import 'package:dictation_app/Globals/constant.dart';
import 'package:dictation_app/Widgets/new_dictation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHeader extends StatefulWidget {
  final Widget textTop;
  final Widget textBottom;
  final double offset;
  final double height;
  final int left_height;
  final int right_height;
  final Color color_1;
  final Color color_2;
  final Widget left_widget;
  final Widget right_widget;
  const MyHeader(
      {Key key, this.textTop, this.textBottom, this.offset,this.height,
        this.left_height,this.right_height,this.color_1,this.color_2,this.left_widget,this.right_widget})
      : super(key: key);

  @override
  _MyHeaderState createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(widget.left_height,widget.right_height),
      child: Container(
        padding: EdgeInsets.only(left: 20, top: 50, right: 20),
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              widget.color_1,
              widget.color_2,
//              Color(0xFF3383CD),
//              Color(0xFF11249F),
            ],
          ),
//          image: DecorationImage(
//
//              alignment: Alignment.bottomLeft,
//               image: AssetImage("assets/dictation_icon.png",),//
//            ),

        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) {
//                          return InfoScreen();
//                        },
//                      ),
//                    );
                  },
                  child: widget.left_widget,
                  //Icon(Icons.b)//SvgPicture.asset("assets/icons/menu.svg"),
                ),
                widget.right_widget,
//                GestureDetector(
//                  child: Container(
//                      width: 30,
//                      height: 30,
//                      child: Image.asset("assets/menu_icon.png")
//                  ),//Icon(Icons.b)//SvgPicture.asset("assets/icons/menu.svg"),
//                ),
                //SizedBox(height: 10),


              ],
            ),

                Expanded(
                  child: Stack(
                    children: <Widget>[
//                  Positioned(
//                    top: (widget.offset < 0) ? 0 : widget.offset,
//                    child: Icon(Icons.battery_alert)
////                    SvgPicture.asset(
////                      widget.image,
////                      width: 230,
////                      fit: BoxFit.fitWidth,
////                      alignment: Alignment.topCenter,
////                    ),
//                  ),
                    widget.textTop,
                      widget.textBottom,
//                      Positioned(
//                        top: 10,
//                        left: 80,
//                        child: Text(
//                          "${widget.textTop} \n${widget.textBottom}",
//                          style: kHeadingTextStyle.copyWith(
//                            color: Colors.white,
//                            fontSize: 50,
//                            fontStyle: FontStyle.italic
//                          ),
//                        ),
//                      ),
                      Container(), // I don't know why it can't work without container
                    ],
                  ),
                ),

          ],
        ),
      ),
    );
  }
  Widget drawer_func()
  {
    return Drawer(

      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("Profile name"),
            accountEmail: new Text("Profile Email"),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.white,
              child: new Icon(Icons.account_circle, size: 60),
            ),
          ),
          new ListTile(
            title: new Text("Clear log events"),
            trailing: new Icon(Icons.clear_all),
            onTap: () {
//              setState(() {
//                //LogEvent.LogEvents.clear();
//              });
              //Navigator.of(context).pop();
            },
          ),
          new ListTile(
            title: new Text("Change wallpaper"),
            trailing: new Icon(Icons.wallpaper),
            onTap: () {
              setState(() {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) => ChangeWallpaper()),
//                                );
              });
              //Navigator.of(context).pop();
            },
          ),
          new ListTile(
            title: new Text("Work diagnostics"),
            trailing: new Icon(Icons.assignment),
            onTap: () {
              setState(() {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) => WorkDiagnostics()),
//                                );
              });
              //Navigator.of(context).pop();
            },
          ),
          new Divider(),
          new ListTile(
            title: new Text("Close"),
            trailing: new Icon(Icons.close),
            onTap: () {
//                              setState(() {
//                                LogEvent.LogEvents.clear();
//                              });
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  int left_height;
  int right_height;
  MyClipper(this.left_height,this.right_height);
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - left_height);//left_height
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - right_height);//right_height
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }}