import 'package:flutter/material.dart';

class PosListTile extends StatelessWidget {
  final IconData leading;
  final String title;
  final IconData trailing;
  final Function action;

  PosListTile({
    this.leading,
    this.title,
    this.trailing,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: Icon(trailing, size: 17),
      onTap: action,
    );
  }
}
