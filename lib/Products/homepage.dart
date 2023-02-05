import 'dart:async';
import 'package:flutter/material.dart';
import 'package:renting_system/Products/database.dart';
import 'package:renting_system/Products/item.dart';
import 'package:renting_system/Products/Forms/editForm.dart';
import 'package:renting_system/Rented/Forms/rentForm.dart';
import 'package:renting_system/Products/Forms/addForm.dart';

final DatabaseHelper _db = DatabaseHelper();


StreamController<List<Item>> _streamController =
    StreamController<List<Item>>.broadcast();


List<Item> _item = [];

Future<List<Item>> query() async {
  await _db.init();
  final allRows = await _db.queryAllRows();
  _item.clear();
  allRows.forEach((element) {
      Item items = Item.fromMap(element);
      _item.add(items);
    debugPrint('query all rows:');
  });
  return _item;
}



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => Home1();
}

class Home1 extends State<StatefulWidget> {
  Future<void> refresh() async{
     await query();
       setState(() {

       });
    return Future.delayed(const Duration(seconds: 1));
  }
  Future<List<Item>>? data;
  @override
  initState() {
    super.initState();
    data = query();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: refresh,
            child: StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
              return FutureBuilder(
                initialData: const [],
                future:data,
                builder: ((context, snapshot1) {
                  var snapshotData = snapshot1.data;
                  if (snapshot1.connectionState == ConnectionState.done) {
                    if (snapshot1.hasData) {
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                _db.delete(snapshotData[index].heading);
                                debugPrint("deleted");
                                _item.removeAt(index);
                                _streamController.sink.add(_item);
                              });
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.redAccent,
                              child: const Icon(Icons.delete),
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: const Color(0xFFF3E5F5),
                              elevation: 5.0,
                              child: SingleChildScrollView(
                                child: ListTile(
                                  leading: const Icon(Icons.add_business_rounded,color: Colors.deepPurple,size: 40),
                                  title: Text(snapshotData![index].heading,style: const TextStyle(color:Colors.deepPurple,fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Description : \n${snapshotData[index]
                                              .description}"),
                                      Text("Price :${snapshotData[index].prices}"),
                                    ],
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return EditForm(
                                          index: index,
                                          item: _item,
                                          streamController: _streamController,

                                        );
                                      },
                                    );
                                  },
                                  trailing: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          const Color(0xff7D53DE)),
                                    ),
                                    child: const Text("Rent"),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return RentForm(
                                            item: _item,
                                            itemIndex: index,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot1.data?.length,

                      );
                    }
                    }
                    else if (snapshot1.hasError) {
                      return const Text("Error");
                    } else {
                      return const Text("Loding");
                    }
                    return const Text("Something went Wrong");

                }),
              );
  }
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Addform(
                          item: _item,
                          streamController: _streamController,
                        );
                      },
                    );
                  });
                },
                backgroundColor: const Color(0xff7D53DE),
                child:  const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
