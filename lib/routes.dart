import 'package:flutter/material.dart';
import 'package:proyectomov2023/screens/dashboard_screen.dart';

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    '/home': (BuildContext context) => const DashboardScreen(),
  };
}
