import 'package:flutter/material.dart';

class ListHolder extends StatefulWidget {
  @override
  _ListHolderState createState() => _ListHolderState();
}

class _ListHolderState extends State<ListHolder>
    with AutomaticKeepAliveClientMixin<ListHolder> {
// this lists here because this Widget avoid reloading
  List<Page> pagesList = [];
  List<Uri> urisList = [];

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  bool get wantKeepAlive {
    return true;
  } // ** and here
}
