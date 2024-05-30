import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:libsys/src/handle_api/library_api.dart';
import 'package:libsys/src/main/book_list_view.dart';

var json;

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, TextEditingController> _textEditingController = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          // isbn
          TextFormField(
            controller: _textEditingController['email'],
            decoration: const InputDecoration(
              labelText: 'E-mail',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'E-mail jest wymagany';
              } // validate email
              else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,10}$')
                  .hasMatch(value)) {
                return 'E-mail jest nieprawidłowy';
              }
              return null;
            },
          ),
          // title
          TextFormField(
            controller: _textEditingController['password'],
            decoration: InputDecoration(
              labelText: 'Hasło',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Hasło jest wymagane';
              }
              return null;
            },
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          // author

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                var loginCredentials = {
                  'email': _textEditingController['email']!.text,
                  'password': _textEditingController['password']!.text,
                };

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logowanie...'),
                    duration: const Duration(milliseconds: 500),
                  ),
                );

                LibraryApi().login(loginCredentials).then((value) {
                  for (var i in jsonDecode(value.body)['flashes']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(i[1]),
                      ),
                    );
                  }
                  if (value.statusCode == 200) {
                    Navigator.popUntil(context, (route) => false);
                    Navigator.pushNamed(
                      context,
                      BooksListView.routeName,
                    );
                  }
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
            },
            child: const Text('Zaloguj się'),
          ),
        ],
      ),
    );
  }
}
