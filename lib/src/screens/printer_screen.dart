import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/widgets/card_custom.dart';
import 'package:point_of_sale/src/widgets/custom_card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PrinterPage extends StatefulWidget {
  final String ip;
  PrinterPage({this.ip, Key key}) : super(key: key);

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

GlobalKey _globalKey = GlobalKey();

class _PrinterPageState extends State<PrinterPage> {
  TextEditingController controllerPay = TextEditingController();
  TextEditingController controllerSend = TextEditingController();
  TextEditingController controllerBill = TextEditingController();
  var sysType;
  bool _isPrintAdress;
  bool _isPrintEnHasLogo;
  bool _isPrintEnNoLogo;
  bool _isPrintKhHasLogo;
  bool _isPrintKhNoLogo;
  bool _isLogoPrint = false;
  bool _isPrintBranch;
  bool _isShowCount;
  bool _isShowDateIn;
  bool _isShowDateOut;
  void initialzePagecouter() async {
    var pref = await SharedPreferences.getInstance();
    var pPay = pref.getInt('paymentcopy') ?? 1;
    var pSend = pref.getInt('sendcopy') ?? 1;
    var pBill = pref.getInt('billcopy') ?? 1;
    setState(() {
      sysType = pref.get("systemType");
      controllerPay.text = pPay.toString();
      // pref.getInt('paymentcopy').toString() ?? '1'.toString();
      controllerSend.text = pSend.toString();
      //pref.getInt('sendcopy').toString() ?? '1'.toString();
      controllerBill.text = pBill.toString();
      // pref.getInt('billcopy').toString() ?? '1'.toString();
    });

    print('System :$sysType');
    print(controllerPay.text);
  }

  void setPageCounter(int payNum, int sendNum, int billNum) async {
    var pref = await SharedPreferences.getInstance();
    _isPrintAdress = pref.getBool("isPrintAddress");
    pref.setInt('paymentcopy', payNum);
    pref.setInt('sendcopy', sendNum);
    pref.setInt('billcopy', billNum);
  }

