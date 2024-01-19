import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacex_demo/models/api_space_x/payload.dart';

class PayloadListTile extends StatefulWidget {
  const PayloadListTile({super.key, required this.payloadId});

  final String payloadId;

  @override
  State<PayloadListTile> createState() => _PayloadListTileState();
}

class _PayloadListTileState extends State<PayloadListTile> {
  // --- NON-STATE Variables
  bool _didDispose = false;

  // STATE Variables
  bool _isLoading = true;
  Payload? _payload;

  @override
  void initState() {
    super.initState();
    _fetchDataWrapper();
  }

  @override
  void dispose() {
    _didDispose = true;
    super.dispose();
  }

  void _fetchDataWrapper() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Payload payload = await _fetchData();
      if (_didDispose) {
        return; // Good practice to not attempt state changes in async processes if the widget is disposed.
      }
      setState(() {
        _payload = payload;
      });
    } catch (e) {
      //TODO: Show a snackbar or whatever the same error handling strategy as LaunchListScreen will be
    }

    setState(() {
      _isLoading = false;
    });
  }

  // TODO: Build a standardised way of accessing the API, rather than repeatedly building all this overhead boilerplate code in every widget. For example, I have in mind that the URL could be held inside of the Model class, and the retrieval code itself somewhere else which is centralised / standardised. It could be a wrapper widget leaving the calling code to be really nice and clean.
  Future<Payload> _fetchData() async {
    final response = await http.get(Uri.parse(
        'https://api.spacexdata.com/v4/payloads/${widget.payloadId}'));
    if (response.statusCode == 200) {
      final rawData = jsonDecode(response.body) as Map<String, dynamic>;
      return Payload.fromJson(rawData);
    } else {
      throw Exception('Failed to load data'); // TODO: Error handling on UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _isLoading
          ? const LinearProgressIndicator()
          : Text('${_payload!.name} - ${_payload!.type}'),
      subtitle: Text('${widget.payloadId}'),
    );
  }
}
