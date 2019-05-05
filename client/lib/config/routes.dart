import 'package:facehealth/pages/Home.dart';
import 'package:facehealth/pages/Login.dart';
import 'package:facehealth/pages/Register.dart';
import 'package:facehealth/pages/Task.dart';
import 'package:fluro/fluro.dart';
import 'package:facehealth/pages/Camera.dart';

class Routes {
  static Router router;

  static void configureRoutes(Router router) {
    router.define('/',
        handler: Handler(handlerFunc: (context, params) => HomePage()));
    router.define('camera',
        handler: Handler(handlerFunc: (context, params) => CameraPage()));
    router.define('login',
        handler: Handler(handlerFunc: (context, params) => LoginPage()));
    router.define('register',
        handler: Handler(handlerFunc: (context, params) => RegisterPage()));
    router.define('task',
        handler: Handler(handlerFunc: (context, params) => TaskPage()));
    Routes.router = router;
  }
}
