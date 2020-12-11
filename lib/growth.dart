import 'package:flutter/material.dart';

class GrowthAndDemand extends StatefulWidget {
  @override
  _GrowthAndDemandState createState() => _GrowthAndDemandState();
}

class _GrowthAndDemandState extends State<GrowthAndDemand> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Coming Soon",
          style: TextStyle(color: Colors.grey.shade400,fontWeight: FontWeight.w600,fontSize: 23),
        ),
      ),
    );
  }
}
