import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/bloc/save_order_bloc/save_order_bloc.dart';
import 'package:point_of_sale/src/controllers/fetchorder_controller.dart';
import 'package:point_of_sale/src/controllers/post_order_to_server.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/screens/detail_sale_screen.dart';
import 'package:point_of_sale/src/screens/show_item_saved.dart';

class ListOrderSaved extends StatefulWidget {
  final String ip;
  final int orderId;
  final FetchOrderModel fetchOrderModel;
  final int tableId;
  const ListOrderSaved({
    Key key,
    @required this.ip,
    @required this.orderId,
    @required this.fetchOrderModel,
    @required this.tableId,
  }) : super(key: key);

  @override
  State<ListOrderSaved> createState() => _ListOrderSavedState();
}

class _ListOrderSavedState extends State<ListOrderSaved> {
  FetchOrderModel fetchOrderModel;
  List<Order> orders = [];
  List<Order> orderByDate;
  bool status = false;
  String dateIn;
  var _now = DateTime.now();
  var _dF = DateFormat('yyyy-MM-dd');
  TextEditingController _dFController;
  TextEditingController _dTController;

  getOrderSaved(
      TextEditingController dateFrom, TextEditingController dateTo) async {
    await FetchOrderController()
        .getFetchOrder(widget.ip, widget.tableId, 0, 0, true)
        .then(
      (value) {
        setState(
          () {
            fetchOrderModel = value;
            orders = fetchOrderModel.orders;
            status = true;
            orderByDate = orders
                .where((e) =>
                    DateTime.parse(dateFrom.text).compareTo(e.dateIn) <= 0 &&
                    e.dateIn.compareTo(DateTime.parse(dateTo.text)) <= 0)
                .toList();
            status = true;
          },
        );
      },
    );
    for (var temp in orderByDate) {
      print(" order no : ${temp.orderNo} date in :${_dF.format(temp.dateIn)}");
    }
  }

  deleteSaveOrder(int orderId, String ip) async {
    await PostOrder().deteleSaveOrder(orderId, ip);
  }

  @override
  void initState() {
    _dFController = TextEditingController(text: _dF.format(_now));
    _dTController = TextEditingController(text: _dF.format(_now));
    super.initState();
    print(_dFController.text);
    print(_dTController.text);
    getOrderSaved(_dFController, _dTController);
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SaveOrderBlocBloc>(context)
        .add(GetSaveOrderEvent(ip: widget.ip, orderId: widget.orderId));

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalization.of(context).getTranValue('orders_saved')),
          actions: [],
        ),
        body: Column(children: [
          SizedBox(height: 15),
          Container(
            height: 80.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: DateTimePicker(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontSize: 20.0),
                        labelText: AppLocalization.of(context)
                            .getTranValue('date_from'),
                      ),
                      type: DateTimePickerType.date,
                      dateMask: 'dd-MMMM-yyyy',
                      controller: _dFController,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Flexible(
                    child: DateTimePicker(
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 20.0),
                        labelText:
                            AppLocalization.of(context).getTranValue('date_to'),
                        border: OutlineInputBorder(),
                      ),
                      type: DateTimePickerType.date,
                      dateMask: 'dd-MMMM-yyyy',
                      controller: _dTController,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        print(_dFController.text);
                        getOrderSaved(_dFController, _dTController);
                        _buildOrder(orderByDate);
                      });
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
                      setState(() {
                        _dFController =
                            TextEditingController(text: _dF.format(_now));
                        _dTController =
                            TextEditingController(text: _dF.format(_now));
                      });
                      getOrderSaved(_dFController, _dTController);
                      _buildOrder(orderByDate);
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
          status
              ? Expanded(child: _buildOrder(orderByDate))
              : Center(child: CircularProgressIndicator()),
        ]));
  }

  _buildOrder(List<Order> order) {
    return order.isEmpty
        ? Center(
            child: Text("No Order Saved"),
          )
        : ListView.separated(
            itemBuilder: (context, index) {
              var data = order[index];
              return ListTile(
                  onTap: () async {
                    fetchOrderModel = await FetchOrderController()
                        .getFetchOrder(
                            widget.ip, widget.tableId, data.orderId, 0, true);
                    print("order id : ${data.orderId}");
                    await Future.delayed(Duration(seconds: 1));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailSaleScreen(
                                  fetchOrderModel: fetchOrderModel,
                                  ip: widget.ip,
                                  orderId: widget.orderId,
                                  tableId: widget.tableId,
                                )));
                  },
                  title: Text(data.orderNo +
                      " " +
                      "(${DateFormat("dd-MM-yyyy").format(data.dateIn)})"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await deleteSaveOrder(data.orderId, widget.ip);
                      setState(() {
                        _dFController =
                            TextEditingController(text: _dF.format(_now));
                        _dTController =
                            TextEditingController(text: _dF.format(_now));
                      });
                      getOrderSaved(_dFController, _dFController);
                    },
                  ));
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: order.length);
  }
}
