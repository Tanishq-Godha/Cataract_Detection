import 'dart:convert';
import 'dart:io';
import 'package:cataract_detector1/Camera/current_result.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
// import 'result_screen.dart'; 
// import 'result_history_screen.dart';
import 'result.dart';
import 'package:http/http.dart' as http;
class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? cameraController;
  File? _rightEyeImage;
  File? _leftEyeImage;
  String? _righteyeresult;
  String? _lefteyeresult;
  bool isRightEyeScanned = false;
  bool isLeftEyeScanned = false;
  bool isLoading = false;
  final List<Result> results = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      print('No cameras available');
      return;
    }
    final firstCamera = cameras.first;
    cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await cameraController!.initialize();
    setState(() {});
  }

  void _disposeCamera() {
    cameraController?.dispose();
    cameraController = null;
  }

  void _takePicture(ImageSource source, String eye) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }
    final croppedImage = await _cropImage(File(pickedImage.path));
    if (croppedImage != null) {
      setState(() {
        if (eye == 'right') {
          _rightEyeImage = croppedImage;
          isRightEyeScanned = true;
        } else if (eye == 'left') {
          _leftEyeImage = croppedImage;
          isLeftEyeScanned = true;
        }
      });
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Zoom the Photo and Place Your Eye Inside the Grid',
          toolbarColor: Colors.blue[400],
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Zoom the Photo and Place Your Eye Inside the Grid',
          minimumAspectRatio: 1.0,
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  void _showBottomSheet(String eye) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Upload from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePicture(ImageSource.gallery, eye);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take Picture through Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePicture(ImageSource.camera, eye);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircularImage(File? imageFile) {
    if (imageFile == null) {
      return CircleAvatar(
        radius: 75,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.image,
          size: 50,
          color: Colors.grey[600],
        ),
      );
    } else {
      return ClipOval(
        child: Image.file(
          imageFile,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    }
  }

void _navigateToResultPage() async {
  if (_rightEyeImage != null && _leftEyeImage != null) {
    setState(() {
        isLoading = true; // Show loading screen
      });
    try {
      // Prepare the request for the right eye image
      var rightEyeRequest = http.MultipartRequest('POST', Uri.parse('https://cataract-detection-api-8b89318d0d10.herokuapp.com/predict'))
        ..files.add(await http.MultipartFile.fromPath('file', _rightEyeImage!.path, filename: 'right_eye_image.jpg'));

      // Send the request for the right eye image
      var rightEyeResponse = await rightEyeRequest.send();

      // Prepare the request for the left eye image
      var leftEyeRequest = http.MultipartRequest('POST', Uri.parse('https://cataract-detection-api-8b89318d0d10.herokuapp.com/predict'))
        ..files.add(await http.MultipartFile.fromPath('file', _leftEyeImage!.path, filename: 'left_eye_image.jpg'));

      // Send the request for the left eye image
      var leftEyeResponse = await leftEyeRequest.send();

      // Check if both requests were successful
      if (rightEyeResponse.statusCode == 200 && leftEyeResponse.statusCode == 200) {
        // Decode the response for the right eye image
        var rightEyeJsonResponse = await rightEyeResponse.stream.bytesToString();
        var rightEyeResult = rightEyeJsonResponse;

        // Decode the response for the left eye image
        var leftEyeJsonResponse = await leftEyeResponse.stream.bytesToString();
        var leftEyeResult = leftEyeJsonResponse;

        // Update the results
        setState(() {
          _righteyeresult = "NORMAL";
          _lefteyeresult = "NORMAL";
          // _lefteyeresult = "NORMAL";
        });

        // Navigate to the result screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              rightEyeImage: _rightEyeImage!,
              leftEyeImage: _leftEyeImage!,
              righteyeresult: _righteyeresult!,
              lefteyeresult: _lefteyeresult!,
              results: results,
            ),
          ),
        );
      } else {
        print('Failed to load response.');
        var rightEyeResponseBody = await rightEyeResponse.stream.bytesToString();
        var leftEyeResponseBody = await leftEyeResponse.stream.bytesToString();
        print('Right Eye Response body: $rightEyeResponseBody');
        print('Left Eye Response body: $leftEyeResponseBody');
      }
    } catch (e) {
      print('Error: $e');
    }
  } else {
    print('Both images must be selected before navigating.');
  }
}





  @override
  void dispose() {
    super.dispose();
    _disposeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'FETCHING RESULTS FROM SERVER',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'YOUR PATIENCE IS HIGHLY OBLIGED',
                    ),
                  ],
                ),
              )
            : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularImage(_rightEyeImage),
                _buildCircularImage(_leftEyeImage),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showBottomSheet('right');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  child: Text('SCAN RIGHT EYE'),
                ),
                ElevatedButton(
                  onPressed: isRightEyeScanned
                      ? () {
                          _showBottomSheet('left');
                        }
                      : null,
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  child: Text('SCAN LEFT EYE'),
                  
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRightEyeScanned && isLeftEyeScanned
                  ? () async {
                      bool? confirmed = await _confirmImagesDialog();
                      if (confirmed == true) {
                        _navigateToResultPage();
                      }
                    }
                  : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
              child: Text('NEXT'),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ResultHistoryScreen(results: results),
            //       ),
            //     );
            //   },
            //   child: Text('VIEW RESULT HISTORY'),
            // ),
          ],
        ),
      ),
    )
    );
    
  }

  Future<bool?> _confirmImagesDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Images'),
          content: Text('Are you sure you want to proceed with these images?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Retake'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
