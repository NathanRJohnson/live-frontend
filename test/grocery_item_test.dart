
import 'package:flutter_test/flutter_test.dart';
import 'package:project_l/wtfridge/model/grocery_item.dart';


void main() {
  test('item initialization', () {
    final item = GroceryItem(name: "G", isActive: false);

    expect(item.name, "G");
    expect(item.isActive, false);
    expect(item.id, isNotNull);
    expect(item.isBeingDeleted, false);
  });

  test('valid item from json', () {
    final Map<String, dynamic> json_object = {
      'item_id': 123,
      'item_name': 'G',
      'is_active': false,
    };

    final item = GroceryItem.fromJSON(json_object);

    expect(item.name, "G");
    expect(item.id, 123);
    expect(item.isActive, false);
  });

  test('missing date_added from json', () {
    final Map<String, dynamic> json_object = {
      'item_id': 123,
      'item_name': 'F',
    };

    expect(() => GroceryItem.fromJSON(json_object), throwsFormatException);
  });

  test('valid item to json', () {
    GroceryItem item = GroceryItem(
        id: 123, name: "F", isActive: true);

    Map<String, dynamic> json = item.toJson();
    print(json);
    assert(json.containsKey('item_id') && json['item_id'] == 123);
    assert(json.containsKey('item_name') && json['item_name'] == "F");
    assert(json.containsKey('is_active') && json['is_active'] == true);
    assert(!json.containsKey('is_being_deleted'));
  });

}