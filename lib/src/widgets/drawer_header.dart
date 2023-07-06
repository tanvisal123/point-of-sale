import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:point_of_sale/src/controllers/company_controller.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/compay_modal.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

Directory _appDocsDir;

class HeaderDrawer extends StatefulWidget {
  final String ip;

  const HeaderDrawer({Key key, @required this.ip}) : super(key: key);
  @override
  _HeaderDrawerState createState() => _HeaderDrawerState();
}

class _HeaderDrawerState extends State<HeaderDrawer> {
  List<CompanyModel> _companyList = [];
  var _userName, _logo, _company;
  Future<void> _getCompany() async {
    var _result = await DataConnectionChecker().hasConnection;
    if (_result) {
      await CompanyController.eachCompany(widget.ip).then((value) {
        if (mounted) {
          setState(() => _companyList.addAll(value));
        }
      });
      var _pref = await SharedPreferences.getInstance();
      _pref.setString('logo',
          '${widget.ip + "/Images/company/${_companyList.first.image}"}');
      _pref.setString('company', _companyList.first.name);

      _logo = _pref.getString('logo');
      _company = _pref.getString('company');
      _userName = await FlutterSession().get('userName');
    } else {
      ShowMessage.showMessageSnakbar('No internet connection', context);
    }
  }

  File _fileFromDocsDir(String filename) {
    String _pathName = p.join(_appDocsDir.path, filename);
    return File(_pathName);
  }

  Future<void> _saveLogo() async {
    _appDocsDir = await getApplicationDocumentsDirectory();
    var _pref = await SharedPreferences.getInstance();
    setState(() {
      _logo = _pref.getString('logo');
    });
    if (_logo == null) {
      _pref.setString('logo',
          '${widget.ip + "/Images/company/${_companyList.first.image}"}');
      _pref.setString('company', _companyList.first.name);
    } else {
      _logo = _pref.getString('logo');
      _company = _pref.getString('company');
      _userName = await FlutterSession().get('userName');
    }
  }

  @override
  void initState() {
    super.initState();
    // _getCompany();
    // _saveLogo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      height: 160.0,
      padding: EdgeInsets.only(top: 25.0),
      child: _logo != null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 30, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_userName' ?? 'Username',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                          ),
                        ),
                        Text(
                          _company ?? 'Company',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _logo != null
                            ? NetworkToFileImage(
                                url: _logo,
                                file: _fileFromDocsDir("logo.png"),
                                debug: true,
                              )
                            : AssetImage('assets/icons/person_icon.png'),
                      ),
                    ),
                    height: 70.0,
                    width: 70.0,
                  ),
                ],
              ),
            )
          : Center(
              // child: CircularProgressIndicator(color: Colors.black,),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 70,
              child: Image.asset('assets/icons/person_icon.png',fit: BoxFit.cover,)),
        ),
            ),
    );
  }
}
