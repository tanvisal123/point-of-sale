import 'package:http/http.dart' as http;
import 'package:point_of_sale/src/constants/api_config.dart';
import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/tax_modal.dart';

class TaxController {
  Repository _repository;
  TaxController() {
    _repository = Repository();
  }

  static Future<List<TaxModel>> getTax(String ip) async {
    var url = ip + Config.urlTax;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return taxModelFromJson(response.body);
    } else {
      return throw Exception('Failed to load tax');
    }
  }

  Future<void> insertTax(TaxModel taxModel) {
    return _repository.insertData('tbTax', taxModel.toJson());
  }

  Future<List<TaxModel>> selectTax() async {
    var response = await _repository.selectData('tbTax') as List;
    List<TaxModel> taxList = [];
    response.map((value) {
      return taxList.add(TaxModel.fromJson(value));
    }).toList();
    return taxList;
  }

  Future<void> deleteTax(int id) {
    return _repository.deleteData('tbTax', id);
  }

  Future<void> updateTax(TaxModel taxModel) {
    return _repository.updateData('tbTax', taxModel.toJson(), taxModel.id);
  }
}
