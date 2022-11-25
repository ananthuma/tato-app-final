import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class ClubsController extends GetxController {
  RxList<ClubModel> clubs = <ClubModel>[].obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<ClubMemberModel> members = <ClubMemberModel>[].obs;

  RxBool isLoadingCategories = false.obs;

  int clubsPage = 1;
  bool canLoadMoreClubs = true;
  RxBool isLoadingClubs = false.obs;

  int membersPage = 1;
  bool canLoadMoreMembers = true;
  bool isLoadingMembers = false;

  RxInt segmentIndex = (-1).obs;

  clear() {
    isLoadingClubs.value = false;
    clubs.value = [];
    clubsPage = 1;
    canLoadMoreClubs = true;
  }

  clearMembers() {
    isLoadingMembers = false;
    members.value = [];
    membersPage = 1;
    canLoadMoreMembers = true;
  }

  selectedSegmentIndex(int index) {
    if(isLoadingClubs.value == true){
      return;
    }
    update();

    if (index == 0 && segmentIndex.value != index) {
      clear();
      getClubs();
    } else if (index == 1 && segmentIndex.value != index) {
      clear();
      getClubs(isJoined: 1);
    } else if (index == 2 && segmentIndex.value != index) {
      clear();
      getClubs(userId: getIt<UserProfileManager>().user!.id);
    }

    segmentIndex.value = index;
  }

  getClubs({String? name, int? categoryId, int? userId, int? isJoined}) {
    if (canLoadMoreClubs) {
      isLoadingClubs.value = true;
      ApiController()
          .getClubs(
              name: name,
              categoryId: categoryId,
              userId: userId,
              isJoined: isJoined,
              page: clubsPage)
          .then((response) {
        clubs.addAll(response.clubs);
        isLoadingClubs.value = false;

        clubsPage += 1;
        if (response.clubs.length == response.metaData?.perPage) {
          canLoadMoreClubs = true;
        } else {
          canLoadMoreClubs = false;
        }
        update();
      });
    }
  }

  clubDeleted(ClubModel club){
    clubs.removeWhere((element) => element.id == club.id);
    clubs.refresh();
  }

  getMembers({int? clubId}) {
    if (canLoadMoreMembers) {
      isLoadingMembers = true;
      ApiController()
          .getClubMembers(clubId: clubId, page: membersPage)
          .then((response) {
        members.addAll(response.clubMembers);
        isLoadingMembers = false;

        membersPage += 1;
        if (response.clubMembers.length == response.metaData?.perPage) {
          canLoadMoreMembers = true;
        } else {
          canLoadMoreMembers = false;
        }
        update();
      });
    }
  }

  getCategories() {
    isLoadingCategories.value = true;
    ApiController().getClubCategories().then((response) {
      categories.value = response.categories;
      isLoadingCategories.value = false;

      update();
    });
  }

  joinClub(ClubModel club) {
    clubs.value = clubs.map((element) {
      if (element.id == club.id) {
        element.isJoined = true;
      }
      return element;
    }).toList();

    clubs.refresh();
    ApiController().joinClub(clubId: club.id!).then((response) {});
  }

  leaveClub(ClubModel club) {
    clubs.value = clubs.map((element) {
      if (element.id == club.id) {
        element.isJoined = false;
      }
      return element;
    }).toList();

    clubs.refresh();
    ApiController().leaveClub(clubId: club.id!).then((response) {});
  }

  removeMemberFromClub(ClubModel club, ClubMemberModel member) {
    members.remove(member);
    update();

    ApiController()
        .removeMemberFromClub(clubId: club.id!, userId: member.id)
        .then((response) {});
  }

  deleteClub({required ClubModel club, required VoidCallback callback}) {
    EasyLoading.show(status: LocalizationString.loading);

    ApiController()
        .deleteClub(
      club.id!,
    )
        .then((response) {
      EasyLoading.dismiss();
      Get.back();
      callback();
    });
  }
}