import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_field/image_field.dart';
import 'package:isbn/isbn.dart';
import 'package:libsys/src/handle_api/library_api.dart';

import '../common/book.dart';

class BookDetailsForm extends StatefulWidget {
  // const BookDetailsForm(Set<Map<String, dynamic>> set, {super.key, this.book});

  final Map<String, dynamic>? book;

  // constructor
  BookDetailsForm(this.book);

  @override
  _BookDetailsFormState createState() {
    return _BookDetailsFormState(this.book);
  }
}

class _BookDetailsFormState extends State<BookDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, dynamic>? book;
  late Map<String, TextEditingController> _textEditingController;

  _BookDetailsFormState(this.book) {
    if (book == null) {
      book = {
        'book_id': '',
        'isbn': '',
        'title': '',
        'author': {'author_id': '', 'full_name': ''},
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
      'isbn': TextEditingController(text: book!['isbn']),
      'title': TextEditingController(text: book!['title']),
      'author': TextEditingController(
          text:
              '${book!['author']['author_id']} ${book!['author']['full_name']}'),
      'category': TextEditingController(text: book!['category']),
      'year': TextEditingController(text: book!['year']),
      'pages': TextEditingController(text: book!['pages']),
      'publisher': TextEditingController(text: book!['publisher']),
      'number_of_copies':
          TextEditingController(text: book!['number_of_copies']),
      'cover': TextEditingController(text: book!['cover']),
      'description': TextEditingController(text: book!['description']),
    };
  }

  @override
  Widget build(BuildContext context) {
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
          TextFormField(
            controller: _textEditingController['author'],
            decoration: const InputDecoration(
              labelText: 'ID autora',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Autor jest wymagany';
              }
              return null;
            },
          ),
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
                  files: [
                    ImageAndCaptionModel(
                        file: base64.decode(book!['cover']), caption: "")
                  ],
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
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Przetwarzanie danych')),
                );

                final book = Book(
                  bookId: this.book!['book_id'],
                  addDate: DateTime.now().toString(),
                  isbn: _textEditingController['isbn']!.text,
                  title: _textEditingController['title']!.text,
                  author: {
                    'author_id':
                        _textEditingController['author']!.text.split(' ')[0],
                    'full_name': _textEditingController['author']!
                        .text
                        .split(' ')
                        .sublist(1)
                        .join(' '),
                  },
                  category: _textEditingController['category']!.text,
                  year: _textEditingController['year']!.text,
                  pages: _textEditingController['pages']!.text,
                  publisher: _textEditingController['publisher']!.text,
                  numberOfCopies:
                      _textEditingController['number_of_copies']!.text,
                  cover: _textEditingController['cover']!.text,
                  description: _textEditingController['description']!.text,
                );

                await LibraryApi()
                    .updateBook(book)
                    .then((value) => {
                          if (value.statusCode == 200)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Zaktualizowano książkę')),
                              ),
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Nie udało się zaktualizować książki')),
                              ),
                            }
                        })
                    .catchError((error, e) {
                  print(error);
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Nie udało się zaktualizować książki')),
                  );
                });
                Navigator.popUntil(context, (route) => false);
                Navigator.pushNamed(context, Navigator.defaultRouteName);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
