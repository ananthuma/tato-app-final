import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

class LocationChatTile extends StatelessWidget {
  final ChatMessageModel message;

  LocationChatTile({Key? key, required this.message}) : super(key: key);
  SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    var controller = StaticMapController(
      googleApiKey: settingsController.setting.value!.googleMapApiKey!,
      width: 400,
      height: 400,
      zoom: 15,
      center: Location(message.mediaContent.location!.latitude,
          message.mediaContent.location!.longitude),
    );
    ImageProvider image = controller.image;

    return Image(image: image).round(10);
  }
}
