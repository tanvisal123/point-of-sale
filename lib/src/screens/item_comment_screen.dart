// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:point_of_sale/src/controllers/item_comment_controller.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import '../models/item_comment_model.dart';

// ternary statme funtion is Deferent
class ItemCommentScreen extends StatefulWidget {
  ItemCommentScreen(
      {this.fetchOrderModel,
      this.orderDetail,
      this.ip,
      this.listselectItem,
      Key key})
      : super(key: key);
  final FetchOrderModel fetchOrderModel;
  List<ItemCommentModel> listselectItem = [];
  final String ip;
  OrderDetailModel orderDetail;
  @override
  State<ItemCommentScreen> createState() => _ItemCommentScreenState();
}

List<ItemCommentModel> listItem = [];
List<ItemCommentModel> listselectItem = [];
List<ItemCommentModel> filterList = [];
TextEditingController controller = TextEditingController();

class _ItemCommentScreenState extends State<ItemCommentScreen> {
  void getInitItemComment() async {
    await ItemCommentController().getItemComment(widget.ip).then((value) {
      setState(() {
        listItem = value.toList();
      });
    });
    for (var temp in listItem) {
      print(temp.description + '& ' + temp.id.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getInitItemComment();
  }

  @override
  void didUpdateWidget(covariant ItemCommentScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey[50],
        foregroundColor: Colors.black,
        title: Container(
          height: 45,
          width: 250,
          child: TextFormField(
            controller: controller,
            onChanged: (value) {
              setState(() {
                filterList = listItem
                    .where((element) => element.description
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
                for (var temp in filterList) {
                  print('search =${temp.description}');
                }
              });
            },
            //  textAlign: TextAlign.justify,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
                hintText: 'Search comment',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder()),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 1),
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(
                  'Item name : ' + widget.orderDetail.khmerName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          InkWell(
            onTap: () async {
              if (filterList.every((element) =>
                  element.description.toLowerCase() !=
                  controller.text.toLowerCase())) {
                await ItemCommentController()
                    .saveItemComment(
                        widget.ip,
                        ItemCommentModel(
                            id: 0,
                            deleted: false,
                            description: controller.text))
                    .whenComplete(() => getInitItemComment());
              }
              controller.text = '';
            },
            child: Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.all(3),
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  Text(
                    'Add Comment',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.text == null || controller.text.isNotEmpty
                  ? filterList.length
                  : listItem.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var item = controller.text == null || controller.text.isNotEmpty
                    ? filterList[index]
                    : listItem[index];
                return Card(
                  elevation: 0,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 12),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.description,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: IconButton(
                                    onPressed: () {
                                      editItemCommen(item);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 35,
                                      color: Colors.amber[800],
                                    )),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                  child: IconButton(
                                      onPressed: () {
                                        deletedItemComment(item);
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        size: 30,
                                        color: Colors.red,
                                      ))),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: 40,
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        if (widget.listselectItem.every(
                                            (element) =>
                                                element.id != item.id)) {
                                          setState(() {
                                            widget.listselectItem.add(item);
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_sharp,
                                        color: Colors.green[600],
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> editItemCommen(ItemCommentModel itemComment) {
    String itemName = '';
    TextEditingController editingController = TextEditingController();
    editingController.text = itemComment.description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titleTextStyle: TextStyle(
                color: Colors.deepOrangeAccent[700],
                fontSize: 20,
                fontWeight: FontWeight.bold),
            title: Text('Edite comment'),
            content: TextField(
              onChanged: (value) {
                itemName = value.toString();
              },
              controller: editingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              MaterialButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  await ItemCommentController()
                      .saveItemComment(
                          widget.ip,
                          ItemCommentModel(
                              id: itemComment.id,
                              description: itemName,
                              deleted: false))
                      .whenComplete(() {
                    getInitItemComment();
                    Navigator.pop(context);
                  });
                },
                child: Text('ok', style: TextStyle(fontSize: 18)),
              ),
              MaterialButton(
                color: Colors.deepOrangeAccent[700],
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'cencel',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
        });
  }

  Future<void> deletedItemComment(ItemCommentModel itemComment) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titleTextStyle: TextStyle(
                color: Colors.deepOrangeAccent[700],
                fontSize: 20,
                fontWeight: FontWeight.bold),
            title: Text('Delete comment'),
            content: Text(
                'do you want to delete comment [${itemComment.description}'),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              MaterialButton(
                color: Colors.blueAccent,
                onPressed: () async {
                  await ItemCommentController()
                      .deleteItemComment(widget.ip, itemComment.id)
                      .whenComplete(() {
                    getInitItemComment();
                    Navigator.pop(context);
                  });
                },
                child: Text('ok', style: TextStyle(fontSize: 18)),
              ),
              MaterialButton(
                color: Colors.deepOrangeAccent[700],
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'cencel',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
        });
  }
}
