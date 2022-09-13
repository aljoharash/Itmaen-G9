import 'package:flutter/material.dart';

enum DialogsAction { yes, cancel }

class AlertDialogs {
  static Future<DialogsAction> yesCancelDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Directionality(
             textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(DialogsAction.cancel),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                        color: Color.fromARGB(255, 76, 114, 134), fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(DialogsAction.yes),
                  child: Text(
                    'تسجيل خروج',
                    style: TextStyle(
                        color: Color.fromARGB(255, 76, 114, 134), fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          );
        },);
        return (action != null) ? action : DialogsAction.cancel;
  }
}