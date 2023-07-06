import 'package:flutter/material.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/screens/detail_sale_screen.dart';

class EditPriceScreen extends StatefulWidget {
  final String ip;
  final FetchOrderModel fetchOrderModel;
  const EditPriceScreen(
      {Key key, @required this.ip, @required this.fetchOrderModel})
      : super(key: key);

  @override
  State<EditPriceScreen> createState() => _EditPriceScreenState();
}

class _EditPriceScreenState extends State<EditPriceScreen> {
  TextEditingController unitPricController;
  TextEditingController editPriceController;
  FetchOrderModel fetchOrderModel;
  Order order;
  Order copyOrder;
  void getOrder() {
    setState(() {
      fetchOrderModel = widget.fetchOrderModel;
      order = fetchOrderModel.order;
      copyOrder = Order.copy(order);
    });
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

  static double sumGrandTotal(Order order) {
    double grandTotal = 0.0;
    grandTotal = order.subTotal * (1 - order.discountRate / 100);
    order.grandTotal = grandTotal;
    return grandTotal;
  }

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalization.of(context).getTranValue('edit_price')),
        actions: [
          InkWell(
            onTap: () async {
              setState(() {
                order.subTotal = sumSubtotal(copyOrder);
                order.grandTotal = sumGrandTotal(copyOrder);
              });
              print("sub total :${copyOrder.subTotal}");
              print("grand total ${copyOrder.grandTotal}");
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailSaleScreen(
                            fetchOrderModel: widget.fetchOrderModel,
                            orderId: order.orderId,
                            tableId: order.tableId,
                            ip: widget.ip,
                          )));
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              child: Text(
                AppLocalization.of(context).getTranValue('apply'),
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: copyOrder.orderDetail.map((e) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStack(e),
                          ),
                          Container(
                            height: 50,
                            width: 70,
                            child: TextFormField(
                              onChanged: ((value) {}),
                              readOnly: true,
                              initialValue: e.unitPrice.toString(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 5.0),
                                labelStyle: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[350]),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Colors.grey[400],
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 50,
                            width: 90,
                            child: TextFormField(
                              initialValue: '0',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 5.0),
                                labelStyle: TextStyle(
                                    fontSize: 17, color: Colors.black),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[350]),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Colors.grey[400],
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              //====
                              onChanged: (value) {
                                double priceEdit =
                                    double.parse(value == '' ? '0' : value);
                                e.unitPrice = priceEdit;
                                print("unit price : ${e.unitPrice}");
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              }).toList())
        ],
      ),
    );
  }

  Widget _buildStack(OrderDetailModel e) {
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
      ],
    );
  }
}
