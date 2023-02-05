import 'package:flutter/material.dart';
import 'package:renting_system/Rented/rentDatabase.dart';
import 'package:renting_system/Rented/rented.dart';
import 'package:renting_system/Rented/rentedItem.dart';

RentDatabaseHelper _db = RentDatabaseHelper();

class RentedEdit extends StatefulWidget {
   const RentedEdit({Key? key,required this.rentedItems,required this.index}) : super(key: key);

  final List<rentedItem> rentedItems;
  final int index;
  @override
  State<RentedEdit> createState() => _RentedEditState();
}

class _RentedEditState extends State<RentedEdit> {
  final TextEditingController _personName = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _daysRemaining = TextEditingController();

  final _rentEditFormKey = GlobalKey<FormState>();

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
                key: _rentEditFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: 30,
                      color: Colors.deepPurple,
                      child: const Text("Edit",
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
                        decoration: InputDecoration(hintText: widget.rentedItems[widget.index].personName,
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
                           readOnly: true,

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
                        decoration: InputDecoration(hintText: widget.rentedItems[widget.index].phoneNumber.toString(),
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
                        autofocus: true,
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
                        decoration: InputDecoration(hintText: widget.rentedItems[widget.index].noOfDays.toString(),
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

                      ),
                    ),
                    ElevatedButton(onPressed: () async{
                      String heading = widget.rentedItems[widget.index].heading;
                      String description = widget.rentedItems[widget.index].description;
                      String prices = widget.rentedItems[widget.index].prices;
                      String personName = widget.rentedItems[widget.index].personName;
                      String phoneNumber = widget.rentedItems[widget.index].phoneNumber;
                      String noOfDays = widget.rentedItems[widget.index].noOfDays;

                      personName = _personName.text.isEmpty
                          ? widget.rentedItems[widget.index].personName
                          : _personName.text;
                       noOfDays = _daysRemaining.text.isEmpty
                          ? widget.rentedItems[widget.index].noOfDays
                          : _daysRemaining.text;
                      phoneNumber =
                      _mobileNumber.text.isEmpty
                          ? widget.rentedItems[widget.index].phoneNumber
                          : _mobileNumber.text;
                      await _update(heading, description, prices, personName, phoneNumber, noOfDays);
                      _rentEditFormKey.currentState?.reset();
                      await rentquery();
                      rentedstreamController.sink.add(widget.rentedItems);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(
                            const Color(0xff7D53DE)),
                      ),
                      child: const Text("Save"),
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
  Future<void> _update(String itemHeading,String itemDescription,String itemPrice,String itemPersonName,String itemPhoneNumber,String itemNoOfDays) async {
    await _db.init();
    final id = await _db.update(itemHeading,itemDescription,itemPrice,itemPersonName,itemPhoneNumber,itemNoOfDays);
    debugPrint('is updated : $id ');
  }
}
