
import 'dart:math';

class FridgeItem {
  String name;
  String timeInFridge;
  DateTime? dateAdded;
  int? id;

  FridgeItem({ required this.name, required this.timeInFridge, this.id, this.dateAdded }) {
    id ??= _generateID();
  }

  // reading from API
  factory FridgeItem.fromJSON(dynamic json) {
    DateTime dateAdded = DateTime.parse(json['date_added'] as String);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateAdded);

    String timeInFridge = "";
    if (difference.inDays < 1) {
      timeInFridge = "< 1 day";
    } else {
      timeInFridge = difference.inDays as String;
    }
    return FridgeItem(
      name: json['item_name'] as String,
      timeInFridge: timeInFridge,
      id: json['item_id'] as int,
      dateAdded: dateAdded
    );
  }

  // writing to API
  Map<String, dynamic> toJson() =>
    {
      "item_id": id,
      "item_name": name
    };

  /*
   * generates a random 9 digit id
   * used when creating a item locally for the first time
   */
  int _generateID() {
    Random random = Random();
    return random.nextInt(900000000) + 100000000;
  }

  @override
  String toString() {
    return "Name: $name, ID: $id";
  }
}