import 'package:flutter/material.dart';

class SimpleInterestForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SimpleInterestForm> {
  final _minimunPadding = 5.0;
  var _currencies = ["Taka", "Doller", "Euro"];
  var _currentSelectedItem = "Taka";

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Container(
        margin: EdgeInsets.all(_minimunPadding * 2),
        child: ListView(
          children: <Widget>[
            getImageAsset(),
            Padding(
              padding: EdgeInsets.only(
                  top: _minimunPadding, bottom: _minimunPadding),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Principal",
                  hintText: "Enter Principal e.g. 10000",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                keyboardType: TextInputType.number,
                style: textStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: _minimunPadding, bottom: _minimunPadding),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Rate of Interest",
                  hintText: "In percent",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                keyboardType: TextInputType.number,
                style: textStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: _minimunPadding, bottom: _minimunPadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Term",
                        hintText: "Time in years",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                      keyboardType: TextInputType.number,
                      style: textStyle,
                    ),
                  ),
                  Container(
                    width: _minimunPadding * 5,
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _currentSelectedItem,
                      items: _currencies.map((String dropDownItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownItem,
                          child: Text(dropDownItem),
                        );
                      }).toList(),
                      onChanged: (String currentItem) {
                        _onDropDownItemChanged(currentItem);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: _minimunPadding, bottom: _minimunPadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                        child: Text("Calculate"),
                        onPressed: () {
                          debugPrint("Calculate button pressed");
                        }),
                  ),
                  Expanded(
                    child: RaisedButton(
                        child: Text("Reset"),
                        onPressed: () {
                          debugPrint("Reset button pressed");
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_minimunPadding * 2),
              child: Text("Todo Text"),
            )
          ],
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = new AssetImage("images/money.png");
    Image image = Image(image: assetImage, width: 125.0, height: 125.0);

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimunPadding * 10),
    );
  }

  void _onDropDownItemChanged(String value) {
    setState(() {
      this._currentSelectedItem = value;
    });
  }
}
