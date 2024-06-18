import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_project/Utils/routes/app_routes.dart';
import 'package:housing_project/controllers/add_new_house_cubit/add_new_house_cubit.dart';
import 'package:housing_project/controllers/auth_cubit/auth_cubit.dart';
import 'package:housing_project/controllers/change_password_page_cubit/change_password_cubit.dart';
import 'package:housing_project/controllers/house_details/house_details_cubit.dart';
import 'package:housing_project/controllers/my_profile_cubit/my_profile_cubit.dart';
import 'package:housing_project/models/user_model.dart';
import 'package:housing_project/views/pages/add_new_house_page/add_new_house_page.dart';
import 'package:housing_project/views/pages/change_password_page/change_password_page.dart';
import 'package:housing_project/views/pages/forget_password_page/forget_password_page.dart';
import 'package:housing_project/views/pages/house_details_page/house_details_page.dart';
import 'package:housing_project/views/pages/custom_bottom_navbar/custom_bottom_navbar.dart';
import 'package:housing_project/views/pages/login_page/login_page.dart';
import 'package:housing_project/views/pages/password_reset_page/password_reset_page.dart';
import 'package:housing_project/views/pages/phone_number_confirm_page/phone_number_confirm_page.dart';
import 'package:housing_project/views/pages/role_selection_page/role_selection_page.dart';
import 'package:housing_project/views/pages/signup_pages/owner_signup_page/owner_signup_page.dart';
import 'package:housing_project/views/pages/signup_pages/student_signup_page/student_signup_page.dart';
import 'package:housing_project/views/pages/profile_page/profile_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loginPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = AuthCubit();
              cubit.getUser();
              return cubit;
            },
            child: const LoginPage(),
          ),
          settings: settings,
        );
      case AppRoutes.stdregister:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const StudentSignupPage(),
          ),
          settings: settings,
        );
      case AppRoutes.ownregister:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const OwnerSignupPage(),
          ),
          settings: settings,
        );
      case AppRoutes.home:
        final UserModel user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => CustomBottomNavbar(user: user),
          settings: settings,
        );
      case AppRoutes.details:
        final String houseId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = HouseDetailsCubit();
              cubit.getHouseDetails(houseId);
              return cubit;
            },
            child: const HouseDetailsPage(),
          ),
          settings: settings,
        );
      case AppRoutes.roleSelectionPage:
        return MaterialPageRoute(
          builder: (_) => const RoleSelectionPage(),
          settings: settings,
        );
      case AppRoutes.profilePage:
        final UserModel user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              return MyProfileCubit();
            },
            child: ProfilePage(user: user),
          ),
          settings: settings,
        );
      case AppRoutes.changePasswordPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ChangePasswordCubit(),
            child: const ChangePasswordPage(),
          ),
          settings: settings,
        );
      case AppRoutes.forgetPasswordPage:
        return MaterialPageRoute(
          builder: (_) => const ForgetPasswordPage(),
          settings: settings,
        );
      case AppRoutes.phoneNumberConfirmationPage:
        return MaterialPageRoute(
          builder: (_) => const PhoneNumberConfirmationPage(),
          settings: settings,
        );
      case AppRoutes.passwordResetPage:
        return MaterialPageRoute(
          builder: (_) => const PasswordResetPage(),
          settings: settings,
        );
      case AppRoutes.addNewHouse:
        final UserModel user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AddNewHouseCubit(),
            child: AddNewHousePage(user: user),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
    }
  }
}
