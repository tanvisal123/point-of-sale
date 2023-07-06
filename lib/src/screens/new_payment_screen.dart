import 'dart:async';
import 'dart:convert';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/widgets/custom_textfield_.dart';
import 'dart:developer' as console;

import '../helpers/app_localization.dart';

class MutipaymentScreen extends StatefulWidget {
  final String ip;
  final FetchOrderModel fetchOrderModel;
  const MutipaymentScreen({Key key, this.ip, this.fetchOrderModel})
      : super(key: key);

  @override
  State<MutipaymentScreen> createState() => _MutipaymentScreenState();
}

class _MutipaymentScreenState extends State<MutipaymentScreen> {
  var freightController = TextEditingController(text: "");
  var gTotalBaseController = TextEditingController(text: "");
  var gTotalAltController = TextEditingController(text: "");
  TextEditingController _dFController;
  TextEditingController searchCardController = TextEditingController();
  PaymentMean _paymentMean;
  DisplayPayOtherCurrency currency;
  double rate = 0, grandTotal = 0;
  List<Freight> freights = [];
  List<String> currencyList = [];
  String selectCurrencyCash = '', selectCurrencybyBank = '';
  bool payByCard = false;
  @override
  void initState() {
    print(widget.fetchOrderModel.order.grandTotal);
    currency = widget.fetchOrderModel.displayCurrency
        .firstWhere((element) => element.isActive);
    rate = currency.altRate;
    freightController.text =
        widget.fetchOrderModel.order.freightAmount.toString();
    freights = widget.fetchOrderModel.freights;
    var grandTotal = widget.fetchOrderModel.order.grandTotal +
        widget.fetchOrderModel.order.freightAmount;
    gTotalBaseController.text = grandTotal.toString();
    gTotalAltController.text = (rate * grandTotal).toString();
    _paymentMean = widget.fetchOrderModel.paymentMeans
        .firstWhere((element) => element.isReceivedChange);
    currencyList = [currency.baseCurrency, currency.altCurrency];
    selectCurrencybyBank = selectCurrencyCash = currencyList.first;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Payment Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "PAYMENT MEAN ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    child: DateTimePicker(
                      decoration: InputDecoration(
                          //border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.date_range_outlined)),
                      type: DateTimePickerType.date,
                      dateMask: 'dd-MM-yyyy',
                      controller: _dFController,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                      dateHintText:
                          AppLocalization.of(context).getTranValue('date_from'),
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.top,
                      // dateLabelText:
                      //     AppLocalization.of(context).getTranValue('date_from'),
                    ),
                  ),
                  Builder(builder: (context) {
                    return IconButton(
                      onPressed: () {
                        //buildPaymentMean();
                        showGlobalDrawer(
                            context: context,
                            builder: _verticalDrawerBuilderPaymentMeans,
                            direction: AxisDirection.up);
                      },
                      icon: Icon(
                        Icons.credit_card_rounded,
                        size: 30,
                      ),
                    );
                  })
                ],
              ),
            ),
            CustomTextField(
                isReadOnly: true,
                controller: freightController,
                leading: Text('Freight', style: TextStyle(fontSize: 18)),
                currency: currency.baseCurrency,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => BuildFreight(
                            ip: widget.ip,
                            freights: freights,
                            fetchOrder: widget.fetchOrderModel,
                          )),
                    ),
                  );
                }),
            CustomTextField(
              isReadOnly: true,
              controller: gTotalBaseController,
              leading: Text('Total', style: TextStyle(fontSize: 18)),
              currency: currency.baseCurrency,
            ),
            CustomTextField(
              isReadOnly: true,
              controller: gTotalAltController,
              leading: Text('Total', style: TextStyle(fontSize: 18)),
              currency: currency.altCurrency,
            ),
            SizedBox(height: 10),
            CustomTextField(
              isReadOnly: true,
              controller: gTotalAltController,
              leading: CustomDropdownButton2(
                buttonDecoration: BoxDecoration(
                    border: Border.all(width: 0, color: Colors.white)),
                dropdownWidth: 100,
                dropdownDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                ),
                dropdownItems: currencyList.toList(),
                hint: '',
                onChanged: (String value) {
                  setState(() {
                    selectCurrencyCash = value;
                  });
                },
                value: selectCurrencyCash.toString(),
              ),
              currency: 'Cash',
            ),
            CustomTextField(
              isReadOnly: true,
              controller: gTotalAltController,
              leading: CustomDropdownButton2(
                buttonDecoration: BoxDecoration(
                    border: Border.all(width: 0, color: Colors.white)),
                dropdownWidth: 100,
                dropdownDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                ),
                dropdownItems: currencyList.toList(),
                hint: '',
                onChanged: (String value) {
                  setState(() {
                    selectCurrencybyBank = value;
                  });
                },
                value: selectCurrencybyBank.toString(),
              ),
              currency: 'ABA',
            ),
            payByCard
                ? Builder(builder: (context) {
                    return InkWell(
                      onTap: () {
                        showGlobalDrawer(
                            context: context,
                            builder: _verticalDrawerBuilder,
                            direction: AxisDirection.up);
                      },
                      child: CustomTextField(
                        isReadOnly: true,
                        controller: gTotalAltController,
                        leading:
                            Text('Pay Card', style: TextStyle(fontSize: 18)),
                        currency: currency.baseCurrency,
                      ),
                    );
                  })
                : SizedBox(),
            CustomTextField(
              isReadOnly: true,
              controller: gTotalAltController,
              leading: Text('Recieve', style: TextStyle(fontSize: 18)),
              currency: currency.baseCurrency,
            ),
            CustomTextField(
              isReadOnly: true,
              controller: gTotalAltController,
              leading: Text('Recieve', style: TextStyle(fontSize: 18)),
              currency: currency.altCurrency,
            ),
            CustomTextField(
              isReadOnly: true,
              controller: gTotalAltController,
              leading: Text('Changed', style: TextStyle(fontSize: 18)),
              currency: currency.baseCurrency,
            ),
            CustomTextField(
              isReadOnly: true,
              controller: gTotalAltController,
              leading: Text('Changed', style: TextStyle(fontSize: 18)),
              currency: currency.altCurrency,
            ),
          ],
        ),
      ),
      bottomSheet: InkWell(
        onTap: () {
          print('object');
        },
        child: Container(
          height: 60,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              AppLocalization.of(context).getTranValue('pay'),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }

  WidgetBuilder get _verticalDrawerBuilder {
    return (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          leading: Icon(
            Icons.group_outlined,
            size: 40,
          ),
          centerTitle: true,
          title: Text(
            'Other Payment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 25,
                ))
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          alignment: Alignment.topCenter,
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 18, color: Colors.black87),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: searchCardController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                          label: Text(
                            'Card number',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          height: 50,
          width: double.infinity,
          color: Colors.blueGrey,
          child: Row(
            children: [
              Expanded(
                child: CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    borderRadius: BorderRadius.circular(0),
                    color: Theme.of(context).primaryColor,
                    child: Center(
                        child: Text(
                            AppLocalization.of(context).getTranValue('clear'))),
                    onPressed: () {
                      setState(() {
                        searchCardController.text = '';
                      });
                    }),
              ),
              Expanded(
                child: CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.red,
                    child: Center(
                      child: Text(
                          AppLocalization.of(context).getTranValue('cancel')),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              Expanded(
                child: CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.blue,
                    child: Center(
                        child: Text(
                            AppLocalization.of(context).getTranValue('ok'))),
                    onPressed: () {}),
              ),
            ],
          ),
        ),
      );
    };
  }

  WidgetBuilder get _verticalDrawerBuilderPaymentMeans {
    return (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 48, 60, 65),
              leading: SizedBox(),
              centerTitle: true,
              title: Text(
                'PAYMENT MEANS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 25,
                    ))
              ],
            ),
            body: Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              alignment: Alignment.topCenter,
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 18, color: Colors.black87),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        width: double.infinity,
                        color: Colors.blueGrey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('Name')),
                            Expanded(child: Text('Currency')),
                            Expanded(child: Text('selected')),
                            Expanded(child: Text('Recieved'))
                          ],
                        ),
                      ),
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              widget.fetchOrderModel.paymentMeans.map((e) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(e.type),
                                ),
                                Expanded(
                                  child: CustomDropdownButton2(
                                    dropdownWidth: 100,
                                    dropdownDecoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      size: 20,
                                    ),
                                    dropdownItems: currencyList.toList(),
                                    hint: '',
                                    onChanged: (String value) {
                                      setState(() {
                                        selectCurrencyCash = value;
                                      });
                                    },
                                    value: selectCurrencyCash.toString(),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Checkbox(
                                      value: e.isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          e.isChecked = value;
                                        });
                                      }),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                      value: e.isReceivedChange,
                                      groupValue: _paymentMean.isReceivedChange,
                                      onChanged: (value) {
                                        setState(() {
                                          e.isReceivedChange = true;
                                        });
                                      }),
                                ),
                              ],
                            );
                          }).toList()),
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: Container(
              height: 50,
              width: double.infinity,
              color: Colors.blueGrey,
              child: Row(
                children: [
                  Checkbox(
                    value: payByCard,
                    onChanged: (value) {
                      setState(() {
                        payByCard = value;
                      });
                    },
                  ),
                  Text('Pay Card'),
                  SizedBox(
                    width: 30,
                  ),
                ],
              ),
            ),
          );
        },
      );
    };
  }

  // Future<void> buildPaymentMean() {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return AlertDialog(
  //           titlePadding: const EdgeInsets.all(0),
  //           title: Container(
  //             height: 40,
  //             color: Colors.blueGrey,
  //             child: const Text(
  //               'PAYMENT MEANS',
  //               style:
  //                   TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: widget.fetchOrderModel.paymentMeans.map((e) {
  //                       return Row(
  //                         children: [
  //                           Expanded(
  //                             child: Text(e.type),
  //                           ),
  //                           Expanded(
  //                             flex: 1,
  //                             child: Checkbox(
  //                                 value: e.isChecked,
  //                                 onChanged: (value) {
  //                                   setState(() {
  //                                     e.isChecked = value;
  //                                   });
  //                                 }),
  //                           ),
  //                           Expanded(
  //                             child: RadioListTile(
  //                                 value: e.isReceivedChange,
  //                                 groupValue: _paymentMean.isReceivedChange,
  //                                 onChanged: (value) {
  //                                   setState(() {
  //                                     e.isReceivedChange = true;
  //                                   });
  //                                 }),
  //                           ),
  //                         ],
  //                       );
  //                     }).toList()),
  //               ],
  //             ),
  //           ),
  //           actionsAlignment: MainAxisAlignment.center,
  //           actions: <Widget>[
  //             Checkbox(
  //               value: payByCard,
  //               onChanged: (value) {
  //                 setState(() {
  //                   payByCard = value;
  //                 });
  //               },
  //             ),
  //             Text('Pay Card'),
  //             SizedBox(
  //               width: 30,
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text(
  //                 AppLocalization.of(context).getTranValue('ok'),
  //                 style:
  //                     TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  //     },
  //   );
  // }
}

