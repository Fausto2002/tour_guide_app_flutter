import 'package:flutter/material.dart';
import 'package:tour_guide_app_flutter/comments/comments.dart';
import 'package:tour_guide_app_flutter/maps/maps.dart';

class Descripcion extends StatelessWidget {
  final String image;
  final String nombre;
  final String categoria;
  final String descripcion;
  final String horarios;
  final String precios;
  final String ubicacion;
  final double latitud;
  final double longitud;
  final String username;

  const Descripcion(
      {Key? key,
      required this.image,
      required this.nombre,
      required this.categoria,
      required this.descripcion,
      required this.horarios,
      required this.precios,
      required this.ubicacion,
      required this.latitud,
      required this.longitud,
      required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.45),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      child: Container(
                        width: 150,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      nombre,
                      style: const TextStyle(fontSize: 30, height: 1.5),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          ubicacion,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            categoria,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(height: 16),
                    DescripcionInfo(
                      icon: Icons.description,
                      nombre: "Descripción",
                      content: descripcion,
                    ),
                    const SizedBox(height: 16),
                    DescripcionInfo(
                      icon: Icons.schedule,
                      nombre: "Horarios",
                      content: horarios,
                    ),
                    const SizedBox(height: 16),
                    DescripcionInfo(
                      icon: Icons.attach_money,
                      nombre: "Precios",
                      content: precios,
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ComentariosPage(
                                    nombreLugar: nombre, username: username),
                              ),
                            );
                          },
                          icon: const Icon(Icons.comment),
                          label: const Text('Comentarios'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapsPage(
                                        latitud: latitud,
                                        longitud: longitud,
                                        nombre: nombre,
                                        image: image,
                                      )),
                            );
                          },
                          icon: const Icon(Icons.map),
                          label: const Text('Mapa'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DescripcionInfo extends StatelessWidget {
  final IconData icon;
  final String nombre;
  final String content;

  const DescripcionInfo({
    Key? key,
    required this.icon,
    required this.nombre,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            Text(
              nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(content),
      ],
    );
  }
}
