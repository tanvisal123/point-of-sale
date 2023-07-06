import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/bloc/fetchorder_bloc/fetchorder_bloc.dart';
import 'package:point_of_sale/src/controllers/scan_barcode_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/item_modal.dart';
import 'package:point_of_sale/src/screens/sale_screen.dart';

import 'package:point_of_sale/src/widgets/build_item_widget.dart';

class ItemBarcodeScreen extends StatefulWidget {
  final int tableId;
  final String barcode;
  final String ip;
  ItemBarcodeScreen({Key key, this.tableId, this.barcode, @required this.ip})
      : super(key: key);

  @override
  _ItemBarcodeScreenState createState() => _ItemBarcodeScreenState();
}

class _ItemBarcodeScreenState extends State<ItemBarcodeScreen> {
  List<ItemMaster> _itemMasterList = [];
  bool _status = false;
  _searchItemByBarcode() async {
    print('Barcode = ${widget.barcode}');
    print('TableId = ${widget.tableId}');
    await ScanBarcodeController.searchItemByBarcode(widget.barcode, widget.ip)
        .then((value) {
      setState(() {
        _itemMasterList.addAll(value);
        print('Item = $_itemMasterList');
      });
    });
    _status = true;
  }

  @override
  void initState() {
    super.initState();
    _searchItemByBarcode();
  }

  @override
  Widget build(BuildContext context) {
    var _translat = AppLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_translat.getTranValue('item')),
      ),
      body: _status
          ? _itemMasterList.isNotEmpty
              ? Column(
                  children: [],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(16.0),
                        height: 150.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: Icon(
                          Icons.format_list_bulleted_outlined,
                          size: 100.0,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        _translat.getTranValue('no_item_in_stock'),
                        style: TextStyle(fontSize: 18.0),
                      ),
                      TextButton(
                        onPressed: () {
                          _scanBarcode();
                        },
                        child: Text(_translat.getTranValue('retry')),
                      ),
                    ],
                  ),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  String _barcode;
  Future<void> _scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (!mounted) return;

      if (barcode.isEmpty) {
        return;
      } else {
        setState(() {
          _barcode = barcode;
        });
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItemBarcodeScreen(
                barcode: _barcode, tableId: widget.tableId, ip: widget.ip),
          ),
        );
      }
    } on PlatformException {
      _barcode = 'Failed to get platform version.';
    }
  }
}

class ItemByBarcode extends StatefulWidget {
  final String ip;
  final FetchOrderModel fetchOrderModel;
  final String barCode;
  const ItemByBarcode({Key key, this.ip, this.fetchOrderModel, this.barCode})
      : super(key: key);

  @override
  State<ItemByBarcode> createState() => _ItemByBarcodeState();
}

class _ItemByBarcodeState extends State<ItemByBarcode> {
  OrderDetailModel orderDetailModel;
  Order order;
  void getItemByBarcode() async {
    order = widget.fetchOrderModel.order;
    await ScanBarcodeController.searchByBarcode(
            widget.ip, order.orderId, order.priceListId, widget.barCode)
        .then((value) {
      setState(() {
        orderDetailModel = value;
        status = true;
      });
      print("barcode : ${widget.barCode}");
    });
  }

  bool status = false;
  var _f = NumberFormat('#,##0.00');
  @override
  void initState() {
    super.initState();
    getItemByBarcode();
  }

  @override
  Widget build(BuildContext context) {
    var _translat = AppLocalization.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(_translat.getTranValue('item')),
        ),
        body: status
            ? orderDetailModel.lineId != null
                ? Column(
                    children: [
                      GestureDetector(
                        onTap: (() {
                          BlocProvider.of<FetchOrderBloc>(context)
                            ..add(AddNewOrederEvent(
                                saleId: orderDetailModel.itemId,
                                orderId: order.orderId,
                                fetchOrderModel: widget.fetchOrderModel));
                        }),
                        child: Container(
                          height: 150.0,
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
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '${orderDetailModel.khmerName} (${orderDetailModel.uom})',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: Text(
                                                    '${orderDetailModel.currency} ${orderDetailModel.typeDis == 'Percent' ? _f.format((orderDetailModel.unitPrice - (orderDetailModel.unitPrice * orderDetailModel.discountRate) / 100)) : _f.format((orderDetailModel.unitPrice - orderDetailModel.discountRate))}',
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                orderDetailModel.discountRate !=
                                                        0
                                                    ? Text(
                                                        '${orderDetailModel.currency} ${orderDetailModel.unitPrice}',
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
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(16.0),
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: Icon(
                            Icons.format_list_bulleted_outlined,
                            size: 100.0,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          _translat.getTranValue('no_item_in_stock'),
                          style: TextStyle(fontSize: 18.0),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(_translat.getTranValue('retry')),
                        ),
                      ],
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
