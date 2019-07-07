import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  TextEditingController repasswordController = new TextEditingController();

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
      title: Text("注册"),
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
          child: Form(
            child: Column(
              children: <Widget>[
                _buildNameTextField(context),
                _buildPasswordTextField(context),
                _buildRePasswordTextField(context),
                _buildRegisterButton(context),
              ],
            ),
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
      controller: nameController,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.black87,
          ),
          labelText: '请输入你的用户名',
          labelStyle: TextStyle(
            color: Colors.black87,
          )),
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.black87,
        ),
        labelText: '请输入你的密码',
        labelStyle: TextStyle(
          color: Colors.black87,
        ),
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

  Widget _buildRePasswordTextField(BuildContext context) {
    return TextFormField(
      controller: repasswordController,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.black87,
        ),
        labelText: '请再次输入你的密码',
        labelStyle: TextStyle(
          color: Colors.black87,
        ),
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
          onPressed: register,
        ),
      ),
    );
  }

  void register() async {
    if (passwordController.text != repasswordController.text) {
      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('密码不一致'),
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
      FormData loginFormData = new FormData.from({
        "username": nameController.text,
        "password": passwordController.text,
      });

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String ip = sharedPreferences.getString("ip");
      String port = sharedPreferences.getString("port");
      Dio dio = new Dio();
      Response response = await dio.post(
          "http://" + ip + ":" + port + "/user/register",
          data: loginFormData);

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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog<Null>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('注册成功'),
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
    }
  }
}
