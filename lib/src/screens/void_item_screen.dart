import 'package:flutter/material.dart';
import 'package:point_of_sale/src/controllers/void_item_controller.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/screens/sale_screen.dart';

class VoidItemScreen extends StatefulWidget {
  VoidItemScreen({this.ip, this.order, Key key}) : super(key: key);
  final Order order;
  final String ip;

  @override
  State<VoidItemScreen> createState() => _VoidItemScreenState();
}

final _formKey = new GlobalKey<FormState>();
final TextEditingController reasonController = TextEditingController();
Order tempOrder;
Order copyOrder;

class _VoidItemScreenState extends State<VoidItemScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      copyOrder = Order.copy(widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Void Item'),
        actions: [
          TextButton(
              onPressed: () {
                copyOrder.orderDetail = widget.order.orderDetail
                    .where((element) => element.isVoided == true)
                    .toList();
                if (copyOrder.orderDetail.isEmpty) {
                  ShowMessage.alertCommingSoon(
                      context, "Void Item", "Select at least 1 void Item");
                } else {
                  showMessageReason();
                }
              },
              child: Text(
                "Apply",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: ListView.builder(
          itemCount: widget.order.orderDetail.length,
          itemBuilder: (context, index) {
            var data = widget.order.orderDetail[index];
            return buildItem(data);
          }),
    );
  }

  Widget buildItem(OrderDetailModel orderDetailModel) {
    return orderDetailModel.orderDetailId <= 0
        ? SizedBox()
        : GestureDetector(
            onTap: (() {
              setState(() {
                orderDetailModel.isVoided == false
                    ? orderDetailModel.isVoided = true
                    : orderDetailModel.isVoided = false;
              });
            }),
            child: Card(
              elevation: 0.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Checkbox(
                        onChanged: (value) {
                          setState(() {
                            orderDetailModel.isVoided = value;
                          });
                        },
                        value: orderDetailModel.isVoided),
                    Text(orderDetailModel.khmerName),
                    Text(
                        '${orderDetailModel.qty} x ${orderDetailModel.unitPrice} ${orderDetailModel.currency}'),
                    Text(orderDetailModel.total.toString() +
                        " " +
                        "${orderDetailModel.currency}"),
                  ],
                ),
              ),
            ),
          );
  }

  Widget cartVoidItemCustom(OrderDetailModel orderDetailModel, int index) {
    return orderDetailModel.orderDetailId <= 0
        ? SizedBox()
        : Card(
            elevation: 0.0,
            child: ListTile(
              textColor: orderDetailModel.isVoided == true ? Colors.red : null,
              style: ListTileStyle.list,
              leading: Checkbox(
                onChanged: (value) {
                  setState(() {
                    orderDetailModel.isVoided = value;
                  });
                },
                value: orderDetailModel.isVoided,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      orderDetailModel.khmerName,
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${orderDetailModel.qty} x ${orderDetailModel.unitPrice}',
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              trailing: Text(
                orderDetailModel.total.toString() +
                    ' ' +
                    orderDetailModel.currency,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
  }

  Future<void> showMessageReason() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Reason of void Item'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: reasonController,
                maxLength: 300,
                maxLines: 3,
                onChanged: (stringValue) {
                  widget.order.reason = stringValue;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter text!";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    border: OutlineInputBorder(),
                    hintText: 'please enter reason!'),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueAccent),
                  ),
                  onPressed: () async {
                    widget.order.orderDetail = widget.order.orderDetail
                        .where((element) => element.isVoided == true)
                        .toList();

                    if (_formKey.currentState.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                          'processing to void item',
                          style: TextStyle(fontSize: 17),
                        )),
                      );
                      await VoidItemController()
                          .postVoidItem(widget.ip, widget.order)
                          .whenComplete(() {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SaleScreen(
                                    ip: widget.ip,
                                    // group1: 1,
                                    // group2: 1,
                                    // group3: 1,
                                    level: 1,
                                    tableId: widget.order.tableId,
                                    orderId: 0,
                                    defaultOrder: true)),
                            (route) => false);

                        // Navigator.push(context,   MaterialPageRoute(builder: (context) =>DetailSaleScreen(ip: ip, orderId: orderId, fetchOrderModel: fetchOrderModel, tableId: tableId) ));
                      });
                    }
                  },
                  child: Text(
                    'Okay',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))
            ],
          );
        });
  }
}
  // CupertinoButton(
          //     color: Color(0xFF448AFF),
          //     child: Text('Apply'),
          //     onPressed: () {
          //       showMessageReason();
          //     }),