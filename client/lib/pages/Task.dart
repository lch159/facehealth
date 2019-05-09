import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
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
                        "这里是任务名称",
                        style: TextStyle(fontSize: 25.0, color: Colors.black),
                      )),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "这里是任务ID",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "这里是任务类型",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        "这里是任务时间",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                  DownloadRow(
                    status: "finish",
                    text: "这里是任务描述",
                    percentage: "100.0",
                  ),
                  DownloadRow(
                    status: "finish",
                    text: "这里是任务描述",
                    percentage: "100.0",
                  ),
                  DownloadRow(
                    status: "downloading",
                    text: "这里是任务描述",
                    percentage: "60.0",
                  ),
                  DownloadRow(
                    status: "wait",
                    text: "这里是任务描述",
                    percentage: "0.0",
                  ),
                  DownloadRow(
                    status: "wait",
                    text: "这里是任务描述",
                    percentage: "0.0",
                  ),
                ],
              ),
            ),
          ),
          FlatButton(onPressed: (){}, child: Text("点击下载图片",style: TextStyle(color: Colors.white),),color: Colors.blue,),

        ],
      ),
    ));
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
