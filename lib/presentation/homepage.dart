

import 'package:say_it/constants/app_colors.dart';
import 'package:say_it/constants/constants.dart';
import 'package:say_it/data/local/shared_prefs.dart';
import 'package:say_it/data/models/firebase_status.dart';
import 'package:say_it/data/models/firebase_user.dart';
import 'package:say_it/data/models/friend.dart';
import 'package:say_it/data/models/friend_request_status.dart';
import 'package:say_it/data/remote/firebase/firebase_client.dart';
import 'package:say_it/presentation/auth/login_screen.dart';
import 'package:say_it/presentation/chat_page.dart';
import 'package:say_it/utils/info_utils.dart';
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
  List<Friend> friends = [];
  List<Friend> friendRequests = [];
  List<Friend> conversations = [];

  @override
  void initState() {
    initObjects();
    super.initState();
  }

  initObjects() async {
    await FirebaseClient.getAllUsers();
    friends = await FirebaseClient.getAllFriends();
    conversations = friends.where((e) => e.friendRequestStatus == FriendRequestStatus.accepted).toList();
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
            child: RefreshIndicator(
            color: AppColors.appColor,
            onRefresh: () => Future.delayed(
              const Duration(seconds: 1), () {
                  initObjects();
                  debugPrint('DebugX: on refresh called [homepage.dart]');
                }
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                itemCount: conversations.length,
                itemBuilder: (_, index) {
                  final conversation = conversations[index];
                  return InkWell(
                    onTap: () {
                      FirebaseClient.setUnreadCount(conversationId: conversation.conversationId, userId: conversation.id, count: 0);

                      Navigator.of(context).push(MaterialPageRoute(builder:(context) => ChatPage(receiver: conversation)));
                    },
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.person, color: AppColors.appColor),
                        title: Text(conversation.name ?? ''),
                        trailing: conversation.unreadCount != 0 ? CircleAvatar(
                          backgroundColor: AppColors.appColor,
                          radius: 10,
                          child: Text(conversation.unreadCount.toString(), style: const TextStyle(fontSize: 12, color: AppColors.white),),
                        ) : null,
                      ),
                    )
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8), 
              ),
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
          return FutureBuilder(
            future: FirebaseClient.getAllUsers(),
            builder: (context, snapshot) {
              return snapshot.hasData
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      child: Text('Add Friends', style: TextStyle(fontSize: 20, color: AppColors.appColor, fontWeight: FontWeight.bold)),
                    ),
                    ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    shrinkWrap: true,
                    itemCount: FirebaseClient.allUsers.length,
                    itemBuilder: (_, index) {
                      final user = snapshot.data![index];
                      // final friend = friends.firstWhere(
                      //   (friend) => friend.id == users[index].id,
                      //   orElse: () => null, // returns null if no friend is found
                      // );
                      final isAlreadyFriend = friends.any((element) => element.id == user.id && element.friendRequestStatus == FriendRequestStatus.accepted);
                      final isRequestPending = friends.any((element) => element.id == user.id && element.friendRequestStatus == FriendRequestStatus.pending);
                      final isRequestRecieved = friends.any((element) => element.id == user.id && element.friendRequestStatus == FriendRequestStatus.recieved);
                      return FriendListTile(
                        user: user,
                        isRequestPending: isRequestPending,
                        isAlreadyFriend: isAlreadyFriend,
                        isRequestRecieved: isRequestRecieved,
                        onTap: () {
                          if(isAlreadyFriend || isRequestPending) return;
                          addFriend(user, acceptRequest: isRequestRecieved).then((_) {
                            initObjects();
                          });
                        });
                    },
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8), 
                  ),
          
          
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text('Friend Requests', style: TextStyle(fontSize: 20, color: AppColors.appColor, fontWeight: FontWeight.bold)),
          ),
                  ],
                )
              : const Center(child: CircularProgressIndicator(color: AppColors.appColor));
            }
          );
          });
        },
        backgroundColor: AppColors.appColor.shade100,
        child: const Icon(Icons.add, color: AppColors.appColor),
      ),
    );
  }
  
  Future<void> addFriend(FirebaseUser firebaseUser, {bool acceptRequest = false}) async {
    FirebaseStatus status = await FirebaseClient.addFriend(firebaseUser, acceptRequest: acceptRequest);
    InfoUtils.showSnackbar('Add Friend', status.message);
    // saveUsers(); // Locally saving
  }

  Future<List<Friend>> getAllFriends() async {
    return [];
    // Locally Retriving saving
    // final savedRawUsers = SharedPrefs.getStringList(SharedPrefsKeys.users) ?? [];
    // return savedRawUsers.map((e) => FirebaseUser.fromRawJson(e)).toList();
  }

  Future<bool> saveUsers() async {
    return await SharedPrefs.setStringList(SharedPrefsKeys.users, friends.map((e) => e.toRawJson()).toList());
  }
}

class FriendListTile extends StatelessWidget {
  const FriendListTile({
    super.key,
    required this.user,
    required this.onTap,
    required this.isRequestPending,
    required this.isAlreadyFriend,
    required this.isRequestRecieved,
  });

  final FirebaseUser user;
  final Null Function() onTap;
  final bool isRequestPending;
  final bool isAlreadyFriend;
  final bool isRequestRecieved;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person, color: AppColors.appColor),
        title: Text(user.name ?? ''),
        subtitle: Text(user.username ?? ''),
        trailing: InkWell(
          onTap: () {
            Get.back();
          },
          child: InkWell(
            onTap: onTap,
            splashColor: AppColors.appColor.shade300,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: AppColors.appColor.shade50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(isRequestRecieved ? 'Accept' : isRequestPending ? 'Requested' : isAlreadyFriend ? 'Added' : 'Add', style: const TextStyle(fontSize: 14, color: AppColors.appColor, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Icon(isRequestPending ? Icons.check_box : isAlreadyFriend ? Icons.download_done_rounded : Icons.add, color: AppColors.appColor, size: 20)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}