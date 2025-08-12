import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/managers/chat_socket_manager/chat_socket_manager.dart';
import 'package:acepadel/managers/chat_socket_manager/chat_socket_state.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import '../../app_styles/app_text_styles.dart';
import '../../components/custom_textfield.dart';
import '../../components/secondary_text.dart';
import '../../globals/constants.dart';
import '../../globals/images.dart';
import '../../managers/user_manager.dart';
import '../../models/chat_socket_chat_message_model.dart';
import '../../models/chat_socket_join_model.dart';
import '../../routes/app_pages.dart';
import '../responsive_widgets/home_responsive_widget.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final int matchId;

  const ChatScreen({super.key, required this.matchId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late Stream<ChatSocketState> stream;
  bool changeScroll = true;
  final ScrollController _scrollController = ScrollController();
  final FocusNode node = FocusNode();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      bool value = ref
          .read(chatSocketProvider.notifier)
          .sendMessage(_controller.text.trim());
      if (value) {
        _controller.clear();
      }
    }
  }

  @override
  void initState() {
    connectSocket();
    super.initState();
  }

  void connectSocket() {
    ref.read(chatSocketProvider.notifier).connect(matchId: widget.matchId);
    stream = ref.read(chatSocketProvider.notifier).stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: GestureDetector(
            onTap: () {
              Utils.closeKeyboard();
            },
            child: HomeResponsiveWidget(
              child: _body(),
            ),
          )),
    );
  }

  Widget _body() {
    final userId = ref.read(userManagerProvider).user?.user?.id;
    return Column(
      children: [
        SizedBox(height: 35.5.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 17.w),
            child: InkWell(
              onTap: () => ref.read(goRouterProvider).pop(),
              child: Image.asset(
                AppImages.backArrow.path,
                width: 24.w,
                height: 24.w,
              ),
            ),
          ),
        ),
        Text(
          "CHAT".tr(context),
          style: AppTextStyles.panchangBold18
              .copyWith(height: 0.9, color: AppColors.darkGreen),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15.h),
        Expanded(
            child: StreamBuilder<ChatSocketState>(
          stream: stream, // Stream of messages
          builder: (context, snapshot) {
            // Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }

            // Error state
            if (snapshot.hasError) {
              return Center(
                  child: SecondaryText(text: snapshot.error.toString()));
            }

            // No data state
            if (!snapshot.hasData || snapshot.data!.chats.isEmpty) {
              return Center(
                  child: Text('${"NO_MESSAGES_AVAILABLE".tr(context)}.'));
            }

            // Chat data state
            List<Message> messages = snapshot.data!.chats;
            List<Admin> admins = snapshot.data!.admin;
            List<Users> users = snapshot.data!.users;

            if (changeScroll) {
              changeScroll = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent + 30);
              });
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              primary: false,
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isSend = message.customerId == userId;
                String value = message.message ?? "";

                String name = "";
                String role = "";

                bool isOrganizer = false;
                bool isPlayer = message.customerId != null;

                if (!isSend) {
                  if (message.customerId != null) {
                    int index = users.indexWhere(
                        (e) => e.customer?.id == message.customerId);
                    if (index != -1) {
                      name =
                          "${users[index].customer?.firstName ?? ""} ${users[index].customer?.lastName ?? ""}";
                      isOrganizer = users[index].isOrganizer ?? false;
                      role = isOrganizer ? "ORGANIZER" : "PLAYER";
                    }
                  } else if (message.adminId != null) {
                    int index =
                        admins.indexWhere((e) => e.id == message.adminId);
                    if (index != -1) {
                      name = admins[index].fullName ?? "";
                      role = chatRoles[admins[index].roleId ?? 0] ?? "ADMIN";
                    }
                  }
                }

                String time = (DateTime.tryParse(message.createdAt ?? "") ??
                        DateTime.now())
                    .format("HH:mm");
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Align(
                    alignment:
                        isSend ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: isSend ? AppColors.yellow : AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(-5, 5),
                              spreadRadius: 1,
                            )
                          ]),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (!isSend)
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          "$name (${role.trU(context)})",
                                          style: AppTextStyles.panchangBold11
                                              .copyWith(
                                                  color: isPlayer
                                                      ? AppColors.green
                                                      : AppColors.blue35),
                                          textAlign: TextAlign.start,
                                        )),
                                  Text(
                                    value,
                                    style: AppTextStyles.helveticaLight14
                                        .copyWith(color: AppColors.darkGreen),
                                    textAlign: TextAlign.start,
                                  )
                                ],
                              )),
                          SizedBox(width: 5.w),
                          Text(
                            time,
                            style: AppTextStyles.helveticaLight12
                                .copyWith(color: AppColors.darkGreen70),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )),
        Container(
            height: 85.h,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: CustomTextField(
              node: node,
              hintText: "TYPE_HERE".tr(context),
              controller: _controller,
              contentPadding: EdgeInsets.only(
                  left: 15.w, top: 15.h, bottom: 15.h, right: 15.w),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular((10).r),
                  borderSide: const BorderSide(color: AppColors.darkGreen90)),
              fillColor: Colors.transparent,
              keyboardType: TextInputType.text,
              suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: InkWell(
                    onTap: _sendMessage,
                    child: const Icon(Icons.send, color: AppColors.darkGreen90),
                  )),
              onFieldSubmitted: (String value) {
                _sendMessage();
              },
            ))
      ],
    );
  }
}
