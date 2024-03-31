import 'dart:convert';

import 'package:flutter/material.dart';

import '../common/book.dart';
import '../common/book_card.dart';
import '../handle_api/library_api.dart';

class BorrowBookView extends StatefulWidget {
  BorrowBookView({Key? key}) : super(key: key);

  static const routeName = '/book_borrow';

  int user_id = -1;

  @override
  State<BorrowBookView> createState() => BorrowBookState();
}

class BorrowBookState extends State<BorrowBookView> {
  BorrowBookState() {
    selectUserBuilder = FutureBuilder<List<dynamic>>(
      future: LibraryApi().getUsers(),
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
          for (var user in snapshot.data!) {
            items.add(DropdownMenuItem(
              value: user['id'],
              child: Text("${user['name']} ${user['surname']}"),
            ));
          }
        }
        if (items.isEmpty) {
          return const Text("Brak autorów");
        }
        return DropdownButtonFormField(
          // value: items[0].value,
          items: items,
          onChanged: (value) {
            print(value);
            setState(() {
              widget.user_id = value;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Użytkownik',
          ),
        );
      },
    );
  }

  static const routeName = '/book_borrow';

  late final selectUserBuilder;

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
              getBookCard(
                context,
                Book.from_map(book_map),
                null,
              ),
              selectUserBuilder,
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (widget.user_id == -1) {
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Błąd'),
                          content: const Text('Musisz wybrać użytkownika.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  var borrow_resp = await LibraryApi().borrowBook(
                    book_map['book_id'],
                    widget.user_id,
                  );
                  for (var i in jsonDecode(borrow_resp.body)['flashes']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(i[1]),
                      ),
                    );
                  }
                  if (borrow_resp.statusCode == 200) {
                    // refresh page
                    setState(() {});
                  }
                },
                child: const Text('Wypożycz'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
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
