import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/src/bloc/customer_bloc/customer_bloc.dart';
import 'package:point_of_sale/src/bloc/group_table_bloc/grouptable_bloc.dart';
import 'package:point_of_sale/src/controllers/check_privilege_conntroller.dart';
import 'package:point_of_sale/src/controllers/sale_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';
import 'package:point_of_sale/src/models/order_modal.dart';
import 'package:point_of_sale/src/models/post_server_modal.dart';
import 'package:point_of_sale/src/screens/report_screen.dart';
import 'package:point_of_sale/src/screens/sale_screen.dart';
import 'package:point_of_sale/src/screens/setting_screen.dart';
import 'package:point_of_sale/src/screens/table_group_screen.dart';
import 'package:point_of_sale/src/screens/theme_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/fetchorder_controller.dart';
import 'login_screen.dart';
import 'open_shift_screen.dart';
import 'dart:developer' as dev;

class HomeScreen extends StatelessWidget {
  const HomeScreen({@required this.ip, this.token});
  final String ip;
  final String token;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'EDI POS',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: AppBody(ip: this.ip),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function onTap;

  MenuItem({this.iconData, this.title, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Icon(iconData, color: Colors.white),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(title, style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  String ip;
  final String token;
  AppBody({Key key, @required this.ip, this.token}) : super(key: key);

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  var token;
  var _systemType;
  void getToken() async {
    var _pref = await SharedPreferences.getInstance();
    widget.ip = _pref.getString('ip');
    dev.log("IP HomePage:${widget.ip}");
    token = _pref.getString("token");
    _systemType = _pref.getString("systemType");
    dev.log('');
    print("system type : $_systemType");
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.white, Theme.of(context).primaryColor],
                  radius: 0.5,
                ),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                children: [
                  MenuView(
                    iconData: Icons.shopping_bag_outlined,
                    menuName: AppLocalization.of(context).getTranValue('sale'),
                    onTap: () async {
                      var _prefs = await SharedPreferences.getInstance();
                      var _systemType = _prefs.getString('systemType');
                      FetchOrderModel fetchOrderModel =
                          await FetchOrderController()
                              .getFetchOrder(widget.ip, 0, 0, 0, true);
                      BlocProvider.of<CustomerBloc>(context)
                          .add(DeleteCustomerEvent());
                      if (_systemType == 'KRMS') {
                        BlocProvider.of<GrouptableBloc>(context)
                            .add(GroupTableEvent());
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TableScreen(ip: widget.ip),
                          ),
                          (route) => false,
                        );
                      } else if (_systemType == 'KBMS') {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SaleScreen(
                              ip: this.widget.ip,
                              level: 1,
                              tableId: fetchOrderModel.order.orderId,
                              orderId: fetchOrderModel.order.orderId,
                              defaultOrder: true,
                            ),
                          ),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Select SystemType")));
                      }
                    },
                  ),
                  MenuView(
                    iconData: Icons.article_outlined,
                    menuName:
                        AppLocalization.of(context).getTranValue('report'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ReportScreen(ip: this.widget.ip)),
                      );
                    },
                  ),
                  MenuView(
                    iconData: Icons.local_atm_outlined,
                    menuName:
                        AppLocalization.of(context).getTranValue('open_shift'),
                    onTap: () async {
                      var per = await CheckPrivilegeController()
                          .checkprivilege("P012", widget.ip);
                      if (per == 'false') {
                        ShowMessage.hasNotPermission(
                          context,
                          AppLocalization.of(context)
                              .getTranValue('user_no_permission'),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OpenShiftScreen(ip: this.widget.ip),
                          ),
                        );
                      }
                    },
                  ),
                  MenuView(
                    iconData: Icons.settings_outlined,
                    menuName:
                        AppLocalization.of(context).getTranValue('setting'),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingScreen(ip: widget.ip)),
                        (route) => false,
                      );
                    },
                  ),
                  MenuView(
                    iconData: Icons.dark_mode_outlined,
                    menuName: AppLocalization.of(context).getTranValue('theme'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThemeScreen()),
                      );
                    },
                  ),
                  MenuView(
                    iconData: Icons.logout_outlined,
                    menuName:
                        AppLocalization.of(context).getTranValue('log_out'),
                    onTap: () {
                      FlutterSession().set("localCurr", 0);
                      // FlutterSession().set("systemType", '');
                      FlutterSession().set("userId", 0);
                      FlutterSession().set("branchId", 0);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Flexible(
          //   flex: 1,
          //   child: Container(
          //     height: double.maxFinite,
          //     width: double.maxFinite,
          //     color: Theme.of(context).primaryColor,
          //     child: CarouselSlider(
          //       options: CarouselOptions(
          //         autoPlay: true,
          //         autoPlayAnimationDuration: Duration(milliseconds: 500),
          //       ),
          //       items: imgList
          //           .map((item) => Container(
          //                 child: Image.asset(
          //                   item,
          //                   fit: BoxFit.cover,
          //                   width: double.maxFinite,
          //                   height: double.maxFinite,
          //                 ),
          //               ))
          //           .toList(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

final List<String> imgList = [
  'assets/images/sale.png',
  'assets/images/sale5.png',
  'assets/images/sale2.jpg',
  'assets/images/sale3.jpg',
];

class MenuView extends StatelessWidget {
  final IconData iconData;
  final String menuName;
  final Function onTap;

  const MenuView({Key key, this.iconData, this.menuName, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData, size: 43.0, color: Colors.white),
            Text(
              menuName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        onPressed: onTap,
      ),
    );
  }
}

class BuildOrder {
  static void buildOrder(PostModel p) async {
    var _key = 0;
    OrderModel _order = OrderModel(
      orderId: p.orderId,
      orderNo: p.orderNo,
      tableId: p.tableId,
      receiptNo: p.receiptNo,
      queueNo: p.queueNo,
      dateIn: p.dateIn,
      dateOut: p.dateOut,
      timeIn: p.timeIn,
      timeOut: p.timeOut,
      waiterId: p.waiterId,
      userOrderId: p.userOrderId,
      userDiscountId: p.userDiscountId,
      customerId: p.customerId,
      customerCount: p.customerCount,
      priceListId: p.priceListId,
      localCurrencyId: p.localCurrencyId,
      sysCurrencyId: p.sysCurrencyId,
      exchangeRate: p.exchangeRate,
      warehouseId: p.warehouseId,
      branchId: p.branchId,
      companyId: p.companyId,
      subTotal: p.subTotal,
      discountRate: p.discountRate,
      discountValue: p.discountValue,
      typeDis: p.typeDis,
      taxRate: p.taxRate,
      taxValue: p.taxValue,
      grandTotal: p.grandTotal,
      grandTotalSys: p.grandTotalSys,
      tip: p.tip,
      received: p.received,
      change: p.change,
      currencyDisplay: p.currencyDisplay,
      displayRate: p.displayRate,
      grandTotalDisplay: p.grandTotalDisplay,
      changeDisplay: p.changeDisplay,
      paymentMeansId: p.paymentMeansId,
      checkBill: p.checkBill,
      cancel: p.cancel,
      delete: p.delete,
      paymentType: p.paymentType,
      receivedType: p.receivedType,
      credit: p.credit,
    );
    _key = await SaleController().insertOrder(_order);
    p.detail.forEach((e) {
      OrderDetail detail = OrderDetail(
        masterId: _key,
        orderDetailId: e.orderDetailId,
        orderId: e.orderId,
        lineId: e.lineId,
        itemId: e.itemId,
        code: e.code,
        khmerName: e.khmerName,
        englishName: e.englishName,
        qty: e.qty,
        printQty: e.printQty,
        unitPrice: e.unitPrice,
        cost: e.cost,
        discountRate: e.discountRate,
        discountValue: e.discountValue,
        typeDis: e.typeDis,
        total: e.total,
        totalSys: e.totalSys,
        uomId: e.uomId,
        uomName: e.uomName,
        itemStatus: e.itemStatus,
        itemPrintTo: e.itemPrintTo,
        currency: e.currency,
        comment: e.comment,
        itemType: e.itemType,
        description: e.description,
        parentLevel: e.parentLevel,
        image: e.image,
        show: 0,
      );
      SaleController().insertOrderDetail(detail);
    });
  }
}
