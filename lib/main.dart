import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/features/Profile/bloc/user_bloc.dart';
import 'package:etrip/features/Profile/bloc/user_event.dart';
import 'package:etrip/features/auth/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/utils/size_config.dart';
import 'features/chat_bot/data/chat_history_service.dart';
import 'features/wishlist/data/service/favorite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await LocalStorageService.init();
  await FavoriteService.initHive();
  await ChatHistoryService.initHive();
  await LocaleCubit.ensureBoxOpen();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(context);

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (ctx) {
                final uid = LocalStorageService().currentUid ?? '';
                return UserBloc()..add(LoadUser(uid));
              },
            ),
            BlocProvider(create: (_) => LocaleCubit()),
          ],
          child: BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                locale: locale,
                supportedLocales: const [Locale('en'), Locale('zh')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  if (locale != null) {
                    for (final supported in supportedLocales) {
                      if (supported.languageCode == locale.languageCode) {
                        return supported;
                      }
                    }
                  }
                  return const Locale('en');
                },
                routerConfig: AppRouter.router,
                theme: ThemeData(
                  textTheme: GoogleFonts.imFellFrenchCanonScTextTheme(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
