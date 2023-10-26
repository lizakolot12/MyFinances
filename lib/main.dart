import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:my_study/data/data.dart';
import 'package:my_study/items.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_study/state_managment.dart';
import 'package:provider/provider.dart';
import 'theme_extensions.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Settings(const Locale('en'), true),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ColorScheme getLightColors() {
    return ColorScheme.fromSeed(
      seedColor: Colors.green,
      brightness: Brightness.light,
    );
  }

  ColorScheme getDarkColors() {
    return ColorScheme.fromSeed(
      seedColor: Colors.cyanAccent,
      brightness: Brightness.dark,
    );
  }

  TextTheme getTextTheme() {
    return TextTheme(
      titleLarge: GoogleFonts.pacifico(
        fontSize: 24,
        fontStyle: FontStyle.italic,
      ),
      displaySmall: GoogleFonts.pacifico(
        fontSize: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('uk'),
        ],
        themeMode: settings.isLight ? ThemeMode.light : ThemeMode.dark,
        theme: ThemeData(
          colorScheme: getLightColors(),
          textTheme: getTextTheme(),
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          textTheme: getTextTheme(),
          colorScheme: getDarkColors(),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: MainPage(),
      );
    });
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Transaction> list = TransactionRepository().getAll();
  int selectedIndex = 0;
  bool stretch = true;

  void addNew() {
    //for future screen
    setState(() {});
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void remove(int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      return Localizations.override(
        context: context,
        locale: settings.locale,
        child: Builder(
          builder: (context) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.title),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.ac_unit),
                      tooltip: 'Toggle theme',
                      onPressed: () => settings.toggleLightness(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.language),
                      tooltip: 'Toggle language',
                      onPressed: () => {
                        setState(
                          () {
                            settings.toggleLanguage();
                          },
                        )
                      },
                    )
                  ],
                ),
                body: selectedIndex == 0 ? buildBody() : buildStack(),
                floatingActionButton: FloatingActionButton(
                  tooltip: 'Add new',
                  onPressed: addNew,
                  child: const Icon(
                    Icons.add,
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(
                        Icons.home,
                      ),
                      label: AppLocalizations.of(context)!.currents,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(
                        Icons.business,
                      ),
                      label: AppLocalizations.of(context)!.reports,
                    ),
                  ],
                  currentIndex: selectedIndex,
                  onTap: onItemTapped,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          return gridSliver(context);
        } else {
          return listSliver(context);
        }
      },
    );
  }

  Widget listSliver(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          stretch: stretch,
          stretchTriggerOffset: 100.0,
          expandedHeight: 100.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              AppLocalizations.of(context)!.mainDesription,
              style: Theme.of(context).mySpecialTextStyle,
            ),
            background: Image.asset(
              "assets/images/cake.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        buildSliverList(),
      ],
    );
  }

  Widget buildSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Dismissible(
            key: Key(list[index].name),
            onDismissed: (direction) {
              remove(index);
            },
            child: TransactionItem(
              transaction: list[index],
              key: UniqueKey(),
            ),
          );
        },
        childCount: list.length,
      ),
    );
  }

  Widget gridSliver(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        buildSliverGrid(),
      ],
    );
  }

  Widget buildSliverGrid() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            child: TransactionGridItem(
              transaction: list[index],
              key: UniqueKey(),
            ),
          );
        },
        childCount: list.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: (1 / .4),
      ),
    );
  }

  Widget buildStack() {
    return Stack(
      children: <Widget>[
        Center(
          child: Image.asset(
            "assets/images/cake.png",
            fit: BoxFit.fitHeight,
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            transform: Matrix4.rotationZ(0.1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "Приклад використання Stack",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
