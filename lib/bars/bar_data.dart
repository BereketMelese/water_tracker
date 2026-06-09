import 'package:water_tracker/bars/individual_bar.dart';

class BarData {
  final double sunWaterAmt;
  final double monWaterAmt;
  final double tueWaterAmt;
  final double wedWaterAmt;
  final double thurWaterAmt;
  final double friWaterAmt;
  final double satWaterAmt;

  BarData({
    required this.sunWaterAmt,
    required this.monWaterAmt,
    required this.tueWaterAmt,
    required this.wedWaterAmt,
    required this.thurWaterAmt,
    required this.friWaterAmt,
    required this.satWaterAmt,
  });

  List<IndividualBar> barData = [];

  void initBarData() {
    barData = [
      IndividualBar(x: 0, y: sunWaterAmt),
      IndividualBar(x: 0, y: monWaterAmt),
      IndividualBar(x: 0, y: tueWaterAmt),
      IndividualBar(x: 0, y: wedWaterAmt),
      IndividualBar(x: 0, y: thurWaterAmt),
      IndividualBar(x: 0, y: friWaterAmt),
      IndividualBar(x: 0, y: satWaterAmt),
    ];
  }
}
