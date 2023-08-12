import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapsPageGeneral extends StatefulWidget {
  const MapsPageGeneral({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapsPageGeneralState createState() => _MapsPageGeneralState();
}

class _MapsPageGeneralState extends State<MapsPageGeneral> {
  List<Map<String, dynamic>> lugaresList = [];
  Map<String, dynamic>? selectedLugar;
  bool _showCard = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    getLugaresFromFirebase();
  }

  void getLugaresFromFirebase() {
    FirebaseFirestore.instance
        .collection('lugares')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        lugaresList.add(data);
      }
      setState(() {});
    });
  }

  void _handleZoomIn() {
    _mapController.move(_mapController.center, _mapController.zoom + 1);
  }

  void _handleZoomOut() {
    _mapController.move(_mapController.center, _mapController.zoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: const LatLng(-1.831239, -78.183403),
                      zoom: 10.0,
                      onTap: (tapPosition, latLng) {
                        setState(() {
                          _showCard = false;
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: lugaresList.map((lugar) {
                          return Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(lugar['latitud'], lugar['longitud']),
                            builder: (ctx) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showCard = true;
                                  selectedLugar = lugar;
                                });
                              },
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 50,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(30),
              child: const Text(
                'Todos los lugares',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
          ),
          if (_showCard && selectedLugar != null)
            Positioned(
              bottom: 60,
              left: 70,
              right: 82,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          selectedLugar!['img'],
                          width: 90,
                          height: 90,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedLugar!['nombre'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                selectedLugar!['categoria'],
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
            ),
          ),
          Positioned(
            top: 170,
            right: 15,
            child: Column(children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: _handleZoomIn,
                child: const Icon(Icons.zoom_in),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: null,
                onPressed: _handleZoomOut,
                child: const Icon(Icons.zoom_out),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
