import 'package:flutter/material.dart';
import 'package:foap/components/thumbnail_view.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/story_imports.dart';

class UserStoryDisplayBar extends StatelessWidget {
  final List<StoryModel> stories;
  final Function(StoryModel, int) viewStoryCallback;

  const UserStoryDisplayBar({
    Key? key,
    required this.stories,
    required this.viewStoryCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Stories length: ${stories.length}');
    return Expanded(
      child: SizedBox(
        height: 1000, // Adjust height as needed
        child: ListView.builder(
          padding: EdgeInsets.only(
            left: DesignConstants.horizontalPadding,
            right: DesignConstants.horizontalPadding,
          ),
          itemCount: stories.length,
          itemBuilder: (BuildContext ctx, int index) {
            print('ItemBuilder index: $index');
            if (stories.isEmpty) {
              print('No stories available.');
              return Container(); // Return an empty container if stories list is empty
            }
            StoryModel story = stories[index];
            print('Story details: $story');
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Add vertical padding here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display user name above the media thumbnail views
                  BodySmallText(
                    story.userName,
                    maxLines: 1,
                    weight: TextWeight.medium,
                  ).hP4,
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: story.media.asMap().entries.map((entry) {
                              final index = entry.key;
                              final media = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: MediaThumbnailView(
                                  borderColor: story.isViewed == true
                                      ? AppColorConstants.disabledColor
                                      : AppColorConstants.themeColor,
                                  media: media,
                                ).ripple(() {
                                  viewStoryCallback(story, index);
                                }),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }



}

