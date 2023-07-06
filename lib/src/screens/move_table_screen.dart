// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_session/flutter_session.dart';

// import 'package:point_of_sale/src/controllers/table_group_controller.dart';
// import 'package:point_of_sale/src/models/table_modal.dart';

// import 'package:point_of_sale/src/screens/table_group_screen.dart';

// // ignore: must_be_immutable
// class MoveTable extends StatefulWidget {
//   TableModel table;
//   final String ip;
//   MoveTable({this.table, @required this.ip});
//   @override
//   _MoveTableState createState() => _MoveTableState();
// }

// class _MoveTableState extends State<MoveTable> {
//   List<TableModel> lsTable = [];
//   var _ip;

//   @override
//   void initState() {
//     super.initState();

//     TableController.getTableMove(widget.ip).then((value) {
//       if (value.length > 0) {
//         if (mounted) {
//           setState(() {
//             lsTable = value;
//           });
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "${widget.table.name}",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//             ),
//             SizedBox(width: 10),
//             Icon(Icons.arrow_right_alt_outlined, size: 27)
//           ],
//         ),
//         actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 5),
//         child: ListView(
//           children: lsTable.map((e) {
//             return Card(
//               child: ListTile(
//                 title: Text("${e.name}",
//                     style:
//                         TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
//                 subtitle: Text("to table",
//                     style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey)),
//                 leading: e.image != null
//                     ? CachedNetworkImage(
//                         imageUrl: "${_ip + "/Images/table/" + e.image}",
//                         placeholder: (context, url) =>
//                             CircularProgressIndicator(
//                           backgroundColor: Colors.green,
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//                         ),
//                         errorWidget: (context, url, error) => Icon(Icons.error),
//                         fit: BoxFit.cover,
//                       )
//                     : Image.asset("images/no_image.png", fit: BoxFit.cover),
//                 onTap: () {
//                   _showMyDialog(widget.table.tableId, e.tableId);
//                 },
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Future<void> _showMyDialog(int oldId, int newId) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('System Message'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Are you sure you want to move this table?',
//                     style: TextStyle(fontSize: 18, color: Colors.black)),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             MaterialButton(
//               color: Color.fromRGBO(75, 181, 69, 1),
//               shape: StadiumBorder(),
//               padding: EdgeInsets.only(left: 18, right: 18),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.check_box,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                   SizedBox(width: 5),
//                   Text(
//                     'Move',
//                     style: TextStyle(fontSize: 15, color: Colors.white),
//                   ),
//                 ],
//               ),
//               onPressed: () async {
//                 showAlertDialog(context);
//                 await Future.delayed(Duration(seconds: 1));
//                 var move =
//                     await TableController.moveTable(oldId, newId, widget.ip);
//                 if (move == "true") {
//                   dynamic sys = await FlutterSession().get("systemType");
//                   if (sys == "KRMS") {
//                     Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 TableGroupScreen(ip: widget.ip)),
//                         (route) => false);
//                   } else if (sys == "KBMS") {
//                     // Navigator.pushAndRemoveUntil(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (context) => SaleGroupScreen(type: "G1")),
//                     //     (route) => false);
//                   }
//                 }
//               },
//             ),
//             SizedBox(width: 5),
//             MaterialButton(
//               color: Colors.red,
//               shape: StadiumBorder(),
//               padding: EdgeInsets.only(left: 18, right: 18),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.cancel,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                   SizedBox(width: 5),
//                   Text('Cancel',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: Colors.white,
//                       )),
//                 ],
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void showAlertDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => Center(
//         child: Container(
//           width: 110.0,
//           height: 92.0,
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(8)),
//           child: new Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(
//                 backgroundColor: Colors.green,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 8),
//                 child: Text(
//                   "Loading...",
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
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
