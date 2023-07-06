import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/ManageLocalData/constant_ip.dart';
import 'package:point_of_sale/src/bloc/customer_bloc/customer_bloc.dart';
import 'package:point_of_sale/src/bloc/group_item1_bloc/group_item_bloc.dart';
import 'package:point_of_sale/src/bloc/order_bloc/order_bloc.dart';
import 'package:point_of_sale/src/controllers/change_table_controller.dart';
import 'package:point_of_sale/src/controllers/check_privilege_conntroller.dart';
import 'package:point_of_sale/src/controllers/fetchorder_controller.dart';
import 'package:point_of_sale/src/controllers/groupItem_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/table_modal.dart';
import 'package:point_of_sale/src/screens/close_shift_screen.dart';
import 'package:point_of_sale/src/screens/customer_screen.dart';
import 'package:point_of_sale/src/screens/detail_sale_screen.dart';
import 'package:point_of_sale/src/screens/login_screen.dart';
import 'package:point_of_sale/src/screens/open_shift_screen.dart';
import 'package:point_of_sale/src/screens/return_receipt_screen.dart';
import 'package:point_of_sale/src/screens/show_pending_void_item_screen.dart';
import 'package:point_of_sale/src/screens/table_group_screen.dart';
import 'package:point_of_sale/src/widgets/drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cancel_receipt_screen.dart';
import 'list_order_saved.dart';

class SaleScreen extends StatefulWidget {
  final String ip;
  final int level;
  final int tableId;
  final int orderId;
  final bool defaultOrder;
  const SaleScreen({
    Key key,
    @required this.ip,
    @required this.level,
    @required this.tableId,
    @required this.orderId,
    @required this.defaultOrder,
  }) : super(key: key);
  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  var sysType;
  AccessIPController ipAddress = Get.put(AccessIPController());
  bool _hasInternet = false, _checkBarcode = true;
  bool loading = false, stutus = false;
  FetchOrderModel fetchOrderModel;
  List<TableModel> listTable;
  List<SaleItems> listSaleItem;
  List<SaleItems> searchItemSale;
  Map<int, String> mapGroup1;
  Map<int, String> mapGroup2;
  Map<int, String> mapGroup3;
  Map<int, List<SaleItems>> mapItemG1;
  Map<int, List<SaleItems>> mapItemG2;
  Map<int, List<SaleItems>> mapItemG3;
  List<TaxGroup> taxGroup;
  String name2;
  String name1;
  String name3;
  String customerName = "";
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

  static double sumGrandTotal(Order order) {
    double grandTotal = 0.0;
    grandTotal = order.subTotal * (1 - order.discountRate / 100);
    order.grandTotal = grandTotal;
    log(jsonEncode(grandTotal));
    return grandTotal;
  }

  // void getSaleItem() async {
  //   await FetchOrderController()
  //       .getFetchOrder(
  //           widget.ip, widget.tableId, widget.orderId, 0, widget.defaultOrder)
  //       .then((value) {
  //     setState(() {
  //       fetchOrderModel = value;
  //       searchItemSale = fetchOrderModel.lSaleItem;
  //       stutus = true;
  //     });
  //   });
  // }

  void getSystempType() async {
    var prefre = await SharedPreferences.getInstance();
    sysType = prefre.get("systemType");
    //print("system type : $sysType");
    _checkBarcode = prefre.getBool('barcode');
    if (_checkBarcode == null) {
      _checkBarcode = false;
    }
  }

  void _checkInternet() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result)
      setState(() => _hasInternet = true);
    else
      setState(() => _hasInternet = false);
    print(_hasInternet);
  }

  void _loadInitizeOrder() {
    BlocProvider.value(
        value: BlocProvider.of<OrderBloc>(context)..add(DeleteOrderEvent()));
  }

  @override
  void initState() {
    super.initState();
    _loadInitizeOrder();
    getSystempType();
    _checkInternet();
    print('IPSaleSscreen:${widget.ip}');
    // getSaleItem();
    BlocProvider.of<GroupItemBloc>(context).add(
      GetGroupItem(
        tableId: widget.tableId,
        orderId: widget.orderId,
        customerId: 0,
        defualtValue: widget.defaultOrder,
      ),
    );
  }

