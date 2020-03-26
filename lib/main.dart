import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'events.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Stock Price Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(children: <Widget>[
        Column(
          children: <Widget>[
            TextFormField(
              focusNode: sharesCountNode,
              controller: sharesCountController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  labelText: "Number of Shares you already have",
                  contentPadding: EdgeInsets.all(10.0)),
            ),
            TextFormField(
              controller: averageCostController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  labelText: "Average cost of the share",
                  contentPadding: EdgeInsets.all(10.0)),
            ),
            TextFormField(
              controller: currentUnitPriceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  labelText: "Current Share Price",
                  contentPadding: EdgeInsets.all(10.0)),
            ),
            TextFormField(
              controller: availableAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "How much money do you have?",
                  contentPadding: EdgeInsets.all(10.0)),
            ),
            Center(
                child: ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Normalize'),
                      color: Color.fromRGBO(0, 64, 255, 1),
                      onPressed: () {
                        setState(() {
                          this.purchasableQuantity = findPurchasableQuantity(availableAmountController, currentUnitPriceController);
                          this.normalizedPrice = findNormalizedPrice(sharesCountController, averageCostController, currentUnitPriceController, purchasableQuantity);
                        });
                      },
                    ),
                    RaisedButton(
                      child: Text('Clear'),
                      color: Color.fromRGBO(0, 64, 255, 1),
                      onPressed: () {
                        reset(sharesCountController, averageCostController, currentUnitPriceController, availableAmountController);
                        sharesCountNode.requestFocus();
                      },
                    )
                  ],
                )),
            Container(
              child: Text(
                "You can purchase a maximum of ${this.purchasableQuantity.toString()} shares"
              )
            ),
            Container(
              child: Text(
                "You will have a normalized price of ${this.normalizedPrice}"
              )
            )
          ],
        )
      ]),
    );
  }
}
