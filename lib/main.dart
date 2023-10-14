import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_study/data/data.dart';
import 'package:my_study/items.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Мої витрати',
        localizationsDelegates: [
          AppLocalizations.delegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
          Locale('uk'),
        ],
        theme: ThemeData(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            // brightness: isLight ? Brightness.light : Brightness.dark,
          ),

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            titleLarge: GoogleFonts.pacifico(
              fontSize: 24,
              fontStyle: FontStyle.italic,
            ),
            displaySmall: GoogleFonts.pacifico(
              fontSize: 14,
            ),
          ),
          useMaterial3: true,
        ),
        home: MainPage());
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
  bool isLight = true;
  bool stretch = true;

  void addNew() {
    //for future screen
    setState(() {});
  }

  void toggleTheme() {
    setState(() {
      isLight = !isLight;
    });
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.ac_unit),
              tooltip: 'Toggle theme',
              onPressed: toggleTheme,
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
  }

  Widget buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          return gridSliver();
        } else {
          return listSliver();
        }
      },
    );
  }

  Widget listSliver() {
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                shadows: <Shadow>[
                  const Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 243, 224, 224),
                  ),
                ],
              ),
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

  Widget gridSliver() {
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
