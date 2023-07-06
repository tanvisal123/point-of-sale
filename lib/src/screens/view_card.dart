// import 'package:flutter/material.dart';
// import 'package:point_of_sale/src/controllers/fetchorder_controller.dart';
// import 'package:point_of_sale/src/models/fetch_oreder_model.dart';

// class ViewCard extends StatefulWidget {
//   final String ip;
//   const ViewCard({Key key, @required this.ip}) : super(key: key);

//   @override
//   State<ViewCard> createState() => _ViewCardState();
// }

// class _ViewCardState extends State<ViewCard> {
//   FetchOrderModel fetchOrderModel;
//   void getOrderDetail() async {
//     await FetchOrderController().getFetchOrder(widget.ip).then((value) {
//       fetchOrderModel = value;
//       print(fetchOrderModel.order.orderDetail);
//     });
//   }

//   @override
//   void initState() {
//     getOrderDetail();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Card"),
//       ),
//     );
//   }
// }
