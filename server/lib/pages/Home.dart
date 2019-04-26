import 'package:facehealth/config/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Icon(Icons.file_download),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.apps), title: Text("主页")),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), title: Text("我的")),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Routes.router.navigateTo(context, '/pages/Camera', //跳转路径
            transition: TransitionType.fadeIn //过场效果
            );
      },
      isExtended: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget bodyWidget;
    switch (_currentIndex) {
      case 0:
        bodyWidget = _buildMainPage(context);
        break;
      case 1:
        bodyWidget = _buildUserPage(context);
        break;
    }
    return bodyWidget;
  }

  Widget _buildMainPage(BuildContext context) {
    return ListView(
      children: <Widget>[
        CarouselSlider(
          items: [1, 2, 3, 4, 5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Container(
                        color: Colors.blue,
                      )),
                );
              },
            );
          }).toList(),
          height: 150.0,
          autoPlay: true,
        ),
        NewsCard(title: "这里是标题",description: "这里是文章摘要xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",),
        NewsCard(title: "这里是标题",description: "这里是文章摘要xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",),
        NewsCard(title: "这里是标题",description: "这里是文章摘要xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",),
        NewsCard(title: "这里是标题",description: "这里是文章摘要xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",),
        NewsCard(title: "这里是标题",description: "这里是文章摘要xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",),
        NewsCard(title: "这里是标题",description: "这里是文章摘要xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",),
      ],
    );
  }

  Widget _buildUserPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:MainAxisAlignment.center ,
        children: <Widget>[
          new ClipOval(
            child: new SizedBox(
              width: 75.0,
              height: 75.0,
              child: Container(
                child: Icon(Icons.person_outline,color: Colors.white,),
                color: Colors.blue,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
          ),
          Text(
            "这里是用户名",
            style: TextStyle(
                fontSize: 30.0, fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
          ),
          Divider(),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  NewsCard({this.title, this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: Card(
        child: ListTile(
          leading: ClipRRect(
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            child: new Container(
              width: 100.0,
              height: 100.0,
              color: Colors.blue,
            ),
          ),
          title: Text(
            title,
            textAlign: TextAlign.left, //文本对齐方式  居中
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300),
          ),
          subtitle: Text(
            description,
            style: TextStyle(fontSize: 15.0, color: Colors.black38),
            maxLines: 4,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
