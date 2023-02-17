import 'package:carpooling_app/screens/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_webservice/places.dart';
import '../requests/google_map_requests.dart';
import 'package:flutter_google_places/flutter_google_places.dart' as gp;

class MyHomePage extends StatefulWidget
{
  MyHomePage({required this.title}) : super ();

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  @override
  // TODO: implement widget
  Widget build(BuildContext context){
    return Scaffold(
      body: Map()
    );
  }
}

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  //controllers
  late GoogleMapController mapController;
  GoogleMapsServices googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  late double x, y;

  late  LatLng _initialPosition = LatLng(26.8206,30.8025); //initial position when the application starts
  late LatLng _LastPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  late String predict;

  List<String> docIDs = [];
  Future getDocId() async{
    await FirebaseFirestore.instance.collection('Locations').get().then(
        (snapshot) => snapshot.docs.forEach((document){
          print(document.reference);
          docIDs.add(document.reference.id);

        }),
    );
  }



  @override
  void initState(){
    getDocId();
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return _initialPosition == null? Container(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      )
    ) : Stack(
        children: <Widget>[

          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition, zoom: 20,),
            //longitude and latitude of where im at
            onMapCreated: onCreated,
            myLocationEnabled: true,
            mapType: MapType.normal,
            //Map type (Satellite, normal, none, terrain)
            compassEnabled: true,
            markers: _markers,
            onCameraMove: _onCameraMove,
            polylines: _polyLines,
          ),


          Positioned(
              top: 70.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 5.0),
                        blurRadius: 10,
                        spreadRadius: 3,
                      )
                    ]
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: locationController,
                  decoration: InputDecoration(
                    icon: Container(margin: EdgeInsets.only(left: 15, top: 0),
                      width: 10,
                      height: 10,
                      child: Icon(Icons.location_on, color: Colors.black,),),
                    hintText: "Pick up",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                  ),
                ),
              )
          ),
          Positioned(
              top: 140.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 5.0),
                        blurRadius: 10,
                        spreadRadius: 3,
                      )
                    ]
                ),
                child: TextField(
                  // Suggestion list opens
                  onTap: () async
                  {

                    const kGoogleApiKey = "AIzaSyDnxRFbPQDEszDTHDOUGs4Rl2e2eU05aYA";

                    Prediction? p = await gp.PlacesAutocomplete.show(
                        context: context,
                        apiKey: kGoogleApiKey,
                        mode: gp.Mode.overlay, // Mode.fullscreen
                        language: "en",
                        strictbounds: false,
                        types: [],
                        components: [new Component(Component.country, "eg")]);
                    if(p != null)
                      {
                        setState(() => destinationController.text = p.description.toString());
                      }

                    createUser(address: destinationController.text);

                  },

                  cursorColor: Colors.black,
                  controller: destinationController,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value)
                  {
                    _markers.clear();
                    _polyLines.clear();
                    sendRequest(value);
                  },
                  decoration: InputDecoration(
                    icon: Container(
                      margin: EdgeInsets.only(left: 15, top: 0),
                      width: 10,
                      height: 10,
                      child: Icon(Icons.local_taxi, color: Colors.black,),),
                    hintText: "Destination",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                  ),
                ),
              )
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: TextButton(
              onPressed: () {},

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SettingsPage();
                      },
                    ),
                  );
                },
                icon: Icon(Icons.settings),
                label: Text(''),
              ),
            ),
          ),
          // Positioned(
          //   top: 40,
          //   right: 10,
          //   child: FloatingActionButton(onPressed: _onAddMarkerPressed,
          //   tooltip: "Add Marker",
          //     backgroundColor: Colors.teal,
          //     child: Icon(Icons.add_location, color: Colors.white)
          //   )
          // )
          // GestureDetector(
          //   onVerticalDragUpdate: (details){},
          //   onHorizontalDragUpdate: (details){
          //     if(details.delta.direction > 0){
          //       Navigator.of(context).push((MaterialPageRoute(builder: (context) => SettingsPage())));
          //     }
          //   },
          // )
        ]
    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _LastPosition = position.target;
    });
  }

  void _addMarker(LatLng location, String address) { //Add marker to the map
    setState(() {
      _markers.add(Marker(markerId: MarkerId(_LastPosition.toString()),
          position: location,
          infoWindow: InfoWindow(
              title: "Address",
              snippet: "Arrive here!"
          ),
          icon: BitmapDescriptor.defaultMarker

      ));
    });
  }

  void createRoute(String encodedPolyline)  //add poly lines to the map according the retrieved route from googlemapservices
  {
    setState(() {
      _polyLines.add(Polyline(polylineId: PolylineId(_LastPosition.toString()),
        width: 6,
        points: convertToLatLng(decodePoly(encodedPolyline)),
        color: Colors.teal,

      ));
    });
  }

  // covert list of doubles into LatLng in order to set polly lines on the map
  List<LatLng> convertToLatLng(List points){
    List<LatLng> result = <LatLng>[];

    for(int i = 0; i < points.length; i++)
      {
        if(i % 2 != 0){
          result.add(LatLng(points[i-1], points[i]));

        }
      }
    return result;
  }

  //Google API requests
  List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;

    //repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      }
      while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    // adding to previous value as done in encoding

    for (var i = 2; i < lList.length; i++)
      lList[i] += lList[i - 2];
    print(lList.toString());

    return lList;
  }

  //get user current location method
  void _getUserLocation() async{

    //ASK FOR ANDROID PERMISSIONS

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    //-------------------

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<geocoding.Placemark> placemark = await geocoding.placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      locationController.text = placemark[0].name!;
      _LastPosition = _initialPosition;
    });
  }

  //get called when the user enter a destination the text field
  void sendRequest(String intededDestination)async
  {

    List<geocoding.Location> locations = await geocoding.locationFromAddress(intededDestination);
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;

    LatLng destination = LatLng(latitude, longitude);

    //add a marker to the destination
    _addMarker(destination, intededDestination);
    String route = await googleMapsServices.getRouteCoordinates(_initialPosition, destination); //retrieve the route from googlemapservieces

    createRoute(route); //create a route

  }

}



// Database

//read in database



//Write in the database
Future createUser({required String address}) async
{
  //reference to document
  final docUser = FirebaseFirestore.instance.collection('Locations').doc();

  final location =  Location(id: docUser.id, Address: address);

  await docUser.set(location.toJson());





}

//Database info

class Location{
  final String id;
  final String Address;

  Location({this.id = '', required this.Address});

  toJson()
  {
    return
        {
          "id": id, 'Address': Address
        };
  }

}