import 'package:b2connect_flutter/model/locale/app_localization.dart';
import 'package:b2connect_flutter/model/services/navigation_service.dart';
import 'package:b2connect_flutter/model/services/storage_service.dart';
import 'package:b2connect_flutter/model/utils/routes.dart';
import 'package:b2connect_flutter/model/utils/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var navigationService = locator<NavigationService>();
var storageService = locator<StorageService>();
Future<Widget> showOnWillPop(context) async {
  var navigationService = locator<NavigationService>();
  return await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text(AppLocalizations.of(context)!.translate('exist')!,
              style: new TextStyle(color: Colors.black, fontSize: 20.0)),
          content:
              new Text(AppLocalizations.of(context)!.translate('exit_conset')!),
          actions: <Widget>[
            // ignore: deprecated_member_use
            new FlatButton(
              onPressed: () async {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: new Text(AppLocalizations.of(context)!.translate('yes')!,
                  style: new TextStyle(fontSize: 18.0)),
            ),
            // ignore: deprecated_member_use
            new FlatButton(
              onPressed: () => navigationService.closeScreen(),
              // this line dismisses the dialog
              child: new Text(
                  AppLocalizations.of(context)!.translate('cancel')!,
                  style: new TextStyle(fontSize: 18.0)),
            )
          ],
        ),
      ) ??
      false;
}

Future<Widget> logOutConset(context) async {
  var navigationService = locator<NavigationService>();
  return await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text(AppLocalizations.of(context)!.translate('logOut')!,
              style: new TextStyle(color: Colors.black, fontSize: 20.0)),
          content: new Text(
              AppLocalizations.of(context)!.translate('logout_conset')!),
          actions: <Widget>[
            // ignore: deprecated_member_use
            new FlatButton(
              onPressed: () async {
                await storageService.setBoolData('isShowHome', false);
                navigationService.navigateTo(LoginScreenRoute);
              },
              child: new Text(AppLocalizations.of(context)!.translate('yes')!,
                  style: new TextStyle(fontSize: 18.0)),
            ),
            // ignore: deprecated_member_use
            new FlatButton(
              onPressed: () => navigationService.closeScreen(),
              // this line dismisses the dialog
              child: new Text(
                  AppLocalizations.of(context)!.translate('cancel')!,
                  style: new TextStyle(fontSize: 18.0)),
            )
          ],
        ),
      ) ??
      false;
}
