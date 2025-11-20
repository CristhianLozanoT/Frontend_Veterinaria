import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<bool> showConfirmDeleteDialog(BuildContext context,
    {required String titulo, required String mensaje}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_rounded,
                      size: 60, color: Colors.redAccent[700]),
                  const SizedBox(height: 15),
                  Text(
                    titulo,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    mensaje,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // CANCELAR
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Cancelar",
                            style: GoogleFonts.inter(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                      ),

                      // ELIMINAR
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.redAccent[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Eliminar",
                            style: GoogleFonts.inter(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ) ??
      false;
}
