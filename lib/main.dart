import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/data/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Environment Variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  final supabaseService = await Get.putAsync(() => SupabaseService().init());
  supabaseService.listenToAuthChanges();

  // Determine Initial Route
  final initialRoute = supabaseService.isAuthenticated
      ? AppPages.NAV
      : AppPages.INITIAL;

  runApp(
    ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Mental Wellbeing",
          initialRoute: initialRoute,
          getPages: AppPages.routes,
          theme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    ),
  );
}
