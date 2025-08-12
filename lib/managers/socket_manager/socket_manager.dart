import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/components/approved_applicant_dialogs/events/events_applicant_dialog.dart';
import 'package:acepadel/components/approved_applicant_dialogs/events/events_approved_request_dialog.dart';
import 'package:acepadel/components/approved_applicant_dialogs/open_match/open_match_applicants_dialog.dart';
import 'package:acepadel/components/approved_applicant_dialogs/open_match/open_match_approved_request_dialog.dart';
import 'package:acepadel/managers/socket_manager/socket_state.dart';
import 'package:acepadel/models/applicat_socket_response.dart';
import 'package:acepadel/models/approve_request_socket_response.dart';
import 'package:acepadel/repository/play_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/screens/event_detail/event_detail.dart';
import 'package:acepadel/screens/open_match_detail/open_match_detail.dart';
import 'package:socket_io_client/socket_io_client.dart' as id;

import '../../globals/constants.dart';

final socketProvider = StateNotifierProvider<SocketNotifier, SocketState>(
  (ref) => SocketNotifier(ref),
);

class SocketNotifier extends StateNotifier<SocketState> {
  late id.Socket _socket;
  Ref ref;

  SocketNotifier(this.ref) : super(SocketState.initial());

  void connect(int clubID, int userID, String token) {
    final l = "https://api.bookandgo.app/api/v1/apps/${clubID}/users/${userID}";
    myPrint('Connecting to: $l');
    _socket = id.io(
      l,
      id.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableReconnection()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket.onConnect((_) {
      myPrint('Connected');
    });

    _socket.on('applicants', (data) {
      final response = ApplicantSocketResponse.fromJson(data);
      state = state.copyWith(
        applicantsData: [...state.applicantsData, response], // Append new data
      );

      _showApplicantSocketDialog(response);
    });

    _socket.on('approved request', (data) {
      final response = ApprovedRequest_SocketResponse.fromJson(data);
      state = state.copyWith(
        approvedRequestData: [...state.approvedRequestData, response],
      );
      _showApprovedRequest(response);
    });

    _socket.onConnectError((error) {
      myPrint('Connection Error: $error');
    });

    _socket.onDisconnect((_) {
      myPrint('Disconnected');
    });

    _socket.connect();
  }

  void clearApplicantsData() {
    state = state.copyWith(applicantsData: []);
  }

  void clearApprovedRequestData() {
    state = state.copyWith(approvedRequestData: []);
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }

  void _showApplicantSocketDialog(ApplicantSocketResponse data) {
    final context = navigatorKey.currentContext;
    bool isEvent = data.serviceBooking?.service?.isEvent ?? false;
    if (context != null) {
      if (_checkIfDetailAlreadyOpen(
          context, data.serviceBooking?.id, isEvent)) {
        return;
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          if (isEvent) {
            return EventApplicantDialog(
              data: data,
            );
          }
          return OpenMatchApplicantDialog(
            data: data,
          );
        },
      );
    }
  }

  void _showApprovedRequest(ApprovedRequest_SocketResponse data) {
    final context = navigatorKey.currentContext;
    bool isEvent = data.serviceBooking?.service?.isEvent ?? false;
    if (context != null) {
      if (_checkIfDetailAlreadyOpen(
          context, data.serviceBooking?.id, isEvent)) {
        return;
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          if (isEvent) {
            return EventApprovedRequestDialog(data: data);
          }
          return OpenMatchApprovedRequestDialog(
            data: data,
          );
        },
      );
    }
  }

  bool _checkIfDetailAlreadyOpen(
      BuildContext context, int? serviceID, bool isEvent) {
    try {
      final navigator = context.widget as Navigator;
      final index =
          navigator.pages.indexWhere((element) => element is MaterialPage);

      final openMatchIndex = navigator.pages.indexWhere((element) {
        if (element is MaterialPage) {
          return isEvent
              ? element.child is EventDetail
              : element.child is OpenMatchDetail;
        }
        return false;
      });
      final details;
      if (isEvent) {
        details = (navigator.pages[openMatchIndex] as MaterialPage).child
            as EventDetail;
      } else {
        details = (navigator.pages[openMatchIndex] as MaterialPage).child
            as OpenMatchDetail;
      }
      if (details.matchId == serviceID) {
        ref.invalidate(fetchServiceWaitingPlayersProvider(
            details.matchId!, RequestServiceType.booking));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
