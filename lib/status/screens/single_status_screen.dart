import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/loading_screen.dart';
import 'package:whatsapp_clone/status/status_model.dart';
import 'package:story_view/story_view.dart';

class SingleStatusScreen extends StatefulWidget {
  const SingleStatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);
  final Status status;
  static const routeName = 'single-status-screen';
  @override
  State<SingleStatusScreen> createState() => _SingleStatusScreenState();
}

class _SingleStatusScreenState extends State<SingleStatusScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initPageItems();
  }

  void initPageItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(StoryItem.pageImage(
          url: widget.status.photoUrl[i], controller: controller));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}
