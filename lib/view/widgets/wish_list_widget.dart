import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/models/offers_models/offers_list_model.dart';
import 'package:b2connect_flutter/model/utils/constant.dart';
import 'package:b2connect_flutter/screen_size.dart';
import 'package:b2connect_flutter/view/screens/product_detail_screen.dart';
import 'package:b2connect_flutter/view_model/providers/offers_provider.dart';
import 'package:b2connect_flutter/view_model/providers/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class WishListWidget extends StatelessWidget {
  const WishListWidget(this.offerList) : super();

  final List<OffersList>? offerList;



  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          addRepaintBoundaries: false,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: offerList!.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: (4.0.h),
            crossAxisSpacing: (4.0.w),
            childAspectRatio:
            ScreenSize.productCardWidth / ScreenSize.productCardHeight,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, i) {
            return AnimationConfiguration.staggeredGrid(
              columnCount: 2,
              position: i,
              duration: const Duration(milliseconds: 1000),
              child: ScaleAnimation(
                scale: 1,
                child: FlipAnimation(
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<OffersProvider>(context,listen: false).productDetailsData=null;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(id: offerList![i].id.toString(),)),
                      );
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: offerList![i].salePrice == null
                                      ? false
                                      : true,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: gradientColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          20.r,
                                        ),
                                      ),
                                    ),
                                    padding: EdgeInsets.only(
                                      left: 9.w,
                                      top: 1.h,
                                      bottom: 1.h,
                                      right: 9.w,
                                    ),
                                    child: Text(
                                      "Sale",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                        ScreenSize.productContainerText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    Provider.of<WishListProvider>(context,listen: false).deleteFromWishList(offerList![i].id!.toString());
                                    Provider.of<WishListProvider>(context,listen: false).removeFromWishList(offerList![i].id!);

                                  },
                                    child: Icon(Icons.clear,size: 20,)
                                )
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Icon(
                                //       Icons.star,
                                //       size: ScreenSize.productIcon,
                                //       color: Colors.yellowAccent.shade700,
                                //     ),
                                //     Text(
                                //       " 4.5",
                                //       style: TextStyle(
                                //         color: Colors.black,
                                //         fontSize: ScreenSize.productRate,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //   ],
                                // )
                              ],
                            ),
                            Container(
                              height: 150,
                              child: Stack(
                                children: [
                                  FadeInImage(
                                    image: NetworkImage(offerList![i].images!.first),
                                    placeholder: AssetImage(
                                      'assets/images/placeholder1.png',
                                    ),

                                    fit: BoxFit.fill,
                                  ),
                                  Visibility(
                                    visible: offerList![i].stockStatus! == "instock"? false : true,
                                    child: Center(
                                      child:
                                      Card(
                                        color: Colors.white,
                                        elevation: 5,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            8.h,
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!.translate('out_of_stock')!,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ),

                            Container(
                              width: ScreenSize.productCardTextWidth,
                              height: 50.h,
                              //color: Colors.red,
                              child: Text(
                                offerList![i].name.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: ScreenSize.productCardText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Visibility(
                                    visible: offerList![i].salePrice == null
                                        ? false
                                        : true,
                                    child: Text(
                                      'AED ${offerList![i].regularPrice.toString()}',
                                      style: TextStyle(
                                        fontSize: ScreenSize.productCardPrice,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.grey.shade800,
                                        decorationStyle: TextDecorationStyle.solid,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    offerList![i].salePrice == null
                                        ? 'AED ${offerList![i].regularPrice.toString()}'
                                        : 'AED ${offerList![i].salePrice.toString()}',
                                    style: TextStyle(
                                      fontSize: ScreenSize.productCardSalePrice,
                                      color: pink,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}