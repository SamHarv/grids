import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../config/constants.dart';
import '../../logic/providers/providers.dart';
import '../../logic/services/colour_conversion.dart';
import '../../data/models/grid_model.dart';
import '../widgets/glass_morphism.dart';
import '../widgets/toolbar_item_widget.dart';
import '../widgets/custom_dialog_widget.dart';
import '../widgets/colour_checkbox_widget.dart';

class GridPage extends ConsumerStatefulWidget {
  /// Display a [grid] - called GridPage rather than GridView to avoid conflict
  /// with Flutter's GridView

  final Grid grid;
  final String gridID;

  const GridPage({super.key, required this.grid, required this.gridID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewGridPageState();
}

class _NewGridPageState extends ConsumerState<GridPage> {
  late AudioPlayer pop = AudioPlayer();
  late AudioPlayer clicker = AudioPlayer();
  late AudioPlayer multiPopUp = AudioPlayer();
  late AudioPlayer multiPopDown = AudioPlayer();
  late AudioPlayer whoosh = AudioPlayer();
  late TextEditingController titleController;
  final colourConverter = ColourConversion();

  late bool greenIsEnabled;
  late bool redIsEnabled;
  late bool blueIsEnabled;
  late bool yellowIsEnabled;
  late bool pinkIsEnabled;
  late bool orangeIsEnabled;

  @override
  void initState() {
    super.initState();
    pop = AudioPlayer();
    clicker = AudioPlayer();
    multiPopUp = AudioPlayer();
    multiPopDown = AudioPlayer();
    whoosh = AudioPlayer();
  }

  @override
  void dispose() {
    pop.dispose();
    clicker.dispose();
    multiPopUp.dispose();
    multiPopDown.dispose();
    whoosh.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.read(firestore);
    final isDarkMode = ref.watch(darkMode);
    final barIsBottom = ref.read(barBottom);
    titleController = TextEditingController(text: widget.grid.title);
    int count =
        ref.watch(xProvider) * ref.watch(yProvider); // total number of dots
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: isDarkMode ? Colors.white : Colors.black,
          // Ensure grid is saved
          onPressed: () async {
            await clicker.setAsset('assets/click.mov');
            clicker.play();
            // Create updated grid object
            final updatedGrid = Grid(
              gridID: widget.gridID,
              title: titleController.text,
              dateModified: DateTime.now().toString(),
              x: widget.grid.x,
              y: widget.grid.y,
              colours: widget.grid.colours,
              shape: widget.grid.shape,
              gridValues: widget.grid.gridValues,
            );
            // Update grid in Firestore
            await db.updateGrid(grid: updatedGrid);
            // ignore: use_build_context_synchronously
            Beamer.of(context).beamToNamed('/grids');
          },
        ),
        // Grid title
        title: SizedBox(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextField(
              onChanged: (value) {
                widget.grid.title = value; // update grid title
              },
              showCursor: true,
              maxLines: 1,
              minLines: 1,
              controller: titleController,
              style: isDarkMode ? darkModeLargeFont : lightModeLargeFont,
              decoration: InputDecoration(
                hintText: widget.grid.title,
                hintStyle: isDarkMode ? darkModeLargeFont : lightModeLargeFont,
                border: InputBorder.none,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ),
        actions: [
          // Delete grid
          IconButton(
            icon: const Icon(Icons.delete),
            color: isDarkMode ? white : black,
            onPressed: () async {
              await clicker.setAsset('assets/click.mov');
              await clicker.play();
              // Show delete confirmation dialog
              showDialog(
                // ignore: use_build_context_synchronously
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogWidget(
                    dialogHeading: 'Delete Grid',
                    dialogContent: Text(
                      'Are you sure you want to delete this grid?',
                      style: isDarkMode ? darkModeFont : lightModeFont,
                    ),
                    dialogActions: [
                      // Cancel deletion
                      TextButton(
                        onPressed: () async {
                          await clicker.setAsset('assets/click.mov');
                          clicker.play();
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: isDarkMode ? darkModeFont : lightModeFont,
                        ),
                      ),
                      // Confirm deletion
                      TextButton(
                        onPressed: () async {
                          await whoosh.setAsset('assets/whoosh.mov');
                          whoosh.play();
                          // Delete grid from Firestore
                          await db.deleteGrid(gridID: widget.gridID);
                          // ignore: use_build_context_synchronously
                          Beamer.of(context).beamToNamed('/grids');
                        },
                        child: Text(
                          "Delete",
                          style: isDarkMode ? darkModeFont : lightModeFont,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: Stack(
        children: [
          // Display grid
          Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ref.watch(xProvider),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: count,
              itemBuilder: (context, index) {
                // Value of dot of current index
                String dot = widget.grid.gridValues[index];
                return InkWell(
                  borderRadius: widget.grid.shape == "circle"
                      ? BorderRadius.circular(256)
                      : BorderRadius.circular(4),
                  onTap: () async {
                    await pop.setAsset('assets/deep.mov');
                    pop.play();
                    // Logic to change colour of dot
                    // List of colours where disabled colours are "none"
                    List colours = widget.grid.colours;
                    // Cycle through 7 colours in outerLoop
                    outerLoop:
                    for (int i = 0; i < colours.length; i++) {
                      // Find current colour
                      if (colours[i] == dot) {
                        // Determine how many disabled colours to skip
                        for (int j = 1; i + j < colours.length; j++) {
                          // Skip disabled colours
                          if (colours[i + j] != "none") {
                            // Assign the next enabled colour
                            dot = colours[i + j];
                            break outerLoop;
                          }
                        }
                        // If no proceeding enabled colours, back to first colour
                        dot = colours[0];
                        break outerLoop;
                      } else if (!colours.contains(dot)) {
                        // If current colour has now been disabled, back to first colour
                        dot = colours[0];
                        break outerLoop;
                      }
                    }
                    // Update grid value
                    setState(() {
                      widget.grid.gridValues[index] = dot;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // Border around each dot if not filled
                      border: Border.all(
                        color: dot == "black"
                            ? isDarkMode
                                ? white
                                : black
                            : Colors.transparent,
                        width: 1,
                      ),
                      // Fill colour of each dot
                      color: dot == "black"
                          ? Colors.transparent
                          : colourConverter.getColourFromString(dot),
                      // Circle or square
                      borderRadius: widget.grid.shape == 'circle'
                          ? BorderRadius.circular(256)
                          : BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
          // Toolbar
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Align(
              // Moveable toolbar
              alignment:
                  barIsBottom ? Alignment.bottomCenter : Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: GlassMorphism(
                  blur: 10,
                  opacity: 0.2,
                  clipRadius: const BorderRadius.all(
                    Radius.circular(128),
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(128),
                  ),
                  color:
                      isDarkMode ? Colors.grey.shade100 : Colors.grey.shade900,
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Enable/ disable colours with checkboxes in dialog
                        ToolbarItemWidget(
                          icon: Icons.palette,
                          onTap: () async {
                            await clicker.setAsset('assets/click.mov');
                            clicker.play();
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (context) => StatefulBuilder(
                                builder: (context, setState) {
                                  greenIsEnabled =
                                      widget.grid.colours[1] == "green";
                                  redIsEnabled =
                                      widget.grid.colours[2] == "red";
                                  blueIsEnabled =
                                      widget.grid.colours[3] == "blue";
                                  yellowIsEnabled =
                                      widget.grid.colours[4] == "yellow";
                                  pinkIsEnabled =
                                      widget.grid.colours[5] == "pink";
                                  orangeIsEnabled =
                                      widget.grid.colours[6] == "orange";
                                  return CustomDialogWidget(
                                    dialogHeading: "Select Colours",
                                    dialogContent: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ColourCheckboxWidget(
                                          grid: widget.grid,
                                          colour: green,
                                          colourString: "green",
                                          index: 1,
                                          clicker: clicker,
                                          isDarkMode: isDarkMode,
                                          enabled: greenIsEnabled,
                                          db: db,
                                        ),
                                        ColourCheckboxWidget(
                                          grid: widget.grid,
                                          colour: red,
                                          colourString: "red",
                                          index: 2,
                                          clicker: clicker,
                                          isDarkMode: isDarkMode,
                                          enabled: redIsEnabled,
                                          db: db,
                                        ),
                                        ColourCheckboxWidget(
                                          grid: widget.grid,
                                          colour: blue,
                                          colourString: "blue",
                                          index: 3,
                                          clicker: clicker,
                                          isDarkMode: isDarkMode,
                                          enabled: blueIsEnabled,
                                          db: db,
                                        ),
                                        ColourCheckboxWidget(
                                          grid: widget.grid,
                                          colour: yellow,
                                          colourString: "yellow",
                                          index: 4,
                                          clicker: clicker,
                                          isDarkMode: isDarkMode,
                                          enabled: yellowIsEnabled,
                                          db: db,
                                        ),
                                        ColourCheckboxWidget(
                                          grid: widget.grid,
                                          colour: pink,
                                          colourString: "pink",
                                          index: 5,
                                          clicker: clicker,
                                          isDarkMode: isDarkMode,
                                          enabled: pinkIsEnabled,
                                          db: db,
                                        ),
                                        ColourCheckboxWidget(
                                          grid: widget.grid,
                                          colour: orange,
                                          colourString: "orange",
                                          index: 6,
                                          clicker: clicker,
                                          isDarkMode: isDarkMode,
                                          enabled: orangeIsEnabled,
                                          db: db,
                                        ),
                                      ],
                                    ),
                                    dialogActions: [
                                      TextButton(
                                        onPressed: () async {
                                          await clicker
                                              .setAsset('assets/click.mov');
                                          clicker.play();
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Done",
                                          style: isDarkMode
                                              ? darkModeFont
                                              : lightModeFont,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        // Adjust the scale of the grid (x rows and y columns)
                        // in a dialog
                        ToolbarItemWidget(
                          icon: Icons.height,
                          onTap: () async {
                            await clicker.setAsset('assets/click.mov');
                            clicker.play();
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (context) => StatefulBuilder(
                                builder: (context, setState) {
                                  return CustomDialogWidget(
                                    dialogHeading: "Adjust Scale",
                                    dialogContent: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Display number of rows (x)
                                        Text(
                                          'x: ${widget.grid.x.toString()}',
                                          style: isDarkMode
                                              ? darkModeFont
                                              : lightModeFont,
                                        ),
                                        // Adjust number of rows (x)
                                        Slider(
                                          label: widget.grid.x.toString(),
                                          min: 3,
                                          max: 14, // fortnight
                                          value: widget.grid.x.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              widget.grid.x = value.toInt();
                                              ref
                                                  .read(xProvider.notifier)
                                                  .state = widget.grid.x;
                                            });
                                          },
                                        ),
                                        // Display number of columns (y)
                                        Text(
                                          'y: ${widget.grid.y.toString()}',
                                          style: isDarkMode
                                              ? darkModeFont
                                              : lightModeFont,
                                        ),
                                        // Adjust number of columns (y)
                                        Slider(
                                          label: widget.grid.y.toString(),
                                          min: 1,
                                          max: 104, // max 4 years of
                                          // fortnights
                                          value: widget.grid.y.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              widget.grid.y = value.toInt();
                                              ref
                                                  .read(yProvider.notifier)
                                                  .state = widget.grid.y;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    dialogActions: [
                                      TextButton(
                                        onPressed: () async {
                                          await clicker
                                              .setAsset('assets/click.mov');
                                          clicker.play();
                                          await db.updateGrid(
                                              grid: widget.grid);
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Done",
                                          style: isDarkMode
                                              ? darkModeFont
                                              : lightModeFont,
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        // Save the grid
                        ToolbarItemWidget(
                          icon: Icons.save,
                          onTap: () async {
                            await clicker.setAsset('assets/click.mov');
                            clicker.play();
                            // Create updated grid object
                            final updatedGrid = Grid(
                              gridID: widget.gridID,
                              title: titleController.text,
                              dateModified: DateTime.now().toString(),
                              x: widget.grid.x,
                              y: widget.grid.y,
                              colours: widget.grid.colours,
                              shape: widget.grid.shape,
                              gridValues: widget.grid.gridValues,
                            );
                            // Update grid in Firestore
                            await db.updateGrid(grid: updatedGrid);
                            // Confirm save
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (context) {
                                return CustomDialogWidget(
                                  dialogHeading: "Saved!",
                                  dialogActions: [
                                    TextButton(
                                        child: Text(
                                          "Dismiss",
                                          style: isDarkMode
                                              ? darkModeFont
                                              : lightModeFont,
                                        ),
                                        onPressed: () async {
                                          await clicker
                                              .setAsset('assets/click.mov');
                                          clicker.play();
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        })
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        // Change shape of dots from circle to square or vice versa
                        ToolbarItemWidget(
                          // Icon to be square if dots are circle, and vice versa
                          icon: widget.grid.shape == 'circle'
                              ? Icons.square_outlined
                              : Icons.circle_outlined,
                          onTap: () async {
                            // Toggle between circle and square
                            if (widget.grid.shape == 'circle') {
                              await multiPopUp
                                  .setAsset('assets/multi_pop_up.mov');
                              multiPopUp.play();
                              setState(() {
                                widget.grid.shape = 'square';
                              });
                            } else {
                              await multiPopDown
                                  .setAsset('assets/multi_pop_down.mov');
                              multiPopDown.play();
                              setState(() {
                                widget.grid.shape = 'circle';
                              });
                            }
                          },
                        ),
                        // Change the position of the toolbar (top or bottom)
                        ToolbarItemWidget(
                          icon: Icons.swap_vert,
                          onTap: () async {
                            await clicker.setAsset('assets/click.mov');
                            clicker.play();
                            setState(() {
                              barIsBottom
                                  ? ref.read(barBottom.notifier).state = false
                                  : ref.read(barBottom.notifier).state = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
