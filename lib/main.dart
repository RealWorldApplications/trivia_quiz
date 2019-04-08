import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trivia_quiz/models/trivia.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

void main() => runApp(MaterialApp(
    home: HomePage(), theme: new ThemeData(primaryColor: Colors.deepOrange)));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var url = "https://opentdb.com/api.php?amount=20&type=boolean";
  Trivia trivia;
  String answer;
  final String CORRECT = "Correct";
  final String WRONG = "Wrong";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);
    trivia = Trivia.fromJson(decodedJson);
    setState(() {
      answer = "?";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trivia Quiz"),
      ),
      body: trivia == null ? isLoading() : buildQuiz(),
    );
  }

  Widget isLoading() {
    return new Stack(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(top: 200.0, left: 200.0),
          child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation(Colors.deepOrangeAccent),
          ),
        ),
      ],
    );
  }

  Widget buildQuiz() {
    return new Stack(
      children: <Widget>[
        PageView(
          onPageChanged: (index) {
            setState(() {
              answer = "?";
            });
          },
          children: trivia.results
              .map(
                (quest) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 3.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              quest.category,
                              style: TextStyle(fontSize: 25.0),
                            ),
                            Container(
                              height: 100,
                              width: 300,
                              child: HtmlView(data: quest.question),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  (quest.correctAnswer) == "True"
                                      ? answer = CORRECT
                                      : answer = WRONG;
                                });
                              },
                              child: Text("True",
                                  style: TextStyle(fontSize: 30.0)),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  (quest.correctAnswer) == "False"
                                      ? answer = CORRECT
                                      : answer = WRONG;
                                });
                              },
                              child: Text("False",
                                  style: TextStyle(fontSize: 30.0)),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20.0, left: 30.0),
                              child: Text(
                                (answer),
                                style: TextStyle(
                                  fontSize: 40.0,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              )
              .toList(),
        ),
      ],
    );
  }
}
