import 'dart:convert';

import 'package:customerapp/dto/restaurant.dart';
import 'package:customerapp/endpoints/urls.dart';
import 'package:customerapp/exceptions/order-callback-failed.dart';
import 'package:http/http.dart' as http;

Future<List<RestaurantDTO>> getRestaurants() async {
  final response =
      await http.get(await EndpointDefinitions.makeRestaurantsURL(), headers: {
    "Content-Type": "application/json",
  });
  await new Future.delayed(const Duration(seconds: 3));
  if (response.statusCode == 200) {
    List<RestaurantDTO> restaurants = (json.decode(response.body) as List)
        .map((i) => RestaurantDTO.fromJson(i))
        .toList();
    return restaurants;
  } else {
    throw OrderCallbackFailed(
        'Failed to login', response.statusCode, response.body);
  }
}
