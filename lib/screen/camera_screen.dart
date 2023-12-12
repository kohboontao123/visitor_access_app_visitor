import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;

import '../class/class.dart';
import '../function/face_detector_painter.dart';
import 'register_screen.dart';



class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  CustomPaint? _customPaint;
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  int direction =0;
  bool _isLoading= false;
  bool _isBtnDisable = false;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  void initState(){
    startCamera(0);
    super.initState();
  }
  var image1 = new Regula.MatchFacesImage();
  var image2 = new Regula.MatchFacesImage();
  void startCamera(int direction) async{
    cameras = await availableCameras();

    cameraController = CameraController(
        cameras[direction],
        ResolutionPreset.high,
        enableAudio: false,
    );

    await cameraController.initialize().then((value){
      if(!mounted){
        return;
      }
      setState(() {});
    }).catchError((e){
      print(e);
    });
  }
  @override
  void dispose(){
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   if(cameraController.value.isInitialized){
     return Scaffold(
         backgroundColor:Colors.grey[300],
         appBar:AppBar(
           backgroundColor: Colors.cyan,
           elevation: 0,
           title:  Text(
               'Take ID Cards Photo'),
           actions: [
             Padding(padding: EdgeInsets.only(right: 20.0),
             child: GestureDetector(
               onTap: (){
                 setState(() {
                   direction = direction == 0 ? 0 : 0;
                   startCamera(direction);
                   _isLoading=false;
                   _isBtnDisable=false;
                 });
               },
               child:Icon(
                 Icons.refresh,
                 size: 26.0,
               ),
             ),
             )
           ],
         ),
       body:Stack(
         children:[
          Center(
            child:Stack(
              alignment: Alignment.center,
              children: [
                CameraPreview(cameraController!),
                //would be the Overlay Widget
                OverlayWithRectangleClipping(),
                Positioned(
                  top: 100,
                  width: 500,
                  height: 250,
                  child:  Text(
                    'Front of MyKad' ,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 40,
                        color: Colors.white
                    ),),
                ),
                Positioned(
                  bottom: 10,
                  width: 500,
                  height: 250,
                  child:  Text(
                    'Place Front ID cards photo wthin the \nframe and take a photo' ,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white
                    ),),
                ),
              ],
            )
          ),
           SizedBox(height:60),
          /* GestureDetector(
                onTap: (){
                  setState(() {
                    direction = direction == 0 ? 0 : 0;
                    startCamera(direction);
                    _isLoading=false;
                  });
                },
               child:button(Icons.refresh,Alignment.bottomLeft)
           ),*/
           Positioned(
               bottom: MediaQuery.of(context).size.height* 0.15,
               width: MediaQuery.of(context).size.width,
               height: MediaQuery.of(context).size.height* 0.1,
               child: Align(
                 alignment: Alignment.centerRight,
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     textStyle: TextStyle(fontSize: 20),
                     minimumSize: Size.fromHeight(72),
                     shape: StadiumBorder(),
                      primary:Colors.cyan
                   ),
                   child: _isLoading
                       ? Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       CircularProgressIndicator(color: Colors.white,),
                       SizedBox(width:24),
                       Text('Please wait...')
                     ],
                   )
                       :Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.camera_alt,size:30),
                           SizedBox(width:10),
                           Text('Capture')
                         ],
                   ) ,
                   onPressed:  _isBtnDisable? null:() async {
                     if(_isLoading)return;
                     setState(() {
                       _isLoading=true;
                       cameraController.takePicture().then((XFile? file) async {
                         if(mounted){
                           if(file !=null){
                             String icPath= await _resizeIC("${file.path}");
                             String addressPath=await _resizeICAddress("${file.path}");
                             String namePath=await _resizeICName("${file.path}");
                             processImage(icPath,addressPath,namePath);

                           }
                         }
                       });
                     });

                   },
                 ),
               )
           ),
         ],
       )
     );
   }else{
     return Container();
   }
  }
  Future<void> processImage(String icPath,String addressPath,String namePath) async {
    final faces = await faceDetector.processImage(InputImage.fromFilePath(icPath));
    int qtyFace =0;
    if (InputImage.fromFilePath(icPath).inputImageData?.size != null &&
        InputImage.fromFilePath(icPath).inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          InputImage.fromFilePath(icPath).inputImageData!.size,
          InputImage.fromFilePath(icPath).inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      //String text = 'Faces found: ${faces.length}\n\n';
      qtyFace = int.parse('${faces.length}');
      if (qtyFace == 2 || qtyFace == 1) {
        RecognizedText recognizedText = await textRecognizer.processImage(
            InputImage.fromFilePath(icPath));
        RecognizedText recognizedAddress = await textRecognizer.processImage(
            InputImage.fromFilePath(addressPath));
        RecognizedText recognizedName = await textRecognizer.processImage(
            InputImage.fromFilePath(namePath));
        await textRecognizer.close();
        String address = "";
        String text = "";
        String ic = "";
        String name = "";
        for (TextBlock block in recognizedAddress.blocks) {
          for (TextLine line in block.lines) {
            address = address + line.text + " ";
          }
        }
        for (TextBlock block in recognizedName.blocks) {
          for (TextLine line in block.lines) {
            name = name + line.text + "";
          }
          break;
        }
        for (TextBlock block in recognizedText.blocks) {
          for (TextLine line in block.lines) {
            if (line.text.length == 14 && line.text.contains('-')) {
              ic = line.text;
            }
            text = text + line.text + "\n";
          }
        }

        if (await icDuplicateCheck(ic)){
          Fluttertoast.showToast(
              msg: "This identity card has already been registered to a different visitor");
          setState(()=>_isLoading=false);

        }else {
          if (name != "" && address != "" && ic != ""
              && (qtyFace == 1 || qtyFace == 2) &&
              (text.contains('KADPENGENALAN') ||
                  text.contains('KADPENGENALA') ||
                  text.contains('KADPENGENAL') ||
                  text.contains('KAD') || text.contains('KAD PE') ||
                  text.contains('KAD PEN') || text.contains('KAD PENG') ||
                  text.contains('KAD PENGE') || text.contains('KAD PENGEN') ||
                  text.contains('KAD PENGENA') || text.contains('KAD PENGENAL') ||
                  text.contains('KAD PENGENALA') ||
                  text.contains('KAD PENGENALAN'))) {
            Visitor.name = name;
            Visitor.icNumber = ic;
            Visitor.gender =
            int.parse(ic.replaceAll(RegExp('[^0-9]'), '')) % 2 == 0
                ? 'Female'
                : 'Male';
            Visitor.address = address;
            Visitor.icImage = icPath;
            matchFaces();
          } else {
            Fluttertoast.showToast(
                msg: "Make sure the ID cards is within frame.\n Please try again.");
          }
          setState(()=>_isLoading=false);
        }
        setState(()=>_isLoading=false);
      }else{
        Fluttertoast.showToast(
            msg: "Only Malaysian ID cards are accepted");
      }
      setState(()=>_isLoading=false);
    }

      //Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));
      //Fluttertoast.showToast(msg: name);
    setState(()=>_isLoading=false);

  }
  matchFaces() {
    Fluttertoast.showToast(msg: "Please wait...");
    _isBtnDisable=true;
    var request = new Regula.MatchFacesRequest();
    image1.bitmap = base64Encode((File(Visitor.icImage).readAsBytesSync()));
    image1.imageType=Regula.ImageType.PRINTED;
    image2.bitmap = base64Encode( Visitor.userImage);
    image2.imageType=Regula.ImageType.LIVE;
    request.images = [image1,image2];
    Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
      var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
      Regula.FaceSDK.matchFacesSimilarityThresholdSplit(jsonEncode(response!.results), 0.75).then((str) async {
        var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));

        if(split!.matchedFaces.length > 0  ){

          Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen()));
          _isBtnDisable=false;

        }else{
          Fluttertoast.showToast(msg: "Make sure ID owner and the app user are the same");
          setState(()=>_isLoading=false);
          _isBtnDisable=false;
        }
      });
    });
  }
  void showPreviewDialog(String image) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.grey.withOpacity(0.5),
          child: Center(
            child: SizedBox.fromSize(
              size: const Size.square(900),
              child: Container(
                child: Image.file(File(image)),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<String> _resizeICName(String filePath)  async {
    ImageProperties properties =
    await FlutterNativeImage.getImageProperties(filePath);
    var cropSize = min(properties.width!, properties.height!)~/1;
    int offsetX = (properties.width! - min(properties.width!, properties.height!));
    int offsetY = (properties.height!-110 - min(properties.width!, properties.height!));
    double height=properties.height! /6 -110;
    File croppedFile = await FlutterNativeImage.cropImage(
        filePath, offsetX,  offsetY, cropSize,  height.toInt());
    return croppedFile.path;
  }
  Future<String> _resizeIC(String filePath)  async {
    ImageProperties properties =
    await FlutterNativeImage.getImageProperties(filePath);
    var cropSize = min(properties.width!, properties.height!);
    int offsetX = (properties.width! - min(properties.width!, properties.height!)) ~/ 2;
    int offsetY = (properties.height! - min(properties.width!, properties.height!)) ~/ 2;
    double height=properties.height! * 0.3;
    File croppedFile = await FlutterNativeImage.cropImage(
        filePath, offsetX,  offsetY, cropSize,  height.toInt());
    return croppedFile.path;
  }
  Future<String> _resizeICAddress(String filePath)  async {
    ImageProperties properties =
    await FlutterNativeImage.getImageProperties(filePath);
    var cropSize = min(properties.width!, properties.height!)~/2;
    int offsetX = (properties.width! - min(properties.width!, properties.height!));
    int offsetY = (properties.height! - min(properties.width!, properties.height!));
    double height=properties.height! /8;
    File croppedFile = await FlutterNativeImage.cropImage(
        filePath, offsetX,  offsetY, cropSize,  height.toInt());
    return croppedFile.path;
  }
  Future<String> addressAssign(String icPath) async{
    RecognizedText recognizedText = await textRecognizer.processImage(InputImage.fromFilePath(icPath));
    await textRecognizer.close();
    String text ="";
    for(TextBlock block in recognizedText.blocks){
      for(TextLine line in block.lines){
        text = text + line.text+" " ;
      }
    }

    return text;
  }
  Widget button(IconData icon , Alignment alignment ){
    return  Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          bottom:20,
        ),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color:Colors.white,
          boxShadow: [
            BoxShadow(
              color:Colors.black26,
              offset: Offset(2,2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Icon(
              icon,size: 30,
          ),
        ),
      ),

    );
  }
  Future<bool> icDuplicateCheck(String ic ) async {
    var collection = FirebaseFirestore.instance.collection('visitor');
    var querySnapshot = await collection.get();

    if (ic.length == 14){
      for(var queryDocumentSnapshot in querySnapshot.docs){
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        if (data['icNumber']==ic){

          return true;
        }
      }
    }else{
      return false;
    }

    return false;

  }
}
class OverlayWithRectangleClipping extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: _getCustomPaintOverlay(context));
  }

  //CustomPainter that helps us in doing this
  CustomPaint _getCustomPaintOverlay(BuildContext context) {
    return CustomPaint(
        size: MediaQuery.of(context).size, painter: RectanglePainter());
  }

}
class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;

    canvas.drawPath(
        Path.combine(
          PathOperation.difference, //simple difference of following operations
          //bellow draws a rectangle of full screen (parent) size
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),

          //bellow clips out the circular rectangle with center as offset and dimensions you need to set
          Path()
            ..addRRect(RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: Offset(size.width * 0.5, size.height * 0.38),
                    width: size.width * 0.85,
                    height: size.height * 0.3),
                Radius.circular(15)))
            ..close(),
        ),
        paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}