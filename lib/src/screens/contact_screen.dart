import 'package:flutter/material.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/widgets/drawer_widget.dart';

class ContactScreen extends StatelessWidget {
  final String ip;
  const ContactScreen({Key key, @required this.ip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _translat = AppLocalization.of(context);
    return Scaffold(
      drawer: DrawerWidget(selected: 5, ip: ip),
      appBar: AppBar(title: Text(_translat.getTranValue('contact'))),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          padding: EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      _translat.getTranValue('sale_title'),
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text(
                      '010 577 721',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '010 577 731',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Column(
                  children: [
                    Text(
                      _translat.getTranValue('services'),
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text(
                      '010 577 793',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '010 577 794',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
}
