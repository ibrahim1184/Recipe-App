//GetMaterialApp
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/routes/app_pages.dart';
import 'package:recipe_app_firebase/firebase_options.dart';
import 'package:recipe_app_firebase/setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  Setup.init();
  
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
