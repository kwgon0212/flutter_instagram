import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  iconTheme: IconThemeData(color: Colors.red[900]),
  appBarTheme: AppBarTheme(
    elevation: 1,
    titleTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
    color: Colors.white,
    actionsIconTheme: IconThemeData(color: Colors.purple[900]),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.blue[900],
      foregroundColor: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.grey,
  ),
);
