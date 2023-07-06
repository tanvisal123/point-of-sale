import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:point_of_sale/src/controllers/check_privilege_conntroller.dart';
import 'package:point_of_sale/src/controllers/pending_void_item_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/pending_void_item_model.dart';

class ShowPendingVoidItemScreen extends StatefulWidget {
  ShowPendingVoidItemScreen({this.ip, Key key}) : super(key: key);
  final String ip;
  @override
  State<ShowPendingVoidItemScreen> createState() =>
      _ShowPendingVoidItemScreenState();
}

GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
TextEditingController _dFController = TextEditingController();
TextEditingController _dTController = TextEditingController();
final TextEditingController reasonController = TextEditingController();
var _now = DateTime.now();
var _dF = DateFormat('yyyy-MM-dd');

class _ShowPendingVoidItemScreenState extends State<ShowPendingVoidItemScreen> {
  List<PendingVoidItemModel> list = [], copyList = [];

  bool checkItemStatus = false;
  void getPendingItem(String df, String dt) async {
    await PendingVoidItemController.getPandingVoidItem(widget.ip, df, dt)
        .then((value) {
      setState(() {
        list = value;
        checkItemStatus = true;
      });
      for (var temp in list) {
        print(temp.cashier);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    reasonController.text = '';
    _dFController = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    _dTController = TextEditingController(
        text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    getPendingItem(_dFController.text, _dTController.text);
    _dFController = TextEditingController(text: _dF.format(_now));
    _dTController = TextEditingController(text: _dF.format(_now));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pending void Item'),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     showSearch(
          //       context: context,
          //       delegate: SearchData(ip: widget.ip, list: list),
          //     );
          //   },
          //   child: Icon(
          //     Icons.search,
          //     color: Colors.white,
          //   ),
          // ),
          // SizedBox(
          //   width: 20,
          // ),
          TextButton(
              onPressed: () {
                reasonController.text = '';
                copyList = filterList(list);
                if (copyList.isEmpty || copyList == null) {
                  ShowMessage.alertCommingSoon(context, "Pending Void Item",
                      "Please select at least 1 void item");
                } else {
                  showMessageReason();
                }
              },
              child: Text(
                'Apply',
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
        ],
      ),
      body: ListView(children: [
        Form(
          key: _globalKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Flexible(
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        dateMask: 'dd-MM-yyyy',
                        controller: _dFController,
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
                        dateMask: 'dd-MM-yyyy',
                        controller: _dTController,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText:
                            AppLocalization.of(context).getTranValue('date_to'),
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
                          final loForm = _globalKey.currentState;
                          loForm.save();
                          list.clear();
                          getPendingItem(
                              _dFController.text, _dTController.text);
                          list.isNotEmpty
                              ? checkItemStatus = true
                              : checkItemStatus = false;
                        },
                        child: Text(
                          AppLocalization.of(context).getTranValue('filter'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          final loForm = _globalKey.currentState;
                          loForm.reset();
                          _dFController = TextEditingController(
                              text: DateFormat("yyyy-MM-dd")
                                  .format(DateTime.now()));
                          _dTController = TextEditingController(
                              text: DateFormat("yyyy-MM-dd")
                                  .format(DateTime.now()));
                          list.clear();
                          getPendingItem(
                              _dFController.text, _dTController.text);
                          list.isEmpty
                              ? checkItemStatus = true
                              : checkItemStatus = false;
                        },
                        child: Text(
                          AppLocalization.of(context).getTranValue('reset'),
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
        checkItemStatus
            ? list.isEmpty || list == null
                ? Center(
                    child: Text("No Item"),
                  )
                : Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return cartVoidItemCustom(list[index]);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(height: 0.0, color: Colors.white);
                        },
                      ),
                    ],
                  )
            : Center(
                child: CircularProgressIndicator(),
              )
      ]),
    );
  }

  Widget cartVoidItemCustom(PendingVoidItemModel pendingVoidItem) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete_forever,
            label: 'Delete',
            onPressed: ((context) async {
              var check = await CheckPrivilegeController()
                  .checkprivilege("P002", widget.ip);
              if (check == 'true') {
                await PendingVoidItemController()
                    .deletePendingitemCotroller(widget.ip, pendingVoidItem.id)
                    .whenComplete(() {
                  list.clear();
                  getPendingItem(
                      '${DateFormat('yyyy-MM-dd').parse(_dFController.text).toString().substring(0, 10)}',
                      '${DateFormat('yyyy-MM-dd').parse(_dTController.text).toString().substring(0, 10)}');
                  if (list.isEmpty) {
                    checkItemStatus = false;
                    list.clear();
                  }
                });
              } else {
                _hasNotPermission(
                  AppLocalization.of(context)
                      .getTranValue('user_no_permission'),
                );
              }
            }),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        child: ListTile(
          tileColor: pendingVoidItem.isVoided == true
              ? Color.fromARGB(255, 245, 228, 227)
              : null,
          textColor: pendingVoidItem.isVoided == true ? Colors.red : null,
          style: ListTileStyle.list,
          leading: Checkbox(
            onChanged: (value) {
              setState(() {
                pendingVoidItem.isVoided = value;
              });
            },
            value: pendingVoidItem.isVoided,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  pendingVoidItem.orderNo,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  pendingVoidItem.date,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  pendingVoidItem.cashier,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  pendingVoidItem.time,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          trailing: Column(
            children: [
              Text(pendingVoidItem.amount),
              Text(
                pendingVoidItem.table,
                style: TextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showMessageReason() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reason of void Item'),
          content: Form(
            key: _globalKey,
            child: TextFormField(
              controller: reasonController,
              maxLength: 300,
              maxLines: 3,
              onChanged: (stringValue) {
                //widget.order.reason = stringValue;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter text!";
                }
                return null;
              },
              decoration: InputDecoration(
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  border: OutlineInputBorder(),
                  hintText: 'please enter reason!'),
            ),
          ),
          actions: <Widget>[
            TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )),
            TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueAccent),
                ),
                onPressed: () async {
                  if (_globalKey.currentState.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                        'processing to void item',
                        style: TextStyle(fontSize: 17),
                      )),
                    );
                    await PendingVoidItemController()
                        .submitPendingitemController(
                            widget.ip, copyList, reasonController.text)
                        .whenComplete(() {
                      Navigator.pop(context);
                      list.clear();
                      getPendingItem(_dFController.text, _dTController.text);
                      if (list.isEmpty) {
                        checkItemStatus = false;
                        list.clear();
                      }
                    });
                  }
                },
                child: Text(
                  'Okay',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ))
          ],
        );
      },
    );
  }

  List<PendingVoidItemModel> filterList(List<PendingVoidItemModel> list) {
    List<PendingVoidItemModel> filterItem =
        list.where((element) => element.isVoided == true).toList();
    return filterItem;
  }

  Future<void> _hasNotPermission(String mess) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            '$mess',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ok'),
            )
          ],
        );
      },
    );
  }
}

