import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:point_of_sale/src/controllers/check_privilege_conntroller.dart';
import 'package:point_of_sale/src/controllers/system_type_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/screens/login_screen.dart';
import 'package:point_of_sale/src/screens/printer_screen.dart';
import 'package:point_of_sale/src/screens/reprint_close_shift_screen.dart';
import 'package:point_of_sale/src/screens/reprint_receipt_screen.dart';
import 'package:point_of_sale/src/screens/sale_screen.dart';
import 'package:point_of_sale/src/screens/theme_screen.dart';
import 'package:point_of_sale/src/widgets/card_custom.dart';
import 'package:point_of_sale/src/widgets/drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/customer_bloc/customer_bloc.dart';
import '../controllers/fetchorder_controller.dart';
import 'change_lang_screen.dart';
import 'close_shift_screen.dart';
import 'getchange_rate_screen.dart';
import 'open_shift_screen.dart';
import 'sale_group_screen.dart';
import 'table_group_screen.dart';

class SystemType {
  final int id;
  final String type;
  SystemType(this.id, this.type);
}

class SettingScreen extends StatefulWidget {
  final String ip;
  SettingScreen({Key key, @required this.ip}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isLogoPrint = false, status = false;

  _checkLogoPrint() async {
    var prefs = await SharedPreferences.getInstance();
    var _logoPrint = prefs.getBool('logoPrint') ?? false;
    if (_logoPrint) {
      setState(() => _isLogoPrint = true);
    } else {
      setState(() => _isLogoPrint = false);
    }
  }

  List<SystemType> _systemTypes = [];
  int _sysTypeId;
  int selectSysType = 0;
  var _sysTypeSaved;
  int values;
  List<String> listSysType = [];

  Future<void> getSysType() async {
    var prfr = await SharedPreferences.getInstance();
    await SystemTypeController.getSystemType(widget.ip).then((value) {
      setState(() {
        listSysType = value;
      });
      status = true;
      print("system type ${listSysType.toString()}");
    });
    _sysTypeSaved = prfr.get("systemType");
    print("system type saved : $_sysTypeSaved");
    if (_sysTypeSaved == "KRMS") {
      selectSysType = 0;
    } else if (_sysTypeSaved == "KBMS") {
      selectSysType = 1;
    } else if (_sysTypeSaved == "KTMS") {
      selectSysType = 2;
    } else if (_sysTypeSaved == "KSMS") {
      selectSysType = 3;
    } else {
      selectSysType = null;
    }
  }

  File _image;
  String _base64Image = '';

  _openGallery() async {
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      List<int> imageBytes = image2.readAsBytesSync();
      _base64Image = base64Encode(imageBytes);
      _image = image2;
    });
    if (_base64Image.isNotEmpty) {
      prefs.setString('img', _base64Image);
      String img = prefs.getString('img');
      print('IMG = $img');
      return Fluttertoast.showToast(
        msg: AppLocalization.of(context).getTranValue('logo_saved'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
        fontSize: 18.0,
      );
    }
    print('Image     = $_image');
    print('String64  = $_base64Image');
  }

  Future<void> _confirmDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            AppLocalization.of(context).getTranValue('img_must_be'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalization.of(context).getTranValue('ok')),
              onPressed: () {
                _openGallery();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  bool _chekPrintCloseShift;
  _getCheckPrintCloseShift() async {
    var prefs = await SharedPreferences.getInstance();
    _chekPrintCloseShift = prefs.getBool('printCloseShift') ?? false;
  }

  @override
  void initState() {
    super.initState();
    //_checkBarcode();
    _checkLogoPrint();
    getSysType();
    _getCheckPrintCloseShift();
  }

  @override
  Widget build(BuildContext context) {
    var _translat = AppLocalization.of(context);
    return Scaffold(
      backgroundColor: Colors.blue[50].withOpacity(0.5),
      drawer: DrawerWidget(selected: 4, ip: widget.ip),
      appBar: AppBar(
        title: Text(_translat.getTranValue('setting')),
      ),
      body: ListView(
        children: [
          CardCustom(
            leading: Icons.local_atm_outlined,
            title: _translat.getTranValue('open_shift'),
            onPress: () async {
              var per = await CheckPrivilegeController()
                  .checkprivilege("P012", widget.ip);
              if (per == 'false') {
                hasNotSetOpenShift(
                    _translat.getTranValue('user_no_permission'));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OpenShiftScreen(ip: widget.ip),
                  ),
                );
              }
            },
          ),
          //------------------- close shift -------------------------
          CardCustom(
            title: AppLocalization.of(context).getTranValue('close_shift'),
            leading: Icons.local_atm_outlined,
            onPress: () async {
              var per = await CheckPrivilegeController()
                  .checkprivilege("P013", widget.ip);
              if (per == 'false') {
                hasNotSetOpenShift(
                    _translat.getTranValue('user_no_permission'));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CloseShiftScreen(ip: widget.ip),
                  ),
                );
              }
            },
            tralling: Switch(
              value: _chekPrintCloseShift ?? false,
              onChanged: (value) async {
                var prefs = await SharedPreferences.getInstance();
                setState(() => _chekPrintCloseShift = value);
                if (_chekPrintCloseShift) {
                  prefs.setBool('printCloseShift', true);
                } else {
                  prefs.setBool('printCloseShift', false);
                }
                print('printCloseShift:$_chekPrintCloseShift');
              },
              activeTrackColor: Theme.of(context).primaryColorLight,
              activeColor: Theme.of(context).primaryColor,
            ),
          ),

          CardCustom(
            leading: Icons.local_atm_outlined,
            title:
                AppLocalization.of(context).getTranValue('reprint_closeshift'),
            onPress: () async {
              String per = await CheckPrivilegeController()
                  .checkprivilege("P014", widget.ip);
              if (per == 'false') {
                hasNotSetOpenShift(
                    _translat.getTranValue('user_no_permission'));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReprintCloseShiftScreen(ip: widget.ip),
                  ),
                );
              }
            },
          ),

          //----------- reprint receipt -----------------
          CardCustom(
            leading: Icons.receipt_long,
            title: AppLocalization.of(context).getTranValue('reprint_receipt'),
            onPress: () async {
              String per = await CheckPrivilegeController()
                  .checkprivilege("P014", widget.ip);
              if (per == 'false') {
                hasNotSetOpenShift(
                    _translat.getTranValue('user_no_permission'));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReprintReceiptScreen(ip: widget.ip),
                  ),
                );
              }
            },
          ),
          //--------------------------------------------------------

          // CardCustom(
          //   leading: Icons.document_scanner_outlined,
          //   onPress: () {},
          //   title: _translat.getTranValue('barcode'),
          //   tralling: Switch(
          //     value: _isBarcode,
          //     onChanged: (value) async {
          //       var prefs = await SharedPreferences.getInstance();
          //       setState(() {
          //         _isBarcode = value;
          //       });
          //       if (_isBarcode) {
          //         prefs.setBool('barcode', true);
          //       } else {
          //         prefs.setBool('barcode', false);
          //       }
          //     },
          //     activeTrackColor: Theme.of(context).primaryColorLight,
          //     activeColor: Theme.of(context).primaryColor,
          //   ),
          // ),
          // CardCustom(
          //   leading: Icons.photo_library_outlined,
          //   onPress: () {
          //     _confirmDailog();
          //   },
          //   title: _translat.getTranValue('logo_receipt'),
          //   tralling: Switch(
          //     value: _isLogoPrint,
          //     onChanged: (value) async {
          //       var prefs = await SharedPreferences.getInstance();
          //       setState(() => _isLogoPrint = value);
          //       if (_isLogoPrint) {
          //         prefs.setBool('logoPrint', true);
          //       } else {
          //         prefs.setBool('logoPrint', false);
          //       }
          //     },
          //     activeTrackColor: Theme.of(context).primaryColorLight,
          //     activeColor: Theme.of(context).primaryColor,
          //   ),
          // ),

          CardCustom(
            leading: Icons.settings_system_daydream_outlined,
            onPress: () {
              buildSystemType();
              //_buildSystemType();
            },
            title: _translat.getTranValue('system_type'),
          ),
          CardCustom(
            leading: Icons.language_outlined,
            title: _translat.getTranValue('change_lang'),
            onPress: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeLangScreen(),
                ),
              );
            },
          ),
          CardCustom(
            leading: Icons.sync_alt,
            title: AppLocalization.of(context).getTranValue('change_rate'),
            onPress: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangeRate(ip: widget.ip),
              ));
            },
          ),
          CardCustom(
            leading: Icons.palette_outlined,
            title: _translat.getTranValue('theme'),
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemeScreen()),
              );
            },
          ),
          CardCustom(
            leading: Icons.print_rounded,
            title: AppLocalization.of(context).getTranValue('setting_printer'),
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PrinterPage(
                            ip: widget.ip,
                          )));
            },
          ),
          CardCustom(
            leading: Icons.logout_outlined,
            title: _translat.getTranValue('log_out'),
            textColor: Colors.red,
            onPress: () {
              FlutterSession().set("localCurr", 0);
              //FlutterSession().set("systemType", _sysTypeSaved);
              FlutterSession().set("userId", 0);
              FlutterSession().set("branchId", 0);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
          SizedBox(height: 6.0),
        ],
      ),
    );
  }

  Future<void> buildSystemType() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                AppLocalization.of(context).getTranValue('system_type'),
              ),
              content: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        List<Widget>.generate(listSysType.length, (index) {
                      return RadioListTile(
                          title: Text(listSysType[index]),
                          value: index,
                          groupValue: selectSysType,
                          onChanged: (value) async {
                            setState(() {
                              selectSysType = value;
                            });
                            var _prf = await SharedPreferences.getInstance();
                            _sysTypeSaved = listSysType[value];
                            _prf.setString("systemType", _sysTypeSaved);
                          });
                    })),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text(AppLocalization.of(context).getTranValue('cancel')),
                ),
                SizedBox(width: 5.0),
                TextButton(
                  onPressed: () async {
                    ShowMessage.showLoading(
                      context,
                      AppLocalization.of(context).getTranValue('loading'),
                    );
                    await Future.delayed(Duration(seconds: 1));
                    if (_sysTypeSaved == "KBMS") {
                      FetchOrderModel fetchOrderModel =
                          await FetchOrderController()
                              .getFetchOrder(widget.ip, 0, 0, 0, true);
                      BlocProvider.of<CustomerBloc>(context)
                          .add(DeleteCustomerEvent());
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaleScreen(
                            ip: widget.ip,
                            level: 1,
                            tableId: fetchOrderModel.order.tableId,
                            orderId: fetchOrderModel.order.orderId,
                            defaultOrder: false,
                          ),
                        ),
                        (route) => false,
                      );
                    } else if (_sysTypeSaved == "KRMS") {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TableScreen(ip: widget.ip),
                        ),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please Select SystemType")));
                    }
                  },
                  child: Text(AppLocalization.of(context).getTranValue('ok')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Future<void> _buildSystemType() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: Text(
  //               AppLocalization.of(context).getTranValue('system_type'),
  //             ),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: _systemTypes
  //                     .map((e) => RadioListTile(
  //                           title: Text('${e.type}'),
  //                           groupValue: _sysTypeId,
  //                           value: e.id,
  //                           onChanged: (value) {
  //                             _sysTypeId = e.id;
  //                             _sysTypeSaved = e.type;
  //                             print('SystemTypeId = $_sysTypeId');
  //                             setState(() {});
  //                           },
  //                         ))
  //                     .toList(),
  //               ),
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child:
  //                     Text(AppLocalization.of(context).getTranValue('cancel')),
  //               ),
  //               SizedBox(width: 5.0),
  //               TextButton(
  //                 onPressed: () async {
  //                   ShowMessage.showLoading(
  //                     context,
  //                     AppLocalization.of(context).getTranValue('loading'),
  //                   );
  //                   await Future.delayed(Duration(seconds: 1));
  //                   var prefs = await SharedPreferences.getInstance();
  //                   prefs.setString('systemType', _sysTypeSaved);
  //                   if (_sysTypeId == 1) {
  //                     Navigator.pushAndRemoveUntil(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => TableScreen(ip: widget.ip),
  //                       ),
  //                       (route) => false,
  //                     );
  //                     print('1');
  //                   } else if (_sysTypeId == 2) {
  //                     // BlocProvider.of<BlocOrder>(context)
  //                     //     .add(EventOrder.delete());
  //                     Navigator.pop(context);
  //                     Navigator.pop(context);
  //                     // Navigator.pushAndRemoveUntil(
  //                     //   context,
  //                     //   MaterialPageRoute(
  //                     //     builder: (context) => SaleGroupScreen(
  //                     //       type: 'G1',
  //                     //       postList: [],
  //                     //       ip: widget.ip,
  //                     //     ),
  //                     //   ),
  //                     //   (route) => true,
  //                     // );
  //                     print('2');
  //                   } else {
  //                     Navigator.pop(context);
  //                     print('3');
  //                   }
  //                 },
  //                 child: Text(AppLocalization.of(context).getTranValue('ok')),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Future<void> hasNotSetOpenShift(String mess) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            '$mess',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              child: Text(AppLocalization.of(context).getTranValue('ok')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
