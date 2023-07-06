import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/controllers/payment_mean_controller.dart';
import 'package:point_of_sale/src/controllers/sale_controller.dart';
import 'package:point_of_sale/src/controllers/setting_controller.dart';
import 'package:point_of_sale/src/controllers/tax_controller.dart';
import 'package:point_of_sale/src/models/item_modal.dart';
import 'package:point_of_sale/src/models/payment_means_modal.dart';
import 'package:point_of_sale/src/models/setting_modal.dart';
import 'package:point_of_sale/src/models/tax_modal.dart';

class BuildItem extends StatefulWidget {
  final String ip;
  final int tableId;
  final ItemMaster itemMaster;
  BuildItem({this.itemMaster, this.tableId, @required this.ip});
  @override
  _BuildItemState createState() => _BuildItemState();
}

class _BuildItemState extends State<BuildItem> {
  //bool isFavorite = false;
  //double _count = 0.0;
  List<TaxModel> _taxList = [];
  List<SettingModel> _settingList = [];
  List<PaymentMeanModel> _paymentList = [];

  Future<void> _getAll() async {
    await PaymentMeanController().selectPaymentMean().then((value) {
      setState(() {
        _paymentList.addAll(value);
      });
    });
    // await SettingController().selectSetting().then((value) {
    //   setState(() {
    //     _settingList.addAll(value);
    //   });
    // });
    // await TaxController().selectTax().then((value) {
    //   setState(() {
    //     _taxList.addAll(value);
    //   });
    // });
  }

  // void _getOrdered() {
  //   BlocProvider.of<BlocOrder>(context).add(
  //     EventOrder.add(key: widget.itemMaster.key, itemMaster: widget.itemMaster),
  //   );
  // }

  Future<void> _getPayment(String ip) async {
    await PaymentMeanController.getPaymenyMean(ip).then((value) {
      if (mounted) setState(() => _paymentList = value);
      _paymentList.forEach((element) {
        print('PaymentList = ' + element.type);
      });
    });
  }

  Future<void> _getSetting(String ip) async {
    await SettingController.getSetting(ip).then((value) {
      if (mounted) setState(() => _settingList = value);
      _settingList.forEach((element) {
        print('SettingList = ' + element.receiptTemplate);
        print('Rate In = ${element.rateIn}');
      });
    });
  }

  Future<void> _getTax(String ip) async {
    await TaxController.getTax(ip).then((value) {
      if (mounted) setState(() => _taxList = value);
      _taxList.forEach((element) {
        print('TaxList = ' + element.name);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // _getOrdered();
    // _getAll();
    _getPayment(widget.ip);
    _getSetting(widget.ip);
    _getTax(widget.ip);

    // FavoriteController.isFavorite(widget.item.key).then((value) {
    //   if (value) {
    //     if (mounted) setState(() => isFavorite = true);
    //   } else {
    //     if (mounted) setState(() => isFavorite = false);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    var _f = NumberFormat('#,##0.00');
    return InkWell(
      onTap: () async {
        await SaleController().buildOrder(
          context,
          widget.itemMaster,
          widget.tableId,
          widget.ip,
          _paymentList,
          // _settingList,
          _taxList,
        );
        // BlocProvider.of<BlocOrder>(context).add(
        //   EventOrder.add(
        //     key: widget.itemMaster.key,
        //     itemMaster: widget.itemMaster,
        //   ),
        // );
        print('Order-Started');
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 0.3, right: 0.3),
        child: Stack(children: [
          Container(
            height: 150.0,
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.3,
                color: Colors.black.withOpacity(0.3),
              ),
              color: Colors.grey[100],
            ),
            child: Row(
              children: <Widget>[
                Card(
                  elevation: 0.0,
                  margin: EdgeInsets.all(0.0),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Container(
                    width: 150.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: widget.itemMaster.image != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  '${widget.ip + '/Images/items/' + widget.itemMaster.image}',
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  width: 30.0,
                                  height: 30.0,
                                  child: CupertinoActivityIndicator(
                                    radius: 13.0,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/no_image.jpg',
                                fit: BoxFit.cover,
                              ),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/no_image.jpg',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 15.0),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${widget.itemMaster.itemName} (${widget.itemMaster.uom})',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      '${widget.itemMaster.currency} ${widget.itemMaster.typeDis == 'Percent' ? _f.format((widget.itemMaster.unitPrice - (widget.itemMaster.unitPrice * widget.itemMaster.disRate) / 100)) : _f.format((widget.itemMaster.unitPrice - widget.itemMaster.disRate))}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  widget.itemMaster.disRate != 0
                                      ? Text(
                                          '${widget.itemMaster.currency} ${_f.format(widget.itemMaster.unitPrice)}',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        )
                                      : Text(''),
                                ],
                                mainAxisAlignment: MainAxisAlignment.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //   Positioned(
          //     bottom: 70.0,
          //     left: 70.0,
          //     child: Container(
          //       child: BlocBuilder<BlocOrder, StateOrder>(
          //         builder: (context, state) {
          //           if (state.allQty == 0) widget.itemMaster.qty = 0;
          //           if (state.qty == null)
          //             return SizedBox(height: 0);
          //           else if (state.qty == 0 &&
          //               state.key == widget.itemMaster.key) {
          //             widget.itemMaster.qty = state.qty;
          //             return SizedBox(height: 0);
          //           } else {
          //             if (state.qty != 0 &&
          //                 state.key == widget.itemMaster.key) {
          //               widget.itemMaster.qty = state.qty;
          //             }
          //             return state.qty != 0 &&
          //                     state.key == widget.itemMaster.key
          //                 ? Container(
          //                     alignment: Alignment.center,
          //                     height: 30.0,
          //                     width: 30.0,
          //                     decoration: BoxDecoration(
          //                       color: Colors.red,
          //                       shape: BoxShape.circle,
          //                     ),
          //                     child: Text(
          //                       '${state.qty.floor()}',
          //                       style: TextStyle(
          //                         fontSize: 15.0,
          //                         fontWeight: FontWeight.w600,
          //                         color: Colors.white,
          //                       ),
          //                     ),
          //                   )
          //                 : widget.itemMaster.qty != 0
          //                     ? Container(
          //                         alignment: Alignment.center,
          //                         decoration: BoxDecoration(
          //                           color: Colors.red,
          //                           shape: BoxShape.circle,
          //                         ),
          //                         height: 30.0,
          //                         width: 30.0,
          //                         child: Text(
          //                           '${widget.itemMaster.qty.floor()}',
          //                           style: TextStyle(
          //                             fontSize: 15.0,
          //                             fontWeight: FontWeight.w600,
          //                             color: Colors.white,
          //                           ),
          //                         ),
          //                       )
          //                     : SizedBox(height: 0.0);
          //           }
          //         },
          //       ),
          //     ),
          //   ),
          // ],
        ]),
      ),
    );
  }
}
