import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';

class BuildBluetoothReceipt extends StatefulWidget {
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

  const BuildBluetoothReceipt({
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
  _BuildBluetoothReceiptState createState() => _BuildBluetoothReceiptState();
}

class _BuildBluetoothReceiptState extends State<BuildBluetoothReceipt> {
  DateFormat dateFormat = new DateFormat("dd/MM/yyyy HH:mm:a");
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.red[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
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
                SizedBox(height: 10),
                Text(
                  'រស្មី កាហ្វេ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Moul',
                  ),
                ),
                Text(
                  'ភូមិកំពុងចុះវារ ឃុំវិហារលួង​ ស្រុកពញាឮ ខេត្តកណ្ដាល',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Content',
                  ),
                ),
                Text(
                  '015 573 716 | 098 837 9334',
                ),
                SizedBox(height: 5),
                Text(
                  'RECEIPT',
                  style: TextStyle(
                      fontSize: 18, decoration: TextDecoration.underline),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cashier'),
                    Text('${widget.cashier ?? ''}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Receipt'),
                    Text('${widget.receiptNo ?? ''}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Table'),
                    Text('${widget.table ?? ''}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Queue'),
                    Text('${widget.queue ?? ''}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pay by'),
                    Text('${widget.payBy ?? ''}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time In'),
                    Text('${dateFormat.format(DateTime.now())}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time Out'),
                    Text('${dateFormat.format(DateTime.now())}'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(
              '----------------------------------------------------------------'),
          SizedBox(height: 5),
          Column(
              children: widget.orderDetailList != null
                  ? widget.orderDetailList.map((e) {
                      print('Qty = ${e.qty}');
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (e.qty > 0)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // if (widget.orderDetailList.length % 2 != 0)
                                  //   Text(
                                  //     '',
                                  //     style: TextStyle(
                                  //       fontSize: 17,
                                  //     ),
                                  //   ),
                                  Text(
                                    '${e.khmerName}',
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    '${e.unitPrice.toStringAsFixed(2)} x ${e.qty}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                  if (e.discountValue * e.qty > 0)
                                    Text(
                                      'Dis(%):${e.discountValue * e.qty}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                ],
                              ),
                            ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 0,
                            child: Text(
                              '${((e.qty * e.unitPrice) - (e.discountValue * e.qty)).toStringAsFixed(2)}\$',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      );
                    }).toList()
                  : [
                      Container(
                        height: 10,
                        color: Colors.red,
                      ),
                    ]),
          SizedBox(height: 5),
          Text(
              '----------------------------------------------------------------'),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Sub-Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 0,
                child: Text(
                  widget.subTotal ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Discout',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 0,
                child: Text(
                  widget.discount ?? '',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Grand-Total',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 0,
                child: Text(
                  widget.grandTotal ?? '',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 5),
          Text(
              '----------------------------------------------------------------'),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Received',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      widget.currency ?? '',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Container(
                      height: 25,
                      width: 90,
                      child: TextField(
                        readOnly: true,
                        controller: widget.controllerReceived,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Changed',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      widget.currency ?? '',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Container(
                      height: 25,
                      width: 90,
                      child: TextField(
                        readOnly: true,
                        controller: widget.controllerChanged,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 5),
          Text(
              '----------------------------------------------------------------'),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('សូមអរគុណចំពោះការអញ្ជើញមកទិញ'),
                  Text('Thank you for shopping...!'),
                  Text('Address : #09, St.168, TK'),
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