class SearchData extends SearchDelegate {
  final List<PendingVoidItemModel> list;
  final String ip;
  SearchData({this.ip, this.list});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, 'true'),
    );
  }

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? list
        : list
            .where((e) =>
                e.cashier.toLowerCase().contains(query.toLowerCase()) ||
                e.date.toLowerCase().contains(query.toLowerCase()) ||
                e.orderNo.toLowerCase().contains(query.toLowerCase()) ||
                e.table.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return suggestions.isEmpty
        ? Center(
            child: Text(
              AppLocalization.of(context).getTranValue('no_result_found'),
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          )
        : Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return cartVoidItemCustom(list[index]);
                },
                separatorBuilder: (context, index) {
                  return Divider(height: 0.0, color: Colors.white);
                },
              ),
            ],
          );
  }

  Widget cartVoidItemCustom(PendingVoidItemModel pendingVoidItem) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [],
      ),
      child: Card(
        elevation: 0,
        child: ListTile(
          tileColor: pendingVoidItem.isVoided == true
              ? Color.fromARGB(255, 245, 228, 227)
              : null,
          textColor: pendingVoidItem.isVoided == true ? Colors.red : null,
          style: ListTileStyle.list,
          leading: Checkbox(
            onChanged: (value) {
              pendingVoidItem.isVoided = value;
            },
            value: pendingVoidItem.isVoided,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  pendingVoidItem.orderNo,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  pendingVoidItem.date,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  pendingVoidItem.cashier,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  pendingVoidItem.time,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          trailing: Column(
            children: [
              Text(pendingVoidItem.amount),
              Text(
                pendingVoidItem.table,
                style: TextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
