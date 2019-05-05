import 'package:dio/dio.dart';
import 'package:facehealth/config/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  var _isObscure = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("登录"),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            width: 0.0,
            height: 0.0,
          ),
          flex: 1,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              _buildNameTextField(context),
              _buildPasswordTextField(context),
              _buildLoginButton(context),
              _buildRegisterButton(context),
            ],
          ),
          flex: 8,
        ),
        Expanded(
          child: Container(
            width: 0.0,
            height: 0.0,
          ),
          flex: 1,
        ),
      ],
    );
  }

//  Widget _buildLogoImage(BuildContext context) {
//    return Container(
//      width: 72.0,
//      height: 72.0,
//      color: Colors.blue,
//    );
//  }

  Widget _buildNameTextField(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: '请输入你的用户名',
      ),
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        labelText: '请输入你的密码',
        suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _isObscure ? Colors.black45 : Colors.blue,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }),
      ),
      obscureText: _isObscure,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 10,
        ),
        child: RaisedButton(
          color: Colors.green,
          child: Text(
            '登录',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          onPressed: login,
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 10,
        ),
        child: RaisedButton(
          color: Colors.blue,
          child: Text(
            '注册',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          onPressed: () {
            Routes.router.navigateTo(context, 'register', //跳转路径
                transition: TransitionType.fadeIn //过场效果
                );
          },
        ),
      ),
    );
  }

  void login() async {
    if (nameController.text.trim().length == 0 ||
        passwordController.text.trim().length == 0) {
      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('账号或密码为空'),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    FormData loginFormData = new FormData.from({
      "name": nameController.text,
      "password": passwordController.text,
    });

    Dio dio = new Dio();
    Response response = await dio.post("http://106.14.1.150:8080/user/login",
        data: loginFormData);

    Map<String, dynamic> data = response.data;
    print(data);
    if (data.containsKey("message")) {
      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('账号或密码错误'),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("token", data["token"]);
      sharedPreferences.setString("id", data["user"]["id"].toString());
      sharedPreferences.setString("name", data["user"]["name"]);
      sharedPreferences.setBool("isLogin", true);

      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('登录成功'),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                 Routes.router.pop(context);
                 Routes.router.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
