
import 'package:say_it/app_router.dart';
import 'package:say_it/constants/app_colors.dart';
import 'package:say_it/constants/constants.dart';
import 'package:say_it/constants/date_formats.dart';
import 'package:say_it/data/local/shared_prefs.dart';
import 'package:say_it/data/models/chat_message.dart';
import 'package:say_it/data/models/friend.dart';
import 'package:say_it/data/remote/firebase/firebase_client.dart';
import 'package:say_it/utils/extensions.dart';
import 'package:say_it/utils/map_utils.dart';
import 'package:say_it/widgets/input_text_feild.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {
  Friend? receiver;

  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  final List<ChatMessage> chatMessages = [];

  @override
  void initState() {
    receiver = AppRouter.getArguments<Friend>();
    super.initState();
    
    // FirebaseClient.listenChatStream(onMessage: (message) => chatListener(message), reciever: widget.receiver);
    // FirebaseClient.addChatListener();
    // FirebaseClient.loadChatHistory(widget.receiver.id!).then((chatHistory) {
    //   setState(() {
    //     chatMessages.addAll(chatHistory);
    //   });
    // });
  }

  @override
  void dispose() {
    FirebaseClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        leadingWidth: 35,
        title: Text(receiver?.name ?? '', style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.appColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: FirebaseAnimatedList(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              controller: scrollController,
              // sort: (a, b) {
              //   ChatMessage aMsg = ChatMessage.fromJson(MapUtils.rawMapToMapStringDynamic(a.value));
              //   ChatMessage bMsg = ChatMessage.fromJson(MapUtils.rawMapToMapStringDynamic(a.value));
              //   return aMsg.createdAt!.compareTo(bMsg.createdAt!);
              // },
              query: FirebaseClient.getChatStream(conversationId : receiver?.conversationId ?? ''), itemBuilder: (context, snap, animation, index) {
                ChatMessage chatMessage = ChatMessage.fromJson(MapUtils.rawMapToMapStringDynamic(snap.value));
                bool isReciever = chatMessage.from == receiver?.username;
                  bool isSender = chatMessage.from == SharedPrefs.getString(SharedPrefsKeys.username);
            
                  return Row(
                    mainAxisAlignment: isReciever ? MainAxisAlignment.start : isSender ? MainAxisAlignment.end : MainAxisAlignment.center,
                    children: [
                      Card(
                        color: isReciever ? AppColors.white : isSender ? AppColors.appColor : AppColors.blue.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: isSender ? const Radius.circular(15) : Radius.zero,
                            bottomRight: isReciever ? const Radius.circular(15) : Radius.zero,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 6, bottom: 6, left: isSender ? 15 : 12, right: isReciever ? 15 : 12),
                          child: Column(
                            crossAxisAlignment: isReciever ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                            children: [
                              Text(
                                chatMessage.message,
                                style: TextStyle(color: isReciever ? AppColors.black : AppColors.white, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                chatMessage.createdAt?.toDateString(DateFormats.hhmma) ?? '',
                                style: TextStyle(fontSize: 9, color: isReciever ? AppColors.black : AppColors.white),
                              ),
                            ],
                          ),
                        )),
                    ],
                  );
                
            }),
          ),

          // Flexible(
          //   child: ListView.builder(
          //     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          //     controller: scrollController,
          //     itemBuilder: (_, index) {
          //       bool isReciever = chatMessages[index].from == widget.receiver.username;
          //       bool isSender = chatMessages[index].from == SharedPrefs.getString(SharedPrefsKeys.username);

          //       return Row(
          //         mainAxisAlignment: isReciever ? MainAxisAlignment.start : isSender ? MainAxisAlignment.end : MainAxisAlignment.center,
          //         children: [
          //           Card(
          //             color: isReciever ? AppColors.white : isSender ? AppColors.appColor : AppColors.blue.shade300,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.only(
          //                 topLeft: const Radius.circular(15),
          //                 topRight: const Radius.circular(15),
          //                 bottomLeft: isSender ? const Radius.circular(15) : Radius.zero,
          //                 bottomRight: isReciever ? const Radius.circular(15) : Radius.zero,
          //               ),
          //             ),
          //             child: Padding(
          //               padding: EdgeInsets.only(top: 6, bottom: 6, left: isSender ? 15 : 12, right: isReciever ? 15 : 12),
          //               child: Column(
          //                 crossAxisAlignment: isReciever ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          //                 children: [
          //                   Text(
          //                     chatMessages[index].message,
          //                     style: TextStyle(color: isReciever ? AppColors.black : AppColors.white, fontWeight: FontWeight.w600),
          //                   ),
          //                   const SizedBox(height: 4),
          //                   Text(
          //                     chatMessages[index].createdAt?.toDateString(DateFormats.hhmma) ?? '',
          //                     style: TextStyle(fontSize: 9, color: isReciever ? AppColors.black : AppColors.white),
          //                   ),
          //                 ],
          //               ),
          //             )),
          //         ],
          //       );
          //     },
          //     itemCount: chatMessages.length,
          //   ),
          // ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: MediaQuery.of(context).viewInsets.bottom + 15),
        child: Row(
          children: [
            Expanded(
              child: InputTextField(
                controller: messageController,
                hintText: "Type message"
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                if(receiver == null) return;
                FirebaseClient.sendMessage(reciever: receiver!, message: messageController.text, onSend: (message) {
                  chatListener(message);
                });
                messageController.clear();
              },
              child: const Icon(Icons.send, size: 30, color: AppColors.appColor),
            ),
          ],
        ),
      ),
    );
  }

  void chatListener(ChatMessage message) {
    chatMessages.add(message);
    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }
}