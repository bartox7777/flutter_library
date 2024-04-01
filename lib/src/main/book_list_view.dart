
import 'package:flutter/material.dart';
import 'package:libsys/src/common/book_card.dart';

import '../common/book.dart';
import '../handle_api/library_api.dart';

class BooksListView extends StatelessWidget {
  const BooksListView({
    super.key,
    required this.books,
    required this.title,
    required this.restorationId,
    required this.onTapRouteName,
  });

  static const String routeName = '/books-list';

  final String title;
  final String restorationId;
  final String onTapRouteName;
  final Function({String phrase}) books;

  FutureBuilder<Widget> howManyBorrows(Book book) {
    return FutureBuilder<Widget>(
      future: LibraryApi().getBorrowsCount(book),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          return Text('Błąd: ${snapshot.error}');
        }
        return const Text('Pobieranie danych...');
      },
    );
  }

  FutureBuilder<List<Book>> futureBuilder(String phrase) =>
      FutureBuilder<List<Book>>(
        future: books(phrase: phrase),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              restorationId: restorationId,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final item = snapshot.data![index];

                return getBookCard(context, item, onTapRouteName);
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error} \n ${snapshot.stackTrace}');
          }

          return Center(child: const CircularProgressIndicator());
        },
      );

  @override
  Widget build(BuildContext context) {
    final phrase = ModalRoute.of(context)!.settings.arguments is String
        ? ModalRoute.of(context)!.settings.arguments as String
        : "";
    if (phrase == '') {
      print('phrase is empty or not a string');
    }
    return futureBuilder(phrase);
  }
}
