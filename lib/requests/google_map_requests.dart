import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'dart:convert';

const apiKey = "AIzaSyDnxRFbPQDEszDTHDOUGs4Rl2e2eU05aYA";

class GoogleMapsServices{

  Future<String> getRouteCoordinates(LatLng l1, LatLng l2)
  async{
    //sending the destination and position latlng

    //retrieve json file of the route
    var response = await get(Uri.parse("https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude}, ${l1.longitude}&destination=${l2.latitude}, ${l2.longitude}&key=$apiKey"));
    Map values = jsonDecode(response.body);

    return values["routes"][0]["overview_polyline"]["points"];
  }
}