import 'dart:convert';

import 'package:flutter/material.dart';

import '../common/book.dart';

/// Displays a list of SampleItems.
class BooksListView extends StatelessWidget {
  const BooksListView({
    super.key,
    required this.books,
    required this.title,
    required this.restorationId,
    required this.onTapRouteName,
  });

  final String title;
  final String restorationId;
  final String onTapRouteName;
  final Future<List<Book>> books;

  FutureBuilder<List<Book>> get futureBuilder => FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              restorationId: restorationId,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final item = snapshot.data![index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      title: RichText(
                          text: TextSpan(
                              text: item.title,
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                            TextSpan(
                                text: ' (${item.year})',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                          ])),
                      subtitle: Text(item.author['full_name']),
                      leading: Image(
                        image: Image.memory(base64Decode(item.cover)).image,
                      ),
                      onTap: () {
                        // Navigate to the details page. If the user leaves and returns to
                        // the app after it has been killed while running in the
                        // background, the navigation stack is restored.
                        Navigator.restorablePushNamed(
                          context,
                          onTapRouteName,
                          arguments: item.to_map(),
                        );
                        // Navigator.pushNamed(
                        //   context,
                        //   onTapRouteName,
                        //   arguments: item.to_map(),
                        // );
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error} \n ${snapshot.stackTrace}');
          }

          // By default, show a loading spinner.
          return Center(child: const CircularProgressIndicator());
        },
      );

  @override
  Widget build(BuildContext context) {
    return futureBuilder;
  }
}
