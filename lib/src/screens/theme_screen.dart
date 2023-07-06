import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/bloc/theme_bloc/theme_bloc.dart';
import 'package:point_of_sale/src/helpers/app_localization.dart';
import 'package:point_of_sale/src/widgets/card_custom.dart';

class ThemeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _translat = AppLocalization.of(context);
    final _theme = BlocProvider.of<ThemeBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text(_translat.getTranValue('theme'))),
      body: ListView(
        children: [
          CardCustom(
            hasLeadingCircle: false,
            cardColor: Colors.green[900],
            title: _translat.getTranValue('light_theme'),
            textColor: Colors.white,
            iconColor: Colors.white,
            leading: Icons.color_lens_sharp,
            onPress: () {
              _theme.add(GreenTheme());
            },
          ),
          CardCustom(
            hasLeadingCircle: false,
            cardColor: Colors.green[900],
            title: _translat.getTranValue('green_theme'),
            textColor: Colors.white,
            iconColor: Colors.white,
            leading: Icons.color_lens_sharp,
            onPress: () {
              _theme.add(GreenTheme());
            },
          ),

          CardCustom(
            hasLeadingCircle: false,
            cardColor: Colors.teal[900],
            title: _translat.getTranValue('teal_theme'),
            textColor: Colors.white,
            iconColor: Colors.white,
            leading: Icons.color_lens_sharp,
            onPress: () {
              _theme.add(TealTheme());
            },
          ),
          CardCustom(
            hasLeadingCircle: false,
            cardColor: Colors.red[900],
            title: _translat.getTranValue('red_theme'),
            textColor: Colors.white,
            iconColor: Colors.white,
            leading: Icons.color_lens_sharp,
            onPress: () {
              _theme.add(RedTheme());
            },
          ),
          CardCustom(
            hasLeadingCircle: false,
            cardColor: Colors.blue[900],
            title: _translat.getTranValue('blue_theme'),
            textColor: Colors.white,
            iconColor: Colors.white,
            leading: Icons.color_lens_sharp,
            onPress: () {
              _theme.add(BlueTheme());
            },
          ),
          CardCustom(
            hasLeadingCircle: false,
            cardColor: Colors.black,
            title: _translat.getTranValue('black_theme'),
            textColor: Colors.white,
            iconColor: Colors.white,
            leading: Icons.color_lens_sharp,
            onPress: () {
              _theme.add(BlackTheme());
            },
          ),
          CardCustom(
            hasLeadingCircle: false,
            cardColor: Colors.orange,
            title: _translat.getTranValue('orange_theme'),
            textColor: Colors.white,
            iconColor: Colors.white,
            leading: Icons.color_lens_sharp,
            onPress: () {
              _theme.add(OrangeTheme());
            },
          ),
        ],
      ),
    );
  }
}
