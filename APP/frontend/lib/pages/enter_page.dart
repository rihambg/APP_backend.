import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sugarblood/models/blood_sugar_model.dart';
import 'package:sugarblood/pages/healthSammary.dart';
import 'package:sugarblood/pages/healthSammary.dart';
import 'package:sugarblood/services/api_service.dart';

class DiabetesDashboardPage extends StatefulWidget {
  const DiabetesDashboardPage({Key? key}) : super(key: key);

  @override
  State<DiabetesDashboardPage> createState() => _DiabetesDashboardPageState();
}

class _DiabetesDashboardPageState extends State<DiabetesDashboardPage> {
  late Future<List<BloodSugarReading>> _bloodSugarFuture;
  late Future<Map<String, dynamic>> _patientDetailsFuture;
  final DateTime _currentDate = DateTime.now();
  int _selectedDayIndex = 4;

  @override
  void initState() {
    super.initState();
    _bloodSugarFuture = ApiService.fetchBloodSugar();
    _patientDetailsFuture = ApiService.fetchPatientDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100, top: 16),
                    children: [
                      _buildHeader(),
                      _buildSearchBar(),
                      _buildWeekCalendar(),
                      const SizedBox(height: 12),
                      _buildSectionTitle("Today's Health Summary",
                          const DiabetesMedicationPage()),
                      _buildHorizontalCards(),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Discover Healthy Meals",
                          const DiabetesMedicationPage()),
                      const SizedBox(height: 12),
                      _buildMealImages(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: Container(
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
                  _buildNavItem(
                      'assets/home.png', true, const DiabetesDashboardPage()),
                  _buildNavItem('assets/compass.png', false,
                      const CommunityAndChatPage()),
                  _buildNavItem('assets/stethoscope.png', false,
                      const DoctorListingPage()),
                  _buildNavItem(
                      'assets/people.png', false, const CommunityAndChatPage()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: ClipOval(
                  child:
                      Image.asset('assets/doctor_team.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow.shade200,
                ),
                child: const Icon(Icons.notifications,
                    size: 20, color: Colors.orange),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'Welcome, John Doe !',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Find records, doctors, advice...',
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildWeekCalendar() {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _buildWeekDays(),
            ),
          ),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
        ],
      ),
    );
  }

  List<Widget> _buildWeekDays() {
    List<Widget> days = [];
    DateTime start = _currentDate.subtract(Duration(days: _selectedDayIndex));
    for (int i = 0; i < 7; i++) {
      DateTime day = start.add(Duration(days: i));
      days.add(
        GestureDetector(
          onTap: () => setState(() => _selectedDayIndex = i),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: i == _selectedDayIndex ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat.E().format(day),
                  style: TextStyle(
                      color:
                          i == _selectedDayIndex ? Colors.white : Colors.black),
                ),
                Text(
                  day.day.toString(),
                  style: TextStyle(
                      color:
                          i == _selectedDayIndex ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return days;
  }

  Widget _buildSectionTitle(String title, Widget targetPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Container(
              width: 25,
              height: 20,
              decoration: const BoxDecoration(
                  color: Color(0xFF00C2CB), shape: BoxShape.circle),
              child:
                  const Icon(Icons.play_arrow, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00C2CB))),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalCards() {
    return FutureBuilder(
      future: Future.wait([_bloodSugarFuture, _patientDetailsFuture]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final bloodSugarReadings = snapshot.data![0] as List<BloodSugarReading>;
        final patientDetails = snapshot.data![1] as Map<String, dynamic>;
        final diabetesType = patientDetails['diabetes_type'] ?? 'Unknown';

        Map<String, dynamic> targetRanges = {
          'type1': {'min': 80, 'max': 130, 'postprandialMax': 180},
          'type2': {'min': 80, 'max': 130, 'postprandialMax': 180},
          'prediabetes': {'min': 70, 'max': 130, 'postprandialMax': 140},
          'gestational': {'min': 70, 'max': 95, 'postprandialMax': 140},
          'Unknown': {'min': 70, 'max': 140, 'postprandialMax': 180},
        };

        final range = targetRanges[diabetesType] ?? targetRanges['Unknown'];
        final latestReadings = bloodSugarReadings.take(3).toList();
        final latestReading = latestReadings.isNotEmpty
            ? latestReadings.first.value.toDouble()
            : 0.0;

        String status = 'Normal';
        Color statusColor = Colors.green;
        if (latestReading < range['min']) {
          status = 'Low';
          statusColor = Colors.orange;
        } else if (latestReading > range['max']) {
          status = 'High';
          statusColor = Colors.red;
        }

        return Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildHealthCard(
                  "Today's Blood Sugar Levels",
                  status,
                  latestReading,
                  statusColor,
                  latestReadings,
                  range,
                ),
                const SizedBox(width: 16),
                _buildActivityCard(),
                const SizedBox(width: 16),
                _buildMedicationCard(),
                const SizedBox(width: 16),
                _buildMealCard(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthCard(
    String title,
    String status,
    double sugarLevel,
    Color statusColor,
    List<BloodSugarReading> latestReadings,
    Map<String, dynamic> range,
  ) {
    return Container(
      width: 300,
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Image.asset(
                'assets/Frame 26.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Blood Sugar Level",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${sugarLevel.toStringAsFixed(0)} mg/dL',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'status: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Image.asset(
                'assets/clock 1.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Target Range",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${range['min']}-${range['max']} mg/dL",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: latestReadings
                  .map((reading) => ListTile(
                        leading: Icon(
                          reading.value < range['min']
                              ? Icons.arrow_downward
                              : reading.value > range['max']
                                  ? Icons.arrow_upward
                                  : Icons.check,
                          color: reading.value < range['min']
                              ? Colors.orange
                              : reading.value > range['max']
                                  ? Colors.red
                                  : Colors.green,
                        ),
                        title: Text('${reading.value} mg/dL'),
                        subtitle: Text(
                            DateFormat('MMM d, HH:mm').format(reading.date)),
                      ))
                  .toList(),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DiabetesMedicationPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "View Detailed Trends",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard() {
    return Container(
      width: 300,
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Activity Snapshot",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.directions_run, color: Colors.grey),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("0 steps",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Goal: 10,000 steps",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 8,
                width: 300 * 0.5 * 0.85,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.local_fire_department, color: Colors.orange),
              SizedBox(width: 8),
              Text("0 kcal burned",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.grey),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("No workout today",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Last session: 2 days ago",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(height: 15),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DiabetesMedicationPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Track Your Activity"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationCard() {
    return Container(
      width: 300,
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Medication Tracker",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.medical_services, color: Colors.grey),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("No medications due",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Next dose: None",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  const Text(
                    "No medications scheduled",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DiabetesMedicationPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Manage Medications"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard() {
    return Container(
      width: 300,
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Meals",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 8),
                const Text(
                  "No meals logged yet",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMealTime('Breakfast', Icons.breakfast_dining),
              _buildMealTime('Lunch', Icons.lunch_dining),
              _buildMealTime('Dinner', Icons.dinner_dining),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DiabetesMedicationPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("Log Your Meals"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTime(String time, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMealImages() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildMealImage('assets/plat_1.jpg'),
            const SizedBox(width: 8),
            _buildMealImage('assets/plat_2.jpg'),
            const SizedBox(width: 8),
            _buildMealImage('assets/plat_3.jpg'),
            const SizedBox(width: 8),
            _buildMealImage('assets/plat_4.jpg'),
            const SizedBox(width: 8),
            _buildMealImage('assets/plat_5.jpg'),
          ],
        ),
      ),
    );
  }

  Widget _buildMealImage(String assetPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        assetPath,
        height: 200,
        width: 240,
        fit: BoxFit.cover,
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
}

class CommunityAndChatPage extends StatelessWidget {
  const CommunityAndChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: const Center(child: Text('Community Page')),
    );
  }
}

class DoctorListingPage extends StatelessWidget {
  const DoctorListingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctors')),
      body: const Center(child: Text('Doctors Page')),
    );
  }
}
