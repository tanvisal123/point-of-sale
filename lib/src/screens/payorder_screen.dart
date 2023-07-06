// import 'dart:typed_data';
// import 'package:awesome_dropdown/awesome_dropdown.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_session/flutter_session.dart';
// import 'package:image/image.dart';
// import 'package:intl/intl.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/bloc_order.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/event_order.dart';
// import 'package:point_of_sale/src/controllers/display_currency_controller.dart';
// import 'package:point_of_sale/src/controllers/open_shift_controller.dart';
// import 'package:point_of_sale/src/controllers/payment_mean_controller.dart';
// import 'package:point_of_sale/src/controllers/post_order_to_server.dart';
// import 'package:point_of_sale/src/controllers/price_list_controller.dart';
// import 'package:point_of_sale/src/controllers/receipt_contoller.dart';
// import 'package:point_of_sale/src/controllers/receipt_information_controller.dart';
// import 'package:point_of_sale/src/controllers/sale_controller.dart';
// import 'package:point_of_sale/src/controllers/setting_controller.dart';
// import 'package:point_of_sale/src/helpers/app_localization.dart';
// import 'package:point_of_sale/src/helpers/printers/widget_to_image.dart';
// import 'package:point_of_sale/src/models/display_currency_modal.dart';
// import 'package:point_of_sale/src/models/order_modal.dart';
// import 'package:point_of_sale/src/models/post_server_modal.dart';
// import 'package:point_of_sale/src/models/price_list_modal.dart';
// import 'package:point_of_sale/src/models/receipt_information.dart';
// import 'package:point_of_sale/src/models/series_model.dart';
// import 'package:point_of_sale/src/models/setting_modal.dart';
// import 'package:point_of_sale/src/models/table_ordered.dart';
// import 'package:point_of_sale/src/printers/print_payment.dart';
// import 'package:point_of_sale/src/screens/sale_group_screen.dart';
// import 'package:point_of_sale/src/screens/table_group_screen.dart';
// import 'package:point_of_sale/src/widgets/custom_textfield_.dart';
// import 'package:point_of_sale/src/helpers/show_message.dart';
// import 'package:point_of_sale/src/models/order_detail_modal.dart';
// import 'package:point_of_sale/src/models/payment_means_modal.dart';
// import 'package:point_of_sale/src/screens/payment_success.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import '../printers/build_payment_recipt.dart';
// import 'package:image/image.dart' as imgx;

// class PayOrderScreen extends StatefulWidget {
//   final String ip;
//   const PayOrderScreen({@required this.ip});
//   @override
//   _State createState() => _State();
// }

// String received = '0.00';
// String chang = '0.00';

// class _State extends State<PayOrderScreen> {
//   PrintPayment _printPayment;
//   SaleController _sale = SaleController();
//   SeriesModel _seriesModel = SeriesModel();
//   TableOrdered _tableOrdered = TableOrdered();
//   var customerName;
//   List<OrderModel> _orderLs = [];
//   List<OrderDetail> _detailLs = [];
//   List<PriceList> _priceLs = [];
//   List<PaymentMeanModel> _paymeanLs = [];
//   List<SettingModel> _settingList = [];
//   List<DisplayCurrModel> _displayCurrLs = [];
//   List<ReceiptInformation> _receiptInfoLs = [];
//   List<String> _payList = [];
//   String _payBy = '';

//   bool _connection, _status = false;
//   var _userName, _userId, _sysType;
//   double _total = 0.0, _rate = 0.0;
//   var _currency = '', _altCurr = '';
//   var _baseTotal = TextEditingController();
//   var _altTotal = TextEditingController();
//   var _received = TextEditingController();
//   var _baseChange = TextEditingController();
//   var _altChange = TextEditingController();
//   var _baseInput = TextEditingController();
//   var _altInput = TextEditingController();
//   var _f = NumberFormat('#,##0.00');
//   Uint8List _bytes;
//   GlobalKey _key1;
//   var ip;
//   var printer;
//   // Widget buildImage(bytes) => bytes != null
//   //     ? SizedBox(
//   //         width: 250,
//   //         child: Image.memory(bytes),
//   //       )
//   //     : SizedBox(height: 0, width: 0);
//   Uint8List resizeImage1(Uint8List data) {
//     Uint8List resizedData = data;
//     imgx.Image img = imgx.decodeImage(data);
//     imgx.Image resized = imgx.copyResize(img, width: 500);
//     resizedData = imgx.encodeJpg(resized);
//     return resizedData;
//   }

