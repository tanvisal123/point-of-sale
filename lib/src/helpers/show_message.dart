import 'package:flutter/material.dart';
import 'package:point_of_sale/src/controllers/check_privilege_conntroller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/screens/open_shift_screen.dart';

class ShowMessage {
  static void comfirmDialog(
      BuildContext context, String title, String des, Function onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Container(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            )),
        content: Text(
          des,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalization.of(context).getTranValue('cancel'))),
          TextButton(
            onPressed: onTap,
            child: Text(AppLocalization.of(context).getTranValue('ok')),
          )
        ],
      ),
    );
  }

  static void alertCommingSoon(
      BuildContext context, String title, String desc) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Container(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            )),
        content: Text(
          desc,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalization.of(context).getTranValue('ok')),
          ),
        ],
      ),
    );
  }

  static Future showMessageSnakbar(String message, BuildContext context,
      {Duration duration: const Duration(seconds: 3)}) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  static void showLoading(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: Container(
          width: 150.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.0),
              CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void buildAlertDialog(BuildContext context, bool status) {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Center(
        child: Container(
          height: 160,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Text(
                  AppLocalization.of(context).getTranValue('confirm'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(
                    AppLocalization.of(context).getTranValue('you_sure'),
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                            AppLocalization.of(context).getTranValue('cancel')),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          status = true;
                        },
                        child: Text(
                            AppLocalization.of(context).getTranValue('yes')),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> hasNotPermission(
      BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            '$message',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Color.fromRGBO(75, 181, 69, 1),
              shape: StadiumBorder(),
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Row(
                children: [
                  Icon(Icons.check_box, color: Colors.white, size: 18),
                  SizedBox(width: 5),
                  Text(
                    AppLocalization.of(context).getTranValue('ok'),
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> notOpenShift(
      BuildContext context, String message, String ip) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            '$message',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalization.of(context).getTranValue('ok')),
              onPressed: () async {
                var per =
                    await CheckPrivilegeController().checkprivilege("P012", ip);
                if (per == 'false') {
                  Navigator.of(context).pop();
                  hasNotPermission(
                      context,
                      AppLocalization.of(context)
                          .getTranValue('user_no_permission'));
                } else {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OpenShiftScreen(ip: ip),
                    ),
                  );
                }

                // var per =
                //     await PermissionController.checkPermissionOpenShift(ip);
                // if (per == 'false') {
                //   Navigator.of(context).pop();
                //   hasNotPermission(
                //       context,
                //       AppLocalization.of(context)
                //           .getTranValue('user_no_permission'));
                // } else {
                //   Navigator.of(context).pop();
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => OpenShiftScreen(ip: ip),
                //     ),
                //   );
                // }
              },
            ),
            TextButton(
              child: Text(AppLocalization.of(context).getTranValue('cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> saveShift(
      BuildContext context, String message, Function onPress) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            '$message',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalization.of(context).getTranValue('ok')),
              onPressed: onPress,
            ),
          ],
        );
      },
    );
  }
}
