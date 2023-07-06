import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/bloc/customer_bloc/customer_bloc.dart';
import 'package:point_of_sale/src/bloc/order_bloc/order_bloc.dart';
import 'package:point_of_sale/src/controllers/change_table_controller.dart';
import 'package:point_of_sale/src/controllers/check_privilege_conntroller.dart';
import 'package:point_of_sale/src/controllers/combine_order_controller.dart';
import 'package:point_of_sale/src/controllers/fetchorder_controller.dart';
import 'package:point_of_sale/src/controllers/member_card_controller/member_card_dis_controller.dart';
import 'package:point_of_sale/src/controllers/move_order_controller.dart';
import 'package:point_of_sale/src/controllers/open_shift_controller.dart';
import 'package:point_of_sale/src/controllers/post_order_to_server.dart';
import 'package:point_of_sale/src/controllers/service_table_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/combine_order_model.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/member_card_discount.dart';
import 'package:point_of_sale/src/models/order_to_combine.dart';
import 'package:point_of_sale/src/models/table_modal.dart';
import 'package:point_of_sale/src/printers/print_bill.dart';
import 'package:point_of_sale/src/printers/print_order.dart';
import 'package:point_of_sale/src/screens/byone_getone_screen.dart';
import 'package:point_of_sale/src/screens/detail_item_screen.dart';
import 'package:point_of_sale/src/screens/edit_price_screen.dart';
import 'package:point_of_sale/src/screens/item_not_enough_stock_screen.dart';
import 'package:point_of_sale/src/screens/new_payment_screen.dart';
import 'package:point_of_sale/src/screens/peding_void_item_screen.dart';
import 'package:point_of_sale/src/screens/sale_screen.dart';
import 'package:point_of_sale/src/screens/split_order_screen.dart';
import 'package:point_of_sale/src/screens/table_group_screen.dart';
import 'package:point_of_sale/src/screens/void_item_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class DetailSaleScreen extends StatefulWidget {
  String ip;
  final int orderId;
  final int tableId;
  final FetchOrderModel fetchOrderModel;
  DetailSaleScreen({
    Key key,
    @required this.ip,
    @required this.orderId,
    @required this.fetchOrderModel,
    @required this.tableId,
  }) : super(key: key);

  @override
  State<DetailSaleScreen> createState() => _DetailSaleScreenState();
}

class _DetailSaleScreenState extends State<DetailSaleScreen> {
  var sysType;
  FetchOrderModel fetchOrderModel;
  List<OrderDetailModel> list = [];
  List<ShowHide> showlist = [];
  List<Order> orderList = [];
  List<OrderToCombine> orderToCom;
  List<TableModel> listTable;
  double countQty = 0;
  Timer _timer;
  Order order;
  Order copyOrder;
  DisplayPayOtherCurrency currency;
  TaxGroup taxGroup;
  LoyaltyProgram loyaltyProgram;
  double totalTaxvalue = 0;
  var _controllerTotalAmont = TextEditingController();
  var _controllerDisValue = TextEditingController();
  var _controllerDisRate = TextEditingController();
  bool loading = false, stutus = false;
  void getOrder() async {
    setState(() {
      fetchOrderModel = widget.fetchOrderModel;
      orderList = widget.fetchOrderModel.orders;
      order = fetchOrderModel.order;
      copyOrder = Order.copy(order);
      currency = fetchOrderModel.displayCurrency
          .firstWhere((e) => e.altCurrencyId == e.baseCurrencyId);
      loyaltyProgram = fetchOrderModel.loyaltyProgram;
    });
  }

  void getTable() async {
    await TableController.getTable(0, widget.ip).then((value) {
      setState(() {
        listTable = value;
        loading = true;
      });
    });
  }

  void getOrderToCombine() async {
    await CombineOrderController.getOrderToCombine(widget.ip, order.orderId)
        .then((value) {
      setState(() {
        orderToCom = value;
        stutus = true;
      });
      for (var temp in orderToCom) {
        print("title note : ${temp.titleNote}");
      }
    });
  }

  double sumItemsTotal(Order order, Setting setting) {
    double subtotal = 0;
    double taxValue = 0;
    for (var item in order.orderDetail) {
      subtotal += getItemTotal(item, fetchOrderModel.setting);
      if (setting.taxOption > 0) {
        taxValue += item.taxValue;
      }
    }
    order.discountValue = subtotal * order.discountRate / 100;
    order.subTotal = subtotal;
    order.taxValue = taxValue;
    order.grandTotal = order.subTotal - order.discountValue;
    if (setting.taxOption == 3) {
      taxGroup = fetchOrderModel.taxGroup
          .firstWhere((element) => element.id == setting.tax);
      order.taxRate = taxGroup.rate;
      taxValue = (order.subTotal - order.discountValue) * order.taxRate / 100;
      order.taxValue = taxValue;
      order.grandTotal = order.grandTotal + order.taxValue;
    }
    return order.grandTotal;
  }

  static double getItemTotal(OrderDetailModel orderDetail, Setting setting) {
    double lineTotalNoTax = orderDetail.qty *
        orderDetail.unitPrice *
        (1 - orderDetail.discountRate / 100);
    orderDetail.total = lineTotalNoTax;
    // print("line total no tax : $lineTotalNoTax");
    switch (setting.taxOption) {
      case 1:
        orderDetail.taxValue = lineTotalNoTax * orderDetail.taxRate / 100;
        orderDetail.total = lineTotalNoTax + orderDetail.taxValue;
        break;
      case 2:
        orderDetail.taxValue =
            lineTotalNoTax * orderDetail.taxRate / (100 + orderDetail.taxRate);
        orderDetail.total = lineTotalNoTax;
        break;
      case 3:
        orderDetail.taxRate = 0;
        orderDetail.taxValue = 0;
        break;
    }
    // print("total line item : ${orderDetail.total}");
    return orderDetail.total;
  }

  void bindShowHide() async {
    setState(() {
      list = widget.fetchOrderModel.order.orderDetail;
      list.forEach((e) {
        ShowHide sh = ShowHide(show: 0, key: e.lineId);
        showlist.add(sh);
      });
    });
    showlist.forEach((element) {
      print("show hide : ${element.key}");
    });
  }

  void getSystemType() async {
    var prefr = await SharedPreferences.getInstance();
    setState(() {
      sysType = prefr.getString("systemType");
    });
    print("system type : $sysType");
  }

