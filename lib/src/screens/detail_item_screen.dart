import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/bloc/fetchorder_bloc/fetchorder_bloc.dart';
import 'package:point_of_sale/src/controllers/item_comment_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/delete_item_comment.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/item_comment_model.dart';
import 'package:point_of_sale/src/screens/add0n_item_screen.dart';
import 'package:point_of_sale/src/screens/detail_sale_screen.dart';
import 'package:point_of_sale/src/screens/item_comment_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DetailItem extends StatefulWidget {
  final OrderDetailModel orderDetail;
  final FetchOrderModel fetchOrderModel;
  final String ip;
  DetailItem(
      {@required this.ip,
      @required this.orderDetail,
      @required this.fetchOrderModel});
  @override
  _DetailItemState createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  double _ordered = 0;
  double _disValue = 0;
  FetchOrderModel fetchOrderModel;
  int orderId;
  Order order;
  OrderDetailModel lineItem;
  double disValue = 0;
  double disRate = 0;
  var currency;
  double totalTaxvalue = 0;
  var _controllerDisRate = TextEditingController();
  var _controllerDisValue = TextEditingController();
  var _controllerItemComment = TextEditingController();
  String selectItemUom = '';
  List<String> list1 = [];
  List<SelectListItem> listItemUoms = [];
  Map<int, String> itemComment = Map();
  List<ItemCommentModel> listItemComment;
  List<ItemCommentModel> selectlistItemComment = [];
  String itemCommentString = '';

  Setting setting;
  TaxGroup taxGroup;
  var listselectUom;
  bool _isBackPressedOrTouchedOutSide = false;
  bool _isDropDownOpened = false;
  bool _isPanDown = false;
  List<String> getSelectUOMs(List<SelectListItem> selectListItem) {
    print('=====================');
    List<String> listUom = [];
    listUom.clear();
    if (selectListItem == null) {
      print('List no data..... ');
    } else {
      for (var select in selectListItem) {
        print('Uom:${select.text}');
        print('Selected:${select.selected}');
        print('Value:${select.value}');
        listUom.add(select.text.toString());
        print('-------------------');
      }
    }
    print('=====================');
    return listUom;
  }

  void convertListItemToString(List<ItemCommentModel> listString) {
    String itemCommentString = '';
    for (ItemCommentModel temp in listString) {
      itemCommentString = (itemCommentString + ';') + temp.description;
      // print(temp.description);
    }
    if (itemCommentString != '') {
      widget.orderDetail.comment =
          itemCommentString.substring(1, itemCommentString.length);
    }

    print(itemCommentString);
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

    //print("noneOrInvoiceVAT : $noneOrInvoiceVAT");
    print("total notax : ${order.subTotal}");
    print("grand total : ${order.grandTotal}");
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

  bool statue = true;
  void getItemComment() async {
    await ItemCommentController().getItemComment(widget.ip).then((value) {
      setState(() {
        listItemComment =
            value.where((element) => element.deleted == false).toList();
        statue = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listItemUoms = widget.orderDetail.itemUoms;
    selectItemUom = widget.orderDetail.uom.toString();
    list1 = getSelectUOMs(widget.orderDetail.itemUoms);
    getItemComment();
    //initTax();
    //sumItemsTotal(order, setting);
    setState(() {
      _ordered = widget.orderDetail.qty;
      fetchOrderModel = widget.fetchOrderModel;
      orderId = fetchOrderModel.order.orderId;
      order = fetchOrderModel.order;
      setting = fetchOrderModel.setting;
      currency = fetchOrderModel.displayCurrency.firstWhere(
          (element) => element.altCurrencyId == element.baseCurrencyId);
      lineItem = widget.orderDetail;
    });
    _controllerDisRate.text = '0.00';
    _controllerDisValue.text = '0.00';
    print("tax option : ${setting.taxOption}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  //height: 140,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${lineItem.khmerName} (${lineItem.uom})",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              widget.orderDetail.itemUoms != null
                                  ? buildListUom()
                                  : SizedBox(
                                      height: 0,
                                    )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  "${getItemTotal(lineItem, widget.fetchOrderModel.setting).toStringAsFixed(2)} ${widget.fetchOrderModel.order.currency.symbol} ",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600)),
                              lineItem.taxRate == 0.0 ||
                                      setting.taxOption == 4 ||
                                      setting.taxOption == 0
                                  ? SizedBox()
                                  : Text(
                                      'tax %: ${widget.orderDetail.taxRate}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 70,
                  child: Row(
                    children: [
                      Container(
                        width: 55,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Icon(Icons.remove),
                          onPressed: _ordered == 1
                              ? null
                              : () => setState(() => _ordered -= 1),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 50,
                          child: TextFormField(
                            scrollPadding: EdgeInsets.only(bottom: 0.5),
                            style: TextStyle(fontSize: 18),
                            key: Key(_ordered.toString()),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            initialValue: _ordered.toString(),
                            onChanged: (value) {
                              _ordered = double.parse(value);
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 55,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: Icon(Icons.add),
                          onPressed: () => setState(() => _ordered += 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('^([1-9][0-9]?|100)\$'),
                          ),
                          LengthLimitingTextInputFormatter(3),
                        ],
                        controller: _controllerDisRate,
                        style: TextStyle(fontSize: 18.0),
                        key: Key(_disValue.toString()),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
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
                        onChanged: (value) {
                          if (value == '') {
                            _controllerDisRate.text = '0.00';
                          } else {
                            disRate = double.parse(value);
                            _controllerDisValue.text =
                                ((order.subTotal * double.parse(value)) / 100)
                                    .toStringAsFixed(2);
                            order.grandTotal = order.subTotal -
                                double.parse((_controllerDisValue.text));
                          }
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _controllerDisValue,
                        onChanged: (value) {
                          if (value == '') {
                            _controllerDisValue.text = '0.00';
                          } else {
                            disValue = double.parse(value);
                            _controllerDisRate.text =
                                ((disValue * 100) / order.subTotal)
                                    .toStringAsFixed(2);
                            disRate = ((disValue * 100) / order.subTotal);
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
                        height: 16,
                      ),
                      listselectItem != null || listselectItem == []
                          ? Container(
                              height: 300,
                              width: double.infinity,
                              padding: const EdgeInsets.all(3),
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: selectlistItemComment.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 0,
                                      child: ListTile(
                                        title: Text(selectlistItemComment[index]
                                            .description),
                                        trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                selectlistItemComment
                                                    .removeAt(index);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              size: 30,
                                              color: Colors.red,
                                            )),
                                      ),
                                    );
                                  }),
                            )
                          : SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: Center(
                                child: Text('Not reloadsatate .... '),
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 2),
        height: 60.0,
        child: MaterialButton(
          splashColor: Colors.white,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            setState(() {
              widget.orderDetail.qty = _ordered;
              widget.orderDetail.printQty = _ordered;
              lineItem.discountRate = disRate;
              lineItem.discountValue = disValue;
              getItemTotal(widget.orderDetail, setting);
            });
            setState(() {
              convertListItemToString(selectlistItemComment ?? []);
            });
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailSaleScreen(
                  ip: widget.ip,
                  fetchOrderModel: fetchOrderModel,
                  orderId: orderId,
                  tableId: 0,
                ),
              ),
            );
          },
          child: Text(
            AppLocalization.of(context).getTranValue('update'),
            style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CupertinoButton(
                padding: const EdgeInsets.all(0),
                borderRadius: BorderRadius.circular(0),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (lineItem.itemType.toLowerCase() ==
                      "addon".toLowerCase()) {
                    ShowMessage.alertCommingSoon(
                        context, "Addon", "Item can't Addon");
                  } else {
                    Navigator.pop(context);
                    List<BaseItemGroup> listBaseItem = fetchOrderModel
                        .bItemGroups
                        .where((element) => element.khmerName.endsWith("*"))
                        .toList();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddOnItemScreen(
                                  ip: widget.ip,
                                  fetchOrder: fetchOrderModel,
                                  listBaseItem: listBaseItem,
                                  tableId: widget.fetchOrderModel.order.tableId,
                                  orderDetailModel: lineItem,
                                )));
                  }
                },
                child: Text(AppLocalization.of(context).getTranValue('add_on')),
              ),
            ),
            Expanded(
              child: CupertinoButton(
                padding: const EdgeInsets.all(0),
                borderRadius: BorderRadius.circular(0),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  List list = await showMaterialModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return ItemCommentScreen(
                          orderDetail: widget.orderDetail,
                          ip: widget.ip,
                          listselectItem: selectlistItemComment ?? [],
                        );
                      });
                  if (list != null) {
                    setState(() {
                      selectlistItemComment = List.from(list);
                    });
                  }
                  setState(() {
                    convertListItemToString(selectlistItemComment ?? []);
                  });
                },
                child: Text(
                    AppLocalization.of(context).getTranValue('comment_item')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListUom() {
    return Container(
      height: 50,
      width: 150,
      child: AwesomeDropDown(
        elevation: 0.0,
        selectedItemTextStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        dropDownListTextStyle: TextStyle(fontWeight: FontWeight.bold),
        dropDownBottomBorderRadius: 5,
        dropDownTopBorderRadius: 5,
        isPanDown: _isPanDown,
        dropDownList: list1,
        selectedItem: selectItemUom,
        onDropDownItemClick: (selectedItem) {
          print('selectText:$selectedItem');
          widget.orderDetail.uom = selectItemUom = selectedItem;
          for (var select in listItemUoms) {
            if (selectItemUom == select.text) {
              setState(() {
                lineItem.uomId = int.parse(select.value);
              });
              print("line item : ${lineItem.uomId}");
              BlocProvider.of<FetchOrderBloc>(context).add(UpdateOrderEvent(
                  orderDetailModel: lineItem,
                  fetchOrderModel: fetchOrderModel));
              print('UOM Value=${widget.orderDetail.uomId}');
            }
          }
        },
        dropStateChanged: (isOpened) {
          _isDropDownOpened = isOpened;
          print("isOpened : $isOpened");
          if (!isOpened) {
            _isBackPressedOrTouchedOutSide = false;
          }
        },
      ),
    );
  }

  orderedModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(top: 25),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
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
                            Icons.add,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1.0, color: Colors.white),
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        height: 60.0,
                        child: MaterialButton(
                            color: Colors.red,
                            splashColor: Colors.white,
                            onPressed: () {},
                            child: TextFormField(
                              controller: _controllerItemComment,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search..."),
                            )),
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
                    listItemComment == null
                        ? Center(
                            child: Text("No ItemComment"),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                        listItemComment[index].description),
                                  )),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.red,
                                            )),
                                        IconButton(
                                            onPressed: () async {
                                              DeleteItemComment
                                                  deleteItemComment =
                                                  await ItemCommentController()
                                                      .deleteItemComment(
                                                          widget.ip,
                                                          listItemComment[index]
                                                              .id);
                                              if (deleteItemComment
                                                      .comment.deleted ==
                                                  true) {
                                                setState(() {
                                                  getItemComment();
                                                });
                                              }
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )),
                                        IconButton(
                                            onPressed: (() {
                                              setState(() {
                                                itemComment[
                                                        listItemComment[index]
                                                            .id] =
                                                    listItemComment[index]
                                                        .description;
                                              });
                                            }),
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              );
                              // return ListTile(
                              //   onTap: () async {},
                              //   leading: Icon(Icons.receipt_long),
                              //   title: Text(
                              //     suggestionItemComment[index].description,
                              //     style: TextStyle(
                              //       fontSize: 18.0,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              //   trailing: IconButton(
                              //     onPressed: () {
                              //       setState(() {
                              //         itemComment[
                              //                 suggestionItemComment[index].id] =
                              //             suggestionItemComment[index]
                              //                 .description;
                              //       });
                              //     },
                              //     icon: Icon(Icons.add),
                              //   ),
                              // );
                            },
                            itemCount: listItemComment.length,
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
  }
}
