import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_study/bloc/chart/chart_bloc.dart';
import 'package:my_study/bloc/list/transaction_bloc.dart';
import 'package:my_study/data/data.dart';
import 'package:my_study/ui/chart/chart_screen.dart';
import 'package:my_study/ui/item/item_screen.dart';
import 'package:my_study/ui/list/list_screen.dart';
import 'package:my_study/ui/settings/settings_screen.dart';
import 'package:my_study/ui/util/error_screen.dart';
import 'package:my_study/ui/util/provider_state_management.dart';
import 'package:provider/provider.dart' as provider;

void main() {
  runApp(
    provider.ChangeNotifierProvider(
      create: (context) => Settings(const Locale('en'), true),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ColorScheme getLightColors() {
    return ColorScheme.fromSeed(
      seedColor: Colors.green,
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

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const MainPage(),
        routes: [
          GoRoute(
            path: "edit/:id",
            builder: (context, state) => ItemScreen(
              transactionId: int.parse(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: "new",
            builder: (context, state) => const ItemScreen(transactionId: null),
          ),
          GoRoute(
            path: "settings",
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );

  @override
  Widget build(BuildContext context) {
    return provider.Selector<Settings, bool>(
      selector: (_, provider) => provider.isLight,
      builder: (context, isLight, child) {
        return RepositoryProvider(
          create: (context) => TransactionRepository(),
          child: MaterialApp.router(
            routerConfig: _router,
            title: "Go router",
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
          ),
        );
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<Settings>(
      builder: (context, settings, child) {
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
                      /*       IconButton(
                      icon: const Icon(Icons.ac_unit),
                      tooltip: 'Toggle theme',
                      onPressed: () => settings.toggleLightness(),
                    ),*/
                      IconButton(
                        icon: const Icon(Icons.settings),
                        tooltip: 'Toggle language',
                        onPressed: () => GoRouter.of(context).go("/settings"),
                      ),
                    ],
                  ),
                  body: TabBarView(
                    children: [
                      BlocProvider(
                        create: (context) => TransactionListBloc(
                          repository:
                              RepositoryProvider.of<TransactionRepository>(
                            context,
                          ),
                        ),
                        child: const ListScreen(),
                      ),
                      BlocProvider(
                        create: (context) => ChartBloc(
                          repository:
                              RepositoryProvider.of<TransactionRepository>(
                            context,
                          ),
                        ),
                        child: const ChartScreen(),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    tooltip: 'Add new',
                    onPressed: () => {
                      context.go("/new"),
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
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
