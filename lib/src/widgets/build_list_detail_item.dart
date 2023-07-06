// import 'package:flutter/material.dart';
// import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
// import 'package:point_of_sale/src/screens/detail_sale_screen.dart';

// class BuildListItem extends StatelessWidget {
//   final FetchOrderModel fetchOrder;
//   final double height;
//   final double width;
//   final Function onTap;
//   final Function onLongTab;
//   final List<ShowHide> showlist;
//   final double grandTotal;
//   final double fointSize;
//   const BuildListItem(
//       {Key key,
//       this.fetchOrder,
//       this.height,
//       this.width,
//       this.onTap,
//       this.onLongTab,
//       this.showlist,
//       this.grandTotal,
//       this.fointSize,
//       })
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         ListView(
//           physics: ScrollPhysics(),
//           shrinkWrap: true,
//           children: _buidListWidget(fetchOrder),
//         )
//       ],
//     );
//   }
//    List<Widget> _buidListWidget(FetchOrderModel fetchOrderModel) {
//     var order = fetchOrderModel.order;
//     var data = fetchOrderModel.order.orderDetail;
//     return data.where((element) => element.qty > 0).map((e) {
//       return InkWell(
//         onTap: onTap,
//         onLongPress: onLongTab,
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 5.0),
//               height: height,
//               child: Row(
//                 children: [
//                   Expanded(child: _buildStack(e, order, widget.ip)),
//                   Container(
//                     width: width ?? 50.0,
//                     height: height ?? 50.0,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(3.0),
//                     ),
//                     child: MaterialButton(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(3.0),
//                         ),
//                         padding: EdgeInsets.only(),
//                         color: Colors.white,
//                         onPressed: onTap,
//                         child: Text(e.qty.toStringAsFixed(0))),
//                   ),
//                   Container(
//                     width: width ?? 140.0,
//                     child: Stack(
//                       children: [
//                         Container(
//                           width: double.infinity,
//                           alignment: Alignment.centerRight,
//                           height: height ?? 70.0,
//                           child: Column(
//                             children: [
//                               Text(
//                                 '${grandTotal.toStringAsFixed(2)} ${e.currency}',
//                                 style: TextStyle(
//                                   fontSize: 16.0,
//                                   decoration: e.discountRate != 0
//                                       ? TextDecoration.lineThrough
//                                       : TextDecoration.none,
//                                   color: e.discountRate != 0
//                                       ? Colors.red
//                                       : Colors.black,
//                                 ),
//                                 textAlign: TextAlign.end,
//                               ),
//                               e.discountRate != 0
//                                   ? Text(
//                                       '${grandTotal.toStringAsFixed(2)} ${e.currency}',
//                                       // '${e.currency}  ${e.typeDis == 'Percent' ? ((e.unitPrice * e.qty) - (e.discountRate * e.qty * e.unitPrice) / 100).toStringAsFixed(2) : ((e.unitPrice * e.qty) - (e.discountRate * e.qty)).toStringAsFixed(2)}',
//                                       style: TextStyle(fontSize: 16.0),
//                                       textAlign: TextAlign.end,
//                                     )
//                                   : Padding(
//                                       padding: const EdgeInsets.only(top: 5.0),
//                                       child: Text(''),
//                                     ),
//                             ],
//                             mainAxisAlignment: e.discountValue != 0
//                                 ? MainAxisAlignment.spaceAround
//                                 : MainAxisAlignment.end,
//                           ),
//                         ),
//                         showlist.firstWhere((s) => s.key == e.lineId).show == 1
//                             ? _buildPosition(e)
//                             : Text(''),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(height: 0, color: Colors.grey),
//           ],
//         ),
//       );
//     }).toList();
//   }
// }
