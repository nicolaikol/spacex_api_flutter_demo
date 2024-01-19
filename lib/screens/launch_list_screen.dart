import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacex_demo/models/api_space_x/launch.dart';
import 'package:spacex_demo/screens/launch_details_screen/index.dart';

class LaunchListView extends StatefulWidget {
  const LaunchListView({super.key});

  @override
  State<LaunchListView> createState() => _LaunchListViewState();
}

// TODO: Seperate the pagination logic into it's own mixin
class _LaunchListViewState extends State<LaunchListView> {
  // --- NON-STATE Variables
  final _scrollController = ScrollController();
  int _currentPage = 0;
  bool _hasNextPage = true;
  bool _didDispose = false;

  // --- STATE Variables
  List<Launch> _list = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadNextPage();
  }

  @override
  void dispose() {
    _didDispose = true;
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_isLoading) {
      return;
    }

    if (!_hasNextPage) {
      return;
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    _currentPage++;
    setState(() {
      _isLoading = true;
    });

    _fetchData().then((value) {
      if (_didDispose) {
        return; // Good practice to not attempt state changes in async processes if the widget is disposed.
      }

      setState(() {
        _list = [
          ..._list,
          ...value,
        ];
        _isLoading = false;
      });
    });
  }

  Future<List<Launch>> _fetchData() async {
    final response = await http.post(
      Uri.parse('https://api.spacexdata.com/v5/launches/query'),
      headers: {"content-type": "application/json"},
      body:
          '{"options":{"limit":15,"page":$_currentPage}}', // TODO: Convert this into a model class and serialize it. I'm just beind lazy as it's just a demo
    );
    if (response.statusCode == 200) {
      final queryResults = jsonDecode(response.body) as Map<String,
          dynamic>; // TODO: Use a model class and serialize it. I'm just being lazy as it's just a demo
      _hasNextPage = queryResults['hasNextPage'] as bool;
      final rawList = queryResults['docs'] as List<dynamic>;
      final list = rawList.map((e) => Launch.fromJson(e)).toList();
      return list;
    } else {
      throw Exception('Failed to load data'); // TODO: Error handling on UI
    }
  }

  _onTapLaunch(Launch l) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LaunchDetailsScreen(launch: l)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Launch List"),
          // actions: [], // TODO: Here we can add a filter/re-order icon which you can click, and it allows you to filter the list / change the order of the list
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Stack(alignment: Alignment.bottomCenter, children: [
            ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              itemCount: _list.length,
              itemBuilder: (BuildContext context, int index) {
                Launch l = _list[index];
                return ListTile(
                  title: Text(l.name),
                  subtitle: Text('#${l.flightNumber} - ${l.id}'),
                  onTap: () => _onTapLaunch(l),
                );
              },
            ),
            if (_isLoading)
              SizedBox(
                width: constraints.maxWidth,
                height: 80,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ]);
        }));
  }
}
