import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/src/controllers/gorup1_controller.dart';
import 'package:point_of_sale/src/controllers/group2_controller.dart';
import 'package:point_of_sale/src/controllers/group3_controller.dart';
import 'package:point_of_sale/src/controllers/item_controller.dart';
import 'package:point_of_sale/src/controllers/payment_mean_controller.dart';
import 'package:point_of_sale/src/controllers/receipt_information_controller.dart';
import 'package:point_of_sale/src/controllers/setting_controller.dart';
import 'package:point_of_sale/src/widgets/drawer_widget.dart';

class SyncScreen extends StatefulWidget {
  final String ip;
  const SyncScreen({@required this.ip});
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  bool isLoadingItem = false;
  bool isLoadingGorup1 = false;
  bool isLoadingGroup2 = false;
  bool isLoadingGroup3 = false;
  bool isLoadingPayment = false;
  bool isLoadingReceipt = false;
  bool isLoadingSetting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(selected: 7, ip: widget.ip),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Synchronization",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return await Future.delayed(Duration(seconds: 2));
        },
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "Item Master Data",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "download item master data",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              trailing: isLoadingItem
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : MaterialButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingItem = true;
                        });
                        downloadItem(widget.ip);
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "Item Category 1",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "download item category 1",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              trailing: isLoadingGorup1
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : MaterialButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingGorup1 = true;
                        });
                        downloadCategoey1(widget.ip);
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "Item Category 2",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              subtitle: Text("download item category 2",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              trailing: isLoadingGroup2
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : MaterialButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingGroup2 = true;
                        });
                        downloadCategory2(widget.ip);
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "Item Category 3",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "download item category 3",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              trailing: isLoadingGroup3
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : MaterialButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingGroup3 = true;
                        });
                        downloadCategory3();
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "Payment Master Data",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "download payment master data",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              trailing: isLoadingPayment
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : MaterialButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingPayment = true;
                        });
                        downloadPaymentMaster(widget.ip);
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "Receipt Master",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "download receipt master data",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              trailing: isLoadingReceipt
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : MaterialButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingReceipt = true;
                        });
                        downloadReceiptMaster(widget.ip);
                      },
                    ),
            ),
            ListTile(
              title: Text(
                "System Setting",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              subtitle: Text("download setting master data",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              trailing: isLoadingReceipt
                  ? Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : MaterialButton(
                      child: Text("Download"),
                      onPressed: () {
                        setState(() {
                          isLoadingSetting = true;
                        });
                        downloadSetting(widget.ip);
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  void downloadItem(String ip) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await ItemController.eachItemLocal(ip).then((value) {
        value.forEach((e) async {
          var data = await ItemController().hasItem(e.key);
          if (data.length == 0) {
            ItemController().insertItem(e);
          } else {
            ItemController().update(e);
          }
        });
      });
      setState(() {
        isLoadingItem = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingItem = false;
      });
    }
  }

  void downloadCategoey1(String ip) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await Group1Controller.eachGroup1(ip).then((value) {
        value.forEach((e) async {
          var has = await Group1Controller().hasGroup1(e.g1Id);
          if (has.length == 0) {
            Group1Controller().insertGroup1(e);
          } else {
            Group1Controller().updateGroup1(e, e.g1Id);
          }
        });
        setState(() {
          isLoadingGorup1 = false;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingGorup1 = false;
      });
    }
  }

  void downloadCategory2(String ip) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await Group2Controller.eachGroup2Local(ip).then((value) {
        value.forEach((e) async {
          var has = await Group2Controller().hasGroup2(e.g2Id);
          if (has.length == 0) {
            Group2Controller().insertGroup2(e);
          } else {
            Group2Controller().updateGroup2(e, e.g2Id);
          }
        });
        setState(() {
          isLoadingGroup2 = false;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingGroup2 = false;
      });
    }
  }

  void downloadCategory3() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await Group3Controller.eachGroup3Local(widget.ip).then((value) {
        value.forEach((e) async {
          var has = await Group3Controller().hasGroup3(e.g3Id);
          if (has.length == 0) {
            Group3Controller().insertGroup3(e);
          } else {
            Group3Controller().updateGorup3(e, e.g3Id);
          }
        });
        setState(() {
          isLoadingGroup3 = false;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingGroup3 = false;
      });
    }
  }

  void downloadPaymentMaster(String ip) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await PaymentMeanController.getPaymenyMean(ip).then((value) {
        value.forEach((e) async {
          var has = await PaymentMeanController().hasPaymentMean(e.id);
          if (has.length == 0) {
            PaymentMeanController().insertPaymentMean(e);
          } else {
            PaymentMeanController().updatePaymentMean(e);
          }
        });
        setState(() {
          isLoadingPayment = false;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingPayment = false;
      });
    }
  }

  void downloadReceiptMaster(String ip) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await ReceiptInformationController.eachRI(ip).then((value) {
        value.forEach((e) async {
          var has = await ReceiptInformationController().hasReceipt(e.id);
          if (has.length == 0) {
            ReceiptInformationController().insertReceipt(e);
          } else {
            ReceiptInformationController().updateReceipt(e, e.id);
          }
        });
        setState(() {
          isLoadingReceipt = false;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingReceipt = false;
      });
    }
  }

  void downloadSetting(String ip) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result) {
      await SettingController.getSetting(ip).then((value) {
        value.forEach((e) async {
          var has = await SettingController().hasSetting(e.id);
          if (has.length == 0) {
            SettingController().insertSetting(e);
          } else {
            SettingController().updateSetting(e);
          }
        });
        setState(() {
          isLoadingSetting = false;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No Internet Connection !"),
        ),
      );
      setState(() {
        isLoadingSetting = false;
      });
    }
  }
}
