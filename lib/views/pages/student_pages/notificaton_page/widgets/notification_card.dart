import 'package:flutter/material.dart';
import 'package:housing_project/Utils/app_color.dart';
import 'package:housing_project/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: AppColor.grey4)),
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.all(8.0),
        tileColor: AppColor.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.senderName,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: AppColor.black),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              notification.content,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(fontWeight: FontWeight.bold, color: AppColor.grey),
            ),
          ],
        ),
        trailing: Text(
          notification.sinceTime,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(fontWeight: FontWeight.bold, color: AppColor.grey),
        ),
        onTap: () {
        },
      ),
    );
  }
}
