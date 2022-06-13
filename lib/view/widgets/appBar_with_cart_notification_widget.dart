import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/utils/constant.dart';
import 'package:b2connect_flutter/model/utils/routes.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:b2connect_flutter/view_model/providers/auth_provider.dart';
import 'package:b2connect_flutter/view_model/providers/offers_provider.dart';
import 'package:b2connect_flutter/view_model/providers/pay_by_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../screen_size.dart';

class AppBarWithCartNotificationWidget extends StatelessWidget implements PreferredSizeWidget{

  final Function() onTapIcon;
  final String title;
  final Widget? leadingWidget;
  final IconData? icon;

  const AppBarWithCartNotificationWidget({this.leadingWidget,required this.title,this.icon,required this.onTapIcon}) : super();

  @override
  Widget build(BuildContext context) {
    final IconData? iconImage = icon ?? Icons.arrow_back_ios;
    //var height = MediaQuery.of(context).size.height;

    return AppBar(
      leading: leadingWidget == null? IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () {
            onTapIcon();
          },
          icon: Icon(iconImage)): leadingWidget,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      //toolbarHeight: height * 0.08,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
        ),
      ),
      actions: [
        InkWell(
          onTap: () async {
            await Provider.of<AuthProvider>(context, listen: false)
                .callNotifications(context, '1', '30')
                .then((value) {

                //  _notificationData.addAll(value);
                navigationService.navigateTo(NotificationsScreenRoute);

            });
          },
          child: Container(
            height: 30.h,
            width: 30.w,
             //color: Colors.red,
            margin: EdgeInsets.only(
              right: 10.w,
              top: 5.h,
            ),
            child: Icon(
              Icons.notifications_outlined,

              color: Colors.white,
              size: 20.w, //ScreenSize.appbarIconSize,
            ),
          ),
        ),
        Container(
          height: 30.h,
          width: 30.w,
          // color: Colors.yellow,
          margin: EdgeInsets.only(
            right: 10.w,
            top: 5.h,
          ),
          child: Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    navigationService.navigateTo(CartScreenRoute);
                    //navigationService.navigateTo(NotificationsScreenRoute);
                  },
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 20.w, //ScreenSize.appbarIconSize,
                  ),
                ),
                Consumer<PayByProvider>(builder: (context, i, _) {
                  return Positioned(
                    left: 17.w,
                    top: 10.h,
                    child: i.totalCartCount == null || i.totalCartCount == 0
                        ? Text(' ')
                        :  Container(
                    width: 15.w,
                    height: 15.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text('${i.totalCartCount}',
                          style: TextStyle(color: pink, fontSize: 10)),

                      //Text('${Provider.of<OffersProvider>(context,listen: false).productIds.length}',style: TextStyle(color: Colors.white,fontSize: 10)),
                    ),
                  ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: gradientColor),
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
