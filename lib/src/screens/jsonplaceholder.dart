import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/src/ManageLocalData/constant_ip.dart';
import 'package:point_of_sale/src/bloc/customer_bloc/customer_bloc.dart';
import 'package:point_of_sale/src/bloc/group_item1_bloc/group_item_bloc.dart';
import 'package:point_of_sale/src/bloc/order_bloc/order_bloc.dart';
import 'package:point_of_sale/src/controllers/change_table_controller.dart';
import 'package:point_of_sale/src/controllers/check_privilege_conntroller.dart';
import 'package:point_of_sale/src/controllers/fetchorder_controller.dart';
import 'package:point_of_sale/src/controllers/groupItem_controller.dart';
import 'package:point_of_sale/src/controllers/jsonplaceholder_controller.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/table_modal.dart';
import 'package:point_of_sale/src/screens/close_shift_screen.dart';
import 'package:point_of_sale/src/screens/customer_screen.dart';
import 'package:point_of_sale/src/screens/detail_sale_screen.dart';
import 'package:point_of_sale/src/screens/login_screen.dart';
import 'package:point_of_sale/src/screens/open_shift_screen.dart';
import 'package:point_of_sale/src/screens/return_receipt_screen.dart';
import 'package:point_of_sale/src/screens/show_pending_void_item_screen.dart';
import 'package:point_of_sale/src/screens/table_group_screen.dart';
import 'package:point_of_sale/src/widgets/drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cancel_receipt_screen.dart';
import 'list_order_saved.dart';
import 'package:point_of_sale/src/models/movie_model.dart';
import 'package:point_of_sale/src/controllers/movie_model_controller.dart';
import 'package:point_of_sale/src/models/jsonplaceholder.dart';
class jsonplaceholdertest extends StatefulWidget {
  //const jsonplaceholdertest({Key key}) : super(key: key);
  final String ip;
  final int userid;
  final UserModel placeholderdb;
  const jsonplaceholdertest({
    Key key,
    @required this.ip,
    @required this.userid,
    @required this.placeholderdb,
  }) : super(key: key);

  @override
  State<jsonplaceholdertest> createState() => _jsonplaceholdertestState();
}

class _jsonplaceholdertestState extends State<jsonplaceholdertest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(ip: ipAddress.ip,selected: 2,),
      appBar: AppBar(
        title: Text(ipAddress.ip),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getUserApi(),
              builder: (context , snapshot){

                if(snapshot.connectionState == ConnectionState.waiting){
                  return Text('Loading');
                }else {
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index){
                        return Card(
                          child: Column(
                            children: [
                              ReusbaleRow(title: 'name', value: data[index]['name'].toString(),),
                              ReusbaleRow(title: 'Username', value: data[index]['username'].toString(),),
                              ReusbaleRow(title: 'address', value: data[index]['address']['street'].toString(),),
                              ReusbaleRow(title: 'Lat', value: data[index]['address']['geo']['lat'].toString(),),
                              ReusbaleRow(title: 'Lat', value: data[index]['address']['geo']['lng'].toString(),),
                            ],
                          ),
                        );
                      });
                }

              },
            ),
          )
        ],
      ),
    );
  }

}
class ReusbaleRow extends StatelessWidget {
  String title , value ;
 ReusbaleRow({Key key ,  this.title ,  this.value}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value ),

        ],
      ),
    );
  }
}
