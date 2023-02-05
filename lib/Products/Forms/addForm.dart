import 'dart:async';
import 'package:flutter/material.dart';
import 'package:renting_system/Products/database.dart';
import 'package:renting_system/Products/homepage.dart';
import '../item.dart';


DatabaseHelper _db = DatabaseHelper();


class Addform extends StatefulWidget {

  const Addform({Key? key,required this.item,required this.streamController}) : super(key: key);

  final StreamController streamController;
  final List<Item> item;

  @override
  State<Addform> createState() =>  _AddformState();
}

class _AddformState extends State<Addform> {

  final TextEditingController _heading = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final _addFormKey = GlobalKey<FormState>();

  Future<void> initDatabase() async
  {
    WidgetsFlutterBinding.ensureInitialized();
    await _db.init();
  }

  @override
  void init()
  {
    super.initState();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 430,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Form(
                key: _addFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: 30,
                      color: Colors.deepPurple,
                      child: const Text("Add",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: Text("Heading",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10, 10, 10, 25),
                      child: TextFormField(
                        controller: _heading,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 5,
                              ),
                              borderRadius:
                              BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets
                                .symmetric(
                                vertical: 10, horizontal: 15)),

                        autofocus: true,
                        validator: (value)
                        {
                          if(value == null || value.isEmpty)
                          {
                            return 'Please enter heading and must be Unique';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Text("Description",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10, 10, 10, 25),
                      child: TextFormField(
                        controller: _description,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 5,
                              ),
                              borderRadius:
                              BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets
                                .symmetric(
                                vertical: 10, horizontal: 15),
                        ),
                        validator: (value)
                        {
                          if(value == null || value.isEmpty)
                          {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Text("Price",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10, 10, 10, 25),
                      child: TextFormField(
                        controller: _price,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 5,
                              ),
                              borderRadius:
                              BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets
                                .symmetric(
                                vertical: 10, horizontal: 15),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value)
                        {
                          if(value == null || value.isEmpty)
                            {
                              return 'Please enter price';
                            }
                          return null;
                        },

                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if(_addFormKey.currentState!.validate())
                        {
                          String heading = _heading.text;
                          String description = _description.text;
                          String prices = _price.text;
                          Item iteminstance = Item(heading, description, prices);
                          try
                          {
                            await _insert(iteminstance.toMap());
                          }
                          catch(e)
                        {
                          _heading.clear();
                          return;
                        }
                          widget.item.add(iteminstance);
                          widget.streamController.sink.add(widget.item);
                          _addFormKey.currentState?.reset;
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Add Item"),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(
                            const Color(0xff7D53DE)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _insert(Map<String,dynamic> item) async {
    await _db.init();
    final id = await _db.insert(item);
    debugPrint('inserted row id:$id ');
  }
}
