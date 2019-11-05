part of core_resources;

Future<T> showSimpleAlert<T>(
  BuildContext context, {
  Widget title,
  Widget content,
  Function() onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        FlatButton(
          child: Text("Ok"),
          onPressed: () => onConfirm != null ? onConfirm() : Navigator.pop(context),
        ),
      ],
    ),
  );
}
