class HttpConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String login = '/login';
  static const String studentRegister = '/studentRegister';
  static const String ownerRegister = '/houseOwnerRegister';
  static const String getUser = '/getUser';
  static const String logout = '/logout';
  static const String changePassword = '/changePassword';
  static const String updateMyInformation = '/updateMyInformation';
  static const String getAllHouses = '/getAllHouses';
  static const String getAllHousesHouseOwner = '/getAllHousesHouseOwner';
  static const String getCategorizedHouses = '/getCategorizedHouses';
  static const String getFavoriteHouses = '/getFavoriteHouses';
  static const String requestReservation = '/requestReservation';
  static const String getReservationRoomRequest = '/getReservationRoomRequest';
  static const String getMyReservationRoom = '/getMyReservationRoom';
  static const String addtimeSlotsAvailable = '/addtimeSlotsAvailable';
  static const String addHouse = '/addHouse';
  static const String addNewRoom = '/addNewRoom';
  static const String addSeconderyRoom = '/addSeconderyRoom';
  static const String getHouseOwnerRequests = '/getHouseOwnerRequests';
  static const String getHouseOwnerActiviationRequest =
      '/getHouseOwnerActiviationRequest';
  static const String acceptRoomReservationRequest =
      '/acceptRoomReservationRequest';
  static const String updateRoomReservation = '/updateRoomReservation';
  static String searchForSpecificOwner(String name) => '/search/$name';
  static String searchForSpecificHouse(int houseId) => '/searchHouse/$houseId';
  static String getHouseDetails(int houseId) => '/getHouseDetails/$houseId';
  static String getOwnerHouseDetails(int houseId) =>
      '/getOwnerHouseDetails/$houseId';
  static String getRoomDetails(int roomId) => '/getRoomDetails/$roomId';
  static String changeFavorite(int houseId) => '/changeFavorite/$houseId';
  static String cancelRequest(int requestId) => '/cancelRequest/$requestId';
  static String rejectRequestHouseOwenr(int requestId) =>
      '/rejectRequestHouseOwenr/$requestId';
  static String confirmAppointment(int requestId) =>
      '/confirmAppointment/$requestId';
  static String rejectHouseOwner(int ownerId) => '/rejectHouseOwner/$ownerId';
  static String acceptHouseOwner(int ownerId) => '/acceptHouseOwner/$ownerId';
  static String finishRoomReservation(int studentId) =>
      '/finishRoomReservation/$studentId';
}
