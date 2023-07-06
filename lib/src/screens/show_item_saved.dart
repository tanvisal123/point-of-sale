import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/bloc/fetchorder_bloc/fetchorder_bloc.dart';
import 'package:point_of_sale/src/controllers/change_table_controller.dart';
import 'package:point_of_sale/src/controllers/check_privilege_conntroller.dart';
import 'package:point_of_sale/src/controllers/combine_order_controller.dart';
import 'package:point_of_sale/src/controllers/move_order_controller.dart';
import 'package:point_of_sale/src/controllers/post_order_to_server.dart';
import 'package:point_of_sale/src/controllers/service_table_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/order_to_combine.dart';
import 'package:point_of_sale/src/models/table_modal.dart';
import 'package:point_of_sale/src/screens/edit_price_screen.dart';
import 'package:point_of_sale/src/screens/payment_screen.dart';
import 'package:point_of_sale/src/screens/table_group_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowItemSaved extends StatefulWidget {
  final FetchOrderModel fetchOrderModel;
  final int orderId;
  final int tableId;
  final String ip;
  const ShowItemSaved(
      {Key key,
      this.fetchOrderModel,
      @required this.ip,
      @required this.orderId,
      @required this.tableId})
      : super(key: key);

  @override
  State<ShowItemSaved> createState() => _ShowItemSavedState();
}

