// import 'dart:async';
// import 'dart:typed_data';
// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_session/flutter_session.dart';
// import 'package:image/image.dart';

// import 'package:point_of_sale/src/bloc/bloc_order/bloc_order.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/event_order.dart';
// import 'package:point_of_sale/src/controllers/open_shift_controller.dart';
// import 'package:point_of_sale/src/controllers/permission_controller.dart';
// import 'package:point_of_sale/src/controllers/post_order_to_server.dart';
// import 'package:point_of_sale/src/controllers/receipt_contoller.dart';
// import 'package:point_of_sale/src/controllers/receipt_information_controller.dart';
// import 'package:point_of_sale/src/controllers/sale_controller.dart';
// import 'package:point_of_sale/src/controllers/service_table_controller.dart';
// import 'package:point_of_sale/src/controllers/void_order_controller.dart';
// import 'package:point_of_sale/src/helpers/app_localization.dart';
// import 'package:point_of_sale/src/helpers/show_message.dart';
// import 'package:point_of_sale/src/helpers/utility.dart';
// import 'package:point_of_sale/src/models/order_detail_modal.dart';
// import 'package:point_of_sale/src/models/order_modal.dart';
// import 'package:point_of_sale/src/models/receipt_information.dart';
// import 'package:point_of_sale/src/models/table_modal.dart';
// import 'package:point_of_sale/src/models/table_ordered.dart';
// import 'package:point_of_sale/src/printers/build_bill_recipt.dart';
// import 'package:point_of_sale/src/printers/build_order_recipt.dart';
// import 'package:point_of_sale/src/printers/print_bill.dart';
// import 'package:point_of_sale/src/printers/print_order.dart';
// import 'package:point_of_sale/src/screens/payorder_screen.dart';
// import 'package:point_of_sale/src/screens/sale_group_screen.dart';
// import 'package:point_of_sale/src/screens/table_group_screen.dart';
// import 'package:point_of_sale/src/widgets/card_custom.dart';
// import 'package:point_of_sale/src/widgets/widget_to_image.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'cancel_receipt_screen.dart';
// import 'detail_by_item_screen.dart';
// import 'discount_item.dart';
// import 'item_not_enough_stock_screen.dart';
// import 'open_shift_screen.dart';
// import 'package:image/image.dart' as imgx;

// class DetailSaleGroup extends StatefulWidget {
//   final String ip;
//   const DetailSaleGroup({@required this.ip});
//   @override
//   _DetailSaleGroupState createState() => _DetailSaleGroupState();
// }

// class _DetailSaleGroupState extends State<DetailSaleGroup> {
//   List<ShowHied> _showList = [];
//   List<OrderModel> _orderList = [];
//   List<OrderDetail> _detailList = [];
//   List<ReceiptInformation> _receiptInfoLs = [];
//   List<TableModel> _tableList = [];
//   GlobalKey key1;
//   Uint8List _bytes;
//   GlobalKey _key2;
//   Uint8List _bytes1;
//   int _tableId;
//   Timer _timer;
//   double _count = 0.0;
//   bool _status = false;
//   var _systemType, _userName, _userId;

//   SaleController _sale = SaleController();
//   TableOrdered _tableOrdered = TableOrdered();
//   var _controllerTotalAmont = TextEditingController();
//   var _controllerDisValue = TextEditingController();
//   var _controllerDisRate = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     getPrinter();
//     getIp();
//     _getAll();
//     _getSystemType();
//     _bineShowHied();
//     _getTable();
//     _controllerDisValue.text = '0.00';
//     _controllerDisRate.text = '0.00';
//   }

//   _getTable() async {
//     await TableController.getTableMove(widget.ip).then((value) {
//       value.forEach((element) {
//         if (element.id == _tableOrdered.id) {
//           return;
//         } else {
//           _tableList.add(element);
//         }
//       });
//     });
//     _tableId = _tableList.first.id;
//   }

//   _getAll() async {
//     await ReceiptInformationController.eachRI(widget.ip).then((value) {
//       if (mounted) setState(() => _receiptInfoLs.addAll(value));
//     });
//     await _sale.selectOrder().then((value) {
//       if (mounted) setState(() => _orderList = value);
//     });
//     await ReceiptController.getTableOrdered(_orderList.first.tableId, widget.ip)
//         .then((value) {
//       if (mounted) setState(() => _tableOrdered = value);
//     });
//     _getOrderDetail();
//     _status = true;
//   }

//   _getOrderDetail() async {
//     await _sale.selectOrderDetail().then((value) {
//       _detailList.clear();
//       if (mounted) setState(() => _detailList.addAll(value));
//     });
//   }

//   _getSystemType() async {
//     _systemType = await FlutterSession().get('systemType');
//     _userName = await FlutterSession().get('userName');
//     _userId = await FlutterSession().get('userId');
//   }

