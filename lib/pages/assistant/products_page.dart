import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> productos = [
    {'nombre': 'Desparasitante Canino', 'precio': 25000, 'stock': 15},
    {'nombre': 'Collar Antipulgas', 'precio': 40000, 'stock': 10},
  ];

  void _openDialog({int? index}) {
    final editing = index != null;
    final p = editing ? productos[index!] : null;
    final nombreCtrl = TextEditingController(text: p?['nombre']);
    final precioCtrl = TextEditingController(text: p?['precio']?.toString());
    final stockCtrl = TextEditingController(text: p?['stock']?.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editing ? 'Editar producto' : 'Agregar producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input('Nombre del producto', nombreCtrl),
            _input('Precio', precioCtrl, keyboard: TextInputType.number),
            _input('Stock', stockCtrl, keyboard: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              final data = {
                'nombre': nombreCtrl.text.trim(),
                'precio': double.tryParse(precioCtrl.text.trim()) ?? 0,
                'stock': int.tryParse(stockCtrl.text.trim()) ?? 0,
              };
              setState(() {
                if (editing) {
                  productos[index!] = data;
                } else {
                  productos.add(data);
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  void _deleteProduct(int index) {
    setState(() => productos.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Catálogo de Productos',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.teal[700])),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Agregar producto'),
              onPressed: () => _openDialog(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Producto')),
                  DataColumn(label: Text('Precio')),
                  DataColumn(label: Text('Stock')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: List.generate(productos.length, (i) {
                  final p = productos[i];
                  return DataRow(cells: [
                    DataCell(Text(p['nombre'])),
                    DataCell(Text('\$${p['precio']}')),
                    DataCell(Text(p['stock'].toString())),
                    DataCell(Row(children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.teal),
                        onPressed: () => _openDialog(index: i),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteProduct(i),
                      ),
                    ])),
                  ]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
