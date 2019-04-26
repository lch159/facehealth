import 'package:facehealth/pages/Home.dart';
import 'package:fluro/fluro.dart';
import 'package:facehealth/pages/Camera.dart';

class Routes {
  static Router router;

  static void configureRoutes(Router router) {
    router.define('/',
        handler: Handler(handlerFunc: (context, params) => HomePage()));
    router.define('/pages/Camera',
        handler: Handler(handlerFunc: (context, params) => CameraPage()));

    Routes.router = router;
  }
}
