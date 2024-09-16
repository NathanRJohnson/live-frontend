
import 'dart:math';

class GroceryItem {
  String name;
  bool isActive;
  int? id;
  int index;
  int quantity;
  String notes;

  GroceryItem({ required this.name, this.isActive = false, this.id, this.index = -1, this.quantity=1, this.notes=""}) {
    id ??= _generateID();
  }

  GroceryItem copy() {
    return GroceryItem(id: id, name: name, isActive: isActive, index: index, quantity: quantity, notes: notes);
  }

  factory GroceryItem.fromJSON(Map<String, dynamic> json) {
    if (!json.containsKey('item_id') || !json.containsKey('item_name') || !json.containsKey('is_active')) {
      throw const FormatException("Missing required fields for GroceryItem in JSON");
    }

    if (!json.containsKey('quantity') || json["quantity"] <= 0) {
      json["quantity"] = 1;
    }

    return GroceryItem(
      id: json['item_id'] as int,
      name: json['item_name'] as String,
      isActive: json['is_active'] as bool,
      index: json['index'] as int,
      quantity: json['quantity'] as int,
      notes: json['notes'] as String
    );
  }

  Map<String, dynamic> toJson() =>
    {
      "item_id": id,
      "item_name": name,
      "is_active": isActive,
      "index": index,
      "quantity": quantity,
      "notes": notes
    };

  int _generateID() {
    Random random = Random();
    return random.nextInt(900000000) + 100000000;
  }

  @override
  String toString() {
    return name;
  }
}


