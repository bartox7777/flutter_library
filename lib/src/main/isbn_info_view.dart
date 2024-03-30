import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:libsys/src/main/book_details_view.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../handle_api/library_api.dart';

class IsbnInfoView extends StatefulWidget {
  const IsbnInfoView({Key? key}) : super(key: key);

  static const routeName = '/isbn_info';

  @override
  State<IsbnInfoView> createState() => _IsbnInfoState();
}

class _IsbnInfoState extends State<IsbnInfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                var isbn = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                var resp = await LibraryApi().getBookByIsbn(isbn);
                var respJson = jsonDecode(resp.body);
                Navigator.of(context).popUntil((route) => false);
                Navigator.of(context).pushNamed(
                  BookDetailsView.routeName,
                  arguments: {
                    'book_map': {
                      'isbn': isbn,
                      'title': respJson['title'] ?? '',
                      'author': {
                        'author_id': '-1',
                        'full_name': respJson['author'] ?? ''
                      },
                      'category': '',
                      'year': respJson['year'] ?? '',
                      'pages': '',
                      'publisher': respJson['publisher'] ?? '',
                      'number_of_copies': '',
                      'cover': '',
                      'description': respJson['description'] ?? '',
                      'add_date': '',
                      'book_id': '-1'
                    },
                    'on_submit_action': 'addBook',
                  },
                );
              },
              child: const Text('Otwórz skaner kodów kreskowych ISBN'),
            ),
          ],
        ),
      ),
    );
  }
}
