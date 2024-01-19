import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacex_demo/models/api_space_x/Launch.dart';

class LaunchListView extends StatefulWidget {
  const LaunchListView({super.key});

  @override
  State<LaunchListView> createState() => _LaunchListViewState();
}

class _LaunchListViewState extends State<LaunchListView> {
  final _scrollController = ScrollController();
  final _list = [];
  final isLoading = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);

    _fetchData().then((value) {
      setState(() {
        _list.addAll(value);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _currentPage++;
        _list.addAll(List.generate(
            20, (index) => 'Item ${index + 1 + _currentPage * 20}'));
      });
    }
  }

  Future<List<Launch>> _fetchData() async {
    final response =
        await http.get(Uri.parse('https://api.spacexdata.com/v5/launches'));
    if (response.statusCode == 200) {
      final rawList = jsonDecode(response.body) as List<dynamic>;
      final list = rawList.map((e) => Launch.fromJson(e)).toList();
      return list;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Launch List"),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) {
          Launch l = _list[index];
          return ListTile(
            title: Text(l.name),
            subtitle: Text(l.id),
          );
        },
      ),
    );
  }
}
