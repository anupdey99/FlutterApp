import 'package:flutter/material.dart';

class FavoriteCity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoriteCityState();
  }
}

class _FavoriteCityState extends State<FavoriteCity> {

  String cityName = "";
  var _currencyArray = ["Rupi", "Doller", "Euro"];
  var _currentValueSelected = "Rupi";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter App"),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              onSubmitted: (String userInput) {
                setState(() {
                  cityName = userInput;
                });
              },
            ),
            DropdownButton<String>(
              items: _currencyArray.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem),
                );
              }).toList(),
              value: _currentValueSelected,
              onChanged: (String selectedValue) {
                _dropDownItemSelected(selectedValue);
              },
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                "$cityName",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _dropDownItemSelected(String value){
    setState(() {
      this._currentValueSelected = value;
    });
  }

}
