import 'package:b2connect_flutter/view/screens/cart_screen.dart';
import 'package:b2connect_flutter/view/screens/categories_screen.dart';
import 'package:b2connect_flutter/view/screens/edit_number_top_up_screen.dart';
import 'package:b2connect_flutter/view/screens/eid_details_screen.dart';
import 'package:b2connect_flutter/view/screens/media_screen.dart';
import 'package:b2connect_flutter/view/screens/money_screen.dart';
import 'package:b2connect_flutter/view/screens/new_filter_screen.dart';
import 'package:b2connect_flutter/view/screens/review_order.dart';
import 'package:b2connect_flutter/view/screens/spinner_screen.dart';
import 'package:b2connect_flutter/view/screens/success_screen.dart';
import 'package:b2connect_flutter/view/screens/top_up_intro_screen.dart';
import 'package:b2connect_flutter/view/screens/wellness_screen.dart';

import '../../view/screens/add_shipping_address.dart';
import '../../view/screens/cash_payment_intro_screen.dart';
import '../../view/screens/order_details_screen.dart';
import '../../view/screens/orders_screen.dart';
import '../../view/screens/notifications_screen.dart';
import '../../view/screens/settings.dart';
import '../../view/screens/shipping_screen.dart';
import '../../view/screens/transactions.dart';
import '../../view/screens/transcation_details_screen.dart';
import '../../view/screens/wifi_plan.dart';
import '../../view/screens/wifi_screen.dart';
import '../../view/screens/payment_method_screen.dart';
import '../../view/screens/wishlist_screen.dart';
import 'package:b2connect_flutter/view/screens/cash_payment_intro_screen.dart';
import 'package:b2connect_flutter/view/screens/order_details_screen.dart';
import 'package:b2connect_flutter/view/screens/orders_screen.dart';
import 'package:b2connect_flutter/view/screens/notifications_screen.dart';
import 'package:b2connect_flutter/view/screens/product_detail_screen.dart';
import 'package:b2connect_flutter/view/screens/settings.dart';
import 'package:b2connect_flutter/view/screens/transactions.dart';
import 'package:b2connect_flutter/view/screens/view_all_offers_screen.dart';
import 'package:b2connect_flutter/view/screens/transcation_details_screen.dart';
import 'package:b2connect_flutter/view/screens/wifi_plan.dart';
import 'package:b2connect_flutter/view/screens/wifi_screen.dart';
import 'package:b2connect_flutter/view/screens/payment_method_screen.dart';
import 'package:flutter/material.dart';
import '../../view/screens/edit_personal_information_screen.dart';
import '../../view/screens/login_screen.dart';
import '../../view/screens/main_dashboard_screen.dart';
import '../../view/screens/main_profile_screen.dart';
import '../../view/screens/password_reset.dart';
import '../../view/screens/personal_information_screen.dart';
import '../../view/screens/scan_your_emirates_id_screen.dart';
import '../../view/screens/notification_screen.dart';
import '../../view/screens/support_screen.dart';
import '../../view/screens/on_boarding_screen.dart';
import '../../view/screens/otp_screen.dart';
import '../../view/screens/signup_screen.dart';
import '../../view/screens/welcome_screen.dart';
import '../../view/screens/splash_screen.dart';
import '../../view/screens/sort_by_screen.dart';

const SplashScreenRoute = '/splash-screen';
const WelcomeScreenRoute = '/Welcome-screen';
const SpinnerScreenRoute = '/Spinner-screen';
const SignupScreenRoute = '/signup-screen';
const OnBoardingRoute = '/on-boarding-screen';
//const SignUpForBt2Route = '/signupforbt2-Screen';
const OtpScreenRoute = '/otp-screen';
const HomeScreenRoute = '/home-screen';
const PasswordResetRoute = '/forgotPassword-screen';
const LoginScreenRoute = '/login-screen';
const WifiScreenV1Route = '/wifi-screen';
const WifiScreenRoute = '/wifi-screen';
const MainDashBoardRoute = '/maindashboard-screen';
const NotificationScreenRoute = '/notification-screen';
const SupportScreenRoute = '/support-screen';
const CameraSliderScreenRoute = '/camera-slider-screen';
const MainProfileScreenRoute = '/main-profile-screen';
const PersonalInformationScreenRoute = '/personal-information-screen';
const SortByScreenRoute = '/sort-by-screen';
const FilterScreenRoute = '/filter-screen';
const ScanYourEmiratesIDScreenRoute = '/ScanYourEmirates-Id-screen';
const ScanScreenRoute = '/scan-screen';
const EditPersonalInformationScreenRoute = '/edit-profile-information-screen';
const NotificationsScreenRoute = '/notificatins-screen';
const OrderDetailScreenRoute = '/order-detail-screen';
const EidDetailScreenRoute = '/eid-detail-screen';
const OrdersScreenRoute = '/orders-screen';
const CardInformationScreenRoute = 'card_information_screen';
const CartScreenRoute = 'cart_screen';
//const PaymentMethodScreenRoute = '/payment-method-screen';
const CashPaymentIntroScreenRoute = '/cash-Payment-intro-screen';
const TopUpIntroScreenRoute = '/topUp-Intro-screen';

