// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/bloc_order.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/event_order.dart';
// import 'package:point_of_sale/src/controllers/sale_controller.dart';
// import 'package:point_of_sale/src/helpers/app_localization.dart';
// import 'package:point_of_sale/src/helpers/show_message.dart';
// import 'package:point_of_sale/src/models/order_detail_modal.dart';
// import 'detail_sale_group_screen.dart';

// class DiscountItemScreen extends StatefulWidget {
//   final String ip;

//   const DiscountItemScreen({Key key, @required this.ip}) : super(key: key);
//   @override
//   _DiscountItemScreenState createState() => _DiscountItemScreenState();
// }

// class _DiscountItemScreenState extends State<DiscountItemScreen> {
//   List<OrderDetail> _orderDetailList = [];
//   bool _loading = false;

//   @override
//   void initState() {
//     super.initState();
//     _getItems();
//   }

//   Future<void> _getItems() async {
//     await SaleController().selectOrderDetail().then((value) {
//       setState(() {
//         if (mounted) _orderDetailList = value;
//       });
//     });
//     _loading = true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var _translat = AppLocalization.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_translat.getTranValue('discount_item')),
//         centerTitle: true,
//       ),
//       body: _loading
//           ? _orderDetailList.length > 0
//               ? ListView(
//                   children: _orderDetailList.where((x) => x.qty > 0).map((e) {
//                   var disRate = e.discountRate;
//                   return InkWell(
//                     onTap: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(builder: (context) => DiscountType()),
//                       // );
//                     },
//                     child: Column(
//                       children: [
//                         ListTile(
//                           title: Text(
//                             "${e.khmerName} ( ${e.uomName})",
//                             style: TextStyle(
//                                 fontSize: 17, fontWeight: FontWeight.w500),
//                           ),
//                           trailing: Container(
//                             width: 100,
//                             child: TextFormField(
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.allow(
//                                   RegExp('^([1-9][0-9]?|100)\$'),
//                                 ),
//                                 LengthLimitingTextInputFormatter(3),
//                               ],
//                               keyboardType: TextInputType.number,
//                               style: TextStyle(fontSize: 19),
//                               initialValue: disRate.toString(),
//                               decoration: InputDecoration(
//                                 suffixIcon: Image.asset(
//                                   'assets/icons/percent.png',
//                                   cacheHeight: 20,
//                                   cacheWidth: 20,
//                                 ),
//                                 contentPadding: EdgeInsets.only(left: 5.0),
//                                 hintText: '0',
//                                 labelStyle: TextStyle(
//                                     fontSize: 17, color: Colors.black),
//                                 border: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: Colors.grey[350]),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5.0),
//                                   borderSide: BorderSide(color: Colors.green),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5.0),
//                                   borderSide: BorderSide(
//                                     color: Colors.grey[400],
//                                     width: 2.0,
//                                   ),
//                                 ),
//                               ),
//                               onChanged: (value) {
//                                 if (value.isNotEmpty) {
//                                   e.discountRate = double.parse(value);
//                                 } else {
//                                   e.discountRate = 0.0;
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                         Divider(height: 0.0, color: Colors.grey),
//                       ],
//                     ),
//                   );
//                 }).toList())
//               : Center(
//                   child: Text(
//                     _translat.getTranValue('no_data'),
//                     style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//                   ),
//                 )
//           : Center(
//               child: CircularProgressIndicator(
//                 backgroundColor: Theme.of(context).primaryColor,
//               ),
//             ),
//       bottomNavigationBar: Container(
//         height: 60.0,
//         child: MaterialButton(
//           color: Theme.of(context).primaryColor,
//           child: Text(
//             _translat.getTranValue('save'),
//             style: TextStyle(
//                 fontSize: 19, color: Colors.white, fontWeight: FontWeight.w500),
//           ),
//           onPressed: () async {
//             ShowMessage.showLoading(context, _translat.getTranValue('loading'));
//             await Future.delayed(Duration(seconds: 2));
//             _orderDetailList.forEach((e) {
//               SaleController().updateOrderDetail(e);
//               BlocProvider.of<BlocOrder>(context)
//                   .add(EventOrder.add(key: e.lineId));
//             });
//             Navigator.pop(context);
//             Navigator.pop(context);
//             Navigator.pop(context);
//             Navigator.pop(context);
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => DetailSaleGroup(ip: widget.ip),
//             //   ),
//             // );
//           },
//         ),
//       ),
//     );
//   }
// }
