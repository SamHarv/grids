import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../config/constants.dart';
import '../../data/database/firestore.dart';
import '../../data/models/grid_model.dart';

class ColourCheckboxWidget extends StatefulWidget {
  /// Checkbox for enabling/disabling colours in the grid

  final Grid grid;
  final Color colour;
  final String colourString;
  final int index;
  final AudioPlayer clicker;
  final bool isDarkMode;
  final bool enabled;
  final Firestore db;

  const ColourCheckboxWidget({
    super.key,
    required this.grid,
    required this.colour,
    required this.colourString,
    required this.index,
    required this.clicker,
    required this.isDarkMode,
    required this.enabled,
    required this.db,
  });

  @override
  State<ColourCheckboxWidget> createState() => _ColourCheckboxWidgetState();
}

class _ColourCheckboxWidgetState extends State<ColourCheckboxWidget> {
  late bool colourIsEnabled = widget.enabled;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: WidgetStateProperty.all(widget.colour),
          value: colourIsEnabled,
          onChanged: (value) async {
            await widget.clicker.setAsset('assets/click.mov');
            widget.clicker.play();
            int index = widget.index;
            // If the colour is enabled, disable it and set each occurrence
            // on the grid to black
            if (colourIsEnabled == true) {
              for (int i = 0; i < widget.grid.gridValues.length; i++) {
                if (widget.grid.gridValues[i] == widget.colourString) {
                  setState(() {
                    widget.grid.gridValues[i] = "black";
                  });
                }
              }
              widget.grid.colours[index] = "none";
            } else {
              // If the colour is disabled, enable it
              widget.grid.colours[index] = widget.colourString;
            }
            setState(() {
              colourIsEnabled = value!;
            });
            // Update the grid in the database
            await widget.db.updateGrid(grid: widget.grid);
          },
        ),
        // Name of colour
        Text(
          "${widget.colourString[0].toUpperCase()}${widget.colourString.substring(1).toLowerCase()}",
          style: widget.isDarkMode ? darkModeFont : lightModeFont,
        ),
      ],
    );
  }
}