//Food Service Screen
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupItemBloc, GroupItemState>(
      builder: (context, state) {
        if (state is GroupItemLoading) {
          return _buildLoading();
        } else if (state is GroupItemLoaded) {
          return Scaffold(
            drawer: DrawerWidget(
              ip: widget.ip,
              selected: 2,
            ),
            appBar: _buildAppBar(state.fetchOrderModel),
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.orange, boxShadow: [
                    BoxShadow(spreadRadius: 0.1, blurRadius: 1),
                  ]),
                  height: 50,
                  width: double.infinity,

                  // color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5, left: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          TextButton(
                            child: Row(
                              children: [
                                Text(
                                  // General Customer
                                  "Allaasdas",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.chevron_right)
                              ],
                            ),
                            onPressed: mapGroup1 == null
                                ? () {}
                                : () {
                                    setState(() {
                                      mapGroup1.clear();
                                      name1 = "";
                                      name2 = "";
                                      name3 = "";
                                      listSaleItem = null;
                                    });
                                  },
                          ),
                          name1 == null || name1.isEmpty
                              ? SizedBox()
                              : TextButton(
                                  child: Row(
                                    children: [
                                      Text(
                                        name1,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(Icons.chevron_right)
                                    ],
                                  ),
                                  onPressed: mapGroup2 == null
                                      ? () {}
                                      : () {
                                          setState(() {
                                            mapGroup2.clear();
                                            name2 = "";
                                            name3 = "";
                                            mapItemG1.forEach((key, value) {
                                              listSaleItem = value;
                                            });
                                          });

                                          _buildItem(listSaleItem,
                                              state.fetchOrderModel);
                                        },
                                ),
                          name2 == null || name2.isEmpty
                              ? SizedBox()
                              : TextButton(
                                  child: Row(
                                    children: [
                                      Text(
                                        name2,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(Icons.chevron_right)
                                    ],
                                  ),
                                  onPressed: mapGroup1 == null
                                      ? () {}
                                      : () {
                                          setState(() {
                                            mapGroup3 == null
                                                ? SizedBox()
                                                : mapGroup3.clear();
                                            name3 = "";
                                            mapItemG2.forEach((key, value) {
                                              listSaleItem = value;
                                            });
                                          });
                                          _buildItem(listSaleItem,
                                              state.fetchOrderModel);
                                        },
                                ),
                          name3 == null || name3.isEmpty
                              ? SizedBox()
                              : TextButton(
                                  child: Text(
                                    name3,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Price Screen
                Expanded(
                    child: listSaleItem == null
                        // ? _buildGroup(state.fetchOrderModel.bItemGroups,
                        // state.fetchOrderModel)
                        ? _buildGroup(state.fetchOrderModel.bItemGroups,
                            state.fetchOrderModel)
                        : _buildItem(listSaleItem, state.fetchOrderModel)),
              ],
            ),
            bottomNavigationBar:
                BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
              if (state is OrderLoaded) {
                var currency = state.stateOrder.fetchOrder.displayCurrency
                    .firstWhere((e) => e.altCurrencyId == e.baseCurrencyId);
                var data = state.stateOrder.fetchOrder;
                if (state.stateOrder.orderDetai.qty == null) {
                  return SizedBox(
                    height: 0.0,
                  );
                } else {
                  if (state.stateOrder.countQty != 0.0) {
                    return Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            color: Colors.grey,
                            child: Text(
                              data.order.subTotal.toStringAsFixed(2) +
                                  " " +
                                  currency.baseCurrency,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          )),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailSaleScreen(
                                      ip: widget.ip,
                                      orderId: data.order.orderId,
                                      fetchOrderModel: data,
                                      tableId: widget.tableId,
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                    ),
                                    child: Text(
                                      AppLocalization.of(context)
                                          .getTranValue("view_cart"),
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0.0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16.0),
                                        ),
                                      ),
                                      height: 25.0,
                                      width: 50.0,
                                      child: Text(
                                        '${state.stateOrder.countQty.floor()}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
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
                    );
                  }
                }
              }
              return SizedBox();
            }),
          );
        } else if (state is GroupItemError) {
          return _buildError(state.message);
        } else {
          return _buildError("Something went worng");
        }
      },
    );
  }

  Widget _buildGroup(
      List<BaseItemGroup> _list, FetchOrderModel fetchOrderModel) {
    return _list.isNotEmpty && _list != null
        ? SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                      children: _list.map((e) {
                    return buildBaseItem(e, fetchOrderModel);
                  }).toList()),
                )
              ],
            ),
          )
        : Center(
            child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/emptybox.png"),
              fit: BoxFit.cover,
            )),
          ));
  }

