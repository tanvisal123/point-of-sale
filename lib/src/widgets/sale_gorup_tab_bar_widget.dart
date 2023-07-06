import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/src/controllers/group2_controller.dart';
import 'package:point_of_sale/src/controllers/group3_controller.dart';
import 'package:point_of_sale/src/controllers/item_controller.dart';
import 'package:point_of_sale/src/models/gorupItem_modal.dart';
import 'package:point_of_sale/src/models/item_modal.dart';
import 'package:point_of_sale/src/models/post_server_modal.dart';
import 'package:point_of_sale/src/screens/sale_group_screen.dart';
import 'package:point_of_sale/src/screens/table_group_screen.dart';
import 'build_item_widget.dart';

class SaleGroupTabBar extends StatefulWidget {
  final String ip;
  final tableId;
  final String type;
  final bool checkInternet;
  final GroupItemModel groupItem;
  final List<PostModel> postList;

  SaleGroupTabBar({
    this.groupItem,
    this.type,
    this.checkInternet,
    this.tableId,
    this.postList,
    @required this.ip,
  });

  @override
  _SaleGroupTabBarState createState() =>
      _SaleGroupTabBarState(startGroup: this.groupItem);
}

class _SaleGroupTabBarState extends State<SaleGroupTabBar> {
  final GroupItemModel startGroup;
  _SaleGroupTabBarState({this.startGroup});

  List<int> _keys;
  var _pageWiseController;
  List<GroupItemModel> _nexGroup = [];
  var _systemType;
  _getSystemType() async {
    _systemType = await FlutterSession().get('systemType');
  }

  @override
  void initState() {
    super.initState();
    _getSystemType();
    _getGroupItem();
    _pageWiseController = PagewiseLoadController(
      pageSize: 10,
      pageFuture: (index) {
        return ItemController.eachItem(
            startGroup, _keys, 10, index + 1, widget.ip);
      },
    );
    // if (widget.checkInternet == true) {
    //   _pageWiseController = PagewiseLoadController(
    //     pageSize: 10,
    //     pageFuture: (index) {
    //       return ItemController.eachItem(
    //           startGroup, _keys, 10, index + 1, widget.ip);
    //     },
    //   );
    // } else {
    //   _pageWiseController = PagewiseLoadController(
    //     pageSize: 10,
    //     pageFuture: (index) {
    //       return ItemController()
    //           .getItems(startGroup, 10, index + 1, widget.ip);
    //     },
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        backgroundColor: Theme.of(context).primaryColor,
        edgeOffset: 3.0,
        displacement: 5.0,
        color: Colors.white,
        onRefresh: () async {
          await Future.delayed(Duration(microseconds: 100));
          if (_systemType == 'KRMS') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TableScreen(ip: widget.ip),
              ),
            );
          } else if (_systemType == 'KBMS') {
            //BlocProvider.of<BlocOrder>(context).add(EventOrder.delete());
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => SaleGroupScreen(
            //       type: 'G1',
            //       postList: [],
            //       ip: widget.ip,
            //     ),
            //   ),
            //   (route) => true,
            // );
          } else {
            Navigator.pop(context);
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150.0,
                        child: Container(
                          color: Colors.grey,
                          child: widget.groupItem.image != null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      '${widget.ip + '/Images/items/' + widget.groupItem.image}',
                                  placeholder: (context, url) => Center(
                                    child: SizedBox(
                                      width: 40.0,
                                      height: 40.0,
                                      child: new CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset('assets/images/no_image.jpg',
                                  fit: BoxFit.cover),
                        ),
                      ),
                      _nexGroup.length != 0
                          ? Container(
                              height: 150.0,
                              margin: EdgeInsets.only(top: 8.0),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _nexGroup.map((e) {
                                  return _buildNextGroup(e, widget.ip);
                                }).toList(),
                              ),
                            )
                          : Container(height: 0.0, width: 0.0),
                    ],
                  );
                }, childCount: 1),
              ),
              // PagewiseSliverList(
              //   itemBuilder: (context, ItemMaster item, index) {
              //     return BuildItem(
              //       itemMaster: item,
              //       tableId: widget.tableId,
              //       ip: widget.ip,
              //     );
              //   },
              //   pageLoadController: _pageWiseController,
              // ),
            ],
          ),
        ));
  }

  Widget _buildNextGroup(GroupItemModel e, String ip) {
    return InkWell(
      onTap: () {
        if (widget.type == 'G1') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => SaleGroupScreen(
          //       ip: ip,
          //       type: 'G2',
          //       postList: widget.postList,
          //       tableId: widget.tableId,
          //       g1Id: widget.groupItem.g1Id,
          //       g2Id: widget.groupItem.g2Id,
          //     ),
          //   ),
          // );
        } else if (widget.type == 'G2') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => SaleGroupScreen(
          //       ip: ip,
          //       type: 'G3',
          //       postList: widget.postList,
          //       tableId: widget.tableId,
          //       g1Id: widget.groupItem.g1Id,
          //       g2Id: widget.groupItem.g2Id,
          //     ),
          //   ),
          // );
        }
      },
      child: widget.ip != null
          ? Container(
              width: 150.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              margin: EdgeInsets.only(right: 8),
              child: e.image != null
                  ? Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: '${widget.ip + '/Images/items/' + e.image}',
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Center(
                            child: SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 50,
                            width: 150,
                            color: Colors.black.withOpacity(0.3),
                            alignment: Alignment.center,
                            child: Text(
                              '${e.name}',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        Image.asset(
                          'assets/images/no_image.jpg',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 50.0,
                            width: 150.0,
                            color: Colors.grey.withOpacity(0.3),
                            alignment: Alignment.center,
                            child: Text(
                              '${e.name}',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _getGroupItem() async {
    bool _result = await DataConnectionChecker().hasConnection;
    if (widget.type == 'G1') {
      if (_result) {
        Group2Controller.eachGroup2(startGroup.g1Id, widget.ip).then((value) {
          if (value.length != 0) {
            if (mounted) setState(() => _nexGroup = value);
          }
        });
      } else {
        Group2Controller().getGroup2(startGroup.g1Id).then((value) {
          if (mounted) setState(() => _nexGroup = value);
        });
      }
    } else if (widget.type == 'G2') {
      if (_result) {
        Group3Controller.eachGroup3(startGroup.g1Id, startGroup.g2Id, widget.ip)
            .then(
          (value) {
            if (value.length != 0) {
              if (mounted) setState(() => _nexGroup = value);
            }
          },
        );
      } else {
        Group3Controller().getGroup3(startGroup.g1Id, startGroup.g2Id).then(
          (value) {
            if (mounted) setState(() => _nexGroup = value);
          },
        );
      }
    }
  }
}
