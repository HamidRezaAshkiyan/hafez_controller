import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void loadMain() async{
    // Navigator.pushReplacementNamed(context, '/home', arguments: {});
  }

  @override
  void initState() {
    super.initState();
    loadMain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text('Loading...')
    );
  }
}
// Assertion failed: navigator.dart !_debugLocked is not true