//second list
  Widget _buildItem(List<SaleItems> list, FetchOrderModel fetchOrderModel) {
    return list.isNotEmpty && list != null
        ? SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                      children: list.map((e) {
                    return buildSaleItem(e, fetchOrderModel);
                  }).toList()),
                )
              ],
            ),
          )
        : Center(
            child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/emptybox.png"),
              fit: BoxFit.cover,
            )),
          ));
  }

  Widget buildBaseItem(
      BaseItemGroup baseItemGroup, FetchOrderModel fetchOrderModel) {
    int priceListId = fetchOrderModel.order.priceListId;
    return baseItemGroup != null
        ? InkWell(
            onTap: () async {
              listSaleItem = await GroupItemController().getGroupItem(
                  widget.ip,
                  baseItemGroup.group1,
                  baseItemGroup.group2,
                  baseItemGroup.group3,
                  priceListId,
                  baseItemGroup.level);
              setState(() {
                fetchOrderModel.saleItems = listSaleItem;
                mapGroup1 = {baseItemGroup.id: baseItemGroup.khmerName};
                mapGroup1.forEach((key, value) {
                  name1 = value;
                });
                mapItemG1 = {baseItemGroup.id: listSaleItem};
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 3, right: 3),
              child: Stack(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.3,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      color: Colors.grey[100],
                    ),
                    child: Row(
                      children: <Widget>[
                        Card(
                          elevation: 0.0,
                          margin: const EdgeInsets.all(0.0),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Container(
                            width: 150.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: baseItemGroup.image != null
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          '${widget.ip + '/Images/items/' + baseItemGroup.image}',
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: SizedBox(
                                          width: 30.0,
                                          height: 30.0,
                                          child: CupertinoActivityIndicator(
                                            radius: 13.0,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/no_image.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/no_image.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        //Text for Listtle Food Service page
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${baseItemGroup.khmerName}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
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
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Text("No Item"),
          );
  }

  Widget buildSaleItem(SaleItems saleItem, FetchOrderModel fetchOrderModel) {
    var currency = fetchOrderModel.displayCurrency.firstWhere(
      (element) => element.altCurrencyId == element.baseCurrencyId,
    );
    var _f = NumberFormat('#,##0.00');
    int priceListId = fetchOrderModel.order.priceListId;
    return saleItem != null
        ? InkWell(
            onTap: () async {
              if (saleItem.itemId > 0) {
                BlocProvider.of<OrderBloc>(context).add(
                  AddOrderEvent(
                    saleID: saleItem.id,
                    orderID: fetchOrderModel.order.orderId,
                    fetchOrder: fetchOrderModel,
                  ),
                );
              } else {
                listSaleItem = await GroupItemController().getGroupItem(
                    widget.ip,
                    saleItem.group1,
                    saleItem.group2,
                    saleItem.group3,
                    priceListId,
                    saleItem.level);
                setState(() {
                  fetchOrderModel.saleItems = listSaleItem;
                  if (saleItem.level > 2) {
                    mapGroup3 = {saleItem.id: saleItem.khmerName};
                    mapGroup3.forEach((key, value) {
                      name3 = value;
                    });
                    mapItemG3 = {saleItem.id: listSaleItem};
                  } else {
                    mapGroup2 = {saleItem.id: saleItem.khmerName};
                    mapGroup2.forEach((key, value) {
                      name2 = value;
                    });
                    mapItemG2 = {saleItem.id: listSaleItem};
                  }
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 3, right: 3),
              child: Stack(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.3,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      color: Colors.grey[100],
                    ),
                    child: Row(
                      children: <Widget>[
                        Card(
                          elevation: 0.0,
                          margin: const EdgeInsets.all(0.0),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Container(
                            width: 150.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: saleItem.image != null
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          '${widget.ip + '/images/items/' + saleItem.image}',
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: SizedBox(
                                          width: 30.0,
                                          height: 30.0,
                                          child: CupertinoActivityIndicator(
                                            radius: 13.0,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/no_image.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/no_image.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        saleItem.itemId > 0
                                            ? '${saleItem.khmerName} (${saleItem.uoM})'
                                            : '${saleItem.khmerName} ',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      saleItem.itemId > 0
                                          ? Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: Text(
                                                    '${currency.baseCurrency} ${saleItem.typeDis == 'Percent' ? _f.format((saleItem.unitPrice - (saleItem.unitPrice * saleItem.discountRate) / 100)) : _f.format((saleItem.unitPrice - saleItem.discountRate))}',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                saleItem.discountRate != 0
                                                    ? Text(
                                                        '${currency.baseCurrency} ${saleItem.unitPrice}',
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      )
                                                    : Text(''),
                                              ],
                                            )
                                          : SizedBox(
                                              height: 0.0,
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
                  ),
                  Positioned(
                    bottom: 40,
                    left: 60,
                    child: BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        if (state is OrderLoaded) {
                          var data = state.stateOrder.orderDetai;
                          if (state.stateOrder.countQty == 0) {
                            saleItem.qty = 0;
                          }
                          if (data.qty == null) {
                            return SizedBox(height: 0);
                          }
                          if (data.lineId == saleItem.id.toString() &&
                              saleItem.itemId > 0) {
                            saleItem.qty = data.qty;
                            print("line id: ${data.lineId}");
                            print("sale id: ${saleItem.id}");
                            print("sale qty : ${saleItem.qty}");
                            print("item name : ${saleItem.khmerName}");
                            print("item name order : ${data.khmerName}");
                          }
                          return data.qty != 0 &&
                                  data.lineId == saleItem.id.toString() &&
                                  saleItem.itemId > 0
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${saleItem.qty.floor()}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : saleItem.qty != 0
                                  ? Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      height: 30.0,
                                      width: 30.0,
                                      child: Text(
                                        '${saleItem.qty.floor()}',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : SizedBox();
                        }

                        return SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Text("No Item"),
          );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: TextStyle(fontSize: 20.0)),
          IconButton(
              onPressed: () {
                ShowMessage.showLoading(context,
                    AppLocalization.of(context).getTranValue("loading"));
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              icon: Icon(Icons.refresh)),
        ],
      ),
    );
  }

  Widget _buildAppBar(FetchOrderModel fetchOrderModel) {
    return AppBar(
      actions: [
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is ShowCustomerOrderState) {
                  return Text(state.fetchOrder.order.customer.name);
                } else {
                  return Text(fetchOrderModel.order.customer.name);
                }
              },
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerScreen(
                                ip: widget.ip,
                                orderId: fetchOrderModel.order.orderId,
                                tableId: fetchOrderModel.order.tableId,
                                defaultOrder: widget.defaultOrder,
                                fetchOrder: fetchOrderModel,
                              )));
                },
                icon: Icon(
                  Icons.person,
                  size: 22,
                )),
            sysType == 'KRMS'
                ? _buildActionOrdered(fetchOrderModel.orders, fetchOrderModel)
                : SizedBox(
                    height: 0,
                  ),
            IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchItems(
                        ip: widget.ip,
                        saleitem: fetchOrderModel.saleItems,
                        fetchOrderModel: fetchOrderModel),
                  );
                },
                icon: Icon(
                  Icons.search,
                  size: 22,
                )),
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () async {
                    var check = await CheckPrivilegeController()
                        .checkprivilege("P020", widget.ip);
                    if (check == "true") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ReceiptToCancel(
                                  ip: widget.ip,
                                )),
                      );
                    } else {
                      _hasNotPermission(AppLocalization.of(context)
                          .getTranValue('user_no_permission'));
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.restore_from_trash_outlined,
                          color: Colors.black),
                      SizedBox(width: 10.0),
                      Text(
                        AppLocalization.of(context)
                            .getTranValue('cancel_receipt'),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                    onTap: () async {
                      var check = await CheckPrivilegeController()
                          .checkprivilege("P021", widget.ip);
                      if (check == "true") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReturnReceiptScreen(
                                    ip: widget.ip,
                                  )),
                        );
                      } else {
                        _hasNotPermission(AppLocalization.of(context)
                            .getTranValue('user_no_permission'));
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.request_quote_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(AppLocalization.of(context)
                            .getTranValue("return_receipt")),
                      ],
                    )),
                PopupMenuItem(
                  onTap: () async {
                    var per = await CheckPrivilegeController()
                        .checkprivilege("P012", widget.ip);
                    if (per == 'false') {
                      hasNotSetOpenShift(AppLocalization.of(context)
                          .getTranValue('user_no_permission'));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OpenShiftScreen(ip: widget.ip),
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.paid_outlined, color: Colors.black),
                      SizedBox(width: 10.0),
                      Text(
                        AppLocalization.of(context).getTranValue('open_shift'),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: () async {
                    var per = await CheckPrivilegeController()
                        .checkprivilege("P013", widget.ip);
                    if (per == 'false') {
                      hasNotSetOpenShift(AppLocalization.of(context)
                          .getTranValue('user_no_permission'));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CloseShiftScreen(ip: widget.ip),
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.local_atm, color: Colors.black),
                      SizedBox(width: 10.0),
                      Text(
                        AppLocalization.of(context).getTranValue('close_shift'),
                      ),
                    ],
                  ),
                ),

                //-------------- show pending void item -------------------
                sysType == "KRMS"
                    ? PopupMenuItem(
                        onTap: () async {
                          await Future.delayed(Duration(seconds: 1));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ShowPendingVoidItemScreen(
                                        ip: widget.ip,
                                      )));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.black),
                            SizedBox(width: 10.0),
                            Text("Pending Void Item"),
                          ],
                        ),
                      )
                    : PopupMenuItem(
                        height: 0.0,
                        padding: EdgeInsets.all(0.0),
                        child: SizedBox(height: 0),
                      ),
                //-------------------------------------------------

                sysType == "KBMS"
                    ? PopupMenuItem(
                        onTap: () async {
                          await Future.delayed(Duration(seconds: 1));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ListOrderSaved(
                                        ip: widget.ip,
                                        orderId: fetchOrderModel.order.orderId,
                                        fetchOrderModel: fetchOrderModel,
                                        tableId: widget.tableId,
                                      )));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.receipt, color: Colors.black),
                            SizedBox(width: 10.0),
                            Text(AppLocalization.of(context)
                                .getTranValue('list_save_orders')),
                          ],
                        ),
                      )
                    : PopupMenuItem(
                        height: 0.0,
                        padding: EdgeInsets.all(0.0),
                        child: SizedBox(height: 0),
                      ),
              ];
            })
          ],
        ),
      ],
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
              child: Text(AppLocalization.of(context).getTranValue('ok')),
            )
          ],
        );
      },
    );
  }

  Future<void> getTableFree(
      List<TableModel> listTable, FetchOrderModel fetchOrderModel) async {
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
              title: Text("Change Table"),
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
                  },
                  child: Text(AppLocalization.of(context).getTranValue('ok')),
                ),
              ],
            );
          }));
        });
  }

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

  orderedModalBottomSheet(BuildContext context, List<Order> orders,
      FetchOrderModel fetchOrderModel) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            return Container(
              margin: EdgeInsets.only(top: 25),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            height: 60.0,
                            child: MaterialButton(
                              color: Colors.red,
                              splashColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SaleScreen(
                                              ip: widget.ip,
                                              level: 1,
                                              //group1: 1,
                                              //group2: 1,
                                              // group3: 1,
                                              tableId: widget.tableId,
                                              orderId: 0,
                                              defaultOrder: false,
                                            )));
                              },
                              child: Text(
                                AppLocalization.of(context)
                                    .getTranValue('new_order'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(width: 1.0, color: Colors.white),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 60.0,
                            child: MaterialButton(
                              color: Colors.red,
                              splashColor: Color.fromARGB(255, 230, 206, 206),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            var _data = orders[index];
                            return ListTile(
                              onTap: () async {
                                print("order id : ${_data.orderId}");
                                fetchOrderModel = await FetchOrderController()
                                    .getFetchOrder(widget.ip, _data.tableId,
                                        _data.orderId, 0, true);
                                setState(() {
                                  setState((() {
                                    fetchOrderModel.order.subTotal =
                                        sumSubtotal(fetchOrderModel.order);
                                    fetchOrderModel.order.grandTotal =
                                        sumGrandTotal(fetchOrderModel.order);
                                  }));
                                });
                                var order = fetchOrderModel.order;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DetailSaleScreen(
                                              ip: ipAddress.ip,
                                              tableId: order.tableId,
                                              orderId: order.orderId,
                                              fetchOrderModel: fetchOrderModel,
                                            )));
                              },
                              leading: Icon(Icons.receipt_long),
                              title: Text(
                                _data.orderNo +
                                    " " +
                                    "${_data.checkBill == 'Y' ? '(Bill)' : '(Send)'}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('dd-MM-yyyy')
                                        .format(_data.dateIn)
                                        .toString() +
                                    '  ' +
                                    _data.timeIn,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(height: 0.0, color: Colors.grey);
                          },
                          itemCount: orders.length,
                        ),
                        Divider(height: 0.0, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionOrdered(
      List<Order> orders, FetchOrderModel fetchOrderModel) {
    return InkWell(
      onTap: () => orderedModalBottomSheet(context, orders, fetchOrderModel),
      child: Stack(
        children: [
          IconButton(
            icon: Icon(Icons.receipt, size: 26),
            onPressed: () =>
                orderedModalBottomSheet(context, orders, fetchOrderModel),
          ),
          orders.isEmpty && orders.length <= 0
              ? SizedBox(height: 0.0, width: 0.0)
              : Positioned(
                  top: 2.0,
                  right: 8.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    width: 20.0,
                    height: 20.0,
                    child: Center(
                      child: Text(
                        orders.length.toString(),
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class SearchItems extends SearchDelegate {
  final FetchOrderModel fetchOrderModel;
  final List<SaleItems> saleitem;
  final String ip;
  SearchItems(
      {@required this.saleitem,
      @required this.ip,
      @required this.fetchOrderModel});
  List<SaleItems> itemSearch;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    final saleItems = saleitem.where((e) {
      return e.khmerName.toLowerCase().contains(query.toLowerCase()) ||
          e.code.toString().contains(query.toString());
    });

    final itemSuggestion = query.isEmpty ? saleitem : saleItems;
    return itemSuggestion == null
        ? Center(
            child: Text(
              AppLocalization.of(context).getTranValue('no_result_found'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          )
        : ListView(
            children: [
              BlocBuilder<OrderBloc, OrderState>(builder: ((context, state) {
                if (state is OrderLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is OrderLoaded) {
                  FetchOrderModel fetchOrder = state.stateOrder.fetchOrder;
                  Order order = state.stateOrder.fetchOrder.order;
                  var currency = state.stateOrder.fetchOrder.displayCurrency
                      .firstWhere((e) => e.altCurrencyId == e.baseCurrencyId);

                  return state.stateOrder.countQty != 0.0
                      ? Container(
                          width: double.infinity,
                          height: 60.0,
                          color: Color.fromRGBO(230, 230, 230, 1),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.grey[400],
                                  child: Text(
                                    '${currency.baseCurrency}  ${order.grandTotal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DetailSaleScreen(
                                                  ip: ip,
                                                  orderId: 0,
                                                  fetchOrderModel: fetchOrder,
                                                  tableId: 0,
                                                )));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        color: Colors.red,
                                        child: Text(
                                          AppLocalization.of(context)
                                              .getTranValue('view_cart'),
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0.0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(16.0),
                                            ),
                                          ),
                                          height: 30.0,
                                          width: 60.0,
                                          child: Text(
                                            "${state.stateOrder.countQty.floor()}",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
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
                        )
                      : Container(
                          height: 0, color: Theme.of(context).primaryColor);
                } else {
                  return SizedBox();
                }
              })),
              SizedBox(height: 13.0),
              ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: itemSuggestion.map((e) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          BlocProvider.of<OrderBloc>(context)
                            ..add(AddOrderEvent(
                                saleID: e.id,
                                orderID: 0,
                                fetchOrder: fetchOrderModel));
                          print("id : ${e.itemId}");
                        },
                        leading: e.image == null
                            ? Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/no_image.jpg',
                                    ),
                                  ),
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                              )
                            : Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      '${ip + '/Images/items/' + e.image}',
                                    ),
                                  ),
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                              ),
                        title: Text(
                          '${e.khmerName}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey, indent: 90.0),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final saleItems = saleitem.where((e) {
      return e.khmerName.toLowerCase().contains(query.toLowerCase()) ||
          e.code.toString().contains(query.toString());
    });

    final itemSuggestion = query.isEmpty ? saleitem : saleItems;
    return itemSuggestion == null
        ? Center(
            child: Text(
              AppLocalization.of(context).getTranValue('no_result_found'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          )
        : ListView(
            children: [
              BlocBuilder<OrderBloc, OrderState>(builder: ((context, state) {
                if (state is OrderLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is OrderLoaded) {
                  FetchOrderModel fetchOrder = state.stateOrder.fetchOrder;
                  Order order = state.stateOrder.fetchOrder.order;
                  var currency = state.stateOrder.fetchOrder.displayCurrency
                      .firstWhere((e) => e.altCurrencyId == e.baseCurrencyId);

                  return state.stateOrder.countQty != 0.0
                      ? Container(
                          width: double.infinity,
                          height: 60.0,
                          color: Color.fromRGBO(230, 230, 230, 1),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.grey[400],
                                  child: Text(
                                    '${currency.baseCurrency}  ${order.grandTotal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DetailSaleScreen(
                                                  ip: ip,
                                                  orderId: 0,
                                                  fetchOrderModel: fetchOrder,
                                                  tableId: 0,
                                                )));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        color: Colors.red,
                                        child: Text(
                                          AppLocalization.of(context)
                                              .getTranValue('view_cart'),
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0.0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(16.0),
                                            ),
                                          ),
                                          height: 30.0,
                                          width: 60.0,
                                          child: Text(
                                            "${state.stateOrder.countQty.floor()}",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
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
                        )
                      : Container(
                          height: 0, color: Theme.of(context).primaryColor);
                } else {
                  return SizedBox();
                }
              })),
              SizedBox(height: 13.0),
              ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: itemSuggestion.map((e) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          BlocProvider.of<OrderBloc>(context)
                            ..add(AddOrderEvent(
                                saleID: e.id,
                                orderID: 0,
                                fetchOrder: fetchOrderModel));
                        },
                        leading: e.image == null
                            ? Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/no_image.jpg',
                                    ),
                                  ),
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                              )
                            : Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      '${ip + '/Images/items/' + e.image}',
                                    ),
                                  ),
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                              ),
                        title: Text(
                          '${e.khmerName}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey, indent: 90.0),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
  }
}
