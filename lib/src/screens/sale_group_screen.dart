// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_session/flutter_session.dart';
// import 'package:intl/intl.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/bloc_order.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/event_order.dart';
// import 'package:point_of_sale/src/bloc/group_item_bloc/groupitem_bloc.dart';
// import 'package:point_of_sale/src/bloc/other_bloc/customer_bloc.dart';
// import 'package:point_of_sale/src/bloc/setting_bloc/setting_bloc.dart';
// import 'package:point_of_sale/src/controllers/customer_controller.dart';

// import 'package:point_of_sale/src/controllers/gorup1_controller.dart';
// import 'package:point_of_sale/src/controllers/group2_controller.dart';
// import 'package:point_of_sale/src/controllers/group3_controller.dart';
// import 'package:point_of_sale/src/controllers/item_controller.dart';
// import 'package:point_of_sale/src/controllers/sale_controller.dart';
// import 'package:point_of_sale/src/helpers/app_localization.dart';
// import 'package:point_of_sale/src/models/customer_modal.dart';

// import 'package:point_of_sale/src/models/gorupItem_modal.dart';
// import 'package:point_of_sale/src/models/item_modal.dart';
// import 'package:point_of_sale/src/models/order_detail_modal.dart';
// import 'package:point_of_sale/src/models/order_modal.dart';
// import 'package:point_of_sale/src/models/post_server_modal.dart';
// import 'package:point_of_sale/src/screens/customer_screen.dart';
// import 'package:point_of_sale/src/screens/item_barcode_screen.dart';
// import 'package:point_of_sale/src/widgets/drawer_widget.dart';
// import 'package:point_of_sale/src/widgets/sale_gorup_tab_bar_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SaleGroupScreen extends StatefulWidget {
//   final List<PostModel> postList;
//   final String type;
//   final int g1Id;
//   final int g2Id;
//   final int tableId;
//   final String ip;
//   SaleGroupScreen({
//     this.type,
//     this.g1Id,
//     this.g2Id,
//     this.tableId,
//     this.postList,
//     @required this.ip,
//   });

//   @override
//   _SaleGroupScreenState createState() => _SaleGroupScreenState();
// }

// class _SaleGroupScreenState extends State<SaleGroupScreen> {
//   List<CustomerModel> customerList = [];
//   Future<void> getCustomer() async {
//     await CustomerController.getCustomer(widget.ip).then((value) {
//       setState(() {
//         customerList.addAll(value);
//       });
//       value.forEach((element) {
//         print("Customer : ${element.name}");
//       });
//     });
//   }

//   var customer;
//   int _countReceipt = 0;
//   var _systemType;
//   String _nowtype, _barcode;
//   bool _hasInternet = false, _loading = true, _checkBarcode = true;

//   Future<void> _selectSystemType() async {
//     var _prefs = await SharedPreferences.getInstance();
//     _checkBarcode = _prefs.getBool('barcode');
//     if (_checkBarcode == null) {
//       _checkBarcode = false;
//     }
//     _systemType = _prefs.getString('systemType');
//     customer = _prefs.getString("customerName");
//     print("customer name: $customer");
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCustomer();
//     BlocProvider.of<CustomerBloc>(context).add(GetCustomerList(widget.ip));
//     _selectSystemType();
//     BlocProvider.of<SettingBloc>(context).add(GetSettingEvent());
//     widget.postList.forEach((element) {
//       print('OrderNo = ${element.receiptNo}');
//       print('Queue   = ${element.queueNo}');
//     });
//     BlocProvider.of<GroupitemBloc>(context).add(
//       GetGroupItemEvent(
//           type: widget.type, g1Id: widget.g1Id, g2Id: widget.g2Id),
//     );
//     if (widget.postList.length > 0) _countOrder();

//     _checkInternet();
//   }

//   Future<void> _scanBarcode() async {
//     try {
//       final barcode = await FlutterBarcodeScanner.scanBarcode(
//           '#ff6666', 'CANCEL', true, ScanMode.BARCODE);
//       if (!mounted) return;
//       if (barcode.isEmpty) {
//         return;
//       } else {
//         setState(() => _barcode = barcode);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ItemBarcodeScreen(
//               ip: widget.ip,
//               barcode: _barcode,
//               tableId: widget.tableId,
//             ),
//           ),
//         );
//       }
//     } on PlatformException {
//       _barcode = 'Failed to scan item';
//     }
//   }

