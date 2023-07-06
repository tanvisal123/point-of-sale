import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/controllers/close_shift_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/models/receipt_reprint_close_shift.dart';
import 'package:point_of_sale/src/models/reprint_close_shift_model.dart';
import 'package:point_of_sale/src/printers/reprint_close_shitf.dart';

class ReprintCloseShiftScreen extends StatefulWidget {
  final String ip;
  const ReprintCloseShiftScreen({Key key, this.ip}) : super(key: key);

  @override
  State<ReprintCloseShiftScreen> createState() =>
      _ReprintCloseShiftScreenState();
}

class _ReprintCloseShiftScreenState extends State<ReprintCloseShiftScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dfController;
  TextEditingController _dToController;
  var _dF = DateFormat('yyyy-MM-dd');
  var _now = DateTime.now();
  bool loading = true;
  List<ReprintCloseShiftModel> _listReprint;
  List<ReceiptReprintCloseShift> receipt;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void getReprintReceipt(String dateFrom, String dateTo) async {
    await CloseShiftController()
        .getReprintCloseShift(widget.ip, dateFrom, dateTo)
        .then((value) {
      setState(() {
        _listReprint = value;
        loading = false;
      });

      for (var temp in _listReprint) {
        print(temp.empName);
      }
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
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
              AppLocalization.of(context).getTranValue('reprint_closeshift')),
          actions: [
            IconButton(
              icon: Icon(Icons.search, size: 28.0),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate:
                      SearchData(ip: widget.ip, listCloseShift: _listReprint),
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
                                _listReprint.clear();
                                getReprintReceipt(
                                    _dfController.text, _dToController.text);
                                _listReprint.isNotEmpty
                                    ? loading = true
                                    : loading = false;
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
                              final loForm = _formKey.currentState;
                              loForm.reset();
                              _dfController = TextEditingController(
                                  text: DateFormat("yyyy-MM-dd")
                                      .format(DateTime.now()));
                              _dToController = TextEditingController(
                                  text: DateFormat("yyyy-MM-dd")
                                      .format(DateTime.now()));
                              _listReprint.clear();
                              getReprintReceipt(
                                  _dfController.text, _dToController.text);
                              _listReprint.isNotEmpty
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
                      _listReprint == null || _listReprint.isEmpty
                          ? Center(
                              child: customText("No Receipt For CloseShift"))
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: _listReprint.length,
                              itemBuilder: (context, index) {
                                var data = _listReprint[index];
                                return Slidable(
                                    endActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: ((context) async {
                                            await Future.delayed(
                                                Duration(seconds: 1));
                                            receipt =
                                                await CloseShiftController()
                                                    .receiptReprintCloseShift(
                                                        widget.ip,
                                                        data.userId,
                                                        data.id);
                                            if (receipt.first.receiptNo ==
                                                    null ||
                                                receipt
                                                    .first.receiptNo.isEmpty) {
                                              showDialog<String>(
                                                context:
                                                    _scaffoldKey.currentContext,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: Text(
                                                    'Reprint CloseShift',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  content: const Text(
                                                    'No Item For PrintRecipt',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'OK'),
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              await ReprintCashOut(
                                                      recipt: receipt,
                                                      reprint: data)
                                                  .startPrint();
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
                                      elevation: 0.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          customText(data.empName),
                                          customText(data.trans),
                                          customText(data.dateOut),
                                          customText(data.totalCashOutSys),
                                        ],
                                      ),
                                    ));
                              },
                              separatorBuilder: (context, index) {
                                return Divider(height: 0.0, color: Colors.grey);
                              },
                            ),
                    ],
                  )
          ],
        ));
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
  final List<ReprintCloseShiftModel> listCloseShift;
  final String ip;
  SearchData({@required this.listCloseShift, @required this.ip});
  List<ReceiptReprintCloseShift> receipt;
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
        ? listCloseShift
        : listCloseShift
            .where((e) =>
                e.empName.toLowerCase().contains(query.toLowerCase()) ||
                e.dateOut.toLowerCase().contains(query.toLowerCase()) ||
                e.trans.toLowerCase().contains(query.toLowerCase()))
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
                        onPressed: ((context) async {
                          receipt = await CloseShiftController()
                              .receiptReprintCloseShift(
                                  ip, data.userId, data.id);

                          if (receipt.first.id == 0) {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                  'Reprint CloseShift',
                                  textAlign: TextAlign.center,
                                ),
                                content: const Text(
                                  'No Item For PrintRecipt',
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            await ReprintCashOut(recipt: receipt, reprint: data)
                                .startPrint();
                          }
                        }),
                        backgroundColor: Color(0xFFFE4A49),
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
                        customText(data.empName),
                        customText(data.trans),
                        customText(data.dateOut),
                        customText(data.totalCashOutSys),
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
        ? listCloseShift
        : listCloseShift
            .where((e) =>
                e.empName.toLowerCase().contains(query.toLowerCase()) ||
                e.dateOut.toLowerCase().contains(query.toLowerCase()) ||
                e.trans.toLowerCase().contains(query.toLowerCase()))
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
                        onPressed: ((context) async {
                          receipt = await CloseShiftController()
                              .receiptReprintCloseShift(
                                  ip, data.userId, data.id);

                          if (receipt.first.id == 0) {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                  'Reprint CloseShift',
                                  textAlign: TextAlign.center,
                                ),
                                content: const Text(
                                  'No Item For PrintRecipt',
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            await ReprintCashOut(recipt: receipt, reprint: data)
                                .startPrint();
                          }
                        }),
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
                        customText(data.empName),
                        customText(data.trans),
                        customText(data.dateOut),
                        customText(data.totalCashOutSys),
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
