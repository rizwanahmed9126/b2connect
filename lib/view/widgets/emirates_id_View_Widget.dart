import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/view_model/providers/auth_provider.dart';
import 'package:b2connect_flutter/view_model/providers/scanner_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

late Text verificationText;
late Icon verificationIcon;
late MaskedTextController emiratesIdTextMask;

class EmiratesIdViewWidget extends StatelessWidget {
  const EmiratesIdViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Consumer<AuthProvider>(builder: (context, i, _) {
        if (i.userInfoData!.emiratesId == "") {
          emiratesIdTextMask = MaskedTextController(
              mask: '000-0000-0000000-0', text: '000-0000-0000000-0');
          verificationText = Text(
            AppLocalizations.of(context)!.translate('not_verified')!,
            style: TextStyle(color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          );
          verificationIcon = Icon(
            Icons.info_outline,
            color: Colors.red,
          );
        } else {
          emiratesIdTextMask = MaskedTextController(
              mask: '000-0000-0000000-0', text: i.userInfoData!.emiratesId);
          verificationText = Text(
            AppLocalizations.of(context)!.translate('verified')!,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          );
          verificationIcon = Icon(
            Icons.check,
            color: Colors.green,
          );
        }
        return Container(
          width: sx(500),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    enabled: false,
                    controller: emiratesIdTextMask,
                    decoration: InputDecoration(
                        //hintText: 'e.g. 61101-1234524-1',
                        border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: verificationIcon,
                ),
                verificationText,
              ],
            ),
          ),
        );
      });
    });
  }
}
