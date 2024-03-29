import 'package:datalocal/datalocal.dart';
import 'package:flutter/material.dart';

class RemindersProvider with ChangeNotifier {
  late DataLocal data;
  bool isLoading = false;

  RemindersProvider() {
    isLoading = true;
    refresh();
    initialize();
  }

  initialize() async {
    data = await DataLocal.create("reminder",
        onRefresh: () => refresh(), debugMode: true);
    data.onRefresh = () {
      refresh();
    };
    data.refresh();
    isLoading = false;
    refresh();
  }

  onSave({
    String? id,
    required String title,
    required DateTime? date,
    required List<Map<String, dynamic>> content,
  }) async {
    if (id != null) {
      if (title.isNotEmpty ||
          content.length >= 2 ||
          content.first['controller'].toString().isNotEmpty) {
        onUpdate(id, title: title, content: content);
      } else {
        onDeleted(id);
      }
    } else {
      if (title.isNotEmpty || content.isNotEmpty) {
        data.insertOne({
          "title": title,
          "content": content,
          "updatedAt": DateTime.now(),
        });
      }
    }
  }

  onUpdate(String id,
      {required String title,
      required List<Map<String, dynamic>> content}) async {
    data.updateOne(id, value: {
      "title": title,
      "content": content,
      "updatedAt": DateTime.now(),
    });
  }

  onDeleted(String id) async {
    data.deleteOne(id);
  }

  void refresh() {
    notifyListeners();
  }
}
