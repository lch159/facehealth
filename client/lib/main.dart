import 'package:facehealth/config/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

void main() {
  ///初始化并配置路由
  final router = new Router();
  Routes.configureRoutes(router);
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: Routes.router.generator);
  }
}
