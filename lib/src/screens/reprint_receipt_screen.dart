import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/controllers/reprint_reciept_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/models/reprint_receipt_model.dart';
import 'package:point_of_sale/src/models/reprint_receipt_temple_model.dart';
import 'package:point_of_sale/src/printers/reprint_receipt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../printers/print_payment.dart';

class ReprintReceiptScreen extends StatefulWidget {
  final String ip;
  const ReprintReceiptScreen({Key key, this.ip}) : super(key: key);

  @override
  State<ReprintReceiptScreen> createState() => _ReprintReceiptScreenState();
}

class _ReprintReceiptScreenState extends State<ReprintReceiptScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dfController;
  TextEditingController _dToController;
  List<ReprintReceiptTample> reprintReceiptTample;
  List<ReprintReceiptModel> reprintReceipt;
  var _dF = DateFormat('yyyy-MM-dd');
  var _now = DateTime.now();
  bool loading = true;
  var systemType;

  void getReprintReceipt(String dateFrom, String dateTo) async {
    var prfr = await SharedPreferences.getInstance();
    systemType = prfr.getString("systemType");
    await ReprintReceiptController()
        .getReceiptToReprint(widget.ip, dateFrom, dateTo)
        .then((value) {
      setState(() {
        reprintReceiptTample = value;
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _dfController = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    _dToController = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(DateTime.now()));

    _dfController = TextEditingController(text: _dF.format(_now));
    _dToController = TextEditingController(text: _dF.format(_now));
    getReprintReceipt(_dfController.text, _dToController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranValue('reprint_receipt'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 28.0),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchData(
                    ip: widget.ip, reprintRecipt: reprintReceiptTample),
              );
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
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
                          controller: _dfController,
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
                          controller: _dToController,
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
                            final loForm = _formKey.currentState;
                            if (loForm.validate() == true) {
                              loForm.save();
                              reprintReceiptTample.clear();
                              getReprintReceipt(
                                  _dfController.text, _dToController.text);
                              reprintReceiptTample.isNotEmpty
                                  ? loading = true
                                  : loading = false;
                            }
                          },
                          child: Text(
                            AppLocalization.of(context).getTranValue('filter'),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: MaterialButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            final loForm = _formKey.currentState;
                            loForm.reset();
                            _dfController = TextEditingController(
                                text: DateFormat("yyyy-MM-dd")
                                    .format(DateTime.now()));
                            _dToController = TextEditingController(
                                text: DateFormat("yyyy-MM-dd")
                                    .format(DateTime.now()));
                            reprintReceiptTample.clear();
                            getReprintReceipt(
                                _dfController.text, _dToController.text);
                            reprintReceiptTample.isNotEmpty
                                ? loading = true
                                : loading = false;
                          },
                          child: Text(
                            AppLocalization.of(context).getTranValue('reset'),
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
          SizedBox(
            height: 10,
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    // Divider(height: 0.0, color: Colors.grey),
                    reprintReceiptTample == null || reprintReceiptTample.isEmpty
                        ? Center(child: customText("No Receipt For Reprint"))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: reprintReceiptTample.length,
                            itemBuilder: (context, index) {
                              var data = reprintReceiptTample[index];
                              return Slidable(
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: ((context) async {
                                          var pref = await SharedPreferences
                                              .getInstance();

                                          await Future.delayed(
                                              Duration(seconds: 1));
                                          reprintReceipt =
                                              await ReprintReceiptController()
                                                  .getReprintReceipt(widget.ip,
                                                      data.receiptId, "Pay");
                                          bool isPrintEnBillhaslogo =
                                              pref.getBool(
                                                      "isPrintEnHasLogo") ??
                                                  false;
                                          bool isPrintEnBillNologo =
                                              pref.getBool("isPrintEnNoLogo") ??
                                                  true;
                                          bool isPrintKhHasLogo = pref.getBool(
                                                  "isPrintKhHasLogo") ??
                                              false;
                                          bool isPrintKhNoLogo =
                                              pref.getBool("isPrintKhNoLogo") ??
                                                  false;
                                          if (isPrintEnBillhaslogo) {
                                            await ReprintReceipt(
                                                    reprintReceipt:
                                                        reprintReceipt)
                                                .startReprint(systemType);
                                          } else if (isPrintEnBillNologo) {
                                            ReprintEnNoLogoReceipt(
                                                    reprintReceipt:
                                                        reprintReceipt)
                                                .startReprint(systemType);
                                          } else if (isPrintKhHasLogo) {
                                            ReprintKHLogoReceipt(
                                                    reprintReceipt:
                                                        reprintReceipt)
                                                .startReprint(systemType);
                                          } else if (isPrintKhNoLogo) {
                                            ReprintKhNoLogoReceipt(
                                                    reprintReceipt:
                                                        reprintReceipt)
                                                .startReprint(systemType);
                                          }
                                        }),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        foregroundColor: Colors.white,
                                        icon: Icons.print,
                                        label: 'Print',
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        customText(data.receiptNo),
                                        customText(data.dateOut),
                                        customText(data.grandTotal),
                                      ],
                                    ),
                                  ));
                            },
                            separatorBuilder: (context, index) {
                              return Divider(height: 0.0, color: Colors.grey);
                            },
                          ),
                    Divider(height: 0.0, color: Colors.grey),
                  ],
                )
        ],
      ),
    );
  }

  Widget customText(String text) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class SearchData extends SearchDelegate {
  final List<ReprintReceiptTample> reprintRecipt;
  final String ip;
  SearchData({@required this.reprintRecipt, @required this.ip});

  Widget customText(String text) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, 'true'),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = query.isEmpty
        ? reprintRecipt
        : reprintRecipt
            .where((e) =>
                e.cashier.toLowerCase().contains(query.toLowerCase()) ||
                e.dateOut.toLowerCase().contains(query.toLowerCase()) ||
                e.receiptNo.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return suggestions.isEmpty
        ? Center(
            child: Text(
              AppLocalization.of(context).getTranValue('no_result_found'),
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              var data = suggestions[index];
              return Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context) async {}),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        icon: Icons.print,
                        label: 'Print',
                      ),
                    ],
                  ),
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        customText(data.receiptNo),
                        customText(data.cashier),
                        customText(data.dateOut),
                        customText(data.grandTotal),
                      ],
                    ),
                  ));
            },
            separatorBuilder: (context, index) {
              return Divider(height: 0.0, color: Colors.grey);
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? reprintRecipt
        : reprintRecipt
            .where((e) =>
                e.cashier.toLowerCase().contains(query.toLowerCase()) ||
                e.dateOut.toLowerCase().contains(query.toLowerCase()) ||
                e.receiptNo.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return suggestions.isEmpty
        ? Center(
            child: Text(
              AppLocalization.of(context).getTranValue('no_result_found'),
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              var data = suggestions[index];
              return Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: ((context) async {}),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        icon: Icons.print,
                        label: 'Print',
                      ),
                    ],
                  ),
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        customText(data.receiptNo),
                        customText(data.cashier),
                        customText(data.dateOut),
                        customText(data.grandTotal),
                      ],
                    ),
                  ));
            },
            separatorBuilder: (context, index) {
              return Divider(height: 0.0, color: Colors.grey);
            },
          );
  }
}
