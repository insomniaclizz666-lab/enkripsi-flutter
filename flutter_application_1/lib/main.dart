import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batu Gunting Kertas',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const GamePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum Choice { batu, gunting, kertas }

extension ChoiceExtension on Choice {
  String get emoji {
    switch (this) {
      case Choice.batu:
        return '✊';
      case Choice.gunting:
        return '✌️';
      case Choice.kertas:
        return '✋';
    }
  }

  String get label {
    switch (this) {
      case Choice.batu:
        return 'Batu';
      case Choice.gunting:
        return 'Gunting';
      case Choice.kertas:
        return 'Kertas';
    }
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Choice? _playerChoice;
  Choice? _computerChoice;
  String _resultText = 'Pilih salah satu untuk mulai!';
  Color _resultColor = const Color.fromARGB(221, 231, 224, 224);

  int _winCount = 0;
  int _loseCount = 0;
  int _drawCount = 0;

  final Random _random = Random();

  void _play(Choice player) {
    final computer = Choice.values[_random.nextInt(Choice.values.length)];

    String result;
    Color color;

    if (player == computer) {
      result = 'seri lho ya';
      color = Colors.orange;
      _drawCount++;
    } else if ((player == Choice.batu && computer == Choice.gunting) ||
        (player == Choice.gunting && computer == Choice.kertas) ||
        (player == Choice.kertas && computer == Choice.batu)) {
      result = 'menang jir';
      color = Colors.green;
      _winCount++;
    } else {
      result = 'kalah wok';
      color = Colors.red;
      _loseCount++;
    }

    setState(() {
      _playerChoice = player;
      _computerChoice = computer;
      _resultText = result;
      _resultColor = color;
    });
  }

  void _resetScore() {
    setState(() {
      _winCount = 0;
      _loseCount = 0;
      _drawCount = 0;
      _playerChoice = null;
      _computerChoice = null;
      _resultText = 'Pilih salah satu untuk mulai!';
      _resultColor = Colors.black87;
    });
  }

  Widget _buildChoiceCard(String emoji, String label, {bool big = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.deepPurple.shade100, width: 2),
          ),
          child: Text(emoji, style: TextStyle(fontSize: big ? 64 : 40)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batu Gunting Kertas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Skor',
            onPressed: _resetScore,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Papan Skor
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _scoreItem('Menang', _winCount, Colors.greenAccent),
                    _scoreItem('Seri', _drawCount, Colors.orangeAccent),
                    _scoreItem('Kalah', _loseCount, Colors.redAccent),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Hasil Pertandingan
              if (_playerChoice != null && _computerChoice != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text('Kamu', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        _buildChoiceCard(_playerChoice!.emoji, _playerChoice!.label, big: true),
                      ],
                    ),
                    const Text('VS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Column(
                      children: [
                        const Text('Komputer', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        _buildChoiceCard(_computerChoice!.emoji, _computerChoice!.label, big: true),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ] else
                const Spacer(),

              Text(
                _resultText,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _resultColor,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Tombol Pilihan
              const Text('Pilih senjatamu:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: Choice.values.map((choice) {
                  return GestureDetector(
                    onTap: () => _play(choice),
                    child: _buildChoiceCard(choice.emoji, choice.label),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}