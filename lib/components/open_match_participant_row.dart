import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/avaialble_slot_widget.dart';
import 'package:acepadel/components/participant_slot.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/models/base_classes/booking_player_base.dart';

class OpenMatchParticipantRowWithBG extends StatelessWidget {
  const OpenMatchParticipantRowWithBG({
    super.key,
    required this.textForAvailableSlot,
    this.availableSlotbackGroundColor = AppColors.green5,
    this.players = const [],
    this.onTap,
    this.showReserveReleaseButton = false,
    this.allowBackground = true,
    this.currentPlayerID = -1,
    this.bgColor,
    this.onRelease,
    this.maxPlayers = 4,
    this.availableSlotIconColor = AppColors.darkBlue,
    this.textColor = AppColors.darkBlue,
    this.onPlayerTap,
  });
  final Color availableSlotbackGroundColor;
  final bool allowBackground;
  final Color availableSlotIconColor;
  final Color textColor;
  final List<BookingPlayerBase> players;
  final String textForAvailableSlot;
  final Function(int, int?)? onTap;
  final bool showReserveReleaseButton;
  final int currentPlayerID;
  final Function(int)? onRelease;
  final int maxPlayers;
  final Function(int, bool)? onPlayerTap;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      width: double.infinity,
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color:
            bgColor ?? (allowBackground ? AppColors.gallery : AppColors.white),
        borderRadius: BorderRadius.circular(7.r),
        boxShadow: [
          if (allowBackground)
            const BoxShadow(
              color: Color(0x11000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
        ],
      ),
      child: OpenMatchParticipantRow(
        textForAvailableSlot: textForAvailableSlot,
        availableSlotbackGroundColor: availableSlotbackGroundColor,
        players: players,
        textColor: textColor,
        onTap: onTap,
        showReserveReleaseButton: showReserveReleaseButton,
        currentCustomerID: currentPlayerID,
        onRelease: onRelease,
        maxPlayers: maxPlayers,
        availableSlotIconColor: availableSlotIconColor,
      ),
    );
  }
}

class OpenMatchParticipantRow extends StatefulWidget {
  const OpenMatchParticipantRow({
    super.key,
    required this.textForAvailableSlot,
    this.availableSlotbackGroundColor = AppColors.green5,
    this.players = const [],
    this.onTap,
    this.showReserveReleaseButton = false,
    this.currentCustomerID = -1,
    this.onRelease,
    this.maxPlayers = 4,
    this.availableSlotIconColor = AppColors.darkBlue,
    this.textColor = AppColors.darkBlue,
    this.onPlayerTap,
  });

  final Color availableSlotbackGroundColor;
  final List<BookingPlayerBase> players;
  final String textForAvailableSlot;
  final Function(int, int?)? onTap;
  final bool showReserveReleaseButton;
  final int currentCustomerID;
  final Function(int)? onRelease;
  final int maxPlayers;
  final Color availableSlotIconColor;
  final Color textColor;
  final Function(int, bool)? onPlayerTap;
  @override
  State<OpenMatchParticipantRow> createState() =>
      _OpenMatchParticipantRowState();
}

class _OpenMatchParticipantRowState extends State<OpenMatchParticipantRow> {
  List<BookingPlayerBase> teamA = [];
  List<BookingPlayerBase> teamB = [];
  List<Widget> playerWidgets = [];

