import 'dart:typed_data';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:image/image.dart' as IMG;
import 'package:image/image.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:point_of_sale/src/helpers/printers/utils.dart';
//import 'package:wifi/wifi.dart';

class NetPrinterScreen extends StatefulWidget {
  @override
  _NetPrinterScreenState createState() => _NetPrinterScreenState();
}

class _NetPrinterScreenState extends State<NetPrinterScreen> {
  //============================Service Network Printer====================
  String localIp = '';
  List<String> devices = [];
  bool isDiscovering = false;
  int found = -1;
  TextEditingController portController = TextEditingController(text: '9100');
  void discover(BuildContext contect) async {
    setState(() {
      isDiscovering = true;
      devices.clear();
      found = -1;
    });

    String ip;
    try {
      //ip = await Wifi.ip;
      print('local ip:\t$ip');
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('WiFi is not connected', textAlign: TextAlign.center),
      );
      ScaffoldMessenger.of(contect).showSnackBar(snackBar);
      return;
    }
    setState(() {
      localIp = ip;
    });

    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    int port = 9100;
    try {
      port = int.parse(portController.text);
    } catch (e) {
      portController.text = port.toString();
    }
    print('subnet:\t$subnet, port:\t$port');

    final stream = NetworkAnalyzer.discover2(subnet, port);

    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}');
        setState(() {
          devices.add(addr.ip);
          found = devices.length;
        });
      }
    })
      ..onDone(() {
        setState(() {
          isDiscovering = false;
          found = devices.length;
        });
      })
      ..onError((dynamic e) {
        final snackBar = SnackBar(
            content: Text('Unexpected exception', textAlign: TextAlign.center));
        ScaffoldMessenger.of(contect).showSnackBar(snackBar);
      });
  }

  Future<void> printDemoReceipt(NetworkPrinter printer) async {
    // Print image
    setState(() {
      final Uint8List byte = resizeImage(bytes1);
      final image = decodeImage(byte);
      printer.imageRaster(image);
    });

    printer.feed(1);
    printer.cut();
  }

  void testPrint(String printerIp, BuildContext context) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final res = await printer.connect(printerIp, port: 9100);

    if (res == PosPrintResult.success) {
      // DEMO RECEIPT
      await printDemoReceipt(printer);
      // TEST PRINT
      //await testReceipt(printer);
      printer.disconnect();
    }
    final snackBar =
        SnackBar(content: Text(res.msg, textAlign: TextAlign.center));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  GlobalKey key1;
  Uint8List bytes1;
  //============================end Service Network Printer====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Printers'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 500,
                  child: Builder(
                    builder: (BuildContext context) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //==========================
                            TextField(
                              controller: portController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Port',
                                hintText: 'Port',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Local ip: $localIp',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 15),
                            MaterialButton(
                              child: Text(
                                '${isDiscovering ? 'Discovering...' : 'Discover'}',
                              ),
                              onPressed: isDiscovering
                                  ? null
                                  : () => discover(context),
                            ),
                            SizedBox(height: 15),
                            found >= 0
                                ? Text('Found: $found device(s)',
                                    style: TextStyle(fontSize: 16))
                                : Container(),
                            Expanded(
                              child: ListView.builder(
                                itemCount: devices.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () =>
                                        testPrint(devices[index], context),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 60,
                                          padding: EdgeInsets.only(left: 10),
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.print),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      '${devices[index]}:${portController.text}',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      'Click to print a test receipt',
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Icon(Icons.chevron_right),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            //=============================================
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).accentColor,
        padding: EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          child: MaterialButton(
            color: Colors.white,
            child: Text('Capture'),
            onPressed: () async {
              final dynamic bytes1 = await Utils.capture(key1);
              setState(() {
                this.bytes1 = bytes1;
              });
            },
          ),
        ),
      ),
    );
  }

  Uint8List resizeImage(Uint8List data) {
    Uint8List resizedData = data;
    final IMG.Image img = IMG.decodeImage(data);
    final IMG.Image resized = IMG.copyResize(img, width: 600);
    resizedData = IMG.encodeJpg(resized);
    return resizedData;
  }
}
