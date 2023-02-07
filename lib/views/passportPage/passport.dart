// // ignore_for_file: unused_field

// import 'dart:io';
// import 'dart:async';


// import 'package:base_project_flutter/constants/constants.dart';
// import 'package:base_project_flutter/constants/imageConstant.dart';
// import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';

// import 'package:base_project_flutter/responsive.dart';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// import '../../main.dart';
// import '../pleaseScanYourFace.dart/pleaseScanYourPage.dart';

// class Pasport extends StatefulWidget {
//   const Pasport({Key? key}) : super(key: key);

//   @override
//   State<Pasport> createState() => _PasportState();
// }

// class _PasportState extends State<Pasport> {
//   CameraController? controller;
//   bool _isCameraInitialized = false;

//   void onNewCameraSelected(CameraDescription cameraDescription) async {
//     final previousCameraController = controller;
//     // Instantiating the camera controller
//     final CameraController cameraController = CameraController(
//       cameraDescription,
//       ResolutionPreset.high,
//       imageFormatGroup: ImageFormatGroup.jpeg,
//     );

//     // Dispose the previous controller
//     await previousCameraController?.dispose();

//     // Replace with the new controller
//     if (mounted) {
//       setState(() {
//         controller = cameraController;
//       });
//     }

//     // Update UI if controller updated
//     cameraController.addListener(() {
//       if (mounted) setState(() {});
//     });

//     // Initialize controller
//     try {
//       await cameraController.initialize();
//     } on CameraException catch (e) {
//       print('Error initializing camera: $e');
//     }

//     // Update the Boolean
//     if (mounted) {
//       setState(() {
//         _isCameraInitialized = controller!.value.isInitialized;
//       });
//     }
//   }

//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     final CameraController? cameraController = controller;

//     // App state changed before we got the chance to initialize.
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       return;
//     }

//     if (state == AppLifecycleState.inactive) {
//       // Free up memory when camera not active
//       cameraController.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       // Reinitialize the camera with same properties
//       onNewCameraSelected(cameraController.description);
//     }
//   }

//   @override
//   void initState() {
//     onNewCameraSelected(cameras[0]);

//     // controller = new CameraController(cameras[0], ResolutionPreset.medium);
//     _loadAfterSomeTime();

//     super.initState();
//   }

//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   Future<XFile?> takePicture() async {
//     final CameraController? cameraController = controller;
//     if (cameraController!.value.isTakingPicture) {
//       // A capture is already pending, do nothing.
//       return null;
//     }
//     try {
//       XFile file = await cameraController.takePicture();
//       return file;
//     } on CameraException catch (e) {
//       print('Error occured while taking picture: $e');
//       return null;
//     }
//   }

//   _loadAfterSomeTime() async {
//     Timer(Duration(seconds: 1), () {
//       setState(() {
//         isSomeTime = true;
//       });
//       print("Yeah, this line is printed after 3 seconds");
//     });
//   }

//   bool isSomeTime = false;

//   File? imgPath;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: tWhite,
//       appBar: AppBar(
//         backgroundColor: tWhite,
//         elevation: 0,
//         leading: GestureDetector(
//           onTap: () {
//             Twl.navigateBack(context);
//           },
//           child: Image.asset(
//             Images.NAVBACK,
//             scale: 4,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 17.5),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     "Passport photo page",
//                     style: TextStyle(
//                         color: tPrimaryColor,
//                         fontSize: isTab(context) ? 18.sp : 21.sp,
//                         fontWeight: FontWeight.w600),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: 26,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Text(
//                       "Position all 4 corners of the front clearly in the frame",
//                       style: TextStyle(
//                           color: tSecondaryColor,
//                           fontSize: isTab(context) ? 10.sp : 13.sp,
//                           fontWeight: FontWeight.w400),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 49,
//                   ),
//                   Container(
//                     height: 245,
//                     width: 340,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                         color: tBlue,
//                       ),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Container(
//                         child:
//                             isSomeTime ? controller!.buildPreview() : Container(),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 60,
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       XFile? rawImage = await takePicture();
//                       File imageFile = File(rawImage!.path);
//                       setState(() {
//                         imgPath = imageFile;
//                       });
//                       print(imageFile);
//                       if (imgPath != null) {
//                         Twl.navigateTo(context, PleaseScanYourFace());
//                       } else {
//                         final snackBar = SnackBar(
//                           content: const Text('Please capture Image'),
//                           action: SnackBarAction(
//                             label: 'Undo',
//                             onPressed: () {
//                               // Some code to undo the change.
//                             },
//                           ),
//                         );
      
//                         // Find the ScaffoldMessenger in the widget tree
//                         // and use it to show a SnackBar.
//                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                       }
//                     },
//                     child: Image.asset(
//                       'assets/icons/scanbtn.png',
//                       scale: 4,
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
