// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:date_time_picker/date_time_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_session/flutter_session.dart';
// import 'package:intl/intl.dart';
// import 'package:point_of_sale/src/controllers/receipt_contoller.dart';
// import 'package:point_of_sale/src/controllers/summary_sale_controller.dart';
// import 'package:point_of_sale/src/helpers/app_localization.dart';
// import 'package:point_of_sale/src/helpers/show_message.dart';
// import 'package:point_of_sale/src/models/receipt_model.dart';
// import 'package:point_of_sale/src/models/summary_sale_model.dart';

// class SummarySale extends StatefulWidget {
//   final String ip;

//   const SummarySale({Key key, @required this.ip}) : super(key: key);
//   @override
//   _SummarySaleState createState() => _SummarySaleState();
// }

// class _SummarySaleState extends State<SummarySale> {
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   TextEditingController _dFController;
//   TextEditingController _dTController;
//   var _f = NumberFormat('#,##0.00');
//   //-----

//   List<ReceiptModel> _receiptList = [];
//   List<SummarySaleModel> _summarySaleList = [];
//   bool _status = false;

//   _getReceiptSummary(String dateF, String dateT) async {
//     bool _result = await DataConnectionChecker().hasConnection;
//     if (_result) {
//       try {
//         var userId = await FlutterSession().get('userId');
//         var branchId = await FlutterSession().get('branchId');
//         await ReceiptController.getReceipt(dateF, dateT, widget.ip)
//             .then((value) {
//           if (mounted) {
//             setState(() => _receiptList.addAll(value));
//           }
//         });
//         await SummarySaleController.getSummarySale(
//                 dateF, dateT, '0', '0', branchId, userId, 'SP', widget.ip)
//             .then((value) {
//           if (mounted) {
//             setState(() => _summarySaleList.addAll(value));
//           }
//         });
//       } finally {
//         _status = true;
//         print('Status = $_status');
//         print('Receipt List = $_receiptList');
//         print('Summary List = $_summarySaleList');
//       }
//     } else {
//       ShowMessage.showMessageSnakbar(
//           AppLocalization.of(context).getTranValue('no_internet'), context);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _dFController = TextEditingController(
//         text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
//     _dTController = TextEditingController(
//         text: DateFormat("yyyy-MM-dd").format(DateTime.now()));

