
import 'dart:math';

class GroceryItem {
  String name;
  bool isActive;
  bool visible = true;
  int? id;
  int index;

  bool isMoving = false;

  GroceryItem({ required this.name, this.isActive = false, this.id, this.index = -1}) {
    id ??= _generateID();
  }

  factory GroceryItem.fromJSON(Map<String, dynamic> json) {
    if (!json.containsKey('item_id') || !json.containsKey('item_name') || !json.containsKey('is_active')) {
      throw const FormatException("Missing required fields for GroceryItem in JSON");
    }

    return GroceryItem(
      id: json['item_id'] as int,
      name: json['item_name'] as String,
      isActive: json['is_active'] as bool,
      index: json['index'] as int
    );
  }

  Map<String, dynamic> toJson() =>
    {
      "item_id": id,
      "item_name": name,
      "is_active": isActive,
      "index": index
    };

  int _generateID() {
    Random random = Random();
    return random.nextInt(900000000) + 100000000;
  }
}