//   Future<void> printDemoReceipt(NetworkPrinter printer) async {
//     // Print image
//     final Uint8List bytes = resizeImage1(_bytes);
//     final image = decodeImage(bytes);
//     printer.image(image);
//     printer.feed(1);
//     printer.cut();
//   }

//   void testPrint(String printerIp, BuildContext ctx) async {
//     const PaperSize paper = PaperSize.mm80;
//     final profile = await CapabilityProfile.load();
//     final printer = NetworkPrinter(paper, profile);

//     final PosPrintResult res = await printer.connect(printerIp, port: 9100);

//     if (res == PosPrintResult.success) {
//       // DEMO RECEIPT
//       await printDemoReceipt(printer);
//       // TEST PRINT
//       // await testReceipt(printer);
//       printer.disconnect();
//     }

//     final snackBar =
//         SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
//     ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
//   }

//   Future<void> _getPrinter() async {
//     var _prefs = await SharedPreferences.getInstance();
//     printer = _prefs.getString("printer");
//     customerName = _prefs.getString("customerName");
//     print("Printer name : $printer");
//   }

//   void getIp() async {
//     var _prefs = await SharedPreferences.getInstance();
//     ip = _prefs.getString('ipAdrress');
//     print('Ip address: $ip');
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getUser();
//     _getAll();
//     _getPrinter();
//     getIp();
//   }

//   Future<void> _getUser() async {
//     var _prefs = await SharedPreferences.getInstance();
//     _userName = await FlutterSession().get('userName');
//     _userId = await FlutterSession().get('userId');
//     _sysType = _prefs.getString('systemType');
//   }

//   Future<void> _getAll() async {
//     _connection = await DataConnectionChecker().hasConnection;
//     if (_connection) {
//       try {
//         await SaleController().selectOrder().then((value) {
//           if (mounted) setState(() => _orderLs.addAll(value));
//         });

//         await SaleController().selectOrderDetail().then((value) {
//           if (mounted) setState(() => _detailLs.addAll(value));
//           _detailLs.forEach((element) {
//             print('Total    = ${element.total}');
//             print('TotalSys = ${element.totalSys}');
//           });
//         });

//         await PaymentMeanController.getPaymenyMean(widget.ip).then((value) {
//           setState(() {
//             _paymeanLs.addAll(value);
//             if (_paymeanLs.isEmpty) {
//               print('Payment is Null');
//             } else {
//               print('Payment is not null');
//               _paymeanLs.forEach((element) {
//                 _payList.add(element.type);
//               });
//               _payBy = _payList.first;
//             }
//           });
//         });

//         await DisplayCurrController.getDisplayCurr(widget.ip).then((value) {
//           setState(() {
//             _displayCurrLs.addAll(value);
//             if (_displayCurrLs.isEmpty) {
//               print('DisCurr is Null');
//             } else {
//               print('DisCurr is Not Null');
//               _altCurr = value.first.altCurr;
//               _currency = value.first.baseCurr;
//               _rate = value.first.rate;
//             }
//           });
//         });

//         await SettingController.getSetting(widget.ip).then((value) {
//           setState(() {
//             _settingList.addAll(value);
//             if (_settingList.isEmpty) {
//               print('Seeting is Null');
//             } else {
//               print('Setting is Not Null');
//             }
//           });
//         });

//         await PriceListController.eachPriceList(widget.ip).then((value) {
//           if (mounted) setState(() => _priceLs.addAll(value));
//         });

