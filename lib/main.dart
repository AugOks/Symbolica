import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:path_provider/path_provider.dart';


// ignore: constant_identifier_names
const double FONT_SIZE = 32;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
Future<void> writeJsonFile(Map<String, dynamic> data, String filename) async {
  // Get the app's document directory
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/$filename';
  final file = File(path);
  final String data = await rootBundle.loadString('assets/data.json');
  //print(data);
  // Convert data to JSON string and write
  String jsonString = jsonEncode(data);
  await file.writeAsString(jsonString);
}

Future<Map<String, dynamic>?> readJsonFile(String filename) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$filename';
    final file = File(path);
    
    // Read file and parse JSON
    String contents = await file.readAsString();
    return jsonDecode(contents);
  } catch (e) {
    print('Error reading file: $e');
    return null;
  }
}


class _MyHomePageState extends State<MyHomePage> {
  bool showBox = false;
  double boxHeight = 0.5;
  String symbol = "";
  String description = "";

  

  Map<String, dynamic>? equationData;

  @override
  void initState() {
    super.initState();
    loadEquationData();
  }

  void loadEquationData() async {
    final data = await readJsonFile('data.json');
    setState(() {
      equationData = data;
    });
  }

  void toggleBox(String symbol, String description) {
    setState(() {
      showBox = !showBox;
      this.symbol = symbol;
      this.description = description;
    });
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            Expanded(
              flex: showBox ? 1 : 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Schrödinger's Equation",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      GestureDetector(
                        onTap: () => toggleBox("i", "The imaginary unit, satisfying i² = -1."),
                        child: Math.tex(
                          r'i',
                          textStyle: TextStyle(fontSize: FONT_SIZE),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleBox(r'\hbar', "Reduced Planck constant, a fundamental physical constant."),
                        child: Math.tex(
                          r'\hbar',
                          textStyle: TextStyle(fontSize: FONT_SIZE),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleBox( r'\frac{\partial}{\partial t}', "Partial derivative with respect to time, indicating how a function changes over time."),
                        child: Math.tex(
                          r'\frac{\partial}{\partial t}',
                          textStyle: TextStyle(fontSize: FONT_SIZE),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleBox(r'\Psi(\mathbf{r},t)', "The wave function, describing the quantum state of a system."),
                        child: Math.tex(
                          r'\Psi(\mathbf{r},t)',
                          textStyle: TextStyle(fontSize: FONT_SIZE),
                        ),
                      ),
                      Math.tex(r'='),
                      GestureDetector(
                        onTap: () => toggleBox(r'\hat{H}', "The Hamiltonian operator, representing the total energy of a quantum system."),
                        child: Math.tex(
                          r'\hat{H}',
                          textStyle: TextStyle(fontSize: FONT_SIZE),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleBox(r'\Psi(\mathbf{r},t)', "The wave function, describing the quantum state of a system."),
                        child: Math.tex(
                          r'\Psi(\mathbf{r},t)',
                          textStyle: TextStyle(fontSize: FONT_SIZE),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (showBox)
             GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  // Convert drag pixels to percentage
                  boxHeight -= details.delta.dy / screenHeight;
                  // Clamp between 0.1 and 0.9
                  boxHeight = boxHeight.clamp(0.1, 0.9);
                }); // setState
              }, // onVerticalDragUpdate
              onVerticalDragEnd: (details) {
                // If dragged below 15%, hide the box
                if (boxHeight < 0.15) {
                  setState(() {
                    showBox = false;
                    boxHeight = 0.5;
                  }); // setState
                }
              }, // onVerticalDragEnd
              child: Container(
                height: screenHeight * boxHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ), // BoxShadow
                  ], // boxShadow
                ), // BoxDecoration
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      width: 50,
                      height: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                       // BoxDecoration
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Math.tex(
                       symbol,
                        textStyle: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          
                          
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    

                  ], 
                ), 
              ), 
            ),
          ],
        ),
      ),
    );
  }
}
