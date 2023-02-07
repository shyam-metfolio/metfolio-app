// // ignore_for_file: unused_field

// import 'dart:async';
// import 'dart:io';

// import 'package:base_project_flutter/constants/constants.dart';
// import 'package:base_project_flutter/constants/imageConstant.dart';
// import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
// import 'package:base_project_flutter/main.dart';
// // import 'package:base_project_flutter/views/successfullPage/successfull.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:path_provider/path_provider.dart';

// class License extends StatefulWidget {
//   const License({Key? key}) : super(key: key);

//   @override
//   State<License> createState() => _LicenseState();
// }

// class _LicenseState extends State<License> {
//   CameraController? controller;
//   bool _isCameraInitialized = false;

//   void onNewCameraSelected(CameraDescription cameraDescription) async {
//     final previousCameraController = controller;
//     // Instantiating the camera controller
//     final CameraController licenceController = CameraController(
//       cameraDescription,
//       ResolutionPreset.high,
//       imageFormatGroup: ImageFormatGroup.jpeg,
//     );

//     // Dispose the previous controller
//     await previousCameraController?.dispose();

//     // Replace with the new controller
//     if (mounted) {
//       setState(() {
//         controller = licenceController;
//       });
//     }

//     // Update UI if controller updated
//     licenceController.addListener(() {
//       if (mounted) setState(() {});
//     });

//     // Initialize controller
//     try {
//       await licenceController.initialize();
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
//   void initState() {
//     onNewCameraSelected(cameras[0]);
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
//       print('fileeeeeeeeeeeeeee');
//       print(file);
//       return file;
//     } on CameraException catch (e) {
//       print('Error occured while taking picture: $e');
//       return null;
//     }
//   }

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
//             scale: 5,
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
//                     "Front of driving \nlicence",
//                     style: TextStyle(
//                         fontFamily: 'signika',
//                         color: tPrimaryColor,
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.w500),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: 26,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25),
//                     child: Text(
//                       "Position all 4 corners of the front clearly in the frame",
//                       style: TextStyle(
//                           color: tSecondaryColor,
//                           fontSize: 14.sp,
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
//                       child:
//                           isSomeTime ? controller!.buildPreview() : Container(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 60,
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       print('object');
//                       XFile? rawImage = await takePicture();
//                       File imageFile = File(rawImage!.path);
//                       print('image is hereeeee');
//                       print(imageFile);
//                       int currentUnix = DateTime.now().millisecondsSinceEpoch;
//                       final directory = await getApplicationDocumentsDirectory();
//                       String fileFormat = imageFile.path.split('.').last;
//                       print('fileFormattttttttttttttttt');
//                       print(fileFormat);
//                       await imageFile.copy(
//                         '${directory.path}/$currentUnix.$fileFormat',
//                       );
//                     },
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/icons/scanbtn.png',
//                           scale: 4,
//                         ),
//                       ],
//                     ),
//                   )
//                   // GestureDetector(
//                   //   onTap: () {
//                   //     Twl.navigateTo(context, SuccessfullScreen());
//                   //   },
//                   //   child: Image.asset(
//                   //     'assets/icons/scanbtn.png',
//                   //     scale: 4,
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
