import 'package:flutter/foundation.dart';

class Item
{
  String heading;
  String description;
  String prices;

 Item(this.heading,this.description,this.prices);

 Map<String,String> toMap()
 {
   return
       {
         'heading': heading,
         'description':description,
         'price':prices
       };
 }

 factory Item.fromMap(Map<String,dynamic> item)
  {
    return Item
    (
     item['heading'],
      item['description'],
      item['price']
    );
  }



}