  int currentPlayerID = -1;
  @override
  void initState() {
    int index = widget.players.indexWhere(
        (element) => element.customer?.id == widget.currentCustomerID);

    if (index != -1) {
      currentPlayerID = widget.players[index].id ?? -1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showReserveReleaseButton && widget.currentCustomerID == -1) {
      return Container();
    }
    setWidget();
    for (int i = 0; i < playerWidgets.length; i++) {
      final player = playerWidgets[i];
      int flex = 1;
      if (player is ParticipantSlot) {
        if (player.showReleaseReserveButton == true) {
          flex = 2;
        }
      }
      playerWidgets[i] = Expanded(
        flex: flex,
        child: playerWidgets[i],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: playerWidgets,
    );
  }

  SizedBox _buildVsWidget() {
    return SizedBox(
      height: 81.h,
      child: Column(
        children: [
          const Spacer(),
          AutoSizeText(
            'V/S',
            maxFontSize: 12,
            minFontSize: 8,
            maxLines: 1,
            stepGranularity: 1,
            textAlign: TextAlign.center,
            style: AppTextStyles.gothamBold14.copyWith(
              color: widget.textColor,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  setWidget() {
    playerWidgets = [];
    for (int i = 0; i < widget.maxPlayers; i++) {
      playerWidgets.add(
        AvailableSlotWidget(
          index: i,
          otherTeamMemberID: null,
          text: widget.textForAvailableSlot,
          backgroundColor: widget.availableSlotbackGroundColor,
          onTap: widget.onTap,
          iconColor: widget.availableSlotIconColor,
          textColor: widget.textColor,
        ),
      );
    }

    List<BookingPlayerBase> playersWithoutPosition = [];
    _setPlayers(playersWithoutPosition);

    _setPlayersWithoutPos(playersWithoutPosition);

    if (widget.maxPlayers > 2) {
      playerWidgets.insert(2, _buildVsWidget());
    }
  }

  void _setPlayersWithoutPos(List<BookingPlayerBase> playersWithoutPosition) {
    for (final player in playersWithoutPosition) {
      final nextAvailablePosition = findNextAvailablePosition();
      if (nextAvailablePosition != -1) {
        bool showReleaseReserveButton = ((player.reserved ?? false) &&
            widget.showReserveReleaseButton &&
            player.customer?.id == widget.currentCustomerID);
        playerWidgets[nextAvailablePosition] = ParticipantSlot(
          player: player,
          onRelease: widget.onRelease,
          showReleaseReserveButton: showReleaseReserveButton,
          textColor: widget.textColor,
          onPlayerTap: widget.onPlayerTap,
        );
      }
    }
  }

  void _setPlayers(List<BookingPlayerBase> playersWithoutPosition) {
    for (int i = 0;
        i <
            (widget.players.length > widget.maxPlayers
                ? widget.players.length
                : math.min(widget.players.length, widget.maxPlayers));
        i++) {
      final player = widget.players[i];
      final position = widget.players[i].position;
      if (position == null || position > widget.maxPlayers) {
        player.position = null;
        playersWithoutPosition.add(player);
      } else {
        bool showReleaseReserveButton = ((player.reserved ?? false) &&
            widget.showReserveReleaseButton &&
            player.customer?.id == widget.currentCustomerID);
        if (!(player.isCanceled ?? false)) {
          playerWidgets[position - 1] = ParticipantSlot(
            player: player,
            onRelease: widget.onRelease,
            showReleaseReserveButton: showReleaseReserveButton,
            textColor: widget.textColor,
            onPlayerTap: widget.onPlayerTap,
          );
        }
      }
    }
  }

  findNextAvailablePosition() {
    for (int i = 0; i < widget.maxPlayers; i++) {
      if (playerWidgets[i] is AvailableSlotWidget) {
        return i;
      }
    }
    return -1;
  }

  setTeamA() {
    teamA = [];
    if (widget.players.isEmpty) return;
    final player = widget.players.first;
    teamA.add(player);
    final otherPlayerID = player.otherPlayer;
    if (otherPlayerID == null) return;
    final otherPlayerIndex =
        widget.players.indexWhere((element) => element.id == otherPlayerID);
    if (otherPlayerIndex == -1) return;
    teamA.add(widget.players[otherPlayerIndex]);
  }

  setTeamB() {
    teamB = [];
    final playersWithoutTeamA =
        widget.players.where((element) => !teamA.contains(element)).toList();
    if (playersWithoutTeamA.isEmpty) return;
    final player = playersWithoutTeamA.first;
    teamB.add(player);
    final otherPlayerID = player.otherPlayer;
    if (otherPlayerID == null) return;
    final otherPlayerIndex = playersWithoutTeamA
        .indexWhere((element) => element.id == otherPlayerID);
    if (otherPlayerIndex == -1) return;
    teamB.add(player);
    teamB.add(playersWithoutTeamA[otherPlayerIndex]);
  }
}
