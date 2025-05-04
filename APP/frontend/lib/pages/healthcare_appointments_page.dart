// lib/pages/healthcare_appointments_page.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HealthcareAppointmentsPage extends StatelessWidget {
  const HealthcareAppointmentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(               // <-- enables scrolling
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTabButtons(),
              const SizedBox(height: 24),
              _buildUpcomingAppointmentsSection(),
              const SizedBox(height: 24),
              _buildPastAppointmentsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Find & Manage Your Healthcare Team',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.notifications, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Search by name, specialty, or location',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              Icon(Icons.tune, color: Colors.grey.shade700),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.blue.shade700, width: 2),
              ),
            ),
            child: const Center(
              child: Text('Explore', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Text('Appointments', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingAppointmentsSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Upcoming Appointments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(children: const [
              Icon(Icons.schedule, size: 20),
              SizedBox(width: 8),
              Text('Appointments Summary', style: TextStyle(fontWeight: FontWeight.w500)),
            ]),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildAppointmentsTable(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('John Doe, would you like to:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildActionButton('Add New Appointment', Icons.add, Colors.green.shade100, Colors.green),
                    const SizedBox(width: 8),
                    _buildActionButton('Reschedule', Icons.calendar_today, Colors.blue.shade100, Colors.blue),
                    const SizedBox(width: 8),
                    _buildActionButton('Cancel', Icons.close, Colors.red.shade100, Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsTable() {
    final headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade700);
    final dataStyle = const TextStyle(fontSize: 12);

    return DataTable(
      columnSpacing: 16,
      headingRowHeight: 40,
      dataRowHeight: 36,
      headingTextStyle: headerStyle,
      dataTextStyle: dataStyle,
      columns: const [
        DataColumn(label: Text('Doctor')),
        DataColumn(label: Text('Department')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Time')),
        DataColumn(label: Text('Status')),
      ],
      rows: [
        _buildAppointmentRow('Dr. Sarah Bennet', 'Endocrinology', '09/12', '10:00 AM', 'Confirmed'),
        _buildAppointmentRow('Dr. Michael Chen', 'Cardiology', '09/15', '2:30 PM', 'Pending'),
        _buildAppointmentRow('Dr. James Wilson', 'Neurology', '09/21', '1:00 PM', 'Confirmed'),
      ],
    );
  }

  DataRow _buildAppointmentRow(String doctor, String dept, String date, String time, String status) {
    Color statusColor = status == 'Confirmed'
        ? Colors.green
        : (status == 'Pending' ? Colors.orange : Colors.red);

    return DataRow(cells: [
      DataCell(Text(doctor)),
      DataCell(Text(dept)),
      DataCell(Text(date)),
      DataCell(Text(time)),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w500, fontSize: 12)),
      )),
    ]);
  }

  Widget _buildActionButton(String text, IconData icon, Color bgColor, Color fgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 16, color: fgColor),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: fgColor, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }

  Widget _buildPastAppointmentsSection() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Text('Past Appointments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_forward),
            ]),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Appointments & Health Progress Trend', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
              SizedBox(height: 200, child: _buildHealthProgressChart()),
              const SizedBox(height: 16),
              const Text('Total Appointments This Year: 8 sessions', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const Text('Most Frequent Doctor: Dr. Sarah Bennet (Endocrinologist)', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(children: [
                const Text('Average Blood Sugar Level Trend: ', style: TextStyle(fontWeight: FontWeight.w500)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
                  child: const Text('Stable', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
                )
              ]),
              const SizedBox(height: 16),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthProgressChart() {
    final appointmentData = [2, 3, 4, 3, 5, 4, 6, 7, 6, 5, 4, 6];
    return LineChart(LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
        getDrawingVerticalLine: (v) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 22, getTitlesWidget: (v, m) {
            const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(months[v.toInt()], style: const TextStyle(color: Colors.black87, fontSize: 10)),
            );
          }),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 24, getTitlesWidget: (v, m) {
            return (v % 2 == 0) ? Text(v.toInt().toString(), style: const TextStyle(color: Colors.blue, fontSize: 10)) : const SizedBox();
          }),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (v, m) {
            return (v % 10 == 0) ? Text(v.toInt().toString(), style: TextStyle(color: Colors.pink.shade300, fontSize: 10)) : const SizedBox();
          }),
        ),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300, width: 1)),
      minX: 0, maxX: 11, minY: 0, maxY: 8,
      lineBarsData: [
        LineChartBarData(
          spots: appointmentData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
          isCurved: false, color: Colors.blue, barWidth: 2, dotData: FlDotData(show: true),
        ),
      ],
    ));
  }
}
