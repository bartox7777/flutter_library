import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/book.dart';
import '../common/book_card.dart';
import '../handle_api/library_api.dart';

class AllBookBorrowsView extends StatelessWidget {
  AllBookBorrowsView({Key? key}) : super(key: key);
  static const routeName = '/borrowed_books';

  FutureBuilder<List<dynamic>> bookBorrowsBuilder(int book_id) =>
      FutureBuilder<List<dynamic>>(
        future: LibraryApi().getBookBorrows(book_id),
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
                      // convert datetime to date
                      "Wypożyczono: ${borrow['predicted_return_date'].split(' ')[1]} ${borrow['predicted_return_date'].split(' ')[2]} ${borrow['predicted_return_date'].split(' ')[3]}",
                    ),
                    trailing: Text(
                      "Zwrócono: ${borrow['return_date'] == null ? 'Nie' : 'Tak'}",
                    ),
                  ),
                ),
              );
            }
          }
          if (items.isEmpty) {
            return const Text("Żaden egzemplarz nie jest wypożyczony.");
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
              Expanded(
                  child: bookBorrowsBuilder(int.parse(book_map['book_id']))),
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
