import 'dart:convert';

import 'package:facehealth/pages/Home.dart';
import 'package:facehealth/pages/Login.dart';
import 'package:facehealth/pages/Register.dart';
import 'package:facehealth/pages/Style.dart';
import 'package:facehealth/pages/StyleInfo.dart';
import 'package:facehealth/pages/Task.dart';
import 'package:facehealth/pages/TaskProgress.dart';
import 'package:fluro/fluro.dart';

class Routes {
  static Router router;

  static void configureRoutes(Router router) {
    router.define('/',
        handler: Handler(handlerFunc: (context, params) => HomePage()));
    router.define('/style',
        handler: Handler(handlerFunc: (context, params) => StylePage()));
    router.define('/login',
        handler: Handler(handlerFunc: (context, params) => LoginPage()));
    router.define('/register',
        handler: Handler(handlerFunc: (context, params) => RegisterPage()));
    router.define('/taskProgress',
        handler: Handler(handlerFunc: (context, params) => TaskProgressPage()));
    router.define('/task/:data',
        handler: Handler(handlerFunc: (context, Map<String, dynamic> params) {
      Map<String, dynamic> data = json.decode(params['data'][0]);

      return TaskPage(
        filename:data['filename'],
        type: data['type'],
        time: data['time'],
        age: data['age'],
        sex: data['sex'],
        id: data['id'],
        imageID:data['imageID'],
      );
    }));
    router.define('/styleinfo/:data',
        handler: Handler(handlerFunc: (context, Map<String, dynamic> params) {
      Map<String, dynamic> data = json.decode(params['data'][0]);

      return StyleInfoPage(
        type: data['type'],
        description: data['description'],
      );
    }));
    Routes.router = router;
  }
}
