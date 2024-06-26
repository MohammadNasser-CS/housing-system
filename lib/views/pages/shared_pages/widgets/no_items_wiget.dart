import 'package:flutter/material.dart';
import 'package:housing_project/Utils/app_color.dart';

class NoItemsWidget extends StatelessWidget {
   final String title;
  final IconData icon;
  const NoItemsWidget({super.key, required this.title,required this.icon});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: size.width * 0.2,
            color: AppColor.grey4,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColor.grey4,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
