import 'package:flutter/material.dart';
import 'package:housing_project/Utils/app_color.dart';
import 'package:housing_project/models/house_model.dart';
import 'package:housing_project/views/widgets/text_widget.dart';
import 'package:readmore/readmore.dart';

class HouseDescriptionSection extends StatelessWidget {
  final HouseModel house;
  const HouseDescriptionSection({
    super.key,
    required this.house,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المواصفات',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Container(
          decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColor.grey4)),
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سعر الغرفة يشمل:',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextWidget(
                      title: 'خدمة الكهرباء:',
                      value: house.electricityServiceIncluded ? ' نعم' : ' لا'),
                  TextWidget(
                    title: 'خدمة الماء:',
                    value: house.waterServiceIncluded ? ' نعم' : ' لا',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextWidget(
                      title: 'خدمة الغاز:',
                      value: house.gazServiceIncluded ? ' نعم' : ' لا'),
                  TextWidget(
                    title: 'خدمة الإنترنت:',
                    value: house.internetServiceIncluded ? ' نعم' : ' لا',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.015),
        Text(
          'الوصف',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Container(
          decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColor.grey4)),
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 12.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadMoreText(
                  colorClickableText: AppColor.orange8,
                  trimCollapsedText: 'المزيد',
                  trimExpandedText: 'أقل',
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  house.description,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColor.grey,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