class BuildFreight extends StatefulWidget {
  final String ip;
  final List<Freight> freights;
  final FetchOrderModel fetchOrder;
  const BuildFreight(
      {Key key, this.ip, @required this.freights, this.fetchOrder})
      : super(key: key);

  @override
  State<BuildFreight> createState() => _BuildFreightState();
}

class _BuildFreightState extends State<BuildFreight> {
  bool _isPanDown = true;
  String selectFreighttype = "";
  bool _isBackPressedOrTouchedOutSide = false;
  bool _isDropDownOpened = false;
  double totalAmount = 0;
  int freightAmount = 0;
  TextEditingController amountController = TextEditingController(text: "0");
  DisplayPayOtherCurrency displayCurrency;
  double sumFreightAmount() {
    double totalFreightAmount = 0;
    widget.freights.forEach((element) {
      totalFreightAmount += element.amountReven;
    });
    return totalFreightAmount;
  }

  @override
  void initState() {
    print(widget.fetchOrder.order.orderId);
    totalAmount = sumFreightAmount();
    print(jsonEncode(widget.freights));
    displayCurrency = widget.fetchOrder.displayCurrency.firstWhere(
        (element) => element.altCurrencyId == element.baseCurrencyId);
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _navigateToPreviousScreenOnIOSBackPress = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: _removeFocus,
        onPanDown: (focus) {
          _isPanDown = true;
          _removeFocus();
        },
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("Freight Detail"),
            ),
            body: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Text("Total Amount : "),
                              Text(
                                  " ${displayCurrency.baseCurrency} ${totalAmount.toStringAsFixed(2)}"),
                            ],
                          ),
                        )),
                    Expanded(
                      flex: 10,
                      child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.black,
                              ),
                          itemCount: widget.freights.length,
                          itemBuilder: (context, index) {
                            Freight freight = widget.freights[index];
                            FreightReceiptType freightReceiptType = freight
                                .freightReceiptTypes
                                .firstWhere((e) => e.selected);
                            List<String> freightTypeName = [];
                            freight.freightReceiptTypes.forEach((e) {
                              freightTypeName.add(e.text);
                            });
                            return Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(freight.name),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      height: 50,
                                      width: 150,
                                      child: AwesomeDropDown(
                                        isPanDown: _isPanDown,
                                        isBackPressedOrTouchedOutSide:
                                            _isBackPressedOrTouchedOutSide,
                                        dropDownList: freightTypeName,
                                        numOfListItemToShow: 4,
                                        selectedItem: freightReceiptType.text,
                                        elevation: 0,
                                        dropDownIcon: const Icon(Icons
                                            .arrow_drop_down_circle_outlined),
                                        dropDownBorderRadius: 5.0,
                                        dropDownBottomBorderRadius: 5.0,
                                        dropDownTopBorderRadius: 5.0,
                                        dropDownOverlayBGColor: Colors.white,
                                        dropDownListTextStyle:
                                            TextStyle(color: Colors.black),
                                        dropStateChanged: (isOpened) {
                                          _isDropDownOpened = isOpened;
                                          if (!isOpened) {
                                            _isBackPressedOrTouchedOutSide =
                                                false;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: 50.0,
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      child: TextFormField(
                                        initialValue: freight.amountReven
                                            .toStringAsFixed(0),
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.black,
                                            fontFamily: 'OpenSans'),
                                        decoration: InputDecoration(
                                          // hintText: freight.amountReven
                                          //     .toStringAsFixed(0),
                                          contentPadding: EdgeInsets.only(
                                              top: 14.0, right: 20.0),
                                        ),
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            value = "0";
                                          }
                                          setState(() {
                                            var f = widget.freights.firstWhere(
                                                (element) =>
                                                    element.freightId ==
                                                    freight.freightId);
                                            freight.amountReven =
                                                double.parse(value);
                                            f.amountReven = double.parse(value);

                                            totalAmount = sumFreightAmount();
                                          });
                                          // print(totalAmount);
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Checkbox(
                                    value: freight.isActive,
                                    onChanged: (value) {
                                      setState(() {
                                        freight.isActive = value;
                                      });
                                    },
                                  ))
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                )),
            bottomNavigationBar: Container(
              height: 50,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.grey[400],
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(80, 167, 117, 1),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: MaterialButton(
                                splashColor: Colors.white,
                                onPressed: () async {
                                  setState(() {
                                    widget.fetchOrder.order.freightAmount =
                                        totalAmount;
                                  });
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MutipaymentScreen(
                                          ip: widget.ip,
                                          fetchOrderModel: widget.fetchOrder),
                                    ),
                                  );
                                },
                                child: Text(
                                  "UPDATE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(85, 136, 192, 1),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: MaterialButton(
                                  splashColor: Colors.white,
                                  onPressed: () async {},
                                  child: Text(
                                    "COMFIRM",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(239, 60, 60, 1),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: MaterialButton(
                                splashColor: Colors.white,
                                onPressed: () async {},
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  String changeSelected(FreightReceiptType freightType) {
    return freightType.text;
  }

  Widget buildDropdown(List<FreightReceiptType> freightTypes, Freight freight) {
    //console.debugger();
    return Expanded(
      flex: 4,
      child: Container(
        height: 50,
        width: 150,
        margin: EdgeInsets.only(left: 0.5),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            dropdownDecoration: BoxDecoration(
              color: Colors.white,
            ),
            items: freightTypes.map((e) {
              //print(jsonEncode(e),
              return DropdownMenuItem(
                value: e.text,
                child: Text(
                  e.text,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              var ft = freight.freightReceiptTypes
                  .firstWhere((element) => element.text == value);
              setState(() {
                ft.selected = true;
                //selected = ft.text;
              });
            },
            buttonHeight: 40,
            buttonWidth: 140,
            itemHeight: 40,
          ),
        ),
      ),
    );
  }

  void _removeFocus() {
    if (_isDropDownOpened) {
      setState(() {
        _isBackPressedOrTouchedOutSide = true;
      });
      _navigateToPreviousScreenOnIOSBackPress = false;
    }
  }

  Future<bool> _onWillPop() {
    if (_scaffoldKey.currentState.isEndDrawerOpen) {
      Navigator.of(context).pop();
      return Future.value(false);
    } else {
      if (_isDropDownOpened) {
        setState(() {
          _isBackPressedOrTouchedOutSide = true;
        });
        FocusManager.instance.primaryFocus.unfocus();
        return Future.value(false);
      } else {
        if (_navigateToPreviousScreenOnIOSBackPress) {
          Navigator.of(context).pop();
          return Future.value(true);
        } else {
          _navigateToPreviousScreenOnIOSBackPress = true;
          return Future.value(false);
        }
      }
    }
  }

  Widget buildFreigthType(
      List<String> freightTypeName, List<FreightReceiptType> freightTypes) {
    String freightTypeSeceted;
    var temp = freightTypes.firstWhere((element) => element.selected);
    return GestureDetector(
      //onTap: _removeFocus,
      onPanDown: (focus) {
        _isPanDown = true;
        _removeFocus();
      },
      child: Container(
        margin: EdgeInsets.only(left: 0.5),
        height: 50,
        width: 150,
        child: AwesomeDropDown(
          elevation: 0,
          dropDownIcon: const Icon(Icons.arrow_drop_down_circle_outlined),
          dropDownBorderRadius: 5.0,
          dropDownBottomBorderRadius: 5.0,
          dropDownTopBorderRadius: 5.0,
          dropDownOverlayBGColor: Colors.grey[100],
          isPanDown: _isPanDown,
          selectedItem: freightTypeSeceted ?? temp.text,
          dropDownList: freightTypeName,
          numOfListItemToShow: freightTypeName.length,
          isBackPressedOrTouchedOutSide: _isBackPressedOrTouchedOutSide,
          onDropDownItemClick: (value) async {
            // freightTypeSeceted = value;
          },
          dropStateChanged: (isOpened) {
            _isDropDownOpened = isOpened;
            if (!isOpened) {
              _isBackPressedOrTouchedOutSide = false;
            }
          },
        ),
      ),
    );
  }
}
// Expanded(
//     flex: 4,
//     child: Container(
//       margin: EdgeInsets.only(left: 0.5),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton2(
//           dropdownDecoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           items: freight.freightReceiptTypes.map((e) {
//             return DropdownMenuItem(
//               onTap: () {
//                 freight.freightReceiptType =
//                     int.parse(e.value);
//               },
//               value: e.text,
//               child: Text(
//                 e.text,
//                 style: const TextStyle(
//                   fontSize: 14,
//                 ),
//               ),
//             );
//           }).toList(),
//           value: selected ?? freightReceiptType.text,
//           onChanged: (value) {
//             setState(() {
//               selected = value;
//             });
//           },
//           buttonHeight: 40,
//           buttonWidth: 140,
//           itemHeight: 40,
//         ),
//       ),
//     )),
// Expanded(
//     flex: 3,
//     child: Container(
//       child: NumberInputWithIncrementDecrement(
//         isInt: false,
//         incDecFactor: 0.35,
//         controller: TextEditingController(),
//       ),
//     ))
// body: Column(
//   children: [
//     DataTable(
//       showBottomBorder: true,
//       columns: <DataColumn>[
//         DataColumn(
//             label: Text(
//           'Name',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         )),
//         DataColumn(
//             label: Text("FreightType",
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold))),
//         DataColumn(
//             label: Text("Amount",
//                 style: TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold))),
//       ],
//       rows: widget.freights.map((e) {
//         FreightReceiptType freightReceiptType =
//             e.freightReceiptTypes.firstWhere((e) => e.selected);
//         List<String> freightTypeName = [];
//         e.freightReceiptTypes.forEach((e) {
//           freightTypeName.add(e.text);
//         });
//         return DataRow(cells: [
//           DataCell(Center(child: Text(e.name))),
//           DataCell(AwesomeDropDown(
//             dropDownList: freightTypeName,
//             selectedItem: freightReceiptType.text,
//             elevation: 0,
//             dropDownIcon:
//                 const Icon(Icons.arrow_drop_down_circle_outlined),
//             dropDownBorderRadius: 5.0,
//             dropDownBottomBorderRadius: 5.0,
//             dropDownTopBorderRadius: 5.0,
//             dropDownOverlayBGColor: Colors.grey[100],
//             isPanDown: _isPanDown,
//           )),
//           DataCell(
//             Container(
//               width: 100,
//               child: TextField(
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(
//                     RegExp('([0-9]|[\.])'),
//                   ),
//                 ],
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   hintText: e.amountReven.toString(),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     if (double.parse(value) == 0.0) {
//                     } else {
//                       e.amountReven = double.parse(value);
//                     }
//                   });
//                 },
//               ),
//             ),
//           ),
//         ]);
//       }).toList(),
//     ),
//   ],
// ),
