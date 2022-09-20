import 'package:foap/helper/common_import.dart';

Widget emptyPost({required String title, required String subTitle, required BuildContext context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/nopost.png', height: 150,),
      const SizedBox(
        height: 20,
      ),
      Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        subTitle,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ],
  );
}

Widget emptyUser({required String title, required String subTitle, required BuildContext context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/nouser.png', height: 150,),
      const SizedBox(
        height: 20,
      ),
      Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        subTitle,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ],
  );
}

Widget emptyData({required String title, required String subTitle, required BuildContext context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/nodata.png', height: 150,),
      const SizedBox(
        height: 20,
      ),
      Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        subTitle,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ],
  );
}
