// lib/pages/doctor_listing_page.dart
import 'package:flutter/material.dart';

class DoctorListingPage extends StatefulWidget {
  const DoctorListingPage({Key? key}) : super(key: key);

  @override
  State<DoctorListingPage> createState() => _DoctorListingPageState();
}

class _DoctorListingPageState extends State<DoctorListingPage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildTabs(),
              _buildDoctorsList(),
              _buildCategoriesSection(),
              _buildFeaturedArticlesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Find & Manage Your Care Team',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.chat, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, specialty, or location…',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTab('Explore', 0),
        _buildTab('Appointments', 1),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _currentTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: isSelected ? Colors.blue : Colors.transparent, width: 2),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Trusted Doctors for You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.arrow_forward, size: 20), onPressed: () {}),
            ],
          ),
        ),
        _buildDoctorCard(
          name: 'Dr. Layla Benhamid',
          specialty: 'Endocrinologist',
          rating: 4.5,
          hospital: 'Argyle Healthcare & Endocrine Center',
          availability: 'New patients welcome in the AM',
          contactNumber: '+123770123456',
          imageUrl: 'assets/images/doctor1.jpg',
        ),
        _buildDoctorCard(
          name: 'Dr. Rami Bonawali',
          specialty: 'Pediatric Endocrinologist',
          rating: 4.8,
          hospital: 'Arcadia Algora',
          availability: 'Fully booked, waitlist available',
          contactNumber: '+123770456544',
          imageUrl: 'assets/images/doctor2.jpg',
        ),
        _buildDoctorCard(
          name: 'Dr. Yasmine Khalid',
          specialty: 'OB/GYN & Diabetes',
          rating: 4.7,
          hospital: 'Bilbia Algeria',
          availability: 'In-network, open slots',
          contactNumber: '+123770123556',
          imageUrl: 'assets/images/doctor3.jpg',
        ),
      ],
    );
  }

  Widget _buildDoctorCard({
    required String name,
    required String specialty,
    required double rating,
    required String hospital,
    required String availability,
    required String contactNumber,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0,1))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageUrl,
              width: 80, height: 80, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80, height: 80, color: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.verified, size:16, color:Colors.blue),
                const SizedBox(width:4),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize:16)),
              ]),
              const SizedBox(height:4),
              Text(specialty, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const SizedBox(height:6),
              Row(children: [
                const Icon(Icons.star, size:14, color:Colors.amber),
                const SizedBox(width:4),
                Text(rating.toString(), style: const TextStyle(fontWeight:FontWeight.bold, fontSize:12)),
              ]),
              const SizedBox(height:6),
              Row(children: [
                Icon(Icons.location_on, size:14, color:Colors.grey.shade600),
                const SizedBox(width:4),
                Expanded(child: Text(hospital, style: TextStyle(color: Colors.grey.shade600, fontSize:12), overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height:6),
              Row(children: [
                Icon(Icons.access_time, size:14, color:Colors.grey.shade600),
                const SizedBox(width:4),
                Expanded(child: Text(availability, style: TextStyle(color: Colors.grey.shade600, fontSize:12), overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height:6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Icon(Icons.phone, size:14, color:Colors.grey.shade600),
                  const SizedBox(width:4),
                  Text(contactNumber, style: TextStyle(color: Colors.grey.shade600, fontSize:12)),
                ]),
               
              ]),
               ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal:12, vertical:6),
                    textStyle: const TextStyle(fontSize:12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Book Appointment'),
                ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal:16, vertical:8),
        child: Text('Articles', style: TextStyle(fontSize:18, fontWeight:FontWeight.bold)),
      ),
      SizedBox(
        height: 100,
        child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal:8), children: [
          _buildCategoryItem(Icons.apple, Colors.green.shade100, Colors.green, 'Nutrition & Diet'),
          _buildCategoryItem(Icons.run_circle, Colors.blue.shade100, Colors.blue, 'Exercise & Fitness'),
          _buildCategoryItem(Icons.medication, Colors.red.shade100, Colors.red, 'Medication & Treatment'),
          _buildCategoryItem(Icons.science, Colors.teal.shade100, Colors.teal, 'Research & Insights'),
          _buildCategoryItem(Icons.favorite, Colors.pink.shade100, Colors.pink, 'Lifestyle & Mental Health'),
          _buildCategoryItem(Icons.pregnant_woman, Colors.purple.shade100, Colors.purple, 'Pregnancy & Parenting'),
        ]),
      ),
    ]);
  }

  Widget _buildCategoryItem(IconData icon, Color bg, Color fg, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal:8, vertical:8),
      child: Column(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, color: fg, size:24)),
        const SizedBox(height:4),
        SizedBox(width:80, child: Text(label, textAlign:TextAlign.center, style: const TextStyle(fontSize:10, fontWeight:FontWeight.w500), maxLines:2, overflow:TextOverflow.ellipsis)),
      ]),
    );
  }

  Widget _buildFeaturedArticlesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal:16, vertical:8),
        child: Text('Featured Articles', style: TextStyle(fontSize:18, fontWeight:FontWeight.bold)),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (_, i) => _buildArticleItem(
          authorName: 'Dr. James Carter',
          authorImageUrl: 'assets/images/doctor4.jpg',
          title: 'Managing Blood Sugar During Pregnancy',
          content: 'A guide to safe blood sugar control during pregnancy…',
        ),
      ),
    ]);
  }

  Widget _buildArticleItem({required String authorName, required String authorImageUrl, required String title, required String content}) {
    return ExpansionTile(
      leading: CircleAvatar(backgroundImage: AssetImage(authorImageUrl), radius:20),
      title: Text(authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize:14)),
      subtitle: Text(title, style: const TextStyle(fontSize:16)),
      children: [
        Padding(padding: const EdgeInsets.all(16), child: Text(content, style: const TextStyle(fontSize:14))),
        ButtonBar(children: [
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.comment_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ]),
      ],
    );
  }
}
