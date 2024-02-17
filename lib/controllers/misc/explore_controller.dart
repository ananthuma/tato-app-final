import 'package:foap/controllers/misc/users_controller.dart';
import 'package:foap/controllers/post/post_controller.dart';
import 'package:foap/helper/list_extension.dart';
import 'package:get/get.dart';
import '../../apiHandler/apis/story_api.dart';
import '../../helper/user_profile_manager.dart';
import '../../manager/db_manager.dart';
import '../../manager/service_locator.dart';
import '../../model/location.dart';
import '../../model/post_search_query.dart';
import '../../model/story_model.dart';
import '../../util/app_util.dart';
import '../clubs/clubs_controller.dart';
import 'misc_controller.dart';

class ExploreController extends GetxController {
  final PostController _postController = Get.find();
  final UsersController _usersController = Get.find();
  final MiscController _miscController = Get.find();
  final ClubsController _clubsController = Get.find();
  final UserProfileManager _userProfileManager = Get.find();

  RxList<StoryModel> stories = <StoryModel>[].obs;
  RxList<LocationModel> locations = <LocationModel>[].obs;

  bool isSearching = false;
  RxString searchText = ''.obs;
  int selectedSegment = 0;

  clear() {
    stories.clear();
    isSearching = false;
    searchText.value = '';
    selectedSegment = 0;
  }

  startSearch() {
    update();
  }

  closeSearch() {
    clear();
    _postController.clear();
    searchText.value = '';
    selectedSegment = 0;
    update();
  }

  searchTextChanged(String text) {
    clear();
    searchText.value = text;
    _postController.clear();
    searchData();
  }

  searchData() {
    if (searchText.isNotEmpty) {
      PostSearchQuery query = PostSearchQuery();
      query.title = searchText.value;
      _postController.setPostSearchQuery(query: query, callback: () {});
      _usersController.setSearchTextFilter(searchText.value);
      _miscController.searchHashTags(searchText.value);
      _clubsController.setSearchText(searchText.value);
    } else {
      closeSearch();
    }
  }

  segmentChanged(int index) {
    selectedSegment = index;
    searchData();
    update();
  }
  Future<List<StoryModel>> getFollowersStories() async {
    List<StoryModel> followersStories = [];
    List<StoryModel> viewedAllStories = [];
    List<StoryModel> notViewedStories = [];

    List<int> viewedStoryIds = await getIt<DBManager>().getAllViewedStories();

    await StoryApi.getStories(resultCallback: (result) {
      for (var story in result) {
        var allMedias = story.media;
        var notViewedStoryMedias = allMedias
            .where((element) => viewedStoryIds.contains(element.id) == false);

        if (notViewedStoryMedias.isEmpty) {
          story.isViewed = true;
          viewedAllStories.add(story);
        } else {
          notViewedStories.add(story);
        }
      }
    });

    followersStories.addAll(notViewedStories);
    followersStories.addAll(viewedAllStories);
    followersStories.unique((e) => e.id);

    return followersStories;
  }
  void getStories() async {
    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        var responses = await Future.wait([
          getFollowersStories(),
        ]).whenComplete(() {});
        stories.clear();

        StoryModel story = StoryModel(
            id: 1,
            name: '',
            userName: _userProfileManager.user.value!.userName,
            email: '',
            image: _userProfileManager.user.value!.picture,
            media: responses[0] as List<StoryMediaModel>);
        print("ami getting stories from explore controller");
        stories.add(story);
        stories.addAll(responses[1] as List<StoryModel>);
        stories.unique((e) => e.id);
        int val = stories.length;
      }
      update();
    });
  }
}
