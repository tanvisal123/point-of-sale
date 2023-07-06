import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/controllers/setting_controller.dart';
import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/item_modal.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';
import 'package:point_of_sale/src/models/order_modal.dart';
import 'package:point_of_sale/src/models/tax_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'display_currency_controller.dart';
import 'package:point_of_sale/src/models/post_server_modal.dart';
import 'package:point_of_sale/src/models/payment_means_modal.dart';

class SaleController {
  Repository _repository;
  SaleController() {
    _repository = Repository();
  }

  //--------- get order --------
  static Future<List<PostModel>> getOrder(int tableId, String ip) async {
    var userId = await FlutterSession().get('userId');
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.urlGetOrder + '/$tableId/$userId';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token,
      },
    );
    print('GETORDER URL = $url');
    if (response.statusCode == 200) {
      return postFromJson(response.body);
    } else {
      return throw Exception('Failed to load order');
    }
  }

  //------ new order ------
  Future<void> buildOrder(
    BuildContext context,
    ItemMaster itemMaster,
    int tableId,
    String ip,
    List<PaymentMeanModel> payment,
    //List<SettingModel> setting,
    List<TaxModel> tax,
  ) async {
    var _selectOrder = await selectOrder();
    var _selectDetail = await selectOrderDetail();
    bool _connection = await DataConnectionChecker().hasConnection;
    var _selectDisplayCurr = await DisplayCurrController().selectDisplayCurr();
    var _selectSetting = await SettingController().selectSetting();

    //var _displayCurr = await DisplayCurrController.getDisplayCurr(ip);
    // var _selectPaymentMean = await PaymentMeanController().selectPaymentMean();
    // var _selectTax = await TaxController().selectTax();

    // if (_selectDisplayCurr.isEmpty || _selectDisplayCurr == null) {
    //   print('DisplayCurr is Null');
    // } else {
    //   _selectDisplayCurr.forEach((element) {
    //     print(element.baseCurr);
    //   });
    // }
    //
    // if (_selectPaymentMean.isEmpty) {
    //   print('Payment Mean Null');
    // } else {
    //   _selectPaymentMean.forEach((element) {
    //     print(element.type);
    //   });
    // }
    // if (_selectSetting.isEmpty || _selectSetting == null) {
    //   print('Setting Null');
    // } else {
    //   print('Setting Not Null');
    //   _selectSetting.forEach((element) {
    //     print(element.branchId);
    //   });
    // }
    // if (_selectTax.isEmpty || _selectTax == null) {
    //   print('Tax is null');
    // } else {
    //   print('Tax is not null');
    //   _selectSetting.forEach((element) {
    //     print(element.branchId);
    //   });
    // }

    if (_connection) {
      //------------------------------------------
      var _getOrder = await getOrder(tableId, ip);
      var _queue = 0;
      if (_getOrder.isEmpty || _getOrder == null) {
        print('Get order is null');
      } else {
        _queue = _getOrder.length;
        print('Queue = $_queue');
      }
      //--------------------------------------
      var _detail = _selectDetail.firstWhere(
        (element) => element.lineId == itemMaster.key,
        orElse: () => null,
      );
      if (_detail == null) {
        var _key = 0;
        var _currentDate = DateTime.now();
        if (_selectOrder.length <= 0) {
          OrderModel _order = OrderModel(
            orderId: 0,
            orderNo: 'Order-${_queue == 0 ? '1' : _queue + 1}',
            tableId: tableId ?? 1,
            receiptNo: 'Order-${_queue == 0 ? '1' : _queue + 1}',
            queueNo: _queue == 0 ? '1' : '${_queue + 1}',
            dateIn: _currentDate,
            dateOut: _currentDate,
            timeIn: DateFormat('kk:mm:ss').format(_currentDate).toString(),
            timeOut: DateFormat('kk:mm:ss').format(_currentDate).toString(),
            waiterId: 1,
            userOrderId: 0,
            userDiscountId: 0,
            customerId:
                _selectSetting.length > 0 ? _selectSetting.first.customerId : 0,
            customerCount: 1,
            priceListId: _selectSetting.length > 0
                ? _selectSetting.first.priceListId
                : 0,
            localCurrencyId: _selectSetting.length > 0
                ? _selectSetting.first.localCurrencyId
                : 0,
            sysCurrencyId: _selectSetting.length > 0
                ? _selectSetting.first.sysCurrencyId
                : 0,
            exchangeRate:
                _selectSetting.length > 0 ? _selectSetting.first.rateIn : 0,
            warehouseId: _selectSetting.length > 0
                ? _selectSetting.first.warehouseId
                : 0,
            branchId: 0,
            companyId:
                _selectSetting.length > 0 ? _selectSetting.first.companyId : 0,
            subTotal: 0,
            discountRate: 0,
            discountValue: 0,
            typeDis: 'Percent',
            taxRate: tax.length > 0 ? tax.first.rate : 0,
            taxValue: 0,
            grandTotal: 0,
            grandTotalSys: 0,
            tip: 0,
            received: 0,
            change: 0,
            currencyDisplay: _selectDisplayCurr.length > 0
                ? _selectDisplayCurr.first.altCurr
                : '',
            displayRate: _selectDisplayCurr.length > 0
                ? _selectDisplayCurr.first.rate
                : 0,
            grandTotalDisplay: 0,
            changeDisplay: 0,
            paymentMeansId: payment.first.id,
            checkBill: 'N',
            cancel: 0,
            delete: 0,
            paymentType: '',
            receivedType: '',
            credit: 0,
            localSetRate: 0,
            plCurrencyId: 0,
            plRate: 0,
          );
          _key = await insertOrder(_order);
        }
        if (_key == 0) {
          if (_selectDetail.length > 0) {
            _key = _selectDetail.first.id;
          }
        }
        OrderDetail detail = OrderDetail(
          masterId: _key,
          orderDetailId: 0,
          orderId: 0,
          lineId: itemMaster.key,
          itemId: itemMaster.itemId,
          code: itemMaster.itemCode,
          khmerName: itemMaster.itemName,
          englishName: itemMaster.itemName,
          qty: 1,
          printQty: 1,
          unitPrice: itemMaster.unitPrice,
          cost: itemMaster.cost,
          discountRate: itemMaster.disRate,
          discountValue: itemMaster.disValue,
          typeDis: itemMaster.typeDis,
          total: 0,
          totalSys: 0,
          uomId: itemMaster.uomId,
          uomName: itemMaster.uom,
          itemStatus: 'F',
          itemPrintTo: '',
          currency: itemMaster.currency,
          comment: '',
          itemType: itemMaster.itemType,
          description: '',
          parentLevel: '',
          image: itemMaster.image,
          show: 0,
        );
        insertOrderDetail(detail);
      } else {
        _detail.qty += 1;
        _detail.printQty += 1;
        updateOrderDetail(_detail);
      }
    } else {
      print('No Internet Connection');
    }
  }

  // inset order
  Future<dynamic> insertOrder(OrderModel order) async {
    return await _repository.insertData('tbOrder', order.toMap());
  }

  // insert order detail
  Future<void> insertOrderDetail(OrderDetail detail) async {
    return await _repository.insertData('tbOrderDetail', detail.toMap());
  }

  // select order
  Future<List<OrderModel>> selectOrder() async {
    var res = await _repository.selectData('tbOrder') as List;
    List<OrderModel> orderList = [];
    res.map((item) {
      return orderList.add(OrderModel.fromJson(item));
    }).toList();
    return orderList;
  }

  // select order by rawQuery
  Future<List<OrderModel>> selectOrderRaw() async {
    var res = await _repository.selectData('tbOrder') as List;
    List<OrderModel> list = [];
    res.map((item) {
      return list.add(OrderModel.fromJson(item));
    }).toList();
    return list;
  }

  // select order by key
  Future<List<OrderModel>> selectOrderKey(int id) async {
    var res = await _repository.selectDataById('tbOrder', id) as List;
    List<OrderModel> list = [];
    res.map((item) {
      return list.add(OrderModel.fromJson(item));
    }).toList();
    return list;
  }

  // select order detail
  Future<List<OrderDetail>> selectOrderDetail() async {
    var response = await _repository.selectData('tbOrderDetail') as List;
    List<OrderDetail> orderDetailList = [];

    response.map((item) {
      return orderDetailList.add(OrderDetail.fromJson(item));
    }).toList();
    return orderDetailList;
  }

  // update order
  Future<void> updateOrder(OrderModel order) async {
    return await _repository.updateData('tbOrder', order.toMap(), order.id);
  }

  // update order detail
  Future<void> updateOrderDetail(OrderDetail orderDetail) async {
    return await _repository.updateData(
      'tbOrderDetail',
      orderDetail.toMap(),
      orderDetail.id,
    );
  }

  //delete all order
  Future<void> deleteAllOrder() async {
    return await _repository.deleteAllData('tbOrder');
  }

  // delete order by id
  Future<void> deleteOrder(int id) async {
    return await _repository.deleteData('tbOrder', id);
  }

  // delete all order detail
  Future<void> deleteAllOrderDetail() async {
    return await _repository.deleteAllData('tbOrderDetail');
  }

  // delete order detail by id
  Future<void> deleteOrderDetail(int id) async {
    return await _repository.deleteData('tbOrderDetail', id);
  }
}
