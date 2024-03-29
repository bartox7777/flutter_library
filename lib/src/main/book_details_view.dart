import 'package:flutter/material.dart';
import 'package:libsys/src/forms/book_details_form.dart';

/// Displays detailed information about a Book
class BookDetailsView extends StatelessWidget {
  const BookDetailsView({super.key});

  static const routeName = '/book_details';

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      try {
        var arg =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        var book_map = arg["book_map"] as Map<String, dynamic>;
        var on_submit_action = arg["on_submit_action"] as String;
        return BookDetailsForm(book_map, on_submit_action);
      } catch (e) {
        print(
          "Map<String, dynamic> book_map or Function(BuildContext, GlobalKey<FormState>, Map<String, TextEditingController>, Map<String, dynamic>?) on_submit was not passed.",
        );
        print(e);
      }
    }
    return BookDetailsForm(null, null);
  }
}