//         await ReceiptInformationController.eachRI(widget.ip).then((value) {
//           if (mounted) setState(() => _receiptInfoLs.addAll(value));
//           print('Logo : ${_receiptInfoLs.first.logo}');
//         });

//         await ReceiptController.getSeries(widget.ip).then((value) {
//           if (mounted) setState(() => _seriesModel = value);
//         });

//         await ReceiptController.getTableOrdered(
//                 _orderLs.first.tableId, widget.ip)
//             .then((value) {
//           if (mounted) setState(() => _tableOrdered = value);
//           print(_tableOrdered.id.toString() + '' + _tableOrdered.name);
//         });
//         //----------------------------
//         _printPayment = PrintPayment(
//           cashier: _userName ?? '',
//           receiptNo:
//               (double.parse(_seriesModel.nextNo)).toStringAsFixed(0) ?? '',
//           table: _tableOrdered.name ?? 'Table',
//           queue: _orderLs.first.orderNo ?? 'Queue',
//           orderDetailList: _detailLs ?? '',
//           subTotal: _orderLs.first.subTotal ?? 0.00,
//           discount: _orderLs.first.discountValue ?? 0.00,
//           grandTotal: _orderLs.first.grandTotal ?? 0.00,
//           currency: _currency ?? 'CURRENCY',
//           branchName: _receiptInfoLs.first.branchName ?? 'Branch Name',
//           title: _receiptInfoLs.first.title ?? 'RECEIPT',
//           address: _receiptInfoLs.first.address ?? '........',
//           desEnglish: _receiptInfoLs.first.desEnglish ?? '.......',
//           deskhmer: _receiptInfoLs.first.deskhmer ?? '.......',
//           phone1: _receiptInfoLs.first.phone1 ?? '--',
//           phone2: _receiptInfoLs.first.phone2 ?? '--',
//           wifi: _settingList.first.wifi ?? '',
//         );
//       } catch (e) {
//         print('Error Get All : $e');
//       } finally {
//         _status = true;
//       }
//     } else {
//       ShowMessage.showMessageSnakbar('No internet connection', context);
//     }
//   }

// //-----------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     var _translat = AppLocalization.of(context);
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(AppLocalization.of(context).getTranValue('pay')),
//         centerTitle: true,
//       ),
//       body: _status
//           ? SingleChildScrollView(
//               child: Container(
//                 margin: EdgeInsets.only(bottom: 3.0),
//                 width: double.infinity,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         AwesomeDropDown(
//                           dropDownIcon:
//                               const Icon(Icons.arrow_drop_down_circle_outlined),
//                           selectedItemTextStyle:
//                               const TextStyle(fontSize: 20.0),
//                           dropDownListTextStyle: const TextStyle(
//                             fontSize: 20.0,
//                             height: 2.0,
//                           ),
//                           isBackPressedOrTouchedOutSide: false,
//                           numOfListItemToShow: _payList.length,
//                           selectedItem: _payBy,
//                           dropDownBorderRadius: 5.0,
//                           dropDownBottomBorderRadius: 5.0,
//                           dropDownTopBorderRadius: 5.0,
//                           dropDownOverlayBGColor: Colors.grey[100],
//                           isPanDown: true,
//                           onDropDownItemClick: (value) {
//                             setState(() {
//                               _payBy = value;
//                               print('Item = $_payBy');
//                             });
//                           },
//                           dropDownList: _payList,
//                         ),
//                         SizedBox(height: 2.0),
//                         BlocBuilder<BlocOrder, StateOrder>(
//                           builder: (context, state) {
//                             _total = state.grandTotal;
//                             _currency = state.currency;
//                             _baseTotal.text = _f.format(_total);
//                             _altTotal.text =
//                                 (_total * _rate).toStringAsFixed(2);
//                             _received.text = _f.format(0.00);
//                             _baseChange.text = _f
//                                 .format(double.parse(_received.text) - _total);
//                             _altChange.text = _f.format(
//                                 (double.parse(_received.text) * _rate -
//                                     double.parse(_altTotal.text)));

