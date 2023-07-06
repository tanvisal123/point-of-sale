import 'package:flutter/material.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/screens/summary_sale_screen.dart';
import 'package:point_of_sale/src/screens/summrynew_salereceipt.dart';
import 'package:point_of_sale/src/widgets/card_custom.dart';
import 'package:point_of_sale/src/widgets/drawer_widget.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key key, @required this.ip}) : super(key: key);

  final String ip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50].withOpacity(0.5),
      drawer: DrawerWidget(selected: 3, ip: ip),
      appBar: AppBar(
        title: Text(AppLocalization.of(context).getTranValue('report')),
      ),
      body: ListView(
        children: [
          CardCustom(
            title: AppLocalization.of(context).getTranValue('summary_receipt'),
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SummarySaleReceipt(ip: ip)),
              );
            },
          ),
        ],
      ),
    );
  }
}
