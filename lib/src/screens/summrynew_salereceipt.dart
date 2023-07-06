import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/src/controllers/summary_sale_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/summary_salereceipt_model.dart';

class SummarySaleReceipt extends StatefulWidget {
  final String ip;
  SummarySaleReceipt({Key key, this.ip}) : super(key: key);

  @override
  State<SummarySaleReceipt> createState() => _SummarySaleReceiptState();
}

GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
TextEditingController _dFController;
TextEditingController _dTController;
var _f = NumberFormat('#,##0.00');

class _SummarySaleReceiptState extends State<SummarySaleReceipt> {
  List<SummarySalesModel> listSummaryReceipt = [];
  bool _status = false;
  void initState() {
    super.initState();
    _dFController = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    _dTController = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    _getlistSummaryReceipt(_dFController.text, _dTController.text);
    // _getReceiptSummary(_dFController.text, _dTController.text);
  }

  _getlistSummaryReceipt(String dateFrom, String dateTo) async {
    bool _result = await DataConnectionChecker().hasConnection;
    if (_result) {
      try {
        await SummarySaleController.getSummarySalesReceipt(
                dateFrom, dateTo, widget.ip)
            .then((value) {
          setState(() {
            listSummaryReceipt.addAll(value);
            if (listSummaryReceipt == null || listSummaryReceipt.isEmpty) {
              _status = false;
            }
            // print("summaryList: ${listSummaryReceipt.first.receiptNo}");
            // print('Date Out: ' + listSummaryReceipt.first.dateOut);
          });
        });
      } finally {
        _status = true;
        // print("summaryList: ${listSummaryReceipt.last.receiptNo}");
        //print('Date Out: ' + listSummaryReceipt.last.dateOut);
        //print("getlistSummaryReceipt : " + e.toString());
      }
    } else {
      ShowMessage.showMessageSnakbar(
          AppLocalization.of(context).getTranValue('no_internet'), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary Receipt'),
      ),
      body: _status
          ? ListView(
              children: [
                Form(
                  key: _globalKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: DateTimePicker(
                                type: DateTimePickerType.date,
                                dateMask: 'dd-MMMM-yyyy',
                                controller: _dFController,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateLabelText: AppLocalization.of(context)
                                    .getTranValue('date_from'),
                              ),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: DateTimePicker(
                                type: DateTimePickerType.date,
                                dateMask: 'dd-MMMM-yyyy',
                                controller: _dTController,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateLabelText: AppLocalization.of(context)
                                    .getTranValue('date_to'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: MaterialButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  final loForm = _globalKey.currentState;
                                  if (loForm.validate() == true) {
                                    loForm.save();
                                    listSummaryReceipt.clear();
                                    _getlistSummaryReceipt(
                                        _dFController.text, _dTController.text);
                                    listSummaryReceipt.isNotEmpty
                                        ? _status = true
                                        : _status = false;
                                  }
                                },
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranValue('filter'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: MaterialButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  final loForm = _globalKey.currentState;
                                  loForm.reset();
                                  _dFController = TextEditingController(
                                      text: DateFormat("yyyy-MM-dd")
                                          .format(DateTime.now()));
                                  _dTController = TextEditingController(
                                      text: DateFormat("yyyy-MM-dd")
                                          .format(DateTime.now()));
                                  listSummaryReceipt.clear();
                                  _getlistSummaryReceipt(
                                      _dFController.text, _dTController.text);
                                  listSummaryReceipt.isNotEmpty
                                      ? _status = true
                                      : _status = false;
                                },
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranValue('reset'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                //  _receiptList.isNotEmpty && listSummaryReceipt.isNotEmpty
                listSummaryReceipt.isNotEmpty
                    ? Column(
                        children: [
                          Divider(height: 0.0, color: Colors.grey),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: listSummaryReceipt.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  print('Card Taped at index $index');
                                },
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "#${listSummaryReceipt[index].receiptNo ?? '###########'}    (${listSummaryReceipt[index].dateOut ?? DateFormat("dd-MM-yyyy").format(DateTime.now())}) ",
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${listSummaryReceipt[index].currency} ${(listSummaryReceipt[index].grandTotal)}",
                                                style:
                                                    TextStyle(fontSize: 13.0),
                                              ),
                                              SizedBox(width: 1.0),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(height: 0.0, color: Colors.grey);
                            },
                          ),
                          Divider(height: 0.0, color: Colors.grey),
                        ],
                      )
                    : Container(
                        height: 300.0,
                        child: Center(
                          child: Center(
                            child: Text(
                              AppLocalization.of(context)
                                  .getTranValue('no_receipt'),
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                listSummaryReceipt.length > 5
                    ? Container(
                        height: 190.0,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              '${DateFormat("dd-MM-yyyy").format(DateTime.parse(_dFController.text))}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.arrow_right_alt,
                                                color: Colors.white,
                                                size: 40.0),
                                            Text(
                                              '${DateFormat("dd-MM-yyyy").format(DateTime.parse(_dTController.text))}',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Discount Item',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              'Discount Total',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              'Vat.Included',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              'Grand Total SSC',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              'Grand Total LCC',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ':',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ':',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ':',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ':',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            ':',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${listSummaryReceipt.last.sDiscountItem}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                '${listSummaryReceipt.last.sDiscountTotal}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                '${listSummaryReceipt.last.sVat}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                '${listSummaryReceipt.last.sGrandTotalSys}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                '${listSummaryReceipt.last.sGrandTotal}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(height: 0.0)
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: _status
          ? listSummaryReceipt.length <= 5 && listSummaryReceipt.isNotEmpty
              ? Container(
                  height: 190.0,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '${DateFormat("dd-MM-yyyy").format(DateTime.parse(_dFController.text))}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(Icons.arrow_right_alt,
                                          color: Colors.white, size: 40.0),
                                      Text(
                                        '${DateFormat("dd-MM-yyyy").format(DateTime.parse(_dTController.text))}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Discount Item',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Discount Total',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Vat.Included',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Grand Total SSC',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Grand Total LCC',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 5,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ':',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${listSummaryReceipt.last.sDiscountItem}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${listSummaryReceipt.last.sDiscountTotal}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${listSummaryReceipt.last.sVat}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${listSummaryReceipt.last.sGrandTotalSys}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '${listSummaryReceipt.last.sGrandTotal}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(height: 0)
          : Container(height: 0),
    );
  }
}
