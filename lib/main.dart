import 'package:collegeapi/api.dart';
import 'package:provider/provider.dart';
import 'package:routefly/routefly.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';

import 'main.route.dart'; // <- GENERATED

part 'main.g.dart'; // <- GENERATED

class AppApi {
  Signal<String> url = Signal<String>("");
  Signal<String> token = Signal<String>("");
  late ApiClient api;
  AppApi({required urlValue}){
    url.value=urlValue;

    api = _createApiClient(basePath: urlValue);

    url.subscribe((value) {
      print("value:"+value);
      api = _createApiClient(basePath: urlValue);
    });
  }
  _createApiClient({required String basePath}){
    return ApiClient(basePath: basePath);
  }

  dispose() async {
    url.dispose();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  var appApi = AppApi(urlValue:"http://10.200.5.183:8080");

  runApp(
  MultiProvider(
    providers: [
      Provider(create: (_) => appApi,
        dispose: (_, instance) => instance.dispose(),)
    ],
    child: const App(),
  ));
}

@Main()
class App extends StatelessWidget {
  const App({super.key});

  ThemeData createTheme(BuildContext context, Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: brightness,
      ),
      brightness: brightness,
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Counter example',
        debugShowCheckedModeBanner: false,
        theme: createTheme(context, Brightness.light),
        darkTheme: createTheme(context, Brightness.dark),
        themeMode: ThemeMode.system,
        routerConfig: Routefly.routerConfig(
          routes: routes,
          initialPath: routePaths.lib.app,
          notFoundPath: '/notfound',
          /*routeBuilder: (context, settings, child) {
            return MaterialPageRoute(
              settings: settings, // !! IMPORTANT !!
              builder: (context) => child,

            );
          },*/
        ));
  }
}

