// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FridgeItemsTable extends FridgeItems
    with TableInfo<$FridgeItemsTable, FridgeItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FridgeItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tableIdMeta =
      const VerificationMeta('tableId');
  @override
  late final GeneratedColumn<int> tableId = GeneratedColumn<int>(
      'table_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateAddedMeta =
      const VerificationMeta('dateAdded');
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
      'date_added', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [tableId, itemId, name, dateAdded, quantity, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fridge_items';
  @override
  VerificationContext validateIntegrity(Insertable<FridgeItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('table_id')) {
      context.handle(_tableIdMeta,
          tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date_added')) {
      context.handle(_dateAddedMeta,
          dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta));
    } else if (isInserting) {
      context.missing(_dateAddedMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tableId};
  @override
  FridgeItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FridgeItem(
      tableId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}table_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dateAdded: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_added'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
    );
  }

  @override
  $FridgeItemsTable createAlias(String alias) {
    return $FridgeItemsTable(attachedDatabase, alias);
  }
}

class FridgeItem extends DataClass implements Insertable<FridgeItem> {
  final int tableId;
  final int itemId;
  final String name;
  final DateTime dateAdded;
  final int quantity;
  final String notes;
  const FridgeItem(
      {required this.tableId,
      required this.itemId,
      required this.name,
      required this.dateAdded,
      required this.quantity,
      required this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['table_id'] = Variable<int>(tableId);
    map['item_id'] = Variable<int>(itemId);
    map['name'] = Variable<String>(name);
    map['date_added'] = Variable<DateTime>(dateAdded);
    map['quantity'] = Variable<int>(quantity);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  FridgeItemsCompanion toCompanion(bool nullToAbsent) {
    return FridgeItemsCompanion(
      tableId: Value(tableId),
      itemId: Value(itemId),
      name: Value(name),
      dateAdded: Value(dateAdded),
      quantity: Value(quantity),
      notes: Value(notes),
    );
  }

  factory FridgeItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FridgeItem(
      tableId: serializer.fromJson<int>(json['tableId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      name: serializer.fromJson<String>(json['name']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      quantity: serializer.fromJson<int>(json['quantity']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tableId': serializer.toJson<int>(tableId),
      'itemId': serializer.toJson<int>(itemId),
      'name': serializer.toJson<String>(name),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
      'quantity': serializer.toJson<int>(quantity),
      'notes': serializer.toJson<String>(notes),
    };
  }

  FridgeItem copyWith(
          {int? tableId,
          int? itemId,
          String? name,
          DateTime? dateAdded,
          int? quantity,
          String? notes}) =>
      FridgeItem(
        tableId: tableId ?? this.tableId,
        itemId: itemId ?? this.itemId,
        name: name ?? this.name,
        dateAdded: dateAdded ?? this.dateAdded,
        quantity: quantity ?? this.quantity,
        notes: notes ?? this.notes,
      );
  FridgeItem copyWithCompanion(FridgeItemsCompanion data) {
    return FridgeItem(
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      name: data.name.present ? data.name.value : this.name,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FridgeItem(')
          ..write('tableId: $tableId, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tableId, itemId, name, dateAdded, quantity, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FridgeItem &&
          other.tableId == this.tableId &&
          other.itemId == this.itemId &&
          other.name == this.name &&
          other.dateAdded == this.dateAdded &&
          other.quantity == this.quantity &&
          other.notes == this.notes);
}

class FridgeItemsCompanion extends UpdateCompanion<FridgeItem> {
  final Value<int> tableId;
  final Value<int> itemId;
  final Value<String> name;
  final Value<DateTime> dateAdded;
  final Value<int> quantity;
  final Value<String> notes;
  const FridgeItemsCompanion({
    this.tableId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.name = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
  });
  FridgeItemsCompanion.insert({
    this.tableId = const Value.absent(),
    required int itemId,
    required String name,
    required DateTime dateAdded,
    required int quantity,
    required String notes,
  })  : itemId = Value(itemId),
        name = Value(name),
        dateAdded = Value(dateAdded),
        quantity = Value(quantity),
        notes = Value(notes);
  static Insertable<FridgeItem> custom({
    Expression<int>? tableId,
    Expression<int>? itemId,
    Expression<String>? name,
    Expression<DateTime>? dateAdded,
    Expression<int>? quantity,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (tableId != null) 'table_id': tableId,
      if (itemId != null) 'item_id': itemId,
      if (name != null) 'name': name,
      if (dateAdded != null) 'date_added': dateAdded,
      if (quantity != null) 'quantity': quantity,
      if (notes != null) 'notes': notes,
    });
  }

  FridgeItemsCompanion copyWith(
      {Value<int>? tableId,
      Value<int>? itemId,
      Value<String>? name,
      Value<DateTime>? dateAdded,
      Value<int>? quantity,
      Value<String>? notes}) {
    return FridgeItemsCompanion(
      tableId: tableId ?? this.tableId,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      dateAdded: dateAdded ?? this.dateAdded,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tableId.present) {
      map['table_id'] = Variable<int>(tableId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FridgeItemsCompanion(')
          ..write('tableId: $tableId, ')
          ..write('itemId: $itemId, ')
          ..write('name: $name, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $GroceryItemsTable extends GroceryItems
    with TableInfo<$GroceryItemsTable, GroceryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroceryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tableIdMeta =
      const VerificationMeta('tableId');
  @override
  late final GeneratedColumn<int> tableId = GeneratedColumn<int>(
      'table_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _indexMeta = const VerificationMeta('index');
  @override
  late final GeneratedColumn<int> index = GeneratedColumn<int>(
      'index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [tableId, itemId, index, name, isActive, quantity, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grocery_items';
  @override
  VerificationContext validateIntegrity(Insertable<GroceryItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('table_id')) {
      context.handle(_tableIdMeta,
          tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index']!, _indexMeta));
    } else if (isInserting) {
      context.missing(_indexMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tableId};
  @override
  GroceryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroceryItem(
      tableId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}table_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      index: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}index'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
    );
  }

  @override
  $GroceryItemsTable createAlias(String alias) {
    return $GroceryItemsTable(attachedDatabase, alias);
  }
}

class GroceryItem extends DataClass implements Insertable<GroceryItem> {
  final int tableId;
  final int itemId;
  final int index;
  final String name;
  final bool isActive;
  final int quantity;
  final String notes;
  const GroceryItem(
      {required this.tableId,
      required this.itemId,
      required this.index,
      required this.name,
      required this.isActive,
      required this.quantity,
      required this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['table_id'] = Variable<int>(tableId);
    map['item_id'] = Variable<int>(itemId);
    map['index'] = Variable<int>(index);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    map['quantity'] = Variable<int>(quantity);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  GroceryItemsCompanion toCompanion(bool nullToAbsent) {
    return GroceryItemsCompanion(
      tableId: Value(tableId),
      itemId: Value(itemId),
      index: Value(index),
      name: Value(name),
      isActive: Value(isActive),
      quantity: Value(quantity),
      notes: Value(notes),
    );
  }

  factory GroceryItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroceryItem(
      tableId: serializer.fromJson<int>(json['tableId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      index: serializer.fromJson<int>(json['index']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      quantity: serializer.fromJson<int>(json['quantity']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tableId': serializer.toJson<int>(tableId),
      'itemId': serializer.toJson<int>(itemId),
      'index': serializer.toJson<int>(index),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'quantity': serializer.toJson<int>(quantity),
      'notes': serializer.toJson<String>(notes),
    };
  }

  GroceryItem copyWith(
          {int? tableId,
          int? itemId,
          int? index,
          String? name,
          bool? isActive,
          int? quantity,
          String? notes}) =>
      GroceryItem(
        tableId: tableId ?? this.tableId,
        itemId: itemId ?? this.itemId,
        index: index ?? this.index,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
        quantity: quantity ?? this.quantity,
        notes: notes ?? this.notes,
      );
  GroceryItem copyWithCompanion(GroceryItemsCompanion data) {
    return GroceryItem(
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      index: data.index.present ? data.index.value : this.index,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroceryItem(')
          ..write('tableId: $tableId, ')
          ..write('itemId: $itemId, ')
          ..write('index: $index, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tableId, itemId, index, name, isActive, quantity, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroceryItem &&
          other.tableId == this.tableId &&
          other.itemId == this.itemId &&
          other.index == this.index &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.quantity == this.quantity &&
          other.notes == this.notes);
}

class GroceryItemsCompanion extends UpdateCompanion<GroceryItem> {
  final Value<int> tableId;
  final Value<int> itemId;
  final Value<int> index;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<int> quantity;
  final Value<String> notes;
  const GroceryItemsCompanion({
    this.tableId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.index = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
  });
  GroceryItemsCompanion.insert({
    this.tableId = const Value.absent(),
    required int itemId,
    required int index,
    required String name,
    required bool isActive,
    required int quantity,
    required String notes,
  })  : itemId = Value(itemId),
        index = Value(index),
        name = Value(name),
        isActive = Value(isActive),
        quantity = Value(quantity),
        notes = Value(notes);
  static Insertable<GroceryItem> custom({
    Expression<int>? tableId,
    Expression<int>? itemId,
    Expression<int>? index,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<int>? quantity,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (tableId != null) 'table_id': tableId,
      if (itemId != null) 'item_id': itemId,
      if (index != null) 'index': index,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (quantity != null) 'quantity': quantity,
      if (notes != null) 'notes': notes,
    });
  }

  GroceryItemsCompanion copyWith(
      {Value<int>? tableId,
      Value<int>? itemId,
      Value<int>? index,
      Value<String>? name,
      Value<bool>? isActive,
      Value<int>? quantity,
      Value<String>? notes}) {
    return GroceryItemsCompanion(
      tableId: tableId ?? this.tableId,
      itemId: itemId ?? this.itemId,
      index: index ?? this.index,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tableId.present) {
      map['table_id'] = Variable<int>(tableId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroceryItemsCompanion(')
          ..write('tableId: $tableId, ')
          ..write('itemId: $itemId, ')
          ..write('index: $index, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FridgeItemsTable fridgeItems = $FridgeItemsTable(this);
  late final $GroceryItemsTable groceryItems = $GroceryItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [fridgeItems, groceryItems];
}

typedef $$FridgeItemsTableCreateCompanionBuilder = FridgeItemsCompanion
    Function({
  Value<int> tableId,
  required int itemId,
  required String name,
  required DateTime dateAdded,
  required int quantity,
  required String notes,
});
typedef $$FridgeItemsTableUpdateCompanionBuilder = FridgeItemsCompanion
    Function({
  Value<int> tableId,
  Value<int> itemId,
  Value<String> name,
  Value<DateTime> dateAdded,
  Value<int> quantity,
  Value<String> notes,
});

class $$FridgeItemsTableFilterComposer
    extends Composer<_$AppDatabase, $FridgeItemsTable> {
  $$FridgeItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get tableId => $composableBuilder(
      column: $table.tableId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
      column: $table.dateAdded, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$FridgeItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $FridgeItemsTable> {
  $$FridgeItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get tableId => $composableBuilder(
      column: $table.tableId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
      column: $table.dateAdded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$FridgeItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FridgeItemsTable> {
  $$FridgeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get tableId =>
      $composableBuilder(column: $table.tableId, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$FridgeItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FridgeItemsTable,
    FridgeItem,
    $$FridgeItemsTableFilterComposer,
    $$FridgeItemsTableOrderingComposer,
    $$FridgeItemsTableAnnotationComposer,
    $$FridgeItemsTableCreateCompanionBuilder,
    $$FridgeItemsTableUpdateCompanionBuilder,
    (FridgeItem, BaseReferences<_$AppDatabase, $FridgeItemsTable, FridgeItem>),
    FridgeItem,
    PrefetchHooks Function()> {
  $$FridgeItemsTableTableManager(_$AppDatabase db, $FridgeItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FridgeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FridgeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FridgeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> tableId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> dateAdded = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String> notes = const Value.absent(),
          }) =>
              FridgeItemsCompanion(
            tableId: tableId,
            itemId: itemId,
            name: name,
            dateAdded: dateAdded,
            quantity: quantity,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> tableId = const Value.absent(),
            required int itemId,
            required String name,
            required DateTime dateAdded,
            required int quantity,
            required String notes,
          }) =>
              FridgeItemsCompanion.insert(
            tableId: tableId,
            itemId: itemId,
            name: name,
            dateAdded: dateAdded,
            quantity: quantity,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FridgeItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FridgeItemsTable,
    FridgeItem,
    $$FridgeItemsTableFilterComposer,
    $$FridgeItemsTableOrderingComposer,
    $$FridgeItemsTableAnnotationComposer,
    $$FridgeItemsTableCreateCompanionBuilder,
    $$FridgeItemsTableUpdateCompanionBuilder,
    (FridgeItem, BaseReferences<_$AppDatabase, $FridgeItemsTable, FridgeItem>),
    FridgeItem,
    PrefetchHooks Function()>;
typedef $$GroceryItemsTableCreateCompanionBuilder = GroceryItemsCompanion
    Function({
  Value<int> tableId,
  required int itemId,
  required int index,
  required String name,
  required bool isActive,
  required int quantity,
  required String notes,
});
typedef $$GroceryItemsTableUpdateCompanionBuilder = GroceryItemsCompanion
    Function({
  Value<int> tableId,
  Value<int> itemId,
  Value<int> index,
  Value<String> name,
  Value<bool> isActive,
  Value<int> quantity,
  Value<String> notes,
});

class $$GroceryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $GroceryItemsTable> {
  $$GroceryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get tableId => $composableBuilder(
      column: $table.tableId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get index => $composableBuilder(
      column: $table.index, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$GroceryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroceryItemsTable> {
  $$GroceryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get tableId => $composableBuilder(
      column: $table.tableId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get index => $composableBuilder(
      column: $table.index, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$GroceryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroceryItemsTable> {
  $$GroceryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get tableId =>
      $composableBuilder(column: $table.tableId, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get index =>
      $composableBuilder(column: $table.index, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$GroceryItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroceryItemsTable,
    GroceryItem,
    $$GroceryItemsTableFilterComposer,
    $$GroceryItemsTableOrderingComposer,
    $$GroceryItemsTableAnnotationComposer,
    $$GroceryItemsTableCreateCompanionBuilder,
    $$GroceryItemsTableUpdateCompanionBuilder,
    (
      GroceryItem,
      BaseReferences<_$AppDatabase, $GroceryItemsTable, GroceryItem>
    ),
    GroceryItem,
    PrefetchHooks Function()> {
  $$GroceryItemsTableTableManager(_$AppDatabase db, $GroceryItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroceryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroceryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroceryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> tableId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<int> index = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String> notes = const Value.absent(),
          }) =>
              GroceryItemsCompanion(
            tableId: tableId,
            itemId: itemId,
            index: index,
            name: name,
            isActive: isActive,
            quantity: quantity,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> tableId = const Value.absent(),
            required int itemId,
            required int index,
            required String name,
            required bool isActive,
            required int quantity,
            required String notes,
          }) =>
              GroceryItemsCompanion.insert(
            tableId: tableId,
            itemId: itemId,
            index: index,
            name: name,
            isActive: isActive,
            quantity: quantity,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GroceryItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroceryItemsTable,
    GroceryItem,
    $$GroceryItemsTableFilterComposer,
    $$GroceryItemsTableOrderingComposer,
    $$GroceryItemsTableAnnotationComposer,
    $$GroceryItemsTableCreateCompanionBuilder,
    $$GroceryItemsTableUpdateCompanionBuilder,
    (
      GroceryItem,
      BaseReferences<_$AppDatabase, $GroceryItemsTable, GroceryItem>
    ),
    GroceryItem,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FridgeItemsTableTableManager get fridgeItems =>
      $$FridgeItemsTableTableManager(_db, _db.fridgeItems);
  $$GroceryItemsTableTableManager get groceryItems =>
      $$GroceryItemsTableTableManager(_db, _db.groceryItems);
}
