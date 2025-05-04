import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'doctor_listing_page.dart';
import 'community_and_chat_page.dart';
import 'healthSammary.dart';
class DiabetesDashboardPage extends StatefulWidget {
  const DiabetesDashboardPage({Key? key}) : super(key: key);

  @override
  State<DiabetesDashboardPage> createState() => _DiabetesDashboardPageState();
}

class _DiabetesDashboardPageState extends State<DiabetesDashboardPage> {
  final DateTime _currentDate = DateTime.now();
  int _selectedDayIndex = 4;

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
                      _buildSectionTitle("Today's Health Summary",DiabetesMedicationPage()),
                      _buildHorizontalCards(),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Discover Healthy Meals",DiabetesMedicationPage()),
                      const SizedBox(height: 12),
                      _buildMealImages(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Bottom Navigation Bar
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem('assets/home.png', true, const DiabetesDashboardPage()),
                  _buildNavItem('assets/compass.png', false, const CommunityAndChatPage()),
                  _buildNavItem('assets/stethoscope .png', false, const DoctorListingPage()),
                  _buildNavItem('assets/people.png', false, const CommunityAndChatPage()),
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
                  child: Image.asset('assets/doctor_team.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow.shade200,
                ),
                child: const Icon(Icons.notifications, size: 20, color: Colors.orange),
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
                Text(DateFormat.E().format(day), style: TextStyle(color: i == _selectedDayIndex ? Colors.white : Colors.black)),
                Text(day.day.toString(), style: TextStyle(color: i == _selectedDayIndex ? Colors.white : Colors.black)),
              ],
            ),
          ),
        ),
      );
    }
    return days;
  }

  Widget _buildSectionTitle(String title,Widget targetPage) {
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
            decoration: const BoxDecoration(color: Color(0xFF00C2CB), shape: BoxShape.circle),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF00C2CB))),
        ],
      ),
    )
    );
    
  }

  Widget _buildHorizontalCards() {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, top: 12),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildHealthCard("Today's Blood Sugar Levels", "Normal", 120),
          const SizedBox(width: 16),
          _buildActivityCard(currentSteps: 5000, goalSteps: 10000),
          const SizedBox(width: 16),
        ],
      ),
    ),
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


Widget _buildHealthCard(String titel2, String status, double sugarLavel) {
  // Determine status color
  Color statusColor = Colors.green;
  if (status == "High") {
    statusColor = Colors.red;
  } else if (status == "Low") {
    statusColor = Colors.orange;
  }

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
          titel2,
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
                      '${sugarLavel.toStringAsFixed(0)} mg/dL',
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
              children: const [
                Text(
                  "Time of Last Measurement",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Last checked: 9:30 AM",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Image.asset(
              'assets/mineral-water 1.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Water Intake Tracker",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "You've only had 2 glasses today.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(), // Push the button to the bottom
        const SizedBox(height: 15), // 15px space above the button
        Center(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              "Log a New Reading",
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


Widget _buildActivityCard({required int currentSteps, required int goalSteps}) {
  final double progressPercentage = goalSteps > 0 ? currentSteps / goalSteps : 0;

  final String formattedCurrentSteps = currentSteps.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  final String formattedGoalSteps = goalSteps.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

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
        Row(
          children: [
            Icon(Icons.directions_run, color: Colors.grey),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$formattedCurrentSteps steps", 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Goal: $formattedGoalSteps steps", 
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
              width: 300 * progressPercentage * 0.85,
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.local_fire_department, color: Colors.orange),
            const SizedBox(width: 8),
            Text("${(currentSteps * 0.04).round()} kcal burned", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.fitness_center, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Strength Training", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Last session: 2 days ago", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        const Spacer(), 
        const SizedBox(height: 15),
        Center(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("Track Your Moves"),
          ),
        ),
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


}
