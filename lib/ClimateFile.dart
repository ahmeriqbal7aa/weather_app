import 'package:flutter/material.dart';
import 'package:weather_app/utilities/apiFile.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Climate extends StatefulWidget {
  @override
  _ClimateState createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {
  //TODO Create Function
  // void showStuff() async {
  //   Map getdata = await getWeather(util.apiID, util.defaultCity);
  //   print(getdata.toString());
  // }

  //TODO Next Screen Widget
  String _cityEntered;
  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      //change to Map instead of dynamic for this to work
      return new ChangeCityName();
    }));

    if (results != null && results.containsKey('enter')) {
      setState(() {
        _cityEntered = results['enter'];
      });
      // debugPrint("From First screen" + results['enter'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Weather App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _goToNextScreen(context);
            },
            icon: Icon(Icons.menu),
          )
        ],
      ),
      body: Stack(
        children: [
          //TODO City Background Image
          Center(
            child: Image(
              image: AssetImage('images/umbrella.png'),
              height: 700,
              width: 400,
              fit: BoxFit.fill,
            ),
          ),
          //TODO City Text
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text(
              '${_cityEntered == null ? util.defaultCity : _cityEntered}',
              style: cityStyle(),
            ),
          ),
          //TODO Temperature Background Image
          Center(
            child: Image(
              image: AssetImage('images/light_rain.png'),
            ),
          ),
          //TODO Temperature Text
          Container(
            margin: EdgeInsets.fromLTRB(60.0, 0.0, 0.0, 50.0),
            child: updateTemp(
                '${_cityEntered == null ? util.defaultCity : _cityEntered}'),
          ),
        ],
      ),
    );
  }

  //TODO Future Widget
  Future<Map> getWeather(String id, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$id&units=imperial';
    // 'http://api.openweathermap.org/data/2.5/weather?q=Burewala&appid=cade35043c3d8615682f8910c617b72e&units=metric';
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  //TODO Widget that take City_Name and show its Temperature and Sub_Temperature
  Widget updateTemp(String city) {
    return FutureBuilder(
        future: getWeather(util.apiID, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          //where we get all of the json data, we setup widgets etc.
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return Container(
              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      content['main']['temp'].toString() + " F",
                      style: new TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 49.9,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                        "Humidity: ${content['main']['humidity'].toString()}\n"
                        "Min: ${content['main']['temp_min'].toString()} F\n"
                        "Max: ${content['main']['temp_max'].toString()} F ",
                        style: subTempStyle(),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

////////////////////////////////////////////////////////////////////////////////
class ChangeCityName extends StatelessWidget {
  final _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Enter City'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          //TODO Image
          Center(
            child: new Image.asset(
              'images/city_background.jpg',
              height: 700,
              width: 400,
              fit: BoxFit.fill,
            ),
          ),
          //TODO Text Field and Button
          ListView(
            children: [
              ListTile(
                title: TextField(
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter City',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              ListTile(
                title: FlatButton(
                  onPressed: () {
                    Navigator.pop(
                        context, {'enter': _cityFieldController.text});
                    // 'enter' is a key
                  },
                  textColor: Colors.white,
                  color: Colors.redAccent,
                  child: Text('Get Weather'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/////////////////////////
// City Text Style
TextStyle cityStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
  );
}

/////////////////////////
// Temperature Text Style
TextStyle tempStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 49.9,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );
}

/////////////////////////////
// Sub Temperature Text Style
TextStyle subTempStyle() {
  return TextStyle(
    color: Colors.white70,
    fontSize: 17.0,
    // fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );
}
