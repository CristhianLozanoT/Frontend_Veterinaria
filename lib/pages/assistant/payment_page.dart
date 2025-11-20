import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'payment_receipt_page.dart'; // 👈 para mostrar comprobante al final

class PaymentPage extends StatefulWidget {
  final String facturaId;
  final double monto;

  const PaymentPage({
    super.key,
    required this.facturaId,
    required this.monto,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String metodo = 'Tarjeta';
  final nombreCtrl = TextEditingController();
  final numeroCtrl = TextEditingController();
  final vencimientoCtrl = TextEditingController();
  final bancoCtrl = TextEditingController();
  final cvdCtrl = TextEditingController();

  void _confirmarPago() {
    if (nombreCtrl.text.isEmpty || numeroCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Completa todos los datos antes de continuar.')),
      );
      return;
    }

    final factura = {
      'id': widget.facturaId,
      'mascota': 'Mascota registrada',
      'veterinario': 'Dr. López',
      'medicamentos': [
        {'nombre': 'Antipulgas', 'precio': 30000},
        {'nombre': 'Vitaminas', 'precio': 15000},
      ]
    };

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentReceiptPage(
          factura: factura,
          total: widget.monto,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Pasarela de Pago Segura 🐾',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.teal[700],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.lock_outline,
                  color: Colors.teal[700], size: 60),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Simulación de pago - VetPay',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[700]),
              ),
            ),
            const SizedBox(height: 30),

            // Información general
            Text('Factura Nº ${widget.facturaId}',
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Monto total: \$${widget.monto.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                    fontSize: 16, color: Colors.teal[700])),
            const SizedBox(height: 30),

            // Método de pago
            DropdownButtonFormField<String>(
              value: metodo,
              decoration: const InputDecoration(
                labelText: 'Método de pago',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'Tarjeta', child: Text('Tarjeta de crédito / débito')),
                DropdownMenuItem(value: 'PSE', child: Text('Transferencia PSE')),
                DropdownMenuItem(
                    value: 'Efectivo', child: Text('Efectivo en punto físico')),
              ],
              onChanged: (v) => setState(() => metodo = v!),
            ),

            const SizedBox(height: 20),
            _input('Nombre del titular', nombreCtrl),

            if (metodo == 'Tarjeta') ...[
              _input('Número de tarjeta', numeroCtrl,
                  keyboard: TextInputType.number),
              _input('Fecha de vencimiento (MM/AA)', vencimientoCtrl),
              _input('CVD / CVV (3 dígitos)', cvdCtrl,
                  keyboard: TextInputType.number),
            ] else if (metodo == 'PSE') ...[
              _input('Banco', bancoCtrl),
              _input('Número de cuenta', numeroCtrl,
                  keyboard: TextInputType.number),
            ] else ...[
              _input('Documento del cliente', numeroCtrl,
                  keyboard: TextInputType.number),
            ],

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirmar pago simulado'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                ),
                onPressed: _confirmarPago,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
