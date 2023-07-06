import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';

class DiscountType extends StatefulWidget {
  final OrderDetail detail;
  DiscountType({this.detail});
  @override
  _DiscountTypeState createState() => _DiscountTypeState();
}

class _DiscountTypeState extends State<DiscountType> {
  bool _cash = false;
  bool _percent = false;
  @override
  void initState() {
    super.initState();
    if (widget.detail.typeDis ?? 'Cash' == "Cash") {
      if (mounted) {
        setState(() {
          _cash = true;
          _percent = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _percent = true;
          _cash = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Discount Type")),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text(
                "Percent",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              // trailing: FlutterSwitch(
              //   showOnOff: true,
              //   activeTextColor: Colors.black,
              //   inactiveTextColor: Colors.blue[50],
              //   value: _percent,
              //   onToggle: (val) {
              //     // setState(() {
              //     //   if (val) {
              //     //     _percent = true;
              //     //     widget.detail.typeDis = "Percent";
              //     //     _cash = false;
              //     //   } else {
              //     //     _percent = false;
              //     //     _cash = true;
              //     //     widget.detail.typeDis = "Cash";
              //     //   }
              //     // });
              //   },
              // ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                "Cash",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              // trailing: FlutterSwitch(
              //   showOnOff: true,
              //   activeTextColor: Colors.black,
              //   inactiveTextColor: Colors.blue[50],
              //   value: _cash,
              //   onToggle: (val) {
              //     // setState(() {
              //     //   if (val) {
              //     //     _percent = false;
              //     //     widget.detail.typeDis = "Cash";
              //     //     _cash = true;
              //     //   } else {
              //     //     _percent = true;
              //     //     widget.detail.typeDis = "Percent";
              //     //     _cash = false;
              //     //   }
              //     // });
              //   },
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
