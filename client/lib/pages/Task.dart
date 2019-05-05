import 'package:flutter/material.dart';

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
      title: Text("任务进度"),
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
              _taskCard(context),
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

  Widget _taskCard(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text("这里是任务名称"),
          subtitle: Text("这里是任务类型"),
        ),
      ),
      onTap: () {},
    );
  }
}
