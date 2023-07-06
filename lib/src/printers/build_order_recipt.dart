import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:point_of_sale/src/models/order_detail_modal.dart';

class BuildOrderRecipt extends StatelessWidget {
  final String reciptNo;
  final String cashier;
  final String table;
  final List<OrderDetail> orderDetailList;
  BuildOrderRecipt({
    Key key,
    this.reciptNo,
    this.cashier,
    this.table,
    this.orderDetailList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Table",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Cashier",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Print Date",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      ":",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ":",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ":",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      table,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      cashier,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.now())}",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            "--------------------------------------------------------",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: orderDetailList != null
                  ? orderDetailList.map((e) {
                      return Column(
                        children: [
                          Text(
                            "${e.khmerName} (${e.uomName} ) (${e.qty.toStringAsFixed(0)})",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          )
                        ],
                      );
                    }).toList()
                  : SizedBox(
                      height: 0,
                      width: 0,
                    )),
          Text(
            "------------------------------------------------------",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
