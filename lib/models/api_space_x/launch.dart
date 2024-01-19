/// An entity representing the parsed API response from https://github.com/r-spacex/SpaceX-API/blob/master/docs/launches/v5/
class Launch {
  final String id;
  final List<String> payloadIds;
  final int flightNumber;
  final String name;
  final bool? success;
  final String? details;
  //... add more properties when they become required. (See here for the list - https://github.com/r-spacex/SpaceX-API/blob/master/docs/launches/v5/all.md)

  const Launch({
    required this.id,
    required this.payloadIds,
    required this.flightNumber,
    required this.name,
    required this.success,
    required this.details,
  });

  factory Launch.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'payloads': List<dynamic>
            payloads, // ... I have no idea why dart refused to parse this as List<String>
        'flight_number': int flightNumber,
        'name': String name,
        'success': bool? success,
        'details': String? details,
      } =>
        Launch(
          id: id,
          payloadIds: payloads.map((e) => e as String).toList(),
          flightNumber: flightNumber,
          name: name,
          success: success,
          details: details,
        ),
      _ => throw const FormatException('Failed to parse.'),
    };
  }
}