const AddShippingAddressScreenRoute = '/add-shipping-address-screen';
const SettingsScreenRoute = '/setting-screen';
const TransactionsScreenRoute = '/transaction-screen';
const WifiPlanScreenRoute = '/wifi-plan-screen';
//const TopUpScreenRoute = '/top-up-screen';
const ViewAllOffersScreenRoute = '/view-all-offers-screen';

const TransactionsDetailScreenRoute = '/transcation-details-screen';
const ProductDetailScreenRoute='/product-details-screen';
const ShippingScreenRoute='shipping-screen';
const WishlistScreenRoute='/wishlist-screen';
const CategoriesScreenRoute='/categories-screen';
//const OrderReviewScreenRoute='/order-preview-screen';
// const SuccessScreenRoute='/success-screen-route';
const MoneyScreenRoute='/money-screen-route';
const WellnessScreenRoute='/wellness-screen-route';
const MediaScreenRoute='/media-screen-route';







Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case PersonalInformationScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => PersonalInformationScreen());

    case ScanYourEmiratesIDScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ScanYourEmiratesIDScreen());

    case EditPersonalInformationScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => EditPersonalInformationScreen());

    case SplashScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SplashScreen());



    case ShippingScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ShippingScreen());

    case AddShippingAddressScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => AddShippingAddress());

    case ViewAllOffersScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ViewAllOffersScreen());

    case PersonalInformationScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => PersonalInformationScreen());

    case WelcomeScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => WelcomeScreen());

    case SpinnerScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SpinnerScreen());

    case WishlistScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => WishlistScreen());

    case SignupScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SignupScreen());

    case OnBoardingRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => OnBoardingScreen());


    case CartScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => CartScreen());

    case OtpScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => OtpScreen());

    case MoneyScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => MoneyScreen());

    case WellnessScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => WellnessScreen());

    case MediaScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => MediaScreen());

   /* case TopUpScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => EditNumberTopUpScreen());*/

    case HomeScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MainDashBoard(selectedIndex: 0,));

    /*case SortByScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SortByScreen());*/

    /*case FilterScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => NewFilterScreen());*/

    case CategoriesScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => CategoriesScreen());

    case PasswordResetRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => PasswordReset());

    case WifiPlanScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => WifiPlanScreen());

    case WifiScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => WifiScreen());

    case PasswordResetRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => PasswordReset());

    case LoginScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen());

    case NotificationScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => NotificationScreen());

    case NotificationsScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => NotificationsScreen());

    case SupportScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SupportScreen());

    case MainProfileScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => MainProfileScreen());

    case OrdersScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => OrdersScreen());

    // case PaymentMethodScreenRoute:
    //   return MaterialPageRoute(
    //       builder: (BuildContext context) => PaymentMethod(comingFrom: true,));

    case CashPaymentIntroScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => CashPaymentIntroScreen());

    case TopUpIntroScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => TopUpIntroScreen());

    case SettingsScreenRoute:
      return MaterialPageRoute(builder: (BuildContext context) => Settings());

    case TransactionsScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => Transactions());

    case ShippingScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ShippingScreen());
    case OrderDetailScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => OrderDetailScreen());

    case EidDetailScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => EidDetailsScreen());

    case TransactionsDetailScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => TransactionDetailsScreen());

    case ProductDetailScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => ProductDetailScreen());

  case TransactionsDetailScreenRoute:
    return MaterialPageRoute(
        builder: (BuildContext context) => TransactionDetailsScreen());

    // case OrderReviewScreenRoute:
    //   return MaterialPageRoute(
    //       builder: (BuildContext context) => OrderReviewScreen());
   /* case SuccessScreenRoute:
      return MaterialPageRoute(
          builder: (BuildContext context) => SuccessScreen(comingFrom: ,));*/

    default:
      return MaterialPageRoute(
          builder: (BuildContext context) => OnBoardingScreen());
  }
}
