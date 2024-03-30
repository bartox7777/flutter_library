import 'dart:convert';

import 'package:flutter/material.dart';

import '../common/book.dart';
import '../main/book_list_view.dart';

void Function() processForm(
  BuildContext context,
  GlobalKey<FormState> _formKey,
  Map<String, TextEditingController> _textEditingController,
  int book_id,
  Function(Book) process_form,
) {
  return () {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        bookId: book_id.toString(),
        addDate: DateTime.now().toString(),
        isbn: _textEditingController['isbn']!.text,
        title: _textEditingController['title']!.text,
        author: {
          'author_id': _textEditingController['author']!.text,
          'full_name': _textEditingController['author_name']!.text,
        },
        category: _textEditingController['category']!.text,
        year: _textEditingController['year']!.text,
        pages: _textEditingController['pages']!.text,
        publisher: _textEditingController['publisher']!.text,
        numberOfCopies: _textEditingController['number_of_copies']!.text,
        cover: _textEditingController['cover']!.text,
        description: _textEditingController['description']!.text,
      );

      var resp = process_form(book);
      resp.then((value) {
        for (var i in jsonDecode(value.body)['flashes']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(i[1]),
            ),
          );
        }
        Navigator.popUntil(context, (route) => false);
        Navigator.pushNamed(
          context,
          BooksListView.routeName,
        );
      }).catchError((error, e) {
        print(error);
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd podczas przetwarzania danych'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Popraw błędy w formularzu'),
        ),
      );
    }
  };
}