//   Future<void> _showCustomer() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Customer'),
//           content: BlocBuilder<CustomerBloc, CustomerState>(
//             builder: ((context, state) {
//               if (state is CustomerLoading) {
//                 return CircularProgressIndicator();
//               } else if (state is CustomerLoaded) {
//                 return SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: customerList.map((e) {
//                       return Text(e.name);
//                     }).toList(),
//                   ),
//                 );
//               } else {
//                 return Center(child: Text("no customer"));
//               }
//             }),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<GroupitemBloc, GroupitemState>(
//       listener: (context, state) {
//         if (state is GroupItemError) {
//           print('Group Item Error : ${state.message}');
//         }
//       },
//       child: BlocBuilder<GroupitemBloc, GroupitemState>(
//         builder: (context, state) {
//           if (state is GroupitemInitial) {
//             return _buildLoading();
//           } else if (state is GroupItemLoading) {
//             return _buildLoading();
//           } else if (state is GroupItemLoaded) {
//             return _buildGroupItemLoaded(state.groupItemList);
//           } else if (state is GroupItemError) {
//             return _buildError(state.message);
//           } else {
//             return _buildLoading();
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildGroupItemLoaded(List<GroupItemModel> groupItemList) {
//     return DefaultTabController(
//       length: groupItemList.length,
//       initialIndex: 0,
//       child: Scaffold(
//         drawer: DrawerWidget(selected: 2, ip: widget.ip),
//         appBar: _buildAppBar(groupItemList),
//         body: _loading
//             ? TabBarView(
//                 children: groupItemList.map((group) {
//                   return SaleGroupTabBar(
//                     ip: widget.ip,
//                     groupItem: group,
//                     type: _nowtype,
//                     checkInternet: _hasInternet,
//                     postList: widget.postList,
//                     tableId: widget.tableId,
//                   );
//                 }).toList(),
//               )
//             : Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Theme.of(context).primaryColor,
//                   ),
//                 ),
//               ),
//         bottomNavigationBar: BlocBuilder<BlocOrder, StateOrder>(
//           builder: (context, state) {
//             if (state.qty == null) {
//               return Container(height: 0.0);
//             } else {
//               if (state.allQty != 0.0) {
//                 return Container(
//                   width: double.infinity,
//                   height: 60.0,
//                   color: Color.fromRGBO(230, 230, 230, 1),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           alignment: Alignment.center,
//                           color: Colors.grey[400],
//                           child: Text(
//                             '${state.currency}  ${state.grandTotal.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               fontSize: 20.0,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: InkWell(
//                           onTap: () {
//                             // Navigator.push(
//                             //   context,
//                             //   MaterialPageRoute(
//                             //     builder: (context) => DetailSaleGroup(
//                             //       ip: widget.ip,
//                             //     ),
//                             //   ),
//                             // );
//                           },
//                           child: Stack(
//                             children: [
//                               Container(
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                 ),
//                                 child: Text(
//                                   AppLocalization.of(context)
//                                       .getTranValue('view_cart'),
//                                   style: TextStyle(
//                                     fontSize: 17.0,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 right: 0.0,
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     border: Border.all(color: Colors.red),
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.only(
//                                       bottomLeft: Radius.circular(16.0),
//                                     ),
//                                   ),
//                                   height: 25.0,
//                                   width: 50.0,
//                                   child: Text(
//                                     '${state.allQty.floor()}',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               } else {
//                 return Container(height: 0.0);
//               }
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildAppBar(List<GroupItemModel> groupItemList) {
//     return AppBar(
//       actions: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _systemType == 'KBMS'
//                 ? Row(
//                     children: [
//                       Text(customer ?? ''),
//                       IconButton(
//                         icon: Icon(Icons.person, size: 26.0),
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       CustomerScreen(ip: widget.ip)));
//                         },
//                       ),
//                     ],
//                   )
//                 : SizedBox(height: 0.0),
//             SizedBox(width: 8.0),
//             _checkBarcode && _checkBarcode != null
//                 ? IconButton(
//                     onPressed: () => _scanBarcode(),
//                     icon: Icon(Icons.document_scanner_outlined, size: 26.0),
//                   )
//                 : SizedBox(height: 0.0),
//             SizedBox(width: 8.0),
//             _systemType == 'KRMS'
//                 ? _buildActionOrdered()
//                 : SizedBox(height: 0.0),
//             SizedBox(width: 10.0),
//             IconButton(
//               icon: Icon(Icons.search, size: 26.0),
//               onPressed: () {
//                 showSearch(
//                   context: context,
//                   delegate: DataSearch(tableId: widget.tableId, ip: widget.ip),
//                 );
//               },
//             ),
//             SizedBox(width: 15.0),
//           ],
//         ),
//       ],
//       title: Text(AppLocalization.of(context).getTranValue('sale_title')),
//       bottom: _buildTabBar(groupItemList),
//     );
//   }

