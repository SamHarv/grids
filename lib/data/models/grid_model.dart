class Grid {
  /// [Grid] model class is a model class that contains the properties of a grid.
  final String gridID;
  String title;
  final String? image; // Not in use
  final String dateModified;
  int x; // Number of columns
  int y; // Number of rows
  List<dynamic> colours;
  String shape; // Circle or square
  List<dynamic> gridValues; // Colour value of each dot

  Grid({
    required this.gridID,
    required this.title,
    this.image, // Not in use
    required this.dateModified,
    required this.x,
    required this.y,
    required this.colours,
    required this.shape,
    required this.gridValues,
  });
}
