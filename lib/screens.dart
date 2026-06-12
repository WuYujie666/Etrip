import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/features/Itinerary/presentation/views/itinerary_gate.dart';
import 'package:etrip/features/Profile/bloc/user_bloc.dart';
import 'package:etrip/features/Profile/bloc/user_state.dart';
import 'package:etrip/features/Profile/presentation/views/profile_view.dart';
import 'package:etrip/features/wishlist/presentation/views/wish_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/home/presentation/views/home_view.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  int _selectedIndex = 0;

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = GoRouterState.of(context);
    if (state.extra != null && state.extra is int) {
      setState(() {
        _selectedIndex = state.extra as int;
      });
    }
  }

  final List<Widget> _screens = [
    const HomeView(),
    const WishListView(),
    const ItineraryGate(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserBloc>().state;
    final lang = context.watch<LocaleCubit>().state.languageCode;

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type:
                BottomNavigationBarType.fixed, // Ensures all labels are visible
            onTap: (val) {
              if ((val == 1 || val == 2) && userState is! UserLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(Translations.tr('login_required_feature', lang)),
                    backgroundColor: Colors.black87,
                  ),
                );
                return;
              }

              setState(() {
                _selectedIndex = val;
              });
            },
            currentIndex: _selectedIndex,
            iconSize: 25,
            selectedItemColor: const Color.fromARGB(255, 104, 67, 153),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.explore),
                  label: Translations.tr('discover', lang)),
              BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 1
                      ? Icons.favorite
                      : Icons.favorite_border),
                  label: Translations.tr('wishlist', lang)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.map_outlined),
                  label: Translations.tr('itinerary', lang)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.account_circle_outlined),
                  label: Translations.tr('profile', lang))
            ]),
        body: _screens[_selectedIndex]);
  }
}
