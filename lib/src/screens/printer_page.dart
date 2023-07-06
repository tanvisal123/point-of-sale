// import 'package:flutter/material.dart';
// import 'package:flutter_session/flutter_session.dart';
// import 'package:ping_discover_network/ping_discover_network.dart';
// import 'package:point_of_sale/src/screens/sale_group_screen.dart';
// import 'package:point_of_sale/src/screens/table_group_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wifi/wifi.dart';

// class PrinterPage extends StatefulWidget {
//   const PrinterPage({Key key, @required this.ip}) : super(key: key);
//   final String ip;
//   @override
//   _PrinterPageState createState() => _PrinterPageState();
// }

// enum GroupPrinter { sunmi, network }

// class _PrinterPageState extends State<PrinterPage> {
//   GroupPrinter _groupPrinter = GroupPrinter.sunmi;
//   bool isDiscovering = false;
//   int found = -1;
//   int port;
//   List<String> devices = [];
//   String localIp = '';
//   Future<void> selectPrinter() async {
//     final _prefs = await SharedPreferences.getInstance();
//     final _printerName = _prefs.getString("printer") ?? 'sunmi';
//     print(_printerName);
//     setState(() {
//       if (_printerName == 'summi') {
//         _groupPrinter = GroupPrinter.sunmi;
//       } else if (_printerName == 'network') {
//         _groupPrinter = GroupPrinter.network;
//       } else {
//         print("No Printer");
//       }
//     });
//     print(_groupPrinter);
//   }

//   @override
//   void initState() {
//     super.initState();
//     selectPrinter();
//     getNetworkdevice();
//     port = 9100;
//   }

//   void getNetworkdevice() async {
//     setState(() {
//       isDiscovering = true;
//       devices.clear();
//       found = -1;
//     });
//     String ip;
//     try {
//       ip = await Wifi.ip;
//       print('local ip:\t$ip');
//     } catch (e) {
//       print('wifi not connect');
//       return;
//     }
//     setState(() {
//       localIp = ip;
//     });

//     final String subnet = ip.substring(0, ip.lastIndexOf('.'));
//     int port = 9100;
//     print('subnet:\t$subnet, port:\t$port');
//     final stream = NetworkAnalyzer.discover2(subnet, port);

//     stream.listen((NetworkAddress addr) {
//       if (addr.exists) {
//         print('Found device: ${addr.ip}');
//         setState(() {
//           devices.add(addr.ip);
//           found = devices.length;
//         });
//       }
//     })
//       ..onDone(() {
//         setState(() {
//           isDiscovering = false;
//           found = devices.length;
//         });
//       })
//       ..onError((dynamic e) {
//         print("Unexpected exception");
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           TextButton(
//             onPressed: () async {
//               final prefs = await SharedPreferences.getInstance();
//               var systemType = await FlutterSession().get("systemType");
//               if (_groupPrinter == GroupPrinter.sunmi) {
//                 prefs.setString('printer', 'sunmi');
//                 if (systemType == 'KRMS') {
//                   Navigator.pop(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => TableScreen(ip: widget.ip)));
//                 } else if (systemType == 'KBMS') {
//                   Navigator.pop(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => SaleGroupScreen(
//                                 ip: widget.ip,
//                                 postList: [],
//                                 type: 'G1',
//                               )));
//                 } else {
//                   print("System type: $systemType");
//                   print("Ip : ${widget.ip}");
//                 }
//               } else if (_groupPrinter == GroupPrinter.network) {
//                 prefs.setString("printer", "network");
//                 if (systemType == 'KRMS') {
//                   Navigator.pop(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => TableScreen(ip: widget.ip)));
//                 } else if (systemType == 'KBMS') {
//                   Navigator.pop(context);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => SaleGroupScreen(
//                                 ip: widget.ip,
//                                 postList: [],
//                                 type: 'G1',
//                               )));
//                 } else {
//                   print("System type: $systemType");
//                   print("Ip : ${widget.ip}");
//                 }
//               } else {
//                 print("No select Printer");
//               }
//             },
//             child: Text(
//               "SAVE",
//               style: TextStyle(fontSize: 16, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: Column(children: [
//         RadioListTile<GroupPrinter>(
//           value: GroupPrinter.sunmi,
//           title: const Text("Sunmi"),
//           groupValue: _groupPrinter,
//           onChanged: (GroupPrinter value) {
//             setState(() {
//               _groupPrinter = value;
//               print(_groupPrinter);
//             });
//           },
//         ),
//         Divider(indent: 70, color: Colors.grey, height: 0.0),
//         RadioListTile<GroupPrinter>(
//           value: GroupPrinter.network,
//           title: const Text("Network"),
//           groupValue: _groupPrinter,
//           onChanged: (GroupPrinter value) {
//             setState(() {
//               _buildAvilableNetPrinter();
//               _groupPrinter = value;
//             });
//           },
//         ),
//         Divider(indent: 70, color: Colors.grey, height: 0.0),
//       ]),
//     );
//   }

//   Future<void> _buildAvilableNetPrinter() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Printer Model'),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               children: devices.map((e) {
//                 return ListTile(
//                   onTap: () async {
//                     final _prefs = await SharedPreferences.getInstance();
//                     String ip = e;
//                     _prefs.setString('ipAdrress', ip);
//                     print('Ip Address = $ip');
//                     print('OK');
//                   },
//                   title: Text('$e : $port'),
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Approve'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
