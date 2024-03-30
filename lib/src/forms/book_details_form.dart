import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_field/image_field.dart';
import 'package:isbn/isbn.dart';
import 'package:libsys/src/handle_api/library_api.dart';
import 'package:libsys/src/moderate/process_book_details_form.dart';

import '../moderate/borrow_book_view.dart';

var json;

class BookDetailsForm extends StatefulWidget {
  final Map<String, dynamic>? book;
  final String? on_submit_action;

  // constructor
  BookDetailsForm(this.book, this.on_submit_action);

  @override
  _BookDetailsFormState createState() {
    return _BookDetailsFormState(this.book, this.on_submit_action);
  }
}

class _BookDetailsFormState extends State<BookDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic>? book;
  late Map<String, TextEditingController> _textEditingController;
  late FutureBuilder selectAuthorBuilder;
  late String? on_submit_action;

  _BookDetailsFormState(this.book, this.on_submit_action) {
    if (this.book == null) {
      this.book = {
        'book_id': '',
        'isbn': '',
        'title': '',
        'author': {'author_id': '-1', 'full_name': ''},
        'category': '',
        'year': '',
        'pages': '',
        'publisher': '',
        'number_of_copies': '',
        'cover': '',
        'description': '',
      };
    }

    _textEditingController = {
      'isbn': TextEditingController(text: this.book!['isbn']),
      'title': TextEditingController(text: this.book!['title']),
      'author': TextEditingController(text: this.book!['author']['author_id']),
      'author_name':
          TextEditingController(text: this.book!['author']['full_name']),
      'category': TextEditingController(text: this.book!['category']),
      'year': TextEditingController(text: this.book!['year']),
      'pages': TextEditingController(text: this.book!['pages']),
      'publisher': TextEditingController(text: this.book!['publisher']),
      'number_of_copies':
          TextEditingController(text: this.book!['number_of_copies']),
      'cover': TextEditingController(text: this.book!['cover']),
      'description': TextEditingController(text: this.book!['description']),
    };

    selectAuthorBuilder = FutureBuilder<List<dynamic>>(
      future: LibraryApi().getAuthors(),
      builder: (context, snapshot) {
        List<DropdownMenuItem> items = [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Pobieranie danych...");
        }
        if (snapshot.hasError) {
          return const Text("Błąd podczas pobierania danych");
        }
        if (snapshot.hasData) {
          items.clear();
          items.add(
            DropdownMenuItem(
              value: book!['author']['author_id'],
              child: Text(book!['author']['full_name']),
            ),
          );
          for (var author in snapshot.data!) {
            if (author[0] == int.parse(book!['author']['author_id'])) {
              continue;
            }
            items.add(DropdownMenuItem(
              value: author[0],
              child: Text(author[1]),
            ));
          }
        }
        if (items.isEmpty) {
          return const Text("Brak autorów");
        }
        return DropdownButtonFormField(
          value: items[0].value,
          items: items,
          onChanged: (value) {
            _textEditingController['author']!.text = value.toString();
          },
          decoration: const InputDecoration(
            labelText: 'Autor',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // fb.createElement();
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          // isbn
          TextFormField(
            controller: _textEditingController['isbn'],
            decoration: const InputDecoration(
              labelText: 'ISBN',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'ISBN jest wymagany';
              } else if (Isbn().notIsbn(value, strict: true)) {
                return 'ISBN jest nieprawidłowy';
              }
              return null;
            },
          ),
          // title

          TextFormField(
            controller: _textEditingController['title'],
            decoration: InputDecoration(
              labelText: 'Tytuł',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tytuł jest wymagany';
              }
              return null;
            },
          ),
          // author
          on_submit_action == "addBook"
              ? TextFormField(
                  controller: _textEditingController['author_name'],
                  decoration: const InputDecoration(
                    labelText: 'Autor',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Autor jest wymagana';
                    }
                    return null;
                  },
                )
              : selectAuthorBuilder,
          // category
          TextFormField(
            controller: _textEditingController['category'],
            decoration: const InputDecoration(
              labelText: 'Kategoria',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kategoria jest wymagana';
              }
              return null;
            },
          ),
          // year
          TextFormField(
            controller: _textEditingController['year'],
            decoration: const InputDecoration(
              labelText: 'Rok wydania',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Rok wydania jest wymagany';
              } else if (int.tryParse(value) == null ||
                  value.length != 4 ||
                  int.parse(value) < 0) {
                return 'Rok wydania musi być liczbą całkowitą dodatnią o długości 4 znaków';
              }
              return null;
            },
          ),
          // pages
          TextFormField(
            controller: _textEditingController['pages'],
            decoration: const InputDecoration(
              labelText: 'Liczba stron',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Liczba stron jest wymagana';
              }
              if (int.tryParse(value) == null || int.parse(value) < 0) {
                return 'Liczba stron musi być liczbą całkowitą dodatnią';
              }
              return null;
            },
          ),
          // publisher
          TextFormField(
            controller: _textEditingController['publisher'],
            decoration: const InputDecoration(
              labelText: 'Wydawca',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Wydawca jest wymagany';
              }
              return null;
            },
          ),
          // number of copies
          TextFormField(
            controller: _textEditingController['number_of_copies'],
            decoration: const InputDecoration(
              labelText: 'Liczba kopii',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Liczba kopii jest wymagana';
              }
              if (int.tryParse(value) == null || int.parse(value) < 0) {
                return 'Liczba kopii musi być liczbą całkowitą dodatnią';
              }
              return null;
            },
          ),
          // cover - image input
          Padding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // color gray
                Text(
                  'Okładka',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                // space
                const SizedBox(height: 5),
                ImageField(
                  onSave: (file) {
                    _textEditingController['cover']!.text =
                        base64.encode(file![0].file);
                  },
                  files: book!['cover'] != ''
                      ? [
                          ImageAndCaptionModel(
                              file: base64.decode(book!['cover']), caption: "")
                        ]
                      : [],
                  multipleUpload: false,
                  enabledCaption: false,
                  cardinality: 1,
                ),
              ],
            ),
            padding: EdgeInsetsDirectional.only(bottom: 20, top: 20),
          ),
          // description
          TextFormField(
            controller: _textEditingController['description'],
            decoration: const InputDecoration(
              labelText: 'Opis',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Opis jest wymagany';
              }
              return null;
            },
            minLines: 1,
            maxLines: 10,
          ),
          // space
          const SizedBox(height: 20),
          if (on_submit_action == 'updateBook')
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(BorrowBookView.routeName, arguments: book!);
              },
              child: const Text('Wypożycz książkę'),
            ),
          ElevatedButton(
            onPressed: processForm(
              context,
              _formKey,
              _textEditingController,
              int.parse(book!['book_id']),
              LibraryApi().updateBook,
            ),
            child: const Text('Zapisz zmiany'),
          ),
          if (on_submit_action == 'addBook')
            ElevatedButton(
              onPressed: processForm(
                context,
                _formKey,
                _textEditingController,
                -1,
                LibraryApi().addBook,
              ),
              child: const Text('Dodaj książkę'),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
