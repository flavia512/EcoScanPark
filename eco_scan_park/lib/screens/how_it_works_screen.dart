import 'package:flutter/material.dart';
import '../core/theme.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sageBackground,
      body: CustomScrollView(
        slivers: [
          // ── AppBar con degradado ──────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.darkGreen,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.darkGreen, AppColors.primaryGreen],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 44),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.eco,
                            color: Colors.white, size: 38),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Cómo funciona EcoScanPark',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Recicla · Escanea · Gana recompensas',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Sección: Pasos principales ────────────
                  _SectionTitle('Pasos para ganar puntos'),
                  const SizedBox(height: 12),
                  ..._steps.map((s) => _StepCard(s)),

                  const SizedBox(height: 28),

                  // ── Sección: Tipos de residuos ────────────
                  _SectionTitle('¿Qué residuos puedo reciclar?'),
                  const SizedBox(height: 12),
                  _WasteTypesGrid(),

                  const SizedBox(height: 28),

                  // ── Sección: Sistema de puntos ────────────
                  _SectionTitle('Sistema de puntos y niveles'),
                  const SizedBox(height: 12),
                  _LevelCard(),

                  const SizedBox(height: 28),

                  // ── Sección: Canjes ───────────────────────
                  _SectionTitle('¿Cómo canjear recompensas?'),
                  const SizedBox(height: 12),
                  _RedeemCard(),

                  const SizedBox(height: 28),

                  // ── Sección: FAQ ──────────────────────────
                  _SectionTitle('Preguntas frecuentes'),
                  const SizedBox(height: 12),
                  ..._faqs.map((f) => _FaqItem(f)),

                  const SizedBox(height: 32),

                  // ── Pie ───────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.eco,
                            color: AppColors.lightGreen, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          '¡Gracias por cuidar el planeta!',
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cada escaneo cuenta para un futuro mejor.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Modelos de datos ───────────────────────────────────────

class _StepData {
  final int number;
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  const _StepData(this.number, this.icon, this.color, this.title,
      this.description);
}

const _steps = [
  _StepData(1, Icons.recycling, AppColors.primaryGreen,
      'Separa tu residuo',
      'Identifica el material: plástico, aluminio, cartón, vidrio, papel u orgánico. Cada tipo tiene su propio contenedor en el parque.'),
  _StepData(2, Icons.qr_code_scanner, Color(0xFF1976D2),
      'Escanea el código',
      'Abre la app, ve a "Escanear" y enfoca el código de barras o QR del producto. La cámara lo detectará automáticamente.'),
  _StepData(3, Icons.stars_rounded, AppColors.amber,
      'Gana puntos',
      'Cada producto escaneado suma puntos según su tipo de material. El aluminio da más puntos que el papel, por ejemplo.'),
  _StepData(4, Icons.card_giftcard, Color(0xFF7B1FA2),
      'Canjea recompensas',
      'Acumula puntos y canjéalos por descuentos, entradas al parque u otros beneficios en la sección "Recompensas".'),
];

class _FaqData {
  final String question;
  final String answer;
  const _FaqData(this.question, this.answer);
}

const _faqs = [
  _FaqData(
    '¿Cuántas veces puedo escanear el mismo producto?',
    'Puedes escanearlo cada vez que lo deposites en el contenedor correcto. No hay límite diario, ¡recicla más y gana más!',
  ),
  _FaqData(
    '¿Los puntos vencen?',
    'No. Los puntos acumulados no tienen fecha de caducidad, permanecen en tu cuenta hasta que los uses.',
  ),
  _FaqData(
    '¿El escáner funciona sin internet?',
    'El escáner necesita conexión para registrar el escaneo en el servidor. Si no hay conexión, la app guarda el resultado en modo demo localmente.',
  ),
  _FaqData(
    '¿Qué pasa si el código no se reconoce?',
    'El producto puede no estar en nuestra base de datos aún. En ese caso el escaneo no sumará puntos, pero lo registramos para agregarlo pronto.',
  ),
  _FaqData(
    '¿Cómo uso el cupón canjeado?',
    'Ve a Perfil → "Mis canjes", selecciona el cupón y pulsa "Usar". Muestra el código al personal del parque para activar tu beneficio.',
  ),
];

// ── Widgets ────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final _StepData step;
  const _StepCard(this.step);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Número del paso
          Container(
            width: 64,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: step.color.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Icon(step.icon, color: step.color, size: 26),
                const SizedBox(height: 6),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: step.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${step.number}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Texto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Text(step.description,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WasteTypesGrid extends StatelessWidget {
  const _WasteTypesGrid();

  static const _types = [
    {'icon': Icons.water_drop, 'label': 'Plástico PET', 'pts': '15 pts', 'color': 0xFF2196F3},
    {'icon': Icons.circle,     'label': 'Aluminio',     'pts': '20 pts', 'color': 0xFF9C27B0},
    {'icon': Icons.inbox,      'label': 'Cartón',       'pts': '12 pts', 'color': 0xFF795548},
    {'icon': Icons.article,    'label': 'Papel',        'pts': '8 pts',  'color': 0xFF607D8B},
    {'icon': Icons.wine_bar,   'label': 'Vidrio',       'pts': '18 pts', 'color': 0xFF4CAF50},
    {'icon': Icons.opacity,    'label': 'HDPE',         'pts': '13 pts', 'color': 0xFF00BCD4},
    {'icon': Icons.grass,      'label': 'Orgánico',     'pts': '8–10 pts','color': 0xFF8BC34A},
    {'icon': Icons.block,      'label': 'No reciclable','pts': '5 pts',  'color': 0xFF9E9E9E},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: _types.length,
      itemBuilder: (context, i) {
        final t = _types[i];
        final color = Color(t['color'] as int);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4)
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(t['icon'] as IconData,
                    color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(t['label'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(t['pts'] as String,
                  style: TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard();

  static const _levels = [
    {'icon': '🌱', 'name': 'Semilla',    'pts': '0 pts',      'color': 0xFF8BC34A},
    {'icon': '🌿', 'name': 'Brote',      'pts': '500 pts',    'color': 0xFF4CAF50},
    {'icon': '🌳', 'name': 'Árbol',      'pts': '1,500 pts',  'color': 0xFF2E7D32},
    {'icon': '🌲', 'name': 'Bosque',     'pts': '3,000 pts',  'color': 0xFF1B5E20},
    {'icon': '🌍', 'name': 'Guardián',   'pts': '6,000 pts',  'color': 0xFF004D40},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.darkGreen, AppColors.primaryGreen],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.military_tech,
                    color: Colors.white, size: 22),
                const SizedBox(width: 10),
                const Text('Niveles de reciclador',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),
          ),
          // Niveles
          ...List.generate(_levels.length, (i) {
            final l = _levels[i];
            final color = Color(l['color'] as int);
            final isLast = i == _levels.length - 1;
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                            color: AppColors.divider, width: 0.5)),
              ),
              child: Row(
                children: [
                  Text(l['icon'] as String,
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(l['name'] as String,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: color,
                            fontSize: 14)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(l['pts'] as String,
                        style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _RedeemCard extends StatelessWidget {
  const _RedeemCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _redeemStep(
            Icons.card_giftcard,
            const Color(0xFF7B1FA2),
            'Ir a Recompensas',
            'Desde la barra inferior, pulsa "Recompensas" para ver todos los premios disponibles.',
          ),
          const Divider(height: 20, color: AppColors.divider),
          _redeemStep(
            Icons.touch_app,
            AppColors.primaryGreen,
            'Seleccionar y canjear',
            'Elige el premio que deseas, verifica que tienes suficientes puntos y pulsa "Canjear".',
          ),
          const Divider(height: 20, color: AppColors.divider),
          _redeemStep(
            Icons.confirmation_number_outlined,
            AppColors.amber,
            'Usar tu cupón',
            'Ve a Perfil → "Mis canjes", abre el cupón y muestra el código al personal del parque.',
          ),
        ],
      ),
    );
  }

  Widget _redeemStep(
      IconData icon, Color color, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 3),
              Text(desc,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class _FaqItem extends StatefulWidget {
  final _FaqData faq;
  const _FaqItem(this.faq);

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          childrenPadding:
              const EdgeInsets.fromLTRB(16, 0, 16, 14),
          leading: Icon(
            _expanded
                ? Icons.help
                : Icons.help_outline,
            color: AppColors.primaryGreen,
            size: 20,
          ),
          title: Text(
            widget.faq.question,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
          trailing: Icon(
            _expanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),
          onExpansionChanged: (v) => setState(() => _expanded = v),
          children: [
            Text(
              widget.faq.answer,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
