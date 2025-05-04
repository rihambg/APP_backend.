import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../services/community_service.dart';
import '../widgets/group_card.dart';

class GroupsTab extends StatefulWidget {
  const GroupsTab({Key? key}) : super(key: key);

  @override
  State<GroupsTab> createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab> {
  late Future<List<Group>> _groups;
  late Future<List<Group>> _joinedGroups;
  List<Group> _groupList = [];

  @override
  void initState() {
    super.initState();
    _groups = CommunityService.fetchAvailableGroups().then((groups) {
      _groupList = groups;
      return groups;
    });
    _joinedGroups = CommunityService.fetchUserGroups();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
       Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text("+ Create Group"),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          
          const Text("🛠 Filter groups by Language / Diabetes type",style: TextStyle(fontWeight: FontWeight.bold)),
          
        ]),
        const SizedBox(height: 16),
        FutureBuilder<List<Group>>(future: _groups, builder: (ctx, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                final group = snapshot.data![index];
                return GroupCard(
                  group: group,
                  onJoin: () {
                    setState(() {
                      group.isJoined = !group.isJoined;
                    });
                  },
                );
              },
            ),
          );
        }),
        const SizedBox(height: 24),
        const Text("🫂 Your groups", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        FutureBuilder<List<Group>>(future: _joinedGroups, builder: (ctx, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return Column(children: snapshot.data!.map((g) => ListTile(
            title: Text(g.title),
            subtitle: Text('${g.membersCount} Members'),
          )).toList());
        }),
      ]),
    );
  }
}
