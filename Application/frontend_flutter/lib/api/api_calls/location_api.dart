import 'package:frontend_flutter/api/models/requests/location_requests/get_location_image_request.dart';
import 'package:frontend_flutter/api/models/requests/location_requests/get_locations_request.dart';
import 'package:frontend_flutter/api/models/responses/location_responses/get_location_image_response.dart';
import 'package:frontend_flutter/api/models/responses/location_responses/get_locations_response.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/api/api_calls/base_api.dart';
import 'dart:convert';
import 'dart:io';

class LocationApi {
  static Future<GetLocationsResponse> getLocations(
      GetLocationsRequest getLocationsRequest) async {
    try {
      request() async {
        final queryParameters = getLocationsRequest.toQueryParameters();
        final url = BaseApi.getUriWithQueryParameters('locations', queryParameters);
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      print (jsonResponse);
      GetLocationsResponse getLocationsResponse =
          GetLocationsResponse.fromJson(jsonResponse);
      return getLocationsResponse;
    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not get locations. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<GetLocationImageResponse> getLocationImage(
      GetLocationImageRequest getLocationImageRequest) async {
    try {
      request() async {
        final urlSuffix = getLocationImageRequest.getUrl('locations/fetch-image');
        final url = BaseApi.getUri(urlSuffix);
        final headers = BaseApi.getHeadersWithAuthorization();
        return await http.get(url, headers: headers);
      }

      var response = await BaseApi.performRequestWithRetry(request);
      var jsonResponse = jsonDecode(response.body);
      GetLocationImageResponse getLocationImageResponse =
          GetLocationImageResponse.fromJson(jsonResponse);
      return getLocationImageResponse;

    } on SocketException {
      throw Exception(
          'Unable to connect to the server. Please check your internet connection');
    } on FormatException {
      throw Exception('Could not get location image. Please try again later');
    } on Exception {
      throw Exception('Unexpected error occurred');
    }
  }
}
