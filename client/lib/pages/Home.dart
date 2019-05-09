import 'package:facehealth/config/routes.dart';
import 'package:facehealth/pages/Utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  var _isLogin = false;
  var _name = "";
  ///初始化屏幕数据

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.initialSharedPreference();
    _getSharedPreference();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _getSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
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
          child: IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              Routes.router.navigateTo(
                context, 'taskProgress', //跳转路径
                transition: TransitionType.inFromRight, //过场效果

              );
            },
          ),
        ),
      ],
    );
  }

  Widget  _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.apps,color: Colors.black,), title: Text("主页",style: TextStyle(color: Colors.black),)),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline,color:Colors.black), title: Text("我的",style: TextStyle(color: Colors.black),)),
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
        Routes.router.navigateTo(context, 'camera', //跳转路径
            transition: TransitionType.fadeIn //过场效果
            );
      },
      isExtended: true,
      backgroundColor: Colors.blue,
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Container(
                          color: Colors.white,
                        )),
                  );
                },
              );
            }).toList(),
            height: 150.0,
            autoPlay: true,
          ),
          Column(
            children: _generateNews(),
          )
        ],
      ),
    );
  }

  Widget _buildUserPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: SizedBox(
                    width: 75.0,
                    height: 75.0,
                    child: Container(
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _isLogin
                      ? Text(
                          _name,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w700),
                        )
                      : Text(
                          "还未登录，点击登录",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w700),
                        ),
                ),
              ],
            ),
            onTap: () {
              print(_isLogin);
              if (!_isLogin)
                Routes.router.navigateTo(context, 'login', //跳转路径
                    transition: TransitionType.fadeIn //过场效果
                    );
            },
          ),
          Divider(),
          Card(
            child: Column(
              children: <Widget>[
                _buildSingleRow(context, "体检日志", true, null),
                _buildSingleRow(context, "任务进度", true, null),
                _buildSingleRow(context, "历史照片", true, null),
                _buildSingleRow(context, "设置", false, null),
              ],
            ),
          ),
          _isLogin
              ? Card(
                  child: _buildSingleRow(context, "退出登录", false, () {
                    showDialog<Null>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('退出成功'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('确定'),
                              onPressed: () {
                                Routes.router.pop(context);
                                Utils.initialSharedPreference();
                                setState(() {
                                  _isLogin = false;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                    initState();
                  }),
                )
              : Container(
                  width: 0.0,
                  height: 0.0,
                ),
        ],
      ),
    );
  }

  List<NewsCard> _generateNews() {
    List<NewsCard> _items = List<NewsCard>();
    setState(() {
      for (int i = 0; i < 7; i++)
        _items.add(
          NewsCard(
            title: "这里是标题",
            description:
                "这里是文章摘要这里是文章摘要这里是文章摘要这里是文章摘要这里是文章摘要这里是文章摘要这里是文章摘要这里是文章摘要这里是文章摘要",
          ),
        );
    });
    return _items;
  }

  Widget _buildSingleRow(BuildContext context, String text, bool isDivided,
      VoidCallback callback) {
    return Column(
      children: <Widget>[
        FlatButton(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: 17.0),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
          onPressed: callback,
        ),
        isDivided
            ? Divider(
                height: 10.0,
              )
            : Container(
                width: 0.0,
                height: 5.0,
              ),
      ],
    );
  }

  void _getSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (sharedPreferences.getBool("isLogin")) {
        _isLogin = true;
        _name = sharedPreferences.getString("name");
      }
    });
  }
}

class NewsCard extends StatelessWidget {
  NewsCard({this.title, this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Card(
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            child: Container(
              width: 75.0,
              color: Colors.white,
            ),
          ),
          title: Text(
            title,
            textAlign: TextAlign.left, //文本对齐方式  居中
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
          ),
          subtitle: Text(
            description,
            style: TextStyle(fontSize: 15.0, color: Colors.black38),
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
