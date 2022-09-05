import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';



class TestMap extends StatefulWidget {
  const TestMap({Key? key}) : super(key: key);

  @override
  State<TestMap> createState() => _TestMapState();
  
}



class _TestMapState extends State<TestMap> {
  Position? position;
  
  var startlat;
  
  var startlong;
  
  double? distance;
   List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
    Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  
  @override
  void initState() {
    // TODO: implement initState
    setInitialLocation();
    getdata();
    super.initState();
    
   
  
  }

  LocationData? currentLocation;
Location? location=Location();
        DocumentSnapshot? snapshot;
 final User? user = FirebaseAuth.instance.currentUser;
 double? x1,y1,x2,y2;
//  double? newloclat,newlong;
  void setInitialLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
   position= await Geolocator.getCurrentPosition();
   
     FirebaseFirestore.instance.collection("user_location").doc(user!.uid).set({
      "start":"startlat",
    "latitude":position!.latitude,
    "longitude":position!.longitude,
    "endlatitude":"",
     "endlongitude":"" ,
   });
  
     
  
  // await FirebaseFirestore.instance.collection('onChange_location').add({
  //   "latitude": position!.latitude,
  //   "longitude": position!.longitude
  // });
  
}
void onchange(){
  location!.onLocationChanged.listen((event) async {   
    setState(() {
      // newloclat=event.latitude!;
      // newlong=event.longitude!;
    }); 
 setState(() {
      getdata();
      // drawroute(x1!, y1!, newloclat!,newlong!);
       Fluttertoast.showToast(msg: "distance$distance");
    });

   await FirebaseFirestore.instance.collection("user_location").doc(user!.uid).update({
    "endlatitude":event.latitude,
     "endlongitude":event.longitude ,
   });

   });
}

    getdata() async{
     final data =  await FirebaseFirestore.instance.collection("user_location").doc(user!.uid).get(); //get the data
     snapshot = data;
       x1=snapshot!.get("latitude");
        y1=snapshot!.get("longitude");
        x2=snapshot!.get("endlatitude");
        y2=snapshot!.get("endlongitude");
       distance=calculateDistance(x1, y1, x2, y2);
      //  drawroute(x1!, y1!, , y1!);
      Fluttertoast.showToast(msg: "distance$distance");
        
    // 
   } 

   double calculateDistance(lat1, lon1, lat2, lon2){
  var p = 0.017453292519943295;
  var a = 0.5 - cos((lat2 - lat1) * p)/2 + 
        cos(lat1 * p) * cos(lat2 * p) * 
        (1 - cos((lon2 - lon1) * p))/2;
  return 1000 * 12742 * asin(sqrt(a));
}


  @override
  Widget build(BuildContext context) {
    onchange();
      drawroute(x1!, y1!, x2!, y2!);
    Fluttertoast.showToast(msg: "$x1");
    // getdata();
    print("your current distance is $distance");
    return Scaffold(
      body: Stack(children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: {
              Marker(markerId: MarkerId("source"),
              position: LatLng(x1!,y1!),
              ),

              // Marker(markerId: MarkerId("destination"),
              // position: LatLng(x2!,y2!),
              // ),
 
            },

            polylines: {
              Polyline(polylineId: PolylineId("route"),
              points: polylineCoordinates,
              ),
            },
                initialCameraPosition: CameraPosition(
                    target: LatLng(34.007832584804724, 71.53103514424775),
                    zoom: 18)),

                    Positioned(
                      bottom: 0,
                      left: 50,
                      right: 50,
                      child: Column(
                        children: [
                          // Text("speed"+position!.speed.toString()),
                          Text(distance.toString().substring(0,3)),
                        ],
                      )),

      ]),
    );
  }

  drawroute(double orignallat,double orignallong, double destinlat,double long) async{
     GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyDUpkW2Cixeg33umfD87s9CYkzsSyC3jXI";
   _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
       "AIzaSyDUpkW2Cixeg33umfD87s9CYkzsSyC3jXI",
        PointLatLng(34.00966468532561, 71.52476950425101),
        PointLatLng(34.01048289220693, 71.54734297412233),
        travelMode: TravelMode.driving,
        // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]
        );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      
    });
    _addPolyLine();
  }
  }

 

 
}
