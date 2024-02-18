import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/story_model.dart';
import '../../screens/story/story_viewer.dart';

class StoryMediaGridView extends StatelessWidget {
  final List<StoryModel> stories;

  const StoryMediaGridView({Key? key, required this.stories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Media Stories'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Adjust the number of columns as per your preference
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _totalMediaCount(),
        itemBuilder: (BuildContext context, int index) {
          final storyIndex = _storyIndexForMediaIndex(index);
          final mediaIndex = _mediaIndexWithinStory(index);
          final mediaUrl = stories[storyIndex].media[mediaIndex].image; // Assuming url is the property that holds the media URL
          final cStory = stories[storyIndex];
          return GestureDetector(
            onTap: () {
              Get.to(() => StoryViewer(
                story: cStory,
                storyDeleted: () {
                  // do something
                },
                startFromIndex:mediaIndex,
              ));
            },
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Image.network(
                  mediaUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  int _totalMediaCount() {
    return stories.fold<int>(0, (total, story) => total + story.media.length);
  }

  int _storyIndexForMediaIndex(int mediaIndex) {
    int currentIndex = 0;
    for (int i = 0; i < stories.length; i++) {
      final storyMediaCount = stories[i].media.length;
      if (mediaIndex >= currentIndex && mediaIndex < currentIndex + storyMediaCount) {
        return i;
      }
      currentIndex += storyMediaCount;
    }
    throw Exception('Invalid media index');
  }

  int _mediaIndexWithinStory(int mediaIndex) {
    int currentIndex = 0;
    for (int i = 0; i < stories.length; i++) {
      final storyMediaCount = stories[i].media.length;
      if (mediaIndex >= currentIndex && mediaIndex < currentIndex + storyMediaCount) {
        return mediaIndex - currentIndex;
      }
      currentIndex += storyMediaCount;
    }
    throw Exception('Invalid media index');
  }
}

