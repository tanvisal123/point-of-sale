import 'dart:convert';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as console;
import 'package:point_of_sale/src/controllers/check_privilege_conntroller.dart';
import 'package:point_of_sale/src/controllers/member_card_controller.dart';
import 'package:point_of_sale/src/controllers/member_card_controller/member_card_dis_controller.dart';
import 'package:point_of_sale/src/controllers/open_shift_controller.dart';
import 'package:point_of_sale/src/controllers/post_order_to_server.dart';
import 'package:point_of_sale/src/controllers/user_setting_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/member_card_discount.dart';
import 'package:point_of_sale/src/models/return_from_server_modal.dart';
import 'package:point_of_sale/src/models/user_setting_model.dart';
import 'package:point_of_sale/src/printers/print_payment.dart';
import 'package:point_of_sale/src/screens/item_not_enough_stock_screen.dart';
import 'package:point_of_sale/src/screens/sale_screen.dart';
import 'package:point_of_sale/src/screens/table_group_screen.dart';
import 'package:point_of_sale/src/widgets/custom_textfield_.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPaymentScreen extends StatefulWidget {
  final String ip;
  final FetchOrderModel fetchOrderModel;
  const NewPaymentScreen({Key key, this.ip, this.fetchOrderModel})
      : super(key: key);

  @override
  State<NewPaymentScreen> createState() => _NewPaymentScreenState();
}

class _NewPaymentScreenState extends State<NewPaymentScreen> {
  String paymentMeanId;
  //PrintPayment printPayment;
  double _total = 0.0, _rate = 0.0, grandTotal;
  bool _isButtonDisabled = false;
  var _baseCurr = '', _altCurr = '';
  var _baseTotal = TextEditingController();
  var _altTotal = TextEditingController();
  var _received = TextEditingController();
  var _baseChange = TextEditingController();
  var _altChange = TextEditingController();
  var _baseInput = TextEditingController();
  var _altInput = TextEditingController();
  var _f = NumberFormat('#,##0.00');
  var _connection;
  bool status = false;
  DisplayPayOtherCurrency currency;
  var userName, customer;
  String payBy;
  List<PaymentMeant> _payList = [];
  List<String> _selectPay = [];
  ReturnFromServers returnFromServers;
  UserSettingModel userSettingModel;
  FetchOrderModel fetchOrderModel;
  Order order;
  var systemType;
  void getPaymentMean() async {
    _connection = await DataConnectionChecker().hasConnection;
    if (_connection) {
      try {
        await UserSettingController().getUserSetting(widget.ip).then((value) {
          setState(() {
            userSettingModel = value;
            _payList = userSettingModel.paymentMeans;
            for (var temp in _payList) {
              _selectPay.add(temp.text);
            }
            payBy = _payList.first.text;
            paymentMeanId = _payList.first.value;
          });
        });
      } catch (e) {
        print('Error Get All : $e');
      } finally {
        status = true;
      }
    }
  }

  void getAll() async {
    var _pref = await SharedPreferences.getInstance();
    userName = _pref.getString("userName");
    systemType = _pref.getString("systemType");
    customer = _pref.getString("customerName");
    print("user name : $userName");
    setState(() {
      fetchOrderModel = widget.fetchOrderModel;
      order = fetchOrderModel.order;
      grandTotal = order.grandTotal;
      currency = fetchOrderModel.displayCurrency
          .firstWhere((element) => element.isActive);

      _rate = currency.altRate;
      _total = grandTotal;
      _baseTotal.text = _f.format(_total);
      _altTotal.text = (_total * _rate).toString();
      _baseCurr = currency.baseCurrency;
      // _received.text = _f.format(0.00);
      _baseInput.text = grandTotal.toString();
      _received.text = grandTotal.toString();
      _baseChange.text = _f.format(double.parse(_received.text) - _total);
      _altChange.text = _f.format((double.parse(_received.text) * _rate -
          double.parse(_altTotal.text)));
      _altCurr = currency.altCurrency;
    });
    print("customer name : $customer");
    print("order : ${order.orderNo}");
  }

