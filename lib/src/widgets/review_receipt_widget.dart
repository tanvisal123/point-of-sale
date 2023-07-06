import 'dart:io';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:point_of_sale/src/controllers/permission_controller.dart';
import 'package:point_of_sale/src/controllers/receipt_contoller.dart';
import 'package:point_of_sale/src/controllers/receipt_information_controller.dart';
import 'package:point_of_sale/src/helpers/printers/connect_bluetooth.dart';
import 'package:point_of_sale/src/models/receip_detail.dart';
import 'package:point_of_sale/src/models/receipt_information.dart';
import 'package:point_of_sale/src/models/receipt_model.dart';
import 'package:point_of_sale/src/screens/open_shift_screen.dart';
import 'package:point_of_sale/src/screens/summary_sale_screen.dart';
import 'package:point_of_sale/src/screens/summrynew_salereceipt.dart';

class ReviewReceipt extends StatefulWidget {
  final ReceiptModel receipts;
  final int receiptId;
  final String ip;
  ReviewReceipt({this.receiptId, this.receipts, @required this.ip});

  @override
  _ReviewReceiptState createState() => _ReviewReceiptState();
}

class _ReviewReceiptState extends State<ReviewReceipt> {
  List<ReceiptDetail> _lsDetail = [];
  String type;
  bool loading = false;
  String _pathImage;
  ReceiptInformation _receiptInfo = new ReceiptInformation();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    ReceiptController.eatchReceiptDetail(widget.receiptId, widget.ip)
        .then((value) {
      if (value.length > 0) {
        if (mounted) {
          setState(() {
            _lsDetail = value;
            loading = true;
          });
        }
      }
    });
    getReceiptInfo(widget.ip);
  }

  _initSaveToPath() async {
    final filename = 'icon_printer.png';
    var bytes = await rootBundle.load("assets/images/icon_printer.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    _writeToFile(bytes, '$dir/$filename');
    setState(() {
      _pathImage = '$dir/$filename';
    });
  }

  Future<void> _writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  }

  void _confirmSummary() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      showAlertDialog(context);
      await Future.delayed(Duration(seconds: 1));
      bluetooth.isConnected.then((isConnected) async {
        if (isConnected) {
          _printSummaryReceipt(_pathImage, result);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => SummarySaleReceipt(ip: widget.ip),
            ),
            (route) => false,
          );
        } else {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConnectionBluetooth(),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Internet Connection !')),
      );
    }
  }