  @override
  void initState() {
    print("tax value : ${widget.fetchOrderModel.order.taxValue}");
    super.initState();
    getSystemType();
    bindShowHide();
    getOrder();
    getTable();
    getOrderToCombine();
    sumItemsTotal(order, fetchOrderModel.setting);
    _controllerDisValue.text = '0.00';
    _controllerDisRate.text = '0.00';
  }

  @override
  Widget build(BuildContext context) {
    var _translat = AppLocalization.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            sysType == 'KRMS'
                ? "${fetchOrderModel.orderTable.name} #${order.orderNo}"
                : "#${order.orderNo}",
            style: TextStyle(fontSize: 12),
          ),
          actions: [
            order.orderId == 0
                ? SizedBox(height: 0, width: 0)
                : IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaleScreen(
                            orderId: order.orderId,
                            defaultOrder: true,
                            level: 1,
                            // group1: 1,
                            // group2: 1,
                            // group3: 1,
                            tableId: order.tableId,
                            ip: widget.ip,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    icon: Icon(
                      Icons.add,
                      size: 20,
                    )),
            IconButton(
              onPressed: () {
                buildPromotion(context);
              },
              icon: Icon(Icons.redeem_outlined),
            ),
            PopupMenuButton(
              iconSize: 28.0,
              elevation: 3.0,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () async {
                      await Future.delayed(Duration(seconds: 1))
                          .whenComplete(_buildDiscountMember);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.group, color: Colors.black),
                        SizedBox(width: 10.0),
                        Text(AppLocalization.of(context)
                            .getTranValue("discount_member")),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      var check = await CheckPrivilegeController()
                          .checkprivilege("P022", widget.ip);
                      if (check == 'true') {
                        _buildDialogDiscount(context, fetchOrderModel);
                      } else {
                        _hasNotPermission(
                          AppLocalization.of(context)
                              .getTranValue('user_no_permission'),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.local_offer_outlined, color: Colors.black),
                        SizedBox(width: 10.0),
                        Text(
                          AppLocalization.of(context)
                              .getTranValue('discount_order'),
                        ),
                      ],
                    ),
                  ),
                  sysType == "KRMS"
                      ? PopupMenuItem(
                          onTap: () async {
                            var check = await CheckPrivilegeController()
                                .checkprivilege("P001", widget.ip);
                            if (check == 'true') {
                              if (order.orderId == 0) {
                                ShowMessage.alertCommingSoon(context,
                                    "Change Table", "Please Send befor Change");
                              } else {
                                getTableFree(listTable);
                              }
                            } else {
                              _hasNotPermission(
                                AppLocalization.of(context)
                                    .getTranValue('user_no_permission'),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.cached_outlined, color: Colors.black),
                              SizedBox(width: 10.0),
                              Text(
                                AppLocalization.of(context)
                                    .getTranValue('move_table'),
                              ),
                            ],
                          ),
                        )
                      : PopupMenuItem(
                          height: 0.0,
                          padding: EdgeInsets.all(0.0),
                          child: SizedBox(height: 0),
                        ),
                  sysType == "KRMS"
                      ? PopupMenuItem(
                          onTap: () async {
                            var check = await CheckPrivilegeController()
                                .checkprivilege("P001", widget.ip);
                            if (check == 'true') {
                              if (order.orderId == 0) {
                                ShowMessage.alertCommingSoon(context,
                                    "Move Order", "Please Send befor Move");
                              } else {
                                getAllTable(listTable);
                              }
                            } else {
                              _hasNotPermission(
                                AppLocalization.of(context)
                                    .getTranValue('user_no_permission'),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.content_cut, color: Colors.black),
                              SizedBox(width: 10.0),
                              Text(AppLocalization.of(context)
                                  .getTranValue('move_order')),
                            ],
                          ),
                        )
                      : PopupMenuItem(
                          height: 0.0,
                          padding: EdgeInsets.all(0.0),
                          child: SizedBox(height: 0),
                        ),
                  sysType == "KRMS"
                      ? PopupMenuItem(
                          onTap: () async {
                            var check = await CheckPrivilegeController()
                                .checkprivilege("P003", widget.ip);
                            if (check == 'true') {
                              if (order.orderId == 0) {
                                ShowMessage.alertCommingSoon(context,
                                    "Split Order", "Please Send befor Split");
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SplitOrderScreen(
                                      ip: widget.ip,
                                      tableId: widget.tableId,
                                      order: fetchOrderModel.order,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              _hasNotPermission(
                                AppLocalization.of(context)
                                    .getTranValue('user_no_permission'),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.content_copy, color: Colors.black),
                              SizedBox(width: 10.0),
                              Text(AppLocalization.of(context)
                                  .getTranValue('split_order')),
                            ],
                          ),
                        )
                      : PopupMenuItem(
                          height: 0.0,
                          padding: EdgeInsets.all(0.0),
                          child: SizedBox(height: 0),
                        ),
                  sysType == "KRMS"
                      ? PopupMenuItem(
                          onTap: () async {
                            var check = await CheckPrivilegeController()
                                .checkprivilege("P002", widget.ip);
                            if (check == 'true') {
                              if (order.orderId == 0) {
                                ShowMessage.alertCommingSoon(
                                    context,
                                    "Combine Order",
                                    "Please Send befor Combine");
                              } else {
                                orderToCombine(orderToCom);
                              }
                            } else {
                              _hasNotPermission(
                                AppLocalization.of(context)
                                    .getTranValue('user_no_permission'),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.slideshow, color: Colors.black),
                              SizedBox(width: 10.0),
                              Text(AppLocalization.of(context)
                                  .getTranValue('comebine_order')),
                            ],
                          ),
                        )
                      : PopupMenuItem(
                          height: 0.0,
                          padding: EdgeInsets.all(0.0),
                          child: SizedBox(height: 0),
                        ),
                  sysType == 'KRMS'
                      ? PopupMenuItem(
                          onTap: () async {
                            var check = await CheckPrivilegeController()
                                .checkprivilege("A047", widget.ip);
                            if (check == 'true') {
                              if (order.orderId == 0) {
                                ShowMessage.alertCommingSoon(context,
                                    "Void Order", "Please Send befor Void");
                              } else {
                                _voidOrder();
                              }
                            } else {
                              _hasNotPermission(
                                AppLocalization.of(context)
                                    .getTranValue('user_no_permission'),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.black),
                              SizedBox(width: 10.0),
                              Text(
                                AppLocalization.of(context)
                                    .getTranValue('void_order'),
                              ),
                            ],
                          ),
                        )
                      : PopupMenuItem(
                          onTap: () async {
                            await Future.delayed(Duration(seconds: 1));
                            Navigator.pop(context);
                            Navigator.push(
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
                                          defaultOrder: false,
                                        )));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.black),
                              SizedBox(width: 10.0),
                              Text(
                                AppLocalization.of(context)
                                        .getTranValue('clear_order') ??
                                    'Clear order',
                              ),
                            ],
                          ),
                        ),
                  //---------------- void item ------------------------------
                  sysType == "KRMS"
                      ? PopupMenuItem(
                          onTap: () async {
                            var check = await CheckPrivilegeController()
                                .checkprivilege("P026", widget.ip);
                            if (check == 'true') {
                              if (order.orderId == 0) {
                                ShowMessage.alertCommingSoon(context,
                                    "Void Item", "Please Send befor void");
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => VoidItemScreen(
                                              ip: widget.ip,
                                              order: copyOrder,
                                            )));
                              }
                            } else {
                              _hasNotPermission(
                                AppLocalization.of(context)
                                    .getTranValue('user_no_permission'),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.black),
                              SizedBox(width: 10.0),
                              Text(
                                AppLocalization.of(context)
                                    .getTranValue('void_item'),
                              ),
                            ],
                          ),
                        )
                      : PopupMenuItem(
                          height: 0.0,
                          padding: EdgeInsets.all(0.0),
                          child: SizedBox(height: 0),
                        ),
                  //------------------------------------------------------

                  //----------------------- pending void item ------------------------
                  sysType == "KRMS"
                      ? PopupMenuItem(
                          onTap: () async {
                            var check = await CheckPrivilegeController()
                                .checkprivilege("P026", widget.ip);
                            if (check == 'true') {
                              if (order.orderId == 0) {
                                ShowMessage.alertCommingSoon(
                                    context,
                                    "Pending Item",
                                    "Please Send befor Pending");
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PendingVoidItemScreen(
                                              ip: widget.ip,
                                              order: copyOrder,
                                            )));
                              }
                            } else {
                              _hasNotPermission(
                                AppLocalization.of(context)
                                    .getTranValue('user_no_permission'),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete_outlined, color: Colors.black),
                              SizedBox(width: 10.0),
                              Text("Pading Void Item"),
                            ],
                          ),
                        )
                      : PopupMenuItem(
                          height: 0.0,
                          padding: EdgeInsets.all(0.0),
                          child: SizedBox(height: 0),
                        ),
                  //----------------------------------------------------------
                  PopupMenuItem(
                    onTap: () async {
                      String check = await CheckPrivilegeController()
                          .checkprivilege("P004", widget.ip);
                      if (check == 'true') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditPriceScreen(
                                      ip: widget.ip,
                                      fetchOrderModel: fetchOrderModel,
                                    )));
                      } else {
                        _hasNotPermission(
                          AppLocalization.of(context)
                              .getTranValue('user_no_permission'),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.border_color, color: Colors.black),
                        SizedBox(
                          width: 10,
                        ),
                        Text(AppLocalization.of(context)
                            .getTranValue('edit_price'))
                      ],
                    ),
                  )
                ];
              },
            )
          ],
        ),
        body: ListView(
          children: [
            ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: _buidListWidget(fetchOrderModel),
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: fetchOrderModel.setting.taxOption == 0 ||
                  fetchOrderModel.order.taxValue == 0
              ? 120
              : 180,
          child: Column(
            children: [
              fetchOrderModel.setting.taxOption == 0 ||
                      fetchOrderModel.order.taxValue == 0 ||
                      order.orderDetail.isEmpty
                  ? SizedBox()
                  : Expanded(
                      flex: 3,
                      child: Container(
                          alignment: Alignment.center,
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                fetchOrderModel.setting.taxOption == 3
                                    ? Expanded(
                                        child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalization.of(context)
                                                      .getTranValue('tax_rate'),
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "${taxGroup.rate.toStringAsFixed(0)} %",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              ],
                                            )),
                                      )
                                    : SizedBox(),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalization.of(context)
                                              .getTranValue('tax_value'),
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${order.taxValue.toStringAsFixed(2)} ${currency.baseCurrency}",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
              Expanded(
                flex: 3,
                child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalization.of(context)
                                        .getTranValue('sub_total'),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${order.subTotal.toStringAsFixed(2) + " " + currency.baseCurrency}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalization.of(context)
                                        .getTranValue('total_dis'),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' ${order.discountValue.toStringAsFixed(2) + " " + currency.baseCurrency}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalization.of(context)
                                        .getTranValue('total_amount'),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' ${order.grandTotal.toStringAsFixed(2) + " " + currency.baseCurrency}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              sysType == 'KRMS'
                  ? Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.grey[400],
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: MaterialButton(
                                  splashColor: Colors.white,
                                  onPressed: () async {
                                    var checkOpenShift =
                                        await OpenShiftController
                                            .checkOpenShifts(widget.ip);

                                    if (checkOpenShift == "true") {
                                      _sendOrder(context, fetchOrderModel);
                                    } else {
                                      ShowMessage.notOpenShift(
                                        context,
                                        AppLocalization.of(context)
                                            .getTranValue(
                                                'open_shift_befor_pay'),
                                        widget.ip,
                                      );
                                    }
                                  },
                                  child: Text(
                                    _translat.getTranValue('send'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  child: MaterialButton(
                                    splashColor: Colors.white,
                                    onPressed: () async {
                                      var checkOpenShift =
                                          await OpenShiftController
                                              .checkOpenShifts(widget.ip);
                                      var check =
                                          await CheckPrivilegeController()
                                              .checkprivilege(
                                                  "P007", widget.ip);
                                      if (check == "true") {
                                        if (checkOpenShift == "true") {
                                          _buildBill(context, fetchOrderModel);
                                        } else {
                                          ShowMessage.notOpenShift(
                                            context,
                                            AppLocalization.of(context)
                                                .getTranValue(
                                                    'open_shift_befor_pay'),
                                            widget.ip,
                                          );
                                        }
                                      } else {
                                        _hasNotPermission(
                                          AppLocalization.of(context)
                                              .getTranValue(
                                                  'user_no_permission'),
                                        );
                                      }
                                    },
                                    child: Text(
                                      _translat.getTranValue('bill'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: MaterialButton(
                                  splashColor: Colors.white,
                                  onPressed: () async {
                                    var check = await CheckPrivilegeController()
                                        .checkprivilege("P008", widget.ip);
                                    if (check == "true") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MutipaymentScreen(
                                            ip: widget.ip,
                                            fetchOrderModel: fetchOrderModel,
                                          ),
                                        ),
                                      );
                                    } else {
                                      _hasNotPermission(
                                        AppLocalization.of(context)
                                            .getTranValue('user_no_permission'),
                                      );
                                    }
                                  },
                                  child: Text(
                                    AppLocalization.of(context)
                                        .getTranValue('pay'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 94, 153, 96),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              child: MaterialButton(
                                splashColor: Colors.white,
                                onPressed: () async {
                                  var checkOpenShift =
                                      await OpenShiftController.checkOpenShifts(
                                          widget.ip);
                                  if (checkOpenShift == "true") {
                                    _saveOrder(
                                      context,
                                      fetchOrderModel,
                                    );
                                  } else {
                                    ShowMessage.notOpenShift(
                                      context,
                                      AppLocalization.of(context)
                                          .getTranValue('open_shift_befor_pay'),
                                      widget.ip,
                                    );
                                  }
                                },
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranValue('save_order'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.grey[400],
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      child: MaterialButton(
                                        splashColor: Colors.white,
                                        onPressed: () async {
                                          var check =
                                              await CheckPrivilegeController()
                                                  .checkprivilege(
                                                      "P008", widget.ip);
                                          dev.log("Check privillege:$check");
                                          print("check = $check");
                                          if (check == "true") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MutipaymentScreen(
                                                        fetchOrderModel:
                                                            fetchOrderModel,
                                                        ip: widget.ip),
                                              ),
                                            );
                                          } else {
                                            _hasNotPermission(
                                              AppLocalization.of(context)
                                                  .getTranValue(
                                                      'user_no_permission'),
                                            );
                                          }
                                        },
                                        child: Text(
                                          AppLocalization.of(context)
                                              .getTranValue('pay'),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ));
  }

  Future<void> orderToCombine(List<OrderToCombine> list) async {
    int value;
    List<OrderToCombine> listCombine;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: Text(
                  AppLocalization.of(context).getTranValue('comebine_order')),
              content: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(list.length, (index) {
                      var data = list[index];
                      return RadioListTile(
                          title: Text(data.titleNote),
                          value: index,
                          groupValue: value,
                          onChanged: (int init) {
                            setState(() {
                              value = init;
                              listCombine = list
                                  .where((element) =>
                                      element.orderId == data.orderId)
                                  .toList();
                            });
                          });
                    })),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text(AppLocalization.of(context).getTranValue('cancel')),
                ),
                TextButton(
                  onPressed: listCombine != null
                      ? () async {
                          CombineOrder combineOrder = CombineOrder(
                              tableId: order.tableId,
                              orderId: order.orderId,
                              orders: listCombine);
                          await CombineOrderController.postCombineOrder(
                              widget.ip, combineOrder);
                          ShowMessage.showLoading(
                            context,
                            AppLocalization.of(context).getTranValue('loading'),
                          );
                          await Future.delayed(Duration(seconds: 1));
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SaleScreen(
                                // group1: 1,
                                // group2: 1,
                                // group3: 1,
                                orderId: 0,
                                defaultOrder: true,
                                ip: widget.ip,
                                level: 1,
                                tableId: fetchOrderModel.order.tableId,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Text(AppLocalization.of(context).getTranValue('ok')),
                ),
              ],
            );
          }));
        });
  }

  Future<void> getTableFree(List<TableModel> listTable) async {
    var tableFree = listTable.where((e) => e.status == "A").toList();
    for (var temp in listTable) {
      print("table Id : ${temp.id} (${temp.name}" "${temp.status})");
    }
    int value;
    var tableSelected;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title:
                  Text(AppLocalization.of(context).getTranValue("move_table")),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: loading
                      ? List.generate(tableFree.length, (index) {
                          return RadioListTile(
                              title: Text(tableFree[index].name),
                              value: index,
                              groupValue: value,
                              onChanged: (int init) {
                                setState(() {
                                  value = init;
                                  tableSelected = tableFree[init].id;
                                });
                                print("table id seleted : $tableSelected");
                              });
                        })
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text(AppLocalization.of(context).getTranValue('cancel')),
                ),
                TextButton(
                  onPressed: tableSelected != null
                      ? () async {
                          print("table id seleted : $tableSelected");
                          ShowMessage.showLoading(context, "Loading");
                          await Future.delayed(Duration(seconds: 1));
                          await ChangeTableController.getTableChange(widget.ip,
                              fetchOrderModel.order.tableId, tableSelected);
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TableScreen(ip: widget.ip),
                            ),
                            (route) => false,
                          );
                        }
                      : null,
                  child: Text(AppLocalization.of(context).getTranValue('ok')),
                ),
              ],
            );
          }));
        });
  }

  List<String> groupPromo = ["ByOne GetOne", "comboSale"];
  Future<void> buildPromotion(BuildContext context) {
    int value;
    int selected;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return AlertDialog(
                title: Text(
                  "Promotion",
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(groupPromo.length, (index) {
                    return RadioListTile(
                        title: Text(groupPromo[index]),
                        value: index,
                        groupValue: value,
                        onChanged: (int select) {
                          setState(
                            () {
                              value = select;
                              selected = select;
                            },
                          );
                        });
                  }),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                        AppLocalization.of(context).getTranValue('cancel')),
                  ),
                  TextButton(
                    onPressed: selected == null
                        ? null
                        : () {
                            if (selected == 0) {
                              Navigator.of(context).pop();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BuyOneGetOneScreen(
                                  loyaltyProgram: loyaltyProgram,
                                );
                              }));
                            }
                          },
                    child: Text(AppLocalization.of(context).getTranValue('ok')),
                  ),
                ],
              );
            }),
          );
        });
  }

  Future<void> getAllTable(List<TableModel> listTable) async {
    int value;
    var tableSelected;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title:
                  Text(AppLocalization.of(context).getTranValue('move_order')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: loading
                      ? List.generate(listTable.length, (index) {
                          return RadioListTile(
                              title: Text(listTable[index].name),
                              value: index,
                              groupValue: value,
                              onChanged: (int init) {
                                setState(() {
                                  value = init;
                                  tableSelected = listTable[init].id;
                                });
                                print("table id seleted : $tableSelected");
                              });
                        })
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text(AppLocalization.of(context).getTranValue('cancel')),
                ),
                TextButton(
                  onPressed: tableSelected != null
                      ? () async {
                          ShowMessage.showLoading(context, "Loading");
                          await Future.delayed(Duration(seconds: 1));
                          await MoveOrderController.getMoveOrder(
                              widget.ip,
                              fetchOrderModel.order.tableId,
                              tableSelected,
                              fetchOrderModel.order.orderId);
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TableScreen(ip: widget.ip),
                            ),
                            (route) => false,
                          );
                        }
                      : null,
                  child: Text(AppLocalization.of(context).getTranValue('ok')),
                ),
              ],
            );
          }));
        });
  }

  var cardNumberController = TextEditingController(text: "");
  String message = "";
  String value;
  Future<void> _scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'CANCEL', true, ScanMode.QR);
      if (!mounted) return;
      if (barcode.isEmpty) {
        return;
      } else {
        setState(() => cardNumberController.text = barcode);
      }
    } on PlatformException {
      cardNumberController.text = 'Failed to scan';
    }
  }

  Future<void> _buildDiscountMember() {
    var translate = AppLocalization.of(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              AppLocalization.of(context).getTranValue("discount_member"),
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(children: [
                TextFormField(
                  controller: cardNumberController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _scanBarcode();
                        },
                        icon: Icon(Icons.qr_code),
                      ),
                      labelText: translate.getTranValue("card_number")),
                ),
                message.isEmpty
                    ? SizedBox()
                    : Text(
                        message,
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
              ]),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalization.of(context).getTranValue('cancel'),
                ),
              ),
              TextButton(
                onPressed: () async {
                  MemberCardDiscount memberCardDis =
                      await MemberCardDisController().getMemberCardDiscount(
                          widget.ip,
                          cardNumberController.text.trim().isEmpty ||
                                  cardNumberController == null
                              ? "@ad"
                              : cardNumberController.text.trim(),
                          order.priceListId);
                  if (memberCardDis.isRejected || memberCardDis.isAlerted) {
                    setState(() {
                      message = "Not Found!";
                      print(message);
                    });
                  } else {
                    setState(() {
                      fetchOrderModel.order.customerId =
                          memberCardDis.items.data.customer.id;
                      fetchOrderModel.order.customer =
                          memberCardDis.items.data.customer;
                    });

                    BlocProvider.of<CustomerBloc>(context).add(
                        AddCustomerToOrderEvent(
                            ip: widget.ip,
                            orderId: widget.orderId,
                            tableId: widget.tableId,
                            defualtOrder: true,
                            customerId: memberCardDis.items.data.customer.id,
                            customer: memberCardDis.items.data.customer));
                    var discount =
                        memberCardDis.items.data.discount - order.subTotal;
                    if (memberCardDis.items.data.typeDiscount == 1) {
                      if (order.subTotal < memberCardDis.items.data.discount) {
                        ShowMessage.alertCommingSoon(context, "Over Discount",
                            "Required amount at least ${currency.baseCurrency} $discount more to use the member card discount.");
                      } else {
                        setState(() {
                          order.discountValue =
                              memberCardDis.items.data.discount;
                          order.discountRate =
                              order.discountValue * 100 / order.subTotal;
                        });
                        sumItemsTotal(order, fetchOrderModel.setting);
                        ShowMessage.showLoading(
                          context,
                          AppLocalization.of(context).getTranValue('loading'),
                        );
                        await Future.delayed(Duration(seconds: 1));
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DetailSaleScreen(
                                      ip: widget.ip,
                                      orderId: widget.orderId,
                                      fetchOrderModel: fetchOrderModel,
                                      tableId: order.tableId,
                                    )));
                      }
                    } else if (memberCardDis.items.data.typeDiscount == 0) {
                      if (memberCardDis.items.data.discount > 100) {
                        ShowMessage.alertCommingSoon(context, "Over Discount",
                            "Required amount at least ${currency.baseCurrency} $discount more to use the member card discount.");
                      } else {
                        setState(() {
                          order.discountRate =
                              memberCardDis.items.data.discount;
                        });
                        sumItemsTotal(order, fetchOrderModel.setting);

                        ShowMessage.showLoading(
                          context,
                          AppLocalization.of(context).getTranValue('loading'),
                        );
                        await Future.delayed(Duration(seconds: 1));
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DetailSaleScreen(
                                      ip: widget.ip,
                                      orderId: widget.orderId,
                                      fetchOrderModel: fetchOrderModel,
                                      tableId: order.tableId,
                                    )));
                      }
                    }
                  }
                },
                child: Text(
                  AppLocalization.of(context).getTranValue('ok'),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _buildDialogDiscount(
      BuildContext context, FetchOrderModel fetchOrderModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // list = fetchOrderModel.order.orderDetail;
        var order = fetchOrderModel.order;
        var currency = fetchOrderModel.displayCurrency.firstWhere(
            (element) => element.altCurrencyId == element.baseCurrencyId);
        _controllerTotalAmont.text = order.grandTotal.toStringAsFixed(2);
        _controllerDisValue.text = (order.discountValue).toStringAsFixed(2);
        return AlertDialog(
          title: Text(AppLocalization.of(context).getTranValue('dis_order')),
          content: SingleChildScrollView(
            child: ListBody(children: [
              TextFormField(
                controller: _controllerTotalAmont,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.black),
                  labelText:
                      '${AppLocalization.of(context).getTranValue('total_amount')} (${currency.baseCurrency})',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                enabled: double.parse(_controllerTotalAmont.text) <= 0
                    ? false
                    : true,
                controller: _controllerDisValue,
                onChanged: (value) {
                  if (value == '') {
                    _controllerDisValue.text = '0.00';
                  } else {
                    order.discountValue = double.parse(value);
                    _controllerDisRate.text =
                        (double.parse(value) * 100 / order.subTotal)
                            .toStringAsFixed(2);
                    order.discountRate =
                        double.parse(value) * 100 / order.subTotal;
                    _controllerTotalAmont.text =
                        (order.subTotal - double.parse(value))
                            .toStringAsFixed(2);
                    order.grandTotal = order.subTotal - double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _controllerDisValue.clear();
                      _controllerDisRate.text = '0.00';
                    },
                    icon: Icon(Icons.close),
                  ),
                  labelText:
                      '${AppLocalization.of(context).getTranValue('discount')} (${currency.baseCurrency})',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                enabled: double.parse(_controllerTotalAmont.text) <= 0
                    ? false
                    : true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp('^([1-9][0-9]?|100)\$'),
                  ),
                  LengthLimitingTextInputFormatter(3),
                ],
                controller: _controllerDisRate,
                onChanged: (value) {
                  if (value == '') {
                    _controllerDisValue.text = '0.00';
                  } else {
                    order.discountRate = double.parse(value);
                    _controllerDisValue.text =
                        ((order.subTotal * double.parse(value)) / 100)
                            .toStringAsFixed(2);
                    order.discountValue =
                        ((order.subTotal * double.parse(value)) / 100);
                    _controllerTotalAmont.text = (order.subTotal -
                            double.parse((_controllerDisValue.text)))
                        .toStringAsFixed(2);
                    order.grandTotal = order.subTotal -
                        double.parse((_controllerDisValue.text));
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _controllerDisRate.clear();
                      _controllerDisValue.text = '0.00';
                    },
                    icon: Icon(Icons.close),
                  ),
                  labelText:
                      '${AppLocalization.of(context).getTranValue('discount')} (%)',
                ),
              ),
            ]),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalization.of(context).getTranValue('cancel'),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (double.parse(_controllerTotalAmont.text) < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.white,
                      content: Text(
                        "Invalid Total Amount",
                        style: TextStyle(color: Colors.red),
                      )));
                } else {
                  sumItemsTotal(order, fetchOrderModel.setting);

                  ShowMessage.showLoading(
                    context,
                    AppLocalization.of(context).getTranValue('loading'),
                  );
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailSaleScreen(
                                ip: widget.ip,
                                orderId: widget.orderId,
                                fetchOrderModel: fetchOrderModel,
                                tableId: 0,
                              )));
                }
              },
              child: Text(
                AppLocalization.of(context).getTranValue('save'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _voidOrder() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            AppLocalization.of(context).getTranValue('title_void_order'),
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalization.of(context).getTranValue('cancel')),
            ),
            SizedBox(width: 5.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _buildReasonDialog();
              },
              child: Text(AppLocalization.of(context).getTranValue('ok')),
            ),
          ],
        );
      },
    );
  }

  Future<void> _buildBill(
      BuildContext context, FetchOrderModel fetchOrderModel) async {
    var pref = await SharedPreferences.getInstance();
    int count = pref.getInt('billcopy') ?? 1;
    bool isPrintEnBillhaslogo = pref.getBool("isPrintEnHasLogo") ?? false;
    bool isPrintEnBillNologo = pref.getBool("isPrintEnNoLogo") ?? true;
    bool isPrintKhHasLogo = pref.getBool("isPrintKhHasLogo") ?? false;
    bool isPrintKhNoLogo = pref.getBool("isPrintKhNoLogo") ?? false;
    var data =
        await PostOrder().sumitOrder(fetchOrderModel, "Bill", widget.ip, '1');
    var currency = fetchOrderModel.displayCurrency
        .firstWhere((e) => e.altCurrencyId == e.baseCurrencyId);
    if (data.itemsReturns.isNotEmpty || data.itemsReturns.length > 0) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotEnoughStockScreen(
            lsItemReturn: data.itemsReturns,
          ),
        ),
      );
    } else {
      if (count == 0) {
        ShowMessage.showLoading(context, "Loading");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => TableScreen(ip: widget.ip),
          ),
          (route) => false,
        );
      } else {
        fetchOrderModel = await FetchOrderController()
            .getFetchOrder(widget.ip, widget.tableId, order.orderId, 0, true);
        int i = 0;
        ShowMessage.showLoading(context, "Loading");
        if (isPrintEnBillhaslogo) {
          do {
            await Future.delayed(Duration(seconds: 1)).whenComplete(() =>
                NewPrintBill(
                        receiptInfoModel: data,
                        fetchOrderModel: fetchOrderModel)
                    .startPrintBill("Pay", currency));
            i < count - 1
                ? await Future.delayed(Duration(seconds: 3))
                : await Future.delayed(Duration(seconds: 0));
            i++;
          } while (i < count);
        } else if (isPrintEnBillNologo) {
          do {
            await Future.delayed(Duration(seconds: 1)).whenComplete(() =>
                EnPrintBillNoLogo(
                        receiptInfoModel: data,
                        fetchOrderModel: fetchOrderModel)
                    .startPrintBill("Pay", currency));
            i < count - 1
                ? await Future.delayed(Duration(seconds: 3))
                : await Future.delayed(Duration(seconds: 0));
            i++;
          } while (i < count);
        } else if (isPrintKhHasLogo) {
          do {
            await Future.delayed(Duration(seconds: 1)).whenComplete(() =>
                KhPrintBillHasLogo(
                        receiptInfoModel: data,
                        fetchOrderModel: fetchOrderModel)
                    .startPrintBill("Pay", currency));
            i < count - 1
                ? await Future.delayed(Duration(seconds: 3))
                : await Future.delayed(Duration(seconds: 0));
            i++;
          } while (i < count);
        } else if (isPrintKhNoLogo) {
          do {
            await Future.delayed(Duration(seconds: 1)).whenComplete(() =>
                KhPrintBillNoLogo(
                        receiptInfoModel: data,
                        fetchOrderModel: fetchOrderModel)
                    .startPrintBill("Pay", currency));
            i < count - 1
                ? await Future.delayed(Duration(seconds: 3))
                : await Future.delayed(Duration(seconds: 0));
            i++;
          } while (i < count);
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => TableScreen(ip: widget.ip),
          ),
          (route) => false,
        );
      }
    }
  }

  Future<void> _sendOrder(
      BuildContext context, FetchOrderModel fetchOrderModel) async {
    var pref = await SharedPreferences.getInstance();
    int count = pref.getInt('sendcopy') ?? 1;
    print("cout print: $count");
    var data =
        await PostOrder().sumitOrder(fetchOrderModel, "Send", widget.ip, '1');
    dev.log('sendOrder:${data.printInvoice}');
    if (data.itemsReturns.isNotEmpty || data.itemsReturns.length > 0) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotEnoughStockScreen(
            lsItemReturn: data.itemsReturns,
          ),
        ),
      );
    } else {
      // start print
      print("table id : ${widget.tableId}");
      fetchOrderModel = await FetchOrderController()
          .getFetchOrder(widget.ip, widget.tableId, order.orderId, 0, true);

      if (count == 0) {
        ShowMessage.showLoading(context, "Loading");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => TableScreen(ip: widget.ip),
          ),
          (route) => false,
        );
      } else {
        int i = 0;
        ShowMessage.showLoading(context, "Loading");
        do {
          await Future.delayed(Duration(seconds: 1)).whenComplete(() {
            NewPrintOrder(receiptInfoModel: data).startPrintOrder();
          });
          i < count - 1
              ? await Future.delayed(Duration(seconds: 2))
              : await Future.delayed(Duration(seconds: 0));
          i++;
        } while (i < count);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => TableScreen(ip: widget.ip),
          ),
          (route) => false,
        );
      }
    }
  }

  Future<void> _saveOrder(
      BuildContext context, FetchOrderModel fetchOrderModel) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    if (_connection) {
      await PostOrder().saveOrder(fetchOrderModel, widget.ip);
      ShowMessage.showLoading(
        context,
        AppLocalization.of(context).getTranValue('loading'),
      );
      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
      Navigator.push(
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
                    defaultOrder: false,
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalization.of(context).getTranValue('no_internet'),
          ),
        ),
      );
    }
  }

  var _reasonController = TextEditingController();
  Future<void> _buildReasonDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextField(
            decoration: InputDecoration(
              label: Text(
                AppLocalization.of(context).getTranValue('enter_reason'),
              ),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 20.0),
            controller: _reasonController,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalization.of(context).getTranValue('cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalization.of(context).getTranValue('ok')),
              onPressed: () async {
                bool connection = await DataConnectionChecker().hasConnection;
                if (connection) {
                  ShowMessage.showLoading(
                    context,
                    AppLocalization.of(context).getTranValue('loading'),
                  );
                  await Future.delayed(Duration(seconds: 1));
                  bool voidOrder = await PostOrder().voidOrder(widget.ip,
                      fetchOrderModel.order.orderId, _reasonController.text);
                  if (voidOrder) {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaleScreen(
                          ip: widget.ip,
                          orderId: 0,
                          tableId: widget.tableId,
                          defaultOrder: true,
                          level: 1,
                          // group1: 1,
                          // group2: 1,
                          // group3: 1,
                        ),
                      ),
                      (route) => false,
                    );
                  } else {
                    _hasNotPermission("SomeThing went wrong!");
                  }
                }
              },
            ),
          ],
        );
      },
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

  List<Widget> _buidListWidget(FetchOrderModel fetchOrderModel) {
    var order = fetchOrderModel.order;

    var detail = order.orderDetail;

    return detail.where((element) => element.qty > 0).map((e) {
      return e.parentLineId.isEmpty ? _buildItem(e, order) : _buildItemAddOn(e);
    }).toList();
  }

  Widget _buildItemAddOn(OrderDetailModel e) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => DetailItem(
                  orderDetail: e,
                  ip: widget.ip,
                  fetchOrderModel: fetchOrderModel,
                )),
          ),
        );
      },
      onLongPress: () {
        print(e.itemType.toLowerCase());
        if (e.itemType.toLowerCase() == "addon".toLowerCase()) {
          ShowMessage.alertCommingSoon(context, "Addon", "Item can't Addon");
        } else {
          OrderDetailModel copyDetail = OrderDetailModel.copy(e);
          setState(() {
            copyDetail.lineId =
                DateTime.now().microsecondsSinceEpoch.toString();
            copyDetail.qty = 1;
            ShowHide sh = ShowHide(show: 0, key: copyDetail.lineId);
            showlist.add(sh);
            sumItemsTotal(order, fetchOrderModel.setting);
          });
          fetchOrderModel.order.orderDetail.add(copyDetail);
          BlocProvider.of<OrderBloc>(context).add(UpdateOrderEvent(
              orderDetail: copyDetail, fetchOrder: fetchOrderModel));
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            height: 50,
            child: Row(
              children: [
                Expanded(child: _buildStackAddon(e, order, widget.ip)),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      padding: EdgeInsets.only(),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          for (var data in list) {
                            if (data.lineId == e.lineId) {
                              showlist
                                  .firstWhere((s) => s.key == data.lineId)
                                  .show = 1;
                            } else {
                              if (data.lineId == e.lineId) {
                                showlist
                                    .firstWhere((s) => s.key == data.lineId)
                                    .show = 0;
                              }
                            }
                          }
                          if (_timer != null) _timer.cancel();
                          _timer = Timer(Duration(seconds: 2), () {
                            if (mounted) {
                              setState(() => showlist
                                  .firstWhere((s) => s.key == e.lineId)
                                  .show = 0);
                            }
                          });
                        });
                      },
                      child: Text(e.qty.toStringAsFixed(0))),
                ),
                Container(
                  width: 140,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        height: 70.0,
                        child: Column(
                          children: [
                            Text(
                              '${getItemTotal(e, fetchOrderModel.setting).toStringAsFixed(2)} ${e.currency}',
                              style: TextStyle(
                                fontSize: 12,
                                decoration: e.discountRate != 0
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: e.discountRate != 0
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            e.discountRate != 0
                                ? Text(
                                    '${getItemTotal(e, fetchOrderModel.setting).toStringAsFixed(2)} ${e.currency}',
                                    // '${e.currency}  ${e.typeDis == 'Percent' ? ((e.unitPrice * e.qty) - (e.discountRate * e.qty * e.unitPrice) / 100).toStringAsFixed(2) : ((e.unitPrice * e.qty) - (e.discountRate * e.qty)).toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.end,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      '',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                          ],
                          mainAxisAlignment: e.discountValue != 0
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.end,
                        ),
                      ),
                      showlist.firstWhere((s) => s.key == e.lineId).show == 1
                          ? _buildPositionAddon(e)
                          : Text(''),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPositionAddon(OrderDetailModel e) {
    return Positioned(
      top: 5,
      left: 3.0,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(color: Colors.grey),
        ),
        child: MaterialButton(
          child: Icon(Icons.add, size: 25.0, color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          padding: EdgeInsets.only(),
          color: Colors.white,
          onPressed: () {
            setState(() {
              e.qty += 1;
              e.printQty += 1;
              if (_timer != null) _timer.cancel();
              _timer = Timer(Duration(seconds: 2), () {
                if (mounted) {
                  setState(() =>
                      showlist.firstWhere((s) => s.key == e.lineId).show = 0);
                }
              });
            });
            BlocProvider.of<OrderBloc>(context).add(
                UpdateOrderEvent(orderDetail: e, fetchOrder: fetchOrderModel));
          },
        ),
      ),
    );
  }

  Widget _buildStackAddon(OrderDetailModel e, Order order, String ip) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Icon(
                Icons.add,
                size: 14,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              child: Text(
                '${e.khmerName + " " + "(${e.uom})"}',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.start,
              ),
              height: 70.0,
              alignment: Alignment.center,
            ),
          ],
        ),

        showlist.firstWhere((s) => s.key == e.lineId).show == 1
            ? Positioned(
                top: 5,
                right: 3.0,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: MaterialButton(
                      child: Icon(Icons.remove, size: 25, color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      padding: EdgeInsets.only(),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          e.qty -= 1;
                          e.printQty -= 1;
                        });
                        BlocProvider.of<OrderBloc>(context).add(
                            UpdateOrderEvent(
                                orderDetail: e, fetchOrder: fetchOrderModel));
                      }),
                ),
              )
            : Text(""),
        // showlist.firstWhere((s) => s.key == e.lineId).show == 1
        //     ? Positioned(
        //         top: 10,
        //         right: 3.0,
        //         child: Container(
        //           height: 50,
        //           width: 50,
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(3.0),
        //             border: Border.all(color: Colors.grey),
        //           ),
        //           child: MaterialButton(
        //               child: Icon(Icons.delete, size: 25, color: Colors.red),
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(3.0),
        //               ),
        //               padding: EdgeInsets.only(),
        //               color: Colors.white,
        //               onPressed: () {}),
        //         ))
        //     : Text(""),
      ],
    );
  }

  Widget _buildItem(OrderDetailModel e, Order order) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => DetailItem(
                      orderDetail: e,
                      ip: widget.ip,
                      fetchOrderModel: fetchOrderModel,
                    ))));
      },
      onLongPress: () {
        print(e.itemType.toLowerCase());
        if (e.itemType.toLowerCase() == "addon".toLowerCase()) {
          ShowMessage.alertCommingSoon(context, "Addon", "Item can't Addon");
        } else {
          OrderDetailModel copyDetail = OrderDetailModel.copy(e);
          setState(() {
            copyDetail.lineId =
                DateTime.now().microsecondsSinceEpoch.toString();
            copyDetail.qty = 1;
            ShowHide sh = ShowHide(show: 0, key: copyDetail.lineId);
            showlist.add(sh);
            sumItemsTotal(order, fetchOrderModel.setting);
          });
          fetchOrderModel.order.orderDetail.add(copyDetail);
          BlocProvider.of<OrderBloc>(context).add(UpdateOrderEvent(
              orderDetail: copyDetail, fetchOrder: fetchOrderModel));
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            height: 70.0,
            child: Row(
              children: [
                Expanded(child: _buildStack(e, order, widget.ip)),
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      padding: EdgeInsets.only(),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          for (var data in list) {
                            if (data.lineId == e.lineId) {
                              showlist
                                  .firstWhere((s) => s.key == data.lineId)
                                  .show = 1;
                            } else {
                              if (data.lineId == e.lineId) {
                                showlist
                                    .firstWhere((s) => s.key == data.lineId)
                                    .show = 0;
                              }
                            }
                          }
                          if (_timer != null) _timer.cancel();
                          _timer = Timer(Duration(seconds: 2), () {
                            if (mounted) {
                              setState(() => showlist
                                  .firstWhere((s) => s.key == e.lineId)
                                  .show = 0);
                            }
                          });
                        });
                      },
                      child: Text(e.qty.toStringAsFixed(0))),
                ),
                Container(
                  width: 140.0,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        height: 70.0,
                        child: Column(
                          children: [
                            Text(
                              '${getItemTotal(e, fetchOrderModel.setting).toStringAsFixed(2)} ${order.currency.symbol}',
                              style: TextStyle(
                                fontSize: 16.0,
                                decoration: e.discountRate != 0
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: e.discountRate != 0
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            e.discountRate != 0
                                ? Text(
                                    '${getItemTotal(e, fetchOrderModel.setting).toStringAsFixed(2)} ${e.currency}',
                                    // '${e.currency}  ${e.typeDis == 'Percent' ? ((e.unitPrice * e.qty) - (e.discountRate * e.qty * e.unitPrice) / 100).toStringAsFixed(2) : ((e.unitPrice * e.qty) - (e.discountRate * e.qty)).toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 16.0),
                                    textAlign: TextAlign.end,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(''),
                                  ),
                          ],
                          mainAxisAlignment: e.discountValue != 0
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.end,
                        ),
                      ),
                      showlist.firstWhere((s) => s.key == e.lineId).show == 1
                          ? _buildPosition(e)
                          : Text(''),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPosition(OrderDetailModel e) {
    return Positioned(
      top: 10.0,
      left: 3.0,
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(color: Colors.grey),
        ),
        child: MaterialButton(
          child: Icon(Icons.add, size: 25.0, color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          padding: EdgeInsets.only(),
          color: Colors.white,
          onPressed: () {
            setState(() {
              e.qty += 1;
              e.printQty += 1;
              if (_timer != null) _timer.cancel();
              _timer = Timer(Duration(seconds: 2), () {
                if (mounted) {
                  setState(() =>
                      showlist.firstWhere((s) => s.key == e.lineId).show = 0);
                }
              });
            });
            BlocProvider.of<OrderBloc>(context).add(
                UpdateOrderEvent(orderDetail: e, fetchOrder: fetchOrderModel));
          },
        ),
      ),
    );
  }

  Widget _buildStack(OrderDetailModel e, Order order, String ip) {
    return Stack(
      children: [
        Container(
          child: Text(
            '${e.khmerName + " " + "(${e.uom})"}',
            style: TextStyle(fontSize: 17.0),
            textAlign: TextAlign.start,
          ),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          height: 70.0,
        ),
        showlist.firstWhere((s) => s.key == e.lineId).show == 1
            ? Positioned(
                top: 10,
                right: 3.0,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: MaterialButton(
                      child: Icon(Icons.remove, size: 25, color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      padding: EdgeInsets.only(),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          e.qty -= 1;
                          e.printQty -= 1;
                        });
                        BlocProvider.of<OrderBloc>(context).add(
                            UpdateOrderEvent(
                                orderDetail: e, fetchOrder: fetchOrderModel));
                      }),
                ),
              )
            : Text(""),
        // showlist.firstWhere((s) => s.key == e.lineId).show == 1
        //     ? Positioned(
        //         top: 10,
        //         right: 3.0,
        //         child: Container(
        //           height: 50,
        //           width: 50,
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(3.0),
        //             border: Border.all(color: Colors.grey),
        //           ),
        //           child: MaterialButton(
        //               child: Icon(Icons.delete, size: 25, color: Colors.red),
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(3.0),
        //               ),
        //               padding: EdgeInsets.only(),
        //               color: Colors.white,
        //               onPressed: () {}),
        //         ))
        //     : Text(""),
      ],
    );
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    super.dispose();
  }
}

class ShowHide {
  int show;
  final String key;
  final double qty;
  ShowHide({this.show, this.key, this.qty});
}
