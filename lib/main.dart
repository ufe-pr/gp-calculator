import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gpa_calc/functions/calculate.dart';

void main() => runApp(MyApp());

List items = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NumCoursesPage();
  }
}

class NumCoursesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  'Welcome to The Calculator',
                  style: TextStyle(
                    fontSize: 48,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                child: Text(
                  'Let\'s calculate',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              FillCourseDetailPage()));
                },
                color: Theme.of(context).buttonColor,
              ),
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
    );
  }
}

class _FillCourseDetailPageState extends State<FillCourseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: Scaffold(
        appBar: AppBar(
          title: Text('GPA Calculator'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index < items.length) {
                      final item = items[index];
                      return Dismissible(
                        child: CourseInfo(
                          courseCodeVal: item['courseCode'],
                          unitsVal: item['units'],
                          grade: item['grade'],
                          key: item['key'],
                        ),
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          setState(() {
                            items.removeAt(index);
                          });
                        },
                        background: Container(
                          color: Colors.blueGrey.withOpacity(0.01),
                        ),
                        direction: DismissDirection.startToEnd,
                      );
                    } else {
                      return InkWell(
                        child: Icon(Icons.add),
                        onTap: () {
                          setState(() {
                            items.add(
                              {
                                'courseCode': '',
                                'units': 0,
                                'grade': 'A',
                                'key': UniqueKey()
                              },
                            );
                          });
                        },
                      );
                    }
                  },
                ),
              ),
              Container(
                child: RaisedButton(
                  child: Text(
                    'Calculate',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayResultsPage(
                                  gp: calculateGP(items),
                                  courses: items,
                                )));
                  },
                ),
                width: double.infinity,
              )
            ],
          ),
          padding: EdgeInsets.all(20),
        ),
      ),
    );
  }
}

class FillCourseDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FillCourseDetailPageState();
  }
}

InputDecoration myDecoration({String label, String placeholder}) {
  return InputDecoration(
    labelText: label,
    hintText: placeholder,
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
          style: BorderStyle.solid, width: 2, color: Colors.blueGrey),
    ),
  );
}

class _CourseInfoState extends State<CourseInfo> {
  final grades = ['A', 'B', 'C', 'D', 'E', 'F'];

  @override
  void initState() {
    super.initState();
    _courseCode = TextEditingController(text: widget.courseCodeVal);
    _units = TextEditingController(
        text: widget.unitsVal != 0 ? widget.unitsVal.toString() : '');
    _grade = widget.grade;
  }

  String _grade;
  TextEditingController _courseCode, _units;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _courseCode,
              decoration: myDecoration(label: 'Course Code'),
              textCapitalization: TextCapitalization.characters,
              onChanged: (value) {
                setState(() {
                  items.singleWhere((element) {
                    return element['key'] == widget.key;
                  })['courseCode'] = value;
                });
              },
            ),
            flex: 2,
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Expanded(
            child: TextField(
              controller: _units,
              decoration: myDecoration(label: 'Units'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  items.singleWhere((element) {
                    return element['key'] == widget.key;
                  })['units'] = num.parse(value);
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Container(
            child: DropdownButton(
              value: _grade,
              items: grades.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  this._grade = newValue;
                  items.singleWhere((element) {
                    return element['key'] == widget.key;
                  })['grade'] = newValue;
                  print(items);
                });
              },
              underline: Container(),
              hint: Text('Grade'),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                  style: BorderStyle.solid, color: Colors.blueGrey, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(5),
          ),
        ],
      ),
    );
  }
}

class CourseInfo extends StatefulWidget {
  final String courseCodeVal;
  final int unitsVal;
  final String grade;
  CourseInfo({
    key,
    this.courseCodeVal,
    this.unitsVal,
    this.grade,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CourseInfoState();
  }
}

class DisplayResultsPage extends StatelessWidget {
  final courses, gp;

  DisplayResultsPage({Key key, this.courses, this.gp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TableRow> rows = <TableRow>[
      TableRow(
        children: <Widget>[
          Container(
            child: Text(
              'Course Code',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            padding: EdgeInsets.all(8),
          ),
          Container(
            child: Text(
              'Units',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            padding: EdgeInsets.all(8),
          ),
          Container(
            child: Text(
              'Grade',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            padding: EdgeInsets.all(8),
          ),
        ],
      )
    ];

    for (var course in courses) {
      rows.add(TableRow(children: <Widget>[
        Container(
          child: Text(
            course['courseCode'],
            style: TextStyle(fontSize: 20),
          ),
          padding: EdgeInsets.all(8),
        ),
        Container(
          child: Text(
            course['units'].toString(),
            style: TextStyle(fontSize: 20),
          ),
          padding: EdgeInsets.all(8),
        ),
        Container(
          child: Text(
            course['grade'],
            style: TextStyle(fontSize: 20),
          ),
          padding: EdgeInsets.all(8),
        ),
      ], key: UniqueKey(),
      ));
    }

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(this.gp.toString(),
                        style: TextStyle(fontSize: 48)),
                    decoration: BoxDecoration(
                      color: gp >= 4.5
                          ? Colors.lightGreenAccent.shade700
                          : 3.5 <= gp && gp < 4.5
                              ? Colors.lightGreenAccent.shade200
                              : 2.5 <= gp && gp < 3.5
                                  ? Colors.yellowAccent
                                  : 2.0 <= gp && gp < 2.5
                                      ? Colors.orangeAccent
                                      : Colors.red,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    padding: EdgeInsets.all(30),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                    child: Text(
                      'You have a G.P. of ${this.gp}...',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Table(
                children: rows,
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,                
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
