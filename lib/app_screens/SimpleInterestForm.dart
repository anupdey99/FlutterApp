import 'package:flutter/material.dart';

class SimpleInterestForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SimpleInterestForm> {
  BuildContext buildContext;
  final key = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  final _minimunPadding = 5.0;
  var _currencies = ["Taka", "Doller", "Euro"];
  var _currentSelectedItem = '';
  var _displayResult = "";
  final FocusNode _principalFocus = new FocusNode();
  final FocusNode _roiFocus = new FocusNode();
  final FocusNode _termFocus = new FocusNode();
  TextEditingController principalController = new TextEditingController();
  TextEditingController roiController = new TextEditingController();
  TextEditingController termController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentSelectedItem = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    TextStyle errorStyle =
        TextStyle(color: Colors.yellowAccent, fontSize: 15.0);
    buildContext = context;
    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        key: key,
        appBar: AppBar(
          title: Text("Interest Calculator"),
        ),
        body: Container(
          margin: EdgeInsets.all(_minimunPadding * 2),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimunPadding, bottom: _minimunPadding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Principal",
                      hintText: "Enter Principal e.g. 10000",
                      icon: Icon(Icons.attach_money),
                      fillColor: Colors.white,
                      labelStyle: textStyle,
                      errorStyle: errorStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    controller: principalController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    focusNode: _principalFocus,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _principalFocus, _roiFocus);
                    },
                    validator: (value) {
                      return value.isEmpty ? "Enter principal amount" : null;
                    },
                    style: textStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimunPadding, bottom: _minimunPadding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Rate of Interest",
                      hintText: "In percent",
                      icon: Icon(Icons.attach_money),
                      fillColor: Colors.white,
                      labelStyle: textStyle,
                      errorStyle: errorStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    controller: roiController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    focusNode: _roiFocus,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _roiFocus, _termFocus);
                    },
                    validator: (value) {
                      return value.isEmpty ? "Enter Rate of Interest" : null;
                    },
                    style: textStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimunPadding, bottom: _minimunPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Term",
                            hintText: "Time in years",
                            icon: Icon(Icons.attach_money),
                            fillColor: Colors.white,
                            labelStyle: textStyle,
                            errorStyle: errorStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                          controller: termController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          focusNode: _termFocus,
                          onFieldSubmitted: (value) {
                            _termFocus.unfocus();
                            this._displayResult = _calculateTotalReturn();
                          },
                          validator: (value) {
                            return value.isEmpty ? "Enter time in years" : null;
                          },
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
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              "Calculate",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              debugPrint("Calculate button pressed");
                              setState(() {
                                this._displayResult = _calculateTotalReturn();
                              });
                            }),
                      ),
                      Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Reset",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              debugPrint("Reset button pressed");
                              setState(() {
                                _reset();
                              });
                            }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(_minimunPadding * 2),
                  child: Text(
                    this._displayResult,
                    style: textStyle,
                  ),
                )
              ],
            ),
          ),
        ));
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

  String _calculateTotalReturn() {
    if (!_formKey.currentState.validate()) {
      debugPrint("Form data not valid!");
      return "";
    }

    // if (principalController.text.isEmpty) {
    //   _showSnackBar(buildContext, "Enter principal anount");
    //   return "";
    // } else if (roiController.text.isEmpty) {
    //   _showSnackBar(buildContext, "Enter rate of Interest");
    //   return "";
    // } else if (termController.text.isEmpty) {
    //   _showSnackBar(buildContext, "Enter term in year");
    //   return "";
    // }
    double principal = double.parse(
        principalController.text.isNotEmpty ? principalController.text : "0");
    double roi = double.parse(
        roiController.text.isNotEmpty ? principalController.text : "0");
    double term = double.parse(
        termController.text.isNotEmpty ? principalController.text : "0");

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    String result =
        "After $term years, your investment will be worth $totalAmountPayable $_currentSelectedItem";

    return result;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    _displayResult = '';
    _currentSelectedItem = _currencies[0];
  }

  void _showSnackBar(BuildContext context, String msg) {
    var snackBar = SnackBar(content: Text(msg));
    key.currentState.showSnackBar(snackBar);
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
