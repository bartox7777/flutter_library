import 'dart:convert';

import 'package:flutter/material.dart';

import '../common/book.dart';
import '../common/book_card.dart';
import '../handle_api/library_api.dart';

class AllBookBorrowsView extends StatelessWidget {
  AllBookBorrowsView({Key? key}) : super(key: key);
  static const routeName = '/borrowed_books';

  FutureBuilder<List<dynamic>> bookBorrowsBuilder(Book book) =>
      FutureBuilder<List<dynamic>>(
        future: LibraryApi().getBookBorrows(int.parse(book.bookId)),
        builder: (context, snapshot) {
          List<Widget> items = [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Pobieranie danych...");
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            print(snapshot.stackTrace);
            print(snapshot.data);
            return const Text("Błąd podczas pobierania danych");
          }
          if (snapshot.hasData) {
            items.clear();
            for (var borrow in snapshot.data!) {
              items.add(
                Card(
                  child: ListTile(
                    title: Text(
                      "${borrow['user']['name']} ${borrow['user']['surname']}",
                    ),
                    subtitle: Text(
                      "Wypożyczono: ${borrow['predicted_return_date'].split(' ')[1]} ${borrow['predicted_return_date'].split(' ')[2]} ${borrow['predicted_return_date'].split(' ')[3]}",
                    ),
                    trailing: Text(
                      "Zwrócono: ${borrow['return_date'] == null ? 'Nie' : 'Tak'}",
                    ),
                    onTap: () {
                      // alert dialog to confirm return
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Potwierdź zwrot"),
                            content: Text(
                              "Czy na pewno chcesz zwrócić tę książkę?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Anuluj"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  var response = await LibraryApi()
                                      .returnBook(borrow['id']);
                                  if (response.statusCode == 200) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushNamed(
                                      AllBookBorrowsView.routeName,
                                      arguments: book.to_map(),
                                    );
                                  } else {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Błąd podczas zwracania książki",
                                        ),
                                      ),
                                    );
                                  }
                                  // show flashes
                                  for (var flash
                                      in jsonDecode(response.body)['flashes']) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(flash[1]),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Zwróć"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            }
          }
          if (items.isEmpty) {
            return const Text("Ta książka nie została jeszcze wypożyczona.");
          }
          return ListView(
            children: items,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      try {
        print(ModalRoute.of(context)!.settings.arguments);
        var book_map =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return Center(
          child: Column(
            children: [
              getBookCard(context, Book.from_map(book_map), null),
              // horizontal line
              Divider(
                color: Theme.of(context).dividerColor,
                height: 20,
                thickness: 3,
                indent: 20,
                endIndent: 20,
              ),
              // scrollable list of borrows
              Expanded(child: bookBorrowsBuilder(Book.from_map(book_map))),
            ],
          ),
        );
      } catch (e) {
        print(
          "Map<String, dynamic> book_map not properly passed.",
        );
        throw e;
      }
    }
    return Text('No book details passed');
  }
}
