import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const BillSplitterApp());

class BillSplitterApp extends StatelessWidget {
  const BillSplitterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bill Splitter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const BillSplitterPage(),
    );
  }
}

class BillSplitterPage extends StatefulWidget {
  const BillSplitterPage({super.key});

  @override
  State<BillSplitterPage> createState() => _BillSplitterPageState();
}

class _BillSplitterPageState extends State<BillSplitterPage> {
  static const Color _blue = Color(0xFF2196F3);

  final TextEditingController _billController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();

  double _tipPercent = 10;
  bool _calculated = false;
  double _tipAmount = 0;
  double _totalAmount = 0;
  double _perPerson = 0;

  @override
  void dispose() {
    _billController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  void _calculate() {
    FocusScope.of(context).unfocus();

    final double? bill = double.tryParse(_billController.text.trim());
    final int? people = int.tryParse(_peopleController.text.trim());

    if (bill == null || bill <= 0) {
      _showMessage('Please enter a valid bill amount');
      return;
    }
    if (people == null || people <= 0) {
      _showMessage('Please enter a valid number of people');
      return;
    }

    setState(() {
      _tipAmount = bill * _tipPercent / 100;
      _totalAmount = bill + _tipAmount;
      _perPerson = _totalAmount / people;
      _calculated = true;
    });
  }

  void _reset() {
    FocusScope.of(context).unfocus();
    setState(() {
      _billController.clear();
      _peopleController.clear();
      _tipPercent = 10;
      _calculated = false;
      _tipAmount = 0;
      _totalAmount = 0;
      _perPerson = 0;
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bill Splitter',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Split your bill easily',
                style: TextStyle(fontSize: 28, color: Color(0xFF1C1B1F)),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter the bill details below',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Total bill amount
              TextField(
                controller: _billController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Total Bill Amount',
                  prefixIcon: const Icon(Icons.receipt_long),
                  prefixText: '₹ ',
                  border: border,
                ),
              ),
              const SizedBox(height: 16),

              // Number of people
              TextField(
                controller: _peopleController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Number of People',
                  prefixIcon: const Icon(Icons.groups),
                  border: border,
                ),
              ),
              const SizedBox(height: 24),

              // Tip slider
              const Text(
                'Tip Percentage',
                style: TextStyle(fontSize: 20, color: Color(0xFF1C1B1F)),
              ),
              Slider(
                value: _tipPercent,
                min: 0,
                max: 30,
                divisions: 6,
                onChanged: (value) => setState(() => _tipPercent = value),
              ),
              Center(
                child: Text(
                  '${_tipPercent.toInt()}% Tip',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _blue,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Calculate button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Calculate Bill',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bill summary
              if (_calculated) ...[
                _buildSummaryCard(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Reset', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Bill Summary',
              style: TextStyle(fontSize: 22, color: Color(0xFF1C1B1F)),
            ),
            const SizedBox(height: 16),
            _summaryRow('Tip Amount', '₹ ${_tipAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            _summaryRow('Total Amount', '₹ ${_totalAmount.toStringAsFixed(2)}'),
            const Divider(height: 28),
            const Text(
              'Amount Per Person',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              '₹ ${_perPerson.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: _blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
