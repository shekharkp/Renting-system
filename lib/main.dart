import 'package:flutter/material.dart';
import 'package:renting_system/Products/homepage.dart';
import 'package:renting_system/Rented/rented.dart';

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
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Renting System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selected = 0;

  var pages = const <Widget>[HomePage(), Rented()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        title: Align(alignment: Alignment.center, child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: Text(widget.title),
        )),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: const Color(0xFFF3E5F5),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      ),
                    child: SizedBox(
                      height: 350,
                      width: double.infinity,
                      child: Column(
                        children:const [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "How to use",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "1.Tap on floating button to add.\n"
                            "\n"
                            "2.Tap on product to edit content.\n"
                                "\n"
                            "3.Slide product Right to left to delete.\n"
                                "\n"
                            "4.Tap on Rent button on product.\n"
                                "\n"
                            "5.Tap on call button to call customer.\n"
                                "\n"
                            "6.Tap on available to delete Product from rented.\n",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "By"
                            "\n"
                            "Shekhar K Patil",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.question_mark_rounded),
          )
        ],
      ),
      body: pages[selected],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(
                Icons.home_filled,
                color: Color(0xff7D53DE),
              ),
              label: "Products"),
          NavigationDestination(
            icon: Icon(
              Icons.timer,
              color: Color(0xff7D53DE),
            ),
            label: "Rented",
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            selected = index;
          });
        },
        selectedIndex: selected,
        backgroundColor: Colors.white,
      ),
    );
  }
}
