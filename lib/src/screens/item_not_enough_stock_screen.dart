import 'package:flutter/material.dart';
import 'package:point_of_sale/src/models/receipt_info_model.dart';
import 'package:point_of_sale/src/models/return_from_server_modal.dart';

class NotEnoughStockScreen extends StatefulWidget {
  final List<ItemsReturn> lsItemReturn;
  NotEnoughStockScreen({this.lsItemReturn});
  @override
  _NotEnoughStockState createState() => _NotEnoughStockState();
}

class _NotEnoughStockState extends State<NotEnoughStockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Not Enuogh Stock",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: widget.lsItemReturn.map((e) {
          return InkWell(
            onTap: () {},
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Text(
                    e.code,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  title: Text(
                    e.khmerName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    "${e.inStock}",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> dailog(ItemReturn re) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: 320,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "Code",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${re.code}",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${re.khmerName}",
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "In Stock",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                            child: Text(
                              ":",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${re.inStock}",
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 110,
                            child: Text(
                              "Ordered Qty",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                            child: Text(
                              ":",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${re.orderQty}",
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 125,
                            child: Text(
                              "Commited Qty",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                            child: Text(
                              ":",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${re.committed}",
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              Positioned(
                  top: -30,
                  child: Center(
                    child: Icon(
                      Icons.info,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  )),
              Positioned(
                right: 5,
                bottom: 0,
                child: MaterialButton(
                  color: Color.fromRGBO(75, 181, 69, 1),
                  shape: StadiumBorder(),
                  padding: EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Ok',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
