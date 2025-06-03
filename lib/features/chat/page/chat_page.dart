import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:servista/core/theme/app_font_weight.dart';
import 'package:servista/core/theme/color_value.dart'; // Untuk format waktu

// Model untuk representasi pesan chat

class ChatPage extends StatefulWidget {
  final String chatUser;
  const ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.trim().isEmpty) {
      return; //
    }

    // Dapatkan waktu saat ini
    final String currentTime = DateFormat('HH:mm').format(DateTime.now());

    // Buat objek pesan baru
    // Untuk contoh ini, kita akan bergantian mengirim pesan sebagai "saya" dan "orang lain"
    // Dalam aplikasi nyata, ini akan bergantung pada logika pengguna yang sebenarnya
    final newMessage = ChatMessage(
      text: text,
      time: currentTime,
      isMe: _messages.length % 2 == 0, // Bergantian untuk demo
    );

    // Tambahkan pesan ke list dan perbarui UI
    setState(() {
      _messages.insert(
        0,
        newMessage,
      ); // Tambahkan di awal agar pesan baru muncul di atas
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        toolbarTextStyle: textTheme.bodyMedium!.copyWith(
          fontSize: 18.sp,
          fontWeight: AppFontWeight.semiBold,
        ),
        toolbarHeight: 42.h,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/back_half_arrow.svg"),
          onPressed: () {
            Navigator.pop(context); //
          },
        ),
        title: Text(
          widget.chatUser,
          style: textTheme.bodyMedium!.copyWith(
            color: ColorValue.dark2Color,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Anda bisa menambahkan ikon atau widget lain di sini jika perlu
        ],
      ),
      body: Column(
        children: [
          Expanded(
            // Gunakan ListView.builder untuk performa yang lebih baik dengan daftar yang dinamis
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.only(top: 19.h, bottom: 19.h),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatBubble(
                    isMe: message.isMe,
                    message: message.text,
                    time: message.time,
                  );
                },
              ),
            ),
          ),
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  // Widget untuk area input pesan
  Widget _buildMessageInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 12.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              child: TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                // Panggil _handleSubmitted ketika tombol enter ditekan di keyboard
                onSubmitted: _handleSubmitted,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          IconButton(
            icon: const Icon(Icons.send, color: ColorValue.dark2Color),
            // Ubah warna ikon send
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

// Widget untuk gelembung chat (tetap sama)
class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String time;

  const ChatBubble({
    super.key,
    required this.isMe,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.0.h),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            color: isMe ? ColorValue.dark2Color : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              if (!isMe)
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: textTheme.bodyMedium!.copyWith(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                time,
                style: textTheme.bodyMedium!.copyWith(
                  color: isMe ? Colors.white70 : Colors.black54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatMessage {
  final String text;
  final String time;
  final bool isMe;

  ChatMessage({required this.text, required this.time, required this.isMe});
}