//                             return Column(
//                               children: [
//                                 CustomTextField(
//                                   controller: _baseTotal,
//                                   leading: Text(_translat.getTranValue('total'),
//                                       style: TextStyle(fontSize: 18)),
//                                   currency: _currency,
//                                 ),
//                                 CustomTextField(
//                                   controller: _altTotal,
//                                   leading: Text(_translat.getTranValue('total'),
//                                       style: TextStyle(fontSize: 18)),
//                                   currency: _altCurr,
//                                 ),
//                                 CustomTextField(
//                                   controller: _baseInput,
//                                   color: Colors.green[100],
//                                   hintext: '0',
//                                   isFocus: true,
//                                   isReadOnly: false,
//                                   textInputType: TextInputType.number,
//                                   leading: Text(_translat.getTranValue('cash'),
//                                       style: TextStyle(fontSize: 18)),
//                                   currency: _currency,
//                                   onChange: (value) {
//                                     try {
//                                       if (_altInput.text != '' && value != '') {
//                                         _received.text = (double.parse(value) +
//                                                 (double.parse(_altInput.text) /
//                                                     _rate))
//                                             .toStringAsFixed(2);
//                                         _baseChange.text = (double.parse(
//                                                     _received.text) -
//                                                 double.parse(_baseTotal.text))
//                                             .toStringAsFixed(2);
//                                         _altChange.text = ((double.parse(
//                                                         _received.text) *
//                                                     _rate) -
//                                                 double.parse(_altTotal.text))
//                                             .toStringAsFixed(2);
//                                       } else if (_altInput.text == '' &&
//                                           value != '') {
//                                         _received.text = double.parse(value)
//                                             .toStringAsFixed(2);
//                                         _baseChange.text = _f.format(
//                                             (double.parse(value) - _total));

//                                         _altChange.text = _f.format(
//                                             ((double.parse(_received.text) *
//                                                     _rate) -
//                                                 double.parse(_altTotal.text)));
//                                       } else if (_altInput.text != '' &&
//                                           value == '') {
//                                         _received.text =
//                                             (double.parse(_altInput.text) /
//                                                     _rate)
//                                                 .toStringAsFixed(2);
//                                         _baseChange.text = _f.format(
//                                             (double.parse(_received.text) -
//                                                 _total));

//                                         _altChange.text = _f.format(
//                                             (double.parse(_received.text) *
//                                                     _rate -
//                                                 double.parse(_altTotal.text)));
//                                       } else if (_altInput.text == '' &&
//                                           value == '') {
//                                         _received.text = '0.00';
//                                         _baseChange.text =
//                                             (double.parse(_received.text) -
//                                                     _total)
//                                                 .toStringAsFixed(2);
//                                         _altChange.text = (double.parse(
//                                                         _received.text) *
//                                                     _rate -
//                                                 double.parse(_altTotal.text))
//                                             .toStringAsFixed(2);
//                                       }
//                                     } catch (e) {
//                                       if (_altInput.text != '' && value != '') {
//                                         _received.text = (double.parse(value) +
//                                                 (double.parse(_altInput.text) /
//                                                     _rate))
//                                             .toStringAsFixed(2);
//                                         _baseChange.text = (double.parse(
//                                                     _received.text) -
//                                                 double.parse(_baseTotal.text))
//                                             .toStringAsFixed(2);
//                                         _altChange.text = ((double.parse(
//                                                         _received.text) *
//                                                     _rate) -
//                                                 double.parse(_altTotal.text))
//                                             .toStringAsFixed(2);
//                                       } else if (_altInput.text == '' &&
//                                           value != '') {
//                                         _received.text = double.parse(value)
//                                             .toStringAsFixed(2);
//                                         _baseChange.text = _f.format(
//                                             (double.parse(value) - _total));

