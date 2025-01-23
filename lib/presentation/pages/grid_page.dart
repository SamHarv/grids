import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '/presentation/widgets/glass_morphism.dart';
import '/controller/constants/constants.dart';
import '/controller/state_management/providers.dart';
import '/data/model/colour_conversions.dart';
import '/data/model/grid_model.dart';
import '../widgets/bottom_nav_bar_menu_widget.dart';
import '../widgets/custom_dialog_widget.dart';

class GridPage extends ConsumerStatefulWidget {
  final GridModel grid;
  final String gridID;

  const GridPage({super.key, required this.grid, required this.gridID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewGridPageState();
}

class _NewGridPageState extends ConsumerState<GridPage> {
  late AudioPlayer pop = AudioPlayer();
  late AudioPlayer clicker = AudioPlayer();
  late AudioPlayer bell = AudioPlayer();
  late AudioPlayer multiPopUp = AudioPlayer();
  late AudioPlayer multiPopDown = AudioPlayer();
  late AudioPlayer whoosh = AudioPlayer();
  late TextEditingController titleController;

  late bool greenIsChecked;
  late bool redIsChecked;
  late bool blueIsChecked;
  late bool yellowIsChecked;
  late bool pinkIsChecked;
  late bool orangeIsChecked;

  @override
  void initState() {
    super.initState();
    pop = AudioPlayer();
    clicker = AudioPlayer();
    bell = AudioPlayer();
    multiPopUp = AudioPlayer();
    multiPopDown = AudioPlayer();
    whoosh = AudioPlayer();
  }

  @override
  void dispose() {
    pop.dispose();
    clicker.dispose();
    bell.dispose();
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
    final colourConverter = ColourConversions();
    int count = ref.watch(xProvider) * ref.watch(yProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: isDarkMode ? Colors.white : Colors.black,
          onPressed: () async {
            await clicker.setAsset('assets/click.mov');
            clicker.play();
            final updatedGrid = GridModel(
              gridID: widget.gridID,
              title: titleController.text,
              dateModified: DateTime.now().toString(),
              x: widget.grid.x,
              y: widget.grid.y,
              colours: widget.grid.colours,
              shape: widget.grid.shape,
              gridValues: widget.grid.gridValues,
            );
            await db.updateGrid(grid: updatedGrid);
            // ignore: use_build_context_synchronously
            Beamer.of(context).beamToNamed('/grids');
          },
        ),
        title: SizedBox(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextField(
              onChanged: (value) {
                widget.grid.title = value;
              },
              showCursor: true,
              maxLines: 1,
              minLines: 1,
              controller: titleController,
              style: isDarkMode ? darkLargeFont : lightLargeFont,
              decoration: InputDecoration(
                hintText: widget.grid.title,
                hintStyle: isDarkMode ? darkLargeFont : lightLargeFont,
                border: InputBorder.none,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            color: isDarkMode ? white : black,
            onPressed: () async {
              await clicker.setAsset('assets/click.mov');
              await clicker.play();
              showDialog(
                // ignore: use_build_context_synchronously
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogWidget(
                    dialogHeading: 'Delete Grid',
                    dialogContent: Text(
                      'Are you sure you want to delete this grid?',
                      style: isDarkMode ? darkFont : lightFont,
                    ),
                    dialogActions: [
                      TextButton(
                        onPressed: () async {
                          await clicker.setAsset('assets/click.mov');
                          clicker.play();
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: isDarkMode ? darkFont : lightFont,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await whoosh.setAsset('assets/whoosh.mov');
                          whoosh.play();
                          await db.deleteGrid(gridID: widget.gridID);
                          // ignore: use_build_context_synchronously
                          Beamer.of(context).beamToNamed('/grids');
                        },
                        child: Text(
                          "Delete",
                          style: isDarkMode ? darkFont : lightFont,
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
                String dot = widget.grid.gridValues[index];
                return InkWell(
                  borderRadius: widget.grid.shape == "circle"
                      ? BorderRadius.circular(64)
                      : BorderRadius.circular(4),
                  onTap: () async {
                    await pop.setAsset('assets/deep.mov');
                    pop.play();

                    for (int i = 0; i < widget.grid.colours.length; i++) {
                      if (!widget.grid.colours.contains(dot)) {
                        dot = widget.grid.colours[0];
                        break;
                      }
                      if (dot == widget.grid.colours[i]) {
                        if (i == widget.grid.colours.length - 1) {
                          dot = widget.grid.colours[0];
                          // break;
                        } else {
                          if (i + 1 < 7 &&
                              widget.grid.colours[i + 1] == "none") {
                            if (i + 2 < 7 &&
                                widget.grid.colours[i + 2] == "none") {
                              if (i + 3 < 7 &&
                                  widget.grid.colours[i + 3] == "none") {
                                if (i + 4 < 7 &&
                                    widget.grid.colours[i + 4] == "none") {
                                  if (i + 5 < 7 &&
                                      widget.grid.colours[i + 5] == "none") {
                                    if (i + 6 < 7 &&
                                        widget.grid.colours[i + 6] == "none") {
                                      dot = widget.grid.colours[0];
                                    } else {
                                      i + 6 < 7
                                          ? dot = widget.grid.colours[i + 6]
                                          : dot = widget.grid.colours[0];
                                    }
                                  } else {
                                    i + 5 < 7
                                        ? dot = widget.grid.colours[i + 5]
                                        : dot = widget.grid.colours[0];
                                  }
                                } else {
                                  i + 4 < 7
                                      ? dot = widget.grid.colours[i + 4]
                                      : dot = widget.grid.colours[0];
                                }
                              } else {
                                i + 3 < 7
                                    ? dot = widget.grid.colours[i + 3]
                                    : dot = widget.grid.colours[0];
                              }
                            } else {
                              i + 2 < 7
                                  ? dot = widget.grid.colours[i + 2]
                                  : dot = widget.grid.colours[0];
                            }
                          } else {
                            i + 1 < 7
                                ? dot = widget.grid.colours[i + 1]
                                : dot = widget.grid.colours[0];
                          }
                          break;
                        }
                      }
                    }
                    setState(() {
                      widget.grid.gridValues[index] = dot;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: dot == "black"
                            ? isDarkMode
                                ? white
                                : black
                            : Colors.transparent,
                        width: 1,
                      ),
                      color: dot == "black"
                          ? Colors.transparent
                          : colourConverter.getColourFromString(dot),
                      borderRadius: widget.grid.shape == 'circle'
                          ? BorderRadius.circular(64)
                          : BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Align(
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
                        BottomNavBarMenuWidget(
                          icon: Icons.palette,
                          onTap: () async {
                            await clicker.setAsset('assets/click.mov');
                            clicker.play();
                            showDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              builder: (context) => StatefulBuilder(
                                builder: (context, setState) {
                                  greenIsChecked =
                                      widget.grid.colours[1] == "green";
                                  redIsChecked =
                                      widget.grid.colours[2] == "red";
                                  blueIsChecked =
                                      widget.grid.colours[3] == "blue";
                                  yellowIsChecked =
                                      widget.grid.colours[4] == "yellow";
                                  pinkIsChecked =
                                      widget.grid.colours[5] == "pink";
                                  orangeIsChecked =
                                      widget.grid.colours[6] == "orange";
                                  return CustomDialogWidget(
                                    dialogHeading: "Select Colours",
                                    dialogContent: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                                checkColor: Colors.white,
                                                fillColor:
                                                    WidgetStateProperty.all(
                                                        green),
                                                value: greenIsChecked,
                                                onChanged: (value) async {
                                                  await clicker.setAsset(
                                                      'assets/click.mov');
                                                  clicker.play();
                                                  int index = 1;
                                                  if (greenIsChecked == true) {
                                                    for (int i = 0;
                                                        i <
                                                            widget
                                                                .grid
                                                                .gridValues
                                                                .length;
                                                        i++) {
                                                      if (widget.grid
                                                              .gridValues[i] ==
                                                          "green") {
                                                        setState(() {
                                                          widget.grid
                                                                  .gridValues[
                                                              i] = "black";
                                                        });
                                                      }
                                                    }
                                                    widget.grid.colours[index] =
                                                        "none";
                                                  } else {
                                                    widget.grid.colours[index] =
                                                        "green";
                                                  }

                                                  setState(() {
                                                    greenIsChecked = value!;
                                                  });
                                                  await db.updateGrid(
                                                      grid: widget.grid);
                                                }),
                                            Text(
                                              "Green",
                                              style: isDarkMode
                                                  ? darkFont
                                                  : lightFont,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              fillColor:
                                                  WidgetStateProperty.all(red),
                                              value: redIsChecked,
                                              onChanged: (value) async {
                                                await clicker.setAsset(
                                                    'assets/click.mov');
                                                clicker.play();
                                                int index = 2;
                                                if (redIsChecked == true) {
                                                  for (int i = 0;
                                                      i <
                                                          widget.grid.gridValues
                                                              .length;
                                                      i++) {
                                                    if (widget.grid
                                                            .gridValues[i] ==
                                                        "red") {
                                                      setState(() {
                                                        widget.grid
                                                                .gridValues[i] =
                                                            "black";
                                                      });
                                                    }
                                                  }
                                                  widget.grid.colours[index] =
                                                      "none";
                                                } else {
                                                  widget.grid.colours[index] =
                                                      "red";
                                                }
                                                setState(() {
                                                  redIsChecked = value!;
                                                });
                                                await db.updateGrid(
                                                    grid: widget.grid);
                                              },
                                            ),
                                            Text(
                                              "Red",
                                              style: isDarkMode
                                                  ? darkFont
                                                  : lightFont,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              fillColor:
                                                  WidgetStateProperty.all(blue),
                                              value: blueIsChecked,
                                              onChanged: (value) async {
                                                await clicker.setAsset(
                                                    'assets/click.mov');
                                                clicker.play();
                                                int index = 3;
                                                if (blueIsChecked == true) {
                                                  for (int i = 0;
                                                      i <
                                                          widget.grid.gridValues
                                                              .length;
                                                      i++) {
                                                    if (widget.grid
                                                            .gridValues[i] ==
                                                        "blue") {
                                                      setState(() {
                                                        widget.grid
                                                                .gridValues[i] =
                                                            "black";
                                                      });
                                                    }
                                                  }
                                                  widget.grid.colours[index] =
                                                      "none";
                                                } else {
                                                  widget.grid.colours[index] =
                                                      "blue";
                                                }
                                                setState(() {
                                                  blueIsChecked = value!;
                                                });
                                                await db.updateGrid(
                                                    grid: widget.grid);
                                              },
                                            ),
                                            Text(
                                              "Blue",
                                              style: isDarkMode
                                                  ? darkFont
                                                  : lightFont,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              fillColor:
                                                  WidgetStateProperty.all(
                                                      yellow),
                                              value: yellowIsChecked,
                                              onChanged: (value) async {
                                                await clicker.setAsset(
                                                    'assets/click.mov');
                                                clicker.play();
                                                int index = 4;
                                                if (yellowIsChecked == true) {
                                                  for (int i = 0;
                                                      i <
                                                          widget.grid.gridValues
                                                              .length;
                                                      i++) {
                                                    if (widget.grid
                                                            .gridValues[i] ==
                                                        "yellow") {
                                                      setState(() {
                                                        widget.grid
                                                                .gridValues[i] =
                                                            "black";
                                                      });
                                                    }
                                                  }
                                                  widget.grid.colours[index] =
                                                      "none";
                                                } else {
                                                  widget.grid.colours[index] =
                                                      "yellow";
                                                }
                                                setState(() {
                                                  yellowIsChecked = value!;
                                                });
                                                await db.updateGrid(
                                                    grid: widget.grid);
                                              },
                                            ),
                                            Text(
                                              "Yellow",
                                              style: isDarkMode
                                                  ? darkFont
                                                  : lightFont,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              fillColor:
                                                  WidgetStateProperty.all(pink),
                                              value: pinkIsChecked,
                                              onChanged: (value) async {
                                                await clicker.setAsset(
                                                    'assets/click.mov');
                                                clicker.play();
                                                int index = 5;
                                                if (pinkIsChecked == true) {
                                                  for (int i = 0;
                                                      i <
                                                          widget.grid.gridValues
                                                              .length;
                                                      i++) {
                                                    if (widget.grid
                                                            .gridValues[i] ==
                                                        "pink") {
                                                      setState(() {
                                                        widget.grid
                                                                .gridValues[i] =
                                                            "black";
                                                      });
                                                    }
                                                  }
                                                  widget.grid.colours[index] =
                                                      "none";
                                                } else {
                                                  widget.grid.colours[index] =
                                                      "pink";
                                                }
                                                setState(() {
                                                  pinkIsChecked = value!;
                                                });
                                                await db.updateGrid(
                                                    grid: widget.grid);
                                              },
                                            ),
                                            Text(
                                              "Pink",
                                              style: isDarkMode
                                                  ? darkFont
                                                  : lightFont,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              fillColor:
                                                  WidgetStateProperty.all(
                                                      orange),
                                              value: orangeIsChecked,
                                              onChanged: (value) async {
                                                await clicker.setAsset(
                                                    'assets/click.mov');
                                                clicker.play();
                                                int index = 6;
                                                if (orangeIsChecked == true) {
                                                  for (int i = 0;
                                                      i <
                                                          widget.grid.gridValues
                                                              .length;
                                                      i++) {
                                                    if (widget.grid
                                                            .gridValues[i] ==
                                                        "orange") {
                                                      setState(() {
                                                        widget.grid
                                                                .gridValues[i] =
                                                            "black";
                                                      });
                                                    }
                                                  }
                                                  widget.grid.colours[index] =
                                                      "none";
                                                } else {
                                                  widget.grid.colours[index] =
                                                      "orange";
                                                }
                                                setState(() {
                                                  orangeIsChecked = value!;
                                                });
                                                await db.updateGrid(
                                                    grid: widget.grid);
                                              },
                                            ),
                                            Text(
                                              "Orange",
                                              style: isDarkMode
                                                  ? darkFont
                                                  : lightFont,
                                            ),
                                          ],
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
                                          style:
                                              isDarkMode ? darkFont : lightFont,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        BottomNavBarMenuWidget(
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
                                            Text(
                                              'x: ${widget.grid.x.toString()}',
                                              style: isDarkMode
                                                  ? darkFont
                                                  : lightFont,
                                            ),
                                            Slider(
                                              label: widget.grid.x.toString(),
                                              min: 3,
                                              max: 14,
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
                                            Text(
                                              'y: ${widget.grid.y.toString()}',
                                              style: isDarkMode
                                                  ? darkFont
                                                  : lightFont,
                                            ),
                                            Slider(
                                              label: widget.grid.y.toString(),
                                              min: 1,
                                              max:
                                                  260, // 10 years with 14 across
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
                                                  ? darkFont
                                                  : lightFont,
                                            ),
                                          )
                                        ],
                                      );
                                    }));
                          },
                        ),
                        BottomNavBarMenuWidget(
                          icon: Icons.save,
                          onTap: () async {
                            await clicker.setAsset('assets/click.mov');
                            clicker.play();
                            final updatedGrid = GridModel(
                              gridID: widget.gridID,
                              title: titleController.text,
                              dateModified: DateTime.now().toString(),
                              x: widget.grid.x,
                              y: widget.grid.y,
                              colours: widget.grid.colours,
                              shape: widget.grid.shape,
                              gridValues: widget.grid.gridValues,
                            );
                            await db.updateGrid(grid: updatedGrid);
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
                                                  ? darkFont
                                                  : lightFont,
                                            ),
                                            onPressed: () async {
                                              await clicker
                                                  .setAsset('assets/click.mov');
                                              clicker.play();
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            })
                                      ]);
                                });
                          },
                        ),
                        BottomNavBarMenuWidget(
                          icon: widget.grid.shape == 'circle'
                              ? Icons.square_outlined
                              : Icons.circle_outlined,
                          onTap: () async {
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
                        BottomNavBarMenuWidget(
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
