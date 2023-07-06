import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/controllers/return_receipt_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/models/return_receipt_model.dart';
import '../helpers/show_message.dart';

class ReturnReceiptScreen extends StatefulWidget {
  final String ip;
  const ReturnReceiptScreen({Key key, @required this.ip}) : super(key: key);
  @override
  State<ReturnReceiptScreen> createState() => _ReturnReceiptScreenState();
}

class _ReturnReceiptScreenState extends State<ReturnReceiptScreen> {
  TextEditingController _dfController;
  TextEditingController _dToController;
  List<ReturnReceiptModel> returnReceipt;
  bool status = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _now = DateTime.now();
  var _dF = DateFormat('yyyy-MM-dd');

  getReturnRecept(String dateFrom, String dateTo) async {
    var connection = await DataConnectionChecker().hasConnection;
    if (connection) {
      try {
        await ReturnReceiptController.getReceiptToReturn(
                widget.ip, dateFrom, dateTo)
            .then((value) {
          setState(() {
            returnReceipt = value;
          });
        });
      } finally {
        status = true;
      }
    } else {
      ShowMessage.showMessageSnakbar(
          AppLocalization.of(context).getTranValue('no_internet'), context);
    }
  }

  @override
  void initState() {
    super.initState();
    _dfController = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    _dToController = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    _dfController = TextEditingController(text: _dF.format(_now));
    _dToController = TextEditingController(text: _dF.format(_now));
    getReturnRecept(_dfController.text, _dToController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalization.of(context).getTranValue("return_receipt")),
      ),
      body: status
          ? ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: DateTimePicker(
                                type: DateTimePickerType.date,
                                dateMask: 'dd-MMMM-yyyy',
                                controller: _dfController,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateLabelText: AppLocalization.of(context)
                                    .getTranValue('date_from'),
                              ),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: DateTimePicker(
                                type: DateTimePickerType.date,
                                dateMask: 'dd-MMMM-yyyy',
                                controller: _dToController,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateLabelText: AppLocalization.of(context)
                                    .getTranValue('date_to'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: MaterialButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  final loForm = _formKey.currentState;
                                  if (loForm.validate() == true) {
                                    loForm.save();
                                    returnReceipt.clear();
                                    getReturnRecept(_dfController.text,
                                        _dToController.text);
                                    returnReceipt.isNotEmpty
                                        ? status = true
                                        : status = false;
                                  }
                                },
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranValue('filter'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: MaterialButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  final loForm = _formKey.currentState;
                                  loForm.reset();
                                  _dfController = TextEditingController(
                                      text: DateFormat("yyyy-MM-dd")
                                          .format(DateTime.now()));
                                  _dToController = TextEditingController(
                                      text: DateFormat("yyyy-MM-dd")
                                          .format(DateTime.now()));
                                  returnReceipt.clear();
                                  getReturnRecept(
                                      _dfController.text, _dToController.text);
                                  returnReceipt.isNotEmpty
                                      ? status = true
                                      : status = false;
                                },
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranValue('reset'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                returnReceipt.isNotEmpty
                    ? Column(
                        children: [
                          Divider(
                              height: 0.0,
                              color: Color.fromARGB(255, 176, 147, 147)),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: returnReceipt.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ShowListItemReturn(
                                              itemReturn: returnReceipt[index]
                                                  .returnItems,
                                              ip: widget.ip)));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  height: 50,
                                  width: double.infinity,
                                  child: Text(
                                    "#${returnReceipt[index].receiptNo} (${returnReceipt[index].dateOut}) ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(height: 0.0, color: Colors.grey);
                            },
                          ),
                          Divider(height: 0.0, color: Colors.grey),
                        ],
                      )
                    : Container(
                        height: 300.0,
                        child: Center(
                          child: Center(
                            child: Text(
                              AppLocalization.of(context)
                                  .getTranValue('no_receipt'),
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class ShowListItemReturn extends StatefulWidget {
  final List<ReturnItem> itemReturn;
  final String ip;
  const ShowListItemReturn(
      {Key key, @required this.itemReturn, @required this.ip})
      : super(key: key);

  @override
  State<ShowListItemReturn> createState() => _ShowListItemReturnState();
}

class _ShowListItemReturnState extends State<ShowListItemReturn> {
  List<ReturnItem> itemsReturn;
  ReturnItemComplate itemComplate;
  bool chexhshowitem = false;
  String returnQty;
  String originalQty;
  final _formKey = GlobalKey<FormState>();
  getItemReturn() async {
    itemsReturn = widget.itemReturn;
    await ReturnReceiptController.getItemToReturn(widget.ip, itemsReturn)
        .then((value) {
      setState(() {
        itemComplate = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalization.of(context).getTranValue('list_of_item')),
          actions: [
            InkWell(
              onTap: () {
                // var reQty = double.parse(returnQty ?? '0');
                // var orgQty = double.parse(originalQty);
                // print(reQty);
                // print(orgQty);
                // if (reQty == 0) {
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //       backgroundColor: Colors.red,
                //       content: Text("No Item Return")));
                // } else if (orgQty <= reQty) {
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //       backgroundColor: Colors.red,
                //       content: Text(
                //           "Return Quanntity can't Exceed Original Quantity")));
                // } else {
                chexhshowitem ? _showMyDialog() : SizedBox();
                // }
              },
              child: Container(
                margin: EdgeInsets.only(right: 20),
                alignment: Alignment.center,
                child: Text(
                  AppLocalization.of(context).getTranValue('apply'),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: widget.itemReturn.map((e) {
                  originalQty = e.openQty.toString();
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
                                onChanged: ((value) {}),
                                readOnly: true,
                                initialValue: originalQty.toString() ?? 0,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 5.0),
                                  labelStyle: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[350]),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
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
                                initialValue: '0',
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  // hintText: '0',
                                  contentPadding: EdgeInsets.only(left: 5.0),
                                  labelStyle: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[350]),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey[400],
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                //====
                                onChanged: (value) {
                                  returnQty = value == '' ? '0' : value;
                                  e.returnQty = double.parse(returnQty);
                                  var reQty = double.parse(returnQty ?? '0');
                                  var orgQty =
                                      double.parse(e.openQty.toString());
                                  print(reQty);
                                  print(orgQty);
                                  if (reQty == 0) {
                                    chexhshowitem = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text("No Item Return")));
                                  } else if (orgQty < reQty) {
                                    chexhshowitem = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                "Return Quanntity can't Exceed Original Quantity")));
                                  } else {
                                    chexhshowitem = true;
                                    //_showMyDialog();
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
        ));
  }

  Widget _buildStack(ReturnItem e) {
    return Stack(
      children: [
        Container(
          child: Text(
            '${e.khName + " " + "(${e.uoM})"}',
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Return Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to Return this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                getItemReturn();
                ShowMessage.showLoading(context,
                    AppLocalization.of(context).getTranValue('loading'));
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReturnReceiptScreen(ip: widget.ip)));
              },
            ),
          ],
        );
      },
    );
  }
}
//  Form(
//         key: _formKey,
//         child: Column(
//             children: List.generate(widget.itemReturn.length, (index) {
//           var data = widget.itemReturn[index];
//           return ListTile(
//             title: Text(
//               "${data.khName}" +
//                   " " +
//                   "(${data.uoM})" +
//                   "      " +
//                   "${data.openQty ?? 0}",
//               style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//             ),
//             trailing: Container(
//               width: 100,
//               child: TextFormField(
//                 controller: returnQty,
//                 onChanged: ((value) {
//                   data.returnQty = double.parse(value == "" ? "0" : value);
//                   print(data.returnQty);
//                 }),
//                 keyboardType: TextInputType.number,
//                 style: TextStyle(fontSize: 19),
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(left: 5.0),
//                   hintText: '0',
//                   labelStyle: TextStyle(fontSize: 17, color: Colors.black),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.grey[350]),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0),
//                     borderSide: BorderSide(color: Colors.green),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0),
//                     borderSide: BorderSide(
//                       color: Colors.grey[400],
//                       width: 2.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         })),
//       ),
