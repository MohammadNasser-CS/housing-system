import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_project/Utils/app_color.dart';
import 'package:housing_project/controllers/house_details/house_details_cubit.dart';
import 'package:housing_project/views/widgets/text_widget.dart';

class BedRoomDiscoveringDialog extends StatefulWidget {
  const BedRoomDiscoveringDialog({super.key});

  @override
  State<BedRoomDiscoveringDialog> createState() =>
      _BedRoomDiscoveringDialogState();
}

class _BedRoomDiscoveringDialogState extends State<BedRoomDiscoveringDialog> {
  String? selectedTimeSlot;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = BlocProvider.of<HouseDetailsCubit>(context);
    return Container(
      height: size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.topCenter,
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<HouseDetailsCubit, HouseDetailsState>(
        bloc: cubit,
        buildWhen: (previous, current) =>
            current is RoomDetailsLoading ||
            current is RoomDetailsLoaded ||
            current is RoomDetailsError,
        builder: (context, state) {
          if (state is RoomDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is RoomDetailsError) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is RoomDetailsLoaded) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: state.room.roomPhotos.map((imageUrl) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsetsDirectional.symmetric(
                              horizontal:
                                  4.0), // Optional: add some margin between images
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              height: size.height * 0.2,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    height: size.height * 0.2,
                    decoration: BoxDecoration(
                      color: AppColor.grey2,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextWidget(
                                  title: 'مساحة الغرفة:',
                                  value: ' ${state.room.roomSpace}م\u00b2'),
                              TextWidget(
                                  title: 'يحتوي على مكتب للدراسة؟:',
                                  value: state.room.desk),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextWidget(
                                  title: 'عدد الأسرَّة المتبقية:',
                                  value: ' ${state.room.avalabileBed}'),
                              TextWidget(
                                  title: 'يحتوي على مكيف؟:',
                                  value: state.room.ac),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextWidget(
                                  title: 'تكلفة حجز الغرفة:',
                                  value: ' ${state.room.price}\u20AA '),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  DropdownButtonHideUnderline(
                    child: DropdownButtonFormField2<String>(
                      decoration: InputDecoration(
                        fillColor: AppColor.grey1,
                        filled: true,
                        contentPadding: const EdgeInsetsDirectional.all(5.0),
                      ),
                      hint: const Text(
                        'قم بإختيار موعد مناسب للقاء صاحب السكن..',
                      ),
                      isExpanded: true,
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(border: Border.all()),
                      ),
                      onChanged: (String? value) {
                        if (value != null) {
                          debugPrint(value);
                          selectedTimeSlot = value;
                          cubit.selectDateTimeSlot(
                              state.room.roomId, selectedTimeSlot!);
                        }
                      },
                      items: state.room.availableTimes.map((entry) {
                        return DropdownMenuItem<String>(
                          onTap: () {},
                          value: entry.slotId,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              border: BorderDirectional(
                                bottom: BorderSide(color: AppColor.grey),
                              ),
                            ),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(entry.timeSlot),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            state.room.avalabileBed != "0"
                                ? debugPrint('تم الحجز بنجاح')
                                : debugPrint('لا يوجد أسرة متبقة في الغرفة');
                            // Navigator.of(context)
                            //     .pushNamed(AppRoutes.ordersPage)
                            //     .then((value) => Navigator.of(context).pop(context));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.orange8,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('إحجز الغرفة!'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
