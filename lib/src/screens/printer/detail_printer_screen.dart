import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:point_of_sale/src/controllers/printer_controller/bluetooth_controller.dart';
import 'package:point_of_sale/src/controllers/printer_controller/printer_controller.dart';
import 'package:point_of_sale/src/controllers/printer_controller/ethernet_controller.dart';
import 'package:point_of_sale/src/helpers/printers/test_print.dart';
import 'package:point_of_sale/src/helpers/show_message.dart';
import 'package:point_of_sale/src/models/printer_model/printer_model.dart';
import 'show_printer_screen.dart';

class DetailPrinterScreen extends StatefulWidget {
  final PrinterInfor printerInfor;
  const DetailPrinterScreen({this.printerInfor});

  @override
  _DetailPrinterScreenState createState() => _DetailPrinterScreenState();
}

class _DetailPrinterScreenState extends State<DetailPrinterScreen> {
  //=--------------- Bluetooth Service Printer ---------------
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _deviceValue;

  EthernetController _ethernetController;
  BluetoothController _bluetoothController;
  bool _connected = false;

  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}
    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() => _connected = true);
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() => _connected = false);
          break;
        default:
          print(state);
          break;
      }
    });
    if (!mounted) return;
    setState(() => _devicesList = devices);

    if (isConnected) {
      setState(() => _connected = true);
    }
  }

  //----------------- End Service Printer -----------------

  final _formKey = GlobalKey<FormState>();
  String _dropdownvalueInterface;
  var _items = ['Bluetooth', 'Ethernet'];

  String _dropdownValuePeper;
  var _itemsPeper = ['80 mm', '58 mm'];

  var _paper;
  var _now;
  var _auto, _prin;
  var _blueName;
  bool _isSwitchedPrint = false;
  bool _isSwitchedAutoPrint = false;
  var _controllerPrinterName = TextEditingController();
  var _controllerIPAddress = TextEditingController();
  TestPrint _testPrint;
  PrinterInfor _printerInfor = PrinterInfor();
  PrinterController _printerController = PrinterController();

  @override
  void initState() {
    super.initState();
    _testPrint = TestPrint();
    _ethernetController = EthernetController();
    _bluetoothController = BluetoothController();

    _controllerPrinterName.text = widget.printerInfor.printerName;
    _dropdownvalueInterface = widget.printerInfor.interface;
    if (widget.printerInfor.interface == 'Ethernet') {
      _controllerIPAddress.text = widget.printerInfor.printerMode;
    } else {
      // init bluetooth device
    }
    _dropdownValuePeper = widget.printerInfor.paperWidth.toString() + ' mm';
    widget.printerInfor.printReceiptStatus == 'true'
        ? _isSwitchedPrint = true
        : _isSwitchedPrint = false;

    widget.printerInfor.autoPrintReceiptStatus == 'true'
        ? _isSwitchedAutoPrint = true
        : _isSwitchedAutoPrint = false;

    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Printer'),
        actions: [
          Center(
            child: TextButton(
              child: Text('SAVE', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() => _now = DateTime.now());
                  _dropdownValuePeper.trim() == '80 mm'
                      ? _paper = 80
                      : _paper = 58;
                  _isSwitchedPrint ? _prin = 'true' : _prin = 'false';
                  _isSwitchedAutoPrint ? _auto = 'true' : _auto = 'false';
                  if (_dropdownvalueInterface.trim() == 'Bluetooth') {
                    setState(() {
                      _blueName = _devicesList
                          .elementAt(_devicesList.indexOf(_deviceValue))
                          .name;
                    });
                    _printerInfor = PrinterInfor(
                      printerId: _now.toString(),
                      printerName: _controllerPrinterName.text.trim(),
                      interface: _dropdownvalueInterface,
                      printerMode: _blueName,
                      paperWidth: _paper,
                      printReceiptStatus: _prin,
                      autoPrintReceiptStatus: _auto,
                    );
                    await _printerController.updatePrinter(
                        _printerInfor, widget.printerInfor.printerId);
                    if (_isSwitchedPrint) {
                      _connect();
                      await FlutterSession().set('printer', 'Bluetooth');
                    } else {
                      await FlutterSession().set('printer', 'Ethernet');
                    }
                  } else {
                    _printerInfor = PrinterInfor(
                      printerId: _now.toString(),
                      printerName: _controllerPrinterName.text.trim(),
                      interface: _dropdownvalueInterface,
                      printerMode: _controllerIPAddress.text.trim(),
                      paperWidth: _paper,
                      printReceiptStatus: _prin,
                      autoPrintReceiptStatus: _auto,
                    );
                    await _printerController.updatePrinter(
                        _printerInfor, widget.printerInfor.printerId);
                    if (_isSwitchedPrint) {
                      await FlutterSession().set('printer', 'Ethernet');
                      await FlutterSession()
                          .set('ip', _controllerIPAddress.text.trim());
                      // await FlutterSession().set('connected', '0');
                    } else {
                      await FlutterSession().set('printer', 'Bluetooth');
                    }
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ShowPrinterScreen()));
                }
              },
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: _buildBody,
    );
  }

  get _buildBody {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _controllerPrinterName,
                  decoration: InputDecoration(labelText: 'Printer Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Interface', style: TextStyle(fontSize: 12)),
                    Container(
                      height: 60,
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        underline: Container(
                          color: Colors.black,
                          height: 0.2,
                          width: double.infinity,
                        ),
                        dropdownColor: Colors.white,
                        value: _dropdownvalueInterface,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: _items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          setState(() => _dropdownvalueInterface = newValue);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _dropdownvalueInterface == 'Ethernet'
                    ? TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _controllerIPAddress,
                        decoration:
                            InputDecoration(labelText: 'Printer IP Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please enter some text';
                          return null;
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Select Printer',
                              style: TextStyle(fontSize: 12)),
                          Container(
                            height: 60,
                            width: double.infinity,
                            child: DropdownButton(
                              icon: Icon(Icons.keyboard_arrow_down),
                              isExpanded: true,
                              underline: Container(
                                color: Colors.black,
                                height: 0.2,
                                width: double.infinity,
                              ),
                              dropdownColor: Colors.white,
                              items: _getDeviceItems(),
                              onChanged: (value) =>
                                  setState(() => _deviceValue = value),
                              value: _deviceValue,
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Peper width', style: TextStyle(fontSize: 12)),
                    Container(
                      height: 60,
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        underline: Container(
                          color: Colors.black,
                          height: 0.5,
                          width: double.infinity,
                        ),
                        value: _dropdownValuePeper,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: _itemsPeper.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          setState(() => _dropdownValuePeper = newValue);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Print Receipt'),
                    Switch(
                      value: _isSwitchedPrint,
                      onChanged: (value) {
                        setState(() => _isSwitchedPrint = value);
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _isSwitchedPrint
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Automatically Print Receipt'),
                          Switch(
                            value: _isSwitchedAutoPrint,
                            onChanged: (value) {
                              setState(() => _isSwitchedAutoPrint = value);
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if (_isSwitchedPrint &&
                                _dropdownvalueInterface == 'Bluetooth') {
                              if (_connected) {
                                await _testPrint.sample();
                                print('Print without connect');
                              } else {
                                _connect();
                                await _testPrint.sample();
                              }
                              print('Bluetooth Print');
                            } else if (_isSwitchedPrint &&
                                _dropdownvalueInterface == 'Ethernet') {
                              await _ethernetController
                                  .connectEthernet(
                                      _controllerIPAddress.text.trim(), context)
                                  .onError((error, stackTrace) =>
                                      print('Network Print Error = $error'));
                              print('Ehternet Print');
                            }
                          },
                          child: Text('PRINT TEST'),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: TextButton(
                          onPressed: () {
                            showDialog<String>(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) => Center(
                                child: Container(
                                  height: 160,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: Text(
                                          'Comfirm',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 50,
                                          child: Text(
                                            'Are you sure you want to delete ?',
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 50,
                                              child: TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('NO'),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 50,
                                              child: TextButton(
                                                onPressed: () async {
                                                  await _printerController
                                                      .deletePrinter(widget
                                                          .printerInfor
                                                          .printerId);
                                                  setState(() {
                                                    _controllerIPAddress
                                                        .clear();
                                                    _controllerPrinterName
                                                        .clear();
                                                    _dropdownValuePeper =
                                                        '80 mm';
                                                    _dropdownvalueInterface =
                                                        'Ethernet';
                                                    _isSwitchedPrint = false;
                                                    _isSwitchedAutoPrint =
                                                        false;
                                                  });
                                                  ShowMessage.showLoading(
                                                      context, 'Loading');
                                                  await Future.delayed(Duration(
                                                      milliseconds: 500));
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            ShowPrinterScreen(),
                                                      ));
                                                },
                                                child: Text('YES'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text('DELETE PRINTER'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //----------------- Bluetooth Printer Service --------------
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  _connect() {
    if (_deviceValue == null) {
      ShowMessage.showMessageSnakbar('No device selected.', context);
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_deviceValue).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = true);
  }

  //-----------------End Bluetooth Print--------------------------------

}
