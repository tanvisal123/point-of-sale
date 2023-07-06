import 'dart:async';
import 'dart:io';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:point_of_sale/src/ManageLocalData/access_ip.dart';
import 'package:point_of_sale/src/bloc/lang_bloc/language_bloc.dart';
import 'package:point_of_sale/src/constants/style_widge.dart';
import 'package:point_of_sale/src/controllers/account_loging_controller.dart';
import 'package:point_of_sale/src/controllers/system_type_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/account_loging.dart';
import 'package:point_of_sale/src/models/compay_modal.dart';
import 'package:point_of_sale/src/models/return_from_server_login.dart';
import 'package:point_of_sale/src/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'dart:developer' as dev;

enum Language { en, km }

Directory _appDocsDir;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AccessIPController accessIPController = Get.put(AccessIPController());
  //---------------
  List<CompanyModel> _companyList = [];
  var _logo, _company = '';
  bool _status = true, isExpired;
  String _sysTypeSaved;
  String saveSysType;
  var token;
  String ipLocal;
  bool _loading = false;
  List<String> listTest = [""];
  List<String> _systemTypeList = [];
  Future<void> _getSystemTypes() async {
    var prefs = await SharedPreferences.getInstance();
    await SystemTypeController.getSystemType(accessIPController.ip)
        .then((value) {
      setState(() {
        _systemTypeList = value;
        _loading = true;
      });
    });
    await prefs.setString('systemType', _systemTypeList.first ?? '');
  }

  File _fileFromDocsDir(String filename) {
    String _pathName = p.join(_appDocsDir.path, filename);
    return File(_pathName);
  }

  // Future<void> _saveLogo() async {
  //   print('Logo    = $_logo');
  //   print('Company = $_company');
  //   if (widget.ip != null) {
  //     _appDocsDir = await getApplicationDocumentsDirectory();
  //     var _pref = await SharedPreferences.getInstance();
  //     if (_logo.isEmpty) {
  //       _pref.setString(
  //         'logo',
  //         '${widget.ip + '/Images/company/${_companyList.first.image}'}',
  //       );
  //       _pref.setString('company', _companyList.first.name);
  //     } else {
  //       _logo = _pref.getString('logo');
  //       _company = _pref.getString('company');
  //     }
  //     setState(() {});
  //   } else {
  //     print('IP is Null');
  //   }
  // }

  //---------------
  bool _showPassword = false, _obscureText = true, _colorUsername = true;
  bool _withUsername = true, _colorPass = true, _withPass = true;
  bool _valid = false, _isChecked = false;
  String _two;

  var _username = TextEditingController();
  var _password = TextEditingController();
  var _ipController;
  Language _language = Language.en;

  Future<void> _getLanguage() async {
    var _prefs = await SharedPreferences.getInstance();
    var _countryCode = _prefs.getString('conCode') ?? 'US';
    if (_countryCode == 'US') {
      setState(() => _language = Language.en);
    } else {
      setState(() => _language = Language.km);
    }
  }

  Future<void> _getRemember() async {
    var _prefs = await SharedPreferences.getInstance();
    _sysTypeSaved = _prefs.getString("systemType");
  }

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<DisplaycurrBloc>(context).add(GetDisplayCurrEvent());
    // BlocProvider.of<PaymentmeanBloc>(context).add(GetPaymenyMeanEvent());
    // BlocProvider.of<OpenShiftBloc>(context).add(GetOpenShiftEvent());
    // BlocProvider.of<SettingBloc>(context).add(GetSettingEvent());
    _getLanguage();
    if (accessIPController.ip != null ||
        accessIPController.ip != '' ||
        accessIPController.ip != 'http://') {
      _getSystemTypes();
    }
    _ipController =
        TextEditingController(text: accessIPController.ip ?? 'http://');
    //_getCompany();

    _getRemember();
  }

  Widget _buildUsernameTF(BuildContext context) {
    var _translat = AppLocalization.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50.0,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: _colorUsername ? Color(0xFF689F38) : Colors.red,
                width: _withUsername ? 0.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  spreadRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _username,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                  fontSize: 17.0, color: Colors.black, fontFamily: 'OpenSans'),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(top: 14.0, left: 20.0, right: 20.0),
                suffixIcon: Icon(Icons.person_outline, color: Colors.black),
                hintText: _translat.getTranValue('enter_username'),
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
          _colorUsername == false
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    _translat.getTranValue('user_required'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                )
              : Container(height: 0.0),
        ],
      ),
    );
  }

  Widget _buildPasswordTF(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50.0,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: _colorPass ? Theme.of(context).primaryColor : Colors.red,
                width: _withPass ? 0.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 3.0),
                ),
              ],
            ),
            child: TextField(
              controller: _password,
              obscureText: _obscureText,
              style: TextStyle(
                  fontSize: 17.0, color: Colors.black, fontFamily: 'OpenSans'),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(top: 14.0, left: 20.0, right: 20.0),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword
                          ? _showPassword = false
                          : _showPassword = true;
                      _obscureText ? _obscureText = false : _obscureText = true;
                    });
                  },
                ),
                hintText:
                    AppLocalization.of(context).getTranValue('enter_password'),
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
          _colorPass == false
              ? Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    AppLocalization.of(context)
                        .getTranValue('password_required'),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                )
              : Text('')
        ],
      ),
    );
  }

  Widget _buildLoginBTN(BuildContext context, String ip) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          padding: EdgeInsets.all(15.0),
          child: Text(
            AppLocalization.of(context).getTranValue('login'),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          onPressed: () async {
            if (_username.text.trim() == '') {
              setState(() {
                _colorUsername = false;
                _withUsername = false;
              });
              //  return;
            } else {
              setState(() {
                _colorUsername = true;
                _withUsername = true;
              });
            }
            if (_password.text.trim() == '') {
              setState(() {
                _colorPass = false;
                _withPass = false;
              });
              // return;
            } else {
              setState(() {
                _colorPass = true;
                _withPass = true;
              });
            }

            ShowMessage.showLoading(
              context,
              AppLocalization.of(context).getTranValue('loading'),
            );
            await Future.delayed(Duration(seconds: 1));
            bool _connection = await DataConnectionChecker().hasConnection;
            if (_connection) {
              AccountLogin account = AccountLogin(
                password: _password.text.trim(),
                userName: _username.text.trim(),
              );
              ReturnFromServerLogin _statue =
                  await LoginController().login(account, accessIPController.ip);
              var _pref = await SharedPreferences.getInstance();
              print("Hello Status: $_status");
              if (_statue.message != null) {
                dev.log('Token:${_statue.accessToken}');
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(_statue.message)));
              } else {
                var pfr = await SharedPreferences.getInstance();
                _sysTypeSaved =
                    pfr.getString('systemType') ?? _systemTypeList.first;
                pfr.setString("systemType", _sysTypeSaved);
                setState(() {
                  isExpired = Jwt.isExpired(_statue.accessToken);
                  if (_status != null) {
                    if (isExpired) {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Your Token Has Expire"),
                        ),
                      );
                    } else if (isExpired == false) {
                      _pref.setString("userName", _username.text.trim());
                      token = _pref.setString("token", _statue.accessToken);
                      print("token save : $token");
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(ip: accessIPController.ip)),
                        (route) => false,
                      );
                    } else {
                      return null;
                    }
                  }
                });
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalization.of(context).getTranValue('no_internet'),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildVilidPassEmail(BuildContext context) {
    return Center(
      child: _two == 'U'
          ? Text(
              AppLocalization.of(context).getTranValue('invalid_user_pass'),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            )
          : Text(
              AppLocalization.of(context).getTranValue('user_no_permission'),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
    );
  }

  Widget _buildLanguage(BuildContext context) {
    final _langBloc = BlocProvider.of<LanguageBloc>(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      height: 113.0,
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          RadioListTile<Language>(
            title: Text('ភាសាខ្មែរ'),
            value: Language.km,
            groupValue: _language,
            onChanged: (Language value) {
              _language = value;
              _langBloc.add(LoadLanguage(Locale(value.toString(), 'KH')));
            },
          ),
          Divider(color: Theme.of(context).primaryColor, height: 0.0),
          RadioListTile<Language>(
            title: Text('English'),
            value: Language.en,
            groupValue: _language,
            onChanged: (Language value) {
              _language = value;
              _langBloc.add(LoadLanguage(Locale(value.toString(), 'US')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRemember() {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) return Colors.blue;
      return Colors.white;
    }

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Text(
            AppLocalization.of(context).getTranValue('remember'),
            style: kLabelStyle,
          ),
        ),
        Checkbox(
          checkColor: Colors.blue,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: _isChecked,
          onChanged: (bool value) {
            setState(() {
              _isChecked = value;
              print('Check = $_isChecked');
            });
          },
        ),
      ],
    );
  }

  Widget _buildSetting(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.3),
      ),
      child: IconButton(
        onPressed: () {
          _buildDialogSetting(context);
        },
        icon: Icon(Icons.settings_outlined),
      ),
    );
  }

  Future<void> _buildDialogSetting(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            controller: _ipController,
            style: TextStyle(fontSize: 20.0),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'IP Address',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('SAVE'),
              onPressed: () async {
                await accessIPController.setIP(_ipController.text);
                Navigator.pop(context);
                showDialog(
                  useSafeArea: true,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        height: 100,
                        width: 100,
                        child: Center(
                          child: FlutterSplashScreen.gif(
                            backgroundColor: Colors.white,
                            gifPath: 'assets/gif/129394-tri-cube-loader-2.gif',
                            gifWidth: double.infinity,
                            gifHeight: double.infinity,
                           defaultNextScreen: LoginScreen(),
                            duration: const Duration(milliseconds: 3515),
                            onInit: () async {
                              debugPrint("onInit 1");
                              await Future.delayed(
                                  const Duration(milliseconds: 2000));
                              debugPrint("onInit 2");
                            },
                            onEnd: () async {
                              debugPrint("onEnd 1");
                              debugPrint("onEnd 2");
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
                await Future.delayed(Duration(seconds: 3));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _buildDialogPermission(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _ipController,
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('CONFIRM'),
              onPressed: () async {
                Navigator.pop(context);
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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: _status
          ? SafeArea(
              child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _logo != null && accessIPController.ip != null
                              ? NetworkToFileImage(
                                  url: _logo,
                                  file: _fileFromDocsDir('logo.png'),
                                  debug: true,
                                )
                              : AssetImage('assets/icons/person_icon.png'),
                        ),
                      ),
                      height: 100.0,
                      width: 100.0,
                    ),
                    _company.isEmpty ||
                            _company == null && accessIPController.ip == null
                        ? SizedBox(height: 0.0)
                        : Text(
                            _company,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    SizedBox(height: 16.0),
                    _buildUsernameTF(context),
                    _buildPasswordTF(context),

                    _buildSystemType(),

                    // _buildSystemType(),
                    //_buildRemember(),
                    SizedBox(height: 16.0),
                    _buildLoginBTN(context, accessIPController.ip),
                    SizedBox(height: 10.0),
                    _valid
                        ? _buildVilidPassEmail(context)
                        : Container(height: 0.0),
                    SizedBox(height: 16.0),
                    _buildLanguage(context),
                    _buildSetting(context),
                  ],
                ),
              ),
            ))
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSystemType() {
    return _loading
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: _systemTypeList == null
                ? SizedBox(
                    height: 0,
                    width: 0,
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: CustomDropdownButton2(
                      icon: Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        // size: 25,
                      ),
                      iconSize: 25,
                      buttonWidth: double.infinity,
                      buttonHeight: 50,
                      dropdownWidth: 360,
                      dropdownPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                      buttonDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      dropdownDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      hint: 'select item',
                      value: _sysTypeSaved ?? _systemTypeList.first,
                      dropdownItems: _systemTypeList,
                      onChanged: (value) async {
                        final _prefs = await SharedPreferences.getInstance();
                        setState(() {
                          _sysTypeSaved = value;
                          _prefs.setString("systemType", _sysTypeSaved);
                          var saved = _prefs.getString("systemType");
                          print("system saved : $saved");
                        });
                      },
                    ),
                  ),
          )
        : SizedBox();
  }
}
