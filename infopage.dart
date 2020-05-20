import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kedah_tour/destination.dart';
import 'package:url_launcher/url_launcher.dart';

//void main() => runApp(Infopage());

class Infopage extends StatefulWidget {
  final Destination destination;
  const Infopage({Key key, this.destination}) : super(key: key);

  @override
  _InfopageState createState() => _InfopageState();
}

class _InfopageState extends State<Infopage> {
  //int index;
  List destinationdata;
  double screenHeight, screenWidth;
  String urlLoadJobs =
      "http://slumberjer.com/visitmalaysia/load_destinations.php";
  @override
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    // var imagename;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Info Page'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10,90,10,10),
        alignment: Alignment(0.2,0.6),
        child: Column(children: <Widget>[
          SizedBox(height: 6),
          Container(
            width: screenWidth / 1.2,
            height: screenHeight / 2,
            child: Card(
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  Table(defaultColumnWidth: FlexColumnWidth(1.0), children: [
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 30,
                            child: Text("Desciption",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                      TableCell(
                          child: Container(
                        height: 80,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 30,
                            child: Text(
                              widget.destination.description,
                            )),
                      )),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 40,
                            child: Text("URL",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                      TableCell(
                          child: Container(
                        height: 60,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 20,
                            child: Text(
                              widget.destination.url,
                            )),
                      )),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 30,
                            child: Text("Address",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                      TableCell(
                          child: Container(
                        height: 50,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 30,
                            child: Text(
                              widget.destination.address,
                            )),
                      )),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 40,
                            child: Text("Contact",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                      TableCell(
                        child: Container(
                          height: 40,
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 30,
                              child: MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                    //_callPhone(index);
                                  },
                                  child: Text(
                                    widget.destination.phone,
                                  ))),
                        ),
                      )
                    ]),
                  ]),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _loadData() {
    String urlLoadJobs =
        "http://slumberjer.com/visitmalaysia/load_destinations.php";

    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        destinationdata = extractdata["locations"];
      });
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> _goToWeb(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _callPhone(int index) async {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
          'Telefon penjual ' + destinationdata[index]['name'] + '?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePhoneCall('tel:' + widget.destination.phone);
              },
              child: Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Tidak",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }
}
