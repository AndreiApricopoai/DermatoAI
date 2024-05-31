import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/api_calls/location_api.dart';
import 'package:frontend_flutter/api/models/requests/location_requests/get_location_image_request.dart';
import 'package:frontend_flutter/api/models/requests/location_requests/get_locations_request.dart';
import 'package:frontend_flutter/api/models/responses/location_responses/get_location_image_response.dart';
import 'package:frontend_flutter/api/models/responses/location_responses/get_locations_response.dart';
import 'package:geolocator/geolocator.dart';

class LocationsProvider with ChangeNotifier {
  List<Clinic>? _clinics;
  bool _isLoading = false;
  String? _errorMessage;
  double _selectedRange = 10.0;
  Map<String, Uint8List> _imageCache = {}; // Cache for image data

  List<Clinic>? get clinics => _clinics;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get selectedRange => _selectedRange;
  Map<String, Uint8List> get imageCache => _imageCache;

  Future<void> fetchLocations(double range) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedRange = range;
    _imageCache.clear(); // Clear image cache when fetching new locations
    notifyListeners();

    try {
          LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if( permission== LocationPermission.denied){
         //nothing
    }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      GetLocationsRequest request = GetLocationsRequest(
        latitude: position.latitude,
        longitude: position.longitude,
        radius: range * 1000,
      );

      GetLocationsResponse response = await LocationApi.getLocations(request);
      _clinics = response.clinics;
      await _preloadImages(_clinics!); // Preload images for all clinics
    } catch (e) {
      _errorMessage = 'Failed to load locations data. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _preloadImages(List<Clinic> clinics) async {
    for (var clinic in clinics) {
      if (clinic.photoReference != null) {
        String? image = await fetchLocationImage(clinic.photoReference ?? '');
        if (image != null && image.isNotEmpty) {
          _imageCache[clinic.photoReference!] = base64Decode(image.split(',').last);
        }
      }
    }
  }

  Future<String?> fetchLocationImage(String photoReference) async {
    if (_imageCache.containsKey(photoReference)) {
      return String.fromCharCodes(_imageCache[photoReference]!);
    }
    // Fetch from API if not in cache
    GetLocationImageRequest request = GetLocationImageRequest(photoReference: photoReference);
    GetLocationImageResponse response = await LocationApi.getLocationImage(request);
    _imageCache[photoReference] = base64Decode(response.image?.split(',').last ?? '');
    return response.image;
  }
  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }
}
