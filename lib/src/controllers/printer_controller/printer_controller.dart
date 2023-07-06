import 'package:point_of_sale/src/helpers/repositorys.dart';
import 'package:point_of_sale/src/models/printer_model/printer_model.dart';

class PrinterController {
  Repository repository;
  PrinterController() {
    repository = Repository();
  }
  Future<void> insertPrinter(PrinterInfor printerInfor) {
    return repository.insertData('tbPrinter', printerInfor.toMap());
  }

  Future<List<PrinterInfor>> selectPrinter() async {
    var response = await repository.selectData('tbPrinter') as List;
    List<PrinterInfor> printerList = [];
    response.map((item) {
      return printerList.add(PrinterInfor.fromJson(item));
    }).toList();
    return printerList;
  }

  Future<void> deletePrinter(String printerId) {
    return repository.deleteData('tbPrinter', printerId);
  }

  Future<void> updatePrinter(PrinterInfor printerInfor, String printerId) {
    return repository.updateData('tbPrinter', printerInfor.toMap(), printerId);
  }
}
