import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surai_crafts/screens/auth/forget_password_screen.dart';
import 'package:surai_crafts/screens/auth/login_screen.dart';
import 'package:surai_crafts/screens/auth/register_screen.dart';
import 'package:surai_crafts/screens/category/single_category_screen.dart';
import 'package:surai_crafts/screens/dashboard/dashboard.dart';
import 'package:surai_crafts/screens/product/add_product_screen.dart';
import 'package:surai_crafts/screens/product/edit_product_screen.dart';
import 'package:surai_crafts/screens/product/my_product_screen.dart';
import 'package:surai_crafts/screens/product/single_product_screen.dart';
import 'package:surai_crafts/screens/splash_screen.dart';
import 'package:surai_crafts/services/local_notification_service.dart';
import 'package:surai_crafts/viewmodels/auth_viewmodel.dart';
import 'package:surai_crafts/viewmodels/category_viewmodel.dart';
import 'package:surai_crafts/viewmodels/global_ui_viewmodel.dart';
import 'package:surai_crafts/viewmodels/product_viewmodel.dart';

import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalUIViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
      ],
      child: OverlayKit(
        child: Consumer<GlobalUIViewModel>(builder: (context, loader, child) {
          // if (loader.isLoading) {
          //   OverlayLoadingProgress.start();
          // } else {
          //   OverlayLoadingProgress.stop();
          // }
          return MaterialApp(
            title: 'Seven Steps',
            debugShowCheckedModeBanner: false,
            color: Colors.white,
            theme: ThemeData(
              fontFamily: "Poppins",
              primarySwatch: Colors.brown,
              textTheme: GoogleFonts.aBeeZeeTextTheme(),
              backgroundColor: Colors.white
            ),

            initialRoute: "/splash",
            routes: {
              "/login": (BuildContext context) => LoginScreen(),
              "/splash": (BuildContext context) => SplashScreen(),
              "/register": (BuildContext context) => RegisterScreen(),
              "/forget-password": (BuildContext context) =>
                  ForgetPasswordScreen(),
              "/dashboard": (BuildContext context) => DashboardScreen(),
              "/add-product": (BuildContext context) => AddProductScreen(),
              "/edit-product": (BuildContext context) => EditProductScreen(),
              "/single-product": (BuildContext context) =>
                  SingleProductScreen(),
              "/single-category": (BuildContext context) =>
                  SingleCategoryScreen(),
              "/my-products": (BuildContext context) => MyProductScreen(),
            },
          );
        }),
      ),
    );
  }
}