class Location {
  dynamic idLocation;
  dynamic address;
  dynamic latitude;
  dynamic longitude;

  Location({
    this.idLocation,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      idLocation: json['id_location'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_location': idLocation,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
