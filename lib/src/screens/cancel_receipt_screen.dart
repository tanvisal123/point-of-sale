import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:point_of_sale/src/bloc/cancel_receipt_bloc/cancel_receipt_bloc.dart';
import 'package:point_of_sale/src/controllers/receipt_to_cancel_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/receipt_model.dart';
import 'package:point_of_sale/src/models/receipt_to_cancel_model.dart';
import 'package:point_of_sale/src/widgets/receipt_widet.dart';

import '../controllers/check_privilege_conntroller.dart';

class ReceiptToCancel extends StatefulWidget {
  final String ip;
  const ReceiptToCancel({Key key, @required this.ip}) : super(key: key);
  @override
  State<ReceiptToCancel> createState() => _ReceiptToCancelState();
}

class _ReceiptToCancelState extends State<ReceiptToCancel> {
  TextEditingController _dfController;
  TextEditingController _dToController;
  List<ReceiptToCancelModel> listReceiptToCancel;
  CancelReceiptModel _cancelReceipt;
  bool status = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _now = DateTime.now();
  var _dF = DateFormat('yyyy-MM-dd');

  _getReceipt(String dF, String dT) async {
    var connection = await DataConnectionChecker().hasConnection;
    if (connection) {
      try {
        await ReceiptToCancelController.getReceiptToCancel(widget.ip, dF, dT)
            .then((value) {
          setState(() {
            listReceiptToCancel = value;
          });
        });
      } finally {
        status = true;
        print('Receipt List = ${listReceiptToCancel.first.receiptId}');
      }
    } else {
      ShowMessage.showMessageSnakbar(
          AppLocalization.of(context).getTranValue('no_internet'), context);
    }
  }

  _getCancelReceipt(int receiptId) async {
    try {
      await ReceiptToCancelController.getcancelReceipt(widget.ip, receiptId)
          .then((value) {
        _cancelReceipt = value;
      });
    } catch (e) {
      ShowMessage.showMessageSnakbar(e, context);
    }
  }

  @override
  void initState() {
    super.initState();
    _dfController = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    _dToController = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    _getReceipt(_dfController.text, _dToController.text);
    _dfController = TextEditingController(text: _dF.format(_now));
    _dToController = TextEditingController(text: _dF.format(_now));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalization.of(context).getTranValue('cancel_receipt')),
        actions: [],
      ),
      body: status
          ? ListView(
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
                                    listReceiptToCancel.clear();
                                    _getReceipt(_dfController.text,
                                        _dToController.text);
                                    listReceiptToCancel.isNotEmpty
                                        ? status = true
                                        : status = false;
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
                                  listReceiptToCancel.clear();
                                  _getReceipt(
                                      _dfController.text, _dToController.text);
                                  listReceiptToCancel.isNotEmpty
                                      ? status = true
                                      : status = false;
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
                SizedBox(
                  height: 10,
                ),
                listReceiptToCancel.isNotEmpty
                    ? Column(
                        children: [
                          Divider(height: 0.0, color: Colors.grey),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: listReceiptToCancel.length,
                            itemBuilder: (context, index) {
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: ((context) async {
                                        final loForm = _formKey.currentState;
                                        var check =
                                            await CheckPrivilegeController()
                                                .checkprivilege(
                                                    "P020", widget.ip);
                                        if (check == "true") {
                                          _getCancelReceipt(
                                              listReceiptToCancel[index]
                                                  .receiptId);
                                        } else {
                                          _hasNotPermission(
                                              AppLocalization.of(context)
                                                  .getTranValue(
                                                      'user_no_permission'));
                                        }

                                        _getReceipt(_dfController.text,
                                            _dToController.text);
                                        listReceiptToCancel.isNotEmpty
                                            ? status = true
                                            : status = false;
                                      }),
                                      backgroundColor: Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Cancel',
                                    ),
                                  ],
                                ),
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "#${listReceiptToCancel[index].receiptNo}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "(${listReceiptToCancel[index].dateOut})",
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(listReceiptToCancel[index]
                                                .grandTotal),
                                          ],
                                        ),
                                      ),
                                    ],
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
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _hasNotPermission(String mess) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            '$mess',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ok'),
            )
          ],
        );
      },
    );
  }
}