//   _bineShowHied() async {
//     var detail = await _sale.selectOrderDetail();
//     detail.forEach((e) {
//       ShowHied _sh = ShowHied(show: 0, key: e.lineId);
//       _showList.add(_sh);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var _translat = AppLocalization.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context, 'T'),
//         ),
//         title: Text(_translat.getTranValue('cart')),
//         actions: [
//           PopupMenuButton<Widget>(
//             iconSize: 28.0,
//             tooltip: 'Discout',
//             elevation: 3.0,
//             itemBuilder: (context) {
//               return [
//                 PopupMenuItem(
//                   onTap: () async {
//                     var check =
//                         await PermissionController.permissionDiscountItem(
//                             widget.ip);
//                     if (check == 'true') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               DiscountItemScreen(ip: widget.ip),
//                         ),
//                       );
//                     } else {
//                       _hasNotPermission(
//                         AppLocalization.of(context)
//                             .getTranValue('user_no_permission'),
//                       );
//                     }
//                   },
//                   child: Row(
//                     children: [
//                       // Image.asset('assets/icons/percent.png'),
//                       SizedBox(width: 10.0),
//                       Text(
//                         AppLocalization.of(context)
//                             .getTranValue('discount_item'),
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   height: 15.0,
//                   padding: EdgeInsets.all(0.0),
//                   child: Divider(height: 0.0, color: Colors.grey),
//                 ),
//                 PopupMenuItem(
//                   onTap: () async {
//                     var check =
//                         await PermissionController.permissionDiscountItem(
//                             widget.ip);
//                     if (check == 'true') {
//                       _buildDialogDiscount(context);
//                     } else {
//                       _hasNotPermission(
//                         AppLocalization.of(context)
//                             .getTranValue('user_no_permission'),
//                       );
//                     }
//                   },
//                   child: Row(
//                     children: [
//                       Icon(Icons.local_offer_outlined, color: Colors.black),
//                       SizedBox(width: 10.0),
//                       Text(
//                         AppLocalization.of(context)
//                             .getTranValue('discount_order'),
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   height: 15.0,
//                   padding: EdgeInsets.all(0.0),
//                   child: Divider(height: 0.0, color: Colors.grey),
//                 ),
//                 _systemType == 'KRMS'
//                     ? PopupMenuItem(
//                         onTap: () async {
//                           var check =
//                               await PermissionController.permissionVoidOrder(
//                                   widget.ip);
//                           if (check == 'true') {
//                             _voidOrder();
//                           } else {
//                             _hasNotPermission(
//                               AppLocalization.of(context)
//                                   .getTranValue('user_no_permission'),
//                             );
//                           }
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.delete_forever_outlined,
//                                 color: Colors.black),
//                             SizedBox(width: 10.0),
//                             Text(
//                               AppLocalization.of(context)
//                                   .getTranValue('void_order'),
//                             ),
//                           ],
//                         ),
//                       )
//                     : PopupMenuItem(
//                         onTap: () async {
//                           BlocProvider.of<BlocOrder>(context)
//                               .add(EventOrder.delete());
//                           Navigator.pop(context);
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.delete_forever_outlined,
//                                 color: Colors.black),
//                             SizedBox(width: 10.0),
//                             Text(
//                               AppLocalization.of(context)
//                                       .getTranValue('clear_order') ??
//                                   'Clear order',
//                             ),
//                           ],
//                         ),
//                       ),
//                 _systemType == 'KRMS'
//                     ? PopupMenuItem(
//                         height: 15.0,
//                         padding: EdgeInsets.all(0.0),
//                         child: Divider(height: 0.0, color: Colors.grey),
//                       )
//                     : PopupMenuItem(
//                         height: 0.0,
//                         padding: EdgeInsets.all(0.0),
//                         child: SizedBox(height: 0),
//                       ),
//                 _systemType == 'KRMS'
//                     ? PopupMenuItem(
//                         onTap: () async {
//                           var check =
//                               await PermissionController.permissionMoveTable(
//                                   widget.ip);
//                           if (check == 'true') {
//                             _moveTable();
//                           } else {
//                             _hasNotPermission(
//                               AppLocalization.of(context)
//                                   .getTranValue('user_no_permission'),
//                             );
//                           }
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.cached_outlined, color: Colors.black),
//                             SizedBox(width: 10.0),
//                             Text(
//                               AppLocalization.of(context)
//                                   .getTranValue('move_table'),
//                             ),
//                           ],
//                         ),
//                       )
//                     : PopupMenuItem(
//                         height: 0.0,
//                         padding: EdgeInsets.all(0.0),
//                         child: SizedBox(height: 0),
//                       ),
//                 PopupMenuItem(
//                   height: 15.0,
//                   padding: EdgeInsets.all(0.0),
//                   child: Divider(height: 0.0, color: Colors.grey),
//                 ),
//                 PopupMenuItem(
//                   onTap: () async {
//                     var check =
//                         await PermissionController.permissionCancelOrder(
//                             widget.ip);
//                     if (check == 'true') {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => CancelReceiptScreen()),
//                       );
//                     } else {
//                       _hasNotPermission(
//                         AppLocalization.of(context)
//                             .getTranValue('user_no_permission'),
//                       );
//                     }
//                   },
//                   child: Row(
//                     children: [
//                       Icon(Icons.not_interested_outlined, color: Colors.black),
//                       SizedBox(width: 10.0),
//                       Text(
//                         AppLocalization.of(context)
//                             .getTranValue('cancel_receipt'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ];
//             },
//           ),
//           // IconButton(
//           //   icon: Icon(Icons.more_vert, size: 30),
//           //   onPressed: () => _settingModalBottomSheet(context, widget.ip),
//           // ),
//         ],
//       ),
//       body: _status
//           ? ListView(
//               children: [
//                 ListView(
//                   physics: ScrollPhysics(),
//                   shrinkWrap: true,
//                   children: _buildListWidget(),
//                 ),
//               ],
//             )
//           : Center(child: CircularProgressIndicator()),
//       bottomNavigationBar: _status
//           ? Container(
//               height: 120.0,
//               child: Column(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: Container(
//                       alignment: Alignment.center,
//                       color: Colors.grey[200],
//                       child: BlocBuilder<BlocOrder, StateOrder>(
//                         builder: (context, state) {
//                           _detailList = state.orderDetail;
//                           _count = state.allQty;
//                           return Padding(
//                             padding: const EdgeInsets.all(0.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           AppLocalization.of(context)
//                                               .getTranValue('sub_total'),
//                                           style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           '${state.currency} ${(state.subTotal).toStringAsFixed(2)}',
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           AppLocalization.of(context)
//                                               .getTranValue('total_dis'),
//                                           style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           '${state.currency} ${state.disOrder.toStringAsFixed(2)}',
//                                           style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           AppLocalization.of(context)
//                                               .getTranValue('total_amount'),
//                                           style: TextStyle(
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           '${state.currency} ${state.grandTotal.toStringAsFixed(2)}',
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   _systemType == 'KRMS'
//                       ? Expanded(
//                           flex: 3,
//                           child: Container(
//                             color: Colors.grey[400],
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     height: double.infinity,
//                                     decoration: BoxDecoration(
//                                       color: Colors.blue,
//                                       border: Border.all(
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                     ),
//                                     child: MaterialButton(
//                                       splashColor: Colors.white,
//                                       onPressed: () async {
//                                         await saveOrder1();
//                                         // if (printer == 'sunmi') {
//                                         //   ShowMessage.showLoading(
//                                         //     context,
//                                         //     _translat.getTranValue('loading'),
//                                         //   );
//                                         //   await saveOrder1();
//                                         // } else if (printer == 'network') {
//                                         //   showOrderRecipt();
//                                         // } else {
//                                         //   showDialog(
//                                         //     context: context,
//                                         //     builder: (BuildContext context) =>
//                                         //         AlertDialog(
//                                         //       content: const Text(
//                                         //           "please select printer for print"),
//                                         //       actions: <Widget>[
//                                         //         TextButton(
//                                         //           onPressed: () =>
//                                         //               Navigator.pop(
//                                         //                   context, 'OK'),
//                                         //           child: const Text('OK'),
//                                         //         ),
//                                         //       ],
//                                         //     ),
//                                         //   );
//                                         // }
//                                       },
//                                       child: Text(
//                                         _translat.getTranValue('send'),
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 15.0,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     height: double.infinity,
//                                     decoration: BoxDecoration(
//                                       color: Colors.orange,
//                                       border: Border.all(
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                     ),
//                                     child: BlocBuilder<BlocOrder, StateOrder>(
//                                       builder: (context, state) {
//                                         return MaterialButton(
//                                           splashColor: Colors.white,
//                                           onPressed: () async {
//                                             await _billOrder(
//                                                 state.allQty,
//                                                 state.disOrder,
//                                                 state.subTotal,
//                                                 state.grandTotal,
//                                                 state.currency);
//                                             // if (printer == 'network') {
//                                             //   showBillRecipt(
//                                             //     state.allQty,
//                                             //     state.disOrder,
//                                             //     state.subTotal,
//                                             //     state.grandTotal,
//                                             //     state.currency,
//                                             //   );
//                                             // } else if (printer == 'sunmi') {
//                                             //   await _billOrder(
//                                             //     state.allQty,
//                                             //     state.disOrder,
//                                             //     state.subTotal,
//                                             //     state.grandTotal,
//                                             //     state.currency,
//                                             //   );
//                                             // } else {
//                                             //   print("select printer");
//                                             // }
//                                           },
//                                           child: Text(
//                                             _translat.getTranValue('bill'),
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 16.0,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     height: double.infinity,
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       border: Border.all(
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                     ),
//                                     child: MaterialButton(
//                                       splashColor: Colors.white,
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 PayOrderScreen(ip: widget.ip),
//                                           ),
//                                         );
//                                       },
//                                       child: Text(
//                                         AppLocalization.of(context)
//                                             .getTranValue('pay'),
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 15.0,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       : Expanded(
//                           flex: 3,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   color: Colors.grey[400],
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         child: Container(
//                                           height: double.infinity,
//                                           decoration: BoxDecoration(
//                                             color: Colors.red,
//                                             border: Border.all(
//                                               color: Theme.of(context)
//                                                   .primaryColor,
//                                             ),
//                                           ),
//                                           child: MaterialButton(
//                                             splashColor: Colors.white,
//                                             onPressed: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       PayOrderScreen(
//                                                           ip: widget.ip),
//                                                 ),
//                                               );
//                                             },
//                                             child: Text(
//                                               AppLocalization.of(context)
//                                                   .getTranValue('pay'),
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 15.0,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                 ],
//               ),
//             )
//           : Container(height: 0.0),
//     );
//   }

//   void _settingModalBottomSheet(context, String ip) {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       isDismissible: true,
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.only(top: 50.0),
//           child: Container(
//             color: Colors.white,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   CardCustom(
//                     leading: Icons.local_offer_outlined,
//                     title: AppLocalization.of(context)
//                         .getTranValue('discount_item'),
//                     onPress: () async {
//                       var check =
//                           await PermissionController.permissionDiscountItem(ip);
//                       if (check == 'true') {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => DiscountItemScreen(ip: ip),
//                           ),
//                         );
//                       } else {
//                         _hasNotPermission(
//                           AppLocalization.of(context)
//                               .getTranValue('user_no_permission'),
//                         );
//                       }
//                     },
//                   ),
//                   CardCustom(
//                     leading: Icons.local_offer_outlined,
//                     title: AppLocalization.of(context)
//                         .getTranValue('discount_order'),
//                     onPress: () {
//                       _buildDialogDiscount(context);
//                     },
//                   ),
//                   SizedBox(height: 100.0),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // ---------- save order for ethernet printer -----------------
//   Future<void> _saveOrder() async {
//     bool _connection = await DataConnectionChecker().hasConnection;
//     if (_connection) {
//       //var _selectOpenShift = await CheckOpenShiftController().selectOpenShift();
//       var _checkOpenShift = await OpenShiftController.checkOpenShift(widget.ip);
//       if (_checkOpenShift.length > 0) {
//         var _data = await PostOrder().beforPost(
//             '', widget.ip, _userId, _orderList, _detailList, _systemType);
//         if (_data.status == 'T') {
//           //---------not stock--------
//           if (_data.data.length > 0) {
//             Navigator.pop(context);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     NotEnoughStockScreen(lsItemReturn: _data.data),
//               ),
//             );
//           }
//           // ----------has stork---------
//           else {
//             //-----Print order for printer----
//             printOrderRecipt();
//             //-------------------
//             if (_systemType == 'KRMS') {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TableGroupScreen(ip: widget.ip),
//                 ),
//                 (route) => false,
//               );
//             } else {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       SaleGroupScreen(type: 'G1', ip: widget.ip),
//                 ),
//                 (route) => false,
//               );
//             }

//             if (_systemType == 'KRMS') {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TableGroupScreen(ip: widget.ip),
//                 ),
//                 (route) => false,
//               );
//             } else {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       SaleGroupScreen(type: 'G1', ip: widget.ip),
//                 ),
//                 (route) => false,
//               );
//             }
//           }
//         } else {
//           Navigator.pop(context);
//           _messBackSaveOrder('${_data.status}', _data.status);
//         }
//       } else {
//         await Future.delayed(Duration(seconds: 2));
//         Navigator.pop(context);
//         _notOpenShift(
//           AppLocalization.of(context).getTranValue('open_shift_befor_pay'),
//           widget.ip,
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             AppLocalization.of(context).getTranValue('no_internet'),
//           ),
//         ),
//       );
//     }
//   } // -------- end save order recipt for ethernet printer ---------

// // ---------------save order recipt for sunmi printer --------------
//   Future<void> saveOrder1() async {
//     bool _connection = await DataConnectionChecker().hasConnection;
//     if (_connection) {
//       var _checkOpenShift = await OpenShiftController.checkOpenShift(widget.ip);
//       if (_checkOpenShift.length > 0) {
//         var _data = await PostOrder().beforPost(
//             '', widget.ip, _userId, _orderList, _detailList, _systemType);
//         if (_data.status == 'T') {
//           //   not in stock
//           if (_data.data.length > 0) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     NotEnoughStockScreen(lsItemReturn: _data.data),
//               ),
//             );
//           }
//           //    has stock
//           else {
//             // print sunmi recipt
//             await PrintOrder(
//               receiptNo: _orderList.first.orderNo,
//               cashier: _userName,
//               table: _tableOrdered.name,
//               orderDetailList: _detailList,
//             ).startPrintOrder();
//             if (_systemType == 'KRMS') {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TableGroupScreen(ip: widget.ip),
//                 ),
//                 (route) => false,
//               );
//             } else {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       SaleGroupScreen(type: 'G1', ip: widget.ip),
//                 ),
//                 (route) => false,
//               );
//             }
//           }
//         } else {
//           Navigator.pop(context);
//           _messBackSaveOrder('${_data.status}', _data.status);
//         }
//       } else {
//         await Future.delayed(Duration(seconds: 2));
//         Navigator.pop(context);
//         _notOpenShift(
//           AppLocalization.of(context).getTranValue('open_shift_befor_pay'),
//           widget.ip,
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             AppLocalization.of(context).getTranValue('no_internet'),
//           ),
//         ),
//       );
//     }
//   } // -------- end save order recipt for sunmi printer --------------

//   // ------------------Save bill Recipt For sunmi printer ------------------
//   Future<void> _billOrder(double totalQty, double disOrder, double subTotal,
//       double grandTotal, String currency) async {
//     //---------------------
//     bool _connection = await DataConnectionChecker().hasConnection;
//     if (_connection) {
//       var _permisBill = await PermissionController.permissionBill(widget.ip);
//       if (_permisBill == 'true') {
//         // var _selectOpenShift = await CheckOpenShiftController().selectOpenShift();
//         var _checkOpenShift =
//             await OpenShiftController.checkOpenShift(widget.ip);
//         if (_checkOpenShift.length > 0) {
//           var _data = await PostOrder().beforPost(
//               'Bill', widget.ip, _userId, _orderList, _detailList, _systemType);
//           if (_data.status == 'T') {
//             //---------No stock---------
//             if (_data.data.length > 0) {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       NotEnoughStockScreen(lsItemReturn: _data.data),
//                 ),
//               );
//             }
//             //----Has stork----
//             else {
//               //--Print Bill--
//               await PrintBill(
//                 orderDetailList: _detailList,
//                 logo: '',
//                 branchName: _receiptInfoLs.first.branchName,
//                 address: _receiptInfoLs.first.address,
//                 phone1: _receiptInfoLs.first.phone1,
//                 phone2: _receiptInfoLs.first.phone2,
//                 title: _receiptInfoLs.first.title,
//                 cashier: _userName,
//                 table: _tableOrdered.name,
//                 queue: _orderList.first.orderNo.isEmpty
//                     ? 'Queue'
//                     : _orderList.first.orderNo == null
//                         ? 'Queue'
//                         : _orderList.first.orderNo,
//                 totalQty: totalQty.toStringAsFixed(0),
//                 currency: currency,
//                 subTotal: subTotal,
//                 discount: disOrder,
//                 grandTotal: grandTotal,
//                 deskhmer: _receiptInfoLs.first.deskhmer,
//                 desEnglish: _receiptInfoLs.first.desEnglish,
//                 wifi: '',
//               ).startPrintBill('Pay');
//               //--------------------------
//               if (_systemType == 'KRMS') {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TableGroupScreen(ip: widget.ip),
//                   ),
//                   (route) => false,
//                 );
//               } else {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         SaleGroupScreen(type: 'G1', ip: widget.ip),
//                   ),
//                   (route) => false,
//                 );
//               }
//             }
//           } else {
//             Navigator.pop(context);
//             _messBackSaveOrder('${_data.status}', _data.status);
//           }
//         } else {
//           await Future.delayed(Duration(seconds: 2));
//           Navigator.pop(context);
//           _notOpenShift(
//             AppLocalization.of(context).getTranValue('open_shift_befor_pay'),
//             widget.ip,
//           );
//         }
//       } else {
//         _hasNotPermission(
//           AppLocalization.of(context).getTranValue('user_no_permission'),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No internet connection')),
//       );
//     }
//     //----------------------------------------------------
//   }

//   // --------- Save bill Recipt For EhternetPrinter -------------
//   Future<void> saveBill1() async {
//     bool _connection = await DataConnectionChecker().hasConnection;
//     if (_connection) {
//       var _permisBill = await PermissionController.permissionBill(widget.ip);
//       if (_permisBill == 'true') {
//         // var _selectOpenShift = await CheckOpenShiftController().selectOpenShift();
//         var _checkOpenShift =
//             await OpenShiftController.checkOpenShift(widget.ip);
//         if (_checkOpenShift.length > 0) {
//           var _data = await PostOrder().beforPost(
//             'Bill',
//             widget.ip,
//             _userId,
//             _orderList,
//             _detailList,
//             _systemType,
//           );
//           if (_data.status == 'T') {
//             //---------No stock---------
//             if (_data.data.length > 0) {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       NotEnoughStockScreen(lsItemReturn: _data.data),
//                 ),
//               );
//             }
//             //----Has stork----
//             else {
//               _bytes1 = await Utils.capture(_key2);
//               setState(() {
//                 _bytes1 = _bytes1;
//               });
//               printBill(ip, context);
//               //--------------------------
//               if (_systemType == 'KRMS') {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TableGroupScreen(ip: widget.ip),
//                   ),
//                   (route) => false,
//                 );
//               } else {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         SaleGroupScreen(type: 'G1', ip: widget.ip),
//                   ),
//                   (route) => false,
//                 );
//               }
//             }
//           } else {
//             Navigator.pop(context);
//             _messBackSaveOrder('${_data.status}', _data.status);
//           }
//         } else {
//           await Future.delayed(Duration(seconds: 2));
//           Navigator.pop(context);
//           _notOpenShift(
//             AppLocalization.of(context).getTranValue('open_shift_befor_pay'),
//             widget.ip,
//           );
//         }
//       } else {
//         _hasNotPermission(
//           AppLocalization.of(context).getTranValue('user_no_permission'),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No internet connection')),
//       );
//     }
//   }
//   // ----------------End For SaveRecipt EthernetPrinter ------------

//   Future<void> _moveTable() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text('${_tableOrdered.name}'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: _tableList
//                       .map((e) => RadioListTile(
//                             title: Text('${e.name}'),
//                             groupValue: _tableId,
//                             value: e.id,
//                             onChanged: (value) {
//                               setState(() {
//                                 _tableId = e.id;
//                                 print('TableId = $_tableId');
//                               });
//                             },
//                           ))
//                       .toList(),
//                 ),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child:
//                       Text(AppLocalization.of(context).getTranValue('cancel')),
//                 ),
//                 SizedBox(width: 5.0),
//                 TextButton(
//                   onPressed: () async {
//                     ShowMessage.showLoading(
//                       context,
//                       AppLocalization.of(context).getTranValue('loading'),
//                     );
//                     await Future.delayed(Duration(seconds: 1));
//                     bool isMove = await TableController.moveTable(
//                         widget.ip, _tableOrdered.id, _tableId);
//                     print('IsMove = $isMove');
//                     if (isMove) {
//                       if (_systemType == 'KRMS') {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 TableGroupScreen(ip: widget.ip),
//                           ),
//                           (route) => false,
//                         );
//                       } else {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SaleGroupScreen(
//                               type: 'G1',
//                               ip: widget.ip,
//                             ),
//                           ),
//                           (route) => false,
//                         );
//                       }
//                     } else {
//                       Navigator.of(context).pop();
//                       ShowMessage.showMessageSnakbar(
//                           'Move table falied', context);
//                     }
//                   },
//                   child: Text(AppLocalization.of(context).getTranValue('ok')),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _voidOrder() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Text(
//             AppLocalization.of(context).getTranValue('title_void_order'),
//             style: TextStyle(
//               fontSize: 18.0,
//               color: Colors.black,
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text(AppLocalization.of(context).getTranValue('cancel')),
//             ),
//             SizedBox(width: 5.0),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _buildReasonDialog();
//               },
//               child: Text(AppLocalization.of(context).getTranValue('ok')),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   var _reasonController = TextEditingController();
//   Future<void> _buildReasonDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: TextField(
//             decoration: InputDecoration(
//               label: Text(
//                 AppLocalization.of(context).getTranValue('enter_reason'),
//               ),
//               border: OutlineInputBorder(),
//             ),
//             style: TextStyle(fontSize: 20.0),
//             controller: _reasonController,
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text(AppLocalization.of(context).getTranValue('cancel')),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text(AppLocalization.of(context).getTranValue('ok')),
//               onPressed: () async {
//                 bool connection = await DataConnectionChecker().hasConnection;
//                 if (connection) {
//                   ShowMessage.showLoading(
//                     context,
//                     AppLocalization.of(context).getTranValue('loading'),
//                   );
//                   await Future.delayed(Duration(seconds: 1));
//                   bool isTrue = false;
//                   var order = await _sale.selectOrder();
//                   if (order.first.orderId == 0) {
//                     _sale.deleteAllOrder();
//                     _sale.deleteAllOrderDetail();
//                     isTrue = true;
//                   } else {
//                     var checkVoid = await VoidOrderController.voidOrder(
//                       widget.ip,
//                       order.first.orderId,
//                       _reasonController.text.isEmpty
//                           ? 'No Reason'
//                           : _reasonController.text,
//                     );
//                     if (checkVoid == 'N') {
//                       Navigator.pop(context);
//                       Navigator.pop(context);
//                       _hasNotPermission(
//                         AppLocalization.of(context)
//                             .getTranValue('user_no_permission'),
//                       );
//                     } else {
//                       _sale.deleteAllOrder();
//                       _sale.deleteAllOrderDetail();
//                       isTrue = true;
//                     }
//                   }
//                   if (isTrue) {
//                     if (_systemType == 'KRMS') {
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => TableGroupScreen(ip: widget.ip),
//                         ),
//                         (route) => false,
//                       );
//                     } else {
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SaleGroupScreen(
//                             type: 'G1',
//                             ip: widget.ip,
//                           ),
//                         ),
//                         (route) => false,
//                       );
//                     }
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         AppLocalization.of(context).getTranValue('no_internet'),
//                       ),
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _buildCancelReceipt() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('AlertDialog Title'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: const <Widget>[
//                 Text('This is a demo alert dialog.'),
//                 Text('Would you like to approve of this message?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Approve'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _notOpenShift(String mess, String ip) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Text(
//             '$mess',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.black,
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () async {
//                 var per =
//                     await PermissionController.checkPermissionOpenShift(ip);
//                 if (per == 'false') {
//                   Navigator.of(context).pop();
//                   _hasNotPermission(AppLocalization.of(context)
//                       .getTranValue('user_no_permission'));
//                 } else {
//                   Navigator.of(context).pop();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OpenShiftScreen(ip: ip),
//                     ),
//                   );
//                 }
//               },
//               child: Text(AppLocalization.of(context).getTranValue('ok')),
//             ),
//             SizedBox(width: 5),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(AppLocalization.of(context).getTranValue('cancel')),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _hasNotPermission(String mess) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Text(
//             '$mess',
//             style: TextStyle(fontSize: 18, color: Colors.black),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(AppLocalization.of(context).getTranValue('ok')),
//             )
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _messBackSaveOrder(String mes, String status) async {
//     //dynamic sys = await FlutterSession().get('systemType');
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('System Message'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(
//                   '$mes',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             MaterialButton(
//               // color: Color.fromRGBO(75, 181, 69, 1),
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
//                     'OK',
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _buildDialogDiscount(BuildContext context) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(AppLocalization.of(context).getTranValue('dis_order')),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 BlocBuilder<BlocOrder, StateOrder>(builder: (context, state) {
//                   _detailList = state.orderDetail;
//                   _controllerTotalAmont.text =
//                       state.subTotal.toStringAsFixed(2);
//                   _controllerDisValue.text =
//                       (state.disOrder).toStringAsFixed(2);
//                   return Column(
//                     children:
//                         _orderList.where((x) => x.grandTotal >= 0).map((e) {
//                       _controllerDisRate.text =
//                           e.discountRate.toStringAsFixed(2);
//                       return Column(
//                         children: [
//                           TextFormField(
//                             controller: _controllerTotalAmont,
//                             readOnly: true,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               hintStyle: TextStyle(color: Colors.black),
//                               labelText:
//                                   '${AppLocalization.of(context).getTranValue('total_amount')} (${state.currency})',
//                             ),
//                           ),
//                           SizedBox(height: 10.0),
//                           TextFormField(
//                             controller: _controllerDisValue,
//                             onChanged: (value) {
//                               if (value == '') {
//                                 _controllerDisRate.text = '0.00';
//                               } else {
//                                 e.discountValue = double.parse(value);
//                                 _controllerDisRate.text =
//                                     (double.parse(value) * 100 / state.subTotal)
//                                         .toStringAsFixed(2);
//                                 e.discountRate =
//                                     double.parse(value) * 100 / state.subTotal;
//                                 _controllerTotalAmont.text =
//                                     (state.subTotal - double.parse(value))
//                                         .toStringAsFixed(2);
//                                 e.grandTotal =
//                                     state.subTotal - double.parse(value);
//                               }
//                             },
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               suffixIcon: IconButton(
//                                 onPressed: () {
//                                   _controllerDisValue.clear();
//                                   _controllerDisRate.text = '0.00';
//                                 },
//                                 icon: Icon(Icons.close),
//                               ),
//                               labelText:
//                                   '${AppLocalization.of(context).getTranValue('discount')} (${state.currency})',
//                             ),
//                           ),
//                           SizedBox(height: 10.0),
//                           TextFormField(
//                             inputFormatters: [
//                               FilteringTextInputFormatter.allow(
//                                 RegExp('^([1-9][0-9]?|100)\$'),
//                               ),
//                               LengthLimitingTextInputFormatter(3),
//                             ],
//                             controller: _controllerDisRate,
//                             onChanged: (value) {
//                               if (value == '') {
//                                 _controllerDisValue.text = '0.00';
//                               } else {
//                                 e.discountRate = double.parse(value);
//                                 _controllerDisValue.text =
//                                     ((state.subTotal * double.parse(value)) /
//                                             100)
//                                         .toStringAsFixed(2);
//                                 e.discountValue =
//                                     ((state.subTotal * double.parse(value)) /
//                                         100);
//                                 _controllerTotalAmont.text = (state.subTotal -
//                                         double.parse(
//                                             (_controllerDisValue.text)))
//                                     .toStringAsFixed(2);
//                                 e.grandTotal = state.subTotal -
//                                     double.parse((_controllerDisValue.text));
//                               }
//                             },
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               suffixIcon: IconButton(
//                                 onPressed: () {
//                                   _controllerDisRate.clear();
//                                   _controllerDisValue.text = '0.00';
//                                 },
//                                 icon: Icon(Icons.close),
//                               ),
//                               labelText:
//                                   '${AppLocalization.of(context).getTranValue('discount')} (%)',
//                             ),
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   );
//                 }),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(
//                 AppLocalization.of(context).getTranValue('cancel'),
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 ShowMessage.showLoading(
//                   context,
//                   AppLocalization.of(context).getTranValue('loading'),
//                 );
//                 await Future.delayed(Duration(seconds: 1));
//                 _orderList.forEach((e) {
//                   SaleController().updateOrder(e);
//                   BlocProvider.of<BlocOrder>(context).add(
//                     EventOrder.add(key: e.orderId),
//                   );
//                 });
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 AppLocalization.of(context).getTranValue('save'),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildStack(OrderDetail e, String ip) {
//     return Stack(
//       children: [
//         Container(
//           child: Text(
//             '${e.khmerName} (${e.uomName})',
//             style: TextStyle(fontSize: 17.0),
//             textAlign: TextAlign.start,
//           ),
//           width: double.infinity,
//           alignment: Alignment.centerLeft,
//           height: 70.0,
//         ),
//         _showList.firstWhere((s) => s.key == e.lineId).show == 1
//             ? Positioned(
//                 top: 10.0,
//                 right: 3.0,
//                 child: Container(
//                   width: 50.0,
//                   height: 50.0,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(3.0),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: MaterialButton(
//                     child: Icon(Icons.remove, size: 25, color: Colors.red),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(3.0),
//                     ),
//                     padding: EdgeInsets.only(),
//                     color: Colors.white,
//                     onPressed: () async {
//                       var _selectOrder = await _sale.selectOrder();
//                       if (_selectOrder.first.orderId == 0) {
//                         if (_count.floor() == 1) {
//                           _hasNotPermission('Cannot empty cart !');
//                         } else {
//                           BlocProvider.of<BlocOrder>(context)
//                               .add(EventOrder.add(key: e.lineId));
//                           e.qty -= 1;
//                           e.printQty -= 1;
//                           _sale.updateOrderDetail(e);
//                         }
//                       } else {
//                         //check permission
//                         var per =
//                             await PermissionController.permissionDeleteItem(ip);
//                         if (per == 'true') {
//                           if (_count.floor() == 1) {
//                             _hasNotPermission('Cannot empty cart !');
//                           } else {
//                             BlocProvider.of<BlocOrder>(context).add(
//                               EventOrder.add(key: e.lineId),
//                             );
//                             e.qty -= 1;
//                             e.printQty -= 1;
//                             _sale.updateOrderDetail(e);
//                             // _getOrderDetail();
//                           }
//                         } else {
//                           _hasNotPermission(AppLocalization.of(context)
//                               .getTranValue('user_no_permission'));
//                         }
//                       }
//                       if (_timer != null) _timer.cancel();
//                       _timer = Timer(Duration(milliseconds: 1500), () {
//                         if (mounted) {
//                           setState(() => _showList
//                               .firstWhere((s) => s.key == e.lineId)
//                               .show = 0);
//                         }
//                       });
//                       _getOrderDetail();
//                     },
//                   ),
//                 ),
//               )
//             : Text(''),
//         _showList.firstWhere((s) => s.key == e.lineId).show == 1
//             ? Positioned(
//                 top: 10.0,
//                 right: 56.0,
//                 child: Container(
//                   width: 50.0,
//                   height: 50.0,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(3.0),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: MaterialButton(
//                     child: Icon(Icons.delete, size: 25.0, color: Colors.red),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(3.0),
//                     ),
//                     padding: EdgeInsets.only(),
//                     color: Colors.white,
//                     onPressed: () async {
//                       var _selectOrder = await _sale.selectOrder();
//                       if (_selectOrder.first.orderId == 0) {
//                         if (_detailList.length == 1) {
//                           _hasNotPermission('Cannot empty cart !');
//                         } else {
//                           BlocProvider.of<BlocOrder>(context)
//                               .add(EventOrder.add(key: e.lineId));
//                           e.qty = 0;
//                           e.printQty = 0;
//                           _sale.updateOrderDetail(e);
//                           // _getOrderDetail();
//                         }
//                       } else {
//                         //​​​---------Check permission---------
//                         var _per =
//                             await PermissionController.permissionDeleteItem(ip);
//                         if (_per == 'true') {
//                           if (_detailList.length == 1) {
//                             _hasNotPermission("Cannot empty cart !");
//                           } else {
//                             BlocProvider.of<BlocOrder>(context).add(
//                               EventOrder.add(key: e.lineId),
//                             );
//                             e.qty = 0;
//                             e.printQty = 0;
//                             _sale.updateOrderDetail(e);
//                             // _getOrderDetail();
//                           }
//                         } else {
//                           _hasNotPermission(AppLocalization.of(context)
//                               .getTranValue('user_no_permission'));
//                         }
//                       }
//                       _getOrderDetail();
//                     },
//                   ),
//                 ),
//               )
//             : Text(''),
//       ],
//     );
//   }

//   List<Widget> _buildListWidget() {
//     return _detailList.where((x) => x.qty > 0).map((e) {
//       return InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DetailByItem(orderDetail: e, ip: widget.ip),
//             ),
//           ).then((value) => _getOrderDetail());
//         },
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 5.0),
//               height: 70.0,
//               child: Row(
//                 children: [
//                   Expanded(child: _buildStack(e, widget.ip)),
//                   Container(
//                     width: 50.0,
//                     height: 50.0,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(3.0),
//                     ),
//                     child: MaterialButton(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(3.0),
//                       ),
//                       padding: EdgeInsets.only(),
//                       color: Colors.white,
//                       onPressed: () {
//                         setState(() {
//                           for (var data in _detailList) {
//                             if (data.lineId == e.lineId) {
//                               _showList
//                                   .firstWhere((s) => s.key == data.lineId)
//                                   .show = 1;
//                             } else {
//                               _showList
//                                   .firstWhere((s) => s.key == data.lineId)
//                                   .show = 0;
//                             }
//                           }
//                           if (_timer != null) _timer.cancel();
//                           _timer = Timer(Duration(seconds: 2), () {
//                             if (mounted) {
//                               setState(() => _showList
//                                   .firstWhere((s) => s.key == e.lineId)
//                                   .show = 0);
//                             }
//                           });
//                         });
//                       },
//                       child: BlocBuilder<BlocOrder, StateOrder>(
//                         builder: (context, state) {
//                           var baseQty = state.baseQty.firstWhere(
//                               (x) => x.key == e.lineId,
//                               orElse: () => null);
//                           return Text(
//                             '${baseQty != null ? baseQty.qty.floor() : 0}',
//                             style: TextStyle(fontSize: 16.0),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 140.0,
//                     child: Stack(
//                       children: [
//                         Container(
//                           width: double.infinity,
//                           alignment: Alignment.centerRight,
//                           height: 70.0,
//                           child: Column(
//                             children: [
//                               Text(
//                                 '${e.currency} ${(e.unitPrice * e.qty).toStringAsFixed(2)}',
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
//                                       '${e.currency}  ${e.typeDis == 'Percent' ? ((e.unitPrice * e.qty) - (e.discountRate * e.qty * e.unitPrice) / 100).toStringAsFixed(2) : ((e.unitPrice * e.qty) - (e.discountRate * e.qty)).toStringAsFixed(2)}',
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
//                         _showList.firstWhere((s) => s.key == e.lineId).show == 1
//                             ? _buildPosition(e)
//                             : Text(''),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Divider(height: 0, color: Colors.grey),
//           ],
//         ),
//       );
//     }).toList();
//   }

//   Widget _buildPosition(OrderDetail e) {
//     return Positioned(
//       top: 10.0,
//       left: 3.0,
//       child: Container(
//         width: 50.0,
//         height: 50.0,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(3.0),
//           border: Border.all(color: Colors.grey),
//         ),
//         child: MaterialButton(
//           child: Icon(Icons.add, size: 25.0, color: Colors.red),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(3.0),
//           ),
//           padding: EdgeInsets.only(),
//           color: Colors.white,
//           onPressed: () {
//             BlocProvider.of<BlocOrder>(context).add(
//               EventOrder.add(key: e.lineId),
//             );
//             e.qty += 1;
//             e.printQty += 1;
//             _sale.updateOrderDetail(e);
//             _getOrderDetail();
//             if (_timer != null) _timer.cancel();
//             _timer = Timer(Duration(seconds: 2), () {
//               if (mounted) {
//                 setState(() =>
//                     _showList.firstWhere((s) => s.key == e.lineId).show = 0);
//               }
//             });
//           },
//         ),
//       ),
//     );
//   }

//   var printer;
//   var ip;
//   void getPrinter() async {
//     var prifs = await SharedPreferences.getInstance();
//     printer = prifs.getString("printer");
//     print("printer name: $printer");
//   }

//   void getIp() async {
//     var priIp = await SharedPreferences.getInstance();
//     ip = priIp.getString("ipAdrress");
//     print("ip : $ip");
//   }

//   Uint8List resizeImage1(Uint8List data) {
//     Uint8List resizedData = data;
//     imgx.Image img = imgx.decodeImage(data);
//     imgx.Image resized = imgx.copyResize(img, width: 500);
//     resizedData = imgx.encodeJpg(resized);
//     return resizedData;
//   }

//   Future<void> printOReceipt(NetworkPrinter printer) async {
//     // Print image
//     final Uint8List bytes = resizeImage1(_bytes);
//     final image = decodeImage(bytes);
//     printer.image(image);
//     printer.feed(1);
//     printer.cut();
//   }

//   void printOrder(String printerIp, BuildContext ctx) async {
//     const PaperSize paper = PaperSize.mm80;
//     final profile = await CapabilityProfile.load();
//     final printer = NetworkPrinter(paper, profile);

//     final PosPrintResult res = await printer.connect(printerIp, port: 9100);

//     if (res == PosPrintResult.success) {
//       // DEMO RECEIPT
//       await printOReceipt(printer);
//       // TEST PRINT
//       // await testReceipt(printer);
//       printer.disconnect();
//     }

//     final snackBar =
//         SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
//     ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
//   }

//   Future<void> printBReceipt(NetworkPrinter printer) async {
//     // Print image
//     final Uint8List bytes = resizeImage1(_bytes1);
//     final image = decodeImage(bytes);
//     printer.image(image);
//     printer.feed(1);
//     printer.cut();
//   }

//   void printBill(String printerIp, BuildContext ctx) async {
//     const PaperSize paper = PaperSize.mm80;
//     final profile = await CapabilityProfile.load();
//     final printer = NetworkPrinter(paper, profile);

//     final PosPrintResult res = await printer.connect(printerIp, port: 9100);

//     if (res == PosPrintResult.success) {
//       // DEMO RECEIPT
//       await printBReceipt(printer);

//       // TEST PRINT
//       // await testReceipt(printer);
//       printer.disconnect();
//     }

//     final snackBar =
//         SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
//     ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
//   }

//   void printOrderRecipt() async {
//     _bytes = await Utils.capture(key1);
//     setState(() {
//       _bytes = _bytes;
//     });
//     printOrder(ip, context);
//   }

//   void printBillRecipt() async {
//     _bytes1 = await Utils.capture(_key2);
//     setState(() {
//       _bytes1 = _bytes1;
//     });
//     printBill(ip, context);
//   }

//   showBillRecipt(double totalQty, double disOrder, double subTotal,
//       double grandTotal, String currency) {
//     return showDialog<String>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('Bill Recipt'),
//         content: WidgetToImage(builder: ((key) {
//           _key2 = key;
//           return BuildBillRecipt(
//             orderDetailList: _detailList,
//             logo: '',
//             branchName: _receiptInfoLs.first.branchName,
//             address: _receiptInfoLs.first.address,
//             phone1: _receiptInfoLs.first.phone1,
//             phone2: _receiptInfoLs.first.phone2,
//             title: _receiptInfoLs.first.title,
//             cashier: _userName,
//             table: _tableOrdered.name,
//             queue: _orderList.first.orderNo.isEmpty
//                 ? 'Queue'
//                 : _orderList.first.orderNo == null
//                     ? 'Queue'
//                     : _orderList.first.orderNo,
//             totalQty: totalQty.toStringAsFixed(0),
//             currency: currency,
//             subTotal: subTotal,
//             discount: disOrder,
//             grandTotal: grandTotal,
//             deskhmer: _receiptInfoLs.first.deskhmer,
//             desEnglish: _receiptInfoLs.first.desEnglish,
//             wifi: '',
//           );
//         })),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.pop(context, 'Cancel'),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               ShowMessage.showLoading(context, "Loading");
//               saveBill1();
//               Navigator.pop(context, "Ok");
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   showOrderRecipt() {
//     return showDialog<String>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('Order Recipt'),
//         content: WidgetToImage(builder: ((key) {
//           key1 = key;
//           return BuildOrderRecipt(
//             reciptNo: _orderList.first.orderNo,
//             cashier: _userName,
//             table: _tableOrdered.name,
//             orderDetailList: _detailList,
//           );
//         })),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.pop(context, 'Cancel'),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               //printOrderRecipt();
//               ShowMessage.showLoading(context, "Loading");
//               _saveOrder();
//               Navigator.pop(context, "Ok");
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
