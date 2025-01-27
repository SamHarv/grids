import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:just_audio/just_audio.dart';

import '../widgets/glass_morphism.dart';
import '../../config/constants.dart';
import '../../logic/providers/providers.dart';
import '../../data/models/grid_model.dart';

class GridsView extends ConsumerStatefulWidget {
  /// UI to display all grids for user

  const GridsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GridsViewState();
}

class _GridsViewState extends ConsumerState<GridsView>
    with TickerProviderStateMixin {
  late SharedPreferences _prefs; // SharedPreferences to manage dark/ light mode
  late AudioPlayer clicker = AudioPlayer();
  late AudioPlayer multiPop = AudioPlayer();

  @override
  void initState() {
    super.initState();
    clicker = AudioPlayer();
    multiPop = AudioPlayer();
    _initSharedPreferences();
  }

  @override
  void dispose() {
    clicker.dispose();
    multiPop.dispose();
    super.dispose();
  }

  // Initialise SharedPreferences
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadDarkMode();
  }

  // Load dark mode from SharedPreferences
  void _loadDarkMode() {
    final isDarkMode = _prefs.getBool('darkMode') ?? true;
    ref.read(darkMode.notifier).state = isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.sizeOf(context).width;
    final db = ref.read(firestore);
    final isDarkMode = ref.watch(darkMode);
    final urlLauncher = ref.read(url);
    final logo = isDarkMode ? 'images/grids.png' : 'images/grids_light.png';

    // Get all grids for user from Firestore
    Future<List<Grid>> getGrids() async {
      final grids = await db.getGrids();
      return grids;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Toggle dark/ light mode
        leading: IconButton(
          iconSize: 24,
          color: isDarkMode ? white : Colors.black,
          icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
          onPressed: () async {
            await multiPop.setAsset(isDarkMode
                ? 'assets/multi_pop_up.mov'
                : 'assets/multi_pop_down.mov');
            await multiPop.play();
            // Save dark mode to SharedPreferences
            _prefs.setBool('darkMode', !isDarkMode);
            // Update dark mode state
            ref.read(darkMode.notifier).state = !isDarkMode;
          },
        ),
        title: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset(
              logo,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          // Navigate to account view
          IconButton(
            iconSize: 24,
            color: isDarkMode ? Colors.white : Colors.black,
            icon: const Icon(Icons.person),
            onPressed: () async {
              await clicker.setAsset('assets/click.mov');
              await clicker.play();
              // ignore: use_build_context_synchronously
              Beamer.of(context).beamToNamed('/account');
            },
          ),
          // O2Tech logo to launch website
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                isDarkMode
                    ? 'images/o2tech_white.png'
                    : 'images/o2tech_black.png',
                fit: BoxFit.contain,
                height: 20,
              ),
              onTap: () async {
                await clicker.setAsset('assets/click.mov');
                await clicker.play();
                urlLauncher.launchO2Tech(); // Launch O2Tech website
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getGrids(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            );
          }
          // Display error if any
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error occurred! ${snapshot.error}',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          }
          final grids = snapshot.data!;
          // Display message if no grids found
          if (grids.isEmpty) {
            return Center(
              child: Stack(
                children: [
                  // Stroked text as border.
                  Text(
                    "No Grids Found!",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Open Sans",
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = Colors.teal[900]!,
                      ),
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    "No Grids Found!",
                    style: isDarkMode ? darkModeLargeFont : lightModeLargeFont,
                  ),
                ],
              ),
            );
          }
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: mediaWidth < 750 ? 2 : 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: grids.length,
                  itemBuilder: (context, index) {
                    final grid = grids[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(32),
                        ),
                        // Navigate to grid page
                        onTap: () async {
                          await clicker.setAsset('assets/click.mov');
                          await clicker.play();
                          // Set x and y state for grid
                          ref.read(xProvider.notifier).state = grid.x;
                          ref.read(yProvider.notifier).state = grid.y;
                          // ignore: use_build_context_synchronously
                          Beamer.of(context).beamToNamed('/grid', data: grid);
                        },
                        child: GlassMorphism(
                          blur: 10,
                          opacity: 0.8,
                          clipRadius: const BorderRadius.all(
                            Radius.circular(32),
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(32),
                          ),
                          color: isDarkMode
                              ? Colors.grey[900]!
                              : Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(32),
                              ),
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.grey[100]!
                                    : Colors.grey[900]!,
                                width: 1.5,
                              ),
                              // color:
                              //     isDarkMode ? Colors.grey[900] : Colors.grey[100],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Stack(
                                  children: [
                                    // Stroked text as border.
                                    Text(
                                      grid.title,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontFamily: "Open Sans",
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 5
                                            ..color = Colors.teal[900]!,
                                        ),
                                      ),
                                    ),
                                    // Solid text as fill.
                                    Text(
                                      grid.title,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontFamily: "Open Sans",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      // Create a new grid
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDarkMode ? Colors.white : Colors.teal[900],
        onPressed: () async {
          await clicker.setAsset('assets/click.mov');
          await clicker.play();
          // Generate a new grid ID
          const uuid = Uuid();
          final gridID = uuid.v4();
          // Create new grid object
          final newGrid = Grid(
            gridID: gridID, // Assign generated grid ID
            title: 'New Grid', // Default title
            dateModified: DateTime.now().toString(),
            x: 7, // Default x value (1 week)
            y: 52, // Default y value (52 weeks)
            colours: [
              "black",
              "green",
              "red",
              "blue",
              "yellow",
              "pink",
              "orange",
            ],
            shape: 'circle',
            gridValues: List.filled(1456, "black"),
          );
          // Set x and y state for new grid
          ref.read(xProvider.notifier).state = newGrid.x;
          ref.read(yProvider.notifier).state = newGrid.y;
          // Add new grid to Firestore
          db.addGrid(grid: newGrid);
          // Navigate to new grid page
          // ignore: use_build_context_synchronously
          Beamer.of(context).beamToNamed('/grid', data: newGrid);
        },
        child: Icon(
          Icons.add,
          color: isDarkMode ? Colors.teal[900] : Colors.white,
        ),
      ),
    );
  }
}
