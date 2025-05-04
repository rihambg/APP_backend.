import 'package:flutter/material.dart';
import '../models/challenge_model.dart';
import '../services/community_service.dart';
import '../widgets/challenge_card.dart';
import '../widgets/challenge_filter.dart';

class ChallengesTab extends StatefulWidget {
  const ChallengesTab({Key? key}) : super(key: key);
  @override
  _ChallengesTabState createState() => _ChallengesTabState();
}

class _ChallengesTabState extends State<ChallengesTab> {
  late Future<List<Challenge>> _allChallenges;
  List<Challenge> _filtered = [];
  String _category = 'Activities';

  @override
  void initState() {
    super.initState();
    _allChallenges = CommunityService.fetchChallenges();
    _allChallenges.then((list) {
      setState(() => _filtered = _filterByCategory(list, _category));
    });
  }

  List<Challenge> _filterByCategory(List<Challenge> list, String cat) {
    return list.where((c) => c.category == cat).toList();
  }

  void _onCategoryChanged(String newCat) {
    setState(() => _category = newCat);
    _allChallenges.then((all) {
      setState(() => _filtered = _filterByCategory(all, newCat));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('What kind of challenge are you interested in?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          ChallengeFilter(onCategoryChanged: _onCategoryChanged),
          const SizedBox(height: 24),

          const Text('🏁 Join a Community Goal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          if (_filtered.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) => ChallengeCard(challenge: _filtered[i]),
              ),
            ),

          const SizedBox(height: 24),
          const Text('🥗 Challenges by Nutritionists', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          // You could repeat the same filtered list or filter by a fixed "Nutritionists" category
        ],
      ),
    );
  }
}