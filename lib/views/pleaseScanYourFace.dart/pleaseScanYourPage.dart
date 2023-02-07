// // ignore_for_file: unused_field

// import 'dart:async';

// import 'package:base_project_flutter/constants/constants.dart';
// import 'package:base_project_flutter/constants/imageConstant.dart';
// import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
// import 'package:base_project_flutter/main.dart';
// import 'package:base_project_flutter/responsive.dart';
// import 'package:base_project_flutter/views/successfullPage/successfull.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// class PleaseScanYourFace extends StatefulWidget {
//   const PleaseScanYourFace({Key? key}) : super(key: key);

//   @override
//   State<PleaseScanYourFace> createState() => _PleaseScanYourFaceState();
// }

// class _PleaseScanYourFaceState extends State<PleaseScanYourFace> {
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
//     onNewCameraSelected(cameras[1]);
//     _loadAfterSomeTime();
//     super.initState();
//   }

//   void dispose() {
//     controller?.dispose();
//     super.dispose();
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
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               children: [
//                 Text(
//                   "Please scan your face",
//                   style: TextStyle(
//                       fontFamily: 'signika',
//                       color: tPrimaryColor,
//                       fontSize: isTab(context) ? 18.sp : 21.sp,
//                       fontWeight: FontWeight.w500),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 26,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 25),
//                   child: Text(
//                     "We need to scan your face to verify your identity",
//                     style: TextStyle(
//                         color: tSecondaryColor,
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w400),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   height: 500,
//                   width: 340,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: tBlue,
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child:
//                         isSomeTime ? controller!.buildPreview() : Container(),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Twl.navigateTo(
//                         context,
//                         SuccessfullScreen(
//                           index: 1,
//                         ));
//                   },
//                   child: Image.asset(
//                     'assets/icons/scanbtn.png',
//                     scale: 4,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
