import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';

HawkFabMenu buildHawkFabMenu(BuildContext context) {
  return HawkFabMenu(
    icon: AnimatedIcons.menu_arrow,
    fabColor: Colors.yellow,
    iconColor: Colors.green,
    items: [
      HawkFabMenuItem(
        label: 'Menu 1',
        ontap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menu 1 selected')),
          );
        },
        icon: const Icon(Icons.home),
        color: Colors.red,
        labelColor: Colors.blue,
      ),
      HawkFabMenuItem(
        label: 'Menu 2',
        ontap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menu 2 selected')),
          );
        },
        icon: const Icon(Icons.comment),
        labelColor: Colors.white,
        labelBackgroundColor: Colors.blue,
      ),
      HawkFabMenuItem(
        label: 'Menu 3 (default)',
        ontap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menu 3 selected')),
          );
        },
        icon: const Icon(Icons.add_a_photo),
      ),
    ],
    body: const Center(
      child: Text('Center of the screen'),
    ),
  );
}
