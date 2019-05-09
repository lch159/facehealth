import 'package:facehealth/config/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class TaskProgressPage extends StatefulWidget {
  @override
  _TaskProgressPageState createState() => _TaskProgressPageState();
}

class _TaskProgressPageState extends State<TaskProgressPage> {
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
              children: <Widget>[
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
                _taskCard(context),
              ],
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

  Widget _taskCard(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text("这里是任务名称"),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Align(alignment:Alignment.centerLeft,child: Text("这里是任务类型")),
                  Align(alignment:Alignment.centerLeft,child: Text("这里是任务状态")),
                  Align(alignment:Alignment.centerLeft,child: Text("这里是任务时间")),
                ],
              ),
              Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black38,
                    )
                  ],
                ),
              ],)
            ],
          ),
        ),
      ),
      onTap: () {
        Routes.router.navigateTo(
          context, 'task', //跳转路径
          transition: TransitionType.inFromRight, //过场效果

        );
      },
    );
  }
}
