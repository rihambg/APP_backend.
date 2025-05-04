import 'package:flutter/material.dart';

class ChallengeFilter extends StatefulWidget {
  final void Function(String) onCategoryChanged;
  const ChallengeFilter({Key? key, required this.onCategoryChanged}) : super(key: key);

  @override
  _ChallengeFilterState createState() => _ChallengeFilterState();
}

class _ChallengeFilterState extends State<ChallengeFilter> {
  String _selected = 'Activities';
  final _categories = [
    {'name': 'Activities', 'icon': 'assets/activity.png'},
    {'name': 'Food',       'icon': 'assets/food.png'},
    {'name': 'Sleep',      'icon': 'assets/sleep.png'},
    {'name': 'Hydration',  'icon': 'assets/hydration.png'},
    {'name': 'Medication', 'icon': 'assets/medication.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (ctx, i) {
          final c = _categories[i];
          final sel = c['name'] == _selected;
          return GestureDetector(
            onTap: () {
              setState(() => _selected = c['name']!);
              widget.onCategoryChanged(_selected);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: sel ? Colors.black : Colors.white,
                border: Border.all(color: sel ? Colors.black : Colors.grey.shade400),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Image.asset(c['icon']!, width: 16, height: 16, color: sel ? Colors.white : Colors.black),
                  const SizedBox(width: 6),
                  Text(c['name']!, style: TextStyle(color: sel ? Colors.white : Colors.black, fontSize: 13)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}