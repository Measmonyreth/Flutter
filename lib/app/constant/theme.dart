import 'package:flutter/material.dart';

ThemeData get lightTheme => ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF1F5F9),

  colorScheme: ColorScheme.light(
    primary: const Color.fromARGB(255, 28, 175, 255),
    secondary: const Color.fromARGB(255, 36, 151, 244),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFFFFF), // AppBar background
    foregroundColor: Color(0xFF1E293B), // Icons & title color
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Color(0xFF1E293B),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: Color(0xFF1E293B)),
  ),

  // ✅ Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFFFFFF), // Bar background
    selectedItemColor: Color.fromARGB(255, 28, 175, 255), // Active icon/label
    unselectedItemColor: Color(0xFF94A3B8), // Inactive icon/label
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    unselectedLabelStyle: TextStyle(fontSize: 12),
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF1E293B)),
    bodySmall: TextStyle(color: Color(0xFF94A3B8)),
  ),
);

ThemeData get darkTheme => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 53, 53, 53),

  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 28, 175, 255),
    secondary: const Color.fromARGB(255, 36, 151, 244),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 48, 48, 48), // Darker than scaffold
    foregroundColor: Color(0xFFE2E8F0),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Color(0xFFE2E8F0),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: Color(0xFFE2E8F0)),
  ),

  // ✅ Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 48, 48, 48), // Darker than scaffold
    selectedItemColor: Color.fromARGB(255, 28, 175, 255),
    unselectedItemColor: Color(0xFF64748B),
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    unselectedLabelStyle: TextStyle(fontSize: 12),
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFE2E8F0)),
    bodySmall: TextStyle(color: Color(0xFF64748B)),
  ),
);
