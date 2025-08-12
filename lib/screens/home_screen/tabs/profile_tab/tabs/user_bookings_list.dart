import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/components/user_booking_card.dart';
import 'package:acepadel/components/user_lessons_events.dart';
import 'package:acepadel/components/user_open_match_card.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/models/user_bookings.dart';
import 'package:acepadel/repository/booking_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:acepadel/screens/home_screen/tabs/play_match_tab/tabs/tab_parent.dart';
import 'package:acepadel/utils/custom_extensions.dart';

class UserBookingsList extends ConsumerStatefulWidget {
  const UserBookingsList({super.key, this.isPast = false});
  final bool isPast;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpComingBookingsState();
}

class _UpComingBookingsState extends ConsumerState<UserBookingsList> {
  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(fetchUserAllBookingsProvider);
    return bookings.when(
      data: (data) => buildBookingList(context, data),
      loading: () => const CupertinoActivityIndicator(radius: 10),
      error: (error, stackTrace) => SecondaryText(text: error.toString()),
    );
  }

  Widget buildBookingList(BuildContext context, List<UserBookings> data) {
    List<UserBookings> bookings = [];
    if (widget.isPast) {
      bookings = data.where((e) => e.isPast).toList();
    } else {
      bookings = data.where((e) => !e.isPast).toList();
    }

    final currentCustomerID = ref.read(userProvider)?.user?.id ?? "";
    bookings.removeWhere((e) {
      int? index = e.players
          ?.indexWhere((element) => element.customer?.id == currentCustomerID);
      if (index == null || index == -1) {
        return false;
      } else {
        return false;
      }
    });

    if (bookings.isEmpty) {
      return SecondaryText(
        text: widget.isPast
            ? "NO_PAST_BOOKINGS".tr(context)
            : "NO_UPCOMING_BOOKINGS".tr(context),
      );
    }

    final dateList = bookings.dateList;
    if (widget.isPast) {
      dateList.sort((a, b) => b.compareTo(a));
    } else {
      dateList.sort((a, b) => a.compareTo(b));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buildBookingWidgets(dateList, bookings),
    );
  }

  List<Widget> buildBookingWidgets(
      List<DateTime> dateList, List<UserBookings> bookings) {
    final widgets = <Widget>[];

    for (var date in dateList) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Text(
            Utils.formatBookingDate(date, context),
            style: AppTextStyles.panchangBold13,
          ),
        ),
      );

      final dateBookings =
          bookings.where((e) => e.bookingDate == date).toList();

      widgets.addAll(
        dateBookings.map((booking) {
          final isOpenMatch = booking.service?.isOpenMatch ?? false;
          final isEvent = booking.service?.isEvent ?? false;
          final isLessonEvent = booking.service?.isLesson ?? false;
          return Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Builder(builder: (context) {
                if (isEvent || isLessonEvent) {
                  return InkWell(
                    onTap: () {
                      _onTap(isOpenMatch, isEvent, isLessonEvent, booking);
                    },
                    child: UserLessonsEventsCard(
                      booking: booking,
                    ),
                  );
                }
                if (isOpenMatch) {
                  return InkWell(
                    onTap: () {
                      _onTap(isOpenMatch, isEvent, isLessonEvent, booking);
                    },
                    child: UserOpenMatchCard(booking: booking),
                  );
                }
                return InkWell(
                  onTap: () {
                    _onTap(isOpenMatch, isEvent, isLessonEvent, booking);
                  },
                  child: UserBookingCard(
                    booking: booking,
                  ),
                );
              }),
            ),
          );
        }),
      );
    }
    return widgets;
  }

  _onTap(bool isOpenMatch, bool isEvent, bool isLessonEvent,
      UserBookings booking) {
    Future nav;
    if (isEvent || isLessonEvent) {
      if (isLessonEvent) {
        nav = ref
            .read(goRouterProvider)
            .push("${RouteNames.lessonInfo}/${booking.id}");
      } else {
        nav = ref
            .read(goRouterProvider)
            .push("${RouteNames.eventInfo}/${booking.id}");
      }
    } else if (isOpenMatch) {
      nav = ref
          .read(goRouterProvider)
          .push("${RouteNames.matchInfo}/${booking.id}");
    } else {
      nav = ref
          .read(goRouterProvider)
          .push("${RouteNames.bookingInfo}/${booking.id}");
    }
    nav.then((value) {
      ref.invalidate(fetchUserAllBookingsProvider);
    });
  }
}
