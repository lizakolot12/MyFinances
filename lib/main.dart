import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_study/data/transaction_bloc.dart';
import 'package:my_study/provider_state_managment.dart';
import 'package:provider/provider.dart' as provider;
import 'data/data.dart';
import 'data/item_bloc.dart';
import 'edit_screen.dart';
import 'item_screen.dart';
import 'list_screen.dart';

void main() {
  runApp(
    provider.ChangeNotifierProvider(
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
    return provider.Selector<Settings, bool>(
        selector: (_, provider) => provider.isLight,
        builder: (context, isLight, child) {
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
            themeMode: isLight ? ThemeMode.light : ThemeMode.dark,
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
            home: const MainPage(),
          );
        });
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<Settings>(builder: (context, settings, child) {
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
                      onPressed: () => settings.toggleLanguage(),
                    )
                  ],
                ),
                body: TabBarView(
                  children: [
                    RepositoryProvider(
                        create: (context) => TransactionRepository(),
                        child: BlocProvider(
                          create: (context) => TransactionListBloc(
                              repository:
                                  RepositoryProvider.of<TransactionRepository>(
                                      context)),
                          child: const ListScreen(),
                        )),
                    buildStack()
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  tooltip: 'Add new',
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RepositoryProvider(
                              create: (context) => TransactionRepository(),
                              child: BlocProvider(
                                create: (context) => TransactionItemBloc(
                                    repository: RepositoryProvider.of<
                                        TransactionRepository>(context)),
                                child: EditScreen(transaction: null),
                                /*transaction:
                                        Transaction(1, "d", 34, List.empty())),*/
                              ))),
                    )
                  },
                  child: const Icon(
                    Icons.add,
                  ),
                ),
                bottomNavigationBar: TabBar(
                  tabs: [
                    Tab(
                      icon: const Icon(
                        Icons.home,
                      ),
                      text: AppLocalizations.of(context)!.currents,
                    ),
                    Tab(
                      icon: const Icon(
                        Icons.business,
                      ),
                      text: AppLocalizations.of(context)!.reports,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
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
