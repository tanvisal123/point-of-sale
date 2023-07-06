import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:point_of_sale/src/models/order_detail_modal.dart';
import 'package:point_of_sale/src/models/order_modal.dart';
import 'package:point_of_sale/src/models/post_server_modal.dart';
import 'package:point_of_sale/src/models/receipt_info_model.dart';
import 'package:point_of_sale/src/models/return_from_server_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as console;
import 'dart:developer' as dev;

class PostOrder {
  Future<ReceiptInfoModel> sumitOrder(FetchOrderModel fetchOrderModel,
      String printType, String ip, String paymentMeanId) async {
    var _prfre = await SharedPreferences.getInstance();
    var token = _prfre.getString("token");
    dev.log("Order:${fetchOrderModel.order.paymentType}");
    var order = fetchOrderModel.order;
    order.receiptNo = "N/A";
    order.paymentMeansId = int.parse(paymentMeanId);
    // for (var temp in order.orderDetail) {
    //   print("unit price ${temp.unitPrice}");
    //   print("total ${temp.total}");
    // }
    // print("paymentmean id: $paymentMeanId");
    // print("payment mean id : ${order.paymentMeansId}");
    // print("receiptNo : ${order.receiptNo}");
    // print("order : ${jsonEncode(order.toJson())}");
    // print("ip : $ip");
    final String url = ip + Config.urlSumitOrder + "/$printType";
    print("url : $url");
    print("print qty : ${order.orderDetail.first.printQty}");
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer " + token,
      },
      body: jsonEncode(order.toJson()),
    );
    dev.log("Send:${response.body}");
    print("status code : ${response.statusCode}");
    print("respone body : ${response.body}");
    try {
      if (response.statusCode == 200) {
        ReceiptInfoModel.fromJson(jsonDecode(response.body));
        console.log(response.body);
      } else {
        print("No data");
      }
    } catch (e) {
      print("error data : ${e.toString()}");
    }
    return receiptInfoFromJson(response.body);
  }

  Future<Order> saveOrder(FetchOrderModel fetchOrderModel, String ip) async {
    var _prfre = await SharedPreferences.getInstance();
    var token = _prfre.getString("token");
    var order = fetchOrderModel.order;
    var url = ip + Config.urlSaveOrder + "/$order";
    String jsonString;
    try {
      var respone = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer " + token
        },
        body: jsonEncode(order.toJson()),
      );
      jsonString = respone.body;
      print(respone.statusCode);
      if (respone.statusCode == 200) {
        Order orders = Order.fromJson(jsonDecode(jsonString));
        print("order no : ${orders.orderNo}");
        return Order.fromJson(jsonDecode(jsonString));
      }
    } catch (e) {
      print(e.toString());
    }
    return Order.fromJson(jsonDecode(jsonString));
  }

  Future<void> deteleSaveOrder(int orderId, String ip) async {
    var _prfre = await SharedPreferences.getInstance();
    var token = _prfre.getString("token");
    var url = ip + Config.deteleSaveOrder + "/$orderId";
    print("url  = $url");
    String jsonString;
    try {
      var respone = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer " + token
        },
      );
      if (respone.statusCode == 200) {
        jsonString = jsonDecode(respone.body);
        print("resopne : $jsonString");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ReturnFromServer> _postOrder(PostModel post, String ip) async {
    final String url = ip + Config.postOrder;
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json;charset=UTF-8'},
      body: jsonEncode(post.toJson()),
    );
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      ReturnFromServer result = ReturnFromServer.fromJson(res);
      return result;
    } else {
      print('PostOrder Data is null');
      return null;
    }
  }

  Future<bool> voidOrder(String ip, int orderId, String reason) async {
    bool _connection = await DataConnectionChecker().hasConnection;
    var _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var url = ip + Config.voidOrder + "/$orderId" + "/$reason";
    var respone = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer " + token
    });
    if (_connection) {
      try {
        if (respone.statusCode == 200) {
          return true;
        }
      } catch (e) {
        print(e);
      }
    }
    return true;
  }

  Future<ReturnFromServer> beforPost(
    String type,
    String ip,
    dynamic userId,
    List<OrderModel> orderList,
    List<OrderDetail> detailList,
    String systemType,
  ) async {
    final _pref = await SharedPreferences.getInstance();
    var customerId = _pref.getInt("customerId") ?? orderList.first.customerId;
    List<OrderDetail> _orderDetailList = [];
    var _branchId = await FlutterSession().get('branchId');
    detailList.forEach((e) {
      print('Print Qty = ${e.printQty}');
      print('Qty       = ${e.qty}');
      print('Image     = ${e.image}');
      print('Total     = ${e.total}');
      print('TotalSys  = ${e.totalSys}');
      OrderDetail orderDetail = OrderDetail(
        orderDetailId: e.orderDetailId,
        orderId: e.orderId,
        lineId: e.lineId,
        itemId: e.itemId,
        code: e.code,
        khmerName: e.khmerName,
        englishName: e.englishName,
        qty: e.qty,
        printQty: e.printQty,
        unitPrice: e.unitPrice,
        cost: e.cost,
        discountRate: e.discountRate,
        discountValue: e.discountValue,
        typeDis: e.typeDis,
        total: e.total,
        totalSys: e.totalSys,
        uomId: e.uomId,
        uomName: e.uomName,
        itemStatus: e.itemStatus,
        itemPrintTo: e.itemPrintTo,
        currency: e.currency,
        comment: e.comment,
        itemType: e.itemType,
        description: e.description,
        parentLevel: e.parentLevel,
        image: e.image,
        show: e.show,
      );
      _orderDetailList.add(orderDetail);
    });
    print('OrderNo = ${orderList.first.orderNo}');
    print('Queue   = ${orderList.first.queueNo}');
    PostModel post = PostModel(
      orderId: orderList.first.orderId,
      orderNo: orderList.first.orderNo,
      tableId: orderList.first.tableId,
      receiptNo: orderList.first.receiptNo,
      queueNo: orderList.first.queueNo,
      dateIn: orderList.first.dateIn,
      dateOut: orderList.first.dateOut,
      timeIn: orderList.first.timeIn,
      timeOut: orderList.first.timeOut,
      waiterId: orderList.first.waiterId,
      userOrderId: userId,
      userDiscountId: userId,
      customerId:
          systemType == "KBMS" ? customerId : orderList.first.customerId,
      customerCount: orderList.first.customerCount,
      priceListId: orderList.first.priceListId,
      localCurrencyId: orderList.first.localCurrencyId,
      sysCurrencyId: orderList.first.sysCurrencyId,
      exchangeRate: orderList.first.exchangeRate,
      warehouseId: orderList.first.warehouseId,
      branchId: _branchId,
      companyId: orderList.first.companyId,
      subTotal: orderList.first.subTotal,
      discountRate: orderList.first.discountRate,
      discountValue: orderList.first.discountValue,
      typeDis: orderList.first.typeDis,
      taxRate: orderList.first.taxRate,
      taxValue: orderList.first.taxValue,
      grandTotal: orderList.first.grandTotal,
      grandTotalSys: orderList.first.grandTotalSys,
      tip: orderList.first.tip,
      received: orderList.first.received,
      change: orderList.first.change,
      currencyDisplay: orderList.first.currencyDisplay,
      displayRate: orderList.first.displayRate,
      grandTotalDisplay: orderList.first.grandTotalDisplay,
      changeDisplay: orderList.first.changeDisplay,
      paymentMeansId: orderList.first.paymentMeansId,
      checkBill: orderList.first.checkBill,
      cancel: orderList.first.cancel,
      delete: orderList.first.delete,
      paymentType: orderList.first.paymentType,
      receivedType: orderList.first.receivedType,
      credit: orderList.first.credit,
      localSetRate: 0,
      plCurrencyId: 0,
      plRate: 0,
      typePrinter: type,
      detail: _orderDetailList,
    );
    var _data = await _postOrder(post, ip);
    ReturnFromServer returnFromServer =
        ReturnFromServer(data: _data.data, status: _data.status);
    return returnFromServer;
  }
}
