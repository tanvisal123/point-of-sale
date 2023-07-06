import 'package:flutter/material.dart';
import 'package:point_of_sale/src/controllers/split_order_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/screens/open_shift_screen.dart';
import 'package:point_of_sale/src/screens/sale_screen.dart';
import 'package:point_of_sale/src/screens/table_group_screen.dart';

class SplitOrderScreen extends StatefulWidget {
  final Order order;
  final int tableId;
  final String ip;
  SplitOrderScreen(
      {@required this.ip, @required this.tableId, @required this.order});
  @override
  _SplitOrderScreenState createState() => _SplitOrderScreenState();
}

class _SplitOrderScreenState extends State<SplitOrderScreen> {
  var loading = false;
  List<ShowHied> lsShow = [];
  Order order;
  String originalQty;
  String returnQty;
  void copyOrder() {
    setState(() {
      order = Order.copy(widget.order);
      order.orderDetail.forEach((element) {
        element.printQty = 0;
        //print("print qty : ${element.printQty}");
      });
    });
  }

  void splitOrder() async {
    await SplitOrderController.splitOrder(widget.ip, order);
  }

  @override
  void initState() {
    super.initState();
    copyOrder();
  }

  bool checkSplitItem = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${AppLocalization.of(context).getTranValue('split_order')} (${order.orderNo})",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: order.orderDetail.length > 0
            ? ListView(
                children: [
                  ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: order.orderDetail.map((e) {
                        originalQty = e.qty.toString();
                        returnQty = e.printQty.toString();
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
                                      readOnly: true,
                                      initialValue: originalQty,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 5.0),
                                        labelStyle: TextStyle(
                                            fontSize: 17, color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[350]),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide:
                                              BorderSide(color: Colors.green),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
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
                                      //initialValue: returnQty,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        contentPadding:
                                            EdgeInsets.only(left: 5.0),
                                        labelStyle: TextStyle(
                                            fontSize: 17, color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[350]),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide:
                                              BorderSide(color: Colors.green),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey[400],
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        returnQty = value;
                                        e.printQty = double.parse(
                                            returnQty ?? 0.toString());
                                        double qty = e.qty ?? 0;
                                        double printQty =
                                            double.parse(returnQty ?? '0');
                                        if (printQty == 0 || printQty == null) {
                                          checkSplitItem = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                      "Please Input Item To Split")));
                                        } else if (printQty > qty) {
                                          checkSplitItem = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                      "Split Quanntity can't Exceed Original Quantity")));
                                        } else {
                                          // splitOrder();
                                          checkSplitItem = true;
                                        }
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
              )
            : Center(
                child: Text(
                  AppLocalization.of(context).getTranValue('data_is_empty'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
          child: MaterialButton(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(AppLocalization.of(context).getTranValue('split'),
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ),
            onPressed: () async {
              // double qty = double.parse(originalQty);
              // double printQty = double.parse(returnQty ?? '0');
              // if (printQty == 0) {
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //       backgroundColor: Colors.red,
              //       content: Text("Please Input Item To Split")));
              // } else if (printQty > qty) {
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //       backgroundColor: Colors.red,
              //       content: Text(
              //           "Split Quanntity can't Exceed Original Quantity")));
              // } else {
              checkSplitItem ? splitOrder() : SizedBox();
              if (checkSplitItem) {
                ShowMessage.showLoading(context,
                    AppLocalization.of(context).getTranValue('loading'));
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SaleScreen(
                      ip: widget.ip,
                      orderId: 0,
                      // group1: 1,
                      // group2: 1,
                      // group3: 1,
                      tableId: widget.tableId,
                      defaultOrder: true,
                      level: 1,
                    ),
                  ),
                );
              }

              // }
            },
          ),
        ));
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
