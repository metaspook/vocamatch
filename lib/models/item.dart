class ItemModel {
  ItemModel({
    required this.name,
    required this.img,
    required this.value,
    this.accepting = false,
  });
  final String name;
  final String img;
  final String value;
  bool accepting;
}