//     _getReceiptSummary(_dFController.text, _dTController.text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           AppLocalization.of(context).getTranValue('summary_receipt'),
//         ),
//       ),
//       body: _status
//           ? ListView(
//               children: [
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Row(
//                           children: [
//                             Flexible(
//                               child: DateTimePicker(
//                                 type: DateTimePickerType.date,
//                                 dateMask: 'dd-MMMM-yyyy',
//                                 controller: _dFController,
//                                 firstDate: DateTime(2000),
//                                 lastDate: DateTime(2100),
//                                 dateLabelText: AppLocalization.of(context)
//                                     .getTranValue('date_from'),
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             Flexible(
//                               child: DateTimePicker(
//                                 type: DateTimePickerType.date,
//                                 dateMask: 'dd-MMMM-yyyy',
//                                 controller: _dTController,
//                                 firstDate: DateTime(2000),
//                                 lastDate: DateTime(2100),
//                                 dateLabelText: AppLocalization.of(context)
//                                     .getTranValue('date_to'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: MaterialButton(
//                                 color: Theme.of(context).primaryColor,
//                                 onPressed: () {
//                                   final loForm = _formKey.currentState;
//                                   if (loForm.validate() == true) {
//                                     loForm.save();
//                                     _receiptList.clear();
//                                     _getReceiptSummary(
//                                         _dFController.text, _dTController.text);
//                                     _receiptList.isNotEmpty &&
//                                             _summarySaleList.isNotEmpty
//                                         ? _status = true
//                                         : _status = false;
//                                   }
//                                 },
//                                 child: Text(
//                                   AppLocalization.of(context)
//                                       .getTranValue('filter'),
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 5),
//                             Expanded(
//                               child: MaterialButton(
//                                 color: Theme.of(context).primaryColor,
//                                 onPressed: () {
//                                   final loForm = _formKey.currentState;
//                                   loForm.reset();
//                                   _dFController = TextEditingController(
//                                       text: DateFormat("yyyy-MM-dd")
//                                           .format(DateTime.now()));
//                                   _dTController = TextEditingController(
//                                       text: DateFormat("yyyy-MM-dd")
//                                           .format(DateTime.now()));
//                                   _receiptList.clear();
//                                   _getReceiptSummary(
//                                       _dFController.text, _dTController.text);
//                                   _receiptList.isNotEmpty &&
//                                           _summarySaleList.isNotEmpty
//                                       ? _status = true
//                                       : _status = false;
//                                 },
//                                 child: Text(
//                                   AppLocalization.of(context)
//                                       .getTranValue('reset'),
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 15.0),
//                 _receiptList.isNotEmpty && _summarySaleList.isNotEmpty
//                     ? Column(
//                         children: [
//                           Divider(height: 0.0, color: Colors.grey),
//                           ListView.separated(
//                             shrinkWrap: true,
//                             physics: ScrollPhysics(),
//                             itemCount: _receiptList.length,
//                             itemBuilder: (context, index) {
//                               return InkWell(
//                                 onTap: () {
//                                   print('Card Taped at index $index');
//                                 },
//                                 child: Container(
//                                   height: 40.0,
//                                   width: double.infinity,
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text(
//                                           "#${_receiptList[index].receiptNo}",
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 4,
//                                         child: Text(
//                                           "(${DateFormat("dd-MM-yyyy").format(DateTime.parse(_receiptList[index].dateIn))} ${_receiptList[index].timeIn})",
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 3,
//                                         child: Row(
//                                           children: [
//                                             Text(
//                                               "${_summarySaleList.first.currency}",
//                                               style: TextStyle(fontSize: 13.0),
//                                             ),
//                                             SizedBox(width: 1.0),
//                                             Text(
//                                               "${_f.format(_receiptList[index].grandTotal)}",
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                             separatorBuilder: (context, index) {
//                               return Divider(height: 0.0, color: Colors.grey);
//                             },
//                           ),
//                           Divider(height: 0.0, color: Colors.grey),
//                         ],
//                       )
//                     : Container(
//                         height: 300.0,
//                         child: Center(
//                           child: Center(
//                             child: Text(
//                               AppLocalization.of(context)
//                                   .getTranValue('no_receipt'),
//                               style: TextStyle(fontSize: 17),
//                             ),
//                           ),
//                         ),
//                       ),
//                 _receiptList.length > 5
//                     ? Container(
//                         height: 190.0,
//                         child: Column(
//                           children: [
//                             Expanded(
//                               flex: 1,
//                               child: Container(
//                                 color: Theme.of(context).primaryColor,
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Container(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceAround,
//                                           children: [
//                                             Text(
//                                               '${DateFormat("dd-MM-yyyy").format(DateTime.parse(_dFController.text))}',
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             Icon(Icons.arrow_right_alt,
//                                                 color: Colors.white,
//                                                 size: 40.0),
//                                             Text(
//                                               '${DateFormat("dd-MM-yyyy").format(DateTime.parse(_dTController.text))}',
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               flex: 4,
//                               child: Container(
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 3,
//                                       child: Container(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceAround,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Discount Item',
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                             Text(
//                                               'Discount Total',
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                             Text(
//                                               'Vat.Included',
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                             Text(
//                                               'Grand Total SSC',
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                             Text(
//                                               'Grand Total LCC',
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       width: 5,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             ':',
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           Text(
//                                             ':',
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           Text(
//                                             ':',
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           Text(
//                                             ':',
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           Text(
//                                             ':',
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex: 6,
//                                       child: Container(
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 5, right: 5),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceAround,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 '${_summarySaleList.last.sDiscountItem}',
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.w500),
//                                               ),
//                                               Text(
//                                                 '${_summarySaleList.last.sDiscountTotal}',
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.w500),
//                                               ),
//                                               Text(
//                                                 '${_summarySaleList.last.sVat}',
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.w500),
//                                               ),
//                                               Text(
//                                                 '${_summarySaleList.last.sGrandTotalSys}',
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.w500),
//                                               ),
//                                               Text(
//                                                 '${_summarySaleList.last.sGrandTotal}',
//                                                 style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight:
//                                                         FontWeight.w500),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : Container(height: 0.0)
//               ],
//             )
//           : Center(
//               child: CircularProgressIndicator(),
//             ),
//       bottomNavigationBar: _status
//           ? _receiptList.length <= 5 && _receiptList.isNotEmpty
//               ? Container(
//                   height: 190.0,
//                   child: Column(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Container(
//                           color: Theme.of(context).primaryColor,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: Container(
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       Text(
//                                         '${DateFormat("dd-MM-yyyy").format(DateTime.parse(_dFController.text))}',
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Icon(Icons.arrow_right_alt,
//                                           color: Colors.white, size: 40.0),
//                                       Text(
//                                         '${DateFormat("dd-MM-yyyy").format(DateTime.parse(_dTController.text))}',
//                                         style: TextStyle(
//                                             fontSize: 16.0,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 4,
//                         child: Container(
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 3,
//                                 child: Container(
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Discount Item',
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         'Discount Total',
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         'Vat.Included',
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         'Grand Total SSC',
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         'Grand Total LCC',
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 width: 5,
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       ':',
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     Text(
//                                       ':',
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     Text(
//                                       ':',
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     Text(
//                                       ':',
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     Text(
//                                       ':',
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 6,
//                                 child: Container(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 5, right: 5),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           '${_summarySaleList.last.sDiscountItem}',
//                                           style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                         Text(
//                                           '${_summarySaleList.last.sDiscountTotal}',
//                                           style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                         Text(
//                                           '${_summarySaleList.last.sVat}',
//                                           style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                         Text(
//                                           '${_summarySaleList.last.sGrandTotalSys}',
//                                           style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                         Text(
//                                           '${_summarySaleList.last.sGrandTotal}',
//                                           style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                       ],
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
//                 )
//               : Container(height: 0)
//           : Container(height: 0),
//     );
//   }
// }
