import 'dart:convert';

import 'package:flutter/material.dart';

import '../handle_api/library_api.dart';

class BorrowBookView extends StatelessWidget {
  BorrowBookView({super.key}) {
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
          value: items[0].value,
          items: items,
          onChanged: (value) {
            print(value);
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    title: RichText(
                      text: TextSpan(
                        text: book_map['title'],
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: ' (${book_map['year']})',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(book_map['author']['full_name']),
                    leading: Image(
                      image:
                          Image.memory(base64Decode(book_map['cover'])).image,
                    ),
                  ),
                ),
              ),
              selectUserBuilder,
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Wypożycz'),
                // full width button
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
