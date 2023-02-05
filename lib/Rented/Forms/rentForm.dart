import 'package:flutter/material.dart';
import 'package:renting_system/Products/item.dart';
import 'package:renting_system/Rented/rentDatabase.dart';
import 'package:renting_system/Rented/rented.dart';
import 'package:renting_system/Rented/rentedItem.dart';




RentDatabaseHelper _db = RentDatabaseHelper();


class RentForm extends StatefulWidget {
  const RentForm({Key? key, required this.item, required this.itemIndex})
      : super(key: key);

  final int itemIndex;
  final List<Item> item;

  @override
  State<RentForm> createState() => _RentFormState();
}

class _RentFormState extends State<RentForm> {
  final TextEditingController _personName = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _daysRemaining = TextEditingController();

  final _rentFormKey = GlobalKey<FormState>();

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
                key: _rentFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: 30,
                      color: Colors.deepPurple,
                      child: const Text("Rent",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: Text("Person name",
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
                        controller: _personName,
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
                            return 'Please enter person name and must be unique';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Text("Mobile number",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10, 10, 10, 25),
                      child: TextFormField(
                        controller: _mobileNumber,
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
                                vertical: 10, horizontal: 15)
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value)
                        {
                          if(value == null || value.isEmpty)
                          {
                            return 'Please enter mobile number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Text("Receive date",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          10, 10, 10, 25),
                      child: TextFormField(
                        controller: _daysRemaining,
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
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100)
                          );

                          if(pickedDate != null)
                          {
                            String format = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            setState(() {
                                _daysRemaining.text = format;
                            });
                          }
                        },
                        validator: (value)
                        {
                          if(value == null || value.isEmpty)
                          {
                            return 'Please enter date';
                          }
                          return null;
                        },

                      ),
                    ),
                    ElevatedButton(onPressed: ()async {
                      if(_rentFormKey.currentState!.validate())
                        {
                          String heading = widget.item[widget.itemIndex].heading;
                          String description = widget.item[widget.itemIndex]
                              .description;
                          String prices = widget.item[widget.itemIndex].prices;
                          String personNames = _personName.text;
                          String phoneNumbers = _mobileNumber.text;
                          String noOfDays = _daysRemaining.text;
                          rentedItem ritem = rentedItem(
                              heading, description, prices, personNames,
                              phoneNumbers, noOfDays);
                          try
                          {
                            await _insert(ritem.toMap());
                          }
                          catch(e)
                          {
                            _personName.clear();
                            return;
                          }
                          rentedItemsList.add(ritem);
                          rentedstreamController.sink.add(rentedItemsList);
                          _rentFormKey.currentState?.reset();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item is rented,You can see it in Rented tab.")));
                        }

                    },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(
                            const Color(0xff7D53DE)),
                      ),
                      child: const Text("Rent it!"),
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
    final id = await db.insert(item);
    debugPrint('inserted row id:$id ');
  }
}

