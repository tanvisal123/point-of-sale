import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/controllers/open_shift_controller.dart';
import 'package:point_of_sale/src/controllers/shift_template_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/shift_template_model.dart';

class OpenShiftScreen extends StatefulWidget {
  final String ip;

  const OpenShiftScreen({Key key, @required this.ip}) : super(key: key);
  @override
  _OpenShiftScreenState createState() => _OpenShiftScreenState();
}

class _OpenShiftScreenState extends State<OpenShiftScreen> {
  var _f = NumberFormat('#,##0.00');
  double _total = 0.0;
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
      appBar: AppBar(title: Text(_translat.getTranValue('open_shift'))),
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
                                    _summmary(e.id, cash, e.rateIn);
                                  },
                                ),
                                SizedBox(height: 5),
                              ],
                            );
                          }).toList(),
                        )
                      : Container(),
                  Container(
                    height: 80.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _translat.getTranValue('total_cash_in'),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${_f.format(_total)} ${_shiftTemplate.currencySys}",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
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
      bottomNavigationBar: MaterialButton(
        height: 50,
        splashColor: Colors.white,
        color: Theme.of(context).primaryColor,
        onPressed: () async {
          ShowMessage.showLoading(context, _translat.getTranValue('loading'));
          await OpenShiftController.processOpenShift(_total, widget.ip);
          ShowMessage.saveShift(
              context, _translat.getTranValue('open_shift_success'), () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          });
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
    );
  }

  void _summmary(int id, String cash, double rate) {
    double sum = 0;
    _shiftTemplate.shiftForms.forEach((x) {
      if (x.id == id) {
        if (cash == "")
          x.inputCash = 0;
        else
          x.inputCash = double.tryParse(cash) * rate;
      }
      sum += x.inputCash;
    });
    setState(() => _total = sum);
  }
}

class SummaryOpenShift {
  int id;
  double value;
  SummaryOpenShift(this.id, this.value);
}

class ShowHied {
  int show;
  int key;
  double qty;
  ShowHied({this.show, this.key, this.qty});
}
