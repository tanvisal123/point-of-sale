import 'package:point_of_sale/src/controllers/sale_controller.dart';
import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';
import 'package:point_of_sale/src/models/order_modal.dart';

class BillController {
  Repository _repository;

  BillController() {
    _repository = Repository();
  }

  insertBill(OrderModel order) async {
    return await _repository.insertData('tbBill', order.toMap());
  }

  insertBillDetail(OrderDetail detail) async {
    return await _repository.insertData('tbBillDetail', detail.toMap());
  }

  Future<List<OrderModel>> getBill(int page, int index) async {
    var res = await _repository.selectData('tbBill') as List;
    List<OrderModel> list = [];
    res.map((item) {
      return list.add(OrderModel.fromJson(item));
    }).toList();

    int totalPage = list.length;
    totalPage = (totalPage / page).floor();
    List<OrderModel> orderList = [];
    if (list.length % page != 0) {
      totalPage += 1;
    }
    if (totalPage >= index) {
      orderList = list.skip((index - 1) * page).take(page).toList();
    }
    return orderList;
  }

  Future<List<OrderModel>> getFirstBii(int orderId) async {
    var res = await _repository.selectFirstBill("tbBill", orderId) as List;
    List<OrderModel> lsOrder = [];
    res.map((item) {
      return lsOrder.add(OrderModel.fromJson(item));
    }).toList();
    return lsOrder;
  }

  Future<List<OrderDetail>> getBillDetail(int orderId) async {
    var res =
        await _repository.selectBillDetail('tbBillDetail', orderId) as List;
    List<OrderDetail> list = [];
    res.map((item) {
      return list.add(OrderDetail.fromJson(item));
    }).toList();
    return list;
  }

  Future<List<OrderDetail>> getFirstBillDetail() async {
    var res = await _repository.selectData('tbBillDetail') as List;
    List<OrderDetail> list = [];
    res.map((item) {
      return list.add(OrderDetail.fromJson(item));
    }).toList();
    return list;
  }

  updateBill(OrderModel order, orderId) async {
    return await _repository.updateBill("tbBill", order, orderId);
  }

  updateBillDetail(OrderDetail detail, detailId) async {
    return await _repository.updateBillDetail("tbBillDetail", detail, detailId);
  }

  deleteBill() async {
    return await _repository.deleteAllData('tbBill');
  }

  deleteBillDetail() async {
    return await _repository.deleteAllData('tbBillDetail');
  }

  newBill() async {
    SaleController().selectOrder().then((order) async {
      var orderId = 0;
      OrderModel orders = new OrderModel(
          orderNo: order.first.orderNo,
          tableId: order.first.tableId,
          receiptNo: order.first.receiptNo,
          queueNo: order.first.queueNo,
          dateIn: order.first.dateIn,
          dateOut: order.first.dateOut,
          timeIn: order.first.timeIn,
          timeOut: order.first.timeOut,
          waiterId: order.first.waiterId,
          userOrderId: order.first.userOrderId,
          userDiscountId: order.first.userDiscountId,
          customerId: order.first.customerId,
          customerCount: order.first.customerCount,
          priceListId: order.first.priceListId,
          localCurrencyId: order.first.localCurrencyId,
          sysCurrencyId: order.first.sysCurrencyId,
          exchangeRate: order.first.exchangeRate,
          warehouseId: order.first.waiterId,
          branchId: order.first.branchId,
          companyId: order.first.companyId,
          subTotal: order.first.subTotal,
          discountRate: order.first.discountRate,
          discountValue: order.first.discountValue,
          typeDis: order.first.typeDis,
          taxRate: order.first.taxRate,
          taxValue: order.first.taxValue,
          grandTotal: order.first.grandTotal,
          grandTotalSys: order.first.grandTotalSys,
          tip: order.first.tip,
          received: order.first.received,
          change: order.first.change,
          currencyDisplay: order.first.currencyDisplay,
          displayRate: order.first.displayRate,
          grandTotalDisplay: order.first.grandTotalDisplay,
          changeDisplay: order.first.changeDisplay,
          paymentMeansId: order.first.paymentMeansId,
          checkBill: order.first.checkBill,
          cancel: order.first.cancel,
          delete: order.first.delete,
          paymentType: order.first.paymentType,
          receivedType: order.first.receivedType,
          credit: order.first.credit);

      orderId = await insertBill(orders);

      SaleController().selectOrderDetail().then((details) async {
        details.forEach((x) async {
          OrderDetail detail = new OrderDetail(
              orderId: orderId,
              lineId: x.lineId,
              itemId: x.itemId,
              code: x.code,
              khmerName: x.khmerName,
              englishName: x.englishName,
              qty: x.qty,
              printQty: x.printQty,
              unitPrice: x.unitPrice,
              cost: x.cost,
              discountRate: x.discountRate,
              discountValue: x.discountValue,
              typeDis: x.typeDis,
              total: x.total,
              totalSys: x.totalSys,
              uomId: x.uomId,
              itemStatus: x.itemStatus,
              itemPrintTo: x.itemPrintTo,
              currency: x.currency,
              comment: x.comment,
              itemType: x.itemType,
              description: x.description,
              parentLevel: x.parentLevel,
              image: x.image,
              show: x.show);
          await insertBillDetail(detail);
        });
        SaleController().deleteAllOrder();
        SaleController().deleteAllOrderDetail();
      });
    });
  }
}
