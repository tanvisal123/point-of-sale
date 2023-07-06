import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:point_of_sale/src/ManageLocalData/access_ip.dart';
import 'package:point_of_sale/src/bloc/group_table_bloc/grouptable_bloc.dart';
import 'package:point_of_sale/src/controllers/fetchorder_controller.dart';
import 'package:point_of_sale/src/controllers/service_table_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/service_table_modal.dart';
import 'package:point_of_sale/src/models/table_modal.dart';
import 'package:point_of_sale/src/screens/home_screen.dart';
import 'package:point_of_sale/src/screens/login_screen.dart';
import 'package:point_of_sale/src/screens/sale_screen.dart';
import 'package:point_of_sale/src/widgets/drawer_widget.dart';

import '../bloc/customer_bloc/customer_bloc.dart';
import '../helpers/show_message.dart';
import 'dart:developer' as dev;

class TableScreen extends StatefulWidget {
  final String ip;
  const TableScreen({Key key, @required this.ip}) : super(key: key);
  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  AccessIPController ipController = Get.put(AccessIPController());
  List<TableModel> listTable;
  List<TableModel> allTable;
  ServiceTableModel serviceTableModel;
  bool status = false;
  void getTable(int groupId) async {
    await TableController.getTable(groupId, widget.ip).then((value) {
      setState(() {
        listTable = value;
        status = true;
      });
      // dev.log('Tables:${listTable.toString()}');
    });
  }

  void getAllTable(int groupId) async {
    await TableController.getTable(groupId, widget.ip).then((value) {
      setState(() {
        allTable = value;
      });
      // dev.log('AllTables:${allTable.toString()}');
    });
  }

