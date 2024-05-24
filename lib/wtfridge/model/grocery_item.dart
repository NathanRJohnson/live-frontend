
import 'dart:math';

class GroceryItem {
  String name;
  bool isActive;
bool isBeingDeleted = false;
  int? id;

  GroceryItem({ required this.name, this.isActive = false, this.id }) {
    id ??= _generateID();
  }

  factory GroceryItem.fromJSON(dynamic json) {
    return GroceryItem(
      id: json['item_id'] as int,
      name: json['item_name'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() =>
    {
      "item_id": id,
      "item_name": name,
      "is_active": isActive,
    };

  int _generateID() {
    Random random = Random();
    return random.nextInt(900000000) + 100000000;
  }
}


