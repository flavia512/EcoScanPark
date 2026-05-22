import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../core/theme.dart';

// Productos registrados en la base de datos
const _products = [
  {'barcode': '7501031311309', 'name': 'Botella de Agua PET',  'pts': 15, 'emoji': '🍶', 'color': 0xFF2196F3},
  {'barcode': '6111244040396', 'name': 'Lata de Refresco',     'pts': 20, 'emoji': '🥤', 'color': 0xFF9C27B0},
  {'barcode': '8410076486250', 'name': 'Caja de Cartón',       'pts': 12, 'emoji': '📦', 'color': 0xFF795548},
  {'barcode': '4006381333931', 'name': 'Periódico / Papel',    'pts': 8,  'emoji': '📰', 'color': 0xFF607D8B},
  {'barcode': '5449000000996', 'name': 'Botella de Vidrio',    'pts': 18, 'emoji': '🍾', 'color': 0xFF4CAF50},
  {'barcode': '0012000001086', 'name': 'Envase Plástico HDPE', 'pts': 13, 'emoji': '🧴', 'color': 0xFF00BCD4},
  {'barcode': 'ORG-001',       'name': 'Restos de Fruta',      'pts': 10, 'emoji': '🍎', 'color': 0xFFFF5722},
  {'barcode': 'ORG-002',       'name': 'Cáscara de Huevo',     'pts': 10, 'emoji': '🥚', 'color': 0xFFFFC107},
  {'barcode': 'ORG-003',       'name': 'Restos de Comida',     'pts': 8,  'emoji': '🥗', 'color': 0xFF8BC34A},
  {'barcode': 'NR-001',        'name': 'Bolsa Plástica Sucia', 'pts': 5,  'emoji': '🛍️', 'color': 0xFF9E9E9E},
  {'barcode': 'NR-002',        'name': 'Unicel / Poliestireno','pts': 5,  'emoji': '📦', 'color': 0xFF757575},
];

class TestCodesScreen extends StatelessWidget {
  const TestCodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        title: const Text('Códigos de prueba',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Banner informativo
          Container(
            width: double.infinity,
            color: AppColors.amber.withValues(alpha: 0.15),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: AppColors.amber, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Muestra un QR en pantalla y escanéalo con otro dispositivo '
                    'o imprímelo.',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.brown.shade700),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _products.length,
              itemBuilder: (context, i) => _ProductCard(_products[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const _ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    final color = Color(product['color'] as int);
    final barcode = product['barcode'] as String;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showFullScreen(context, product),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // QR pequeño
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: QrImageView(
                  data: barcode,
                  version: QrVersions.auto,
                  size: 70,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: color,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product['emoji']}  ${product['name']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(barcode,
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontFamily: 'monospace')),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '+${product['pts']} pts',
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.open_in_full, color: Colors.grey.shade400, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullScreen(BuildContext context, Map<String, dynamic> product) {
    final color = Color(product['color'] as int);
    final barcode = product['barcode'] as String;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${product['emoji']}  ${product['name']}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              QrImageView(
                data: barcode,
                version: QrVersions.auto,
                size: 240,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: color,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                barcode,
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: 'monospace',
                    fontSize: 14),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+${product['pts']} puntos al reciclar',
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
