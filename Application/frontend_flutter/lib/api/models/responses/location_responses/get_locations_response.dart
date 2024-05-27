import 'package:frontend_flutter/api/models/responses/base_response.dart';

class GetLocationsResponse extends BaseApiResponse {
  final List<Clinic> clinics;

  GetLocationsResponse.fromJson(super.json)
      : clinics = (json['data'] as List)
            .map((clinicJson) => Clinic.fromJson(clinicJson))
            .toList(),
        super.fromJson();
}

class Clinic {
  final String? name;
  final Location? location;
  final double? rating;
  final int? numberOfReviews;
  final String? openStatus;
  final String? placeId;
  final String? googleMapsLink;
  final String? address;
  final String? photoReference;

  Clinic({
    this.name,
    this.location,
    this.rating,
    this.numberOfReviews,
    this.openStatus,
    this.placeId,
    this.googleMapsLink,
    this.address,
    this.photoReference,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      name: json['name'],
      location: Location.fromJson(json['location']),
      rating: json['rating']?.toDouble(),
      numberOfReviews: json['numberOfReviews'],
      openStatus: json['openStatus'],
      placeId: json['placeId'],
      googleMapsLink: json['googleMapsLink'],
      address: json['address'],
      photoReference: json['photoReference'],
    );
  }
}

class Location {
  final double? latitude;
  final double? longitude;

  Location({
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['lat']?.toDouble(),
      longitude: json['lng']?.toDouble(),
    );
  }
}
