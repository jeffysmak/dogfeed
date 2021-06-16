// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:provider/provider.dart';
// import 'package:saloon_app/Globals.dart';
// import 'package:saloon_app/controllers/AuthProvider.dart';
// import 'package:saloon_app/helpers/AuthHelper.dart';
// import 'package:saloon_app/models/AppUser.dart';
// import 'package:saloon_app/widgets/ButtonTexts.dart';
//
// class LoginOtpScreen extends StatefulWidget {
//   @override
//   _LoginOtpScreenState createState() => _LoginOtpScreenState();
// }
//
// class _LoginOtpScreenState extends State<LoginOtpScreen> {
//   PhoneAuthenticationProvider authenticationProvider;
//
//   String verificationId;
//   int forceRecesendingToken;
//   Timer _timer;
//   TextEditingController otpFieldController = TextEditingController();
//   ValueNotifier<int> timeoutNotifier = ValueNotifier<int>(60);
//   ValueNotifier<bool> codeAutoRetrievalTimeoutNotifier = ValueNotifier<bool>(false);
//   bool codeSentNotifier = false;
//
//   @override
//   Widget build(BuildContext context) {
//     authenticationProvider = Provider.of<PhoneAuthenticationProvider>(context);
//     if(!codeSentNotifier){
//       codeSentNotifier = true;
//       print('seddddd');
//       PhoneAuthentication.sendVerificationCodeToUser(
//         '+92${authenticationProvider.phoneNumberFieldController.text}',
//         onCodeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//         onCodeSent: codeSent,
//         onVerificationCompleted: verificationCompleted,
//         onVerificationFailed: verificationFailed,
//         resend: false,
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
//         onPressed: () async {
//           if (authenticationProvider.otpFieldController.text.length == 6) {
//             UserCredential result = await PhoneAuthentication.signInWithAuthIdOtp(
//               verificationId,
//               authenticationProvider.otpFieldController.text,
//               (String message) {
//                 showDialog(
//                   context: context,
//                   builder: (ctx) => AlertDialog(
//                     title: Text('Authentication Failed', style: TextStyle(color: Theme.of(context).accentColor)),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(message),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: FlatButton(
//                                 child: Text('TRY AGAIN', style: TextStyle(color: Theme.of(context).accentColor)),
//                                 onPressed: () async {
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//             if (result != null && result.user != null) {
//               authenticationProvider.setFirebaseUser(result.user);
//               // successfuly signedin
//               if (_timer.isActive || timeoutNotifier.value < 1) {
//                 // stop the time
//                 _timer.cancel();
//               }
//               handlePhoneAuthResult(result);
//             }
//             return;
//           }
//           Globals.showSnackBar(context, 'Please verify your phone number', Colors.red);
//         },
//       ),
//       body: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Text(
//                 'Verify your number',
//                 style: Theme.of(context).textTheme.headline4,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Enter the code sent to 0${authenticationProvider.phoneNumberFieldController.text}',
//                 style: Theme.of(context).textTheme.subtitle1,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: PinCodeTextField(
//                 length: 6,
//                 appContext: context,
//                 animationType: AnimationType.scale,
//                 pinTheme: PinTheme(
//                   shape: PinCodeFieldShape.box,
//                   activeFillColor: Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   activeColor: Theme.of(context).accentColor,
//                   inactiveColor: Theme.of(context).accentColor,
//                   inactiveFillColor: Colors.grey.shade50,
//                   selectedFillColor: Colors.grey.shade50,
//                   selectedColor: Theme.of(context).accentColor,
//                 ),
//                 animationDuration: Duration(milliseconds: 300),
//                 enableActiveFill: true,
//                 backgroundColor: Colors.transparent,
//                 keyboardType: TextInputType.number,
//                 onCompleted: (v) {},
//                 controller: authenticationProvider.otpFieldController,
//                 onChanged: (value) {},
//                 beforeTextPaste: (text) {
//                   return false;
//                 },
//               ),
//             ),
//             ValueListenableBuilder(
//               valueListenable: timeoutNotifier,
//               builder: (_, int timeLeft, __) {
//                 return Text(
//                   '$timeLeft Sec',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: MediaQuery.of(context).size.height * 0.015,
//                   ),
//                 );
//               },
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//               child: ValueListenableBuilder<bool>(
//                 builder: (_, bool timedOut, __) {
//                   return FlatButtonWithIcon(
//                     timedOut
//                         ? () {
//                             PhoneAuthentication.sendVerificationCodeToUser(
//                               '+92${authenticationProvider.phoneNumberFieldController.text}',
//                               onCodeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//                               onCodeSent: codeSent,
//                               onVerificationCompleted: verificationCompleted,
//                               onVerificationFailed: verificationFailed,
//                               resend: true,
//                               resendingToken: forceRecesendingToken,
//                             );
//                           }
//                         : null,
//                     'Resend',
//                     Icons.refresh,
//                   );
//                 },
//                 valueListenable: codeAutoRetrievalTimeoutNotifier,
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // phone auth callbacks
//   PhoneCodeSent codeSent;
//   PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout;
//   PhoneVerificationFailed verificationFailed;
//   PhoneVerificationCompleted verificationCompleted;
//
//   void handlePhoneAuthResult(UserCredential result) async {
//     Navigator.pushReplacementNamed(context, '/profileRegistration');
//     return;
//   }
//
//   void startTimer() {
//     const onesecond = const Duration(seconds: 1);
//     timeoutNotifier.value = 60;
//     codeAutoRetrievalTimeoutNotifier.value = false;
//     _timer = new Timer.periodic(
//       onesecond,
//       (Timer timer) {
//         if (timeoutNotifier.value < 1) {
//           timer.cancel();
//           codeAutoRetrievalTimeoutNotifier.value = true;
//         } else {
//           timeoutNotifier.value = timeoutNotifier.value - 1;
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     if (_timer != null && _timer.isActive) {
//       _timer.cancel();
//     }
//     if (_timer != null) {
//       _timer = null;
//     }
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     codeSent = (String vid, [int forceResendingToken]) async {
//       verificationId = vid;
//       forceRecesendingToken = forceResendingToken;
//       startTimer();
//     };
//     codeAutoRetrievalTimeout = (String vid) {
//       verificationId = vid;
//     };
//     verificationFailed = (FirebaseAuthException authException) {
//       showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           title: Text('Authentication Failed', style: TextStyle(color: Theme.of(context).accentColor)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(authException.message),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: FlatButton(
//                       child: Text('TRY AGAIN', style: TextStyle(color: Theme.of(context).accentColor)),
//                       onPressed: () async {
//                         Navigator.pop(context);
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: FlatButton(
//                       child: Text('CANCEL', style: TextStyle(color: Theme.of(context).accentColor)),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       );
//     };
//     verificationCompleted = (AuthCredential auth) async {
//       UserCredential result = await PhoneAuthentication.signInWithAuthCredentials(auth);
//       if (result != null && result.user != null) {
//         authenticationProvider.setFirebaseUser(result.user);
//         // successfuly signedin
//         if (_timer != null && _timer.isActive || timeoutNotifier.value < 1) {
//           // stop the time
//           _timer.cancel();
//         }
//         handlePhoneAuthResult(result);
//       }
//     };
//   }
// }
