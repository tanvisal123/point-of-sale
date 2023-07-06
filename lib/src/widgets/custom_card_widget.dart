import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData leading;
  final Widget tralling;
  final Function onPress;
  final Color textColor;
  final Color cardColor;
  final Color iconColor;
  final bool hasLeadingCircle;

  const CustomCard(
      {Key key,
      this.title,
      this.leading,
      this.tralling,
      this.onPress,
      this.textColor,
      this.cardColor,
      this.iconColor,
      this.hasLeadingCircle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 6.0),
      child: SizedBox(
        height: 75.0,
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.all(0),
          elevation: 3,
          color: cardColor ?? Colors.white,
          child: CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            onPressed: onPress,
            child: ListTile(
              title: Text(
                title ?? 'Title',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.black,
                ),
              ),
              trailing: tralling ?? SizedBox(height: 0.0),
            ),
          ),
        ),
      ),
    );
  }
}
