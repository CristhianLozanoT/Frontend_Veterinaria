import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'payment_page.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  List<Map<String, dynamic>> facturas = [
    {
      'id': '001',
      'mascota': 'Buddy',
      'veterinario': 'Dr. López',
      'estado': 'Pendiente',
      'medicamentos': [
        {'nombre': 'Antipulgas', 'precio': 30000},
        {'nombre': 'Vitaminas', 'precio': 15000},
      ],
    },
    {
      'id': '002',
      'mascota': 'Luna',
      'veterinario': 'Dr. Gómez',
      'estado': 'Pendiente',
      'medicamentos': [
        {'nombre': 'Pomada curativa', 'precio': 20000},
      ],
    },
  ];

  Future<void> _abrirPago(Map<String, dynamic> factura) async {
    final total = (factura['medicamentos'] as List)
        .fold<double>(0, (sum, item) => sum + (item['precio'] as double));

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          facturaId: factura['id'],
          monto: total,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        factura['estado'] = 'Pagada';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Facturas del Veterinario',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, color: Colors.teal[700])),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: facturas.length,
        itemBuilder: (_, i) {
          final f = facturas[i];
          final total = (f['medicamentos'] as List)
              .fold<double>(0, (sum, item) => sum + (item['precio'] as double));

          final esPagada = f['estado'] == 'Pagada';

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Factura Nº ${f['id']}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Mascota: ${f['mascota']}'),
                  Text('Veterinario: ${f['veterinario']}'),
                  const SizedBox(height: 10),
                  const Text('Medicamentos:',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  ...List.generate((f['medicamentos'] as List).length, (j) {
                    final m = (f['medicamentos'] as List)[j];
                    return Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text('• ${m['nombre']} — \$${m['precio']}'),
                    );
                  }),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total: \$${total.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.teal)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: esPagada
                              ? Colors.green[100]
                              : Colors.orange[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          esPagada ? 'Pagada' : 'Pendiente',
                          style: TextStyle(
                            color: esPagada
                                ? Colors.green[800]
                                : Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  if (!esPagada)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text('Pagar factura'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        onPressed: () => _abrirPago(f),
                      ),
                    )
                  else
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('✅ Pago completado',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
