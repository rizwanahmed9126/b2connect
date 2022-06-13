import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/utils/routes.dart';
import 'package:b2connect_flutter/view/screens/main_dashboard_screen.dart';
import 'package:b2connect_flutter/view/widgets/appbar_with_back_icon_and_language.dart';
import 'package:b2connect_flutter/view/widgets/showOnWillPop.dart';
import 'package:b2connect_flutter/view_model/providers/pay_by_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'custom_buttons/gradiant_color_button.dart';


class EmptyCart extends StatelessWidget {
  final String name;
  final bool showButton;
  final String desc;
  const EmptyCart({Key? key,required this.name,required this.showButton,required this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: AppBarWithBackIconAndLanguage(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 34.sp,
              ),
            ),
            Column(
              children: [
                Center(
                  child: Container(
                      height: height*0.2,
                      child: Image.asset('assets/images/cart_empty.png')
                  ),
                ),
                SizedBox(height: 15,),
                Text(desc,style: TextStyle(fontSize: 19),),
              ],
            ),

           showButton? Column(
              children: [
                CustomButton(
                  height: height * 0.07,
                  width: double.infinity,
                  onPressed: (){
                    navigationService.navigateTo(ViewAllOffersScreenRoute);

                  },

                  text: "Shop, Now!"//AppLocalizations.of(context)!.translate('back')!,
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MainDashBoard(selectedIndex: 1,)));
                    },
                    //     () {
                    //   setState(() {
                    //     _launched = _makePhoneCall('tel: 800614');
                    //   });
                    // },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      primary: Color(0xFFFFEBF2),
                    ),
                    child: new Text(
                      AppLocalizations.of(context)!.translate('contact_support')!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                    ),
                  ),
                ),
              ],
            ):Text(''),
          ],
        ),
      ),
    );
  }
}
