import 'package:dictation_app/DictationPage/OnFinished.dart';
import 'package:dictation_app/DictationPage/StartDictationPage.dart';
import 'package:dictation_app/Globals/GlobalColors.dart';
import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:dictation_app/Globals/constant.dart';
import 'package:dictation_app/Registration/SignIn.dart';
import 'package:dictation_app/SaveInFile.dart';
import 'package:dictation_app/Widgets/RecentDictationsPage.dart';
import 'package:dictation_app/Widgets/my_header.dart';
import 'package:dictation_app/Widgets/new_dictation.dart';
import 'package:dictation_app/main.dart';
import 'package:flutter/material.dart';
import 'package:dictation_app/Globals/GlobalFunctions.dart';
class MainPage extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var controller = ScrollController();
  MainPage(this._scaffoldKey,this.controller);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    print("main recent: ${GlobalParameters.recentDictations.length.toString()}");
    /*
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
    );
    */

    return Scaffold(
      body: SingleChildScrollView(
        controller: widget.controller,
        child: Column(
          children: <Widget>[
            //Adding the title
            MyHeader(
              textTop:
              Align(
                alignment: Alignment.topRight,
                child: Center(
                  child: Text(
                    "QuizMe\n",
                    style: kHeadingTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 50,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
              ),
//            Positioned(
//              top: 10,
//              left: 80,
//              child: Text(
//                "Quizme\n",
//                style: kHeadingTextStyle.copyWith(
//                    color: Colors.white,
//                    fontSize: 50,
//                    fontStyle: FontStyle.italic
//                ),
//              ),
//            ),
              textBottom: Text(""),
              offset: 0,
              height: 300,
              left_height: 80,
              right_height: 80,
              color_1: Color(0xFF3383CD),
              color_2: Color(0xFF11249F),

              //Add new dictation button
              left_widget: main_left_widget(),

              right_widget: main_right_widget(),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(35,10,4,4),
                  child: Text("Dictations",style: TextStyle(
                      fontSize: 20
                  ),),
                )
            ),
            GestureDetector(
              onTap: (){
                if (GlobalParameters.Dictations.length != 0)
                  {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                        ),
                        context: context,
                        builder: (context){
                          return Column(
                mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: GlobalParameters.Dictations.length,
                                  itemBuilder: (BuildContext context, int index) =>
                                      bottom_item(context, index)),
                            ],
                          );
                        }
                    );
                  }
                else{
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return StatefulBuilder(
                          builder: (context, setState)
                          {
                            return AlertDialog(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20),
                                ),
                                title: Container(
                                  child:
                                  Text("You don't have any dictations yet",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),


                                ),
                                content: FlatButton(
                                  child: Text("Close", style: TextStyle(
                                      fontSize: 20,
                                      color: kPrimaryColor
                                  ),),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    //Navigator.pop(context);
                                  },
                                ),

                            );
                          },
                        );
                      }
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: GlobalParameters.DarkMode ? Colors.grey[700] : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: GlobalParameters.DarkMode ? Colors.black : Color(0xFFE5E5E5),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.featured_play_list,color: kPrimaryColor,),
                    //SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                    SizedBox(width: 20),
                    Expanded(
                      //child: GestureDetector(
                      child: Text(GlobalParameters.selected_dictation),
                    ),
                    Icon(Icons.assignment,color: kTextLightColor,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GlobalParameters.last_dictation != null ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Last Dictation\n",
                              style: TextStyle(
                                fontSize: 18,
                                color: GlobalParameters.DarkMode ? Colors.grey[200] : kTitleTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GlobalParameters.last_saved_dictation.date != null ? TextSpan(
                              text: "Last Dictation was on ${GlobalParameters.last_saved_dictation.date}",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ) : TextSpan(),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          int dictation_index;
                          if (GlobalParameters.last_saved_dictation != null)
                          {
                            for (int i = 0;i < GlobalParameters.Dictations.length;i ++)
                              {
                                if (GlobalParameters.last_saved_dictation.name == GlobalParameters.Dictations[i].name)
                                  {
                                    dictation_index = i;
                                  }
                              }
                            if (dictation_index != null)
                              {
                                //Show the last dictations results
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return OnFinished(GlobalParameters.Dictations[dictation_index],GlobalParameters.Dictations[dictation_index].last_dictation_tested_words,"last dictation");
                                    },
                                  ),
                                );


//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                  builder: (context) {
//                                    return OnFinished(GlobalParameters.last_dictation,GlobalParameters.last_saved_dictation.last_dictation_tested_words,"last dictation");
//                                  },
//                                ),
//                              );
                              }

                          }
                          else{
                            //Informing the user that there is no last dictation
                            show_snack_bar(widget._scaffoldKey, "There is no last dictation");
                            //GlobalParameters.snackBarValue = "There is no last dictation";
                            //widget._scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
                          }
                        },
                        child: Text(
                          "See details",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
//                SizedBox(height: 20),
//                Container(
//                  padding: EdgeInsets.all(20),
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(20),
//                    color: Colors.white,
//                    boxShadow: [
//                      BoxShadow(
//                        offset: Offset(0, 4),
//                        blurRadius: 30,
//                        color: kShadowColor,
//                      ),
//                    ],
//                  ),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                    ],
//                  ),
//                ),

                ],
              ),
            ): SizedBox.shrink(),
            GlobalParameters.recentDictations.length > 0 ? Padding(
              padding: EdgeInsets.fromLTRB(10,20,10,10),
              child: Column(
                children: <Widget>[
//                ListView.builder(
//                    scrollDirection: Axis.vertical,
//                    shrinkWrap: true,
//                    itemCount: GlobalParameters.recentDictations.length,
//                    itemBuilder: (BuildContext context, int index) =>
//                        BuildCard(context, index)),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RecentDictations(recent_list());
                            },
                          ),
                        );
                      },
                      leading: Icon(Icons.history),
                      title: Text("Recent Dictations"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  )


