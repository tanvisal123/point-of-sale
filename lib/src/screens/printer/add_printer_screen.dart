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
import 'package:flutter/material.dart' hide Image;
import 'package:point_of_sale/src/screens/printer/show_printer_screen.dart';

class AddPrinterScreen extends StatefulWidget {
  const AddPrinterScreen({Key key}) : super(key: key);

  @override
  _AddPrinterScreenState createState() => _AddPrinterScreenState();
}

class _AddPrinterScreenState extends State<AddPrinterScreen> {
  //--------------- Bluetooth Printer ------------------------
  BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _deviceValue;
  bool _connected = false;

  EthernetController _ethernetController;
  TestPrint _testPrint;

  @override
  void initState() {
    super.initState();
    //_bluetoothController = BluetoothController();
    _ethernetController = EthernetController();
    _testPrint = TestPrint();
    _initPlatformState();
  }

  void _initPlatformState() async {
    bool isConnected = await _bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetooth.getBondedDevices();
    } catch (e) {
      print('Init Printer Error');
    }
    _bluetooth.onStateChanged().listen((state) {
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
    if (isConnected) setState(() => _connected = true);
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('No Device'),
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

  void _connect() {
    if (_deviceValue == null) {
      ShowMessage.showMessageSnakbar('No device selected', context);
    } else {
      _bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          _bluetooth.connect(_deviceValue).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  void _disconnect() {
    _bluetooth.disconnect();
    setState(() => _connected = true);
  }

  //---------------- End Bluetooth Printer -----------

  final _formKey = GlobalKey<FormState>();
  String _dropdownvalueInterface = 'Bluetooth';
  var _items = ['Bluetooth', 'Ethernet'];

  String _dropdownValuePeper = '58 mm';
  var _itemsPeper = ['58 mm', '80 mm'];

  var _paper;
  var _now;
  var _auto, _prin;
  var _blueName;
  bool _isSwitchedPrint = false;
  bool _isSwitchedAutoPrint = false;
  var _controllerPrinterName = TextEditingController();
  var _controllerIPAddress = TextEditingController();

  PrinterController _printerController = PrinterController();
  PrinterInfor _printerInfor = PrinterInfor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Printer'),
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
                    setState(() => _blueName = _devicesList
                        .elementAt(_devicesList.indexOf(_deviceValue))
                        .name);
                    _printerInfor = PrinterInfor(
                      printerId: _now.toString(),
                      printerName: _controllerPrinterName.text.trim(),
                      interface: _dropdownvalueInterface,
                      printerMode: _blueName,
                      paperWidth: _paper,
                      printReceiptStatus: _prin,
                      autoPrintReceiptStatus: _auto,
                    );
                    await _printerController.insertPrinter(_printerInfor);
                    if (_isSwitchedPrint) {
                      _connect();
                      await FlutterSession().set('printer', 'Bluetooth');
                      if (_connected)
                        await FlutterSession().set('connected', '1');
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
                    await _printerController.insertPrinter(_printerInfor);
                    if (_isSwitchedPrint) {
                      await FlutterSession().set('printer', 'Ethernet');
                      await FlutterSession()
                          .set('ip', _controllerIPAddress.text.trim());
                      await FlutterSession().set('connected', '0');
                    } else {
                      await FlutterSession().set('printer', 'Bluetooth');
                    }
                  }
                  ShowMessage.showLoading(context, 'Loading');
                  await Future.delayed(Duration(milliseconds: 500));
                  Navigator.pop(context);
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
                    if (value == null || value.isEmpty)
                      return 'Please enter some text';
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
                        controller: _controllerIPAddress,
                        keyboardType: TextInputType.number,
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
                              isExpanded: true,
                              underline: Container(
                                color: Colors.black,
                                height: 0.2,
                                width: double.infinity,
                              ),
                              icon: Icon(Icons.keyboard_arrow_down),
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
                Container(
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
                          _testPrint.sample();
                        } else {
                          _connect();
                          print('Bluetooth Connected');
                          _testPrint.sample();
                        }
                        print('Bluetooth Print');
                      } else if (_isSwitchedPrint &&
                          _dropdownvalueInterface == 'Ethernet') {
                        _ethernetController.connectEthernet(
                            _controllerIPAddress.text.trim(), context);
                        print('Ethernet Print');
                      }
                    },
                    child: Text('PRINT TEST'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //---------------------

}
