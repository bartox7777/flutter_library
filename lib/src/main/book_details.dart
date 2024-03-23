import 'package:flutter/material.dart';
import 'package:libsys/src/forms/book_details_form.dart';

/// Displays detailed information about a Book
class BookDetailsView extends StatelessWidget {
  const BookDetailsView({super.key});

  static const routeName = '/book_details';

  @override
  Widget build(BuildContext context) {
    // short if
    Map<String, dynamic>? book =
        ModalRoute.of(context)!.settings.arguments != null
            ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
            : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formularz książki'),
      ),
      body: BookDetailsForm(book),
    );
  }
}
