// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_pagewise/flutter_pagewise.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/bloc_order.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/event_order.dart';
// import 'package:point_of_sale/src/controllers/favorite_controller.dart';
// import 'package:point_of_sale/src/controllers/item_controller.dart';
// import 'package:point_of_sale/src/models/gorupItem_modal.dart';

// // ignore: must_be_immutable
// class FavoriteScreen extends StatefulWidget {
//   List<int> lsFavorite = [];
//   final String ip;

//   FavoriteScreen({Key key, this.lsFavorite, @required this.ip})
//       : super(key: key);

//   @override
//   _FavoriteScreenState createState() => _FavoriteScreenState();
// }

// class _FavoriteScreenState extends State<FavoriteScreen> {
//   var pageWiseController;
//   GroupItemModel group;
//   @override
//   void initState() {
//     super.initState();
//     pageWiseController = PagewiseLoadController(
//         pageSize: 10,
//         pageFuture: (index) => ItemController.eachItem(
//             group, widget.lsFavorite, 10, index + 1, widget.ip));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         //drawer: DrawerWidget(),
//         appBar: AppBar(
//           title: Text("Favorite"),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: Icon(Icons.clear, size: 25),
//               onPressed: () {
//                 clearFavorite();
//               },
//             )
//           ],
//         ),
//         body: RefreshIndicator(
//           onRefresh: () async {
//             pageWiseController.reset();
//           },
//           child: Container(
//             width: double.infinity,
//             height: double.infinity,
//             // child: PagewiseListView(
//             //   itemBuilder: (context, ItemMaster item, _) {
//             //     return BuildItem(itemMaster: item);
//             //   },
//             //   pageLoadController: pageWiseController,
//             // ),
//           ),
//         ),
//         bottomNavigationBar:
//             BlocBuilder<BlocOrder, StateOrder>(builder: (_, state) {
//           if (state.qty == null) {
//             return Container(
//               child: Text(""),
//             );
//           } else {
//             return state.allQty != 0
//                 ? Container(
//                     width: double.infinity,
//                     color: Color.fromRGBO(230, 230, 230, 1),
//                     child: Padding(
//                       padding: EdgeInsets.all(7),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               "${state.currency}  ${state.grandTotal.toStringAsFixed(2)}",
//                               style: TextStyle(
//                                 fontSize: 20.0,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             width: 200,
//                             child: MaterialButton(
//                               splashColor: Colors.grey,
//                               color: Colors.red,
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                       child: Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.lightGreen,
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20))),
//                                     height: 30,
//                                     width: 30,
//                                     child: Padding(
//                                       padding: EdgeInsets.only(top: 6),
//                                       child: Text(
//                                         "${state.allQty.floor()}",
//                                         style: TextStyle(
//                                           fontSize: 15.0,
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   )),
//                                   IconButton(
//                                     icon: Icon(
//                                       Icons.shopping_cart,
//                                       color: Colors.white,
//                                       size: 23,
//                                     ),
//                                     onPressed: () {},
//                                   ),
//                                   Expanded(
//                                     child: Text(
//                                       "View Cart",
//                                       style: TextStyle(
//                                         fontSize: 17.0,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               onPressed: () {
//                                 // Navigator.push(
//                                 //     context,
//                                 //     MaterialPageRoute(
//                                 //       builder: (context) => DetailSaleGroup(),
//                                 //     )).then((value) {});
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 : Container(child: Text(""));
//           }
//         }));
//   }

//   Future<void> clearFavorite() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Favorite'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(
//                   'Do you want to clear favorite or item ordered in list favorite ?',
//                   style: TextStyle(fontSize: 18, color: Colors.black),
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             MaterialButton(
//               color: Color.fromRGBO(75, 181, 69, 1),
//               shape: StadiumBorder(),
//               padding: EdgeInsets.only(left: 18, right: 18),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.check_box,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                   SizedBox(width: 5),
//                   Text(
//                     'Yes',
//                     style: TextStyle(fontSize: 15, color: Colors.white),
//                   ),
//                 ],
//               ),
//               onPressed: () {
//                 FavoriteController.removeAll('favorite');
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>
//                           FavoriteScreen(lsFavorite: [], ip: widget.ip)),
//                 );
//               },
//             ),
//             SizedBox(width: 5),
//             MaterialButton(
//               color: Colors.red,
//               shape: StadiumBorder(),
//               padding: EdgeInsets.only(left: 18, right: 18),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.cancel,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                   SizedBox(width: 5),
//                   Text(
//                     'No',
//                     style: TextStyle(fontSize: 15, color: Colors.white),
//                   ),
//                 ],
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
