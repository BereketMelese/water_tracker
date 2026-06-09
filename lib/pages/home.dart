import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/data/water_data.dart';
import 'package:water_tracker/model/water_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final amountController = TextEditingController();
  bool isLoading = false;

  Future<void> saveWater(String amountStr, BuildContext parentContext) async {
    if (amountStr.isEmpty) {
      ScaffoldMessenger.of(
        parentContext,
      ).showSnackBar(const SnackBar(content: Text('Please enter an amount')));
      return;
    }

    // Parse double safely
    final double amount = double.tryParse(amountStr) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final waterData = Provider.of<WaterData>(parentContext, listen: false);

      final waterModel = WaterModel(
        amount: amount,
        dateTime: DateTime.now(),
        unit: 'ml',
      );

      await waterData.saveWater(waterModel, parentContext);

      amountController.clear();

      // Show success message using parentContext
      if (mounted) {
        ScaffoldMessenger.of(parentContext).showSnackBar(
          const SnackBar(content: Text('Water added successfully! ✅')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          parentContext,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void addWater() {
    final parentContext = context; // Store parent context before dialog

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Water'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add water to your daily intake'),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount (ml)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              amountController.clear();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final amount = amountController.text.trim();
              Navigator.pop(dialogContext); // Close dialog
              await saveWater(amount, parentContext); // Use parent context
            },
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add map functionality
            },
            icon: const Icon(Icons.map),
          ),
        ],
        title: const Text('Water Tracker'),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: addWater,
      ),
    );
  }
}
