import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';

class BuildPaymentRecipt extends StatelessWidget {
  final String cashier;
  final String table;
  final String queue;
  final String receiptNo;
  final double subTotal;
  final double discount;
  final double grandTotal;
  final String currency;
  final String payby;
  final TextEditingController receviedController;
  final TextEditingController returnController;
  //----------------------
  final String branchName;
  final String address;
  final String deskhmer;
  final String desEnglish;
  final String logo;
  final String phone1;
  final String phone2;
  final String title;
  final String wifi;
  final List<OrderDetail> orderDetailList;
  const BuildPaymentRecipt({
    Key key,
    this.payby,
    this.cashier,
    this.table,
    this.queue,
    this.receiptNo,
    this.subTotal,
    this.discount,
    this.grandTotal,
    this.currency,
    this.branchName,
    this.address,
    this.deskhmer,
    this.desEnglish,
    this.logo,
    this.phone1,
    this.phone2,
    this.title,
    this.wifi,
    this.orderDetailList,
    this.receviedController,
    this.returnController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _customerText(String text, {FontWeight fontWeight}) {
      return Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: fontWeight),
      );
    }

    var _f = NumberFormat('#,##0.00');
    return Container(
      width: 350,
      color: Colors.red[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            branchName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            address,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "$phone1 | $phone2",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            "Branch1",
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _customerText("Casher", fontWeight: FontWeight.bold),
                    _customerText("Table", fontWeight: FontWeight.bold),
                    _customerText("Queue", fontWeight: FontWeight.bold),
                    _customerText("Pay By", fontWeight: FontWeight.bold),
                  ],
                ),
              ),
              Container(
                width: 2,
                child: Column(
                  children: [
                    _customerText(":", fontWeight: FontWeight.bold),
                    _customerText(":", fontWeight: FontWeight.bold),
                    _customerText(":", fontWeight: FontWeight.bold),
                    _customerText(":", fontWeight: FontWeight.bold),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _customerText(cashier, fontWeight: FontWeight.bold),
                      _customerText(table, fontWeight: FontWeight.bold),
                      _customerText(queue, fontWeight: FontWeight.bold),
                      _customerText(""),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _customerText("Recipt", fontWeight: FontWeight.bold),
                    _customerText("Time In", fontWeight: FontWeight.bold),
                    _customerText("Time Out", fontWeight: FontWeight.bold),
                    _customerText(""),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    _customerText(":", fontWeight: FontWeight.bold),
                    _customerText(":", fontWeight: FontWeight.bold),
                    _customerText(":", fontWeight: FontWeight.bold),
                    _customerText("", fontWeight: FontWeight.bold)
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _customerText(receiptNo, fontWeight: FontWeight.bold),
                      _customerText(
                          DateFormat('dd-MM-yyy hh:mm a')
                              .format(DateTime.now()),
                          fontWeight: FontWeight.bold),
                      _customerText(
                          DateFormat('dd-MM-yyy hh:mm a')
                              .format(DateTime.now()),
                          fontWeight: FontWeight.bold),
                      _customerText(payby, fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
          Text(
            "___________________________________________",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              SizedBox(width: 5),
              Expanded(
                flex: 4,
                child: _customerText("Name", fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: _customerText("Qty", fontWeight: FontWeight.bold),
              ),
              Expanded(
                flex: 2,
                child: _customerText("Price", fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: _customerText("Dis", fontWeight: FontWeight.bold),
              ),
              Expanded(
                flex: 2,
                child: _customerText("Total", fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
            ],
          ),
          Column(
              children: orderDetailList != null
                  ? orderDetailList.map((e) {
                      return Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: _customerText(
                                  "${e.khmerName}(${e.uomName})",
                                  fontWeight: FontWeight.bold)),
                          Expanded(
                            child: _customerText("${e.qty.toStringAsFixed(0)}",
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              flex: 2,
                              child: _customerText(_f.format(e.unitPrice),
                                  fontWeight: FontWeight.bold)),
                          Expanded(
                              child: _customerText(_f.format(e.discountRate),
                                  fontWeight: FontWeight.bold)),
                          Expanded(
                              flex: 2,
                              child: _customerText(_f.format(e.total),
                                  fontWeight: FontWeight.bold)),
                        ],
                      );
                    }).toList()
                  : SizedBox(
                      height: 0,
                      width: 0,
                    )),
          Text(
            "___________________________________________",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _customerText("Sub-Total", fontWeight: FontWeight.bold),
                    _customerText("Discount", fontWeight: FontWeight.bold),
                    _customerText("Grand-Total", fontWeight: FontWeight.bold),
                  ],
                ),
              )),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _customerText("${_f.format(subTotal)} $currency",
                          fontWeight: FontWeight.bold),
                      _customerText("${_f.format(discount)} $currency",
                          fontWeight: FontWeight.bold),
                      _customerText("${_f.format(grandTotal)} $currency",
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text(
            "___________________________________________",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _customerText("Recived:", fontWeight: FontWeight.bold),
                    _customerText("Return:", fontWeight: FontWeight.bold),
                  ],
                ),
              )),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 20,
                        child: TextFormField(
                          readOnly: true,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                          controller: receviedController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 20,
                        child: TextFormField(
                          readOnly: true,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                          controller: returnController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text(
            "___________________________________________",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "សូមអគុណសំរាប់ការអញ្ជើញមក",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "thank you for your purchase!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "Wifi: 11112222",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
