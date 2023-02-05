import 'dart:async';
import 'package:flutter/material.dart';
import 'package:renting_system/Products/database.dart';
import 'package:renting_system/Products/homepage.dart';
import '../item.dart';

 final DatabaseHelper _db = DatabaseHelper();

class EditForm extends StatefulWidget {
  final int index;
  final List<Item> item;
  final StreamController streamController;

  const EditForm(
      {Key? key,
      required this.index,
      required this.item,
      required this.streamController,
      })
      : super(key: key);

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final TextEditingController _heading = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final _editFormKey = GlobalKey<FormState>();

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
                key: _editFormKey,
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
                      child: Text("Heading",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
                      child: TextFormField(
                        controller: _heading,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: widget.item[widget.index].heading,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15)),
                        readOnly: true,
                      ),
                    ),
                    const Text("Description",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
                      child: TextFormField(
                        controller: _description,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: widget.item[widget.index].description,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15)),
                        autofocus: true,
                      ),
                    ),
                    const Text("Price",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
                      child: TextFormField(
                        controller: _price,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: widget.item[widget.index].prices,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String heading = widget.item[widget.index].heading;
                        String description =
                            widget.item[widget.index].description;
                        String prices = widget.item[widget.index].prices;
                        heading = _heading.text.isEmpty
                            ? widget.item[widget.index].heading
                            : _heading.text;
                        prices = _price.text.isEmpty
                            ? widget.item[widget.index].prices
                            : _price.text;
                        description = _description.text.isEmpty
                            ? widget.item[widget.index].description
                            : _description.text;
                        await _update(heading, description, prices);
                        _editFormKey.currentState?.reset();
                         await query();
                        widget.streamController.sink.add(widget.item);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Save"),
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

  Future<void> _update(String itemHeading, String itemDescription, String itemPrice) async {
    await _db.init();
    final id = await _db.update(itemHeading, itemDescription, itemPrice);
    debugPrint('is updated : $id ');
  }
}
