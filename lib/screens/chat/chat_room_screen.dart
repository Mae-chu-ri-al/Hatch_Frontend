import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatRoomScreen extends StatefulWidget {
  final Map<String, dynamic> roomData;

  const ChatRoomScreen({Key? key, required this.roomData}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final Color mintColor = const Color(0xFFBCE0D8);
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    // 부모로부터 받아온 채팅 리스트 참조
    _messages = widget.roomData['messages'] ?? [];
  }

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "text": _msgController.text.trim(),
        "isMe": true, // 임시로 모두 내가 보낸 것으로 처리
        "time": DateFormat('a h:mm', 'ko_KR').format(DateTime.now()),
        "unread": 1, // 읽지 않은 사람 수 임시 값
      });
      _msgController.clear();
    });

    // 메시지 보낸 후 스크롤을 맨 아래로 이동
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))]
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28), onPressed: () => Navigator.pop(context)),
                  CircleAvatar(radius: 18, backgroundColor: Colors.blueAccent.shade100, child: const Icon(Icons.people, color: Colors.white, size: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.roomData['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 12, color: Colors.grey.shade600),
                            const SizedBox(width: 2),
                            Text(widget.roomData['members'] ?? "N명", style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.black87, size: 26),
                  const SizedBox(width: 15),
                  const Icon(Icons.menu, color: Colors.black87, size: 26),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg['text'], msg['isMe'], msg['time'], msg['unread']);
              },
            ),
          ),
          // 하단 텍스트 입력부
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300))
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: const InputDecoration(
                          hintText: "메시지를 입력하세요.",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  InkWell(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      color: mintColor.withOpacity(0.5),
                      child: const Text("전송", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 채팅 말풍선 UI 컴포넌트
  Widget _buildMessageBubble(String text, bool isMe, String time, int unreadCount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMe) _buildTimeAndUnread(time, unreadCount, isMe),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? Colors.white : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : const Radius.circular(15),
                ),
                border: isMe ? Border.all(color: Colors.grey.shade300) : null,
              ),
              child: Text(text, style: const TextStyle(fontSize: 15, color: Colors.black87)),
            ),
          ),
          if (!isMe) _buildTimeAndUnread(time, unreadCount, isMe),
        ],
      ),
    );
  }

  // 시간 및 읽음 표시 컴포넌트
  Widget _buildTimeAndUnread(String time, int unreadCount, bool isMe) {
    return Padding(
      padding: EdgeInsets.only(
          left: isMe ? 0 : 8.0,
          right: isMe ? 8.0 : 0,
          bottom: 2.0
      ),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (unreadCount > 0)
            Text(unreadCount.toString(), style: TextStyle(fontSize: 11, color: mintColor, fontWeight: FontWeight.bold)),
          Text(time, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}