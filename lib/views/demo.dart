



// import 'package:flutter/material.dart';


// class OtpScreen extends StatefulWidget {
//   const OtpScreen({Key? key}) : super(key: key);

//   @override
//   _OtpScreenState createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   // 4 text editing controllers that associate with the 4 input fields
//   final TextEditingController _fieldOne = TextEditingController();
//   final TextEditingController _fieldTwo = TextEditingController();
//   final TextEditingController _fieldThree = TextEditingController();
//   final TextEditingController _fieldFour = TextEditingController();

//   // This is the entered code
//   // It will be displayed in a Text widget
//   String? _otp;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
     
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text('Phone Number Verification'),
//           const SizedBox(
//             height: 30,
//           ),
//           // Implement 4 input fields
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               OtpInput(_fieldOne, true),
//               OtpInput(_fieldTwo, true),
//               OtpInput(_fieldThree, true),
//               OtpInput(_fieldFour, true)
//             ],
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _otp = _fieldOne.text +
//                       _fieldTwo.text +
//                       _fieldThree.text +
//                       _fieldFour.text;
//                 });
//               },
//               child: const Text('Submit')),
//           const SizedBox(
//             height: 30,
//           ),
//           // Display the entered OTP code
//           Text(
//             _otp ?? 'Please enter OTP',
//             style: const TextStyle(fontSize: 30),
//           )
//         ],
//       ),
//     );
//   }
// }

// // Create an input widget that takes only one digit
// class OtpInput extends StatelessWidget {
//   final TextEditingController controller;
//   final bool autoFocus;
//   const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60,
//       width: 50,
//       child: TextField(
//         autofocus: autoFocus,
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         controller: controller,
//         maxLength: 1,
//         cursorColor: Theme.of(context).primaryColor,
//         decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             counterText: '',
//             hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
//         onChanged: (value) {
//           if (value.length == 1) {
//             FocusScope.of(context).nextFocus();
//           }
//         },
//       ),
//     );
//   }
// }



// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// import '../main.dart';

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver{
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
//     super.initState();
//   }

//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }

// import 'package:base_project_flutter/constants/constants.dart';
// import 'package:base_project_flutter/constants/imageConstant.dart';
// import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
// import 'package:document_scanner_flutter/document_scanner_flutter.dart';
// import 'package:document_scanner_flutter/configs/configs.dart';
// import 'package:flutter/material.dart';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

// class DocScanPage extends StatefulWidget {
//   @override
//   _DocScanPageState createState() => _DocScanPageState();
// }

// class _DocScanPageState extends State<DocScanPage> {
//   PDFDocument? _scannedDocument;
//   File? _scannedDocumentFile;
//   File? _scannedImage;

//   // openPdfScanner(BuildContext context) async {
//   //   var doc = await DocumentScannerFlutter.launchForPdf(
//   //     context,

//   //     //source: ScannerFileSource.CAMERA
//   //   );
//   //   if (doc != null) {
//   //     _scannedDocument = null;
//   //     setState(() {});
//   //     await Future.delayed(Duration(milliseconds: 100));
//   //     _scannedDocumentFile = doc;
//   //     _scannedDocument = await PDFDocument.fromFile(doc);
//   //     setState(() {});
//   //   }
//   // }

//   openImageScanner(BuildContext context) async {
//     var image = await DocumentScannerFlutter.launch(
//       context,
//       //source: ScannerFileSource.CAMERA,
//     );
//     if (image != null) {
//       _scannedImage = image;
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: tWhite,
//         appBar: AppBar(
//           backgroundColor: tWhite,
//           elevation: 0,
//           leading: GestureDetector(
//             onTap: () {
//               Twl.navigateBack(context);
//             },
//             child: Image.asset(
//               Images.NAVBACK,
//               scale: 5,
//             ),
//           ),
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (_scannedDocument != null || _scannedImage != null) ...[
//               if (_scannedImage != null)
//                 // Image.file(_scannedImage!,
//                 //     width: 300, height: 300, fit: BoxFit.contain),
//                 if (_scannedDocument != null)
//                   Expanded(
//                       child: PDFViewer(
//                     document: _scannedDocument!,
//                   )),
//               // Padding(
//               //   padding: const EdgeInsets.all(8.0),
//               //   child: Text(
//               //       _scannedDocumentFile?.path ?? _scannedImage?.path ?? ''),
//               // ),
//             ],
//             Center(
//               child: Builder(builder: (context) {
//                 return ElevatedButton(
//                     style: ButtonStyle(
//                         // backgroundColor: ,
//                         ),
//                     onPressed: () => openImageScanner(context),
//                     child: Image.asset(
//                       "assets/icons/scanbtn.png",
//                       scale: 3,
//                     ));
//               }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:io';

// import 'package:base_project_flutter/constants/constants.dart';
// import 'package:base_project_flutter/constants/imageConstant.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:sizer/sizer.dart';

// import '../../../globalFuctions/globalFunctions.dart';
// import '../../../responsive.dart';
// // import 'package:stylistproject001/MyAppointments.dart';

// class Editprofile extends StatefulWidget {
//   Editprofile({Key? key}) : super(key: key);

//   @override
//   State<Editprofile> createState() => _EditprofileState();
// }

// class _EditprofileState extends State<Editprofile> {
//   final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];
//   List<Widget> uploadImage = [
//     // Image.asset(Images.EDITPROFILEIMG, height: 18.h, width: 32.w),
//     // Image.asset(
//     //   Images.CARDIMAGE,
//     //   height: 18.h,
//     //   width: 32.w,
//     // ),
//     // Image.asset(Images.CIRCLEIMG, height: 18.h, width: 32.w),
//     // Image.asset(Images.EDITPROFILEIMG, height: 18.h, width: 32.w),
//     // Image.asset(Images.CARDIMAGE, height: 18.h, width: 32.w),
//   ];

//   bool isLoading = true;
//   var profileImage;
//   Future getImage(String type) async {
//     var pickedFile;
//     final picker = ImagePicker();
//     if (type == 'camera') {
//       pickedFile = await picker.getImage(
//           source: ImageSource.camera,
//           maxHeight: 480,
//           maxWidth: 640,
//           imageQuality: 50);
//     } else if (type == 'gallery') {
//       pickedFile = await picker.getImage(
//           source: ImageSource.gallery,
//           maxHeight: 480,
//           maxWidth: 640,
//           imageQuality: 50);
//     }
//     if (pickedFile != null) {
//       print('isLoading start');
//       isLoading = false;
//       File _file = File(pickedFile.path);
//       print(_file.lengthSync());
//       // ignore: non_constant_identifier_names
//       String ImageName = pickedFile.path;
//       print("13" + ImageName);

//       // ignore: unused_local_variable
//       String url;
//       // Upload file
//       FirebaseStorage storage = FirebaseStorage.instance;
//       Reference ref =
//           storage.ref().child("$ImageName" + DateTime.now().toString());
//       print(ref);

//       UploadTask uploadTask = ref.putFile(_file);
//       print(uploadTask);

//       uploadTask.then((res) async {
//         isLoading = false;
//         url = await res.ref.getDownloadURL();

//         print(url);
//         setState(() {
//           profileImage = profileImage;
//           profileImage = url;
//           print('profileImage');
//           print(profileImage);
//         });
//         isLoading = true;
//         print('loading ended');
//       });
//       isLoading = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: tWhite,
//       appBar: AppBar(
//         elevation: 1,
//         backgroundColor: tWhite,
//         leading: GestureDetector(
//           onTap: () {
//             Twl.navigateBack(context);
//           },
//           // child: Image.asset(
//           //   Images.BACK,
//           //   scale: 3.5,
//           // ),
//         ),
//         centerTitle: true,
//         title: Text(
//           "Edit Profile",
//           style: TextStyle(
//               color: tBlack, fontSize: 16.sp, fontWeight: FontWeight.w400),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
//                 height: 150,
//                 child: ListView.builder(
//                     padding: EdgeInsets.symmetric(vertical: 5),
//                     shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     itemCount: uploadImage.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         height: 13.h,
//                         width: 28.w,
//                         child: Stack(
//                           children: [
//                             ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Text("")
//                                 // Image.asset(Images.EDITPROFILEIMG, fit: BoxFit.fill),
//                                 ),
//                             Align(
//                               alignment: Alignment.bottomRight,
//                               child: GestureDetector(),
//                             ),
//                             Positioned(
//                                 bottom: 0,
//                                 right: 4,
//                                 child: GestureDetector(
//                                     onTap: () {
//                                       showBarModalBottomSheet(
//                                           context: context,
//                                           backgroundColor: Colors.transparent,
//                                           builder: (context) => Container(
//                                               height: isMobile(context)
//                                                   ? 150
//                                                   : 40.w,
//                                               child: Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 60,
//                                                     top: 30,
//                                                     right: 60),
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             //Twl.getImage('gallery');
//                                                             getImage('camera');
//                                                             Navigator.pop(
//                                                                 context);
//                                                           },
//                                                           child: Column(
//                                                             children: [
//                                                               Image.asset(
//                                                                 "assets/images/Camera.png",
//                                                                 scale: isTab(
//                                                                         context)
//                                                                     ? 3
//                                                                     : 5,
//                                                               ),
//                                                               SizedBox(
//                                                                 height:
//                                                                     tDefaultPadding,
//                                                               ),
//                                                               Text("Camera")
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             getImage('gallery');
//                                                             Navigator.pop(
//                                                                 context);
//                                                           },
//                                                           child: Column(
//                                                             children: [
//                                                               Image.asset(
//                                                                 "assets/images/imageUpload.png",
//                                                                 scale: isTab(
//                                                                         context)
//                                                                     ? 3
//                                                                     : 5,
//                                                               ),
//                                                               SizedBox(
//                                                                 height:
//                                                                     tDefaultPadding,
//                                                               ),
//                                                               Text("Gallery")
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               )));
//                                     },
//                                     child: Icon(
//                                       Icons.delete,
//                                       color: tWhite,
//                                     )))
//                           ],
//                         ),
//                       );
//                     }),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [tBoxShadow],
//                         color: tWhite),
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             TextField(
//                               keyboardType: TextInputType.text,
//                               decoration: InputDecoration(
//                                 // label: Text("Salon name"),
//                                 labelText: 'Salon name',
//                                 labelStyle:
//                                     TextStyle(color: tGray, fontSize: 12.sp),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: tBlack),
//                                 ),
//                                 hintText: "The Stylizz Salon",
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(0, 10, 0, 5),
//                                 // labelText: "Salon name",
//                                 // labelStyle: TextStyle(
//                                 //   color: Colors.grey[600],
//                                 //   fontSize: 17,
//                                 // )
//                               ),
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             // Text(
//                             //   'Mail ID',
//                             //   style: TextStyle(color: tGray),
//                             //   textAlign: TextAlign.start,
//                             // ),
//                             TextField(
//                               keyboardType: TextInputType.emailAddress,
//                               decoration: InputDecoration(
//                                 labelText: 'Mail ID',
//                                 labelStyle:
//                                     TextStyle(color: tGray, fontSize: 12.sp),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: tBlack),
//                                 ),
//                                 hintText: "avinash@gmail.com",
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(0, 10, 0, 5),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             // Text(
//                             //   'Mobile no',
//                             //   style: TextStyle(color: tGray),
//                             //   textAlign: TextAlign.start,
//                             // ),
//                             TextField(
//                               // maxLength: 12,
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 labelText: 'Mobile no.',
//                                 labelStyle:
//                                     TextStyle(color: tGray, fontSize: 12.sp),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: tBlack),
//                                 ),
//                                 hintText: "+91 9010709777",
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(0, 10, 0, 5),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             // Text(
//                             //   'About us',
//                             //   style: TextStyle(color: tGray),
//                             //   textAlign: TextAlign.start,
//                             // ),
//                             TextField(
//                               maxLines: 3,
//                               decoration: InputDecoration(
//                                 labelStyle:
//                                     TextStyle(color: tGray, fontSize: 12.sp),
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(0, 10, 0, 5),
//                                 labelText: 'About us',
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: tBlack),
//                                 ),
//                                 hintText:
//                                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit,do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
//                                 hintStyle: TextStyle(fontSize: 14),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             // Text(
//                             //   'Location',
//                             //   style: TextStyle(color: tGray),
//                             //   textAlign: TextAlign.start,
//                             // ),
//                             TextField(
//                               decoration: InputDecoration(
//                                 labelText: 'Location',
//                                 labelStyle:
//                                     TextStyle(color: tGray, fontSize: 12.sp),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black),
//                                 ),
//                                 contentPadding:
//                                     EdgeInsets.fromLTRB(0, 20, 0, 0),
//                                 hintText: "Spline arcade, madhapur ",
//                                 // suffixIcon: Image.asset(
//                                 //   Images.LOCATIONICON,
//                                 //   scale: 2.9,
//                                 // )
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 100,
//               ),
//               GestureDetector(
//                 //  onTap: (){
//                 //       Navigator.push(
//                 //         context,
//                 //         MaterialPageRoute(
//                 //             builder: (context) => MyAppointments()\
//                 //             ),
//                 //       );},
//                 child: Container(
//                   width: 345,
//                   height: 48,
//                   decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(6)),
//                   child: Center(
//                     child: Text(
//                       "Update",
//                       style: TextStyle(
//                         color: tWhite,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
