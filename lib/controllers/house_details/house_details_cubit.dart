import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_project/Utils/auth_exceptions.dart';
import 'package:housing_project/models/houses_models/house_details_model.dart';
import 'package:housing_project/models/houses_models/room_details_models/rooms_response_model.dart';
import 'package:housing_project/services/student_services/student_service.dart';

part 'house_details_state.dart';

class HouseDetailsCubit extends Cubit<HouseDetailsState> {
  HouseDetailsCubit() : super(HouseDetailsInitial());
  final StudentServices _studentServices = StudentServicesImplementation();
  Future<void> getHouseDetails(String houseId) async {
    try {
      emit(HouseDetailsLoading());
      final houses = await _studentServices.getHouseDetails(houseId);
      emit(HouseDetailsLoaded(houseDetails: houses));
    } on AuthException catch (exp) {
      emit(HouseDetailsError(message: exp.message));
    } catch (exp) {
      emit(HouseDetailsError(message: exp.toString()));
    }
  }

  Future<void> changeFavorite(String houseId) async {
    try {
      emit(HouseDetailsLoading());
      String message = await _studentServices.changeFavorite(houseId);
      emit(FavroiteDetailsChangedSuccess(message: message));
      getHouseDetails(houseId);
    } on AuthException catch (exp) {
      emit(HouseDetailsError(message: exp.message));
    } catch (exp) {
      emit(HouseDetailsError(message: exp.toString()));
    }
  }

  Future<void> getRoomDetails(String roomId) async {
    try {
      emit(RoomDetailsLoading());
      final room = await _studentServices.getRoomDetails(roomId);
      emit(RoomDetailsLoaded(room: room));
    } on AuthException catch (exp) {
      emit(RoomDetailsError(message: exp.message));
    } catch (exp) {
      emit(RoomDetailsError(message: exp.toString()));
    }
  }

  Future<void> selectDateTimeSlot(String roomId, String timeSlotId) async {
    try {
      String result =
          await _studentServices.makeRequestReservation(roomId, timeSlotId);
      emit(RequestReservationDone(message: result));
    } on AuthException catch (exp) {
      emit(RoomDetailsError(message: exp.message));
    } catch (exp) {
      emit(RoomDetailsError(message: exp.toString()));
    }
    // emit(DayTimeSlotChanged());
  }
}
