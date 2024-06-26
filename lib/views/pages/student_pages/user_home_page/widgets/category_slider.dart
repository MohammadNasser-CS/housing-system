import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_project/Utils/app_color.dart';
import 'package:housing_project/controllers/user_home_page_cubit/user_home_cubit.dart';
import 'package:housing_project/models/home_category_model.dart';
import 'package:housing_project/models/houses_models/house_model.dart';

class CategorySlider extends StatefulWidget {
  const CategorySlider({
    super.key,
  });

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  int? selectedCategoryIndex;
  late List<HouseModel> filterdHouses;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);
    final size = MediaQuery.of(context).size;
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      buildWhen: (previous, current) => current is HomePageCategoryChanged,
      builder: (context, state) {
        if (state is HomePageCategoryChanged) {
          return Column(
            children: [
              SizedBox(
                height: size.height * 0.07,
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: 10.0),
                    child: InkWell(
                      onTap: () {
                        if (state.selectedCategoryIndex == null ||
                            state.selectedCategoryIndex != index) {
                          cubit.changeCategory(index);
                        } else {
                          cubit.changeCategory(null);
                        }
                      },
                      child: Container(
                        width: size.width * 0.2,
                        decoration: BoxDecoration(
                          color: state.selectedCategoryIndex == index
                              ? AppColor.orange8
                              : Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border.all(color: AppColor.orange8),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              categories[index].category,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: size.width * 0.03,
                                    color: state.selectedCategoryIndex == index
                                        ? Colors.white
                                        : AppColor.orange8,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              SizedBox(
                height: size.height * 0.07,
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: 10.0),
                    child: InkWell(
                      onTap: () {
                        if (selectedCategoryIndex == null ||
                            selectedCategoryIndex != index) {
                          selectedCategoryIndex = index;
                        } else {
                          selectedCategoryIndex = null;
                          cubit.changeCategory(selectedCategoryIndex);
                        }
                        if (selectedCategoryIndex != null) {
                          cubit.changeCategory(selectedCategoryIndex);
                        }
                      },
                      child: Container(
                        width: size.width * 0.2,
                        decoration: BoxDecoration(
                          color: selectedCategoryIndex == index
                              ? AppColor.orange8
                              : Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border.all(color: AppColor.orange8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              categories[index].category,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: size.width * 0.03,
                                    color: selectedCategoryIndex == index
                                        ? Colors.white
                                        : AppColor.orange8,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
