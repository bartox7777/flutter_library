import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libsys/src/main/book_details_view.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../handle_api/library_api.dart';
import 'book_list_view.dart';

class NfcReadView extends StatefulWidget {
  static const routeName = '/nfc_read';

  @override
  State<StatefulWidget> createState() => NfcReadState();
}

class NfcReadState extends State<NfcReadView> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  var showIndicator = false;

  @override
  Widget build(BuildContext context) {
    // redirect on listenable change
    result.addListener(() {
      if (result.value == null || result.value == '') return;
      print('result.value: ${result.value['isodep']['identifier'].toString()}');
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushNamed(
        BooksListView.routeName,
        arguments: result.value['isodep']['identifier'].toString(),
      );
    });

    if (showIndicator) {
      return Center(child: CircularProgressIndicator());
    }
    return FutureBuilder<bool>(
      future: NfcManager.instance.isAvailable(),
      builder: (context, ss) => ss.data != true
          ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
          : Center(
              child: ElevatedButton(
                onPressed: _tagRead,
                child: Text('Odczytaj tag NFC'),
              ),
            ),
    );
  }

  void _tagRead() {
    setState(() {
      showIndicator = true;
    });
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
  }
}
