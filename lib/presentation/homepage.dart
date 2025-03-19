

import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/data/local/shared_prefs.dart';
import 'package:chat_app/data/models/firebase_user.dart';
import 'package:chat_app/data/remote/firebase/firebase_client.dart';
import 'package:chat_app/presentation/auth/login_screen.dart';
import 'package:chat_app/presentation/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<FirebaseUser> friends = [];

  @override
  void initState() {
    initObjects();
    super.initState();
  }

  initObjects() async {
    friends = await getUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppConfig.name, style: TextStyle(color: Colors.white)),
            Text(SharedPrefs.getString(SharedPrefsKeys.name) ?? '', style: const TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
        backgroundColor: AppColors.appColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap:() {
                FirebaseClient.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => LoginScreen()));
              },
              child: const Icon(Icons.logout, color: Colors.white)
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              itemCount: friends.length,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder:(context) => ChatPage(receiver: friends[index])));
                  },
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.person, color: AppColors.appColor),
                      title: Text(friends[index].name ?? ''),
                    ),
                  )
                );
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8), 
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // DialogUtils.showInputBox(
          //   context,
          //   title: 'Add User',
          //   hintText: 'Enter username',
          //   buttonText: 'Add',
          //   onSubmit: (value) async {
          //     users.add(value);
          //     await SharedPrefs.setStringList(SharedPrefsKeys.users, users);
          //     setState(() {});
          //   }
          // );

        showModalBottomSheet(context: context, builder: (context) {  
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Text('Add Friends', style: TextStyle(fontSize: 20, color: AppColors.appColor, fontWeight: FontWeight.bold)),
              ),
              FutureBuilder(
                future: FirebaseClient.getAllUsers(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                    ? Flexible(
                      child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      itemCount: FirebaseClient.allUsers.length,
                      itemBuilder: (_, index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.person, color: AppColors.appColor),
                            title: Text(snapshot.data?[index].name ?? ''),
                            subtitle: Text(snapshot.data?[index].username ?? ''),
                            trailing: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: InkWell(
                                onTap: () {
                                  addFriend(snapshot.data![index]);
                                  setState(() {});
                                },
                                splashColor: AppColors.appColor.shade300,
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    color: AppColors.appColor.shade50,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Add', style: TextStyle(fontSize: 14, color: AppColors.appColor, fontWeight: FontWeight.bold)),
                                          SizedBox(width: 4),
                                          Icon(Icons.add, color: AppColors.appColor, size: 20)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8), 
                    ),
                    )
                  : const Expanded(child: Align(alignment: Alignment.center, child: CircularProgressIndicator(color: AppColors.appColor)));
                }
              ),
            ],
            );
          });
        },
        backgroundColor: AppColors.appColor.shade100,
        child: const Icon(Icons.add, color: AppColors.appColor),
      ),
    );
  }
  
  void addFriend(FirebaseUser firebaseUser) async {
    friends.add(firebaseUser);
    saveUsers();
  }

  Future<List<FirebaseUser>> getUsers() async {
    final savedRawUsers = SharedPrefs.getStringList(SharedPrefsKeys.users) ?? [];
    return savedRawUsers.map((e) => FirebaseUser.fromRawJson(e)).toList();
  }

  Future<bool> saveUsers() async {
    return await SharedPrefs.setStringList(SharedPrefsKeys.users, friends.map((e) => e.toRawJson()).toList());
  }
}