//   Widget _buildActionOrdered() {
//     return InkWell(
//       onTap: () => _orderedModalBottomSheet(context),
//       child: Stack(
//         children: [
//           IconButton(
//             icon: Icon(Icons.receipt, size: 26),
//             onPressed: () => _orderedModalBottomSheet(context),
//           ),
//           _countReceipt > 0
//               ? Positioned(
//                   top: 2.0,
//                   right: 8.0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     width: 20.0,
//                     height: 20.0,
//                     child: Center(
//                       child: Text(
//                         '$_countReceipt',
//                         style: TextStyle(
//                           fontSize: 13.0,
//                           color: Colors.white,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 )
//               : SizedBox(height: 0.0, width: 0.0),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabBar(List<GroupItemModel> groupItemList) {
//     return TabBar(
//       isScrollable: true,
//       indicator: BoxDecoration(
//         color: Colors.grey.withOpacity(0.3),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(2.0),
//           topRight: Radius.circular(2.0),
//         ),
//       ),
//       tabs: groupItemList.map((group) {
//         return Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Tab(
//             child: Text(
//               group.name,
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildLoading() {
//     return Center(
//       child: CircularProgressIndicator(),
//     );
//   }

//   Widget _buildError(String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(message, style: TextStyle(fontSize: 20.0)),
//           IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
//         ],
//       ),
//     );
//   }

//   Future<void> _getGroupItem(String ip) async {
//     await Future.delayed(Duration(seconds: 1));
//     bool _result = await DataConnectionChecker().hasConnection;
//     if (widget.type == 'G1') {
//       if (_result) {
//         await Group1Controller.eachGroup1(ip).then((values) {
//           setState(() {
//             // _groupItemList = values;
//             _nowtype = 'G1';
//             _loading = true;
//           });
//         });
//       } else {
//         await Group1Controller().getGroup1().then((values) {
//           setState(() {
//             // _groupItemList = values;
//             _nowtype = 'G1';
//             _loading = true;
//           });
//         });
//       }
//     } else if (widget.type == 'G2') {
//       if (_result) {
//         await Group2Controller.eachGroup2(widget.g1Id, widget.ip)
//             .then((values) {
//           setState(() {
//             // _groupItemList = values;
//             _nowtype = 'G2';
//             _loading = true;
//           });
//         });
//       } else {
//         await Group2Controller().getGroup2(widget.g1Id).then((values) {
//           setState(() {
//             // _groupItemList = values;
//             _nowtype = 'G2';
//             _loading = true;
//           });
//         });
//       }
//     } else if (widget.type == 'G3') {
//       if (_result) {
//         await Group3Controller.eachGroup3(widget.g1Id, widget.g2Id, widget.ip)
//             .then((values) {
//           setState(() {
//             // _groupItemList = values;
//             _nowtype = 'G3';
//             _loading = true;
//           });
//         });
//       } else {
//         await Group3Controller()
//             .getGroup3(widget.g1Id, widget.g2Id)
//             .then((values) {
//           setState(() {
//             // _groupItemList = values;
//             _nowtype = 'G3';
//             _loading = true;
//           });
//         });
//       }
//     }
//   }

//   void _checkInternet() async {
//     bool result = await DataConnectionChecker().hasConnection;
//     if (result)
//       setState(() => _hasInternet = true);
//     else
//       setState(() => _hasInternet = false);
//   }

//   _orderedModalBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (context) {
//         return Container(
//           margin: EdgeInsets.only(top: 25),
//           color: Colors.white,
//           child: Column(
//             children: [
//               Container(
//                 height: 60,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: Container(
//                         width: double.infinity,
//                         height: 60.0,
//                         child: MaterialButton(
//                           color: Colors.red,
//                           splashColor: Colors.white,
//                           onPressed: () {
//                             BlocProvider.of<BlocOrder>(context).add(
//                               EventOrder.delete(),
//                             );
//                             Navigator.pop(context);
//                           },
//                           child: Text(
//                             'New Order',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(width: 1.0, color: Colors.white),
//                     Expanded(
//                       child: Container(
//                         width: double.infinity,
//                         height: 60.0,
//                         child: MaterialButton(
//                           color: Colors.red,
//                           splashColor: Colors.white,
//                           onPressed: () => Navigator.pop(context),
//                           child: Icon(
//                             Icons.close,
//                             size: 30.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ListView(
//                   children: [
//                     ListView.separated(
//                       shrinkWrap: true,
//                       physics: ScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         var _data = widget.postList[index];
//                         return ListTile(
//                           onTap: () {
//                             _buildOrder(p: _data);
//                           },
//                           leading: Icon(Icons.receipt_long),
//                           title: Text(
//                             _data.orderNo,
//                             style: TextStyle(
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           subtitle: Text(
//                             DateFormat('dd-MM-yyyy')
//                                     .format(_data.dateIn)
//                                     .toString() +
//                                 '  ' +
//                                 _data.timeIn,
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         );
//                       },
//                       separatorBuilder: (context, index) {
//                         return Divider(height: 0.0, color: Colors.grey);
//                       },
//                       itemCount: widget.postList.length,
//                     ),
//                     Divider(height: 0.0, color: Colors.grey),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _countOrder() {
//     setState(() => _countReceipt = widget.postList.length);
//   }

//   Future<void> _buildOrder({@required PostModel p}) async {
//     await SaleController().deleteAllOrder();
//     await SaleController().deleteAllOrderDetail();
//     var key = 0;
//     OrderModel order = OrderModel(
//       orderId: p.orderId,
//       orderNo: p.orderNo,
//       tableId: p.tableId,
//       receiptNo: p.receiptNo,
//       queueNo: p.queueNo,
//       dateIn: p.dateIn,
//       dateOut: p.dateOut,
//       timeIn: p.timeIn,
//       timeOut: p.timeOut,
//       waiterId: p.waiterId,
//       userOrderId: p.userOrderId,
//       userDiscountId: p.userDiscountId,
//       customerId: p.customerId,
//       customerCount: p.customerCount,
//       priceListId: p.priceListId,
//       localCurrencyId: p.localCurrencyId,
//       sysCurrencyId: p.sysCurrencyId,
//       exchangeRate: p.exchangeRate,
//       warehouseId: p.warehouseId,
//       branchId: p.branchId,
//       companyId: p.companyId,
//       subTotal: p.subTotal,
//       discountRate: p.discountRate,
//       discountValue: p.discountValue,
//       typeDis: p.typeDis,
//       taxRate: p.taxRate,
//       taxValue: p.taxValue,
//       grandTotal: p.grandTotal,
//       grandTotalSys: p.grandTotalSys,
//       tip: p.tip,
//       received: p.received,
//       change: p.change,
//       currencyDisplay: p.currencyDisplay,
//       displayRate: p.displayRate,
//       grandTotalDisplay: p.grandTotalDisplay,
//       changeDisplay: p.changeDisplay,
//       paymentMeansId: p.paymentMeansId,
//       checkBill: p.checkBill,
//       cancel: p.cancel,
//       delete: p.delete,
//       paymentType: p.paymentType,
//       receivedType: p.receivedType,
//       credit: p.credit,
//     );
//     key = await SaleController().insertOrder(order);
//     p.detail.forEach((e) async {
//       OrderDetail detail = new OrderDetail(
//         masterId: key,
//         orderDetailId: e.orderDetailId,
//         orderId: e.orderId,
//         lineId: e.lineId,
//         itemId: e.itemId,
//         code: e.code,
//         khmerName: e.khmerName,
//         englishName: e.englishName,
//         qty: e.qty,
//         printQty: e.printQty,
//         unitPrice: e.unitPrice,
//         cost: e.cost,
//         discountRate: e.discountRate,
//         discountValue: e.discountValue,
//         typeDis: e.typeDis,
//         total: e.total,
//         totalSys: e.totalSys,
//         uomId: e.uomId,
//         uomName: e.uomName,
//         itemStatus: e.itemStatus,
//         itemPrintTo: e.itemPrintTo,
//         currency: e.currency,
//         comment: e.comment,
//         itemType: e.itemType,
//         description: e.description,
//         parentLevel: e.parentLevel,
//         image: e.image,
//         show: 0,
//       );
//       SaleController().insertOrderDetail(detail);
//       BlocProvider.of<BlocOrder>(context).add(EventOrder.add(key: e.lineId));
//     });
//     Navigator.pop(context);
//   }
// }

// class DataSearch extends SearchDelegate<String> {
//   int tableId;
//   final String ip;

//   DataSearch({this.tableId, @required this.ip});
//   List<ItemMaster> ls = [];
//   List<ItemMaster> items = [];
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () => query = '',
//       )
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//       ),
//       onPressed: () => close(context, 'true'),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     if (query == '') {
//       if (items.length != 0) {
//         return Column(
//           children: [
//             BlocBuilder<BlocOrder, StateOrder>(
//               builder: (context, state) {
//                 if (state.qty == null) {
//                   return Container(height: 0.0);
//                 } else {
//                   return state.allQty != 0.0
//                       ? Container(
//                           width: double.infinity,
//                           height: 60.0,
//                           color: Color.fromRGBO(230, 230, 230, 1),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   color: Colors.grey[400],
//                                   child: Text(
//                                     "${state.currency}  ${state.grandTotal.toStringAsFixed(2)}",
//                                     style: TextStyle(
//                                       fontSize: 20.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: InkWell(
//                                   onTap: () {
//                                     // Navigator.push(
//                                     //   context,
//                                     //   MaterialPageRoute(
//                                     //     builder: (context) =>
//                                     //         DetailSaleGroup(ip: ip),
//                                     //   ),
//                                     // );
//                                   },
//                                   child: Stack(
//                                     children: [
//                                       Container(
//                                         alignment: Alignment.center,
//                                         color: Colors.red,
//                                         child: Text(
//                                           AppLocalization.of(context)
//                                               .getTranValue('view_cart'),
//                                           style: TextStyle(
//                                             fontSize: 17.0,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         right: 0.0,
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           decoration: BoxDecoration(
//                                             color: Colors.grey[400],
//                                             borderRadius: BorderRadius.only(
//                                               bottomLeft: Radius.circular(16.0),
//                                             ),
//                                           ),
//                                           height: 30.0,
//                                           width: 60.0,
//                                           child: Text(
//                                             '${state.allQty.floor()}',
//                                             style: TextStyle(
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.w600,
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
//                         )
//                       : Container(
//                           height: 0,
//                           color: Theme.of(context).primaryColor,
//                         );
//                 }
//               },
//             ),
//             // BuildItem(itemMaster: items.first, tableId: tableId, ip: ip),
//           ],
//         );
//       }
//       return Text('');
//     } else {
//       if (items.length > 0) {
//         return Column(
//           children: [
//             BlocBuilder<BlocOrder, StateOrder>(
//               builder: (context, state) {
//                 if (state.qty == null) {
//                   return Container(height: 0.0);
//                 } else {
//                   return state.allQty != 0.0
//                       ? Container(
//                           width: double.infinity,
//                           height: 60.0,
//                           color: Color.fromRGBO(230, 230, 230, 1),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   color: Colors.grey[400],
//                                   child: Text(
//                                     "${state.currency}  ${state.grandTotal.toStringAsFixed(2)}",
//                                     style: TextStyle(
//                                       fontSize: 20.0,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: InkWell(
//                                   onTap: () {
//                                     // Navigator.push(
//                                     //   context,
//                                     //   MaterialPageRoute(
//                                     //     builder: (context) =>
//                                     //         DetailSaleGroup(ip: ip),
//                                     //   ),
//                                     // );
//                                   },
//                                   child: Stack(
//                                     children: [
//                                       Container(
//                                         alignment: Alignment.center,
//                                         color: Colors.red,
//                                         child: Text(
//                                           AppLocalization.of(context)
//                                               .getTranValue('view_cart'),
//                                           style: TextStyle(
//                                             fontSize: 17.0,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         right: 0.0,
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           decoration: BoxDecoration(
//                                             color: Colors.grey[400],
//                                             borderRadius: BorderRadius.only(
//                                               bottomLeft: Radius.circular(16.0),
//                                             ),
//                                           ),
//                                           height: 30.0,
//                                           width: 60.0,
//                                           child: Text(
//                                             "${state.allQty.floor()}",
//                                             style: TextStyle(
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.w600,
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
//                         )
//                       : Container(
//                           height: 0,
//                           color: Theme.of(context).primaryColor,
//                         );
//                 }
//               },
//             ),
//             // BuildItem(itemMaster: items.first, tableId: tableId, ip: ip),
//           ],
//         );
//       }
//       return Text('');
//     }
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     ItemController.searchItem(query, ip).then((value) {
//       ls = [];
//       ls.addAll(value);
//     });
//     return ls.isEmpty
//         ? Center(
//             child: Text(
//               AppLocalization.of(context).getTranValue('no_result_found'),
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.black,
//               ),
//             ),
//           )
//         : ListView(
//             children: [
//               BlocBuilder<BlocOrder, StateOrder>(
//                 builder: (context, state) {
//                   if (state.qty == null) {
//                     return Container(height: 0.0);
//                   } else {
//                     return state.allQty != 0.0
//                         ? Container(
//                             width: double.infinity,
//                             height: 60.0,
//                             color: Color.fromRGBO(230, 230, 230, 1),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     color: Colors.grey[400],
//                                     child: Text(
//                                       '${state.currency}  ${state.grandTotal.toStringAsFixed(2)}',
//                                       style: TextStyle(
//                                         fontSize: 20.0,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: InkWell(
//                                     onTap: () {
//                                       // Navigator.push(
//                                       //   context,
//                                       //   MaterialPageRoute(
//                                       //     builder: (context) =>
//                                       //         DetailSaleGroup(ip: ip),
//                                       //   ),
//                                       // );
//                                     },
//                                     child: Stack(
//                                       children: [
//                                         Container(
//                                           alignment: Alignment.center,
//                                           color: Colors.red,
//                                           child: Text(
//                                             AppLocalization.of(context)
//                                                 .getTranValue('view_cart'),
//                                             style: TextStyle(
//                                               fontSize: 17.0,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           right: 0.0,
//                                           child: Container(
//                                             alignment: Alignment.center,
//                                             decoration: BoxDecoration(
//                                               color: Colors.grey[400],
//                                               borderRadius: BorderRadius.only(
//                                                 bottomLeft:
//                                                     Radius.circular(16.0),
//                                               ),
//                                             ),
//                                             height: 30.0,
//                                             width: 60.0,
//                                             child: Text(
//                                               "${state.allQty.floor()}",
//                                               style: TextStyle(
//                                                 fontSize: 15.0,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : Container(
//                             height: 0, color: Theme.of(context).primaryColor);
//                   }
//                 },
//               ),
//               SizedBox(height: 13.0),
//               ListView(
//                 shrinkWrap: true,
//                 physics: ScrollPhysics(),
//                 children: ls.map((e) {
//                   return Column(
//                     children: [
//                       ListTile(
//                         onTap: () {
//                           showResults(context);
//                           items = [];
//                           items.add(e);
//                         },
//                         leading: Container(
//                           height: 60.0,
//                           width: 60.0,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: NetworkImage(
//                                 '${ip + '/Images/items/' + e.image}',
//                               ),
//                             ),
//                             color: Colors.blue[50],
//                             borderRadius: BorderRadius.circular(3.0),
//                           ),
//                         ),
//                         title: Text(
//                           '${e.itemName}',
//                           style: TextStyle(
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       Divider(color: Colors.grey, indent: 90.0),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ],
//           );
//   }
// }
