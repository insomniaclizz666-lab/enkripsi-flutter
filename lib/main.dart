import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color paper = Color(0xFFF2EEE3);
const Color ink = Color(0xFF1B1B18);
const Color rust = Color(0xFFB5482A);
const Color muted = Color(0xFF7A7568);

void main() {
  runApp(const SandiApp());
}

class SandiApp extends StatelessWidget {
  const SandiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sandi Caesar',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: paper,
        colorScheme: ColorScheme.fromSeed(seedColor: rust, surface: paper),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: rust,
          selectionColor: Color(0x40B5482A),
        ),
      ),
      home: const SandiPage(),
    );
  }
}

// ---------------------------------------------------------------------------
// Logika sandi Caesar
// ---------------------------------------------------------------------------

String caesar(String text, int key, bool encrypt) {
  final shift = encrypt ? key % 26 : (26 - key % 26) % 26;
  final sb = StringBuffer();
  for (final r in text.runes) {
    if (r >= 65 && r <= 90) {
      sb.writeCharCode((r - 65 + shift) % 26 + 65);
    } else if (r >= 97 && r <= 122) {
      sb.writeCharCode((r - 97 + shift) % 26 + 97);
    } else {
      sb.writeCharCode(r);
    }
  }
  return sb.toString();
}

// ---------------------------------------------------------------------------
// Halaman utama
// ---------------------------------------------------------------------------

class SandiPage extends StatefulWidget {
  const SandiPage({super.key});

  @override
  State<SandiPage> createState() => _SandiPageState();
}

class _SandiPageState extends State<SandiPage> {
  final TextEditingController _input = TextEditingController();

  bool _encrypt = true;
  double _shift = 3;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  String get _result => caesar(_input.text, _shift.round(), _encrypt);

  void _copy(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tersalin ke papan klip'),
        backgroundColor: ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _flip(String value) {
    setState(() {
      _input.text = value;
      _encrypt = !_encrypt;
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sandi Caesar',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: ink,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enkripsi dan dekripsi teks dengan pergeseran huruf.',
                style: TextStyle(fontSize: 14, color: muted),
              ),
              const SizedBox(height: 18),
              Container(height: 2, color: ink),
              const SizedBox(height: 22),

              // Arah proses
              Row(
                children: [
                  Expanded(child: _modeButton('Enkripsi', true)),
                  const SizedBox(width: 10),
                  Expanded(child: _modeButton('Dekripsi', false)),
                ],
              ),
              const SizedBox(height: 26),

              // Teks masukan
              _label(_encrypt ? 'Teks asli' : 'Teks sandi'),
              const SizedBox(height: 8),
              TextField(
                controller: _input,
                onChanged: (_) => setState(() {}),
                minLines: 3,
                maxLines: 6,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15,
                  color: ink,
                ),
                decoration: _boxDecoration('Ketik atau tempel teks di sini'),
              ),
              const SizedBox(height: 26),

              // Kunci pergeseran
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _label('Pergeseran'),
                  const Spacer(),
                  Text(
                    _shift.round().toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: rust,
                      height: 1,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  activeTrackColor: ink,
                  inactiveTrackColor: const Color(0x331B1B18),
                  thumbColor: rust,
                  overlayColor: const Color(0x22B5482A),
                  activeTickMarkColor: Colors.transparent,
                  inactiveTickMarkColor: Colors.transparent,
                ),
                child: Slider(
                  value: _shift,
                  min: 0,
                  max: 25,
                  divisions: 25,
                  onChanged: (v) => setState(() => _shift = v),
                ),
              ),
              const SizedBox(height: 8),
              _alphabetStrip(),
              const SizedBox(height: 26),

              // Hasil
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                color: ink,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (_encrypt ? 'teks sandi' : 'teks asli').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                        color: Color(0x99F2EEE3),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SelectableText(
                      result.isEmpty ? '—' : result,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 17,
                        height: 1.4,
                        color: paper,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      'Salin',
                      result.isEmpty ? null : () => _copy(result),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionButton(
                      'Balikkan',
                      result.isEmpty ? null : () => _flip(result),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- komponen -----------------------------------------------------------

  Widget _alphabetStrip() {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final s = _shift.round();
    final shifted = alphabet.substring(s) + alphabet.substring(0, s);

    Widget row(String letters, Color color, FontWeight weight) {
      return Row(
        children: letters
            .split('')
            .map(
              (c) => Expanded(
                child: Center(
                  child: Text(
                    c,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: weight,
                      color: color,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: ink, width: 1),
        ),
      ),
      child: Column(
        children: [
          row(alphabet, ink, FontWeight.w500),
          const SizedBox(height: 6),
          row(shifted, rust, FontWeight.w700),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 1.4,
        fontWeight: FontWeight.w700,
        color: muted,
      ),
    );
  }

  InputDecoration _boxDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0x887A7568), fontSize: 14),
      contentPadding: const EdgeInsets.all(14),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: ink, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: rust, width: 2),
      ),
    );
  }

  Widget _modeButton(String title, bool value) {
    final selected = _encrypt == value;
    return GestureDetector(
      onTap: () => setState(() => _encrypt = value),
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? ink : Colors.transparent,
          border: Border.all(color: ink, width: 1),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: selected ? paper : ink,
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String title, VoidCallback? onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        disabledForegroundColor: const Color(0x557A7568),
        minimumSize: const Size.fromHeight(46),
        shape: const RoundedRectangleBorder(),
        side: BorderSide(
          color: onTap == null ? const Color(0x337A7568) : ink,
          width: 1,
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
    );
  }
}