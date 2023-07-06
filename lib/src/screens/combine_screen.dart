import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/src/controllers/combine_receipt_controller.dart';
import 'package:point_of_sale/src/controllers/sale_controller.dart';
import 'package:point_of_sale/src/models/combine_modal.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';
import 'package:point_of_sale/src/models/order_modal.dart';
import 'package:point_of_sale/src/models/post_server_modal.dart';

class CombineScreen extends StatefulWidget {
  final OrderModel order;
  final String ip;
  CombineScreen({this.order, @required this.ip});
  @override
  _CombineScreenState createState() => _CombineScreenState();
}

class _CombineScreenState extends State<CombineScreen> {
  List<CombineReceipt> receipts = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    CombineReceiptController.eachCombine(widget.order.orderId, widget.ip)
        .then((value) async {
      if (value.length > 0) {
        if (mounted) {
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            receipts = value;
            loading = false;
          });
        }
      } else {
        if (mounted) {
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            loading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Combine Receipt( ${widget.order.orderNo} )",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          centerTitle: true,
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ))
            : receipts.length != 0
                ? ListView(
                    children: [
                      new ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: receipts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              child: new Container(
                                padding: new EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    new CheckboxListTile(
                                        activeColor: Colors.lightGreen[700],
                                        dense: true,
                                        //font change
                                        title: new Text(
                                          receipts[index].tableName +
                                              "  " +
                                              "#" +
                                              receipts[index].orderNo,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        value: receipts[index].isCheck,
                                        secondary: Text(
                                          "${index + 1}",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        onChanged: (bool val) {
                                          itemChange(val, index);
                                        })
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  )
                : Center(
                    child: Text(
                      "Data is empty.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
          child: MaterialButton(
            color: Color.fromRGBO(76, 175, 80, 1),
            padding: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                "Combine",
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            onPressed: () async {
              if (receipts.length > 0) {
                List<Receipt> lsReceipt = [];
                receipts.forEach((x) {
                  if (x.isCheck) {
                    Receipt re = new Receipt(orderID: x.orderId);
                    lsReceipt.add(re);
                  }
                });
                CombineReceipt combine = new CombineReceipt(
                    orderId: widget.order.orderId,
                    tableId: widget.order.tableId,
                    orderNo: widget.order.orderNo,
                    receipts: lsReceipt,
                    isCheck: false,
                    tableName: "");
                showAlertDialog(context);
                await Future.delayed(Duration(seconds: 2));
                var result = await CombineReceiptController()
                    .postOrder(combine, widget.ip);
                if (result == "true") {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  var getOrder = await SaleController.getOrder(
                      widget.order.tableId, widget.ip);
                  await SaleController().deleteAllOrder();
                  await SaleController().deleteAllOrderDetail();
                  //has order on table
                  if (getOrder.length > 0) {
                    buildOrder(getOrder[0]);
                  } // no order on  table
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => SaleGroupScreen(
                  //         type: "G1",
                  //         tableId: widget.order.tableId,
                  //         lsPost: getOrder),
                  //   ),
                  // );
                }
              }
            },
          ),
        ));
  }

  void itemChange(bool val, int index) {
    setState(() {
      receipts[index].isCheck = val;
    });
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: Container(
          width: 110.0,
          height: 92.0,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.green,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Text(
                  "Loading...",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buildOrder(PostModel p) async {
    var key = 0;
    OrderModel order = new OrderModel(
        orderId: p.orderId,
        orderNo: p.orderNo,
        tableId: p.tableId,
        receiptNo: p.receiptNo,
        queueNo: p.queueNo,
        dateIn: p.dateIn,
        dateOut: p.dateOut,
        timeIn: p.timeIn,
        timeOut: p.timeOut,
        waiterId: p.waiterId,
        userOrderId: p.userOrderId,
        userDiscountId: p.userDiscountId,
        customerId: p.customerId,
        customerCount: p.customerCount,
        priceListId: p.priceListId,
        localCurrencyId: p.localCurrencyId,
        sysCurrencyId: p.sysCurrencyId,
        exchangeRate: p.exchangeRate,
        warehouseId: p.warehouseId,
        branchId: p.branchId,
        companyId: p.companyId,
        subTotal: p.subTotal,
        discountRate: p.discountRate,
        discountValue: p.discountValue,
        typeDis: p.typeDis,
        taxRate: p.taxRate,
        taxValue: p.taxValue,
        grandTotal: p.grandTotal,
        grandTotalSys: p.grandTotalSys,
        tip: p.tip,
        received: p.received,
        change: p.change,
        currencyDisplay: p.currencyDisplay,
        displayRate: p.displayRate,
        grandTotalDisplay: p.grandTotalDisplay,
        changeDisplay: p.changeDisplay,
        paymentMeansId: p.paymentMeansId,
        checkBill: p.checkBill,
        cancel: p.cancel,
        delete: p.delete,
        paymentType: p.paymentType,
        receivedType: p.receivedType,
        credit: p.credit);
    key = await SaleController().insertOrder(order);
    p.detail.forEach((x) {
      OrderDetail detail = new OrderDetail(
          masterId: key,
          orderDetailId: x.orderDetailId,
          orderId: x.orderId,
          lineId: x.lineId,
          itemId: x.itemId,
          code: x.code,
          khmerName: x.khmerName,
          englishName: x.englishName,
          qty: x.qty,
          printQty: x.printQty,
          unitPrice: x.unitPrice,
          cost: x.cost,
          discountRate: x.discountRate,
          discountValue: x.discountValue,
          typeDis: x.typeDis,
          total: x.total,
          totalSys: x.totalSys,
          uomId: x.uomId,
          itemStatus: x.itemStatus,
          itemPrintTo: x.itemPrintTo,
          currency: x.currency,
          comment: x.comment,
          itemType: x.itemType,
          description: x.description,
          parentLevel: x.parentLevel,
          image: x.image,
          show: 0);
      SaleController().insertOrderDetail(detail);
    });
  }
}
