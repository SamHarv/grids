class GridModel {
  final String gridID;
  String title;
  final String? image;
  final String dateModified;
  int x;
  int y;
  List<dynamic> colours;
  String shape;
  List<dynamic> gridValues;

  GridModel({
    required this.gridID,
    required this.title,
    this.image,
    required this.dateModified,
    required this.x,
    required this.y,
    required this.colours,
    required this.shape,
    required this.gridValues,
  });
}
