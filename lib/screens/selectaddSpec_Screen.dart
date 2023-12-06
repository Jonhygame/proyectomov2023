import 'package:flutter/material.dart';

class SelectAddSpecScreen extends StatefulWidget {
  @override
  _SelectAddSpecScreenState createState() => _SelectAddSpecScreenState();
}

class _SelectAddSpecScreenState extends State<SelectAddSpecScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Add Spec Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Button 1'),
            ),
          ],
        ),
      ),
    );
  }
}
