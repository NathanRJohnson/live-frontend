
import 'dart:math';

class FridgeItem {
  String name;
  String timeInFridge;
  DateTime? dateAdded;
  int quantity;
  String notes;
  int? id;

  FridgeItem({ required this.name, this.timeInFridge = "< 1 day", this.id, this.dateAdded, this.quantity = 1, this.notes = "" }) {
    id ??= _generateID();
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateAdded!);

    timeInFridge = _getDateDisplayMessage(difference);
  }

  factory FridgeItem.fromJSON(Map<String, dynamic> json) {
    if (!json.containsKey('item_id') || !json.containsKey('date_added') || !json.containsKey('item_name')) {
      throw const FormatException("Missing required fields for FridgeItem in JSON");
    }

    DateTime dateAdded = DateTime.parse(json['date_added'] as String);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateAdded);

    String timeInFridge = _getDateDisplayMessage(difference);

    int quantity = json.containsKey('quantity') ? json['quantity'] as int : 1;
    String notes =  json.containsKey('notes') ? json['notes'] as String : "";


    return FridgeItem(
      name: json['item_name'] as String,
      timeInFridge: timeInFridge,
      dateAdded: dateAdded,
      quantity: quantity,
      notes: notes,
      id: json['item_id'] as int,
    );
  }

  // writing to API
  Map<String, dynamic> toJson() =>
    {
      "item_id": id,
      "item_name": name,
      "quantity": quantity,
      "notes": notes,
      // "date_added": dateAdded
    };

  @override
  String toString() {
    return "Name: $name, ID: $id";
  }

  /*
   * generates a random 9 digit id
   * used when creating a item locally for the first time
   */
  static int _generateID() {
    Random random = Random();
    return random.nextInt(900000000) + 100000000;
  }

  static String _getDateDisplayMessage(Duration d) {
    String timeInFridge = "";
    if (d.inDays < 1) {
      timeInFridge = "< 1 day";
    } else if (d.inDays == 1) {
      timeInFridge = "1 day";
    } else {
      timeInFridge = "${d.inDays} days";
    }

    return timeInFridge;
  }
}
