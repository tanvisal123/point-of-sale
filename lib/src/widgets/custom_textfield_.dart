import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Widget leading;
  final String number;
  final String currency;
  final bool isReadOnly;
  final bool isFocus;
  final TextInputType textInputType;
  final String hintext;
  final Color color;
  final Function(String) onChange;
  final Function onPress;
  final TextEditingController controller;

  const CustomTextField({
    Key key,
    this.leading,
    this.number,
    this.currency,
    this.isReadOnly,
    this.controller,
    this.isFocus,
    this.hintext,
    this.color,
    this.onChange,
    this.textInputType,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController(text: '0.00');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10.0),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: color ?? Colors.white,
            border: Border.all(width: 0.1),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: 0,
                color: Colors.grey,
                offset: Offset(0, 3),
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 8),
            Flexible(
              child: Container(
                width: double.infinity,
                child: leading ?? Text('Label'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              ':',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            Flexible(
              flex: 1,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(),
                child: TextField(
                  onTap: onPress,
                  onChanged: onChange,
                  keyboardType: textInputType,
                  autofocus: isFocus ?? false,
                  readOnly: isReadOnly ?? true,
                  controller: controller ?? _controller,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                    hintText: hintext,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                width: double.infinity,
                child: Text(
                  currency ?? 'currency',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
