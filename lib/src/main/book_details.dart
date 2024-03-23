import 'package:flutter/material.dart';

/// Displays detailed information about a Book
class BookDetailsView extends StatelessWidget {
  const BookDetailsView({super.key});

  static const routeName = '/book_details';

  @override
  Widget build(BuildContext context) {
    var bookId = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: Center(
        child: Text('${bookId}'),
      ),
    );
  }
}
