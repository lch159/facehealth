import 'dart:async';

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
  TextEditingController _usernameController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  var _isObscure = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
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

  Widget _buildNameTextField(BuildContext context) {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person,
          color: Colors.black87,
        ),
        labelText: '请输入你的用户名',
        labelStyle: TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.black87,
        ),
        labelText: '请输入你的密码',
        labelStyle: TextStyle(color: Colors.black87),
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
          onPressed: _login,
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
            Routes.router.navigateTo(context, '/register', //跳转路径
                transition: TransitionType.fadeIn //过场效果
                );
          },
        ),
      ),
    );
  }

  Future<void> _login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_usernameController.text.trim().length == 0 ||
        _passwordController.text.trim().length == 0) {
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
      return;
    }
    FormData loginFormData = new FormData.from({
      "username": _usernameController.text,
      "password": _passwordController.text,
    });

    String ip = sharedPreferences.getString("ip").trim();
    String port = sharedPreferences.getString("port").trim();
    String url = "http://" + ip + ":" + port + "/user/login";
    print(url);

    Dio dio = new Dio();
    Response response = await dio.post(url, data: loginFormData);

    Map<String, dynamic> data = response.data;
    if (data["result"] == "失败") {
      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(data["message"]),
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
      return;
    } else {
      sharedPreferences.setString("token", data["token"]);
      sharedPreferences.setBool("isLogin", true);
      sharedPreferences.setString("username", _usernameController.text);

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
