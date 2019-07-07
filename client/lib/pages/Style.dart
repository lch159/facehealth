import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:facehealth/config/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StylePage extends StatefulWidget {
  @override
  _StylePageState createState() => _StylePageState();
}

List<CameraDescription> cameras;

class _StylePageState extends State<StylePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar();
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        StyleTypeCard(
          icon: Icons.camera_alt,
          type: "AI体检",
          description: "拍摄人脸部照片来监控人体健康状况",
        ),
        StyleTypeCard(
          icon: Icons.camera,
          type: "美化风格",
          description: "人脸表情变换，风格迁移",
        ),
        StyleTypeCard(
          icon: Icons.face,
          type: "明星相似度",
          description: "查看你和哪个明星人脸最像",
        ),
      ],
    );
  }
}

class StyleTypeCard extends StatefulWidget {
  StyleTypeCard({
    this.icon,
    this.type,
    this.description,
  });

  final IconData icon;
  final String type;
  final String description;

  @override
  _StyleTypeCardState createState() => _StyleTypeCardState();
}

class _StyleTypeCardState extends State<StyleTypeCard> {
  String _selectGender = "男";

  var _selectAge = "";

  File _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new ClipOval(
                  child: new SizedBox(
                    width: 75.0,
                    height: 75.0,
                    child: Container(
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                      ),
                      color: Colors.blue,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.centerLeft,
                      child: Text(
                        widget.type,
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    Text(
                      widget.description,
                      style: TextStyle(fontSize: 15.0, color: Colors.black38),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                Icon(Icons.chevron_right, color: Colors.black45)
              ],
            ),
          ),
        ),
      ),
      onTap: () async {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        if (sharedPreferences.getBool("isLogin")) {
          String data = json.encode({
            'type': widget.type,
            'age': _selectAge,
            'gender': _selectGender,
            'description': widget.description
          });
          Routes.router.navigateTo(context, '/styleinfo/$data', //跳转路径
              transition: TransitionType.fadeIn);
        } else {
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('还未登录是否要现在登录'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Routes.router.navigateTo(context, '/login', //跳转路径
                          transition: TransitionType.fadeIn);
                    },
                  ),
                  FlatButton(
                    child: Text('取消'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
