import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'home_page.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      seconds: 2,
      navigateAfterSeconds: const HomePage(),
      title: const Text(
        '\nSudoku Fschmatz',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
      ),
      loadingText: const Text(
        'Loading',
      ),
    );
  }
}