// print receitp summary
  void _printSummaryReceipt(String imaPath, bool isInternet) async {
    bluetooth.isConnected.then((isConnected) async {
      var date = DateTime.now();
      if (isConnected) {
        bluetooth.printCustom(
            DateFormat("dd-MM-yyyy HH:mm:ss").format(date).toString(), 1, 0);
        // try {
        //   String data = 'លក់ទំនិញ';
        //   final bytes = await rootBundle.load(data);
        //   String result =
        //       utf8.decode(bytes.buffer.asUint8List(), allowMalformed: true);
        //   final d =
        //       await CharsetDetector.autoDecode(bytes.buffer.asUint8List());
        //   bluetooth.printCustom('Hi : $result', 1, 0);
        //   bluetooth.printCustom('H  : $d', 1, 0);
        //   bluetooth.printNewLine();
        //   bluetooth.printNewLine();
        //   bluetooth.printNewLine();
        // } catch (e) {
        //   print('error :$e');
        // }
        bluetooth.printCustom(
            "Branch  : ${_receiptInfo.branchName != null ? _receiptInfo.branchName : ""}",
            1,
            0);
        bluetooth.printCustom(
            "Address : ${_receiptInfo.address != null ? _receiptInfo.address : ""}",
            1,
            0);
        bluetooth.printCustom(
            "Phone 1 : ${_receiptInfo.phone1 != null ? _receiptInfo.phone1 : ""}",
            1,
            0);
        bluetooth.printCustom(
            "Phone 2 : ${_receiptInfo.phone2 != null ? _receiptInfo.phone2 : ""}",
            1,
            0);
        bluetooth.printNewLine();
        bluetooth.printCustom("  RECEIPT  ", 3, 1);
        bluetooth.printCustom("-----------", 1, 1);
        bluetooth.printCustom(
            "Cashier     : ${widget.receipts.userAccount.employee.name}", 1, 0);
        bluetooth.printCustom("Queue       : ${widget.receipts.queueNo}", 1, 0);
        bluetooth.printCustom(
            "Pay By      : ${widget.receipts.paymentType}", 1, 0);
        bluetooth.printCustom("Transaction : ${widget.receipts.orderNo}", 1, 0);
        bluetooth.printCustom("Receipt No #: ${widget.receipts.orderNo}", 1, 0);
        bluetooth.printCustom(
            "Date In     : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.receipts.dateIn)).toString()}",
            1,
            0);
        bluetooth.printCustom(
            "Date Out    : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.receipts.dateOut)).toString()}",
            1,
            0);
        bluetooth.printCustom("Time In     : ${widget.receipts.timeIn}", 1, 0);
        bluetooth.printCustom("Time Out    : ${widget.receipts.timeOut}", 1, 0);
        bluetooth.printCustom("-------------------------", 1, 1);
        for (var i = 0; i < _lsDetail.length; i++) {
          bluetooth.printLeftRight("No#  : ", "-------${i + 1}", 0);
          bluetooth.printLeftRight(
              "Name : ",
              "${_lsDetail[i].khmerName}(${_lsDetail[i].unitofMeansure.name}",
              0);
          bluetooth.printLeftRight("Qty  : ", "${_lsDetail[i].qty.floor()}", 0);
          bluetooth.printLeftRight(
              "Price: ", "${_lsDetail[i].unitPrice.toStringAsFixed(2)}", 0);
          bluetooth.printLeftRight(
              "Dis. : ",
              "${_lsDetail[i].discountRate.toStringAsFixed(1)} ${_lsDetail[i].typeDis == "Percent" ? "%" : "Cash"}",
              0);
          bluetooth.printLeftRight(
              "Total: ", "${_lsDetail[i].total.toStringAsFixed(2)}", 0);
        }

        bluetooth.printCustom('----------------------', 1, 1);
        bluetooth.printLeftRight('Sub-Total  :',
            '${widget.receipts.subTotal.toStringAsFixed(2)}', 0);
        bluetooth.printLeftRight('Discount   :',
            '${widget.receipts.typeDis == "Percent" ? "%" : "Cash"}', 0);
        bluetooth.printLeftRight(
            'Grand-Total:',
            '${widget.receipts.currencyDisplay + " " + widget.receipts.grandTotal.toStringAsFixed(2)}',
            0);
        bluetooth.printCustom('----------------------', 1, 1);
        // //-----------------------------------------------------
        // if (widget.receipts.paymentType.contains(',') == true) {
        //   bluetooth.printLeftRight('Cash Pay  :',
        //       '${widget.receipts.receivedType.split(',')[0]}', 0);
        //   bluetooth.printLeftRight('Bank Pay  :',
        //       '${widget.receipts.receivedType.split(',')[1]}', 0);
        // } else if (widget.receipts.paymentType == 'Cash') {
        //   bluetooth.printLeftRight(
        //       'Cash Pay  :', '${widget.receipts.receivedType}', 0);
        // } else if (widget.receipts.paymentType == 'Bank') {
        //   bluetooth.printLeftRight(
        //       'Bank Pay  :', '${widget.receipts.receivedType}', 0);
        // } else {
        //   bluetooth.printLeftRight('Cash Pay  :', '${null}', 0);
        //   bluetooth.printLeftRight('Bank Pay  :', '${null}', 0);
        // }
        // //-------------------------------------------------------
        bluetooth.printLeftRight(
            'Received  :', '${widget.receipts.received.toStringAsFixed(2)}', 0);

        bluetooth.printLeftRight(
            'Change    :',
            '${widget.receipts.currencyDisplay + " " + widget.receipts.change.toStringAsFixed(2)}',
            0);
        bluetooth.printCustom('Thank you for your purchases !', 1, 1);
        bluetooth.printQRcode("${_receiptInfo.branchId}", 200, 200, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();

        //bluetooth.printImage(pathImage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Internet Connection !')),
        );
      }
    });
  }
  //----------------end function ------------------

  Future<void> _notOpenShift(String mess, String ip) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('System Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '$mess',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Row(
                children: [
                  Icon(
                    Icons.check_box,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                var per =
                    await PermissionController.checkPermissionOpenShift(ip);
                if (per == 'false') {
                  Navigator.of(context).pop();
                  hasNotPermission("You cannot access to this function.");
                } else {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OpenShiftScreen(ip: widget.ip),
                    ),
                  );
                }
              },
            ),
            SizedBox(width: 5),
            ElevatedButton(
              child: Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'No',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: Container(
          width: 110.0,
          height: 92.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _confirmSummary();
        },
        child: Icon(Icons.print),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, size: 30),
            onPressed: () {
              _settingModalBottomSheet(context, widget.ip);
            },
          )
        ],
        title: Text(
          "Review Receipt (${widget.receipts.receiptNo})",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: loading
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        child: Image.asset("assets/images/icon_printer.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SizedBox(
                          width: 100,
                          height: 120,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Text(
                                  "Branch :",
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Text(
                                  "Address :",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Text(
                                  "Phone 1:",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Text(
                                  "Phone 2:",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Text(
                                "${_receiptInfo.branchName != null ? _receiptInfo.branchName : ""}",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Text(
                                "${_receiptInfo.address != null ? _receiptInfo.address : " "}",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Text(
                                "${_receiptInfo.phone1 != null ? _receiptInfo.phone1 : ""}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Text(
                                "${_receiptInfo.phone2 != null ? _receiptInfo.phone2 : " "}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Center(
                    child: Text(
                      "RECEIPT",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Cashier",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.userAccount.employee.name}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Queue",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.queueNo}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Pay By",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.paymentType}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Transaction",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.orderNo}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Receipt No #",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.receiptNo}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Date In",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.receipts.dateIn)).toString()}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Date Out",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.receipts.dateOut)).toString()}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Time In",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.timeIn}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 30,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "Time Out",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 2,
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.receipts.timeOut}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        "---------------------------------------------------"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: Text(
                          "№ ",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 38,
                        height: 25,
                        child: Text(
                          "Qty",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        height: 25,
                        child: Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        height: 25,
                        child: Text(
                          "Dis.",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 85,
                        height: 25,
                        child: Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _lsDetail.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25,
                              height: 20,
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${_lsDetail[index].khmerName}(${_lsDetail[index].unitofMeansure.name})",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 38,
                              height: 25,
                              child: Text(
                                "${_lsDetail[index].qty.floor()}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              height: 25,
                              child: Text(
                                "${_lsDetail[index].unitPrice.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              height: 25,
                              child: Text(
                                "${_lsDetail[index].discountRate.toStringAsFixed(1)} ${_lsDetail[index].typeDis == "Percent" ? "%" : "Cash"}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 85,
                              height: 25,
                              child: Text(
                                "${_lsDetail[index].total.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        "---------------------------------------------------"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "SUB-TOTAL :",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      widget.receipts.subTotal.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "DISCOUNT (${widget.receipts.typeDis == "Percent" ? "%" : "Cash"}):",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      widget.receipts.discountRate.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "GRAND-TOTAL :",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      widget.receipts.currencyDisplay +
                          " " +
                          widget.receipts.grandTotal.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        "---------------------------------------------------"),
                  ),
                ),

                // widget.receipts.paymentType.contains(',') == true
                widget.receipts.paymentType == null
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: ListTile(
                              title: Text(
                                "Cash Pay :",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Text(
                                //"${widget.receipts.receivedType.split(',')[0]}",
                                'Null',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: ListTile(
                              title: Text(
                                "Bank Pay :",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Text(
                                //"${widget.receipts.receivedType.split(',')[1]}",
                                'Null',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : widget.receipts.paymentType == "Cash"
                        ? Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: ListTile(
                              title: Text(
                                "Cash Pay :",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Text(
                                "${widget.receipts.receivedType}",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: ListTile(
                              title: Text(
                                "Bank Pay :",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Text(
                                "${widget.receipts.receivedType}",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "Received :",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      widget.receipts.received.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 15, right: 15),
                //   child: ListTile(
                //     title: Text("Credit :",
                //         style: GoogleFonts.laila(
                //             textStyle: TextStyle(
                //                 fontSize: 17.0, fontWeight: FontWeight.w500))),
                //     trailing: Text(widget.receipts.credit.toStringAsFixed(2),
                //         style: GoogleFonts.laila(
                //             textStyle: TextStyle(
                //                 fontSize: 17.0, fontWeight: FontWeight.w500))),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    title: Text(
                      "Change :",
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      widget.receipts.currencyDisplay +
                          " " +
                          widget.receipts.change.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 30),
                  child: Center(
                    child: Text(
                      "${_receiptInfo.desEnglish}",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
    );
  }

  void getReceiptInfo(String ip) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      ReceiptInformationController.eachRI(ip).then((value) {
        if (value.length > 0) {
          if (mounted) {
            setState(() {
              _receiptInfo = value.first;
            });
          }
        }
      });
    } else {
      ReceiptInformationController().getReceipt().then((value) {
        if (value.length > 0) {
          if (mounted) {
            setState(() {
              _receiptInfo = value.first;
            });
          }
        }
      });
    }
  }

  void _settingModalBottomSheet(context, String ip) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(232, 232, 232, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text(
                          "Functions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        new IconButton(
                          icon: Icon(Icons.close, size: 30),
                          color: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: new ListView(
                    children: <Widget>[
                      new Card(
                        child: new ListTile(
                          leading: new Icon(
                            Icons.print,
                            size: 30,
                            color: Colors.black87,
                          ),
                          title: new Text(
                            'Print Receipt',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            _confirmSummary();
                          },
                        ),
                      ),
                      new Card(
                        child: new ListTile(
                            leading: new Icon(
                              Icons.cancel,
                              size: 30,
                              color: Colors.black87,
                            ),
                            title: new Text(
                              'Cancal Receipt',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () async {
                              var check = await PermissionController
                                  .permissionCancelOrder(ip);
                              if (check == 'true') {
                              } else {
                                hasNotPermission(
                                    "You cannot access to this function .");
                              }
                            }),
                      ),
                      new Card(
                        child: new ListTile(
                            leading: new Icon(
                              Icons.assignment_return,
                              size: 30,
                              color: Colors.black87,
                            ),
                            title: new Text(
                              'Return Receipt',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () async {
                              var check = await PermissionController
                                  .permissionReturnOrder(ip);
                              if (check == 'true') {
                                print('Permission true');
                              } else {
                                hasNotPermission(
                                  "You cannot access to this function .",
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> hasNotPermission(String mess) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('System Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '$mess',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Color.fromRGBO(75, 181, 69, 1),
              shape: StadiumBorder(),
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Ok',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
