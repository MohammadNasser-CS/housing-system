import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_project/Utils/app_color.dart';
import 'package:housing_project/controllers/calender_select_cubit/calender_select_cubit.dart';
import 'package:housing_project/controllers/owner_home_page_cubit/owner_home_page_cubit.dart';
import 'package:housing_project/models/owner_free_date_time_model.dart';
import 'package:housing_project/views/pages/owner_pages/owner_home_page/widgets/search_section_widgets/date_time_dialog.dart';

class OwnerHomePageSearchSectionSearchSection extends StatefulWidget {
  const OwnerHomePageSearchSectionSearchSection({super.key});

  @override
  State<OwnerHomePageSearchSectionSearchSection> createState() =>
      _OwnerHomePageSearchSectionSearchSectionState();
}

class _OwnerHomePageSearchSectionSearchSectionState
    extends State<OwnerHomePageSearchSectionSearchSection>
    with SingleTickerProviderStateMixin {
  // late final GlobalKey<FormState> _formKey;
  late final TextEditingController _searchController;
  AnimationController? _animationController;
  String? onwerName, password;
  late FocusNode _searchFocusNode;
  bool visibility = false;
  @override
  void initState() {
    // _formKey = GlobalKey<FormState>();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _animationController = BottomSheet.createAnimationController(this);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<OwnerHomePageCubit>(context);
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 6,
          child: TextFormField(
            textAlign: TextAlign.right,
            controller: _searchController,
            focusNode: _searchFocusNode,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onEditingComplete: () async {
              _searchFocusNode.unfocus();
              if (_searchController.text.isNotEmpty) {
                await cubit.searchFilled(_searchController.text);
              } else {
                await cubit.getHomeData();
              }
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsetsDirectional.all(size.width * 0.03),
              hintText: 'رقم العقار...',
              prefixIcon: const Icon(Icons.search_outlined),
              prefixIconColor: AppColor.grey,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.03),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useRootNavigator: true,
              useSafeArea: true,
              showDragHandle: true,
              enableDrag: true,
              builder: (BuildContext context) {
                return BottomSheet(
                  backgroundColor: AppColor.grey1,
                  onClosing: () {},
                  animationController: _animationController,
                  builder: (context) => StatefulBuilder(
                    builder: (context, setState) => BlocProvider.value(
                      value: cubit,
                      child: BlocProvider(
                        create: (context) => CalenderSelectCubit(),
                        child: Container(
                            height: size.height * 0.55,
                            decoration: BoxDecoration(
                              color: AppColor.grey1,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24.0),
                                topRight: Radius.circular(24.0),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8.0),
                            child:
                                const Scaffold(body: FreeDateTimeSlotDialog())),
                      ),
                    ),
                  ),
                );
              },
            ).then((value) {
              for (var day in days) {
                day.startTime = null;
                day.endTime = null;
                day.included = false;
              }
            });
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsetsDirectional.all(size.width * 0.04),
            decoration: BoxDecoration(
              color: AppColor.orange8,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              Icons.calendar_month,
              color: AppColor.white,
              size: size.width * 0.05,
            ),
          ),
        ),
      ],
    );
  }
}
