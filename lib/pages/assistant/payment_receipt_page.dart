import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PaymentReceiptPage extends StatelessWidget {
  final Map<String, dynamic> factura;
  final double total;

  const PaymentReceiptPage({
    super.key,
    required this.factura,
    required this.total,
  });

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Encabezado
              pw.Center(
                child: pw.Text('VetConnect 🐾',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.teal700,
                    )),
              ),
              pw.SizedBox(height: 5),
              pw.Center(
                child: pw.Text('Comprobante de Pago',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    )),
              ),
              pw.Divider(),

              // Información principal
              pw.SizedBox(height: 20),
              pw.Text('Factura Nº ${factura['id']}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Mascota: ${factura['mascota']}'),
              pw.Text('Veterinario: ${factura['veterinario']}'),

              pw.SizedBox(height: 15),
              pw.Text('Medicamentos:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),

              // Lista de medicamentos
              pw.ListView.builder(
                itemCount: (factura['medicamentos'] as List).length,
                itemBuilder: (_, i) {
                  final m = factura['medicamentos'][i];
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text('• ${m['nombre']} — \$${m['precio']}'),
                  );
                },
              ),

              pw.Divider(),
              pw.Text('Total: \$${total.toStringAsFixed(0)}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.teal700,
                  )),

              pw.SizedBox(height: 15),
              pw.Text('Fecha de pago: ${DateTime.now()}'),

              pw.SizedBox(height: 30),
              pw.Center(
                child: pw.Text('Pago simulado exitosamente 💚',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green700,
                    )),
              ),

              pw.Spacer(),

              // Firma digital simulada
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.SizedBox(height: 30),
                    pw.Text('__________________________',
                        style: pw.TextStyle(color: PdfColors.grey)),
                    pw.Text('Dr. ${factura['veterinario']}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey800,
                        )),
                    pw.Text('Firma digital simulada',
                        style: pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Factura Nº ${factura['id']}',
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w700, color: Colors.teal[700]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('✅ Pago realizado exitosamente',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 18)),
            const SizedBox(height: 20),
            Text('Mascota: ${factura['mascota']}'),
            Text('Veterinario: ${factura['veterinario']}'),
            const SizedBox(height: 10),
            const Text('Medicamentos:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate((factura['medicamentos'] as List).length, (i) {
              final m = factura['medicamentos'][i];
              return Text('• ${m['nombre']} — \$${m['precio']}');
            }),
            const Divider(),
            Text('Total: \$${total.toStringAsFixed(0)}',
                style: const TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Fecha de pago: ${DateTime.now()}'),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _generatePdf(context),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Descargar comprobante PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
