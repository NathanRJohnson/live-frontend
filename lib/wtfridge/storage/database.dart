import 'package:drift/drift.dart';
import 'package:project_l/wtfridge/platform/platform.dart';
import 'package:project_l/wtfridge/storage/database.steps.dart';

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
  TextColumn get section => text().withLength(min:0, max: 64).nullable()();
  TextColumn get store => text().withLength(min:0, max: 64).nullable()();
}

class Products extends Table {
  IntColumn get tableId => integer().autoIncrement()();
  IntColumn get id => integer()();
  TextColumn get name => text().withLength(min: 0, max: 64)();
  TextColumn get section => text().withLength(min: 0, max: 64)();
  IntColumn get avgExpiryDays => integer()();
  BlobColumn get barcodes => blob()();
}

@DriftDatabase(tables: [FridgeItems, GroceryItems, Products])
class AppDatabase extends _$AppDatabase {

  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 2;

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

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: _schemaUpgrade
    );
  }
}

extension Migrations on GeneratedDatabase {
  // Extracting the `stepByStep` call into a static field or method ensures that you're not
  // accidentally referring to the current database schema (via a getter on the database class).
  // This ensures that each step brings the database into the correct snapshot.
  OnUpgrade get _schemaUpgrade => stepByStep(
    from1To2: (m, schema) async {
      await m.createTable(schema.products);
      await m.addColumn(schema.groceryItems, schema.groceryItems.section);
      await m.addColumn(schema.groceryItems, schema.groceryItems.store);
    },
  );
}

