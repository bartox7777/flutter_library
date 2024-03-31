import 'dart:convert';

import 'package:flutter/material.dart';

import '../common/book.dart';
import '../handle_api/library_api.dart';

FutureBuilder<Widget> howManyBorrows(Book book) {
  return FutureBuilder<Widget>(
    future: LibraryApi().getBorrowsCount(book),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return snapshot.data!;
      } else if (snapshot.hasError) {
        return Text('Błąd: ${snapshot.error}');
      }
      return const Text('...');
    },
  );
}

Widget getBookCard(BuildContext context, Book book, String? onTapRouteName) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: RichText(
          text: TextSpan(
            text: book.title,
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: ' (${book.year})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(book.author['full_name']),
        leading: Image(
          image: Image.memory(base64Decode(book.cover)).image,
          width: 100.0,
        ),
        trailing: howManyBorrows(book),
        onTap: () {
          if (onTapRouteName == null) {
            return;
          }
          Navigator.restorablePushNamed(
            context,
            onTapRouteName,
            arguments: {
              'book_map': book.to_map(),
              'on_submit_action': "updateBook",
            },
          );
        },
      ),
    ),
  );
}
