import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';

class BuildEthernetReceipt extends StatefulWidget {
  final String cashier;
  final String table;
  final String queue;
  final String payBy;
  final String receiptNo;
  final String subTotal;
  final String discount;
  final String grandTotal;
  final String received;
  final String change;
  final String currency;
  final TextEditingController controllerReceived;
  final TextEditingController controllerChanged;
  final List<OrderDetail> orderDetailList;

  const BuildEthernetReceipt({
    Key key,
    this.cashier,
    this.table,
    this.queue,
    this.payBy,
    this.receiptNo,
    this.subTotal,
    this.discount,
    this.grandTotal,
    this.received,
    this.change,
    this.currency,
    this.controllerReceived,
    this.controllerChanged,
    this.orderDetailList,
  }) : super(key: key);

  @override
  _BuildEthernetReceiptState createState() => _BuildEthernetReceiptState();
}

class _BuildEthernetReceiptState extends State<BuildEthernetReceipt> {
  DateFormat dateFormat = new DateFormat("dd-MM-yyyy HH:mm:a");
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      color: Colors.red[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      image: DecorationImage(
                        image: AssetImage('assets/images/coffee.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'រស្មី កាហ្វេ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Moul',
                        ),
                      ),
                      Text(
                        'ភូមិកំពុងចុះវារ ឃុំវិហារលួង​ ស្រុកពញាឮ ខេត្តកណ្ដាល',
                        style: TextStyle(
                          fontFamily: 'Content',
                        ),
                      ),
                      Text(
                        '015 573 716 | 098 837 9334',
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 3),
              Text(
                'RECEIPT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 3),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cashier : ${widget.cashier ?? 'N/A'}'),
                      Text('Table     : ${widget.table ?? 'N/A'}'),
                      Text(
                        'Queue   : ${widget.queue ?? 'N/A'}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Receipt No : ${widget.receiptNo ?? 'N/A'}'),
                      Text(
                          'Time In       : ${dateFormat.format(DateTime.now())}'),
                      Text(
                          'Time Out    : ${dateFormat.format(DateTime.now())}'),
                    ],
                  ),
                ],
              ),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text('Pay By   : '),
                  Text('${widget.payBy ?? 'N/A'}'),
                ],
              ),
              SizedBox(height: 3),
              Text(
                  '-------------------------------------------------------------------------------------------------------'),
              SizedBox(height: 3),
              Row(
                children: [
                  Container(
                    width: 30,
                    child: Text(
                      '№',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 152,
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 54,
                    child: Text(
                      'Qty',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    child: Text(
                      'Price',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    child: Text(
                      'Dis.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              for (var i = 0; i < widget.orderDetailList.length; i++)
                Row(
                  children: [
                    Container(
                      width: 30,
                      child: Text(
                        '${i + 1}',
                      ),
                    ),
                    Container(
                      width: 152,
                      child: Text(
                        '${widget.orderDetailList[i].khmerName ?? 'N/A'}',
                      ),
                    ),
                    Container(
                      width: 54,
                      child: Text(
                        '${widget.orderDetailList[i].qty}',
                      ),
                    ),
                    Container(
                      width: 50,
                      child: Text(
                        '${widget.orderDetailList[i].unitPrice.toStringAsFixed(2)}',
                      ),
                    ),
                    Container(
                      width: 40,
                      child: Text(
                        '${widget.orderDetailList[i].discountValue * widget.orderDetailList[i].qty}',
                      ),
                    ),
                    Container(
                      width: 60,
                      child: Text(
                        '${((widget.orderDetailList[i].unitPrice * widget.orderDetailList[i].qty) - (widget.orderDetailList[i].discountValue * widget.orderDetailList[i].qty)).toStringAsFixed(2)}',
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 3),
              Text(
                  '-------------------------------------------------------------------------------------------------------'),
              SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: SizedBox(width: 50)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Sub-Total'),
                      Text('Discount'),
                      Text('Grand-Total'),
                      Text('Received'),
                      Text('Change'),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(':'),
                      Text(':'),
                      Text(':'),
                      Text(':'),
                      Text(':'),
                    ],
                  ),
                  Expanded(child: Container()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text('${widget.subTotal ?? 0}'),
                      Text('${widget.discount ?? 0}'),
                      Text(
                        '${widget.grandTotal ?? 0}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // Text('${widget.received ?? 0}'),
                      // Text('${widget.change ?? 0}'),
                      Row(
                        children: [
                          Text(widget.currency ?? 'CUR'),
                          Container(
                            height: 20,
                            width: 80,
                            child: TextField(
                              readOnly: true,
                              controller: widget.controllerReceived,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(widget.currency ?? 'CUR'),
                          Container(
                            height: 20,
                            width: 80,
                            child: TextField(
                              readOnly: true,
                              controller: widget.controllerChanged,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 15),
                ],
              ),
              SizedBox(height: 3),
              Text(
                  '-------------------------------------------------------------------------------------------------------'),
              SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('សូមអរគុណសម្រាប់ការអញ្ជើញមក៕'),
                      Text('Password WiFi'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
