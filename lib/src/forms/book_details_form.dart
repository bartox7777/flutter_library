import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_field/image_field.dart';

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
  _BookDetailsFormState(this.book);

  final Map<String, dynamic>? book;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          // isbn
          TextFormField(
            initialValue: book != null ? book!['isbn'] : '',
            decoration: const InputDecoration(
              labelText: 'ISBN',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'ISBN jest wymagany';
              }
              return null;
            },
          ),
          // title

          TextFormField(
            initialValue: book != null ? book!['title'] : '',
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
            initialValue: book != null ? book!['author']["author_id"] : '',
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
            initialValue: book != null ? book!['category'] : '',
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
            initialValue: book != null ? book!['year'] : '',
            decoration: const InputDecoration(
              labelText: 'Rok wydania',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Rok wydania jest wymagany';
              }
              return null;
            },
          ),
          // pages
          TextFormField(
            initialValue: book != null ? book!['pages'] : '',
            decoration: const InputDecoration(
              labelText: 'Liczba stron',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Liczba stron jest wymagana';
              }
              return null;
            },
          ),
          // publisher
          TextFormField(
            initialValue: book != null ? book!['publisher'] : '',
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
            initialValue: book != null ? book!['number_of_copies'] : '',
            decoration: const InputDecoration(
              labelText: 'Liczba kopii',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Liczba kopii jest wymagana';
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
                const Text('Okładka', style: TextStyle(color: Colors.black87)),
                // space
                const SizedBox(height: 5),
                ImageField(
                  files: book != null
                      ? [
                          ImageAndCaptionModel(
                              file: base64.decode(book!['cover']), caption: "")
                        ]
                      : null,
                  multipleUpload: false,
                  enabledCaption: false,
                ),
              ],
            ),
            padding: EdgeInsetsDirectional.only(bottom: 20, top: 20),
          ),
          // description
          TextFormField(
            initialValue: book != null ? book!['description'] : '',
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
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Przetwarzanie danych')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
