import 'dart:async';
import 'package:flutter/material.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';
import 'package:point_of_sale/src/screens/open_shift_screen.dart';

// ignore: must_be_immutable
class SplitReceiptScreen extends StatefulWidget {
  List<OrderDetail> detail = [];
  String orderNo;
  SplitReceiptScreen({this.detail, this.orderNo});
  @override
  _SplitReceiptScreenState createState() => _SplitReceiptScreenState();
}

class _SplitReceiptScreenState extends State<SplitReceiptScreen> {
  var loading = false;
  List<ShowHied> lsShow = [];
  Timer _timer;
  @override
  void initState() {
    super.initState();
    checkOrder();
    bineShowHied();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Split Receipt ( ${widget.orderNo})",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: loading
            ? widget.detail.length > 0
                ? ListView(
                    children: widget.detail.map((e) {
                      return Card(
                        child: Container(
                          height: 70,
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Stack(
                                children: [
                                  Container(
                                    height: 70,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${e.khmerName} ( ${e.uomName} )",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  lsShow
                                              .firstWhere(
                                                  (s) => s.key == e.lineId)
                                              .show ==
                                          1
                                      ? Positioned(
                                          right: 5,
                                          top: 12.5,
                                          child: Container(
                                            width: 50,
                                            height: 45,
                                            color: Colors.white,
                                            child: MaterialButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                if (e.qty == 1) {
                                                  widget.detail.removeWhere(
                                                      (x) =>
                                                          x.lineId == e.lineId);
                                                }
                                                setState(() {
                                                  e.qty -= 1;
                                                  e.printQty -= 1;
                                                });

                                                if (_timer != null) {
                                                  _timer.cancel();
                                                }
                                                _timer = new Timer(
                                                    Duration(seconds: 2), () {
                                                  if (mounted) {
                                                    setState(() {
                                                      lsShow
                                                          .firstWhere((s) =>
                                                              s.key == e.lineId)
                                                          .show = 0;
                                                    });
                                                  }
                                                });
                                              },
                                              child: Icon(Icons.remove,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        )
                                      : Text("")
                                ],
                              )),
                              Container(
                                width: 50,
                                height: 45,
                                child: MaterialButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      for (var data in widget.detail) {
                                        if (data.lineId == e.lineId) {
                                          lsShow
                                              .firstWhere(
                                                  (s) => s.key == data.lineId)
                                              .show = 1;
                                        } else {
                                          lsShow
                                              .firstWhere(
                                                  (s) => s.key == data.lineId)
                                              .show = 0;
                                        }
                                      }
                                      if (_timer != null) {
                                        _timer.cancel();
                                      }
                                      _timer = Timer(Duration(seconds: 2), () {
                                        if (mounted) {
                                          setState(() {
                                            lsShow
                                                .firstWhere(
                                                    (s) => s.key == e.lineId)
                                                .show = 0;
                                          });
                                        }
                                      });
                                    });
                                  },
                                  child: Text(
                                    "${e.qty.floor()}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Stack(
                                children: [
                                  Container(
                                    height: 70,
                                    alignment: Alignment.centerRight,
                                    child: MaterialButton(
                                      minWidth: 15,
                                      color: Colors.transparent,
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 28,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          widget.detail.removeWhere(
                                              (x) => x.lineId == e.lineId);
                                        });
                                      },
                                    ),
                                  ),
                                  lsShow
                                              .firstWhere(
                                                  (s) => s.key == e.lineId)
                                              .show ==
                                          1
                                      ? Positioned(
                                          left: 1,
                                          top: 12.5,
                                          child: Container(
                                            width: 50,
                                            height: 45,
                                            color: Colors.white,
                                            child: MaterialButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                var checkAdd =
                                                    lsShow.firstWhere(
                                                        (s) =>
                                                            s.key == e.lineId,
                                                        orElse: () => null);
                                                if (checkAdd != null) {
                                                  if (e.qty != checkAdd.qty) {
                                                    setState(() {
                                                      e.qty += 1;
                                                      e.printQty += 1;
                                                    });
                                                  }
                                                }
                                                if (_timer != null) {
                                                  _timer.cancel();
                                                }
                                                _timer = Timer(
                                                    Duration(seconds: 2), () {
                                                  if (mounted) {
                                                    setState(() {
                                                      lsShow
                                                          .firstWhere((s) =>
                                                              s.key == e.lineId)
                                                          .show = 0;
                                                    });
                                                  }
                                                });
                                              },
                                              child: Icon(Icons.add,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        )
                                      : Text("")
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : Center(
                    child: Text(
                      "Data is empty",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
          child: MaterialButton(
            color: Color.fromRGBO(76, 175, 80, 1),
            padding: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("Slipt ",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ),
            onPressed: () async {},
          ),
        ));
  }

  void checkOrder() async {
    if (widget.detail.length > 0) {
      await Future.delayed(Duration(seconds: 1));
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
    } else {
      await Future.delayed(Duration(seconds: 1));
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
    }
  }

  void bineShowHied() async {
    widget.detail.forEach((e) {
      ShowHied sh = new ShowHied(show: 0, key: e.lineId, qty: e.qty);
      lsShow.add(sh);
    });
  }
}
