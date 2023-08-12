import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComentariosPage extends StatefulWidget {
  final String nombreLugar;
  final String username;

  const ComentariosPage(
      {required this.nombreLugar, required this.username, Key? key})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ComentariosPageState createState() => _ComentariosPageState();
}

class _ComentariosPageState extends State<ComentariosPage> {
  final TextEditingController _comentarioController = TextEditingController();
  double _puntuacion = 0.0;

  String _advertencia = '';

  void _submitComentario() async {
    final comentario = _comentarioController.text;

    if (_puntuacion == 0.0 || comentario.isEmpty) {
      setState(() {
        _advertencia = 'Debes agregar puntuación y comentario';
      });
    } else {
      await FirebaseFirestore.instance.collection('valoraciones').add({
        'comentario': comentario,
        'puntuacion': _puntuacion,
        'lugar':
            FirebaseFirestore.instance.doc('lugares/${widget.nombreLugar}'),
        'username': widget.username,
      });

      _comentarioController.clear();
      setState(() {
        _puntuacion = 0.0;
        _advertencia = '';
      });
    }
  }

  void _eliminarComentario(String comentarioId) async {
    await FirebaseFirestore.instance
        .collection('valoraciones')
        .doc(comentarioId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('valoraciones')
                  .where('lugar',
                      isEqualTo: FirebaseFirestore.instance
                          .doc('lugares/${widget.nombreLugar}'))
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final comentarios = snapshot.data!.docs;
                List<Widget> comentariosWidgets = [];
                for (var comentario in comentarios) {
                  final comentarioData =
                      comentario.data() as Map<String, dynamic>;
                  final comentarioId = comentario.id;
                  final comentarioText = comentarioData['comentario'];
                  final puntuacion = comentarioData['puntuacion'];
                  final username = comentarioData[
                      'username']; // Agregado: Obtener el nombre de usuario
                  final estrellas = List.generate(5, (index) {
                    return Icon(
                      index < puntuacion ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    );
                  });
                  final comentarioWidget = Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              ...estrellas,
                            ],
                          ),
                          subtitle: Text(comentarioText),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _eliminarComentario(comentarioId);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                  comentariosWidgets.add(comentarioWidget);
                }
                return ListView(
                  children: comentariosWidgets,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.center,
            child: Text(
              '¿Qué puntuación le das?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _puntuacion ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _puntuacion = index + 1.0;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  title: TextField(
                    controller: _comentarioController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Añadir comentario',
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _submitComentario,
                  icon: const Icon(Icons.send),
                  label: const Text('Enviar'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if (_advertencia.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _advertencia,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
