import 'package:flutter/material.dart';
import 'package:libsys/src/main/book_details_view.dart';

import 'handle_api/library_api.dart';
import 'main/book_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            var view;
            var title;
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    view = SettingsView(controller: settingsController);
                    title = 'Ustawienia';
                  case BookDetailsView.routeName:
                    view = const BookDetailsView();
                    title = 'Formularz książki';
                  case 'NewestBooksList':
                  default:
                    view = BooksListView(
                      books: LibraryApi().getBooks(),
                      title: 'Najnowsze książki',
                      restorationId: 'NewestBooksList',
                      onTapRouteName: BookDetailsView.routeName,
                    );
                    title = 'Najnowsze książki';
                }
                // return Container(
                //   child: Padding(
                //     padding: const EdgeInsets.all(200.0),
                //     child: view,
                //   ),
                //   color: Theme.of(context).scaffoldBackgroundColor,
                // );
                return Scaffold(
                  appBar: AppBar(
                    title: Text(title),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          // Navigate to the settings page. If the user leaves and returns
                          // to the app after it has been killed while running in the
                          // background, the navigation stack is restored.
                          Navigator.restorablePushNamed(
                              context, SettingsView.routeName);
                        },
                      ),
                    ],
                  ),
                  body: Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 20, end: 20),
                    child: Container(
                      child: view,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
