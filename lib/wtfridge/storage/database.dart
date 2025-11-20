import 'package:drift/drift.dart';
import 'package:project_l/wtfridge/platform/platform.dart';

part 'database.g.dart';

class FridgeItems extends Table {
  IntColumn get tableId => integer().autoIncrement()();
  IntColumn get itemId => integer()();
  TextColumn get name => text()();
  DateTimeColumn get dateAdded => dateTime()();
  IntColumn get quantity => integer()();
  TextColumn get notes => text().withLength(min:0, max: 64)();
}

class GroceryItems extends Table {
  IntColumn get tableId => integer().autoIncrement()();
  IntColumn get itemId => integer()();
  IntColumn get index => integer()();
  TextColumn get name => text()();
  BoolColumn get isActive => boolean()();
  IntColumn get quantity => integer()();
  TextColumn get notes => text().withLength(min:0, max: 64)();
}

@DriftDatabase(tables: [FridgeItems, GroceryItems])
class AppDatabase extends _$AppDatabase {

  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  static final AppDatabase _instance = AppDatabase(Platform.createDatabaseConnection("test-wtfridge-database"));

  static AppDatabase get instance => _instance;

  Future<void> updateGroceryIndicies(int oldIndex, int newIndex) async {
    late final Insertable<GroceryItem> shift;

    if (oldIndex < newIndex) {
      shift = GroceryItemsCompanion.custom(
          index: groceryItems.index - const Constant(1)
      );
    } else {
      shift = GroceryItemsCompanion.custom(
          index: groceryItems.index + const Constant(1)
      );
      (oldIndex, newIndex) = (newIndex, oldIndex);
    }

    await transaction(() async {
      await (update(groceryItems)
        ..where((g) =>
            g.index.isBiggerOrEqual(Constant(oldIndex))
            & g.index.isSmallerOrEqual(Constant(newIndex))
        ))
        .write(shift);
    });

  }
}

