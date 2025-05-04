import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'doctor_listing_page.dart';
import 'community_and_chat_page.dart';
import '../models/blood_sugar_model.dart';
import '../models/medication_model.dart';
import '../services/api_service.dart';

class DiabetesMedicationPage extends StatefulWidget {
  const DiabetesMedicationPage({Key? key}) : super(key: key);

  @override
  _DiabetesMedicationPageState createState() => _DiabetesMedicationPageState();
}

class _DiabetesMedicationPageState extends State<DiabetesMedicationPage> {
  late Future<List<BloodSugarReading>> _bloodSugarFuture;
  late Future<List<Medication>> _medicationsFuture;

  @override
  void initState() {
    super.initState();
    _bloodSugarFuture = ApiService.fetchBloodSugar();
    _medicationsFuture = ApiService.fetchMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Diabetes & Medication Overview',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      // Use Stack to overlay floating nav bar
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 140), // bottom padding for nav bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildActionRow(),
                const SizedBox(height: 12),
                _buildBloodSugarCard(),
                const SizedBox(height: 16),
                _buildMedicationCard(),
              ],
            ),
          ),

          // Floating Bottom Navigation Bar
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: _buildFloatingNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('assets/home.png', true, const DiabetesMedicationPage()),
          _buildNavItem('assets/compass.png', false, const CommunityAndChatPage()),
          _buildNavItem('assets/stethoscope.png', false, const DoctorListingPage()),
          _buildNavItem('assets/people.png', false, const CommunityAndChatPage()),
        ],
      ),
    );
  }

  Widget _buildNavItem(String imagePath, bool isSelected, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade200 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.asset(
          imagePath,
          width: 24,
          height: 24,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          'Log a New Reading',
          backgroundColor: const Color(0xFFDEEAFF),
          textColor: Colors.black87,
          onPressed: () {},
        ),
        const SizedBox(width: 12),
        _buildActionButton(
          'View History',
          backgroundColor: Colors.white,
          textColor: Colors.black87,
          onPressed: () {},
          hasBorder: true,
        ),
      ],
    );
  }

  Widget _buildBloodSugarCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart, size: 18),
              SizedBox(width: 8),
              Text(
                'Blood Sugar Trends',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Blood Sugar Levels Throughout the Day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: FutureBuilder<List<BloodSugarReading>>(
              future: _bloodSugarFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final data = snapshot.data!;
                return LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 10,
                      drawVerticalLine: true,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                            final label = '${date.hour % 12 == 0 ? 12 : date.hour % 12} ${date.hour < 12 ? 'AM' : 'PM'}';
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 10,
                          reservedSize: 35,
                          getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                    ),
                    minY: 0,
                    lineBarsData: [
                      LineChartBarData(
                        spots: data.map((e) => FlSpot(e.date.millisecondsSinceEpoch.toDouble(), e.value)).toList(),
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.1)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Latest Reading:', '112 mg/dL'),
              _buildStat('Highest Level:', '130 mg/dL'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.medication_outlined, size: 18),
              SizedBox(width: 8),
              Text('Medication Tracking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.play_arrow, size: 16, color: Colors.black87),
              SizedBox(width: 4),
              Text('Today\'s Medications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<Medication>>(
            future: _medicationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final meds = snapshot.data!;
              return Table(
                border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(1.5),
                  3: FlexColumnWidth(1.5),
                },
                children: [
                  _buildTableHeader(),
                  ...meds.map((m) => _buildMedicationRow(m.name, m.dose, m.time, m.status)),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.amber.shade100, shape: BoxShape.circle),
                child: const Icon(Icons.access_time, size: 16, color: Colors.amber),
              ),
              const SizedBox(width: 8),
              const Text('Insulin @ 12 PM', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 13, color: Colors.red),
                    children: [
                      TextSpan(text: 'You\'ve missed your 6 PM dose of Saxafringe', style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: child,
      );

  Widget _buildActionButton(
    String text, {
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
    bool hasBorder = false,
  }) =>
      ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: hasBorder ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
          ),
        ),
        child: Text(text),
      );

  Widget _buildStat(String label, String value) => Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(width: 4),
          Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      );

  TableRow _buildTableHeader() => TableRow(
        decoration: BoxDecoration(color: Colors.grey.shade100),
        children: [
          _buildTableCell('Medication', isHeader: true),
          _buildTableCell('Dose', isHeader: true),
          _buildTableCell('Time', isHeader: true),
          _buildTableCell('Status', isHeader: true),
        ],
      );

  TableRow _buildMedicationRow(String med, String dose, String time, String status) {
    Color c = status == 'Taken'
        ? Colors.green
        : (status == 'Missed' ? Colors.red : Colors.orange);
    return TableRow(children: [
      _buildTableCell(med),
      _buildTableCell(dose),
      _buildTableCell(time),
      _buildTableCell(status, textColor: c, fontWeight: FontWeight.w500),
    ]);
  }

  Widget _buildTableCell(String text, {bool isHeader = false, Color textColor = Colors.black87, FontWeight? fontWeight}) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: isHeader ? 12 : 11,
            fontWeight: isHeader || fontWeight != null ? FontWeight.w600 : FontWeight.normal,
            color: textColor,
          ),
        ),
      );
}
