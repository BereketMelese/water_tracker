import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:water_tracker/model/water_model.dart';

class WaterData extends ChangeNotifier {
  List<WaterModel> waterDataList = [];
  bool isLoading = false;

  Future<void> saveWater(WaterModel water, BuildContext context) async {
    if (water.amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final baseUrl = dotenv.env['backUrl'];

    if (baseUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuration error: API URL missing')),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      String firebaseUrl = baseUrl.startsWith('http://')
          ? baseUrl
          : 'https://$baseUrl';

      final url = Uri.parse('$firebaseUrl/water.json');

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(water.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        waterDataList.add(water);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
