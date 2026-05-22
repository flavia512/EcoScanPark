import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/user_provider.dart';

// Soporta cámara en web, Android e iOS. Simulación solo en escritorio nativo.
bool get _supportsCamera {
  if (kIsWeb) return true;
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  bool _torchOn = false;
  MobileScannerController? _cameraController;
  late AnimationController _lineController;
  late Animation<double> _lineAnim;

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _lineAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInOut),
    );

    if (_supportsCamera) {
      _cameraController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: false,
      );
    }
  }

  @override
  void dispose() {
    _lineController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  // ── Procesamiento del barcode detectado ──────────────────
  Future<void> _onBarcodeDetected(String barcode) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    _cameraController?.stop();

    final provider = context.read<UserProvider>();
    final error = await provider.submitScan(barcode);

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (error != null) {
      provider.simulateScan();
      if (!mounted) return;
      final record = provider.lastScan;
      if (record != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Modo demo: escaneo registrado localmente'),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pushNamed(context, '/scan_result', arguments: record);
      }
      return;
    }

    final record = provider.lastScan;
    if (record != null) {
      Navigator.pushNamed(context, '/scan_result', arguments: record);
    }
  }

  // ── Demo barcodes (solo Windows/Web) ─────────────────────
  static const _demoBarcodes = [
    '7501031311309', '6111244040396', '8410076486250',
    '4006381333931', '5449000000996', '0012000001086',
    'ORG-001', 'ORG-002', 'ORG-003', 'NR-001', 'NR-002',
  ];

  Future<void> _simulateScan() async {
    final barcode =
        _demoBarcodes[DateTime.now().millisecond % _demoBarcodes.length];
    await _onBarcodeDetected(barcode);
  }

  void _toggleTorch() {
    _cameraController?.toggleTorch();
    setState(() => _torchOn = !_torchOn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Fondo: cámara real o gradiente simulado ──────
          if (_supportsCamera && _cameraController != null)
            MobileScanner(
              controller: _cameraController!,
              onDetect: (capture) {
                final barcode = capture.barcodes.firstOrNull?.rawValue;
                if (barcode != null && barcode.isNotEmpty) {
                  _onBarcodeDetected(barcode);
                }
              },
            )
          else
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D1A0D),
                    Color(0xFF1A2E1A),
                    Color(0xFF0D1A0D)
                  ],
                ),
              ),
            ),

          // ── UI superpuesta ────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.eco,
                          color: AppColors.lightGreen, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'ECOSCANPARK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                const Text(
                  'Enfoca el código de barras',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _isProcessing
                      ? 'Procesando escaneo...'
                      : 'Centra el producto en el recuadro',
                  style:
                      const TextStyle(color: Colors.white60, fontSize: 13),
                ),

                const Spacer(),

                // Marco del escáner
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _isProcessing
                              ? AppColors.amber
                              : AppColors.lightGreen,
                          width: 2.5,
                        ),
                        color: _supportsCamera
                            ? Colors.transparent
                            : Colors.white.withValues(alpha: 0.04),
                      ),
                      child: _isProcessing
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.amber,
                                strokeWidth: 3,
                              ),
                            )
                          : _supportsCamera
                              ? null
                              : const Icon(
                                  Icons.qr_code_2,
                                  size: 90,
                                  color: Color(0x33FFFFFF),
                                ),
                    ),
                    // Línea animada (solo cuando no procesa)
                    if (!_isProcessing)
                      AnimatedBuilder(
                        animation: _lineAnim,
                        builder: (context, _) {
                          return Positioned(
                            top: _lineAnim.value * 240 + 10,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppColors.lightGreen,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.lightGreen
                                        .withValues(alpha: 0.6),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ...['tl', 'tr', 'bl', 'br'].map((pos) => _Corner(pos)),
                  ],
                ),

                const Spacer(),

                // Controles inferiores
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ControlBtn(
                        icon: _torchOn
                            ? Icons.flash_on
                            : Icons.flash_off_outlined,
                        label: 'Flash',
                        onTap: _supportsCamera ? _toggleTorch : () {},
                      ),
                      // Botón central: en móvil confirma / en desktop dispara simulación
                      GestureDetector(
                        onTap: _isProcessing
                            ? null
                            : (_supportsCamera
                                ? null // en móvil la cámara detecta sola
                                : _simulateScan),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isProcessing
                                ? Colors.grey.shade700
                                : AppColors.primaryGreen,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGreen
                                    .withValues(alpha: 0.45),
                                blurRadius: 18,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                      _ControlBtn(
                        icon: Icons.close,
                        label: 'Cancelar',
                        onTap: () {
                          _cameraController?.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ],
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

class _Corner extends StatelessWidget {
  final String position;
  const _Corner(this.position);

  @override
  Widget build(BuildContext context) {
    const cornerSize = 22.0;
    const offset = 0.0;
    final isTop = position.startsWith('t');
    final isLeft = position.endsWith('l');

    return Positioned(
      top: isTop ? offset : null,
      bottom: isTop ? null : offset,
      left: isLeft ? offset : null,
      right: isLeft ? null : offset,
      child: SizedBox(
        width: cornerSize,
        height: cornerSize,
        child: CustomPaint(
          painter: _CornerPainter(isTop: isTop, isLeft: isLeft),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;
  const _CornerPainter({required this.isTop, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightGreen
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final x = isLeft ? 0.0 : size.width;
    final y = isTop ? 0.0 : size.height;

    canvas.drawLine(Offset(x, y), Offset(isLeft ? size.width : 0, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, isTop ? size.height : 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 11)),
        ],
      ),
    );
  }
}


