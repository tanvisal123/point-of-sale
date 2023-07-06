// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/bloc_order.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/event_order.dart';
// import 'package:point_of_sale/src/controllers/sale_controller.dart';
// import 'package:point_of_sale/src/helpers/app_localization.dart';
// import 'package:point_of_sale/src/helpers/show_message.dart';
// import 'package:point_of_sale/src/models/order_modal.dart';
// import 'detail_sale_group_screen.dart';

// class DiscountOrderScreen extends StatelessWidget {
//   DiscountOrderScreen({
//     Key key,
//     @required this.orders,
//     @required this.ip,
//   }) : super(key: key);

//   final List<OrderModel> orders;
//   final String ip;

//   final _controllerTotalAmont = TextEditingController();
//   final _controllerDisValue = TextEditingController();
//   final _controllerDisRate = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     var _translate = AppLocalization.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Discount Order'),
//       ),
//       body: Container(
//         height: 350,
//         width: 300,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Column(
//           children: [
//             Container(
//               alignment: Alignment.center,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.grey.withOpacity(0.3),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(5),
//                   topRight: Radius.circular(5),
//                 ),
//               ),
//               child: Text(
//                 AppLocalization.of(context).getTranValue('dis_order'),
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Container(
//                 alignment: Alignment.center,
//                 height: 230,
//                 child: Column(
//                   children: [
//                     BlocBuilder<BlocOrder, StateOrder>(
//                         builder: (context, state) {
//                       _controllerTotalAmont.text =
//                           state.subTotal.toStringAsFixed(2);
//                       _controllerDisValue.text =
//                           (state.disOrder).toStringAsFixed(2);

//                       return Column(
//                         children:
//                             orders.where((x) => x.grandTotal >= 0).map((e) {
//                           _controllerDisRate.text =
//                               e.discountRate.toStringAsFixed(2);
//                           return Column(
//                             children: [
//                               TextFormField(
//                                 controller: _controllerTotalAmont,
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   hintStyle: TextStyle(color: Colors.black),
//                                   labelText:
//                                       '${AppLocalization.of(context).getTranValue('total_amount')} (${state.currency})',
//                                 ),
//                               ),
//                               TextFormField(
//                                 controller: _controllerDisValue,
//                                 onChanged: (value) {
//                                   if (value == '') {
//                                     _controllerDisRate.text = '0.00';
//                                   } else {
//                                     e.discountValue = double.parse(value);
//                                     _controllerDisRate.text =
//                                         (double.parse(value) *
//                                                 100 /
//                                                 state.subTotal)
//                                             .toStringAsFixed(2);
//                                     e.discountRate = double.parse(value) *
//                                         100 /
//                                         state.subTotal;
//                                     _controllerTotalAmont.text =
//                                         (state.subTotal - double.parse(value))
//                                             .toStringAsFixed(2);
//                                     e.grandTotal =
//                                         state.subTotal - double.parse(value);
//                                   }
//                                 },
//                                 keyboardType: TextInputType.number,
//                                 decoration: InputDecoration(
//                                   suffixIcon: IconButton(
//                                     onPressed: () {
//                                       _controllerDisValue.clear();
//                                       _controllerDisRate.text = '0.00';
//                                     },
//                                     icon: Icon(Icons.close),
//                                   ),
//                                   labelText:
//                                       '${AppLocalization.of(context).getTranValue('discount')} (${state.currency})',
//                                 ),
//                               ),
//                               TextFormField(
//                                 inputFormatters: [
//                                   FilteringTextInputFormatter.allow(
//                                     RegExp('^([1-9][0-9]?|100)\$'),
//                                   ),
//                                   LengthLimitingTextInputFormatter(3),
//                                 ],
//                                 controller: _controllerDisRate,
//                                 onChanged: (value) {
//                                   if (value == '') {
//                                     _controllerDisValue.text = '0.00';
//                                   } else {
//                                     e.discountRate = double.parse(value);
//                                     _controllerDisValue.text =
//                                         ((state.subTotal *
//                                                     double.parse(value)) /
//                                                 100)
//                                             .toStringAsFixed(2);
//                                     e.discountValue = ((state.subTotal *
//                                             double.parse(value)) /
//                                         100);
//                                     _controllerTotalAmont.text =
//                                         (state.subTotal -
//                                                 double.parse(
//                                                     (_controllerDisValue.text)))
//                                             .toStringAsFixed(2);
//                                     e.grandTotal = state.subTotal -
//                                         double.parse(
//                                             (_controllerDisValue.text));
//                                   }
//                                 },
//                                 keyboardType: TextInputType.number,
//                                 decoration: InputDecoration(
//                                   suffixIcon: IconButton(
//                                     onPressed: () {
//                                       _controllerDisRate.clear();
//                                       _controllerDisValue.text = '0.00';
//                                     },
//                                     icon: Icon(Icons.close),
//                                   ),
//                                   labelText:
//                                       '${AppLocalization.of(context).getTranValue('discount')} (%)',
//                                 ),
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey.withOpacity(0.3),
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(5),
//                       ),
//                     ),
//                     height: 60,
//                     child: TextButton(
//                       onPressed: () async {
//                         ShowMessage.showLoading(
//                           context,
//                           AppLocalization.of(context).getTranValue('loading'),
//                         );
//                         await Future.delayed(Duration(seconds: 1));
//                         orders.forEach((e) {
//                           SaleController().updateOrder(e);
//                           BlocProvider.of<BlocOrder>(context).add(
//                             EventOrder.add(key: e.orderId),
//                           );
//                         });
//                         Navigator.pop(context);
//                         Navigator.pop(context);
//                         Navigator.pop(context);
//                         Navigator.pop(context);
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (_) => DetailSaleGroup(ip: ip),
//                         //   ),
//                         // );
//                       },
//                       child: Text(
//                         _translate.getTranValue('save'),
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(width: 1.0, height: 50.0),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey.withOpacity(0.3),
//                       borderRadius: BorderRadius.only(
//                         bottomRight: Radius.circular(5.0),
//                       ),
//                     ),
//                     height: 60.0,
//                     child: TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text(
//                         _translate.getTranValue('cancel'),
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
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
