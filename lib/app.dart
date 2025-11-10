import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:yousef1234321/core/binding/controller_binder.dart';
import 'package:yousef1234321/routes/app_route.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: Approute.getSplashScreen(),
          getPages: Approute.routes,
          builder: EasyLoading.init(),
          initialBinding: ControllerBinder(),
          themeMode: ThemeMode.system,
          // theme: AppTheme.lightTheme,
          
          // darkTheme: AppTheme.darkTheme,
        );
      },
    );
  }
}
