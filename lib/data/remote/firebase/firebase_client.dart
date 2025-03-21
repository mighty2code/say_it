import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/data/local/shared_prefs.dart';
import 'package:chat_app/data/models/chat_message.dart';
import 'package:chat_app/data/models/firebase_status.dart';
import 'package:chat_app/data/models/firebase_user.dart';
import 'package:chat_app/data/models/friend.dart';
import 'package:chat_app/data/models/friend_request_status.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/utils/map_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseClient {
  static FirebaseDatabase database = FirebaseDatabase.instance;
  static List<FirebaseUser> allUsers = [];
  static List<Friend> allFriends = [];

  static Function(ChatMessage message) listener = (message) {
    debugPrint("$currentTimeStamp: $message");
  };

  static void setChatListener(Function(ChatMessage message) listenerFunction) {
    listener = listenerFunction;
  }

  static void initSDK() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  static dispose() {}

  static Future<bool> isLoggedIn() async {
    return FirebaseAuth.instance.currentUser !=  null;
  }

  static Future<FirebaseAuthStatus> signIn({required FirebaseUser user}) async {
    try {
      if(user.email == null || user.password == null) return FirebaseAuthStatus(isSuccess: false, message: 'Please provide email & password for Firebase SignIn');
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      final firebaseId = credential.user?.uid ?? '';
      final userData =  await getLoggedUserData(firebaseID: firebaseId);
      if(userData != null) {
        saveUserData(userData);
      }
      saveUserData(user);
      debugPrint('DebugX: Firebase Login Successful, Firebase logged email- (${user.email}) FirebaseId- ($firebaseId)');
      return FirebaseAuthStatus(isSuccess: true, message: 'Login Successful');
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
        case 'wrong-password':
          errorMessage = 'Invalid password.';
        default:
          errorMessage = 'Firebase Exception: $e';
      }
      return FirebaseAuthStatus(isSuccess: false, message: errorMessage);
    } catch (e) {
      debugPrint('DebugX: Exception: $e');
      return FirebaseAuthStatus(isSuccess: false, message: 'Exception: $e');
    }
  }

  static Future<FirebaseAuthStatus> signUp({required FirebaseUser user}) async {
    try {
      if(user.email == null || user.password == null) return FirebaseAuthStatus(isSuccess: false, message: 'Please provide email & password for Firebase SignUp');
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      final firebaseId = credential.user?.uid ?? '';
      
      user.id = firebaseId;
      saveUserData(user);
      addNewUser(user);

      debugPrint('DebugX: Firebase Signup Successful, Firebase logged email- (${user.email}) FirebaseId- ($firebaseId)');
      return FirebaseAuthStatus(isSuccess: true, message: 'Signup Successful');
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
        case 'email-already-in-use':
          errorMessage = 'The account already exists for that email.';
        default:
          errorMessage = 'Firebase Exception: $e';
      }
      return FirebaseAuthStatus(isSuccess: false, message: errorMessage);
    } catch (e) {
      debugPrint('DebugX: Exception: $e');
      return FirebaseAuthStatus(isSuccess: false, message: 'Exception: $e');
    }
  }

  static void saveUserData(FirebaseUser user) {
    SharedPrefs.setBool(SharedPrefsKeys.isLoggedIn, true);
    if(user.id != null) {
      SharedPrefs.setString(SharedPrefsKeys.firebaseId, user.id!);
    }
    if(user.email != null) {
      SharedPrefs.setString(SharedPrefsKeys.email, user.email!);
    }
    if(user.name != null) {
      SharedPrefs.setString(SharedPrefsKeys.name, user.name!);
    }
    if(user.username != null) {
      SharedPrefs.setString(SharedPrefsKeys.username, user.username!);
    }
  }

  static Future<FirebaseAuthStatus> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      debugPrint('DebugX: Firebase Logout Successful.');
      SharedPrefs.clear();
      return FirebaseAuthStatus(isSuccess: true, message: 'Logout Successful');
    } on FirebaseAuthException catch (e) {
      return FirebaseAuthStatus(isSuccess: false, message: 'Firebase Exception: $e');
    } catch (e) {
      debugPrint('DebugX: Exception: $e');
      return FirebaseAuthStatus(isSuccess: false, message: 'Exception: $e');
    }
  }

  static void onMessagesReceived(List<ChatMessage> messages) {
    for (var msg in messages) {
      listener(msg);

      /*switch (msg.body.type) {
        case MessageType.TXT:
          {
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;
            listener(
              "receive text message: ${body.content}, from: ${msg.from}",
            );
          }
          break;
        case MessageType.IMAGE:
          {
            listener(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VIDEO:
          {
            listener(
              "receive video message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.LOCATION:
          {
            listener(
              "receive location message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VOICE:
          {
            listener(
              "receive voice message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.FILE:
          {
            listener(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CUSTOM:
          {
            listener(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.COMBINE:
          {
            listener(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CMD:
          {
            // Receiving command messages does not trigger the `onMessagesReceived` event, but triggers the `onCmdMessagesReceived` event instead.
          }
          break;
      }*/
    }
  }

  static Future<FirebaseStatus> sendMessage({required Friend reciever, required String message, Function(ChatMessage message)? onSend}) async {
    if (reciever.id == null || reciever.id!.isEmpty) {
      debugPrint("Reciever Id is Empty");
      return FirebaseStatus(isSuccess: false, message: 'Error: Reciever Id is Empty');
    }
    String senderId = SharedPrefs.getString(SharedPrefsKeys.firebaseId) ?? '';
    String? senderUserName = SharedPrefs.getString(SharedPrefsKeys.username);

    if (senderId.isEmpty) {
      debugPrint("Sender Id is Empty");
      return FirebaseStatus(isSuccess: false, message: 'Error: Sender Id is Empty');
    }

    var msg = ChatMessage(
      senderKey: senderId,
      recieverKey: reciever.id!,
      message: message,
      messageType: MessageType.text, 
      from: senderUserName,
      to: reciever.username
    );
    final key = database
        .ref(FirebaseCollection.chat)
        .child(senderId)
        .child(reciever.id!)
        .child('messages').push().key ?? '';
    
    if(key.isEmpty) return FirebaseStatus(isSuccess: false, message: 'Error: Push Key is Empty');

    final unreadCount = await getUnreadCount(conversationId: reciever.conversationId, userId: senderId);

    setUnreadCount(conversationId: reciever.conversationId, userId: senderId, count: unreadCount+1);

    await database
      .ref(FirebaseCollection.chat)
      .child(reciever.conversationId!)
      .child('messages')
      .child(key)
      .set(msg.toJson());

    onSend?.call(msg);
    return FirebaseStatus(isSuccess: false, message: 'Messege send Successfully');
  }

  static listenChatStream({required FirebaseUser reciever, required Function(ChatMessage message) onMessage}) {
    // getChatStream(reciever: reciever).listen((event) {
    //   final rawMap = event.snapshot.value as Map<Object?, Object?>;
    //   final rawChatMap = rawMap.values.elementAt(0) as Map<Object?, Object?>;
    //   final chatMap = rawChatMap.map((key, val) => MapEntry(key.toString(), val));
    //   ChatMessage chatMessage = ChatMessage.fromJson(chatMap);
    //   onMessage.call(chatMessage);
    // });
  }

  static Query getChatStream({required String conversationId})  {
    if (conversationId.isEmpty) {
      debugPrint("conversationId is Empty");
      // yield* Stream.error(FirebaseStatus(isSuccess: false, message: 'Error: Reciever Id is Empty'));
    }

    return database
      .ref(FirebaseCollection.chat)
      .child(conversationId)
      .child('messages')
      .orderByKey();
  }

  /// Loads chat history for a given conversation.
  /// [conversationId] is the target user ID or group ID depending on the conversation type.
  /// [pageSize] determines how many messages to load in one call.
  static Future<List<ChatMessage>> loadChatHistory(String conversationId, {int pageSize = 200}) async {
    return [];
    // // Get the conversation instance.
    // // For one-to-one chat, use ChatConversationType.Chat;
    // // for group chats, you might use ChatConversationType.Group.
    // ChatConversation? conversation = await ChatClient.getInstance.chatManager.getConversation(
    //   conversationId,
    //   type: ChatConversationType.Chat, // Change to ChatConversationType.Group for group chats.
    //   // createIfNeed: true,
    // );

    // // Load historical messages.
    // // Passing an empty string ("") tells the SDK to load starting from the latest message.
    // List<ChatMessage> messages = await conversation?.loadMessages(loadCount: pageSize) ?? [];
    // return messages;
  }

  static String get currentTimeStamp {
    return DateTime.now().toString().split(".").first;
  }
  
  static void addNewUser(FirebaseUser user) async {
    String? firebaseID = SharedPrefs.getString(SharedPrefsKeys.firebaseId);
    if(firebaseID == null) return;
    try {
      await database
        .ref(FirebaseCollection.users)
        .child(firebaseID)
        .set(user.toJson());
    } on Exception catch (e) {
      debugPrint('DebugX: Exception: $e');
    }
  }

  static Future<FirebaseUser?> getLoggedUserData({required String firebaseID}) async {
    try {
      final data = await database
        .ref(FirebaseCollection.users)
        .child(firebaseID)
        .get();
      final userMap = MapUtils.rawMapToMapStringDynamic(data.value);
      userMap['id'] = firebaseID;
      return FirebaseUser.fromJson(userMap);
    } on Exception catch (e) {
      debugPrint('DebugX: Exception: $e');
      return null;
    }
  }

  static Future<List<FirebaseUser>> getAllUsers() async {
    try {
      final snapshot = await database
        .ref(FirebaseCollection.users)
        .get();
      if(snapshot.value == null) return [];
      final allUserMap = MapUtils.rawMapToMapStringDynamic(snapshot.value);
      allUsers = [];
      for (var firebaseId in allUserMap.keys) {
        if(allUserMap[firebaseId] != null) {
          final userMap = MapUtils.rawMapToMapStringDynamic(allUserMap[firebaseId]);
          final user = FirebaseUser.fromJson(userMap);
          user.id = firebaseId;
          allUsers.add(user);
        }
      }
      debugPrint('DebugX: All Users fetched successfully');
      return allUsers;
    } on Exception catch (e) {
      debugPrint('DebugX: Exception: $e');
      return allUsers;
    }
  }

  static Future<FirebaseStatus> addFriend(FirebaseUser firebaseUser, {bool acceptRequest = false}) async {
    try {
      String? firebaseID = SharedPrefs.getString(SharedPrefsKeys.firebaseId);
      if(firebaseID == null || firebaseUser.id == null) return FirebaseStatus(isSuccess: false, message: 'Error: Invalid Credentials');

      final conversationId = database
        .ref(FirebaseCollection.friends)
        .push()
        .key ?? '';
      
      /// Adding Friend in Current User
      await database
        .ref(FirebaseCollection.friends)
        .child(firebaseID)
        .child(firebaseUser.id!)
        .set({
          'conversation_id' : conversationId,
          'request_status': acceptRequest ? FriendRequestStatus.accepted : FriendRequestStatus.pending
        });
      
      /// Adding Friend Request in Other User
      await database
        .ref(FirebaseCollection.friends)
        .child(firebaseUser.id!)
        .child(firebaseID)
        .set({
          'conversation_id' : conversationId,
          'request_status':  acceptRequest ? FriendRequestStatus.accepted : FriendRequestStatus.recieved
        });
      
      /// Adding Participant ids in the chat conversation
      if(acceptRequest) {
        await database
        .ref(FirebaseCollection.chat)
        .child(conversationId)
        .child('participants')
        .set([firebaseUser.id, firebaseID]);
      }

      debugPrint('DebugX: Friend Added successfully - User : $firebaseUser');
      return FirebaseStatus(isSuccess: true, message: 'Friend Added successfully');
    } on Exception catch (e) {
      debugPrint('DebugX: Exception: $e');
      return FirebaseStatus(isSuccess: false, message: 'Exception: $e');
    }
  }

  static Future<List<Friend>> getAllFriends() async {
    try {
      String? firebaseID = SharedPrefs.getString(SharedPrefsKeys.firebaseId);
      if(firebaseID == null) return [];

      final snapshot = await database
        .ref(FirebaseCollection.friends)
        .child(firebaseID)
        .get();
      if(snapshot.value == null) return [];

      final allFriendsMap = MapUtils.rawMapToMapStringDynamic(snapshot.value);
      allFriends = [];
      for (var user in allUsers) {
        if(allFriendsMap.containsKey(user.id)) {
          final friendMap = MapUtils.rawMapToMapStringDynamic(allFriendsMap[user.id]);
          final friend = Friend.fromJson({...user.toJson() , ...friendMap});
          friend.unreadCount = await getUnreadCount(conversationId: friend.conversationId, userId: friend.id);
          allFriends.add(friend);
        }
      }
      debugPrint('DebugX: Friend List fetched successfully');
      return allFriends;
    } on Exception catch (e) {
      debugPrint('DebugX: Exception: $e');
      return allFriends;
    }
  }
  
  static Future<int> getUnreadCount({required String? conversationId, required String? userId}) async {
    if(conversationId == null || userId == null) return 0;
    final count = await database
      .ref(FirebaseCollection.chat)
      .child(conversationId)
      .child('inbox')
      .child(userId)
      .child('unread_count').get();

    return count.value != null ? count.value as int : 0;
  }
  
  static void setUnreadCount({required String? conversationId, required String? userId, required int count}) async {
    if(conversationId == null || userId == null) return;
    await database
      .ref(FirebaseCollection.chat)
      .child(conversationId)
      .child('inbox')
      .child(userId)
      .child('unread_count').set(count);
  }
}