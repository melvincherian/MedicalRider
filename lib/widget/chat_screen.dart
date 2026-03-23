import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/chat_model.dart';
import 'package:medical_delivery_app/providers/chat_provider%20copy.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String riderId;
  final String chatPartnerName;
  final String currentUserType;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.riderId,
    required this.chatPartnerName,
    required this.currentUserType,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatProvider _chatProvider;
  Timer? _connectionCheckTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _initializeChat();
    _startConnectionCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectionCheckTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _chatProvider.checkConnectionStatus();
        break;
      default:
        break;
    }
  }

  void _startConnectionCheck() {
    _connectionCheckTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted) {
        _chatProvider.checkConnectionStatus();
      }
    });
  }

  void _initializeChat() async {
    await _chatProvider.initializeChat(
      userId: widget.userId,
      riderId: widget.riderId,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animate: false);
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    _scrollToBottom();

    final success = await _chatProvider.sendMessage(
      userId: widget.userId,
      riderId: widget.riderId,
      message: message,
      senderType: widget.currentUserType,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _chatProvider.error.isNotEmpty
                ? _chatProvider.error
                : 'Failed to send message',
          ),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () {
              _messageController.text = message;
              _sendMessage();
            },
          ),
        ),
      );
    }
  }

  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0) {
        if (animate) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
    final displayHour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    return '${displayHour.toString().padLeft(2, '0')}:$minute $amPm';
  }

  bool _isCurrentUser(ChatMessage message) {
    return message.senderType == widget.currentUserType;
  }

  Widget _buildConnectionStatus() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (!chatProvider.isConnected) {
          return Container(
            width: double.infinity,
            color: Colors.orange[100],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: Colors.orange, size: 16),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Reconnecting... Messages will be sent when connection is restored.',
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () => chatProvider.reconnectIfNeeded(),
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return Column(
            children: [
              // Header with map background
              Container(
                height: 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/mapimage.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Connection status dot
                        Container(
                          decoration: BoxDecoration(
                            color: chatProvider.isConnected
                                ? Colors.green
                                : Colors.red,
                            shape: BoxShape.circle,
                          ),
                          width: 12,
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Chat partner info
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.chatPartnerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Connection status banner
              _buildConnectionStatus(),

              // Divider
              Container(height: 1, color: Colors.grey[200]),

              // Chat messages area
              Expanded(
                child: Container(
                  color: Colors.grey[50],
                  child: chatProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF6C5CE7)),
                          ),
                        )
                      : chatProvider.messages.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No messages yet',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  Text(
                                    'Start a conversation!',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () => chatProvider.refreshChat(
                                userId: widget.userId,
                                riderId: widget.riderId,
                              ),
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                itemCount: chatProvider.messages.length,
                                itemBuilder: (context, index) {
                                  final message = chatProvider.messages[index];
                                  final isCurrentUser =
                                      _isCurrentUser(message);

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (index ==
                                        chatProvider.messages.length - 1) {
                                      _scrollToBottom();
                                    }
                                  });

                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: _buildMessageBubble(
                                        message, isCurrentUser),
                                  );
                                },
                              ),
                            ),
                ),
              ),

              // Message input area
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: SafeArea(
                  child: Row(
                    children: [
                      // Text input
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: _messageController,
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            decoration: const InputDecoration(
                              hintText: 'Write your message',
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 16),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Send button
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: chatProvider.isSending
                              ? Colors.grey
                              : const Color(0xFF6C5CE7),
                          shape: BoxShape.circle,
                        ),
                        child: chatProvider.isSending
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : IconButton(
                                onPressed: chatProvider.isSending
                                    ? null
                                    : _sendMessage,
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isCurrentUser) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: isCurrentUser
          ? [
              const Expanded(child: SizedBox()),
              Flexible(
                child: _buildMessageContent(message, isCurrentUser),
              ),
            ]
          : [
              const SizedBox(width: 8),
              Expanded(
                child: _buildMessageContent(message, isCurrentUser),
              ),
            ],
    );
  }

  Widget _buildMessageContent(ChatMessage message, bool isCurrentUser) {
    final isOrderMessage = message.message.startsWith('Order #');

    return Column(
      crossAxisAlignment: isCurrentUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (!isCurrentUser)
          Text(
            message.sender ?? widget.chatPartnerName,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          )
        else
          const Text(
            'You',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isCurrentUser ? const Color(0xFF6C5CE7) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isOrderMessage
                ? Border.all(
                    color: isCurrentUser
                        ? Colors.white.withOpacity(0.3)
                        : const Color(0xFF6C5CE7).withOpacity(0.3),
                    width: 1,
                  )
                : null,
            boxShadow: isCurrentUser
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isOrderMessage)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 16,
                      color: isCurrentUser
                          ? Colors.white
                          : const Color(0xFF6C5CE7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isCurrentUser
                            ? Colors.white
                            : const Color(0xFF6C5CE7),
                      ),
                    ),
                  ],
                ),
              if (isOrderMessage) const SizedBox(height: 8),
              Text(
                message.message,
                style: TextStyle(
                  fontSize: 16,
                  color: isCurrentUser ? Colors.white : Colors.black,
                  fontFamily: isOrderMessage ? 'monospace' : null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatTime(message.timestamp),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}