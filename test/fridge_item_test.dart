
import 'package:flutter_test/flutter_test.dart';
import 'package:project_l/wtfridge/model/fridge_item.dart';


void main() {
  test('item initialization', () {
    final item = FridgeItem(name: "F", timeInFridge: "< 1 day");

    expect(item.name, "F");
    expect(item.timeInFridge, "< 1 day");
    expect(item.id, isNotNull);
    expect(item.dateAdded, isNull);
  });

  test('valid item from json', () {
    final Map<String, dynamic> json_object = {
      'item_id': 123,
      'item_name': 'F',
      'date_added': DateTime(2001).toString(),
    };

    final item = FridgeItem.fromJSON(json_object);

    expect(item.name, "F");
    expect(item.timeInFridge, isNotNull);
    expect(item.id, 123);
    expect(item.dateAdded, DateTime(2001));
  });

  test('missing date_added from json', () {
    final Map<String, dynamic> json_object = {
      'item_id': 123,
      'item_name': 'F',
    };

    expect(() => FridgeItem.fromJSON(json_object), throwsFormatException);
  });

  test('valid item to json', () {
    FridgeItem item = FridgeItem(
        id: 123, name: "F", dateAdded: DateTime(2001), timeInFridge: "< 1 day");

    Map<String, dynamic> json = item.toJson();
    assert(json.containsKey('item_id') && json['item_id'] == 123);
    assert(json.containsKey('item_name') && json['item_name'] == "F");
    assert(!json.containsKey('date_added'));
    assert(!json.containsKey('time_in_fridge'));
  });

}