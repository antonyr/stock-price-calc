import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'const/material_white.dart';
import 'events.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: white,
          brightness: Brightness.dark,
          cardColor: Colors.transparent,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            border: OutlineInputBorder(borderSide: BorderSide()),
//            errorStyle: TextStyle(color: Colors.red.shade900),
//            errorBorder: OutlineInputBorder(
//                borderSide: BorderSide(color: Colors.red.shade900)),
//            focusedErrorBorder: OutlineInputBorder(
//                borderSide: BorderSide(color: Colors.amberAccent)),
          )),
      home: MyHomePage(title: 'Stock Price Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController = new ScrollController();
  var sharesCountController = TextEditingController();
  var averageCostController = TextEditingController();
  var currentUnitPriceController = TextEditingController();
  var availableAmountController = TextEditingController();
  var sharesCountNode = FocusNode();
  var purchasableQuantity = 0;
  var normalizedPrice = '';
  bool _showResult = false;
  final _formKey = GlobalKey<FormState>();
  String sharesToBuy = 'How many shares you wanna buy';
  bool autoValidate = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.fill)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF7F6F7E),
          elevation: 0.0,
          title: Text(widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFDEAF2D),
              )),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: sharesCountNode,
                    controller: sharesCountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Number of Shares you already have',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter some value";
                      }
                      return null;
                    },
                    autovalidate: autoValidate,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: averageCostController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Average cost of the share',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter some value";
                      }
                      return null;
                    },
                    autovalidate: autoValidate,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: currentUnitPriceController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Current Share Price',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter some value";
                      }
                      return null;
                    },
                    autovalidate: autoValidate,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: availableAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'How much money do you have?',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter some value";
                      }
                      return null;
                    },
                    autovalidate: autoValidate,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: DropdownButton<String>(
                      value: sharesToBuy,
                      icon: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.arrow_drop_down_circle)),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          sharesToBuy = newValue;
                        });
                      },
                      items: <String>[
                        'How many shares you wanna buy',
                        'How much money you got'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.white54,
                          width: 0.8,
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Normalize'),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        color: Colors.green,
                        onPressed: () {
                          setState(() {
                            autoValidate = true;
                          });
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              this._showResult = true;
                              this.purchasableQuantity =
                                  findPurchasableQuantity(
                                      availableAmountController,
                                      currentUnitPriceController);
                              this.normalizedPrice = findNormalizedPrice(
                                  sharesCountController,
                                  averageCostController,
                                  currentUnitPriceController,
                                  purchasableQuantity);
                            });
                            var scrollPosition = _scrollController.position;
                            _scrollController.animateTo(
                              scrollPosition.maxScrollExtent,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 100),
                            );
                          }
                        },
                      ),
                      RaisedButton(
                        color: Colors.grey,
                        child: Text('Clear',
                            style: TextStyle(color: Colors.white)),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        onPressed: () {
                          setState(() {
                            this._showResult = false;
                          });
                          reset(
                              sharesCountController,
                              averageCostController,
                              currentUnitPriceController,
                              availableAmountController);
                          sharesCountNode.requestFocus();
                        },
                      )
                    ],
                  )),
                  SizedBox(height: 20.0),
                  buildResult(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Card buildResult() {
    if (_showResult) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                  "You can purchase a maximum of ${this.purchasableQuantity.toString()} shares",
                  style: TextStyle(fontSize: 16.0)),
              Text(
                  "You will have a normalized price of ${this.normalizedPrice}",
                  style: TextStyle(fontSize: 16.0))
            ],
          ),
        ),
      );
    } else {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text("Your results will be displayed here"),
            ],
          ),
        ),
      );
    }
  }
}
