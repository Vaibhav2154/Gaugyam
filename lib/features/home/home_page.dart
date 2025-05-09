import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:gaugyam/features/chat_assistant/pages/chat_assistant.dart';
import 'package:gaugyam/features/auth/pages/phoneauth_page.dart';
import 'package:gaugyam/features/auth/providers/auth_providers.dart';
import 'package:gaugyam/features/breeding_prog/pages/breeding_prog.dart';
import 'package:gaugyam/features/home/charts_dist.dart';
import 'package:gaugyam/features/search_screen/pages/search_screen.dart';
import 'package:gaugyam/features/feed_stock/pages/feed_stock.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state changes for navigation
    ref.listen<AuthStateData>(authStateNotifierProvider, (previous, current) {
      // If the user was authenticated before but now is not (signed out)
      if (previous?.state == AuthState.authenticated &&
          current.state != AuthState.authenticated) {
        // Navigate to phone auth page and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          PhoneAuthScreen.route(),
          (route) => false, // This removes all previous routes
        );
      }
    });
    return Scaffold(
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       SizedBox(height: 60),
      //       Text(
      //         'Menu',
      //         style: TextStyle(color: AppPallete.whiteColor, fontSize: 24),
      //       ),
      //       SizedBox(height: 20),
      //       ListTile(
      //         title: const Text('Search'),
      //         leading: const Icon(Icons.search),
      //         onTap: () {
      //           Navigator.pop(context);
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => Search()),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         title: const Text('Home'),
      //         leading: const Icon(Icons.home),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         title: const Text('Breeding Assistant'),
      //         leading: const Icon(Icons.pets),
      //         onTap: () {
      //           Navigator.pop(context);
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => BreedingProg()),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         title: const Text('Feeding Assistant'),
      //         leading: const Icon(Icons.fastfood_rounded),
      //         onTap: () {
      //           Navigator.pop(context);
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => CowFeedingAssistantScreen(),
      //             ),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         title: const Text('Chat Assistant'),
      //         leading: const Icon(Icons.chat),
      //         onTap: () {
      //           Navigator.pop(context);
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => ChatAssistantScreen(),
      //             ),
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Home',
            style: TextStyle(color: AppPallete.gradient1),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppPallete.gradient1),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Search()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.chat, color: AppPallete.gradient1),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatAssistantScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppPallete.gradient1),
            onSelected: (String choice) async {
              if (choice == 'Logout') {
                // Sign out using Riverpod auth provider
                await ref.read(authStateNotifierProvider.notifier).signOut();
                if (!context.mounted) return;
                Navigator.of(context)
                    .pushAndRemoveUntil(PhoneAuthScreen.route(), (route) => false);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hello Farmer, 👋",
                  style: TextStyle(
                    color: AppPallete.gradient1,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedStockPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 60),
                          backgroundColor: AppPallete.gradient1, // Button color
                          foregroundColor: Colors.white, // Text color
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // Rounded corners
                          ),
                        ),
                        child: Text("Feed Stock"),
                      ),
                      const SizedBox(width: 20),
                      //CattleStatisticsWidget(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BreedingProg(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 60),
                          backgroundColor: AppPallete.gradient1, // Button color
                          foregroundColor: Colors.white, // Text color
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // Rounded corners
                          ),
                        ),
                        child: Text("Breeding Techniques"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                CattleStatisticsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
