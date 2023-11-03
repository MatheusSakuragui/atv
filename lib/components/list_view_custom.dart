import 'package:atv_crud_flutter/pages/forms.dart';
import 'package:atv_crud_flutter/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListViewCustom extends StatefulWidget {
  final List<dynamic> data;

  const ListViewCustom({Key? key, required this.data}) : super(key: key);

  @override
  _ListViewCustomState createState() => _ListViewCustomState();
}

class _ListViewCustomState extends State<ListViewCustom> {
  Future<void> deleteProduct(id) async {
    final http.Response response = await http.delete(
      Uri.parse(
          'https://loja-mcyhir2om-rodrigoribeiro027.vercel.app/produtos/excluir/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      print(
          'Erro ao cadastrar produto: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        final item = widget.data[index];
        final nome = item["nome"];
        final descricao = item["descricao"];
        final preco = item["preco"];
        final quantidade = item["quantidade"];
        final id = item["_id"];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              'Nome: $nome',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Descrição: $descricao',
                  style: const TextStyle(fontSize: 14.0),
                ),
                Text(
                  'Preço: ${preco.toStringAsFixed(2)} Reais',
                  style: const TextStyle(fontSize: 14.0),
                ),
                Text(
                  'Quantidade: $quantidade',
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  color: const Color.fromARGB(255, 87, 0, 150),
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Forms(
                          titulo: "Editar",
                          nome: nome,
                          descricao: descricao,
                          preco: preco,
                          quantidade: quantidade,
                          id: id,
                          editar: true,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.delete_sharp),
                  onPressed: () {
                    deleteProduct(id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
