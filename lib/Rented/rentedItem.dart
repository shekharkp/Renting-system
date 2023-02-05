class rentedItem
{
  String heading;
  String description;
  String prices;
  String personName;
  String phoneNumber;
  String noOfDays;

  rentedItem(this.heading,this.description,this.prices,this.personName,this.phoneNumber,this.noOfDays);

  Map<String,String> toMap()
  {
    return
      {
        'heading': heading,
        'description':description,
        'prices':prices,
        'personName':personName,
        'phoneNumber':phoneNumber,
        'noOfDays':noOfDays
      };
  }

  factory rentedItem.fromMap(Map<String,dynamic> item)
  {
    return rentedItem
      (
        item['heading'],
        item['description'],
        item['prices'],
        item['personName'],
        item['phoneNumber'],
        item['noOfDays']
    );
  }
}