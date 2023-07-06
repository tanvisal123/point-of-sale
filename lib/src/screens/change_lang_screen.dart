import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/bloc/lang_bloc/language_bloc.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Language { en, km }

class ChangeLangScreen extends StatefulWidget {
  const ChangeLangScreen({Key key}) : super(key: key);

  @override
  _ChangeLangScreenState createState() => _ChangeLangScreenState();
}

class _ChangeLangScreenState extends State<ChangeLangScreen> {
  Language _language = Language.en;
  Future<void> _getLanguage() async {
    var _prefs = await SharedPreferences.getInstance();
    var _countryCode = _prefs.getString('conCode') ?? 'US';
    print('CountryCode = $_countryCode');
    if (_countryCode == 'US') {
      setState(() => _language = Language.en);
    } else {
      setState(() => _language = Language.km);
    }
  }

  @override
  void initState() {
    super.initState();
    _getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    var _translat = AppLocalization.of(context);
    final _langBloc = BlocProvider.of<LanguageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _translat.getTranValue('change_lang'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8.0),
            RadioListTile<Language>(
              title: Text('ភាសាខ្មែរ'),
              value: Language.km,
              groupValue: _language,
              onChanged: (Language value) {
                _language = value;
                print("language:$_language");
                _langBloc.add(LoadLanguage(Locale(value.toString(), 'KH')));
              },
            ),
            Divider(color: Theme.of(context).primaryColor),
            RadioListTile<Language>(
              title: Text('English'),
              value: Language.en,
              groupValue: _language,
              onChanged: (Language value) {
                _language = value;
                print("language:$_language");
                _langBloc.add(LoadLanguage(Locale(value.toString(), 'US')));
              },
            ),
            Divider(color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }
}
