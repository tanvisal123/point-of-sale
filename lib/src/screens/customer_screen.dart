import 'dart:async';

//import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/bloc/customer_bloc/customer_bloc.dart';

import 'package:point_of_sale/src/controllers/customer_controller.dart';
import 'package:point_of_sale/src/controllers/fetchorder_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/models/customer_model.dart';

import '../models/fetch_oreder_model.dart';

class CustomerScreen extends StatefulWidget {
  final String ip;
  final int orderId;
  final int tableId;
  final bool defaultOrder;
  final FetchOrderModel fetchOrder;

  CustomerScreen({
    Key key,
    @required this.ip,
    @required this.orderId,
    @required this.tableId,
    @required this.defaultOrder,
    @required this.fetchOrder,
  }) : super(key: key);
  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> _customerList = [];
  StreamController<List<Customer>> _customerSteream =
      StreamController<List<Customer>>();

  void getCustomer() async {
    await CustomerController.getCustomer(widget.ip).then((value) {
      setState(() {
        _customerList.addAll(value);
      });
      _customerList.forEach((element) {
        print("customer name: ${element.name}");
      });
    });
  }

  void _onSearchChanged(String value) {
    List<Customer> foundContacts = _customerList
        .where((Customer customerModel) =>
            customerModel.name.toLowerCase().indexOf(value.toLowerCase()) > -1)
        .toList();
    this._customerSteream.add(foundContacts);
  }

  void _onRestoreAllData() {
    this._customerSteream.add(this._customerList);
  }

  void callBack(Customer customer) {
    setState(() {
      widget.fetchOrder.order.customer = customer;
    });
  }

  @override
  void initState() {
    super.initState();
    getCustomer();
    _customerSteream.add(_customerList);
    BlocProvider.of<CustomerBloc>(context).add(GetCustomerEvent(widget.ip));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalization.of(context).getTranValue('customers')),
        ),
        // appBar:
        //  AppBarTextField(
        //   // decoration: InputDecoration(
        //   //   hintText: AppLocalization.of(context).getTranValue('search'),
        //   //   border: InputBorder.none,
        //   //   contentPadding: EdgeInsets.only(bottom: 0.1),
        //   // ),
        //   // autocorrect: false,
        //   // autofocus: false,
        //   // searchContainerColor: Colors.white,
        //   centerTitle: true,
        //   title: Text(AppLocalization.of(context).getTranValue('customers')),
        //   onBackPressed: _onRestoreAllData,
        //   onClearPressed: _onRestoreAllData,
        //   onChanged: _onSearchChanged,
        // ),
        body: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is ShowCustomerState) {
              return ListView.builder(
                itemCount: state.listCustomer.length,
                itemBuilder: ((context, index) {
                  var data = state.listCustomer[index];
                  return Card(
                    child: ListTile(
                      onTap: (() async {
                        setState(() {
                          widget.fetchOrder.order.customerId = data.id;
                          widget.fetchOrder.order.customer = data;
                        });
                        BlocProvider.of<CustomerBloc>(context).add(
                            AddCustomerToOrderEvent(
                                ip: widget.ip,
                                orderId: widget.orderId,
                                tableId: widget.tableId,
                                defualtOrder: widget.defaultOrder,
                                customerId: data.id,
                                customer: data));
                        Navigator.pop(context);
                      }),
                      title: Text(data.name),
                      subtitle: Text(data.email ?? ''),
                    ),
                  );
                }),
              );
            } else if (state is CustomerLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ErrorState) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  @override
  void dispose() {
    _customerSteream.close();
    super.dispose();
  }
}
// StreamBuilder<List<Customer>>(
//           stream: _customerSteream.stream,
//           builder: (context, snapshot) {
//             List<Customer> customer = snapshot.hasData ? snapshot.data : [];
//             return ListView.builder(
//               itemCount: customer.length,
//               itemBuilder: ((context, index) {
//                 var data = customer[index];
//                 return Card(
//                   child: ListTile(
//                     onTap: (() async {
//                       // setState(() {
//                       //   widget.fetchOrder.order.customerId = data.id;
//                       //   widget.fetchOrder.order.customer = data;
//                       // });
//                       BlocProvider.of<CustomerBloc>(context).add(
//                           AddCustomerToOrderEvent(
//                               ip: widget.ip,
//                               orderId: widget.orderId,
//                               tableId: widget.tableId,
//                               defualtOrder: widget.defaultOrder,
//                               customerId: data.id,
//                               customer: data));
//                       Navigator.pop(context);
//                     }),
//                     title: Text(data.name),
//                     subtitle: Text(data.email ?? ''),
//                   ),
//                 );
//               }),
//             );
//           }),