//                                         _altChange.text = _f.format(
//                                             ((double.parse(_received.text) *
//                                                     _rate) -
//                                                 double.parse(_altTotal.text)));
//                                       } else if (_altInput.text != '' &&
//                                           value == '') {
//                                         _received.text =
//                                             (double.parse(_altInput.text) /
//                                                     _rate)
//                                                 .toStringAsFixed(2);
//                                         _baseChange.text = _f.format(
//                                             (double.parse(_received.text) -
//                                                 _total));

//                                         _altChange.text = _f.format(
//                                             (double.parse(_received.text) *
//                                                     _rate -
//                                                 double.parse(_altTotal.text)));
//                                       } else if (_altInput.text == '' &&
//                                           value == '') {
//                                         _received.text = '0.00';
//                                         _baseChange.text =
//                                             (double.parse(_received.text) -
//                                                     _total)
//                                                 .toStringAsFixed(2);
//                                         _altChange.text = (double.parse(
//                                                         _received.text) *
//                                                     _rate -
//                                                 double.parse(_altTotal.text))
//                                             .toStringAsFixed(2);
//                                       }
//                                     }
//                                   },
//                                 ),
//                                 CustomTextField(
//                                   onChange: (value) {
//                                     try {
//                                       if (_baseInput.text != '' &&
//                                           value != '') {
//                                         _received.text = (double.parse(value) /
//                                                     _rate +
//                                                 (double.parse(_baseInput.text)))
//                                             .toStringAsFixed(2);
//                                         _baseChange.text = (double.parse(
//                                                     _received.text) -
//                                                 double.parse(_baseTotal.text))
//                                             .toStringAsFixed(2);
//                                         _altChange.text = ((double.parse(
//                                                         _received.text) *
//                                                     _rate) -
//                                                 double.parse(_altTotal.text))
//                                             .toStringAsFixed(2);
//                                       } else if (_baseInput.text == '' &&
//                                           value != '') {
//                                         _received.text =
//                                             (double.parse(value) / _rate)
//                                                 .toStringAsFixed(2);
//                                         _baseChange.text = _f.format(
//                                             (double.parse(_received.text) -
//                                                 _total));

//                                         _altChange.text = _f.format(
//                                             (double.parse(value) -
//                                                 double.parse(_altTotal.text)));
//                                       } else if (_baseInput.text != '' &&
//                                           value == '') {
//                                         _received.text =
//                                             (double.parse(_baseInput.text))
//                                                 .toStringAsFixed(2);
//                                         _baseChange.text = _f.format(
//                                             (double.parse(_received.text) -
//                                                 _total));

//                                         _altChange.text = _f.format(
//                                             (double.parse(_received.text) *
//                                                     _rate) -
//                                                 double.parse(_altTotal.text));
//                                       } else if (_baseInput.text == '' &&
//                                           value == '') {
//                                         _received.text = '0.00';
//                                         _baseChange.text =
//                                             (double.parse(_received.text) -
//                                                     _total)
//                                                 .toStringAsFixed(2);
//                                         _altChange.text = (double.parse(
//                                                         _received.text) *
//                                                     _rate -
//                                                 double.parse(_altTotal.text))
//                                             .toStringAsFixed(2);
//                                       }
//                                     } catch (e) {
//                                       if (_baseInput.text != '' &&
//                                           value != '') {
//                                         _received.text = (double.parse(value) /
//                                                     _rate +
//                                                 (double.parse(_baseInput.text)))
//                                             .toStringAsFixed(2);
//                                         _baseChange.text = (double.parse(
//                                                     _received.text) -
//                                                 double.parse(_baseTotal.text))
//                                             .toStringAsFixed(2);
//                                         _altChange.text = ((double.parse(
//                                                         _received.text) *
//                                                     _rate) -
//                                                 double.parse(_altTotal.text))
//                                             .toStringAsFixed(2);
//                                       } else if (_baseInput.text == '' &&
//                                           value != '') {
//                                         _received.text =
//                                             (double.parse(value) / _rate)
//                                                 .toStringAsFixed(2);
//                                         _baseChange.text = _f.format(
//                                             (double.parse(_received.text) -
//                                                 _total));

