// import 'package:flutter/material.dart';
// import 'package:flutter_session/flutter_session.dart';
// import 'package:point_of_sale/src/screens/sale_group_screen.dart';
// import 'package:point_of_sale/src/screens/table_group_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PaymentSuccess extends StatefulWidget {
//   final String status;
//   final String mess;
//   final String ip;
//   PaymentSuccess({this.mess, this.status, @required this.ip});

//   @override
//   _PaymentSuccessState createState() => _PaymentSuccessState();
// }

// class _PaymentSuccessState extends State<PaymentSuccess> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Container(
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 spreadRadius: 5.0,
//                 blurRadius: 5.0,
//                 offset: Offset(0, 3),
//               ),
//             ],
//             borderRadius: BorderRadius.circular(10.0),
//             color: Colors.white,
//           ),
//           width: 300.0,
//           height: 300.0,
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 50.0,
//                 child: Center(
//                   child: Text(
//                     widget.mess,
//                     style: TextStyle(
//                       fontSize: 22.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.0),
//               Container(
//                 height: 110.0,
//                 width: 110.0,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(60),
//                     color: widget.status == 'T'
//                         ? Colors.lightGreen
//                         : Colors.white),
//                 child: widget.status == 'T'
//                     ? Icon(Icons.done, color: Colors.white, size: 90.0)
//                     : Icon(Icons.cancel, color: Colors.red, size: 130.0),
//               ),
//               SizedBox(height: 50.0),
//               Container(
//                 width: 85.0,
//                 height: 45.0,
//                 child: MaterialButton(
//                   color: Colors.lightGreen,
//                   child: widget.status == 'T'
//                       ? Center(
//                           child: Text(
//                             'Done',
//                             style: TextStyle(
//                               fontSize: 17.0,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         )
//                       : Center(
//                           child: Text(
//                             'OK',
//                             style: TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                   onPressed: () async {
//                     var _prefs = await SharedPreferences.getInstance();
//                     var sys = _prefs.getString('systemType');

//                     if (widget.status == 'T') {
//                       if (sys == 'KRMS') {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TableScreen(ip: widget.ip),
//                           ),
//                           (route) => false,
//                         );
//                       } else {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 SaleGroupScreen(type: 'G1', ip: widget.ip),
//                           ),
//                           (route) => false,
//                         );
//                       }
//                     } else {
//                       Navigator.pop(context);
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
