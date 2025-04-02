import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_modelo_20251/main.dart';
import 'package:routefly/routefly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/util/legacy_to_async_migration_util.dart';
import 'package:signals/signals_flutter.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with SignalsMixin {

  final Signal<int> counter = Signal<int>(0);

  /// Completes when the preferences have been initialized, which happens after
  /// legacy preferences have been migrated.
  final Completer<void> _preferencesReady = Completer<void>();

  final Future<SharedPreferencesWithCache> _prefs =

  SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        // This cache will only accept the key 'counter'.
          allowList: <String>{'counter'}));

  void _incrementCounter() {
    counter.value++;
  }


  Future<void> _migratePreferences() async {
    // #docregion migrate
    const SharedPreferencesOptions sharedPreferencesOptions =
    SharedPreferencesOptions();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await migrateLegacySharedPreferencesToSharedPreferencesAsyncIfNecessary(
      legacySharedPreferencesInstance: prefs,
      sharedPreferencesAsyncOptions: sharedPreferencesOptions,
      migrationCompletedKey: 'migrationCompleted',
    );
    // #enddocregion migrate
  }

  @override
  void initState() {
    super.initState();
    _migratePreferences().then((_) {
       _prefs.then((SharedPreferencesWithCache prefs) {
         print("counter"+prefs.getInt('counter').toString());
         counter.value = prefs.getInt('counter') ?? 0;
         _preferencesReady.complete();
         counter.subscribe((value) async{
           final SharedPreferencesWithCache prefs = await _prefs;
           print(counter.value);
           prefs.setInt('counter', counter.value);
         });
      });
    });

  }

  void _navigateToAboutPage(){
    Routefly.push(routePaths.about);
  }
  _openTypeEditPage() {
    Routefly.push('${routePaths.type.path}/${counter.value}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Counter')),
      body: Center(
    child: _WaitForInitialization(
        initialized: _preferencesReady.future,
        builder: (BuildContext context) => FutureBuilder<int>(
          future: Future.value(counter.value),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    const Text('Valor :'),
                    Text('${counter.watch(context)}', style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium),
                  ],
                  );
                }
            }
          }
        )
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
          destinations: [
            BackButton(
              onPressed: () {
                var value = counter.value;
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('OK clicado : '+value.toString()),
                      action: SnackBarAction(label: "OK", onPressed:() {} ),
                    )
                );
              },
            ),
            TextButton(onPressed: _navigateToAboutPage, child: Text("Sobre")),
            IconButton(onPressed: _openTypeEditPage, icon: const Icon(Icons.edit))
          ]
      ),
    );
  }
}

/// Waits for the [initialized] future to complete before rendering [builder].
class _WaitForInitialization extends StatelessWidget {
  const _WaitForInitialization({
    required this.initialized,
    required this.builder,
  });

  final Future<void> initialized;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initialized,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return const CircularProgressIndicator();
        }
        return builder(context);
      },
    );
  }
}