// import 'dart:typed_data';
// import 'dart:io' show Platform;
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart' hide Image;
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
// import 'package:image/image.dart';

// class PrintReceiptHome extends StatefulWidget {
//   final List<Map<String, dynamic>> data;
//   PrintReceiptHome(this.data);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<PrintReceiptHome> {
//   PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
//   List<PrinterBluetooth> _devices = [];
//   String _devicesMsg;
//   BluetoothManager bluetoothManager = BluetoothManager.instance;

//   @override
//   void initState() {
//     if (Platform.isAndroid) {
//       bluetoothManager.state.listen((val) {
//         if (!mounted) return;
//         if (val == 12) {
//           initPrinter();
//         } else if (val == 10) {
//           setState(() => _devicesMsg = 'Bluetooth Disconnect!');
//         }
//       });
//     } else {
//       initPrinter();
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Print'),
//       ),
//       body: _devices.isEmpty
//           ? Center(child: Text(_devicesMsg ?? ''))
//           : ListView.builder(
//               itemCount: _devices.length,
//               itemBuilder: (c, i) {
//                 return ListTile(
//                   leading: Icon(Icons.print),
//                   title: Text(_devices[i].name),
//                   subtitle: Text(_devices[i].address),
//                   onTap: () {
//                     _startPrint(_devices[i]);
//                   },
//                 );
//               },
//             ),
//       bottomNavigationBar: MaterialButton(
//           onPressed: () => initPrinter(), child: Text("Scan Print")),
//     );
//   }

//   void initPrinter() async {
//     _printerManager.startScan(Duration(seconds: 5));
//     _printerManager.scanResults.listen((val) {
//       print(val);
//       if (!mounted) return;
//       setState(() => _devices = val);
//       if (_devices.isEmpty) setState(() => _devicesMsg = 'No Devices');
//     });
//   }

//   Future<void> _startPrint(PrinterBluetooth printer) async {
//     _printerManager.selectPrinter(printer);
//     final result =
//         await _printerManager.printTicket(await _ticket(PaperSize.mm80));
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         content: Text(result.msg),
//       ),
//     );
//   }

//   Future<Ticket> _ticket(PaperSize paper) async {
//     final ticket = Ticket(paper);
//     int total = 0;

//     // Image assets
//     final ByteData data = await rootBundle.load('images/logo.png');
//     final Uint8List bytes = data.buffer.asUint8List();
//     final Image image = decodeImage(bytes);
//     ticket.image(image);
//     ticket.text(
//       'TOKO KU',
//       styles: PosStyles(
//           align: PosAlign.center,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2),
//       linesAfter: 1,
//     );

//     for (var i = 0; i < widget.data.length; i++) {
//       total += widget.data[i]['total'];
//       ticket.text(widget.data[i]['title']);
//       ticket.row([
//         PosColumn(
//             text: '${widget.data[i]['price']} x ${widget.data[i]['qty']}',
//             width: 6),
//         PosColumn(text: 'Rp ${widget.data[i]['total']}', width: 6),
//       ]);
//     }

//     ticket.feed(1);
//     ticket.row([
//       PosColumn(text: 'Total', width: 6, styles: PosStyles(bold: true)),
//       PosColumn(text: 'Rp $total', width: 6, styles: PosStyles(bold: true)),
//     ]);
//     ticket.feed(2);
//     ticket.text('Thank You',
//         styles: PosStyles(align: PosAlign.center, bold: true));
//     ticket.cut();

//     return ticket;
//   }

//   @override
//   void dispose() {
//     _printerManager.stopScan();
//     super.dispose();
//   }
// }
