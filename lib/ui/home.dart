import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightFeetController = TextEditingController();
  final TextEditingController _heightInchesController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  int _baseCalculating = 0;
  String _unitWeight = "lbs";
  String _unitHeightFeet = "feet";
  String _unitHeightInches = "inches";
  double _finalBmi = 0.0;

  String _definitionBmi = '';
  String _definitionBmiWHO = '';

  int _gender = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.title,
          ),
          backgroundColor: Colors.pinkAccent,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Image.asset(
                "images/bmilogo.png",
                height: 100.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio<int>(
                      value: 0,
                      groupValue: _baseCalculating,
                      onChanged: handleUnitValueChange),
                  Text(
                    'Imperial',
                    style: TextStyle(color: Colors.blue),
                  ),
                  Radio<int>(
                      value: 1,
                      groupValue: _baseCalculating,
                      onChanged: handleUnitValueChange),
                  Text(
                    'Metric',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.grey[400],
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          onEditingComplete: calculateBmi,
                          decoration: InputDecoration(
                              labelText: "Age",
                              hintText: "e.g: 27",
                              icon: Icon(Icons.person_outline)),
                        )),
                        Expanded(
                            child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Radio<int>(
                                    value: 0,
                                    groupValue: _gender,
                                    onChanged: handleGenderValueChange),
                                Text(
                                  'Man',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Radio<int>(
                                    value: 1,
                                    groupValue: _gender,
                                    onChanged: handleGenderValueChange),
                                Text(
                                  'Woman',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ],
                        ))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                          controller: _heightFeetController,
                          keyboardType: TextInputType.number,
                          onEditingComplete: calculateBmi,
                          decoration: InputDecoration(
                              labelText: "Height in $_unitHeightFeet",
                              hintText:
                                  _baseCalculating == 0 ? "e.g: 6" : "e.g: 1",
                              icon: Icon(Icons.vertical_align_top)),
                        )),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
                          child: Text(
                            "And",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          controller: _heightInchesController,
                          keyboardType: TextInputType.number,
                          onEditingComplete: calculateBmi,
                          decoration: InputDecoration(
                            labelText: "Height in $_unitHeightInches",
                            hintText: _baseCalculating == 0
                                ? "e.g: 3"
                                : "e.g: "
                                    "90",
                          ),
                        )),
                      ],
                    ),
                    TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      onEditingComplete: calculateBmi,
                      decoration: InputDecoration(
                          labelText: "Weight in $_unitWeight",
                          hintText: "e.g: 150",
                          icon: Icon(Icons.fitness_center)),
                    ),
                    Padding(padding: EdgeInsets.all(10.0)),
                    RaisedButton(
                      onPressed: calculateBmi,
                      child: Text("Calculate"),
                      color: Colors.pinkAccent,
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Center(
                child: Text(
                    "Your BMI: ${_finalBmi == 0 ? '...' : _finalBmi.toStringAsFixed(1)}",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500)),
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Center(
                child: Text(_definitionBmi,
                    style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500)),
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              Center(
                child: Text(_definitionBmiWHO,
                    style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500)),
              )
            ],
          ),
        ));
  }

  void handleUnitValueChange(int value) {
    setState(() {
      _baseCalculating = value;
      switch (_baseCalculating) {
        case 0:
          _unitWeight = "lbs";
          _unitHeightFeet = "feet";
          _unitHeightInches = "inсhes";
          break;
        case 1:
          _unitWeight = "kg";
          _unitHeightFeet = "m";
          _unitHeightInches = "cm";
          break;
      }
      if (allEntered()) {
        calculateBmi();
      }
    });
  }

  void calculateBmi() {
    setState(() {
      double _correctionFactor;
      double _inches = 0.0;
      double _normal = 0;
      int _age = 0;
      // FocusScope.of(context).detach();
      if (allEntered()) {
        _age = int.parse(_ageController.text);
        if (_baseCalculating == 0) {
          _correctionFactor = 703.0;
          _inches = double.parse(_heightFeetController.text) * 12 +
              double.parse(_heightInchesController.text);
        } else {
          _correctionFactor = 10000.0;
          _inches = double.parse(_heightFeetController.text) * 100 +
              double.parse(_heightInchesController.text);
        }
        _finalBmi = (double.parse(_weightController.text) * _correctionFactor) /
            (_inches * _inches);
        switch (_gender) {
          case 0:
            if (_age >= 19 && _age < 25) {
              _normal = 21.4;
            } else if (_age >= 25 && _age < 35) {
              _normal = 21.6;
            } else if (_age >= 35 && _age < 45) {
              _normal = 22.9;
            } else if (_age >= 45 && _age < 55) {
              _normal = 25.8;
            } else if (_age >= 55) {
              _normal = 26.6;
            }
            break;
          case 1:
            if (_age >= 19 && _age < 25) {
              _normal = 19.5;
            } else if (_age >= 25 && _age < 35) {
              _normal = 23.2;
            } else if (_age >= 35 && _age < 45) {
              _normal = 23.4;
            } else if (_age >= 45 && _age < 55) {
              _normal = 25.2;
            } else if (_age >= 55) {
              _normal = 27.3;
            }
        }
        _definitionBmi = 'Modern method: ';
        if (_finalBmi < _normal) {
          _definitionBmi += 'Underweight';
        } else if (_finalBmi == _normal) {
          _definitionBmi += 'Normal';
        } else if (_finalBmi > _normal && _finalBmi <= (_normal + 5.0)) {
          _definitionBmi += 'Overweight';
        } else if (_finalBmi > (_normal + 5.0)) {
          _definitionBmi += 'Obesity';
        }
// By WHO
        _definitionBmiWHO = 'WHO method: ';
        if (_finalBmi < 18.5) {
          _definitionBmiWHO += 'Underweight';
        } else if (_finalBmi >= 18.5 && _finalBmi < 24.9) {
          _definitionBmiWHO += 'Normal';
        } else if (_finalBmi >= 25.0 && _finalBmi < 29.9) {
          _definitionBmiWHO += 'Overweight';
        } else if (_finalBmi > 30.0) {
          _definitionBmiWHO += 'Obesity';
        }
      } else {
        _finalBmi = 0;
        _definitionBmi = "Repeat please!";
        _definitionBmiWHO = "Enter all above fields...";
      }
    });
  }

  bool allEntered() {
    if (_ageController.text.isNotEmpty &&
        _weightController.text.isNotEmpty &&
        (_heightFeetController.text.isNotEmpty ||
            _heightInchesController.text.isNotEmpty)) {
      return true;
    } else
      return false;
  }

  void handleGenderValueChange(int value) {
    setState(() {
      _gender = value;
      if (allEntered()) {
        calculateBmi();
      }
    });
  }
}
