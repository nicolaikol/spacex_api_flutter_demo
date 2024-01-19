import 'package:flutter/material.dart';
import 'package:spacex_demo/models/api_space_x/launch.dart';
import 'package:spacex_demo/screens/launch_details_screen/components/payload_tile.dart';

class LaunchDetailsScreen extends StatefulWidget {
  const LaunchDetailsScreen({super.key, required this.launch});

  final Launch launch;

  @override
  State<LaunchDetailsScreen> createState() => _LaunchDetailsScreenState();
}

class _LaunchDetailsScreenState extends State<LaunchDetailsScreen> {
  // --- NON-STATE Variables
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final l = widget.launch;
    String status =
        l.success == null ? 'Unknown' : (l.success! ? 'Success' : 'Failure');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Launch: ${l.name}"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flight Number: ${l.flightNumber}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(
                'ID: ${l.id}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(
                'Status: $status',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Divider(),
              Text(
                'Payloads',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: _scrollController,
                  itemCount: l.payloadIds.length,
                  itemBuilder: (BuildContext context, int index) {
                    String id = l.payloadIds[index];
                    return PayloadListTile(payloadId: id);
                  },
                ),
              ),
            ],
          )),
    );
  }
}
