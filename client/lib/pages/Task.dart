import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskPage extends StatefulWidget {
  TaskPage({
    this.type,
    this.time,
    this.age,
    this.sex,
    this.id,
    this.filename,
    this.imageID,
  });

  final String type;
  final String time;
  final String age;
  final String sex;
  final String id;
  final String filename;
  final String imageID;

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool _fold = true;

  String _imageInfo = "";

  Widget _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image = FlutterLogo();
  }

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
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      )),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "用户ID:" + widget.id,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "年龄:" + widget.age,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "性别:" + widget.sex,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "拍摄时间:" + widget.time,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),

                  Divider(
                    color: Colors.black54,
                  ),
                  DownloadRow(
                    status: "finish",
                    text: "上传",
                    percentage: "100.0",
                  ),
                  DownloadRow(
                    status: "finish",
                    text: "计算",
                    percentage: "100.0",
                  ),

                  _fold
                      ? Container(
                          width: 0.0,
                          height: 0.0,
                        )
                      : Column(
                          children: <Widget>[
                            _image,
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(_imageInfo),
                            ),
                          ],
                        ),

                  IconButton(
                    icon: _fold
                        ? Icon(Icons.keyboard_arrow_down)
                        : Icon(Icons.keyboard_arrow_up),
                    onPressed: () {
                      setState(() {
                        _fold = !_fold;

                        _download(
                            "G:\\\\images\\\\upload\\\\" + widget.filename,
                            widget.imageID); //本地测试用
                        int type = int.parse(widget.filename.split("_")[0]);
//                        _handle(type);
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future _handle(int type) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    FormData loginFormData = new FormData.from({
//      "imagePath": "G:\\images\\finished\\" + widget.filename,
      "token": sharedPreferences.getString("token"),
      "task": type,
    });

    String ip = sharedPreferences.getString("ip").trim();
    String port = sharedPreferences.getString("port").trim();
    String url = "http://" + ip + ":" + port + "/function/handle";

    Dio dio = new Dio();
    Response response = await dio.post(url, data: loginFormData);
    Map<String, dynamic> data = response.data;
    if (data["result"] == "失败") {
    } else {
      var path = data["handledImagePath"];

      setState(() {
        if (type == 1) {
          String tmp = path.split("_").last().split(".")[0];

          if (tmp == "1") {
            _imageInfo = "疾病:肢端肥大症-严重";
          } else if (tmp == "2") {
            _imageInfo = "疾病:肢端肥大症-中等";
          } else if (tmp == "3") {
            _imageInfo = "疾病:肢端肥大症-轻微";
          }
        } else if (type == 2) {
          _imageInfo = "";
        } else if (type == 3) {
          String tmp = path.split("_").last().split(".")[0];

          _imageInfo = "与您相似的明星:" + tmp;
        }
      });

//      _download(path, data["handledImageID"]);
    }
  }

  Future _download(String downloadPath, String imageID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String ip = sharedPreferences.getString("ip").trim();
    String port = sharedPreferences.getString("port").trim();
    String uri = "http://" + ip + ":" + port + "/function/downloadImage";
    String token = sharedPreferences.getString("token");
    String url = uri +
        "?downloadPath=" +
        downloadPath +
        "&token=" +
        token +
        "&imageID=" +
        imageID;

    setState(() {
      _image = CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fadeOutDuration: Duration(seconds: 1),
        fadeInDuration: Duration(seconds: 1),
      );
    });
  }
}

class DownloadRow extends StatefulWidget {
  DownloadRow({this.status, this.text, this.percentage});

  final String status;
  final String text;
  final String percentage;

  @override
  _DownloadRowState createState() => _DownloadRowState();
}

class _DownloadRowState extends State<DownloadRow> {
  Widget _getIcon() {
    Widget ic = Icon(
      Icons.check_box,
      size: 25.0,
      color: Colors.blue,
    );
    switch (widget.status) {
      case "finish":
        ic = Icon(
          Icons.check_box,
          size: 25.0,
          color: Colors.blue,
        );
        break;
      case "downloading":
        ic = SpinKitRing(
          color: Colors.blue,
          size: 25.0,
          lineWidth: 2.0,
        );
        break;
      case "wait":
        ic = Icon(
          Icons.check_box_outline_blank,
          size: 25.0,
          color: Colors.blue,
        );
        break;
    }
    return ic;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _getIcon(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Text(widget.text),
                LinearPercentIndicator(
                  width: ScreenUtil.getInstance().setWidth(477),
                  lineHeight: 20.0,
                  percent: double.parse(widget.percentage) / 100,
                  center: Text(
                    widget.percentage + "%",
                    style: TextStyle(color: Colors.white),
                  ),
                  progressColor: Colors.blue,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