  @override
  void initState() {
    dev.log('IPGroupScreen:${widget.ip}');
    getTable(0);
    getAllTable(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrouptableBloc, GrouptableState>(
      builder: (context, state) {
        return Scaffold(
          drawer: DrawerWidget(selected: 2, ip: widget.ip),
          appBar: AppBar(
            centerTitle: true,
            title:
                Text(AppLocalization.of(context).getTranValue("table_group")),
            actions: [
              IconButton(
                icon: Icon(Icons.search, size: 28.0),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchTable(ip: widget.ip, listTable: allTable),
                  );
                },
              ),
            ],
          ),
          body: (state is GrouptableInitial)
              ? _buildLoading()
              : (state is GrouptableLoading)
                  ? _buildLoading
                  : (state is GrouptableLoaded)
                      ? Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.orange,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          getTable(0);
                                        },
                                        child: Text(
                                          "All",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Row(
                                        children: state.serviceTable.groupTables
                                            .map((e) {
                                      return TextButton(
                                        onPressed: () {
                                          getTable(e.id);
                                        },
                                        child: Text(
                                          e.name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }).toList()),
                                  ],
                                ),
                              ),
                            ),
                            // SingleChildScrollView(
                            //   scrollDirection: Axis.horizontal,
                            //   child: Container(
                            //     height: 60,
                            //     width: 500,
                            //     color: Colors.grey[400],
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         TextButton(
                            //           onPressed: () {
                            //             getTable(0);
                            //           },
                            //           child: Text(
                            //             "All",
                            //             style: TextStyle(
                            //                 fontSize: 18,
                            //                 fontWeight: FontWeight.bold),
                            //           ),
                            //         ),
                            //         Expanded(
                            //           child: Row(
                            //               children: state
                            //                   .serviceTable.groupTables
                            //                   .map((e) {
                            //             return TextButton(
                            //               onPressed: () {
                            //                 getTable(e.id);
                            //               },
                            //               child: Text(
                            //                 e.name,
                            //                 style: TextStyle(
                            //                     fontSize: 18,
                            //                     fontWeight: FontWeight.bold),
                            //               ),
                            //             );
                            //           }).toList()),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Expanded(child: _buildBody(listTable)),
                          ],
                        )
                      : Center(
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        height: 100,
                                        width: 100,
                                        child: Center(
                                          child: FlutterSplashScreen.gif(
                                            backgroundColor: Colors.white,
                                            gifPath:
                                                'assets/gif/129394-tri-cube-loader-2.gif',
                                            gifWidth: 100,
                                            gifHeight: 100,
                                            defaultNextScreen:
                                                HomeScreen(ip: widget.ip),
                                            duration: const Duration(
                                                milliseconds: 3515),
                                            onInit: () async {
                                              context
                                                  .read<GrouptableBloc>()
                                                  .add(GroupTableEvent());
                                              debugPrint("onInit 1");
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 2000));
                                            },
                                            onEnd: () async {
                                              debugPrint("onEnd 1");
                                              debugPrint("onEnd 2");
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.refresh,
                                size: 30,
                              )),
                        ),
        );
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: TextStyle(fontSize: 20.0)),
          IconButton(
              onPressed: () {
                ShowMessage.showLoading(context,
                    AppLocalization.of(context).getTranValue("loading"));
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              icon: Icon(Icons.refresh)),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBody(List<TableModel> listTable) {
    return status
        ? GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            children: listTable.map((e) {
              return Container(
                child: InkWell(
                  onTap: () async {
                    FetchOrderModel fetchOrderModel =
                        await FetchOrderController()
                            .getFetchOrder(widget.ip, 0, 0, 0, true);
                    BlocProvider.of<CustomerBloc>(context)
                        .add(DeleteCustomerEvent());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SaleScreen(
                                ip: widget.ip,
                                level: 1,
                                tableId: e.id,
                                orderId: fetchOrderModel.order.orderId,
                                defaultOrder: true,
                              )),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(0.0),
                    shadowColor: Colors.grey,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: e.image != null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        '${widget.ip + '//Images/table/' + e.image}',
                                    placeholder: (context, url) => Center(
                                      child: SizedBox(
                                        width: 40.0,
                                        height: 40.0,
                                        child: CupertinoActivityIndicator(
                                          radius: 13.0,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/no_image.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/no_image.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 40.0,
                          color: e.status == 'A'
                              ? Colors.grey[300]
                              : e.status == 'B'
                                  ? Colors.red
                                  : e.status == 'P'
                                      ? Color.fromRGBO(76, 175, 80, 1)
                                      : Colors.grey[300],
                          child: Center(
                            child: Text(
                              '${e.name}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

class SearchTable extends SearchDelegate<String> {
  final String ip;
  final List<TableModel> listTable;
  SearchTable({@required this.ip, @required this.listTable});

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
  Widget buildResults(BuildContext context) {
    final tableSuggestions = query.isEmpty
        ? listTable
        : listTable
            .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return tableSuggestions.isEmpty
        ? Center(
            child: Text(
              AppLocalization.of(context).getTranValue('no_result_found'),
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          )
        : ListView(
            children: [
              SizedBox(height: 13.0),
              ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: tableSuggestions.map((e) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          FetchOrderModel fetchOrderModel =
                              await FetchOrderController()
                                  .getFetchOrder(ip, 0, 0, 0, true);
                          BlocProvider.of<CustomerBloc>(context)
                              .add(DeleteCustomerEvent());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SaleScreen(
                                        ip: ip,
                                        level: 1,
                                        tableId: e.id,
                                        orderId: fetchOrderModel.order.orderId,
                                        defaultOrder: true,
                                      )));
                        },
                        leading: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(5.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: e.image != null
                                  ? NetworkImage(
                                      '${ip + '//Images/table/' + e.image}',
                                    )
                                  : AssetImage('assets/images/no_image.jpg'),
                            ),
                          ),
                        ),
                        title: Text(
                          '${e.name}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey, indent: 90.0),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final tableSuggestions = query.isEmpty
        ? listTable
        : listTable
            .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return tableSuggestions.isEmpty
        ? Center(
            child: Text(
              AppLocalization.of(context).getTranValue('no_result_found'),
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          )
        : ListView(
            children: [
              SizedBox(height: 13.0),
              ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: tableSuggestions.map((e) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          FetchOrderModel fetchOrderModel =
                              await FetchOrderController()
                                  .getFetchOrder(ip, 0, 0, 0, true);
                          BlocProvider.of<CustomerBloc>(context)
                              .add(DeleteCustomerEvent());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SaleScreen(
                                        ip: ip,
                                        level: 1,
                                        tableId: e.id,
                                        orderId: fetchOrderModel.order.orderId,
                                        defaultOrder: true,
                                      )));
                        },
                        leading: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(5.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: e.image != null
                                  ? NetworkImage(
                                      '${ip + '//Images/table/' + e.image}',
                                    )
                                  : AssetImage('assets/images/no_image.jpg'),
                            ),
                          ),
                        ),
                        title: Text(
                          '${e.name}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey, indent: 90.0),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
  }
}
