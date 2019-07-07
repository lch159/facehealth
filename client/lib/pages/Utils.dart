import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Object login(String name, String password) async {
    FormData loginFormData = new FormData.from({
      "name": name,
      "password": password,
    });

    Dio dio = new Dio();
    Response response = await dio.post("http://106.14.1.150:8080/user/login",
        data: loginFormData);

    Map<String, dynamic> data = response.data;

    return data;
  }

  static Object register(String name, String password) async {
    FormData loginFormData = new FormData.from({
      "name": name,
      "password": password,
    });

    Dio dio = new Dio();
    Response response = await dio.post("http://106.14.1.150:8080/user/register",
        data: loginFormData);

    Map<String, dynamic> data = response.data;

    return data;
  }

  static Future<void> initialSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.setString("token", "");
    sharedPreferences.setString("id", "");
    sharedPreferences.setString("username", "");
    sharedPreferences.setBool("isLogin", false);
    sharedPreferences.setString("ip", "10.0.2.2");
    sharedPreferences.setString("port", "8080");
//    sharedPreferences.setStringList("tasks", new List());//(task,token)
  }
}
