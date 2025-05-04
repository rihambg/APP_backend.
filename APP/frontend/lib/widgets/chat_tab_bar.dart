import 'package:flutter/material.dart';

class ChatTabBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTab;
  const ChatTabBar({required this.selected, required this.onTab, Key? key}) : super(key: key);

  @override Widget build(BuildContext c) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(25)),
      child: Row(children: [
        _tab('Explore', 0),
        _tab('Challenges', 1),
        _tab('Groups', 2),
      ]),
    );
  }
  Widget _tab(String t, int i) => Expanded(
    child: GestureDetector(
      onTap: () => onTab(i),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical:12),
        decoration: BoxDecoration(
          color: selected==i ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(child: Text(t, style: TextStyle(color: selected==i?Colors.black:Colors.grey, fontWeight: selected==i?FontWeight.bold:null))),
      ),
    ),
  );
}