  @override
  void initState() {
    super.initState();
    getAll();
    getPaymentMean();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(AppLocalization.of(context).getTranValue('pay')),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                _buildDiscountMember();
              },
              icon: Icon(Icons.group))
        ],
      ),
      body: status
          ? SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(bottom: 3.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        AwesomeDropDown(
                          dropDownIcon:
                              const Icon(Icons.arrow_drop_down_circle_outlined),
                          selectedItemTextStyle:
                              const TextStyle(fontSize: 20.0),
                          dropDownListTextStyle: const TextStyle(
                            fontSize: 20.0,
                            height: 2.0,
                          ),
                          isBackPressedOrTouchedOutSide: false,
                          numOfListItemToShow: _payList.length,
                          selectedItem: payBy,
                          dropDownBorderRadius: 5.0,
                          dropDownBottomBorderRadius: 5.0,
                          dropDownTopBorderRadius: 5.0,
                          dropDownOverlayBGColor: Colors.grey[100],
                          isPanDown: true,
                          onDropDownItemClick: (value) {
                            setState(() {
                              payBy = value;
                              var values = _payList.firstWhere(
                                  (element) => element.text == value);
                              paymentMeanId = values.value;
                              print("paymeant id : $paymentMeanId");
                            });
                            print("payment text : $payBy");
                          },
                          dropDownList: _selectPay,
                        ),
                        SizedBox(height: 2.0),
                        Column(
                          children: [
                            CustomTextField(
                              controller: _baseTotal,
                              leading:
                                  Text('Total', style: TextStyle(fontSize: 18)),
                              currency: _baseCurr,
                            ),
                            CustomTextField(
                              controller: _altTotal,
                              leading:
                                  Text("Total", style: TextStyle(fontSize: 18)),
                              currency: _altCurr,
                            ),
                            CustomTextField(
                              controller: _baseInput,
                              color: Colors.green[100],
                              hintext: '0',
                              isFocus: true,
                              isReadOnly: false,
                              textInputType: TextInputType.number,
                              leading:
                                  Text("Cash", style: TextStyle(fontSize: 18)),
                              currency: _baseCurr,
                              onChange: (value) {
                                try {
                                  if (_altInput.text != '' && value != '') {
                                    _received.text = (double.parse(value) +
                                            (double.parse(_altInput.text) /
                                                _rate))
                                        .toStringAsFixed(2);
                                    _baseChange.text =
                                        (double.parse(_received.text) -
                                                double.parse(_baseTotal.text))
                                            .toStringAsFixed(2);
                                    _altChange.text =
                                        ((double.parse(_received.text) *
                                                    _rate) -
                                                double.parse(_altTotal.text))
                                            .toStringAsFixed(2);
                                  } else if (_altInput.text == '' &&
                                      value != '') {
                                    _received.text =
                                        double.parse(value).toStringAsFixed(2);
                                    _baseChange.text = _f
                                        .format((double.parse(value) - _total));

                                    _altChange.text = _f.format(
                                        ((double.parse(_received.text) *
                                                _rate) -
                                            double.parse(_altTotal.text)));
                                  } else if (_altInput.text != '' &&
                                      value == '') {
                                    _received.text =
                                        (double.parse(_altInput.text) / _rate)
                                            .toStringAsFixed(2);
                                    _baseChange.text = _f.format(
                                        (double.parse(_received.text) -
                                            _total));

                                    _altChange.text = _f.format(
                                        (double.parse(_received.text) * _rate -
                                            double.parse(_altTotal.text)));
                                  } else if (_altInput.text == '' &&
                                      value == '') {
                                    _received.text = '0.00';
                                    _baseChange.text =
                                        (double.parse(_received.text) - _total)
                                            .toStringAsFixed(2);
                                    _altChange.text =
                                        (double.parse(_received.text) * _rate -
                                                double.parse(_altTotal.text))
                                            .toStringAsFixed(2);
                                  }
                                } catch (e) {
                                  if (_altInput.text != '' && value != '') {
                                    _received.text = (double.parse(value) +
                                            (double.parse(_altInput.text) /
                                                _rate))
                                        .toStringAsFixed(2);
                                    _baseChange.text =
                                        (double.parse(_received.text) -
                                                double.parse(_baseTotal.text))
                                            .toStringAsFixed(2);
                                    _altChange.text =
                                        ((double.parse(_received.text) *
                                                    _rate) -
                                                double.parse(_altTotal.text))
                                            .toStringAsFixed(2);
                                  } else if (_altInput.text == '' &&
                                      value != '') {
                                    _received.text =
                                        double.parse(value).toStringAsFixed(2);
                                    _baseChange.text = _f
                                        .format((double.parse(value) - _total));

                                    _altChange.text = _f.format(
                                        ((double.parse(_received.text) *
                                                _rate) -
                                            double.parse(_altTotal.text)));
                                  } else if (_altInput.text != '' &&
                                      value == '') {
                                    _received.text =
                                        (double.parse(_altInput.text) / _rate)
                                            .toStringAsFixed(2);
                                    _baseChange.text = _f.format(
                                        (double.parse(_received.text) -
                                            _total));
                                    _altChange.text = _f.format(
                                        (double.parse(_received.text) * _rate -
                                            double.parse(_altTotal.text)));
                                  } else if (_altInput.text == '' &&
                                      value == '') {
                                    _received.text = '0.00';
                                    _baseChange.text =
                                        (double.parse(_received.text) - _total)
                                            .toStringAsFixed(2);
                                    _altChange.text =
                                        (double.parse(_received.text) * _rate -
                                                double.parse(_altTotal.text))
                                            .toStringAsFixed(2);
                                  }
                                }
                              },
                            ),
                            CustomTextField(
                              onChange: (value) {
                                try {
                                  if (_baseInput.text != '' && value != '') {
                                    _received.text =
                                        (double.parse(value) / _rate +
                                                (double.parse(_baseInput.text)))
                                            .toStringAsFixed(2);
                                    _baseChange.text =
                                        (double.parse(_received.text) -
                                                double.parse(_baseTotal.text))
                                            .toStringAsFixed(2);
                                    _altChange.text =
                                        ((double.parse(_received.text) *
                                                    _rate) -
                                                double.parse(_altTotal.text))
                                            .toStringAsFixed(2);
                                  } else if (_baseInput.text == '' &&
                                      value != '') {
                                    _received.text =
                                        (double.parse(value) / _rate)
                                            .toStringAsFixed(2);
                                    _baseChange.text = _f.format(
                                        (double.parse(_received.text) -
                                            _total));
                                    _altChange.text = _f.format(
                                        (double.parse(value) -
                                            double.parse(_altTotal.text)));
                                  } else if (_baseInput.text != '' &&
                                      value == '') {
                                    _received.text =
                                        (double.parse(_baseInput.text))
                                            .toStringAsFixed(2);
                                    _baseChange.text = _f.format(
                                        (double.parse(_received.text) -
                                            _total));

                                    _altChange.text = _f.format(
                                        (double.parse(_received.text) * _rate) -
                                            double.parse(_altTotal.text));
                                  } else if (_baseInput.text == '' &&
                                      value == '') {
                                    _received.text = '0.00';
                                    _baseChange.text =
                                        (double.parse(_received.text) - _total)
                                            .toStringAsFixed(2);
                                    _altChange.text =
                                        (double.parse(_received.text) * _rate -
                                                double.parse(_altTotal.text))
                                            .toStringAsFixed(2);
                                  }
                                } catch (e) {
                                  if (_baseInput.text != '' && value != '') {
                                    _received.text =
                                        (double.parse(value) / _rate +
                                                (double.parse(_baseInput.text)))
                                            .toStringAsFixed(2);
                                    _baseChange.text =
                                        (double.parse(_received.text) -
                                                double.parse(_baseTotal.text))
                                            .toStringAsFixed(2);
                                    _altChange.text =
                                        ((double.parse(_received.text) *
                                                    _rate) -
                                                double.parse(_altTotal.text))
                                            .toStringAsFixed(2);
                                  } else if (_baseInput.text == '' &&
                                      value != '') {
                                    _received.text =
                                        (double.parse(value) / _rate)
                                            .toStringAsFixed(2);
                                    _baseChange.text = _f.format(
                                        (double.parse(_received.text) -
                                            _total));

                                    _altChange.text = _f.format(
                                        (double.parse(value) -
                                            double.parse(_altTotal.text)));
                                  } else if (_baseInput.text != '' &&
                                      value == '') {
                                    _received.text =
                                        (double.parse(_baseInput.text))
                                            .toStringAsFixed(2);
                                    _baseChange.text = _f.format(
                                        (double.parse(_received.text) -
                                            _total));

                                    _altChange.text = _f.format(
                                        (double.parse(_received.text) * _rate) -
                                            double.parse(_altTotal.text));
                                  } else if (_baseInput.text == '' &&
                                      value == '') {
                                    _received.text = '0.00';
                                    _baseChange.text =
                                        (double.parse(_received.text) - _total)
                                            .toStringAsFixed(2);
                                    _altChange.text =
                                        (double.parse(_received.text) * _rate -
                                                double.parse(_altTotal.text))
                                            .toString();
                                  }
                                }
                              },
                              controller: _altInput,
                              color: Colors.green[100],
                              hintext: '0',
                              isReadOnly: false,
                              textInputType: TextInputType.number,
                              leading:
                                  Text("Cash", style: TextStyle(fontSize: 18)),
                              currency: _altCurr,
                            ),
                            CustomTextField(
                              controller: _received,
                              leading: Text("Recived",
                                  style: TextStyle(fontSize: 18)),
                              currency: _baseCurr,
                            ),
                            CustomTextField(
                              controller: _baseChange,
                              leading: Text('Change',
                                  style: TextStyle(fontSize: 18)),
                              currency: _baseCurr,
                            ),
                            CustomTextField(
                              controller: _altChange,
                              leading: Text("Change",
                                  style: TextStyle(fontSize: 18)),
                              currency: _altCurr,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: SizedBox(
        height: 55.0,
        child: MaterialButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            AppLocalization.of(context).getTranValue('confirm'),
            style: TextStyle(
              fontSize: 19.0,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: _isButtonDisabled
              ? null
              : () async {
                  setState(() {
                    _isButtonDisabled = true;
                  });
                  double _cashReceived = double.parse(_received.text);
                  String check = await CheckPrivilegeController()
                      .checkprivilege("P008", widget.ip);
                  if (_cashReceived >= _total) {
                    if (check == "true") {
                      _confirmOrder(context, fetchOrderModel);
                    } else {
                      setState(() {
                        _isButtonDisabled = false;
                      });
                      _dialoadOK(context, "Not Allow Permission");
                    }
                  } else {
                    setState(() {
                      _isButtonDisabled = false;
                    });
                    ShowMessage.comfirmDialog(context, "Cridit",
                        "Payment Is Not Enough, Do You want to Cridit!", () {
                      order.appliedAmount = _cashReceived;
                      _confirmOrder(context, fetchOrderModel);
                    });
                  }
                },
          // () async {
          //   double _cashReceived = double.parse(_received.text);
          //   String check = await CheckPrivilegeController()
          //       .checkprivilege("P008", widget.ip);
          //   if (_cashReceived >= _total) {
          //     if (check == "true") {
          //       _confirmOrder(context, fetchOrderModel);
          //     } else {
          //       _dialoadOK(context, "Not Allow Permission");
          //     }
          //   } else {
          //     _dialoadOK(
          //       context,
          //       "insufficient payment",
          //     );
          //   }
          // }),
        ),
      ),
    );
  }

  Future<void> _confirmOrder(
      BuildContext context, FetchOrderModel fetchOrderModel) async {
    DisplayPayOtherCurrency currency = fetchOrderModel.displayCurrency
        .firstWhere(
            (element) => element.altCurrencyId == element.baseCurrencyId);
    var checkOpenShift = await OpenShiftController.checkOpenShifts(widget.ip);
    if (checkOpenShift == "true") {
      var pref = await SharedPreferences.getInstance();
      int count = pref.getInt('paymentcopy') ?? 1;
      bool _isPrintEnHasLogo = pref.getBool("isPrintEnHasLogo") ?? false;
      bool _isPrintEnNoLogo = pref.getBool("isPrintEnNoLogo") ?? true;
      bool _isPrintKhHasLogo = pref.getBool("isPrintKhHasLogo") ?? false;
      bool _isPrintKhNoLogo = pref.getBool("isPrintKhNoLogo") ?? false;
      var data = await PostOrder()
          .sumitOrder(fetchOrderModel, "Pay", widget.ip, paymentMeanId);
      //console.log(jsonEncode(data));
      if (data.itemsReturns.isNotEmpty || data.itemsReturns.length > 0) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotEnoughStockScreen(
              lsItemReturn: data.itemsReturns,
            ),
          ),
        );
      } else {
        //--------start print---------
        print("print ok");
        if (count == 0) {
          ShowMessage.showLoading(context, "Loading");
          if (systemType == "KRMS") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => TableScreen(ip: widget.ip),
              ),
              (route) => false,
            );
          } else {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => SaleScreen(
                  ip: widget.ip,
                  level: 1,
                  // group1: 1,
                  // group2: 1,
                  // group3: 1,
                  tableId: 0,
                  orderId: 0,
                  defaultOrder: true,
                ),
              ),
              (route) => true,
            );
          }
        } else {
          int i = 0;
          if (_isPrintEnHasLogo) {
            do {
              Future.delayed(Duration(seconds: 1)).whenComplete(() =>
                  PrintNewPaymant(
                          receiptInfoModel: data, displayCurrency: currency)
                      .startPrintPayment(
                          payBy,
                          double.parse(
                              _received.text.isEmpty ? '0.00' : _received.text),
                          _baseChange.text,
                          systemType,
                          customer));
              i < count - 1
                  ? await Future.delayed(Duration(seconds: 2))
                  : await Future.delayed(Duration(seconds: 1));
              i++;
            } while (i < count);
          } else if (_isPrintEnNoLogo) {
            do {
              Future.delayed(Duration(seconds: 1)).whenComplete(() =>
                  PrintEngNoLogoPaymant(
                          receiptInfoModel: data, displayCurrency: currency)
                      .startPrintPayment(
                          payBy,
                          double.parse(
                              _received.text.isEmpty ? '0.00' : _received.text),
                          _baseChange.text,
                          systemType,
                          customer));
              i < count - 1
                  ? await Future.delayed(Duration(seconds: 2))
                  : await Future.delayed(Duration(seconds: 1));
              i++;
            } while (i < count);
          } else if (_isPrintKhHasLogo) {
            do {
              Future.delayed(Duration(seconds: 1)).whenComplete(() =>
                  PrintKhHasLogoPaymant(
                          receiptInfoModel: data, displayCurrency: currency)
                      .startPrintPayment(
                          payBy,
                          double.parse(
                              _received.text.isEmpty ? '0.00' : _received.text),
                          _baseChange.text,
                          systemType,
                          customer));
              i < count - 1
                  ? await Future.delayed(Duration(seconds: 2))
                  : await Future.delayed(Duration(seconds: 1));
              i++;
            } while (i < count);
          } else if (_isPrintKhNoLogo) {
            do {
              Future.delayed(Duration(seconds: 1)).whenComplete(() =>
                  PrintKhNoLogoPaymant(
                          receiptInfoModel: data, displayCurrency: currency)
                      .startPrintPayment(
                          payBy,
                          double.parse(
                              _received.text.isEmpty ? '0.00' : _received.text),
                          _baseChange.text,
                          systemType,
                          customer));
              i < count - 1
                  ? await Future.delayed(Duration(seconds: 2))
                  : await Future.delayed(Duration(seconds: 1));
              i++;
            } while (i < count);
          }
          if (systemType == "KRMS") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => TableScreen(ip: widget.ip),
              ),
              (route) => false,
            );
          } else {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => SaleScreen(
                  ip: widget.ip,
                  level: 1,
                  // group1: 1,
                  // group2: 1,
                  // group3: 1,
                  tableId: 0,
                  orderId: 0,
                  defaultOrder: true,
                ),
              ),
              (route) => true,
            );
          }
        }
      }
    } else {
      setState(() {
        _isButtonDisabled = false;
      });
      ShowMessage.notOpenShift(
        context,
        AppLocalization.of(context).getTranValue('open_shift_befor_pay'),
        widget.ip,
      );
    }
  }

  var cardNumberController = TextEditingController(text: "88460024811704");
  String message = "";
  Future<void> _scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'CANCEL', true, ScanMode.QR);
      if (!mounted) return;
      if (barcode.isEmpty) {
        return;
      } else {
        setState(() => cardNumberController.text = barcode);
      }
    } on PlatformException {
      cardNumberController.text = 'Failed to scan';
    }
  }

  Future<void> _buildDiscountMember() {
    var translate = AppLocalization.of(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              AppLocalization.of(context).getTranValue("discount_member"),
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(children: [
                TextFormField(
                  controller: cardNumberController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _scanBarcode();
                        },
                        icon: Icon(Icons.qr_code),
                      ),
                      labelText: translate.getTranValue("card_number")),
                ),
                message.isEmpty
                    ? SizedBox()
                    : Text(
                        message,
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
              ]),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  translate.getTranValue('cancel'),
                ),
              ),
              TextButton(
                onPressed: () async {
                  MemberCardDiscount memberCardDis =
                      await MemberCardDisController().getCardMemberDetail(
                          widget.ip,
                          cardNumberController.text.trim().isEmpty ||
                                  cardNumberController == null
                              ? "@ad"
                              : cardNumberController.text.trim(),
                          grandTotal,
                          order.priceListId);
                  if (memberCardDis.isRejected) {
                    setState(() {
                      message = memberCardDis.data.message;
                      print("message = $message");
                    });
                  } else if (memberCardDis.isAlerted) {
                    Navigator.pop(context);
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(translate.getTranValue("card_number")),
                        content: Text(memberCardDis.data.message),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(translate.getTranValue('cancel')),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              translate.getTranValue('ok'),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    print("isapproved : ${memberCardDis.data.message}");
                  }
                },
                child: Text(
                  translate.getTranValue('ok'),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _dialoadOK(BuildContext context, String desc) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            '$desc',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalization.of(context).getTranValue('retry')),
            )
          ],
        );
      },
    );
  }
}
