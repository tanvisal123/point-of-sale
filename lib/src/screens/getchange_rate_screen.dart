import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:point_of_sale/src/controllers/getchangerate_template_controller.dart';
import 'package:point_of_sale/src/controllers/savedisplaycurrecy_controller.dart';
import 'package:point_of_sale/src/models/getchangerate_template.dart';

import '../controllers/check_privilege_conntroller.dart';
import '../helpers/app_localization.dart';
import '../helpers/show_message.dart';

class ChangeRate extends StatefulWidget {
  const ChangeRate({Key key, @required this.ip}) : super(key: key);
  final String ip;
  @override
  State<ChangeRate> createState() => _ChangeRateState();
}

class _ChangeRateState extends State<ChangeRate> {
  bool ck = false;
  List<GetChangeRateTemplate> list = [], tempList = [];
  getChangeRate() async {
    var connection = await DataConnectionChecker().hasConnection;
    if (connection) {
      try {
        await GetChangeRateTemplateController()
            .getChangeRatetemplate(widget.ip, 0)
            .then((value) {
          setState(() {
            tempList = list = value;
            print('List Or getChang Rate:${list.first.plCurrencyName}');
          });
        });
      } finally {
        ck = true;
      }
    } else {
      ShowMessage.showMessageSnakbar(
          AppLocalization.of(context).getTranValue('no_internet'), context);
    }
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
              child: Text(AppLocalization.of(context).getTranValue('ok')),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getChangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        title: Text(
          AppLocalization.of(context).getTranValue('change_rate'),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
              mouseCursor: MouseCursor.defer,
              onPressed: () {
                getChangeRate();
              },
              icon: Icon(Icons.refresh)),
          SizedBox(
            width: 10,
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.QUESTION,
                    headerAnimationLoop: false,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Do you want to save change?',
                    desc: 'Click OK to save change rate...',
                    buttonsTextStyle: const TextStyle(color: Colors.black),
                    showCloseIcon: false,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      setState(() {
                        list = tempList;
                      });
                      var check = await CheckPrivilegeController()
                          .checkprivilege("P023", widget.ip);
                      if (check == "true") {
                        try {
                          await SaveDisplayCurrencisController()
                              .saveDisplaycurrencies(widget.ip, list)
                              .whenComplete(() => getChangeRate());
                        } catch (e) {
                          print(e.toString());
                        }
                      } else {
                        _hasNotPermission(AppLocalization.of(context)
                            .getTranValue('user_no_permission'));
                      }
                    },
                  ).show();
                });
              },
              child: Text(
                AppLocalization.of(context).getTranValue("save"),
                style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: ck
          ? Column(
              children: [
                DataTable(
                  showBottomBorder: true,
                  columns: <DataColumn>[
                    DataColumn(
                        label: Text(
                      'Pricelist',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                            AppLocalization.of(context).getTranValue("other"),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text(
                            AppLocalization.of(context).getTranValue("rate"),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                  rows: tempList
                      .map(
                        (e) => DataRow(cells: [
                          DataCell(Center(child: Text(e.plCurrencyName))),
                          DataCell(Center(child: Text(e.alCurrencyName))),
                          DataCell(
                            Container(
                              width: 100,
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('([0-9]|[\.])'),
                                  ),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: e.displayRate.toString(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (double.parse(value) == 0.0) {
                                      ScaffoldMessenger(
                                          child: SnackBar(
                                              content: Text(
                                                  'something wrong please try again')));
                                    } else {
                                      e.displayRate = double.parse(value);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                      )
                      .toList(),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
