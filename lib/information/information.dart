import 'package:flutter/material.dart';
import 'package:tour_guide_app_flutter/main.dart';
import 'package:tour_guide_app_flutter/maps/mapsgeneral.dart';
import 'descripcion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({required this.username, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> lugaresList = [];
  List<Map<String, dynamic>> _lugaresByCategory = [];
  List<Map<String, dynamic>> _lugaresFiltered = [];
  String _searchText = '';
  final TextEditingController _searchTextEditingController =
      TextEditingController();

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
      showLugaresByCategory('Parque');
    });
  }

  void clearSearch() {
    setState(() {
      _searchText = '';
      _lugaresFiltered = [];
      _searchTextEditingController.clear();
    });
  }

  void showLugaresByCategory(String category) {
    List<Map<String, dynamic>> lugaresByCategory =
        lugaresList.where((lugar) => lugar['categoria'] == category).toList();

    setState(() {
      _lugaresByCategory = lugaresByCategory;
    });
  }

  void searchLugaresByCategory(String category) {
    List<Map<String, dynamic>> lugaresFiltered = [];

    if (category.isNotEmpty) {
      lugaresFiltered = lugaresList
          .where((lugar) =>
              lugar['categoria'].toLowerCase() == category.toLowerCase())
          .toList();
    }

    setState(() {
      _searchText = category;
      _lugaresFiltered = lugaresFiltered;
    });
  }

  showInfoDialog(BuildContext context, String appName, String appDescription,
      String appVersion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appDescription),
              const SizedBox(height: 10),
              Text('Versión: $appVersion'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget makeItem(
      {image,
      nombre,
      categoria,
      descripcion,
      horarios,
      precios,
      ubicacion,
      latitud,
      longitud,
      username}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Descripcion(
              image: image ?? "",
              nombre: nombre ?? "",
              categoria: categoria ?? "",
              descripcion: descripcion ?? "",
              horarios: horarios ?? "",
              precios: precios ?? "",
              ubicacion: ubicacion ?? "",
              latitud: latitud,
              longitud: longitud,
              username: widget.username,
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 5 / 3,
        child: Container(
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(.8),
                  Colors.black.withOpacity(.2),
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                nombre,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://hips.hearstapps.com/hmg-prod/images/the-mandalorian-3-grogu-ig-12-figura-star-wars-643fa5510d0d4.jpg?crop=0.7435185185185186xw:1xh;center,top&resize=1200:*'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hola, ${widget.username}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Información"),
              onTap: () {
                Navigator.pop(context);
                showInfoDialog(
                  context,
                  "TOUR GUIDE APP",
                  "Descubre los lugares más emblemáticos y fascinantes de nuestra ciudad con nuestra aplicación de guía turística. Explora museos llenos de historia, maravíllate con monumentos icónicos y relájate en hermosos parques. Además, encuentra los mejores restaurantes para deleitar tu paladar. ¡Embárcate en una aventura inolvidable con nuestra app de turismo!",
                  "2.0.0",
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text("Mapa"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const MapsPageGeneral())));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text("Cerrar Sesión",
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => const MyApp())));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (innerContext) {
          return FloatingActionButton(
            onPressed: () {
              Scaffold.of(innerContext).openDrawer();
            },
            backgroundColor:
                Colors.green.withOpacity(0.7), // Cambia el color y la opacidad
            foregroundColor: Colors.white, // Cambia el color del ícono
            elevation: 2.0,
            child: const Icon(Icons.menu),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      backgroundColor: Colors.green[100],
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/imagenes/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.green.withOpacity(.8),
                        Colors.green.withOpacity(.2),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const Text(
                        "¿A dónde iremos?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchText = value.toLowerCase();
                              searchLugaresByCategory(value);
                            });
                          },
                          controller: _searchTextEditingController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.green),
                            suffixIcon: _searchText.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        clearSearch();
                                        _searchText = '';
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                      });
                                    },
                                  )
                                : null,
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                            hintText: "Busca por categoría...",
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              if (_searchText.isEmpty) ...[
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Parques más visitados",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _lugaresByCategory.length,
                          itemBuilder: (context, index) {
                            return makeItem(
                              image: _lugaresByCategory[index]['img'],
                              nombre: _lugaresByCategory[index]['nombre'],
                              categoria: _lugaresByCategory[index]['categoria'],
                              descripcion: _lugaresByCategory[index]
                                  ['descripcion'],
                              horarios: _lugaresByCategory[index]['horarios'],
                              precios: _lugaresByCategory[index]['precios'],
                              ubicacion: _lugaresByCategory[index]['ubicacion'],
                              latitud: _lugaresByCategory[index]['latitud'],
                              longitud: _lugaresByCategory[index]['longitud'],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Todos los lugares",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: lugaresList.map((lugar) {
                          return makeItem(
                            image: lugar['img'],
                            nombre: lugar['nombre'],
                            categoria: lugar['categoria'],
                            descripcion: lugar['descripcion'],
                            horarios: lugar['horarios'],
                            precios: lugar['precios'],
                            ubicacion: lugar['ubicacion'],
                            latitud: lugar['latitud'],
                            longitud: lugar['longitud'],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ] else ...[
                if (_searchText.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Resultados de la búsqueda",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: _lugaresFiltered.map((lugar) {
                            return makeItem(
                              image: lugar['img'],
                              nombre: lugar['nombre'],
                              categoria: lugar['categoria'],
                              descripcion: lugar['descripcion'],
                              horarios: lugar['horarios'],
                              precios: lugar['precios'],
                              ubicacion: lugar['ubicacion'],
                              latitud: lugar['latitud'],
                              longitud: lugar['longitud'],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ],
            ]),
      ),
    );
  }
}
