/// An entity representing the parsed API response from https://github.com/r-spacex/SpaceX-API/blob/master/docs/payloads/v4/
class Payload {
  final String id;
  final String name;
  final String type;
  //... add more properties when they become required. (See here for the list - https://github.com/r-spacex/SpaceX-API/blob/master/docs/payloads/v4/all.md)

  const Payload({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'name': String name,
        'type': String type,
      } =>
        Payload(
          id: id,
          name: name,
          type: type,
        ),
      _ => throw const FormatException('Failed to parse.'),
    };
  }
}
