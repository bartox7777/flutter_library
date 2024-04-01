import 'package:flutter/material.dart';
import 'package:libsys/src/main/book_details_view.dart';
import 'package:libsys/src/main/isbn_info_view.dart';

import 'handle_api/library_api.dart';
import 'main/book_list_view.dart';
import 'main/light_sensor_view.dart';
import 'main/nfc_read.dart';
import 'moderate/all_book_borrows_view.dart';
import 'moderate/borrow_book_view.dart';
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
                  case LightSensorView.routeName:
                    view = const LightSensorView();
                    title = 'Jasność otoczenia';
                  case IsbnInfoView.routeName:
                    view = const IsbnInfoView();
                    title = 'Skanowanie ISBN';
                  case NfcReadView.routeName:
                    view = NfcReadView();
                    title = 'Odczytaj przez NFC';
                  case BorrowBookView.routeName:
                    view = BorrowBookView();
                    title = 'Wypożycz książkę';
                  case AllBookBorrowsView.routeName:
                    view = AllBookBorrowsView();
                    title = 'Wypożyczenia';
                  case BooksListView.routeName:
                    view = BooksListView(
                      books: LibraryApi().getBooks,
                      title: 'Lista książek',
                      restorationId: 'NewestBooksList',
                      onTapRouteName: BookDetailsView.routeName,
                    );
                    title = 'Lista książek';
                  default:
                    // view = LoginView();
                    // title = "Logowanie";
                    // return Scaffold(
                    //   appBar: AppBar(
                    //     title: Text(title),
                    //   ),
                    //   body: Padding(
                    //     padding: const EdgeInsetsDirectional.only(
                    //         start: 20, end: 20),
                    //     child: Container(
                    //       child: view,
                    //     ),
                    //   ),
                    // );
                    view = BooksListView(
                      books: LibraryApi().getBooks,
                      title: 'Lista książek',
                      restorationId: 'NewestBooksList',
                      onTapRouteName: BookDetailsView.routeName,
                    );
                    title = 'Lista książek';
                }

                return Scaffold(
                  appBar: AppBar(
                    title: Text(title),
                    actions: [
                      PopupMenuButton(
                        itemBuilder: (BuildContext context) {
                          return [
                            // if view is instnace of loginview
                            PopupMenuItem(
                              child: ListTile(
                                title: Text('Wszystkie książki'),
                                onTap: () {
                                  Navigator.of(context)
                                      .popUntil((route) => false);
                                  Navigator.of(context)
                                      .pushNamed(BooksListView.routeName);
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                title: Text('Dodaj książkę'),
                                onTap: () {
                                  Navigator.of(context)
                                      .popUntil((route) => false);
                                  Navigator.of(context).pushNamed(
                                    BookDetailsView.routeName,
                                    arguments: {
                                      'book_map': {
                                        'isbn': '',
                                        'title': '',
                                        'author': {
                                          'author_id': '-1',
                                          'full_name': ''
                                        },
                                        'category': '',
                                        'year': '',
                                        'pages': '',
                                        'publisher': '',
                                        'number_of_copies': '',
                                        'cover': '',
                                        'description': '',
                                        'add_date': '',
                                        'book_id': '-1'
                                      },
                                      'on_submit_action': 'addBook',
                                    },
                                  );
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                title: Text('Sprawdź jasność'),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(LightSensorView.routeName);
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                title: Text('Skanowanie ISBN'),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(IsbnInfoView.routeName);
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                title: Text('Wyszukaj przez NFC'),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(NfcReadView.routeName);
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                title: Text('Ustawienia'),
                                onTap: () {
                                  if (ModalRoute.of(context)!.settings.name !=
                                      SettingsView.routeName) {
                                    Navigator.of(context).popAndPushNamed(
                                        SettingsView.routeName);
                                  } else {
                                    return;
                                  }
                                },
                              ),
                            ),
                          ];
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
