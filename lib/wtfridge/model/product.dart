import 'package:project_l/wtfridge/model/fridge_item.dart';
import 'package:project_l/wtfridge/model/grocery_item.dart';

class Product {
  final int id;
  final String name;
  final String section;
  final int avgExpiryDays;
  final List<String> barcodes;

  const Product({required this.id, required this.name, required this.section, this.avgExpiryDays=-1, this.barcodes=const []});

  Map<String, String> toGroceryValues() {
    return <String, String> {
      "item_name": name,
      "quantity": "1",
      "notes": "",
      "section": section,
      "store": ""
    };
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return (other is GroceryItem && other.name == name)
        || (other is FridgeItem && other.name == name)
        || (other == name);
  }

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() {
    return name;
  }
}