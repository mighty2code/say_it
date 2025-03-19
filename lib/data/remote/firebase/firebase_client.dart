import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/data/local/shared_prefs.dart';
import 'package:chat_app/data/models/chat_message.dart';
import 'package:chat_app/data/models/firebase_auth_status.dart';
import 'package:chat_app/data/models/firebase_user.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseClient {
  static FirebaseDatabase database = FirebaseDatabase.instance;
  static List<FirebaseUser> allUsers = [];

  static Function(ChatMessage message) listener = (message) {
    debugPrint("$currentTimeStamp: $message");
  };

  static void setChatListener(Function(ChatMessage message) listenerFunction) {
    listener = listenerFunction;
  }

  static void initSDK() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  static dispose() {
    // ChatClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID");
  }

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
      user.id = firebaseId;
      SharedPrefs.setString(SharedPrefsKeys.firebaseId, firebaseId);
      SharedPrefs.setBool(SharedPrefsKeys.isLoggedIn, true);
      SharedPrefs.setString(SharedPrefsKeys.email, user.email!);
      final userData =  await getLoggedUserData();
      if(userData != null) {
        saveUserData(userData);
      }
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
      SharedPrefs.setString(SharedPrefsKeys.firebaseId, firebaseId);
      SharedPrefs.setBool(SharedPrefsKeys.isLoggedIn, true);
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

  static void addChatListener() {
    // ChatClient.getInstance.chatManager.addMessageEvent(
    //     "UNIQUE_HANDLER_ID",
    //     ChatMessageEvent(
    //       onSuccess: (msgId, msg) {
    //         debugPrint("send message succeed");
    //       },
    //       onProgress: (msgId, progress) {
    //         debugPrint("send message succeed");
    //       },
    //       onError: (msgId, msg, error) {
    //         debugPrint(
    //           "send message failed, code: ${error.code}, desc: ${error.description}",
    //         );
    //       },
    //     ));

    // ChatClient.getInstance.chatManager.addEventHandler(
    //   "UNIQUE_HANDLER_ID",
    //   ChatEventHandler(onMessagesReceived: onMessagesReceived),
    // );
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

  static void sendMessage({required String chatId, required String message, Function(ChatMessage message)? onSend}) async {
    // if (chatId.isEmpty) {
    //   debugPrint("single chat id or message content is null");
    //   return;
    // }

    // var msg = ChatMessage.createTxtSendMessage(
    //   targetId: chatId,
    //   content: message,
    // );

    // onSend?.call(msg);
    
    // ChatClient.getInstance.chatManager.sendMessage(msg);
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
  
  static void addNewUser(FirebaseUser user) {
    String? firebaseID = SharedPrefs.getString(SharedPrefsKeys.firebaseId);
    if(firebaseID == null) return;
    try {
      database
        .ref(FirebaseCollection.users)
        .child(firebaseID)
        .set(user.toJson());
    } on Exception catch (e) {
      debugPrint('DebugX: Exception: $e');
    }
  }

  static Future<FirebaseUser?> getLoggedUserData() async {
    String? firebaseID = SharedPrefs.getString(SharedPrefsKeys.firebaseId);
    if(firebaseID == null) return null;
    try {
      final data = await database
        .ref(FirebaseCollection.users)
        .child(firebaseID)
        .get();
      final value = data.value as Map<Object?, Object?>;
      final userMap = value.map((key, val) => MapEntry(key.toString(), val));
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
      final value = snapshot.value as Map<Object?, Object?>;
      final allUserMap = value.map((key, val) => MapEntry(key.toString(), val));
      allUsers = [];
      for (var firebaseId in allUserMap.keys) {
        if(allUserMap[firebaseId] != null) {
          final rawMap = allUserMap[firebaseId] as Map<Object?, Object?>;
          final userMap = rawMap.map((key, val) => MapEntry(key.toString(), val));
          final user = FirebaseUser.fromJson(userMap);
          user.id = firebaseId;
          allUsers.add(user);
        }
      }
      debugPrint('DebugX: Message fetched successfully');
      return allUsers;
    } on Exception catch (e) {
      debugPrint('DebugX: Exception: $e');
      return allUsers;
    }
  }

  // static void getMsgList() {
  //   try {
  //     database
  //       .ref(FirebaseCollection.messagesTable)
  //       .onValue.listen((event) {
  //         debugPrint(event.snapshot.value.toString());
  //       });
  //   } on Exception catch (e) {
  //     debugPrint('DebugX: Exception: $e');
  //   }
  // }

  static void sendDummyMessage() {
    try {
      final key = database.ref(FirebaseCollection.messagesTable).push().key ?? '';
      if (key.isNotEmpty) {
        database.ref(FirebaseCollection.messagesTable)
            .child(key)
            .set({"Position": "Flutter2"});
      }
      
    } on Exception catch (e) {
      debugPrint('DebugX: Exception: $e');
    }
  }
}

class FirebaseCollection {
  static const users = 'users';
  static const messagesTable = 'friends';
}