class _ShowItemSavedState extends State<ShowItemSaved> {
  List<OrderDetailModel> listOrded;
  FetchOrderModel fetchOrderModel;
  Order order;
  bool status = false;
  List<Order> orderList = [];
  List<TableModel> listTable;
  var _controllerTotalAmont = TextEditingController();
  var _controllerDisValue = TextEditingController();
  var _controllerDisRate = TextEditingController();
  var subTotal;
  var grandTotal;
  var countQty;
  var sysType;
  DisplayPayOtherCurrency currency;
  bool loading = false, stutus = false;
  List<OrderToCombine> orderToCom;
  void getOrder() async {
    setState(() {
      fetchOrderModel = widget.fetchOrderModel;
      orderList = widget.fetchOrderModel.orders;
      order = fetchOrderModel.order;
      currency = fetchOrderModel.displayCurrency
          .firstWhere((e) => e.altCurrencyId == e.baseCurrencyId);
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
    await CombineOrderController.getOrderToCombine(widget.ip, widget.orderId)
        .then((value) {
      setState(() {
        orderToCom = value;
        stutus = true;
      });
    });
  }

  void getItem() {
    setState(() {
      fetchOrderModel = widget.fetchOrderModel;
      listOrded = fetchOrderModel.order.orderDetail;
      order = fetchOrderModel.order;
      order.subTotal = sumSubtotal(order);
      order.grandTotal = subGrandTotal(order);
      currency = fetchOrderModel.displayCurrency.firstWhere(
          (element) => element.altCurrencyId == element.baseCurrencyId);
    });
    for (var temp in listOrded) {
      print("line id : ${temp.lineId}");
    }
    print("sub Total : ${order.subTotal}");
    print("grand Total : ${order.grandTotal}");
    status = true;
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
    super.initState();
    getItem();
    getSystemType();
    getOrder();
    getTable();
    getOrderToCombine();
  }

  static double sumSubtotal(Order order) {
    double subtotal = 0;
    for (var item in order.orderDetail) {
      subtotal += sumLineItem(item);
    }
    order.subTotal = subtotal;
    return subtotal;
  }

  static double sumLineItem(OrderDetailModel orderDetail) {
    return orderDetail.qty *
        orderDetail.unitPrice *
        (1 - orderDetail.discountRate / 100);
  }

  static double subGrandTotal(Order order) {
    double grandTotal = 0.0;
    grandTotal = order.subTotal * (1 - order.discountRate / 100);
    order.grandTotal = grandTotal;
    return grandTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalization.of(context).getTranValue('item_saved')),
          actions: [
            SizedBox(
              width: 10,
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    order.orderNo,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: ((context) {
                    return [
                      sysType == "KRMS"
                          ? PopupMenuItem(
                              onTap: () async {
                                var check = await CheckPrivilegeController()
                                    .checkprivilege("P001", widget.ip);
                                if (check == 'true') {
                                  getTableFree(listTable);
                                } else {
                                  _hasNotPermission(
                                    AppLocalization.of(context)
                                        .getTranValue('user_no_permission'),
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.cached_outlined,
                                      color: Colors.black),
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
                      sysType == 'KRMS'
                          ? PopupMenuItem(
                              onTap: () async {
                                var check = await CheckPrivilegeController()
                                    .checkprivilege("A047", widget.ip);
                                if (check == 'true') {
                                  // _voidOrder();
                                } else {
                                  _hasNotPermission(
                                    AppLocalization.of(context)
                                        .getTranValue('user_no_permission'),
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.delete_forever_outlined,
                                      color: Colors.black),
                                  SizedBox(width: 10.0),
                                  Text(
                                    AppLocalization.of(context)
                                        .getTranValue('void_order'),
                                  ),
                                ],
                              ),
                            )
                          : PopupMenuItem(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(Icons.delete_forever_outlined,
                                      color: Colors.black),
                                  SizedBox(width: 10.0),
                                  Text(
                                    AppLocalization.of(context)
                                            .getTranValue('clear_order') ??
                                        'Clear order',
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
                                  getAllTable(listTable);
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
                                    .checkprivilege("P002", widget.ip);
                                if (check == 'true') {
                                  orderToCombine(orderToCom);
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
                      sysType == "KRMS"
                          ? PopupMenuItem(
                              onTap: () async {},
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
                              onTap: () async {},
                              child: Row(
                                children: [
                                  Icon(Icons.delete_forever,
                                      color: Colors.black),
                                  SizedBox(width: 10.0),
                                  Text(AppLocalization.of(context)
                                      .getTranValue('void_order')),
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
                              onTap: () async {},
                              child: Row(
                                children: [
                                  Icon(Icons.delete_forever,
                                      color: Colors.black),
                                  SizedBox(width: 10.0),
                                  Text(AppLocalization.of(context)
                                      .getTranValue('void_item')),
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
                              onTap: () async {},
                              child: Row(
                                children: [
                                  Icon(Icons.delete_forever,
                                      color: Colors.black),
                                  SizedBox(width: 10.0),
                                  Text("Panding Void Item"),
                                ],
                              ),
                            )
                          : PopupMenuItem(
                              height: 0.0,
                              padding: EdgeInsets.all(0.0),
                              child: SizedBox(height: 0),
                            ),
                      PopupMenuItem(
                        onTap: () async {
                          var check = await CheckPrivilegeController()
                              .checkprivilege("P022", widget.ip);
                          if (check == 'true') {
                            _buildDialogDiscount(context);
                          } else {
                            _hasNotPermission(
                              AppLocalization.of(context)
                                  .getTranValue('user_no_permission'),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.local_offer_outlined,
                                color: Colors.black),
                            SizedBox(width: 10.0),
                            Text(
                              AppLocalization.of(context)
                                  .getTranValue('discount_order'),
                            ),
                          ],
                        ),
                      ),
                      sysType == "KBMS"
                          ? PopupMenuItem(
                              onTap: () async {
                                _saveOrder(context, fetchOrderModel);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.receipt, color: Colors.black),
                                  SizedBox(width: 10.0),
                                  Text(AppLocalization.of(context)
                                      .getTranValue('save_order')),
                                ],
                              ),
                            )
                          : PopupMenuItem(
                              height: 0.0,
                              padding: EdgeInsets.all(0.0),
                              child: SizedBox(height: 0),
                            ),
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
                          ))
                    ];
                  }),
                ),
              ],
            )
          ],
        ),
        body: status
            ? ListView(
                children: [
                  ListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    children: _buidListWidget(fetchOrderModel),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        bottomNavigationBar: Container(
          height: 120.0,
          child: Column(
            children: [
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
                                    "${currency.baseCurrency}" +
                                        " " +
                                        order.subTotal.toStringAsFixed(2),
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
                                    "${currency.baseCurrency}" +
                                        " " +
                                        order.discountValue.toStringAsFixed(2),
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
                                    "${currency.baseCurrency}" +
                                        " " +
                                        order.grandTotal.toStringAsFixed(2),
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
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.grey[400],
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 126, 197, 129),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: MaterialButton(
                                  splashColor: Colors.white,
                                  onPressed: () {
                                    _showItem(fetchOrderModel);
                                  },
                                  child: Text(
                                    AppLocalization.of(context)
                                        .getTranValue('add_item'),
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
                                              NewPaymentScreen(
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
                      return RadioListTile(
                          title: Text(list[index].titleNote),
                          value: index,
                          groupValue: value,
                          onChanged: (int init) {
                            setState(() {
                              value = init;
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
                  onPressed: () async {},
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
                  Text(AppLocalization.of(context).getTranValue('move_table')),
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
                  onPressed: () async {
                    print("table id seleted : $tableSelected");
                    ShowMessage.showLoading(context, "Loading");
                    await Future.delayed(Duration(seconds: 1));
                    await ChangeTableController.getTableChange(
                        widget.ip, widget.tableId, tableSelected);
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TableScreen(ip: widget.ip),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(AppLocalization.of(context).getTranValue('ok')),
                ),
              ],
            );
          }));
        });
  }

  Future<void> getAllTable(List<TableModel> listTable) async {
    int value;
    var tableSelected;

    for (var temp in listTable) {
      print("table Id : ${temp.id} (${temp.name}" "${temp.status})");
    }
    print("order id : ${widget.orderId}");
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: Text("Move Receipt"),
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
                  onPressed: () async {
                    ShowMessage.showLoading(context, "Loading");
                    await Future.delayed(Duration(seconds: 1));
                    await MoveOrderController.getMoveOrder(widget.ip,
                        widget.tableId, tableSelected, widget.orderId);
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TableScreen(ip: widget.ip),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(AppLocalization.of(context).getTranValue('ok')),
                ),
              ],
            );
          }));
        });
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

  Future<void> _dialogComfirm(FetchOrderModel fetchOrderModel) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'Do You Want to Save This Order',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _saveOrder(context, fetchOrderModel);
                },
                child: Text('ok'),
              )
            ],
          );
        });
  }

  Future<void> _showItem(FetchOrderModel fetchOrderModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalization.of(context).getTranValue('list_of_item')),
          content: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(
                    fetchOrderModel.saleItems.length, (index) {
                  var data = fetchOrderModel.saleItems[index];
                  return ListTile(
                    onTap: () {
                      BlocProvider.of<FetchOrderBloc>(context).add(
                          AppOrdedEvent(
                              saleId: data.id,
                              orderId: fetchOrderModel.order.orderId,
                              fetchOrderModel: fetchOrderModel));
                    },
                    title: Text(data.khmerName + " " + "(${data.uoM})"),
                    subtitle: Text(
                        "${currency.baseCurrency}" +
                            " " +
                            data.unitPrice.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.red)),
                  );
                })),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalization.of(context).getTranValue('cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalization.of(context).getTranValue('add')),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ShowItemSaved(
                              fetchOrderModel: fetchOrderModel,
                              ip: widget.ip,
                              tableId: 0,
                              orderId: 0,
                            )));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _buildDialogDiscount(BuildContext context) async {
    _controllerTotalAmont.text = order.subTotal.toStringAsFixed(2);
    _controllerDisValue.text = (order.discountValue).toStringAsFixed(2);
    currency = fetchOrderModel.displayCurrency.firstWhere(
      (element) => element.altCurrencyId == element.baseCurrencyId,
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalization.of(context).getTranValue('dis_order')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  children: [
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
                      controller: _controllerDisValue,
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
                          order.grandTotal =
                              order.subTotal - double.parse(value);
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
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
                  ],
                )
              ],
            ),
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
                        builder: (_) => ShowItemSaved(
                              fetchOrderModel: fetchOrderModel,
                              ip: widget.ip,
                              orderId: 0,
                              tableId: 0,
                            )));
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

  Future<void> _saveOrder(
      BuildContext context, FetchOrderModel fetchOrderModel) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    if (_connection) {
      await PostOrder().saveOrder(fetchOrderModel, widget.ip);
      print("Saved!");
      // for (var temp in orders) {
      //   print("orderNo : ${temp.orderNo}");
      // }
      // ShowMessage.showLoading(
      //   context,
      //   AppLocalization.of(context).getTranValue('loading'),
      // );
      // await Future.delayed(Duration(seconds: 1));
      // Navigator.pop(context);
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => SaleScreen(ip: widget.ip)));
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

  List<Widget> _buidListWidget(FetchOrderModel fetchOrderModel) {
    var data = fetchOrderModel.order.orderDetail;
    var order = fetchOrderModel.order;
    return data.where((element) => element.qty > 0).map((e) {
      print("id order: ${e.orderId}");
      return InkWell(
        onTap: () {},
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              height: 70.0,
              child: Row(
                children: [
                  Expanded(child: _buildStack(e, widget.ip)),
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
                        onPressed: () {},
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
                                '${e.currency} ${(e.unitPrice * e.qty).toStringAsFixed(2)}',
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
                                      '${e.currency}  ${e.typeDis == 'Percent' ? ((e.unitPrice * e.qty) - (e.discountRate * e.qty * e.unitPrice) / 100).toStringAsFixed(2) : ((e.unitPrice * e.qty) - (e.discountRate * e.qty)).toStringAsFixed(2)}',
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
                        _buildPosition(e, order)
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
    }).toList();
  }

  Widget _buildPosition(OrderDetailModel e, Order order) {
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
              order.subTotal = sumSubtotal(order);
              order.grandTotal = subGrandTotal(order);
            });
          },
        ),
      ),
    );
  }

  Widget _buildStack(OrderDetailModel e, String ip) {
    return Stack(
      children: [
        Container(
          child: Text(
            '${e.khmerName}',
            style: TextStyle(fontSize: 17.0),
            textAlign: TextAlign.start,
          ),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          height: 70.0,
        ),

        Positioned(
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
                    order.subTotal = sumSubtotal(order);
                    order.grandTotal = subGrandTotal(order);
                  });
                }),
          ),
        )

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
}
