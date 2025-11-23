class Product {
  final int id;
  final String name;
  final String section;
  final int avgExpiryDays;
  final List<String> barcodes;

  const Product({required this.id, required this.name, required this.section, this.avgExpiryDays=-1, this.barcodes=const []});

  @override
  String toString() {
    return name;
  }
}