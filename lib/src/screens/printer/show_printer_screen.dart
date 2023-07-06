import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/src/controllers/printer_controller/printer_controller.dart';
import 'package:point_of_sale/src/models/printer_model/printer_model.dart';
import 'package:point_of_sale/src/screens/printer/add_printer_screen.dart';
import 'package:point_of_sale/src/screens/printer/detail_printer_screen.dart';

class ShowPrinterScreen extends StatefulWidget {
  const ShowPrinterScreen({Key key}) : super(key: key);

  @override
  _ShowPrinterScreenState createState() => _ShowPrinterScreenState();
}

class _ShowPrinterScreenState extends State<ShowPrinterScreen> {
  List<PrinterInfor> _printerList = [];
  PrinterController _printerController = PrinterController();
  selectPrinter() async {
    await _printerController.selectPrinter().then((value) {
      if (mounted) setState(() => _printerList.addAll(value));
    });
  }

  Future<void> statusPrinter() async {
    var b = await FlutterSession().get('printer');
    var ip = await FlutterSession().get('ip');
    var connected = await FlutterSession().get('connected');
    print('Printer   = $b');
    print('IP        = $ip');
    print('Connected = $connected');
  }

  @override
  void initState() {
    super.initState();
    selectPrinter();
    print('Init');
    statusPrinter();
  }

  // bool isSwitched = false;
  // final _switchSet = Set<dynamic>();
  // Widget buildSwitch(int index) {
  //   bool _switched = _switchSet.contains(index);
  //   return Switch(
  //     value: _switched,
  //     onChanged: (value) {
  //       setState(() {
  //         if (_switched) {
  //           _switchSet.remove(index);
  //           _switched = value;
  //           print('Index : $index');
  //         } else {
  //           _switchSet.add(index);
  //           _switched = value;
  //           print('Index : $index');
  //         }
  //       });
  //     },
  //     activeTrackColor: Colors.lightGreenAccent,
  //     activeColor: Colors.green,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer'),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPrinterScreen()),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
          itemCount: _printerList.length,
          itemBuilder: (context, index) {
            var data = _printerList[index];
            return Card(
              child: ListTile(
                leading: Icon(Icons.print),
                title: Text('${data.printerName}'),
                subtitle: Text('${data.printerMode}'),
                //trailing: buildSwitch(index),
                onTap: () {
                  print(data);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPrinterScreen(printerInfor: data),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
