import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facehealth/config/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seekbar/seekbar/seekbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StyleInfoPage extends StatefulWidget {
  StyleInfoPage({
    this.type,
    this.description,
  });

  final String type;
  final String description;

  @override
  _StyleInfoPageState createState() => _StyleInfoPageState();
}

class _StyleInfoPageState extends State<StyleInfoPage> {
  String _selectGender = "性别";

  double _selectAge = 0.0;

  File _image;

  double percentage = 0.00;

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
      title: Text("任务详情"),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.type,
                        style: TextStyle(fontSize: 25.0, color: Colors.black),
                      )),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.description,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PopupMenuButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _selectGender,
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                              value: '男',
                              child: Text(
                                '男',
                                style: TextStyle(fontSize: 18.0),
                              )),
                          PopupMenuItem<String>(
                              value: '女',
                              child: Text(
                                '女',
                                style: TextStyle(fontSize: 18.0),
                              )),
                          PopupMenuItem<String>(
                              value: '其他',
                              child: Text(
                                '其他',
                                style: TextStyle(fontSize: 18.0),
                              )),
                        ];
                      },
                      onSelected: (String value) {
                        setState(() {
                          _selectGender = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '年龄',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: 200,
                                  child: SeekBar(
                                    indicatorRadius: 0.0,
                                    progresseight: 8,
                                    value: _selectAge,
                                    hideBubble: false,
                                    alwaysShowBubble: true,
                                    bubbleRadius: 9,
                                    bubbleColor: Colors.blue,
                                    bubbleTextColor: Colors.white,
                                    bubbleTextSize: 12,
                                    bubbleMargin: 4,
                                    bubbleInCenter: true,
                                    onValueChanged: (value) {
                                      setState(() {
                                        _selectAge = value.value;
                                      });
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 300.0,
                    height: 300.0,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _selectPhoto(context);
                        });
                      },
                      child: _image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.add),
                                Text("点击添加图像")
                              ],
                            )
                          : Image.file(
                              _image,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              if (_image == null || _selectGender == "" || _selectAge == "") {
                showDialog<Null>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('信息不完整，请检查'),
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
                showDialog<Null>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(content: LinearProgressIndicator());
                  },
                );
                _uploadFile();
              }
            },
            child: Text(
              "确定",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
          ),
        ],
      ),
    ));
  }

  Future<void> _uploadFile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String _selectType = "";
    switch (widget.type) {
      case "AI体检":
        _selectType = "1";
        break;
      case "美化风格":
        _selectType = "2";
        break;
      case "明星相似度":
        _selectType = "3";
        break;
    }
    String gender = "";
    switch (_selectGender) {
      case "男":
        gender = "1";
        break;
      case "女":
        gender = "2";
        break;
      default:
        gender = "0";
        break;
    }
    String _info =
        _selectType + "_" + _selectAge.ceil().toString() + "_" + gender;

    var suffixArr = _image.path.toString().split("/");
    var filenameArr = suffixArr[suffixArr.length - 1].split(".");
    var suffix = filenameArr[filenameArr.length - 1];
    var token = sharedPreferences.getString("token");
    FormData formData = new FormData.from({
      "file": UploadFileInfo(_image, suffixArr[suffixArr.length - 1]),
      "token": token,
      "info": _info
    });

    String ip = sharedPreferences.getString("ip");
    String port = sharedPreferences.getString("port");

//    if(sharedPreferences.getStringList("task")==null)
//      {
//        List<String> tmp =new List();
//        tmp.add(token);
//        sharedPreferences.
//        sharedPreferences.setStringList("task",tmp);
//      }
    try {
      Dio dio = new Dio(new BaseOptions(
        contentType: ContentType("multipart", "form-data"),
      ));
      String uri = "http://" + ip + ":" + port + "/function/uploadImage";
      Response response = await dio.post(
        uri,
        data: formData,
        onSendProgress: (int sent, int total) async {
          if (sent == total) Navigator.of(context).pop();
//          print((sent * 100 / total).toStringAsFixed(2) + "%");
//          print("$sent $total");
        },
      );
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
        showDialog<Null>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('上传成功，是否立即查看进度'),
              actions: <Widget>[
                FlatButton(
                  child: Text('确定'),
                  onPressed: () {
                    Routes.router.pop(context);
                    Routes.router.pop(context);
                    Routes.router.navigateTo(context, 'task', //跳转路径
                        transition: TransitionType.fadeIn);
                  },
                ),
              ],
            );
          },
        );
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      print(e.response.statusCode);
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);

      // Something happened in setting up or sending the request that triggered an Error
      print(e.request);
      print(e.message);
    }
  }

  File _selectPhoto(BuildContext context) {
    File image;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              FlatButton(
                child: Text('拍照'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  image =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    _image = image;
                  });
                },
              ),
              FlatButton(
                child: Text('从相册选取'),
                onPressed: () async {
                  Navigator.of(context).pop();

                  image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _image = image;
                  });
                },
              ),
            ],
          );
        });
    return image;
  }
}
