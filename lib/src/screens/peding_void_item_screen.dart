import 'package:flutter/material.dart';
import 'package:point_of_sale/src/controllers/pending_void_item_controller.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/screens/sale_screen.dart';

import '../helpers/app_localization.dart';

class PendingVoidItemScreen extends StatefulWidget {
  final String ip;
  final Order order;
  const PendingVoidItemScreen({Key key, @required this.ip, this.order})
      : super(key: key);

  @override
  State<PendingVoidItemScreen> createState() => _PendingVoidItemScreenState();
}

class _PendingVoidItemScreenState extends State<PendingVoidItemScreen> {
  bool check = false;
  Order copyOrder;
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
        title: Text("Pending VoidItem"),
        actions: [
          TextButton(
              onPressed: () async {
                copyOrder.orderDetail = widget.order.orderDetail
                    .where((element) => element.isVoided == true)
                    .toList();
                if (copyOrder.orderDetail.isEmpty ||
                    copyOrder.orderDetail == null) {
                  ShowMessage.alertCommingSoon(context, "Pending Void Item",
                      "Please Select at least one on Pending void item");
                } else {
                  await PendingVoidItemController.pendingVoidItem(
                      widget.ip, copyOrder);
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
                                defaultOrder: false,
                                ip: widget.ip,
                                level: 1,
                                tableId: widget.order.tableId,
                              )));
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
                  Text(orderDetailModel.englishName),
                  Text(
                      '${orderDetailModel.qty} x ${orderDetailModel.unitPrice} ${orderDetailModel.currency}'),
                  Text(orderDetailModel.total.toString() +
                      " " +
                      "${orderDetailModel.currency}"),
                ],
              ),
            ),
          );
  }

  Widget cartVoidItemCustom(OrderDetailModel orderDetailModel) {
    return orderDetailModel.orderDetailId <= 0
        ? SizedBox()
        : ListTile(
            leading: Checkbox(
                onChanged: (value) {
                  setState(() {
                    orderDetailModel.isVoided = value;
                    if (orderDetailModel.isVoided == true) {
                      copyOrder.orderDetail.add(orderDetailModel);
                      print(copyOrder.orderDetail);
                    }
                  });
                },
                value: orderDetailModel.isVoided),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(orderDetailModel.englishName),
                Text(
                    '${orderDetailModel.qty} x ${orderDetailModel.unitPrice}\$')
              ],
            ),
            trailing: Text(orderDetailModel.total.toString() +
                " "
                    "${orderDetailModel.currency}"),
          );
  }
}
