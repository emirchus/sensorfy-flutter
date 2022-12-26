import 'package:flutter/material.dart';
import 'package:flutter_censors_manager/presentation/screens/home/home_screen.dart';
import 'package:flutter_censors_manager/presentation/screens/sensor/sensor_screen.dart';
import 'package:flutter_censors_manager/application/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: darkBackgroundColor,
        textTheme: GoogleFonts.jostTextTheme().apply(
          bodyColor: Colors.white
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primarySwatch,

        ),
        appBarTheme: AppBarTheme(
          color: backgroundColor,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.jost(
            color: white,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      title: "Sensify",
      routes: {
        "/": (context) => const HomeScreen(),
        "/sensor": (context) => const SensorScreen(),
      },
      initialRoute: "/",
    );
  }
}