//                Row(
//                  children: <Widget>[
//                    RichText(
//                      text: TextSpan(
//                        children: [
//                          TextSpan(
//                            text: "Recent Dictations\n",
//                            style: kTitleTextstyle,
//                          ),
//                          GlobalParameters.last_saved_dictation.date != null ? TextSpan(
//                            text: "Last Dictation was on ${GlobalParameters.last_saved_dictation.date}",
//                            style: TextStyle(
//                              color: kTextLightColor,
//                            ),
//                          ) : TextSpan(),
//                        ],
//                      ),
//                    ),
//                    Spacer(),
//                    GestureDetector(
//                      onTap: (){
//                        if (GlobalParameters.last_saved_dictation != null)
//                        {
//                          //Show the last dictations results
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) {
//                                return OnFinished(GlobalParameters.last_dictation,GlobalParameters.last_saved_dictation.last_dictation_tested_words,"last dictation");
//                              },
//                            ),
//                          );
//                        }
//                        else{
//                          //Informing the user that there is no last dictation
//                          GlobalParameters.snackBarValue = "There is no last dictation";
//                          widget._scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
//                        }
//                      },
//                      child: Text(
//                        "See details",
//                        style: TextStyle(
//                          color: kPrimaryColor,
//                          fontWeight: FontWeight.w600,
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//                SizedBox(height: 20),
//                Container(
//                  padding: EdgeInsets.all(20),
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(20),
//                    color: Colors.white,
//                    boxShadow: [
//                      BoxShadow(
//                        offset: Offset(0, 4),
//                        blurRadius: 30,
//                        color: kShadowColor,
//                      ),
//                    ],
//                  ),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                    ],
//                  ),
//                ),

                ],
              ),
            ) : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
  List<Dictation> recent_list()
  {
    List<Dictation> recent_dictations_list = new List<Dictation>();
    List<DateTime> dictations_times = new List<DateTime>();
    GlobalParameters.Dictations.forEach((cell){
      if (cell.last_dictation_time != null)
        {
          dictations_times.add(DateTime.parse(cell.last_dictation_time));
        }

//      DateTime date_time = hour;
//      List<String> time = new List<String>();
//      time = cell.last_dictation_time.split(':');
//      date_time.hour = int.parse(time[0]);
//      if (cell.last_dictation_time == null)
//        {
//          cell.last_dictation_time = "999999";
//        }
//      dictations_times.add(cell.last_dictation_time);
    });

    dictations_times.sort((a,b) => a.compareTo(b));
    for (int i = 0;i < dictations_times.length;i ++)
    {
      for (int j = 0;j < GlobalParameters.Dictations.length;j ++)
      {
        if (GlobalParameters.Dictations[j].last_dictation_time == dictations_times[i].toString())
        {
          recent_dictations_list.add(GlobalParameters.Dictations[j]);
        }
      }
    }
    return recent_dictations_list.reversed.toList();
  }
  Widget BuildCard(BuildContext context,int index)
  {
    Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: Icon(Icons.assignment),
        title: Text(GlobalParameters.recentDictations[index].name),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DictationInfo(GlobalParameters.recentDictations[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
  Widget main_left_widget()
  {
    return Container(
        child: IconButton(
          icon: Icon(Icons.add,size: 45,color: Colors.white,),
          onPressed: (){
            GlobalParameters.add_dictation_translation_language = "";
            GlobalParameters.add_dictation_word_language = "";
            GlobalParameters.add_dictation.words_list.clear();
            GlobalParameters.change_language = true;
//            GlobalParameters.words_to_add_list.clear();
//            GlobalParameters.add_dictation.name = "";
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return NewDictation();
                },
              ),
            );
          },
        )
    );
  }
  Widget main_right_widget()
  {
    return IconButton(
      icon: Icon(Icons.settings,size: 35,color: Colors.white),
      onPressed: (){
        widget._scaffoldKey.currentState.openEndDrawer();
      },
    );
//    return GestureDetector(
//      onTap: (){
//        widget._scaffoldKey.currentState.openEndDrawer();
//      },
//      child: Container(
//          width: 35,
//          height: 35,
//          child: Image.asset("assets/menu_icon.png",color: Colors.white,)
//      ),
//    );
  }
  void on_removed(int index) async
  {
//    setState(() {
//      GlobalParameters.Dictations.removeAt(index);
//    });
//    SaveInFile.save_in_file();
//    Navigator.pop(context);
//    Navigator.pop(context);

    final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context, setState)
            {
              return AlertDialog(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20),
                  ),
                  title: Container(
                      child:
                      Text("Are you sure you want to delete this dictation?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),


                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Yes",style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor
                        ),),
                        onPressed: (){

                          Navigator.of(context).pop(true);

                          //Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text("No",style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor
                        ),),
                        onPressed: (){
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ],
                  )
              );
            },
          );
        }
    );
    if (result == true)
    {
      Navigator.pop(context);
      if (GlobalParameters.last_dictation == GlobalParameters.Dictations[index])
      {
        setState(() {
          GlobalParameters.last_dictation = null;
          GlobalParameters.last_dictation_date = "";
          GlobalParameters.last_saved_dictation = null;
          filter_recent_dictations();
          if (GlobalParameters.recentDictations.length == 1)
            GlobalParameters.recentDictations.clear();
          else
            GlobalParameters.recentDictations.remove(GlobalParameters.Dictations[index]);
        });
        SaveInFile.save_recent_dictations();
        SaveInFile.save_last_dictation();
      }
      setState(() {
        GlobalParameters.Dictations.removeAt(index);
      });

      SaveInFile.save_in_file();
    }
  }
  void filter_recent_dictations()
  {
    int count = 0;
    for (int i = 0;i < GlobalParameters.recentDictations.length;i ++) {
      for (int j = 0; j < GlobalParameters.recentDictations.length; j ++) {
        if (GlobalParameters.recentDictations[i].name == GlobalParameters.recentDictations[j].name)
          {
            count ++;
            if (count > 1){
                GlobalParameters.recentDictations.remove(GlobalParameters.recentDictations[i]);
              }
          }
      }
    }
    bool exist = false;
    for (int i = 0;i < GlobalParameters.recentDictations.length;i ++) {
      for (int j = 0;j < GlobalParameters.Dictations.length;j ++) {
        if (GlobalParameters.Dictations[j].name == GlobalParameters.recentDictations[i].name)
          {
            exist = true;
          }
      }
      if (exist == false)
        {
          GlobalParameters.recentDictations.removeAt(i);
        }

    }
  }
  Widget bottom_item(BuildContext context, int index)
  {
    return Column(
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.featured_play_list),
            title: Text(GlobalParameters.Dictations[index].name),
            onTap: (){
              setState(() {
                //Close the showModalBottomSheet widget
                Navigator.pop(context);

                //Pushing the dictation info page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DictationInfo(GlobalParameters.Dictations[index]);
                    },
                  ),
                );
              });
            },
          trailing: IconButton(
            icon: Icon(Icons.delete_outline,color: Colors.redAccent,),
            onPressed: () {
              on_removed(index);
            },
          )

//          GestureDetector(
//            child: Text("Delete",style: TextStyle(
//              color: kDeathColor
//            ),),
//            onTap: (){
//              on_removed(index);
//              //remove_function(context,"dictation");
////              bool remove_or_not = remove_function(context,"dictation");
////              if (remove_or_not == true)
////                {
////                  setState(() {
////                    GlobalParameters.Dictations.removeAt(index);
////                  });
////                  SaveInFile.save_in_file();
////                  Navigator.pop(context);
////                }
//
//            },
//          )
//      IconButton(
//        icon: Icon(Icons.remove),
//        onPressed: (){
//          on_removed(index);
//        },
//      ),
        ),
        Divider(height: 5,color: Colors.grey,endIndent: 30,indent: 30,),
      ],
    );
  }

}