  void checkPrintAdress() async {
    var pref = await SharedPreferences.getInstance();
    _isPrintAdress = pref.getBool("isPrintAddress") ?? false;
    _isPrintEnHasLogo = pref.getBool("isPrintEnHasLogo") ?? false;
    _isPrintEnNoLogo = pref.getBool("isPrintEnNoLogo") ?? true;
    _isPrintKhHasLogo = pref.getBool("isPrintKhHasLogo") ?? false;
    _isPrintKhNoLogo = pref.getBool("isPrintKhNoLogo") ?? false;
    _isPrintBranch = pref.getBool("isPrintBranch") ?? false;
    _isShowCount = pref.getBool("isShowCount") ?? false;
    _isShowDateIn = pref.getBool("isShowDateIn") ?? true;
    _isShowDateOut = pref.getBool("isShowDateOut") ?? true;
    print("show address = $_isPrintAdress");
    print("printEnHasL = $_isPrintEnHasLogo");
    print("printEnNoL = $_isPrintEnNoLogo");
    print("printKHhasl = $_isPrintKhHasLogo");
    print("printkhnol =  $_isPrintKhNoLogo");
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

  _checkLogoPrint() async {
    var prefs = await SharedPreferences.getInstance();
    var _logoPrint = prefs.getBool('logoPrint') ?? false;
    if (_logoPrint) {
      setState(() => _isLogoPrint = true);
    } else {
      setState(() => _isLogoPrint = false);
    }
  }

  @override
  void initState() {
    initialzePagecouter();
    checkPrintAdress();
    _checkLogoPrint();
    super.initState();
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
              onPressed: () async {
                _openGallery();
                var prefs = await SharedPreferences.getInstance();
                setState(() => _isLogoPrint = true);
                if (_isLogoPrint) {
                  prefs.setBool('logoPrint', true);
                } else {
                  prefs.setBool('logoPrint', false);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _translat = AppLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(fontSize: 20),
        title: Text(AppLocalization.of(context).getTranValue(
          'printer_options',
        )),
        centerTitle: false,
        actions: [
          MaterialButton(
            onPressed: () {
              setState(() {
                setPageCounter(
                    int.parse(controllerPay.text ?? '1'.toString()),
                    int.parse(controllerSend.text ?? '1'.toString()),
                    int.parse(controllerBill.text ?? '1'.toString()));
              });
              print('value=$controllerPay');
              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                borderSide: const BorderSide(
                  color: Colors.green,
                  width: 2,
                ),
                width: 360,
                buttonsBorderRadius: const BorderRadius.all(
                  Radius.circular(2),
                ),
                dismissOnTouchOutside: true,
                dismissOnBackKeyPress: false,
                headerAnimationLoop: false,
                animType: AnimType.RIGHSLIDE,
                title: AppLocalization.of(context).getTranValue('done'),
                // desc: AppLocalization.of(context)
                //     .getTranValue('do_you_want_to_reprint?'),
                showCloseIcon: true,
                btnOkOnPress: () {
                  setState(() {});
                },
              ).show().whenComplete(() => Navigator.pop(context));
            },
            child: Text(
              AppLocalization.of(context).getTranValue('save'),
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Form(
              key: _globalKey,
              child: Column(
                children: [
                  CustomCard(
                    title: "Show Address on Receipt",
                    tralling: Switch(
                      value: _isPrintAdress,
                      onChanged: (value) async {
                        var prf = await SharedPreferences.getInstance();
                        setState(() {
                          _isPrintAdress = value;
                          prf.setBool("isPrintAddress", _isPrintAdress);
                        });
                        print(_isPrintAdress);
                      },
                      activeTrackColor: Theme.of(context).primaryColorLight,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),

                  CustomCard(
                    title: "Show Branch on Receipt",
                    tralling: Switch(
                      value: _isPrintBranch,
                      onChanged: (value) async {
                        var prf = await SharedPreferences.getInstance();
                        setState(() {
                          _isPrintBranch = value;
                          prf.setBool("isPrintBranch", _isPrintBranch);
                        });
                      },
                      activeTrackColor: Theme.of(context).primaryColorLight,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  CustomCard(
                    title: "Show Count on Receipt",
                    tralling: Switch(
                      value: _isShowCount,
                      onChanged: (value) async {
                        var prf = await SharedPreferences.getInstance();
                        setState(() {
                          _isShowCount = value;
                          prf.setBool("isShowCount", _isShowCount);
                        });
                      },
                      activeTrackColor: Theme.of(context).primaryColorLight,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  CustomCard(
                    onPress: () {
                      _confirmDailog();
                    },
                    title: "Print Logo",
                    tralling: Switch(
                      value: _isLogoPrint,
                      onChanged: (value) async {
                        var prefs = await SharedPreferences.getInstance();
                        setState(() => _isLogoPrint = value);
                        if (_isLogoPrint) {
                          prefs.setBool('logoPrint', true);
                        } else {
                          prefs.setBool('logoPrint', false);
                        }
                      },
                      activeTrackColor: Theme.of(context).primaryColorLight,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),

                  CustomCard(
                    title: "Show date out on receipt",
                    tralling: Switch(
                      value: _isShowDateOut,
                      onChanged: (value) async {
                        var prf = await SharedPreferences.getInstance();
                        setState(() {
                          _isShowDateOut = value;
                          prf.setBool("isShowDateOut", _isShowDateOut);
                        });
                      },
                      activeTrackColor: Theme.of(context).primaryColorLight,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),

                  CustomCard(
                    title: "Show date in on receipt",
                    tralling: Switch(
                      value: _isShowDateIn,
                      onChanged: (value) async {
                        var prf = await SharedPreferences.getInstance();
                        setState(() {
                          _isShowDateIn = value;
                          prf.setBool("isShowDateIn", _isShowDateIn);
                        });
                      },
                      activeTrackColor: Theme.of(context).primaryColorLight,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),

                  // Card(
                  //   child: GestureDetector(
                  //     onTap: (() {
                  //       _confirmDailog();
                  //     }),
                  //     child: Container(
                  //       height: 50,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(12),
                  //         //color: Colors.grey,
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //         children: [
                  //           Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Text(
                  //                 "Print Logo",
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     fontSize: 20),
                  //               ),
                  //             ],
                  //           ),
                  //           Switch(
                  //             value: _isLogoPrint,
                  //             onChanged: (value) async {
                  //               var prefs =
                  //                   await SharedPreferences.getInstance();
                  //               setState(() => _isLogoPrint = value);
                  //               if (_isLogoPrint) {
                  //                 prefs.setBool('logoPrint', true);
                  //               } else {
                  //                 prefs.setBool('logoPrint', false);
                  //               }
                  //             },
                  //             activeTrackColor:
                  //                 Theme.of(context).primaryColorLight,
                  //             activeColor: Theme.of(context).primaryColor,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  CustomCard(
                    title: "Print English has Logo",
                    tralling: Switch(
                      value: _isPrintEnHasLogo,
                      onChanged: (value) async {
                        var prf = await SharedPreferences.getInstance();
                        setState(() {
                          _isPrintEnHasLogo = value;
                          _isPrintEnNoLogo = false;
                          _isPrintKhHasLogo = false;
                          _isPrintKhNoLogo = false;
                          prf.setBool("isPrintEnHasLogo", _isPrintEnHasLogo);
                          prf.setBool("isPrintEnNoLogo", false);
                          prf.setBool("isPrintKhHasLogo", false);
                          prf.setBool("isPrintKhNoLogo", false);
                        });
                        print(_isPrintEnHasLogo);
                      },
                      activeTrackColor: Theme.of(context).primaryColorLight,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),

                  // Card(
                  //   child: Container(
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(12),
                  //       //color: Colors.grey,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       children: [
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text(
                  //               "Print English has Logo",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 20),
                  //             ),
                  //           ],
                  //         ),
                  //         Switch(
                  //           value: _isPrintEnHasLogo ?? true,
                  //           onChanged: (value) async {
                  //             var prf = await SharedPreferences.getInstance();
                  //             setState(() {
                  //               _isPrintEnHasLogo = value;
                  //               prf.setBool(
                  //                   "isPrintEnHasLogo", _isPrintEnHasLogo);
                  //             });
                  //             print(_isPrintEnHasLogo);
                  //           },
                  //           activeTrackColor:
                  //               Theme.of(context).primaryColorLight,
                  //           activeColor: Theme.of(context).primaryColor,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  CustomCard(
                    title: "Print English No Logo",
                    tralling: Switch(
                      value: _isPrintEnNoLogo,
                      onChanged: (value) async {
                        var prf = await SharedPreferences.getInstance();
                        setState(() {
                          _isPrintEnNoLogo = value;
                          _isPrintEnHasLogo = false;
                          _isPrintKhHasLogo = false;
                          _isPrintKhNoLogo = false;
                          prf.setBool("isPrintEnNoLogo", _isPrintEnNoLogo);
                          prf.setBool("isPrintEnHasLogo", false);
                          prf.setBool("isPrintKhHasLogo", false);
                          prf.setBool("isPrintKhNoLogo", false);
                        });
                        print(_isPrintEnNoLogo);
                      },
                      activeTrackColor: Theme.of(context).primaryColorLight,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),

                  // Card(
                  //   child: Container(
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(12),
                  //       //color: Colors.grey,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       children: [
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text(
                  //               "Print English No Logo ",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 20),
                  //             ),
                  //           ],
                  //         ),
                  //         Switch(
                  //           value: _isPrintEnNoLogo ?? true,
                  //           onChanged: (value) async {
                  //             var prf = await SharedPreferences.getInstance();
                  //             setState(() {
                  //               _isPrintEnNoLogo = value;
                  //               prf.setBool(
                  //                   "isPrintEnNoLogo", _isPrintEnNoLogo);
                  //             });
                  //             print(_isPrintEnNoLogo);
                  //           },
                  //           activeTrackColor:
                  //               Theme.of(context).primaryColorLight,
                  //           activeColor: Theme.of(context).primaryColor,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  CustomCard(
                    title: "Print Khmer has Logo",
                    tralling: Switch(
                      value: _isPrintKhHasLogo,
                      onChanged: (value) async {
                        var prf = await SharedPreferences.getInstance();
                        setState(() {
                          _isPrintKhHasLogo = value;
                          _isPrintEnNoLogo = false;
                          _isPrintEnHasLogo = false;
                          _isPrintKhNoLogo = false;
                          prf.setBool("isPrintKhHasLogo", _isPrintKhHasLogo);
                          prf.setBool("isPrintEnNoLogo", false);
                          prf.setBool("isPrintEnHasLogo", false);
                          prf.setBool("isPrintKhNoLogo", false);
                        });
                      },
                      activeTrackColor: Theme.of(context).primaryColorLight,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  // Card(
                  //   child: Container(
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(12),
                  //       //color: Colors.grey,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       children: [
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text(
                  //               "Print Khmer has Logo",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 20),
                  //             ),
                  //           ],
                  //         ),
                  //         Switch(
                  //           value: _isPrintKhHasLogo,
                  //           onChanged: (value) async {
                  //             var prf = await SharedPreferences.getInstance();
                  //             setState(() {
                  //               _isPrintKhHasLogo = value;
                  //               prf.setBool(
                  //                   "isPrintKhHasLogo", _isPrintKhHasLogo);
                  //             });
                  //           },
                  //           activeTrackColor:
                  //               Theme.of(context).primaryColorLight,
                  //           activeColor: Theme.of(context).primaryColor,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  CustomCard(
                    title: "Print Khmer No Logo",
                    tralling: Switch(
                      value: _isPrintKhNoLogo,
                      onChanged: (value) async {
                        var prf = await SharedPreferences.getInstance();
                        setState(() {
                          _isPrintKhNoLogo = value;
                          _isPrintKhHasLogo = false;
                          _isPrintEnNoLogo = false;
                          _isPrintEnHasLogo = false;
                          prf.setBool("isPrintKhNoLogo", _isPrintKhNoLogo);
                          prf.setBool("isPrintKhHasLogo", false);
                          prf.setBool("isPrintEnNoLogo", false);
                          prf.setBool("isPrintEnHasLogo", false);
                        });
                      },
                      activeTrackColor: Theme.of(context).primaryColorLight,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),

                  // Card(
                  //   child: Container(
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(12),
                  //       //color: Colors.grey,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       children: [
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text(
                  //               "Print Khmer No Logo",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 20),
                  //             ),
                  //           ],
                  //         ),
                  //         Switch(
                  //           value: _isPrintKhNoLogo,
                  //           onChanged: (value) async {
                  //             var prf = await SharedPreferences.getInstance();
                  //             setState(() {
                  //               _isPrintKhNoLogo = value;
                  //               prf.setBool(
                  //                   "isPrintKhNoLogo", _isPrintKhNoLogo);
                  //             });
                  //           },
                  //           activeTrackColor:
                  //               Theme.of(context).primaryColorLight,
                  //           activeColor: Theme.of(context).primaryColor,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Card(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        //color: Colors.grey,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalization.of(context)
                                    .getTranValue('print_pay'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .getTranValue('copy_page'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          Container(
                            height: 60,
                            width: 150,
                            // decoration: BoxDecoration(),
                            child: TextFormField(
                              decoration:
                                  InputDecoration(border: OutlineInputBorder()),
                              controller: controllerPay ?? '1'.toString(),
                              style: TextStyle(fontSize: 20),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('([0-9][0-9]?|100)'),
                                ),
                                LengthLimitingTextInputFormatter(3),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  sysType == "KBMS"
                      ? SizedBox()
                      : Card(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              //color: Colors.grey,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalization.of(context)
                                          .getTranValue('print_send'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      AppLocalization.of(context)
                                          .getTranValue('copy_page'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 60,
                                  width: 150,
                                  // decoration: BoxDecoration(),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder()),
                                    controller:
                                        controllerSend ?? '1'.toString(),
                                    style: TextStyle(fontSize: 20),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('([0-9][0-9]?|100)'),
                                      ),
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                  sysType == "KBMS"
                      ? SizedBox()
                      : Card(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              //color: Colors.grey,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalization.of(context)
                                          .getTranValue('print_bill'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      AppLocalization.of(context)
                                          .getTranValue('copy_page'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                sysType == "KBMS"
                                    ? SizedBox()
                                    : Container(
                                        height: 60,
                                        width: 150,
                                        // decoration: BoxDecoration(),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                          controller:
                                              controllerBill ?? '1'.toString(),
                                          style: TextStyle(fontSize: 20),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp('([0-9][0-9]?|100)'),
                                            ),
                                            LengthLimitingTextInputFormatter(3),
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                ],
              ))
        ],
      ),
    );
  }
}
