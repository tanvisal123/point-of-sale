// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:point_of_sale/src/widgets/print_receipt_home.dart';

// class PrintHome extends StatelessWidget {
//   final List<Map<String, dynamic>> data = [
//     {"title": "Print 1", "price": 1200, "qty": 10, "total": 12000},
//     {"title": "Print 2", "price": 100, "qty": 10, "total": 1000}
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Print Home"),
//       ),
//       body: ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (c, i) {
//           return ListTile(
//             title: Text(data[i]['title']),
//             subtitle: Text("${data[i]['price']}"),
//             trailing: Text("${data[i]['total']}"),
//           );
//         },
//       ),
//       bottomNavigationBar: TextButton(
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PrintReceiptHome(data),
//           ),
//         ),
//         child: Text("Print"),
//       ),
//     );
//   }
// }
