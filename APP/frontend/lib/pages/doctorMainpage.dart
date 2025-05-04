import 'package:flutter/material.dart';
import 'package:sugarblood/widgets/appointment_card.dart';
import 'package:sugarblood/widgets/notification_card.dart';
import 'package:sugarblood/widgets/filter_chip.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({Key? key}) : super(key: key);

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF00C6AE),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF00C6AE),
            tabs: const [
              Tab(text: 'Appointments'),
              Tab(text: 'Notifications'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentsTab(),
                _buildNotificationsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFEEEEEE),
              child: Icon(Icons.person, size: 20, color: Colors.black54),
            ),
            const SizedBox(width: 8),
            const Text(
              'Welcome, Dr. Smith!',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Find patients, records, appointments...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text("Today's Schedule", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
       SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0), // Adjust the value as needed
        child: buildFilterChip('All', isSelected: true),
      ),
      buildFilterChip('Today'),
      buildFilterChip('This Week'),
      buildFilterChip('Upcoming'),
      // more chips...
    ],
  ),
),

        const AppointmentCard(
          name: 'John Smith',
          purpose: 'Blood Sugar Check',
          time: '09:30 AM',
          initials: 'JS',
          color: Colors.blue,
        ),
        const AppointmentCard(
          name: 'Emma Wilson',
          purpose: 'Regular Checkup',
          time: '11:00 AM',
          initials: 'EW',
          color: Colors.purple,
        ),
        const AppointmentCard(
          name: 'Robert Johnson',
          purpose: 'Medication Review',
          time: '02:15 PM',
          initials: 'RJ',
          color: Colors.green,
          isHighPriority: true,
        ),
        const AppointmentCard(
          name: 'Anna Thompson',
          purpose: 'Blood Pressure Check',
          time: '03:45 PM',
          initials: 'AT',
          color: Colors.orange,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Schedule New Appointment"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C6AE),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        NotificationCard(
          title: 'Urgent: Blood Sugar Alert',
          message: 'John Smith\'s blood sugar reading is critically high.',
          time: '10 minutes ago',
          isUrgent: true,
        ),
        NotificationCard(
          title: 'Appointment Reminder',
          message: 'You have an appointment with Emma Wilson in 30 minutes.',
          time: '25 minutes ago',
        ),
        NotificationCard(
          title: 'Missed Medication',
          message: 'Robert Johnson missed his evening dose.',
          time: '2 hours ago',
        ),
        NotificationCard(
          title: 'Lab Results Available',
          message: 'New results available for Anna Thompson.',
          time: '4 hours ago',
        ),
        NotificationCard(
          title: 'Patient Message',
          message: 'New message from Michael Brown.',
          time: 'Yesterday',
        ),
      ],
    );
  }
}
