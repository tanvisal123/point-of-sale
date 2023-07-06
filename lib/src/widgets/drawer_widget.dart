import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/screens/contact_screen.dart';
import 'package:point_of_sale/src/screens/home_screen.dart';
import 'package:point_of_sale/src/screens/login_screen.dart';
import 'package:point_of_sale/src/screens/report_screen.dart';
import 'package:point_of_sale/src/screens/sale_screen.dart';
import 'package:point_of_sale/src/screens/setting_screen.dart';
import 'package:point_of_sale/src/screens/table_group_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_header.dart';
import 'list_drawer.dart';

class DrawerWidget extends StatefulWidget {
  final int selected;
  final String ip;
  const DrawerWidget({this.selected = 1, @required this.ip});
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  var sysType;
  void getSystempType() async {
    var prefre = await SharedPreferences.getInstance();
    sysType = prefre.get("systemType");
    print("system type : $sysType");
  }

  @override
  void initState() {
    super.initState();
    getSystempType();
  }

  @override
  Widget build(BuildContext context) {
    var _translat = AppLocalization.of(context);
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 15,
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    HeaderDrawer(ip: widget.ip),
                    ListDrawer(
                      label: _translat.getTranValue('home'),
                      selected: widget.selected == 1,
                      selectedColor: Colors.grey.withOpacity(0.3),
                      leading: Icons.home_outlined,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(ip: widget.ip)),
                          (route) => false,
                        );
                      },
                    ),
                    ListDrawer(
                      label: _translat.getTranValue('sale'),
                      selected: widget.selected == 2,
                      selectedColor: Colors.grey.withOpacity(0.3),
                      leading: Icons.shopping_bag_outlined,
                      onTap: () async {
                        if (sysType == 'KRMS') {
                          // var _details =
                          //     await SaleController().selectOrderDetail();
                          // if (_details.length > 0) {
                          //   await SaleController().deleteAllOrder();
                          //   await SaleController().deleteAllOrderDetail();
                          // }
                          // var _orders =
                          //     await SaleController.getOrder(0, widget.ip);
                          // //----Has order on table---
                          // if (_orders.length > 0) {
                          //   buildOrder(_orders[0]);
                          // }
                          // //----No order on table------
                          // //============================
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TableScreen(ip: widget.ip),
                            ),
                            (route) => false,
                          );
                        } else if (sysType == 'KBMS') {
                          // BlocProvider.of<BlocOrder>(context)
                          //     .add(EventOrder.delete());
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SaleScreen(
                                ip: widget.ip,
                                level: 1,
                                // group1: 1,
                                // group2: 1,
                                // group3: 1,
                                tableId: 0,
                                orderId: 0,
                                defaultOrder: true,
                              ),
                            ),
                            (route) => true,
                          );
                        }
                      },
                    ),
                    ListDrawer(
                      label: _translat.getTranValue('report'),
                      selected: widget.selected == 3,
                      selectedColor: Colors.grey.withOpacity(0.3),
                      leading: Icons.article_outlined,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ReportScreen(ip: widget.ip)),
                          (route) => false,
                        );
                      },
                    ),
                    // ListDrawer(
                    //   label: "Loyalty Program",
                    //   selected: widget.selected == 7,
                    //   selectedColor: Colors.grey.withOpacity(0.3),
                    //   leading: Icons.loyalty_outlined,
                    //   onTap: () {
                    //     Navigator.pushAndRemoveUntil(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => LoyaltyProgram(ip: widget.ip),
                    //       ),
                    //       (route) => false,
                    //     );
                    //   },
                    // ),
                    Divider(),
                    ListDrawer(
                      label: _translat.getTranValue('setting'),
                      selected: widget.selected == 4,
                      selectedColor: Colors.grey.withOpacity(0.3),
                      leading: Icons.settings_outlined,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingScreen(ip: widget.ip),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                    ListDrawer(
                      label: _translat.getTranValue('contact'),
                      selected: widget.selected == 5,
                      selectedColor: Colors.grey.withOpacity(0.3),
                      leading: Icons.info_outline,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactScreen(ip: widget.ip),
                          ),
                          (route) => true,
                        );
                      },
                    ),
                    ListDrawer(
                      label: _translat.getTranValue('log_out'),
                      selected: widget.selected == 6,
                      selectedColor: Colors.grey.withOpacity(0.3),
                      leading: Icons.logout_outlined,
                      onTap: () {
                        FlutterSession().set("localCurr", 0);
                        //FlutterSession().set("systemType", '');
                        FlutterSession().set("userId", 0);
                        FlutterSession().set("branchId", 0);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                    // ListDrawer(
                    //   label: _translat.getTranValue('setting'),
                    //   selected: widget.selected == 7,
                    //   selectedColor: Colors.grey.withOpacity(0.3),
                    //   leading: Icons.settings_outlined,
                    //   onTap: () {
                    //     Navigator.pushAndRemoveUntil(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => SyncScreen(ip: widget.ip),
                    //       ),
                    //       (route) => false,
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            height: 50,
            color: Colors.white,
            child: ListTile(
              title: Text(
                'version : 1.5.0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )),
          Expanded(
              child: Container(
            height: 50,
            color: Colors.white,
          ))
        ],
      ),
    );
  }
}
