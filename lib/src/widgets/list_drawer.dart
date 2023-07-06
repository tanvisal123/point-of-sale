import 'package:flutter/material.dart';

class ListDrawer extends StatelessWidget {
  final IconData leading;
  final String label;
  final Function onTap;
  final bool selected;
  final Color selectedColor;
  const ListDrawer({
    this.leading,
    this.label,
    this.onTap,
    this.selected = false,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedTileColor: selectedColor,
      leading: Icon(leading ?? Icon(Icons.home)),
      title: Text(label ?? 'Label'),
      onTap: onTap,
    );
  }
}
