import 'package:flutter/material.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> chatRooms;

  const ChatListScreen({Key? key, required this.chatRooms}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final Color mintColor = const Color(0xFFBCE0D8);
  bool isGroupSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))]
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28), onPressed: () => Navigator.pop(context)),
                  const Spacer(),
                  const Icon(Icons.search, color: Colors.black87, size: 26),
                  const SizedBox(width: 15),
                  const Icon(Icons.notifications_outlined, color: Colors.black87, size: 26),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("채팅", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildFilterChip("그룹", isGroupSelected, () => setState(() => isGroupSelected = true)),
                    const SizedBox(width: 10),
                    _buildFilterChip("개인", !isGroupSelected, () => setState(() => isGroupSelected = false)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.chatRooms.isEmpty ? _buildEmptyState() : _buildChatList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.black87 : Colors.grey.shade300, width: isSelected ? 1.5 : 1),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.black87 : Colors.grey.shade500, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600)),
      ),
    );
  }

  // 채팅이 없을 때 표시될 UI
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: mintColor.withOpacity(0.6)),
          const SizedBox(height: 20),
          const Text("아직 채팅이 없습니다.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 10),
          Text("스터디나 팀플에 지원하고 대화를 시작해보세요!", style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // 채팅 목록 UI
  Widget _buildChatList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.chatRooms.length,
      itemBuilder: (context, index) {
        final room = widget.chatRooms[index];
        // 마지막 채팅 메시지 미리보기용 추출
        String lastMessage = room['messages'].isNotEmpty ? room['messages'].last['text'] : "대화를 시작해보세요.";

        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ChatRoomScreen(roomData: room),
            )).then((value) => setState(() {})); // 돌아왔을 때 마지막 메시지 갱신
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blueAccent.shade100,
                  child: const Icon(Icons.people, color: Colors.white),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(room['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                          Icon(Icons.person_outline, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 2),
                          Text(room['members'] ?? "N명", style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(lastMessage, style: TextStyle(fontSize: 13, color: Colors.grey.shade500), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}