import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/payment_means_modal.dart';

class PaymentMeanController {
  Repository _repository;
  PaymentMeanController() {
    _repository = Repository();
  }
  static Future<List<PaymentMeanModel>> getPaymenyMean(String ip) async {
    var url = ip + Config.paymentMean;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return paymentMeanModelFromJson(response.body);
    } else {
      return throw Exception('Failed to load paymean');
    }
  }

  Future<void> insertPaymentMean(PaymentMeanModel pay) async {
    return await _repository.insertData('tbPaymentMean', pay.toMap());
  }

  Future<void> updatePaymentMean(PaymentMeanModel pay) async {
    return await _repository.updateData("tbPaymentMean", pay.toMap(), pay.id);
  }

  Future<List<PaymentMeanModel>> hasPaymentMean(int id) async {
    var res = await _repository.selectDataById('tbPaymentMean', id) as List;
    List<PaymentMeanModel> payList = [];
    res.map((e) {
      return payList.add(PaymentMeanModel.fromJson(e));
    }).toList();
    return payList;
  }

  Future<List<PaymentMeanModel>> selectPaymentMean() async {
    var res = await _repository.selectData('tbPaymentMean') as List;
    List<PaymentMeanModel> payList = [];
    res.map((e) {
      return payList.add(PaymentMeanModel.fromJson(e));
    }).toList();
    return payList;
  }
}
