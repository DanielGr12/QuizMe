import 'package:dictation_app/Globals/GlobalColors.dart';
import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:dictation_app/Globals/SettingsParameters.dart';
import 'package:dictation_app/Globals/constant.dart';
import 'package:dictation_app/Widgets/my_header.dart';
import 'package:flutter/material.dart';

class MainSettings extends StatefulWidget {
  @override
  _MainSettingsState createState() => _MainSettingsState();
}

class _MainSettingsState extends State<MainSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //Adding the title
              MyHeader(
                textTop: Positioned(
                  //top: 10,
                  left: 80,
                  child: Text(
                    "Settings\n",
                    style: kHeadingTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 50,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                textBottom: Positioned(
                  top: 75,
                  left: 80,
                  child: Text(
                    "",
                    style: kHeadingTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 25,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                offset: 2,
                height: 250,
                left_height: 30,
                right_height: 100,
                color_1: Colors.orange,
                color_2: Colors.redAccent,
                left_widget: settings_left_widget(),
                right_widget: settings_right_widget(),
              ),
              new Divider(color: kTextLightColor,),
              ListTile(
                leading: GlobalParameters.DarkMode == false ? Icon(Icons.wb_sunny,size: 30,) : Icon(Icons.brightness_3,size: 30,),
                title: Text("Dark Mode"),
                trailing: Switch(value: GlobalParameters.DarkMode,onChanged: (value){

                },),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MainSettings();
                      },
                    ),
                  );
                },
              ),
              new Divider(color: kTextLightColor,),
//              Divider(
//                height: 20,
//                color: Colors.grey,
//              ),
              //Choose what will be the voice in the dictation if the person chose to enable it
//              RadioListTile(
//                value: 1,
//                groupValue: SettingParameters.boy_or_girl_group,
//                title: Text("Boy voice"),
//                onChanged: (val) {
//                  print("Radio Tile pressed $val");
//                  setState(() {
//                    SettingParameters.boy_or_girl_group = val;
//                  });
//                },
//                secondary: OutlineButton(
//                  child: Text("Say Hi"),
//                  onPressed: () {},
//                ),
//                selected: false,
//              ),
//              RadioListTile(
//                value: 2,
//                groupValue: SettingParameters.boy_or_girl_group,
//                title: Text("Girl voice"),
//                onChanged: (val) {
//                  print("Radio Tile pressed $val");
//                  setState(() {
//                    SettingParameters.boy_or_girl_group = val;
//                  });
//                },
//                secondary: OutlineButton(
//                  child: Text("Say Hi"),
//                  onPressed: () {},
//                ),
//                selected: false,
//              ),
//              Divider(
//                height: 20,
//                color: Colors.grey,
//              ),
            ],
          )
      ),
    );
  }
  Widget settings_right_widget()
  {
    return GestureDetector(
      child: Container(
          width: 30,
          height: 30,
          //child: //Image.asset("assets/menu_icon.png")
      ),//Icon(Icons.b)//SvgPicture.asset("assets/icons/menu.svg"),
    );
  }
  Widget settings_left_widget()
  {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios,size: 35,color: Colors.white,),
      onPressed: (){
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }
}