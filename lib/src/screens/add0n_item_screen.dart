import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/bloc/order_bloc/order_bloc.dart';
import 'package:point_of_sale/src/controllers/groupItem_controller.dart';
import 'package:point_of_sale/src/controllers/order_detail_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/screens/detail_sale_screen.dart';

class AddOnItemScreen extends StatefulWidget {
  final String ip;
  final int tableId;
  final FetchOrderModel fetchOrder;
  final List<BaseItemGroup> listBaseItem;
  final OrderDetailModel orderDetailModel;
  const AddOnItemScreen(
      {Key key,
      this.ip,
      this.fetchOrder,
      this.listBaseItem,
      this.tableId,
      this.orderDetailModel})
      : super(key: key);

  @override
  State<AddOnItemScreen> createState() => _AddOnItemScreenState();
}

class _AddOnItemScreenState extends State<AddOnItemScreen> {
  List<SaleItems> listSaleItem;
  Map<int, String> mapGroup1;
  Map<int, List<SaleItems>> mapItemG1;
  String name1;
  Future<OrderDetailModel> insertLineItem(
      FetchOrderModel fetchOrderModel, SaleItems saleItem, int orderId) async {
    OrderDetailModel orderDetail = await OrderDetialController()
        .getOrderDetail(widget.ip, saleItem.id, orderId);
    orderDetail.lineId = DateTime.now().microsecondsSinceEpoch.toString();
    orderDetail.parentLineId = widget.orderDetailModel.lineId;
    List<OrderDetailModel> listOrderDetails = fetchOrderModel.order.orderDetail;
    int index = listOrderDetails.indexOf(widget.orderDetailModel);
    fetchOrderModel.order.orderDetail.insert(index + 1, orderDetail);
    print("line id : ${widget.orderDetailModel.lineId}");
    print("parent line Id : ${orderDetail.parentLineId}");
    return orderDetail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Addon Item"),
      ),
      body: listSaleItem == null
          ? _buildGroup(widget.listBaseItem, widget.fetchOrder)
          : _buildItem(listSaleItem, widget.fetchOrder),
      bottomNavigationBar:
          BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
        if (state is OrderLoaded) {
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
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailSaleScreen(
                                        ip: widget.ip,
                                        orderId: data.order.orderId,
                                        fetchOrderModel: data,
                                        tableId: widget.tableId,
                                      )));
                        },
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
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
                ),
              ),
            ),
          );
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

  Widget buildSaleItem(SaleItems saleItem, FetchOrderModel fetchOrderModel) {
    var currency = fetchOrderModel.displayCurrency.firstWhere(
        (element) => element.altCurrencyId == element.baseCurrencyId);
    var _f = NumberFormat('#,##0.00');
    int priceListId = fetchOrderModel.order.priceListId;
    return saleItem != null
        ? InkWell(
            onTap: () async {
              if (saleItem.itemId > 0) {
                insertLineItem(
                    fetchOrderModel, saleItem, fetchOrderModel.order.orderId);
              } else {}
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
                  saleItem.qty == 0
                      ? SizedBox()
                      : Positioned(
                          bottom: 40,
                          left: 60,
                          child: Container(
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
                          )),
                ],
              ),
            ),
          )
        : Center(
            child: Text("No Item"),
          );
  }
}
