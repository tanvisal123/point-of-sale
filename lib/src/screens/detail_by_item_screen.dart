// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/bloc_order.dart';
// import 'package:point_of_sale/src/bloc/bloc_order/event_order.dart';
// import 'package:point_of_sale/src/controllers/sale_controller.dart';
// import 'package:point_of_sale/src/helpers/app_localization.dart';
// import 'package:point_of_sale/src/models/order_detail_modal.dart';
// import 'package:point_of_sale/src/screens/detail_sale_group_screen.dart';

// class DetailByItem extends StatefulWidget {
//   final OrderDetail orderDetail;
//   final String ip;
//   DetailByItem({this.orderDetail, @required this.ip});
//   @override
//   _DetailByItemState createState() => _DetailByItemState();
// }

// class _DetailByItemState extends State<DetailByItem> {
//   double _ordered = 0;
//   String _description = '';
//   double _disValue = 0;
//   int _dropDownIndex = 0;
//   //bool _checkDis = false;

//   @override
//   void initState() {
//     super.initState();
//     setState(() => _ordered = widget.orderDetail.qty);
//     if (widget.orderDetail.typeDis == 'Cash') {
//       setState(() {
//         _dropDownIndex = 0;
//         _disValue = widget.orderDetail.discountRate;
//       });
//     } else {
//       setState(() {
//         _dropDownIndex = 1;
//         _disValue = widget.orderDetail.discountRate;
//       });
//     }
//     // PermissionController.permissionDiscountItem().then((value) {
//     //   if (mounted) {
//     //     if (value == "true") {
//     //       setState(() => _checkDis = true);
//     //     } else {
//     //       setState(() => _checkDis = false);
//     //     }
//     //   }
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('Image = ${widget.orderDetail.image}');
//     return Scaffold(
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: <Widget>[
//           SliverAppBar(
//             leading: IconButton(
//               onPressed: () => Navigator.pop(context),
//               icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
//             ),
//             stretch: true,
//             onStretchTrigger: () {
//               return;
//             },
//             expandedHeight: 200.0,
//             flexibleSpace: FlexibleSpaceBar(
//               stretchModes: <StretchMode>[
//                 StretchMode.zoomBackground,
//                 StretchMode.blurBackground,
//                 StretchMode.fadeTitle,
//               ],
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   widget.orderDetail.image != null
//                       ? CachedNetworkImage(
//                           imageUrl:
//                               "${widget.ip + "/Images/items/" + widget.orderDetail.image}",
//                           placeholder: (context, url) => Center(
//                             child: SizedBox(
//                               width: 40.0,
//                               height: 40.0,
//                               child: new CircularProgressIndicator(
//                                 backgroundColor: Colors.white,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                     Theme.of(context).primaryColor),
//                               ),
//                             ),
//                           ),
//                           errorWidget: (context, url, error) => Image.asset(
//                               'assets/images/no_image.jpg',
//                               fit: BoxFit.cover),
//                           fit: BoxFit.cover,
//                           height: double.infinity,
//                           width: double.infinity,
//                         )
//                       : Image.asset(
//                           "assets/images/no_image.jpg",
//                           width: double.infinity,
//                           height: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                 ],
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate([
//               ListTile(
//                 title: Text(
//                   "${widget.orderDetail.khmerName}",
//                   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
//                 ),
//                 subtitle: Text(
//                   "Item",
//                   style: TextStyle(fontSize: 15.0, color: Colors.grey),
//                 ),
//                 trailing: Text(
//                   "${widget.orderDetail.currency}  ${widget.orderDetail.unitPrice.toStringAsFixed(2)}",
//                   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 width: double.infinity,
//                 height: 70,
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 55,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(
//                           color: Colors.grey,
//                         ),
//                       ),
//                       child: MaterialButton(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(3.0),
//                         ),
//                         child: Icon(Icons.remove),
//                         onPressed: _ordered == 1
//                             ? null
//                             : () => setState(() => _ordered -= 1),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: Container(
//                         height: 50,
//                         child: TextFormField(
//                           style: TextStyle(fontSize: 20),
//                           key: Key(_ordered.toString()),
//                           textAlign: TextAlign.center,
//                           keyboardType: TextInputType.number,
//                           initialValue: _ordered.toString(),
//                           onChanged: (value) {
//                             _ordered = double.parse(value);
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Container(
//                       width: 55,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.grey),
//                       ),
//                       child: MaterialButton(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(3.0),
//                         ),
//                         child: Icon(Icons.add),
//                         onPressed: () => setState(() => _ordered += 1),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(10),
//                 width: double.infinity,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ListTile(
//                       title: Text(
//                         AppLocalization.of(context).getTranValue('discount'),
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       subtitle: Text(
//                         AppLocalization.of(context).getTranValue('dis_by_item'),
//                         style: TextStyle(fontSize: 15.0, color: Colors.grey),
//                       ),
//                       trailing: DropdownButton(
//                         value: _dropDownIndex,
//                         dropdownColor: Colors.white,
//                         onChanged: (int index) {
//                           setState(() => _dropDownIndex = index);
//                         },
//                         items: [
//                           DropdownMenuItem(
//                             value: 0,
//                             child: Text('Cash'),
//                           ),
//                           DropdownMenuItem(
//                             value: 1,
//                             child: Text('Percent'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     TextFormField(
//                       inputFormatters: _dropDownIndex == 1
//                           ? [
//                               FilteringTextInputFormatter.allow(
//                                 RegExp('^([1-9][0-9]?|100)\$'),
//                               ),
//                               LengthLimitingTextInputFormatter(3),
//                             ]
//                           : null,
//                       //readOnly: _checkDis ? true : false,
//                       style: TextStyle(fontSize: 18.0),
//                       key: Key(_disValue.toString()),
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                       ),
//                       initialValue: _disValue.toString(),
//                       onChanged: (value) {
//                         if (value.isEmpty)
//                           _disValue = 0;
//                         else
//                           _disValue = double.parse(value);
//                       },
//                     ),
//                     ListTile(
//                       title: Text(
//                         AppLocalization.of(context).getTranValue('description'),
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       subtitle: Text(
//                         "(Express your interest in the item)",
//                         style: TextStyle(fontSize: 15.0, color: Colors.grey),
//                       ),
//                     ),
//                     TextFormField(
//                       style: TextStyle(fontSize: 18.0),
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red)),
//                       ),
//                       onChanged: (value) {
//                         _description = value.toString();
//                       },
//                       maxLength: 1000,
//                       maxLines: 3,
//                     ),
//                   ],
//                 ),
//               )
//             ]),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: 60.0,
//         child: MaterialButton(
//           splashColor: Colors.white,
//           color: Theme.of(context).primaryColor,
//           onPressed: () {
//             setState(() {
//               widget.orderDetail.qty = _ordered;
//               widget.orderDetail.printQty = _ordered;
//               widget.orderDetail.comment = _description;
//               widget.orderDetail.discountRate = _disValue;
//               if (_dropDownIndex == 0) {
//                 widget.orderDetail.typeDis = 'Cash';
//               } else {
//                 widget.orderDetail.typeDis = 'Percent';
//               }
//               SaleController().updateOrderDetail(widget.orderDetail);
//               BlocProvider.of<BlocOrder>(context)
//                   .add(EventOrder.add(key: widget.orderDetail.lineId));
//             });
//             Navigator.pop(context);
//             Navigator.pop(context);
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(builder: (_) => DetailSaleGroup(ip: widget.ip)),
//             // );
//           },
//           child: Text(
//             AppLocalization.of(context).getTranValue('update'),
//             style: TextStyle(
//               fontSize: 19.0,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