//                                         _altChange.text = _f.format(
//                                             (double.parse(value) -
//                                                 double.parse(_altTotal.text)));
//                                       } else if (_baseInput.text != '' &&
//                                           value == '') {
//                                         _received.text =
//                                             (double.parse(_baseInput.text))
//                                                 .toStringAsFixed(2);
//                                         _baseChange.text = _f.format(
//                                             (double.parse(_received.text) -
//                                                 _total));

//                                         _altChange.text = _f.format(
//                                             (double.parse(_received.text) *
//                                                     _rate) -
//                                                 double.parse(_altTotal.text));
//                                       } else if (_baseInput.text == '' &&
//                                           value == '') {
//                                         _received.text = '0.00';
//                                         _baseChange.text =
//                                             (double.parse(_received.text) -
//                                                     _total)
//                                                 .toStringAsFixed(2);
//                                         _altChange.text = (double.parse(
//                                                         _received.text) *
//                                                     _rate -
//                                                 double.parse(_altTotal.text))
//                                             .toStringAsFixed(2);
//                                       }
//                                     }
//                                   },
//                                   controller: _altInput,
//                                   color: Colors.green[100],
//                                   hintext: '0',
//                                   isReadOnly: false,
//                                   textInputType: TextInputType.number,
//                                   leading: Text(_translat.getTranValue('cash'),
//                                       style: TextStyle(fontSize: 18)),
//                                   currency: _altCurr,
//                                 ),
//                                 CustomTextField(
//                                   controller: _received,
//                                   leading: Text(
//                                       _translat.getTranValue('received'),
//                                       style: TextStyle(fontSize: 18)),
//                                   currency: _currency,
//                                 ),
//                                 CustomTextField(
//                                   controller: _baseChange,
//                                   leading: Text(
//                                       _translat.getTranValue('changed'),
//                                       style: TextStyle(fontSize: 18)),
//                                   currency: _currency,
//                                 ),
//                                 CustomTextField(
//                                   controller: _altChange,
//                                   leading: Text(
//                                       _translat.getTranValue('changed'),
//                                       style: TextStyle(fontSize: 18)),
//                                   currency: _altCurr,
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           children: [
//                             printer == "network"
//                                 ? WidgetToImage(
//                                     builder: (key) {
//                                       _key1 = key;
//                                       return BuildPaymentRecipt(
//                                         payby: _payBy ?? 'N/A',
//                                         cashier: _userName ?? '',
//                                         receiptNo:
//                                             (double.parse(_seriesModel.nextNo))
//                                                     .toStringAsFixed(0) ??
//                                                 '',
//                                         table: _tableOrdered.name ?? 'Table',
//                                         queue:
//                                             _orderLs.first.orderNo ?? 'Queue',
//                                         orderDetailList: _detailLs ?? '',
//                                         subTotal:
//                                             _orderLs.first.subTotal ?? 0.00,
//                                         discount:
//                                             _orderLs.first.discountValue ??
//                                                 0.00,
//                                         grandTotal:
//                                             _orderLs.first.grandTotal ?? 0.00,
//                                         currency: _currency ?? 'CURRENCY',
//                                         branchName:
//                                             _receiptInfoLs.first.branchName ??
//                                                 'Branch Name',
//                                         title: _receiptInfoLs.first.title ??
//                                             'RECEIPT',
//                                         address: _receiptInfoLs.first.address ??
//                                             '........',
//                                         desEnglish:
//                                             _receiptInfoLs.first.desEnglish ??
//                                                 '.......',
//                                         deskhmer:
//                                             _receiptInfoLs.first.deskhmer ??
//                                                 '.......',
//                                         phone1:
//                                             _receiptInfoLs.first.phone1 ?? '--',
//                                         phone2:
//                                             _receiptInfoLs.first.phone2 ?? '--',
//                                         wifi: _settingList.first.wifi ?? '',
//                                         receviedController: _received == null
//                                             ? 0.00
//                                             : _received,
//                                         returnController: _baseChange == null
//                                             ? 0.00
//                                             : _baseChange,
//                                       );
//                                     },
//                                   )
//                                 : SizedBox(
//                                     height: 0,
//                                   ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             //buildImage(_bytes),
//                           ],
//                         ),
//                         // ElevatedButton(
//                         //     onPressed: () async {
//                         //       _bytes = await Utils.capture(_key1);
//                         //       setState(() {
//                         //         _bytes = _bytes;
//                         //       });
//                         //       testPrint(ip, context);
//                         //     },
//                         //     child: Text("Print"))
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : Center(
//               child: CircularProgressIndicator(
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//       bottomNavigationBar: SizedBox(
//         height: 55.0,
//         child: MaterialButton(
//             color: Theme.of(context).primaryColor,
//             child: Text(
//               _translat.getTranValue('confirm'),
//               style: TextStyle(
//                 fontSize: 19.0,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             onPressed: () async {
//               double _cashReceived = double.parse(_received.text);
//               if (_cashReceived >= _total) {
//                 _orderLs.first.paymentType = _payBy;
//                 _orderLs.first.receivedType = _payBy;
//                 _orderLs.first.received = double.parse(_received.text);
//                 if (_cashReceived > _total) {
//                   _orderLs.first.change = _cashReceived - _total;
//                 }
//                 _sale.updateOrder(_orderLs.first);
//                 _confirmOrder(context);
//               } else {
//                 _dialoadOK(
//                   context,
//                   _translat.getTranValue('insufficient_payment'),
//                 );
//               }
//             }

//             // if (_cashReceived >= _total && printer == 'network') {
//             //   _orderLs.first.paymentType = _payBy;
//             //   _orderLs.first.receivedType = _payBy;
//             //   _orderLs.first.received = double.parse(_received.text);
//             //   if (_cashReceived > _total) {
//             //     _orderLs.first.change = _cashReceived - _total;
//             //   }
//             //   _sale.updateOrder(_orderLs.first);
//             //   _confirmOrder(context);
//             //   _bytes = await Utils.capture(_key1);
//             //   setState(() {
//             //     _bytes = _bytes;
//             //   });
//             //   testPrint(ip, context);
//             // } else {
//             //   _dialoadOK(
//             //     context,
//             //     _translat.getTranValue('insufficient_payment'),
//             //   );
//             // }
//             // if (_cashReceived >= _total && printer == "sunmi") {
//             //   _orderLs.first.paymentType = _payBy;
//             //   _orderLs.first.receivedType = _payBy;
//             //   _orderLs.first.received = double.parse(_received.text);
//             //   if (_cashReceived > _total) {
//             //     _orderLs.first.change = _cashReceived - _total;
//             //   }
//             //   _sale.updateOrder(_orderLs.first);
//             //   _confirmOrder(context);
//             // } else if (_cashReceived < _total) {
//             //   _dialoadOK(
//             //     context,
//             //     _translat.getTranValue('insufficient_payment'),
//             //   );
//             // } else if (printer == "null") {
//             //   showDialog(
//             //     context: context,
//             //     builder: (BuildContext context) => AlertDialog(
//             //       content: const Text("please select printer for print"),
//             //       actions: <Widget>[
//             //         TextButton(
//             //           onPressed: () => Navigator.pop(context, 'OK'),
//             //           child: const Text('OK'),
//             //         ),
//             //       ],
//             //     ),
//             //   );
//             // }
//             ),
//       ),
//     );
//   }

//   Future<void> _dialoadOK(BuildContext context, String desc) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Text(
//             '$desc',
//             style: TextStyle(fontSize: 18, color: Colors.black),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 _sale.selectOrder().then((value) {
//                   value.first.credit = 0.0;
//                   _sale.updateOrder(value.first);
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text(AppLocalization.of(context).getTranValue('retry')),
//             )
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _confirmOrder(BuildContext context) async {
//     var _translat = AppLocalization.of(context);
//     //var _selectOpenShift = await CheckOpenShiftController().selectOpenShift();
//     var _checkOpenShift = await OpenShiftController.checkOpenShift(widget.ip);
//     if (_checkOpenShift.length > 0) {
//       ShowMessage.showLoading(context, _translat.getTranValue('loading'));
//       //---------slow this---------
//       var _data = await PostOrder()
//           .beforPost('Pay', widget.ip, _userId, _orderLs, _detailLs, _sysType);
//       _detailLs.forEach((element) {
//         print('Dis Rate = ' + element.discountRate.toString());
//       });
//       //-----------------------------
//       if (_data.status == 'T') {
//         if (_data.data.length > 0) {
//           Navigator.pop(context);
//           // // Navigator.push(
//           // //   context,
//           // //   MaterialPageRoute(
//           // //     builder: (context) => NotEnoughStockScreen(
//           // //       lsItemReturn: _data.data,
//           // //     ),
//           // //   ),
//           // );
//         }
//         // has stock----
//         else {
//           received = _received.text;
//           chang = _baseChange.text;
//           //---------start prin Payment----------
//           await _printPayment.startPrintPayment(
//               _payBy,
//               double.parse(received.isEmpty ? '0.00' : received),
//               chang.isEmpty ? '0.00' : chang,
//               _sysType,
//               customerName: customerName);
//           //-----------------------------------------------------------
//           var _setting = await SettingController.getSetting(widget.ip);
//           if (_setting.first.printReceiptTender) {
//             if (_sysType == 'KRMS') {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => TableScreen(ip: widget.ip),
//                 ),
//                 (route) => false,
//               );
//             } else {
//               BlocProvider.of<BlocOrder>(context).add(EventOrder.delete());
//               print('End Pay');
//               Navigator.pop(context);
//               Navigator.pop(context);
//               Navigator.pop(context);
//               Navigator.pop(context);
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       SaleGroupScreen(type: 'G1', postList: [], ip: widget.ip),
//                 ),
//                 (route) => true,
//               );
//             }
//           } else {
//             // not print pay
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PaymentSuccess(
//                   mess: _translat.getTranValue('pay_success'),
//                   status: _data.status,
//                   ip: widget.ip,
//                 ),
//               ),
//               (route) => false,
//             );
//           }
//         }
//       } else {
//         // can't post to server
//         Navigator.pop(context);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PaymentSuccess(
//               mess: _translat.getTranValue('pay_wrong'),
//               status: _data.status,
//               ip: widget.ip,
//             ),
//           ),
//         );
//       }
//     } else {
//       ShowMessage.notOpenShift(
//         context,
//         _translat.getTranValue('open_shift_befor_pay'),
//         widget.ip,
//       );
//     }
//   }

//   void buildOrder(PostModel p) async {
//     var key = 0;
//     OrderModel order = new OrderModel(
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
//     p.detail.forEach((x) {
//       OrderDetail detail = OrderDetail(
//         masterId: key,
//         orderDetailId: x.orderDetailId,
//         orderId: x.orderId,
//         lineId: x.lineId,
//         itemId: x.itemId,
//         code: x.code,
//         khmerName: x.khmerName,
//         englishName: x.englishName,
//         qty: x.qty,
//         printQty: x.printQty,
//         unitPrice: x.unitPrice,
//         cost: x.cost,
//         discountRate: x.discountRate,
//         discountValue: x.discountValue,
//         typeDis: x.typeDis,
//         total: x.total,
//         totalSys: x.totalSys,
//         uomId: x.uomId,
//         uomName: x.uomName,
//         itemStatus: x.itemStatus,
//         itemPrintTo: x.itemPrintTo,
//         currency: x.currency,
//         comment: x.comment,
//         itemType: x.itemType,
//         description: x.description,
//         parentLevel: x.parentLevel,
//         image: x.image,
//         show: 0,
//       );
//       SaleController().insertOrderDetail(detail);
//     });
//   }
// }
