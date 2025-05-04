import 'package:flutter/material.dart';
import 'explore_tab.dart';
import 'challenges_tab.dart';
import 'groups_tab.dart';
import '../models/post_model.dart';
import '../services/community_service.dart';

class CommunityAndChatPage extends StatefulWidget {
  const CommunityAndChatPage({super.key});

  @override
  State<CommunityAndChatPage> createState() => _CommunityAndChatPageState();
}

class _CommunityAndChatPageState extends State<CommunityAndChatPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  /// Called when the user submits a new post.
  void _handlePost(String text) {
    final content = text.trim();
    if (content.isEmpty) return;

    // Create a Post with your model's parameters:
    final newPost = Post(
      username: 'You',
      timeAgo: 'Just now',
      content: content,
      comments: 0,
      repliedBy: '',
    );

    CommunityService.addPost(newPost);
    _inputController.clear();
    setState(() {}); // Rebuild to refresh ExploreTab
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildInputBar(),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.blueAccent,
              labelColor: Colors.black,
              tabs: const [
                Tab(text: 'Explore'),
                Tab(text: 'Challenges'),
                Tab(text: 'Groups'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ExploreTab(),
                  ChallengesTab(),
                  GroupsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Community & Chat',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.add), onPressed: () {}),
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.message, color: Colors.white, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/user.png'),
            radius: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _inputController,
              onSubmitted: _handlePost,
              decoration: const InputDecoration(
                hintText: "What's on your mind...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
