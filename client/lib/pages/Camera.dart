import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatelessWidget {
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
        CameraTypeCard(
          icon: Icons.camera_alt,
          name: "AI体检",
          description: "通过拍摄人的脸部照片来监控人体健康状况",
        ),
        CameraTypeCard(
          icon: Icons.camera,
          name: "美化风格",
          description: "人脸表情变换，风格迁移",
        ),
      ],
    );
  }
}

class CameraTypeCard extends StatelessWidget {
  CameraTypeCard({this.icon, this.name, this.description});

  final IconData icon;
  final String name;
  final String description;

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
                        icon,
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
                        name,
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    Text(
                      description,
                      style: TextStyle(fontSize: 15.0, color: Colors.black45),
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
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                children: <Widget>[
                  FlatButton(
                    child: Text('拍照'),
                    onPressed: () async {
                      Navigator.of(context).pop();

                      await ImagePicker.pickImage(source: ImageSource.camera);
                    },
                  ),
                  FlatButton(
                    child: Text('从相册选取'),
                    onPressed: () async {
                      Navigator.of(context).pop();

                      await ImagePicker.pickImage(source: ImageSource.camera);
                    },
                  ),
                ],
              );
            });
      },
    );
  }
}
