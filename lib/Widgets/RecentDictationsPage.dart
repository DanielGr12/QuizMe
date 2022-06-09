import 'package:dictation_app/DictationPage/StartDictationPage.dart';
import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:flutter/material.dart';

class RecentDictations extends StatefulWidget {
  List<Dictation> recent_dications = new List<Dictation>();
  RecentDictations(this.recent_dications);
  @override
  _RecentDictationsState createState() => _RecentDictationsState();
}

class _RecentDictationsState extends State<RecentDictations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recent Dictations"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.recent_dications.length,
                itemBuilder: (BuildContext context, int index) =>
                    BuildCard(context, index)),
          ],
        ),
      ),
    );
  }
  Widget BuildCard(BuildContext context,int index)
  {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
        //Navigator.of(context).push(FadeRouteBuilder(page: DictationInfo(widget.recent_dications[index])));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DictationInfo(widget.recent_dications[index]);
            },
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(

          leading: Icon(Icons.assignment),
          title: Row(
            children: <Widget>[
              Text(widget.recent_dications[index].name),
              Spacer(),
              Text(widget.recent_dications[index].date)
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}