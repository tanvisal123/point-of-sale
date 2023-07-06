import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/ManageLocalData/constant_ip.dart';
import 'package:point_of_sale/src/controllers/check_privilege_conntroller.dart';
import 'package:point_of_sale/src/controllers/close_shift_controller.dart';
import 'package:point_of_sale/src/controllers/open_shift_controller.dart';
import 'package:point_of_sale/src/controllers/shift_template_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/close_shift_model.dart';
import 'package:point_of_sale/src/models/shift_template_model.dart';
import 'package:point_of_sale/src/printers/print_close_shift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class CloseShiftScreen extends StatefulWidget {
  final String ip;

  const CloseShiftScreen({Key key, @required this.ip}) : super(key: key);
  @override
  _CloseShiftScreenState createState() => _CloseShiftScreenState();
}

class _CloseShiftScreenState extends State<CloseShiftScreen> {
  var _f = NumberFormat('#,##0.00');
  double _total = 0;
  bool _status = false;

  ShiftTemplateModel _shiftTemplate = ShiftTemplateModel();
  void _getShiftTemplate() async {
    await ShiftTemplateController.getShiftTemplate(widget.ip).then((value) {
      if (mounted) setState(() => _shiftTemplate = value);
    });
    _status = true;
  }

  @override
  void initState() {
    _getShiftTemplate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _translat = AppLocalization.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_translat.getTranValue('close_shift'))),
      body: _status
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                children: [
                  SizedBox(height: 8.0),
                  _shiftTemplate.shiftForms.isNotEmpty
                      ? ListView(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          children: _shiftTemplate.shiftForms.map((e) {
                            return Column(
                              children: [
                                TextField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(fontSize: 19),
                                  decoration: InputDecoration(
                                    hintText: '0.00',
                                    labelText: "${e.currency}",
                                    labelStyle: TextStyle(
                                        fontSize: 17, color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[350]),
                                    ),
                                    prefixIcon: Icon(Icons.money),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey[400],
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  onChanged: (cash) {
                                    summmary(e.id, cash, e.rateIn);
                                  },
                                ),
                                SizedBox(height: 5),
                              ],
                            );
                          }).toList(),
                        )
                      : Container(),
                  Container(
                    height: 150.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Text(
                                  _translat.getTranValue('total_cash_out'),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${_f.format(_total)} ${_shiftTemplate.currencySys}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(color: Colors.black),
                        Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Text(
                                  _translat.getTranValue('grand_total'),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${_f.format(_shiftTemplate.grandTotalSys)} ${_shiftTemplate.currencySys}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: Container(
        child: MaterialButton(
          height: 50,
          splashColor: Colors.white,
          color: Theme.of(context).primaryColor,
          onPressed: () async {
            var prefs = await SharedPreferences.getInstance();
            var _checkPrintCloseShift =
                prefs.getBool('printCloseShift') ?? false;

            var checkOpenShift =
                await OpenShiftController.checkOpenShifts(ipAddress.ip);
            var check = await CheckPrivilegeController()
                .checkprivilege("P013", ipAddress.ip);
            if (check == "true") {
              if (checkOpenShift == "true") {
                ShowMessage.showLoading(
                    context, _translat.getTranValue('loading'));
                ProccesCloseShift proccesCloseShift =
                    await CloseShiftController.processCloseShift(
                        _total, ipAddress.ip);
                var isApproved = proccesCloseShift.isApproved;
                if (isApproved) {
                  ShowMessage.saveShift(
                      context, _translat.getTranValue('close_shift_success'),
                      () {
                    if (_checkPrintCloseShift) {
                      if (proccesCloseShift.items.closeShift == null) {
                      } else {
                        PrintCashOut(proccesCloseShift: proccesCloseShift)
                            .startPrint();
                      }
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false);
                  });
                } else {
                  ShowMessage.saveShift(
                      context, _translat.getTranValue('close_shift_failed'),
                      () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                }
              } else {
                ShowMessage.notOpenShift(
                  context,
                  AppLocalization.of(context)
                      .getTranValue('open_shift_befor_pay'),
                  widget.ip,
                );
              }
            } else {
              _hasNotPermission(
                AppLocalization.of(context).getTranValue('user_no_permission'),
              );
            }
          },
          child: Text(
            _translat.getTranValue('save'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
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

  void summmary(int id, String cash, double rate) {
    double sum = 0;
    _shiftTemplate.shiftForms.forEach((x) {
      if (x.id == id) {
        if (cash == '')
          x.inputCash = 0;
        else
          x.inputCash = double.tryParse(cash) * rate;
      }
      sum += x.inputCash;
    });
    setState(() => _total = sum);
  }
}
