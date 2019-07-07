import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:facehealth/config/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProgressPage extends StatefulWidget {
  @override
  _TaskProgressPageState createState() => _TaskProgressPageState();
}

class _TaskProgressPageState extends State<TaskProgressPage> {
  List<TaskCard> tasks = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getImages();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Future<void> _getImages() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    FormData loginFormData = new FormData.from({
      "token": sharedPreferences.getString("token"),
    });

    String ip = sharedPreferences.getString("ip").trim();
    String port = sharedPreferences.getString("port").trim();
    String url = "http://" + ip + ":" + port + "/function/getUserImages";
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
      List<dynamic> paths = data["paths"];
      List<dynamic> imageIDs = data["imageIDs"];

      for (int i = 0; i < paths.length; i++) {
        String path = paths[i];
        String imageID = imageIDs[i].toString();
        List<String> tmp = path.split("\\");//windows 服务器配置
        String filename = tmp[tmp.length - 1];

        String status = "已完成";
        setState(() {
          tasks.insert(
              0,
              TaskCard(
                filename: filename,
                status: status,
                imageID: imageID,
              ));
        });
      }
    }
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("任务进度"),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
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
              children: tasks,
            ),
            flex: 12,
          ),
          Expanded(
            child: Container(
              width: 0.0,
              height: 0.0,
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatefulWidget {
  TaskCard({
    this.status,
    this.filename,
    this.imageID,
  });

  final String status;
  final String filename;
  final String imageID;

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String type;
  String id;
  String age;
  String sex;
  String time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      parseName();
    });
  }

  void parseName() {
    List<String> name = widget.filename.split("_");
    switch (name[0]) {
      case "1":
        type = "AI体检";
        break;
      case "2":
        type = "美化风格";
        break;
      case "3":
        type = "明星相似度";
        break;
    }
    id = name[1];
    age = name[2];
    switch (name[3]) {
      case "0":
        sex = "其他";
        break;
      case "1":
        sex = "男";
        break;
      case "2":
        sex = "女";
        break;
    }
    time = DateTime.fromMillisecondsSinceEpoch(int.parse(name[4].split(".")[0]) + 28800000)
        .toString()
        .split(".")[0];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(
            type,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("用户ID:id$id",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w500))),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("任务状态:" + widget.status,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w500))),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(time,
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54))),
//                  Align(
//                      alignment: Alignment.centerLeft,
//                      child: Icon(Icons.keyboard_arrow_right,size: 15.0,color: Colors.black45,),)
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        String data = json.encode({
          'type': type,
          'filename': widget.filename,
          'time': time,
          'age': age,
          'sex': sex,
          'id': id,
          'imageID': widget.imageID
        });
        Routes.router.navigateTo(context, '/task/$data', //跳转路径
            transition: TransitionType.fadeIn);
      },
    );
  }
}
