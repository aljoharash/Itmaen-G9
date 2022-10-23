import 'package:category_picker/category_picker.dart';
import 'package:category_picker/category_picker_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class history extends StatefulWidget {
  @override
  _History createState() => _History();
}

class _History extends State<history> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CategoryPicker(
          items: [
            CategoryPickerItem(
              value: "Test",
            ),
            CategoryPickerItem(
              value: "Test2",
            ),
            CategoryPickerItem(
              value: "Test3",
            ),
          ],
          onValueChanged: (value) {
            print(value.label);
          },
        ),
      ),
    );
  }
}
