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
          cardColor: white,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            border: OutlineInputBorder(borderSide: BorderSide()),
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
  var sharesCountController = TextEditingController();
  var averageCostController = TextEditingController();
  var currentUnitPriceController = TextEditingController();
  var availableAmountController = TextEditingController();
  var sharesCountNode = FocusNode();
  var purchasableQuantity = 0;
  var normalizedPrice = '';
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"), fit: BoxFit.fill)),
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
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
                  ),
                  SizedBox(
                    height: 20,
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
                            this._showResult = true;
                            this.purchasableQuantity = findPurchasableQuantity(
                                availableAmountController,
                                currentUnitPriceController);
                            this.normalizedPrice = findNormalizedPrice(
                                sharesCountController,
                                averageCostController,
                                currentUnitPriceController,
                                purchasableQuantity);
                          });
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
                  SizedBox(height: 30.0),
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
                  style: TextStyle(fontSize: 16.0, color: Color(0xFF7F6F7E))),
              Text(
                  "You will have a normalized price of ${this.normalizedPrice}",
                  style: TextStyle(fontSize: 16.0, color: Color(0xFF7F6F7E)))
            ],
          ),
        ),
      );
    } else {
      return Card();
    }
  }
}
