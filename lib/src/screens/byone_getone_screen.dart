import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';

class BuyOneGetOneScreen extends StatefulWidget {
  final LoyaltyProgram loyaltyProgram;
  const BuyOneGetOneScreen({Key key, this.loyaltyProgram}) : super(key: key);

  @override
  State<BuyOneGetOneScreen> createState() => _BuyOneGetOneScreenState();
}

class _BuyOneGetOneScreenState extends State<BuyOneGetOneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalization.of(context).getTranValue("byone_getone")),
        ),
        body: ListView.builder(
            itemCount: widget.loyaltyProgram.buyXGetXDetails.length,
            itemBuilder: (context, index) {
              var detail = widget.loyaltyProgram.buyXGetXDetails[index];
              return Slidable(
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: ((context) async {}),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      icon: Icons.file_download_rounded,
                      label: 'Choose',
                    ),
                  ],
                ),
                child: Card(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Text(detail.proCode),
                                Text(detail.buyItemName),
                                Text(detail.uoM),
                                Text(detail.buyQty.toString()),
                              ],
                            )),
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: Icon(Icons.arrow_forward),
                          )),
                      Expanded(
                          flex: 5,
                          child: Container(
                              child: Column(
                            children: [
                              Text(detail.proCode),
                              Text(detail.getItemName),
                              Text(detail.getUomName),
                              Text(detail.getQty.toString()),
                            ],
                          )))
                    ],
                  ),
                ),
              );
            }));
  }
}
