import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'utilities/utilits.dart' as util;
import "package:http/http.dart" as http;

class AreaWeather extends StatefulWidget {
  @override
  _AreaWeatherState createState() => _AreaWeatherState();
}

class _AreaWeatherState extends State<AreaWeather> {
  String _cityEntered;

  Future<Map> _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute<Map>(builder: (context) {
      return changeCity();
    }));
    if (results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Area Weather'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _goToNextScreen(context);
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/umbrella.jpg',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
          Container(
            margin:
                EdgeInsets.only(left: 0.0, top: 14.9, right: 24.9, bottom: 0.0),
            alignment: Alignment.topRight,
            child: Text(
              _cityEntered == null ? util.defaultCity : _cityEntered,
              style: cityStyle(),
            ),
          ),
          Center(
            child: Container(
              width: 170,
              height: 160,
              child: Image.asset(
                'images/light_rain.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 2.0,
              bottom: 2.0,
            ),
            alignment: Alignment.center,
            child: updateWeatherTemp(_cityEntered),
          ),
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=imperial';
    http.Response response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    }
  }

  Widget updateWeatherTemp(String city) {
    return FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return Container(
              margin: const EdgeInsets.fromLTRB(20.0, 300.0, 0.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      content['main']['temp'].toString() + " F",
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 49.9,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: ListTile(
                      title: Text(
                        "Humidity: ${content['main']['humidity'].toString()}\n"
                        "Min: ${content['main']['temp_min'].toString()} F\n"
                        "Max: ${content['main']['temp_max'].toString()} F ",
                        style: extraDataStyle(),
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

  TextStyle cityStyle() {
    return TextStyle(
      color: Colors.grey.shade600,
      fontSize: 22.9,
      fontStyle: FontStyle.italic,
    );
  }

  TextStyle tempStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 25.5,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle extraDataStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 22.0,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.normal,
    );
  }
}

class changeCity extends StatelessWidget {
  var _cityNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('change city'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          Center(
              child: Image.asset(
            'images/white_snow.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          )),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter City",
                  ),
                  controller: _cityNameController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: FlatButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'enter': _cityNameController.text,
                    });
                  },
                  child: Text(
                    'Get Weather',
                  ),
                  color: Colors.redAccent,
                  textColor: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
