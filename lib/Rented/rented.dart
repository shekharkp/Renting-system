import 'package:flutter/material.dart';
import 'package:renting_system/Rented/rentDatabase.dart';
import 'package:renting_system/Rented/Forms/rentedEditForm.dart';
import 'package:renting_system/Rented/rentedItem.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

StreamController<List<rentedItem>> rentedstreamController =
    StreamController<List<rentedItem>>.broadcast();

RentDatabaseHelper db = RentDatabaseHelper();

List<rentedItem> rentedItemsList = [];

Future<List<rentedItem>> rentquery() async {
  await db.init();
  final allRows = await db.queryAllRows();
  rentedItemsList.clear();
  allRows.forEach((element) {
    rentedItem items = rentedItem.fromMap(element);
    rentedItemsList.add(items);
    debugPrint('query all rows:');
  });
  return rentedItemsList;
}

class Rented extends StatefulWidget {
  const Rented({super.key});

  @override
  State<StatefulWidget> createState() => _Home2();
}

class _Home2 extends State<StatefulWidget> {
  Future<List<rentedItem>>? data;

  @override
  initState() {
    super.initState();
    data = rentquery();
    rentedstreamController.sink.add(rentedItemsList);
  }

  Future<void> refresh() async {
    await rentquery();
    setState(() {});
    return Future.delayed(const Duration(seconds: 1));
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
              stream: rentedstreamController.stream,
              builder: (context, snapshot) {
                return FutureBuilder(
                    initialData: const [],
                    future: rentquery(),
                    builder: (context, snapshot1) {
                      var snapshotData = snapshot1.data;
                      if (snapshot1.connectionState == ConnectionState.done) {
                        if (snapshot1.hasData) {
                          return ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 10,
                                color: const Color(0xFFF3E5F5),
                                child: SingleChildScrollView(
                                  child: ListTile(
                                    leading: const Icon(Icons.timer_rounded,
                                        color: Colors.deepPurple, size: 40,),
                                    title: Text(snapshotData![index].heading,style: const TextStyle(color:Colors.deepPurple,fontWeight: FontWeight.bold)),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Person name : ${snapshotData[index].personName}"),
                                        Text(
                                            "Mobile number : ${snapshotData[index].phoneNumber.toString()}"),
                                        Text(
                                            "Date of receive : ${snapshotData[index].noOfDays.toString()}"),
                                        Text(
                                            "Description : \n${snapshotData[index].description}"),
                                        Text(
                                            "Price :${snapshotData[index].prices}"),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return RentedEdit(
                                              rentedItems: rentedItemsList,
                                              index: index);
                                        },
                                      );
                                    },
                                    trailing: Wrap(spacing: 10, children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xff7D53DE)),
                                        ),
                                        onPressed: () async {
                                          await db.init();
                                          await db.delete(
                                              snapshot1.data![index].personName);
                                          rentedItemsList.removeAt(index);
                                          rentedstreamController.sink
                                              .add(rentedItemsList);
                                        },
                                        child: const Text("Available"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          String url =
                                              "${snapshot1.data![index].phoneNumber}";
                                          final Uri urls =
                                              Uri(scheme: 'tel', host: url);
                                          await launchUrl(urls,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xff7D53DE)),
                                        ),
                                        child: const Text("Call"),
                                      )
                                    ]),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot1.data!.length,
                          );
                        }
                      } else if (snapshot1.hasError) {
                         const Text("Error");
                      } else {
                        return  const Text("Loding");
                      }
                      return const Text("Something went Wrong");
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
