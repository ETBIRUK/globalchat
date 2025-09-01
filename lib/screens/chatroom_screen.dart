import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatroomScreen extends StatefulWidget {
  String chatroomName;
  String chatroomId;

  ChatroomScreen({
    super.key,
    required this.chatroomName,
    required this.chatroomId,
  });

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  var db = FirebaseFirestore.instance;

  TextEditingController messageText = TextEditingController();

  Future<void> sendMessage() async {
    if (messageText.text.isEmpty) {
      return;
    }

    Map<String, dynamic> messageTosend = {
      "text": messageText.text,
      "sender_name": Provider.of<Userprovider>
      (context, listen: false).userName,
      "sender_id": Provider.of<Userprovider>
      (context, listen: false).userId,
      "chatroom_id": widget.chatroomId,
      "timestamp": FieldValue.serverTimestamp(),
    };
     messageText.text = "";
    try {
      await db.collection("messages").add(messageTosend);
    } catch (e) {}
   
    // Function to send message
  }
  Widget singleChatItem( {required String sender_name,
  required String text, required String sender_id}) {
    return Column(
                        crossAxisAlignment:
                          sender_id == Provider.of<Userprovider>(context, 
                          listen: false).userId
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,

                        children: [
                           Padding(
                             padding: const EdgeInsets.only(left:8.0, right:6),
                             child: 
                             Text(sender_name,
                             style: TextStyle(fontWeight:
                              FontWeight.bold)),
                           ),
                          Container(
                            
                          decoration: BoxDecoration(
                            color: sender_id == Provider.of<Userprovider>(context, listen: false).userId
                                ? Colors.grey[300]
                                : Colors.blueGrey[900],
                            borderRadius: BorderRadius.circular(20)
                          ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(text, 
                              style: TextStyle(
                                color: sender_id == 
                                Provider.of<Userprovider>
                                (context, listen: false)
                                .userId
                                ? Colors.black
                                :Colors.white),),
                            )),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      );
                        
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatroomName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: db
              .collection("messages") .where("chatroom_id", isEqualTo: 
              widget. chatroomId)
              .limit(100)
              .orderBy("timestamp", descending: true)
              .snapshots(),
              builder: (context, snapshot) {

                if (snapshot.hasError){
                  print(snapshot.error);
                  return Text("some error occurred!");

                }

                var allMessages = snapshot.data?.docs ?? [];

                if (allMessages.length < 1) {
                  return Center(
                    child: Text("No messages here!"),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: allMessages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                     child: singleChatItem(sender_name:
                     allMessages[index]["sender_name"],
                     text: allMessages[index]["text"], 
                     sender_id: allMessages[index]["sender_id"]),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageText,
                      decoration: InputDecoration(
                        hintText: "write message here...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(onTap: sendMessage, child: Icon(Icons.send)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
