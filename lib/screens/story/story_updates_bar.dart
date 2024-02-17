import 'package:foap/components/thumbnail_view.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/story_imports.dart';

class StoryUpdatesBar extends StatelessWidget {
  final List<StoryModel> stories;
  final List<UserModel> liveUsers;

  final VoidCallback addStoryCallback;
  final Function(StoryModel) viewStoryCallback;
  final Function(UserModel) joinLiveUserCallback;

  const StoryUpdatesBar({
    Key? key,
    required this.stories,
    required this.liveUsers,
    required this.addStoryCallback,
    required this.viewStoryCallback,
    required this.joinLiveUserCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: DesignConstants.horizontalPadding,
        right: DesignConstants.horizontalPadding,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: stories.length + liveUsers.length + 1,
      itemBuilder: (BuildContext ctx, int index) {
        if (index == 0) {
          return SizedBox(
            width: 70,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: ThemeIconWidget(
                    ThemeIcon.plus,
                    size: 25,
                    color: AppColorConstants.iconColor,
                  ),
                ).borderWithRadius(
                  value: 2,
                  radius: 20,
                ).ripple(() {
                  addStoryCallback();
                }),
                const SizedBox(
                  height: 5,
                ),
                BodySmallText(
                  addStoryString.tr,
                  weight: TextWeight.medium,
                ),
              ],
            ),
          );
        } else {
          return SizedBox(
            width: 70,
            child: Column(
              children: [
                MediaThumbnailView(
                  borderColor: stories[index - 1].isViewed == true
                      ? AppColorConstants.disabledColor
                      : AppColorConstants.themeColor,
                  media: stories[index - 1].media.last,
                ).ripple(() {
                  viewStoryCallback(stories[index - 1]);
                }),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: BodySmallText(
                    yourStoriesString.tr,
                    maxLines: 1,
                    weight: TextWeight.medium,
                  ).hP4,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}