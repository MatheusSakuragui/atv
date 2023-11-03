import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

Future<void> fetchProducts() async {
  final response = await http.get(Uri.parse('https://loja-mcyhir2om-rodrigoribeiro027.vercel.app/produtos/buscar'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<Product> productList = List<Product>.from(data.map((model) => Product.fromJson(model)));
    if (mounted) {
      setState(() {
        products = productList;
      });
    }
  } else {
    throw Exception('Failed to load products');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(products[index].name),
              subtitle: Text('Preço: ${products[index].price.toStringAsFixed(2)}'),
         trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit), // Ícone de edição
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProductPage(product: products[index]),
                      )).then((value) {
                        if (value != null && value) {
                          fetchProducts();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteProduct(products[index].id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateProductPage())).then((value) {
            if (value != null && value) {
              fetchProducts();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void deleteProduct(String productId) async {
    final response = await http.delete(Uri.parse('https://loja-mcyhir2om-rodrigoribeiro027.vercel.app/produtos/excluir/$productId'));

    await fetchProducts();
  }
  
}

class Product {
  final String id; // Change 'id' to '_id'.
  final String name;
  final double price;
  final String description;
  final int quantity;

  Product({
    required this.id, // Change 'id' to '_id'.
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'], // Change 'id' to '_id'.
      name: json['nome'],
      price: json['preco'].toDouble(),
      description: json['descricao'],
      quantity: json['quantidade'],
    );
  }
}



class CreateProductPage extends StatefulWidget {
  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final numberFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  Future<bool> createProduct() async {
    final response = await http.post(
      Uri.parse('https://loja-mcyhir2om-rodrigoribeiro027.vercel.app/produtos/criar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'nome': nameController.text,
        'preco': double.parse(priceController.text),
        'descricao': descriptionController.text,
        'quantidade': int.parse(quantityController.text),
      }),
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pop(true);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Produto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome do Produto'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [numberFormatter],
              decoration: InputDecoration(labelText: 'Preço'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descrição do Produto'),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [numberFormatter],
              decoration: InputDecoration(labelText: 'Quantidade'),
            ),
            SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  bool created = await createProduct();
                    Navigator.of(context).pop(true); 
              
                },
                child: Text('Criar Produto'),
              )
          ],
        ),
      ),
    );
  }
}
class EditProductPage extends StatefulWidget {
  final Product product;

  EditProductPage({required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final numberFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  @override
  void initState() {
    super.initState();
    nameController.text = widget.product.name;
    priceController.text = widget.product.price.toStringAsFixed(2);
    descriptionController.text = widget.product.description;
    quantityController.text = widget.product.quantity.toString();
  }

  Future<bool> updateProduct() async {
    final response = await http.put(
      Uri.parse('https://loja-mcyhir2om-rodrigoribeiro027.vercel.app/produtos/atualizar/${widget.product.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'nome': nameController.text,
        'preco': double.parse(priceController.text),
        'descricao': descriptionController.text,
        'quantidade': int.parse(quantityController.text),
      }),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Produto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome do Produto'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [numberFormatter],
              decoration: InputDecoration(labelText: 'Preço'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descrição do Produto'),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [numberFormatter],
              decoration: InputDecoration(labelText: 'Quantidade'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                bool updated = await updateProduct();
                  Navigator.of(context).pop(true);
               
              },
              child: Text('Atualizar Produto'),
            )
          ],
        ),
      ),
    );
  }
}
