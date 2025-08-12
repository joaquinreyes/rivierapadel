import 'package:acepadel/models/applicat_socket_response.dart';
import 'package:acepadel/models/approve_request_socket_response.dart';

class SocketState {
  final List<ApplicantSocketResponse> applicantsData;
  final List<ApprovedRequest_SocketResponse> approvedRequestData;

  SocketState({
    required this.applicantsData,
    required this.approvedRequestData,
  });

  factory SocketState.initial() {
    return SocketState(
      applicantsData: [],
      approvedRequestData: [],
    );
  }

  SocketState copyWith({
    List<ApplicantSocketResponse>? applicantsData,
    List<ApprovedRequest_SocketResponse>? approvedRequestData,
  }) {
    return SocketState(
      applicantsData: applicantsData ?? this.applicantsData,
      approvedRequestData: approvedRequestData ?? this.approvedRequestData,
    );
  }
}
