import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/open_shift_modal.dart';

class CheckOpenShiftController {
  Repository _repository;
  CheckOpenShiftController() {
    this._repository = Repository();
  }

  Future<void> insertOpenShift(OpenShiftModel openShiftModel) {
    return _repository.insertData('tbOpenShift', openShiftModel.toJson());
  }

  Future<List<OpenShiftModel>> selectOpenShift() async {
    var response = await _repository.selectData('tbOpenShift') as List;
    List<OpenShiftModel> openShiftList = [];
    response.map((value) {
      return openShiftList.add(OpenShiftModel.fromJson(value));
    }).toList();
    return openShiftList;
  }

  Future<void> deleteOpenShift(int id) {
    return _repository.deleteData('tbOpenShift', id);
  }

  Future<void> updateOpenShift(OpenShiftModel openShiftModel) {
    return _repository.updateData(
      'tbOpenShift',
      openShiftModel.toJson(),
      openShiftModel.id,
    );
  }
}
