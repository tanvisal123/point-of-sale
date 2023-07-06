import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/src/models/receipt_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ReceiptWidget extends StatelessWidget {
  final ReceiptModel receiptModel;
  const ReceiptWidget({Key key, @required this.receiptModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _dF = DateFormat('dd-MM-yyyy');
    return Slidable(
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: null,
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Cancel',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: null,
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Cancel',
          ),
        ],
      ),
      child: ListTile(
        title: Text('#${receiptModel.receiptNo}'),
        subtitle: Text(
            '${_dF.format(DateTime.parse(receiptModel.dateIn))}  (${receiptModel.timeIn})'),
        trailing:
            Text('${receiptModel.grandTotal} ${receiptModel.currencyDisplay}'),
      ),
    );
  }
}
