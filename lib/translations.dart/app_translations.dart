// import 'package:get/get.dart';

// import '../globals/constants.dart';

// class AppTranslations extends Translations {
//   @override
//   Map<String, Map<String, String>> get keys => {
//         "en_US": {
//           // Auth Screen
//           "sign_in": "Sign in",
//           "register": "Register",
//           // Sign In Screen
//           "welcome_back": "Welcome back",
//           "email": "Email",
//           "Number": "Number",
//           "password": "Password",
//           "forgot_my_password": "Forgot my password",
//           "recover_password": "Recover Password",
//           "enter_email_address": "Enter email address",
//           "send_recover_email": "Send Recover Email",
//           "email_successfully_sent": "Email successfully sent",
//           "check_email_to_restore_password":
//               "Please check your email to restore password",
//           "no_user_found_with_this_email": "No user found with this email",
//           "incorrect_password": "Incorrect password",
//           "no_user_with_email": "No user found with this email",
//           "req_field_err": "This is a required field",
//           // Sign Up Screen
//           "full_name": "Public Name",
//           "already_have_an_account": "Already have an account",
//           "select_preferred_location": "Select your preferred location",
//           "select_preferred_sport": "Select your preferred Sport",
//           "preferred_sport": "Preferred Sport",
//           "next": "Next",
//           "padel_courts_available": "Padel courts available.",
//           "padel_tennis_courts_available": "Padel & Tennis courts available.",
//           "fitness_class_gym": "Fitness classes & Gym.",
//           "please_enter_valid_email": "Please enter a valid email",
//           "password_must_be_at_least_6_characters":
//               "Password must be at least 6 characters",
//           "user_with_email_already_exists":
//               "User with this email already exists",
//           // Booking Screen
//           "add_profile_picture": "Add Profile Picture",
//           "this_way_other_players_can_identify_you":
//               "This way other players can identify you when you join a match",
//           "when_did_you_start_playing": "Also, when did you start playing?",
//           "This will give other players an idea about your skills.":
//               "This will give other players an idea about your skills.",
//           "padel": "Padel",
//           "pickleball": "Pickleball",
//           "tennis": "Tennis",
//           "padel_courts": "Padel courts",
//           "save": "Save",
//           "COMING_SOON": "Coming Soon",
//           "classes": "Classes",
//           "booking": "Booking",
//           "profile": "Profile",
//           "change_profile_picture": "Change Profile Picture",
//           "cancel": "Cancel",
//           "camera": "Camera",
//           "gallery": "Gallery",
//           "book": "Book",
//           "court": "Court",
//           "book_court": "Book Court",
//           "booking_information": "Booking Information",
//           "cancellation_24_hours_before_booking":
//               "Cancelation up to 24 hours before the match starts can be credited.",
//           "cancellation_12_hours_before_booking":
//               "CANCELATIONS UP TO 24 HOURS BEFORE THE BOOKING STARTS CAN BE CREDITED.",
//           "If you cancel before  24 hours the booking starts, we'll add credits to your account.":
//               "There will be no refund if the cancellation is less than 24 hours before the booking starts. If you are eligible for a refund, it will be refunded to your club wallet as credits. \nFind out more about the cancellation policy on Prime Padel website.",
//           "phone_number": "Phone Number",
//           "level": "Level",
//           "position": "Position",
//           "started_playing": "Started Playing",
//           "location": "Location",
//           "date": "Date",
//           "time": "Time",
//           "price": "Price",
//           "you_have_successfully_booked_court": "You have booked a court",
//           "you_have_successfully_booked_lesson": "You have booked a lesson",
//           "add_to_calendar": "Add to Calendar",
//           "see_my_bookings": "See my Bookings",
//           "see": "See",
//           "loading": "Loading",
//           "oops_something_has_gone_wrong": "Oops! Something has gone wrong",
//           "try_again_or_send_message": "Please try again or send us a message",
//           "send_us_message": "Send us a Message",
//           // Profile Screen
//           "sign_out": "Sign Out",
//           "upcoming_bookings": "Upcoming Bookings",
//           "no_upcoming_bookings": "No Upcoming Bookings",
//           "past_bookings": "Past Bookings",
//           "no_past_bookings": "No Past Bookings",
//           "settings": "Settings",
//           "duration": "Duration",
//           "today": "Today",
//           "tomorrow": "tomorrow",
//           "after_tomorrow": "after tomorrow",
//           "are_you_sure_you_want_to_sign_out":
//               "Are you sure you want to sign out?",
//           // Booking Info
//           "booking_info": "Booking Info",
//           "cancel_booking": "Cancel Booking",
//           "share_info_in_whatsapp": "Share info in Whatsapp",
//           "share_in_whatsapp": "Share in Whatsapp",
//           "share_match_in_whatsapp": "Share match in Whatsapp",
//           "you_cant_cancel_booking": "You can't cancel the booking",
//           "booking_can_only_be_canceled_up_to_6_hours_before_match_starts":
//               "The booking can only be canceled up to 24 hours before the match starts.",
//           "booking_can_only_be_canceled_up_to_12_hours_before_match_starts":
//               "The booking can only be canceled up to 24 hours before the match starts.",
//           "are_you_sure_want_to_cancel_booking":
//               "Are you sure want to cancel the booking?",
//           "are_you_sure_want_to_cancel_lesson":
//               "Are you sure want to cancel the lesson?",
//           "are_you_sure_you_want_to_cancel": "Are you sure you want to cancel?",
//           "lesson_There will be no refund if the cancellation is less than 48 hours before...":
//               "There will be no refund if the cancellation is less than 48 hours before the lesson starts. If you are eligible for a refund, it will be refunded to your club wallet as credits. \nFind out more about the cancellation policy on Prime Padel website. ",
//           "are_you_sure_want_to_cancel_match":
//               "Are you sure want to cancel the Match?",
//           "you_have_cancelled_the_booking": "You have cancelled the booking",
//           "you_have_cancelled_the_match": "you have cancelled the Match",
//           "you_have_successfully_cancelled": "You have successfully cancelled",
//           "If you cancel, the payment will be credited to your wallet.":
//               "If you cancel, the payment will be credited to your wallet.",
//           "no_slots_available_for_now": "No slots available for now",
//           "no_lessons_available_for_now": "No lessons available for now",
//           "sorry_slot_already_booked":
//               "We’re sorry, this time slot has been taken just before you tried booking.",
//           "please_select_new_one": "Please select a new one",
//           "changes_have_been_made_by_padel_art":
//               "Changes have been made by Prime Padel",
//           "changes_made_in_booking": "Changes made in booking",
//           "booking_cancelled": "Booking cancelled",
//           "open_match_canceled_by_organizer":
//               "open match canceled by organizer",
//           "please_check_details_below_thoroughly":
//               "Please check the details below thoroughly.",
//           "if_you_have_problem_with_changes_contact_us":
//               "If you have any problem with the changes please contact us.",
//           "booking_canceled_by_padel_art":
//               "Booking canceled by Prime Padel", //Changes have been made by Prime Padel
//           "booking_canceled": "Booking canceled",
//           "following_details_are_no_longer_valid":
//               "The following details are no longer valid.",
//           "if_you_have_any_problem_with_this_change_contact_us":
//               "If you have any problem with this change please contact us.",
//           // Settings Tab
//           "personal_information": "Personal Information",
//           "edit": "Edit",
//           "preferred_location": "Preferred Location",
//           "change_password": "Change password",
//           "edit_your_information": "Edit your Information",
//           "current_password": "Current Password",
//           "new_password": "New Password",
//           "recover": "Recover",
//           "password_successfully_changed": "Password Successfully Changed",
//           "delete_account": "Delete account",
//           "delete": "Delete",
//           "confirm_password": "Confirm Password",
//           "are_you_sure_you_want_to_delete_account":
//               "Are you sure you want to delete this account",
//           "this_action_cannot_be_reversed_and_your_information_will_be_lost":
//               "This action cannot be reversed and your information will be lost.",
//           // Group Classes
//           "group_classes": "Group Classes",
//           "group": "Group",
//           "no_group_classes_available_for_now":
//               "No group classes available for now",
//           "no_open_match_available_for_now":
//               "No open matches available for now",
//           "sports": "Sports",
//           "all_locations": "All Locations",
//           // Class Info
//           "class_info": "Class Info",
//           "info_about_this_event": "info about this event",
//           "participants": "Participants",
//           "players": "Players",
//           "player": "Player",
//           "max": "Max",
//           "min": "Min",
//           "info": "Info",
//           "slots": "Slots",
//           "available_slots": "Available Slots",
//           "current_participants": "Current Participants",
//           "more": "More",
//           "join": "Join",
//           "chat": "Chat",
//           "are_you_sure_you_want_to_join": "Are you sure you want to join?",
//           "are_you_sure_you_want_to_join_the_match":
//               "Are you sure you want to join the match?",
//           "if_you_join_one_of_the_available_slots_will_be_taken":
//               "If you join, one of the available slots will be taken",
//           "you_have_joined_successfully": "You have joined successfully",
//           "undo": "Undo",
//           "cancel_slot": "Cancel Slot",
//           "are_you_sure_you_want_to_leave": "Are you sure you want to leave?",
//           "are_you_sure_you_want_to_leave_this_open_match":
//               "Are you sure you want to leave this open match?",
//           "If you join, the other players will receive a notification.":
//               "Once you join, the other players will receive a notification. \nFind out more about the cancellation policy on Prime Padel website. ",
//           "Cancellations up to 24 hrs before the match starts can be credited.":
//               "Cancellations up to 24 hrs before the match starts can be credited.",
//           "If you cancel before  24 hours the match starts, we'll add credits to your  account.":
//               "There will be no refund if the cancellation is less than 24 hours before the booking starts. If you are eligible for a refund, it will be refunded to your club wallet as credits. \nFind out more about the cancellation policy on Prime Padel website.",
//           "Any spots reserved by you will leave the match as well.":
//               "Any spots reserved by you will leave the match as well.",
//           "if_you_leave_one_of_the_available_slots_will_be_taken":
//               "If you leave, one of the available slots will be taken",
//           "leave": "Leave",
//           "reserved": "Reserved",
//           "reserve": "Reserve",
//           "available": "Available",
//           "you_have_left_successfully": "You have left successfully",
//           "you_cant_leave_class": "Oops! You can’t leave",
//           "you_can_only_leave_up_to_12_hours_before_event_starts":
//               "You can only leave up to 24 hours before the event starts.",
//           "an_error_occurred_while_loading_participants":
//               "An error occurred while loading participants info",
//           // Chat Screen
//           "send": "Send",
//           "message_could_not_be_sent": "Message could not be sent",
//           "": "",
//           "slots_taken_err":
//               "UNFORTUNATELY, ALL SLOTS FOR THIS EVENT HAVE BEEN TAKEN.",
//           "waiting_list": "Waiting List",
//           "waiting_list_info":
//               "in the case that any player withdraws from the event, the first person on the waiting list will take his place. If more players leave the event, the following players on the waiting list will take their places.",
//           "there_is_no_waiting_list": "There is no waiting list",
//           "join_waiting_list": "Join Waiting List",
//           "an_error_occurred_while_loading_waiting_list":
//               "An error occurred while loading waiting list",
//           "are_you_sure_you_want_to_join_waiting_list":
//               "Are you sure you want to join the waiting list?",
//           "if_you_join_waiting_list":
//               "If you join, you can be automatically incorporated in case other players leave the event.",
//           "you_have_joined_waiting_list_successfully":
//               "You have joined the waiting list successfully",
//           "leave_waiting_list": "Leave Waiting List",
//           "are_you_sure_you_want_to_leave_waiting_list":
//               "Are you sure you want to leave the waiting list?",
//           "if_you_leave_waiting_list":
//               "if you leave, you will lose your spot in the waiting list",
//           "you_have_left_waiting_list_successfully":
//               "You have left the waiting list successfully",
//           //  Notifications Screen
//           "notifications": "Notifications",
//           "clear_all": "Clear all",
//           "no_notifications": "No Notifications",
//           "an_error_occurred_while_loading_class":
//               "An error occurred while loading class",
//           "courts": "Courts",
//           "lessons": "Lessons",
//           "open_matches": "Open Matches",
//           "open_match": "Open Match",
//           "events": "Events",
//           "event_info": "Event Info",
//           "match_info": "Match Info",
//           "see_profile": "See Profile",
//           "do_you_want_to_open_this_match": "Do you want to open this match?",
//           "Approve players before they join":
//               "Approve players before they join",
//           "friendly match": "Friendly Match",
//           "no score": "no score",
//           "optional": "Optional",
//           "open match to find players": "Open match to find players",
//           "select_the_match_level": "Select the match level",
//           "select_your_level": "Select your level",
//           "match_level": "Match Level",
//           "allow_players_from": "Allow players from",
//           "Played at least 5 times": "Played at least 5 times",
//           "First time playing.": "First time playing.",
//           "will require staff approval": "Will require staff approval",
//           "are_you_going_with_someone_else": "Are you going with someone else?",
//           "limit_players_level": "Limit players level?",
//           "leave_a_note_to_other_players": "Leave a note to other players",
//           "type_here": "Type here",
//           "beginner": "Beginner",
//           "bronze": "Bronze",
//           "silver": "Silver",
//           "gold": "Gold",
//           "plyer_ranking": "Player Ranking",
//           "player_stats": "Player stats",
//           "note_from_organizer": "Note from Organizer",
//           "organizer": "Organizer",
//           "beginner_explanation":
//               "You are just starting to play and don’t have much experience.",
//           "bronze_explanation":
//               "You have played enough, started mastering different shots and feel more confident.",
//           "silver_explanation":
//               "Your technique is good, you have mastered the shots and know where to stand on every move.",
//           "gold_explanation":
//               "You are an experienced player. You are looking for high level and intense matches.",
//           "select_your_position": "Select your position",
//           "right_side": "Right Side",
//           "left_side": "Left Side",
//           "both_sides": "Both Sides",
//           "right_side_explanation":
//               "You play better at the right side of the court.",
//           "left_side_explanation":
//               "You play better at the left side of the court.",
//           "both_sides_explanation":
//               "You are comfortable playing on either side of the court.",
//           "your level is not yet verified": "Your level is not yet verified",
//           "level_not_verified_desc":
//               "your verification is still pending so you wont be able to join an open match. To speed things up contact us through the button below.",
//           "are_you_sure_you_want_to_release_this_reserved_spot":
//               "are you sure you want to release this reserved spot?",
//           "yes_release_this_spot": "Yes, Release this spot",
//           "you_have_released_this_spot_successfully":
//               "You have released this spot successfully",
//           "reserve_a_spot": "Reserve a Spot",
//           "reserved_by": "Reserved by",
//           "are_you_sure_you_want_to_reserve_this_spot":
//               "Are you sure you want to reserve this spot?",
//           "reserve_this_spot": "Reserve this spot",
//           "you_have_reserved_a_spot_successfully":
//               "You have reserved a spot successfully",
//           "choose_your_spot": "Choose your spot",
//           "oops_you_cannot_join_this_open_match":
//               "oops! you cannot join this open match",
//           "oops_you_cannot_join_this_event": "oops! you cannot join this event",
//           "Unfortunately, you cannot join this event as you don't have the required level.":
//               "Unfortunately, you cannot join this event as you don't have the required level.",

//           "your_level_is_too_low_to_join_this_open_match":
//               "your level is too low to join this open match.",
//           "your_level_is_too_high_to_join_this_open_match":
//               "your level is too high to join this open match.",
//           "pay_full_amount": "Pay Full Court",
//           "pay_my_part": "Pay my share",
//           "payment_information": "Payment Information",
//           "select_your_payment_method": "Select your payment method",
//           "add_credit_card": "Add credit/debit card",
//           "enter_card_details": "Enter card details",
//           "pay_court": "Proceed to Pay",
//           "save_card": "Save Card",
//           "payment_unsuccessful": "Oops! your payment didn’t go through",
//           "booking_payment": "booking payment",
//           "lesson_payment": "lesson payment",
//           "event_payment": "event payment",
//           "pay_lesson": "Pay Lesson",
//           "join_event": "Join and Pay Event",
//           "ladies only available": "ladies only available",
//           "refund_failed": "We had an issue processing the refund",
//           "refund_failed_description":
//               "We had an issue processing the refund. Please contact us to get your refund",
//           "first_name": "First Name",
//           "last_name": "Last Name",
//           "post_match": "Post Match",
//           "see_my_matches": "See my Matches",
//           "ranking_profile": "Ranking Profile",
//           "CANCEL": "Cancel or reschedule",
//           "You won’t be able to edit this later":
//               "You won’t be able to edit this later",
//           "Join and pay my share": "Join and pay my share",
//           "Leave Open Match": "Leave Open Match",
//           "cancel_match": "Cancel Match",
//           "you_have_left_the_match": "You have left the match",
//           "you_have_reserved_a_spot": "You have reserved a spot",
//           "you have joined the match": "You have joined the match",
//           "If you leave, one of the taken slots will be open":
//               "There will be no refund if the cancellation is less than 24 hours before the event starts. If you are eligible for a refund, it will be refunded to your club wallet as credits.\nFind out more about the cancellation policy on Prime Padel website. ",
//           "If you leave the spot before  24 hours the event starts, we'll add credits to your  account.":
//               "If you leave the spot before  24 hours the event starts, we'll add credits to your account.",
//           "see_dates": "See Dates",
//           "hide_dates": "Hide Dates",
//           'Cancelation up to 48 hours before the lesson starts can be credited.':
//               'Cancelation up to 48 hours before the lesson starts can be credited.',

//           "Powered by book & Go": "Powered by book & Go",
//           "Play & match": "Play & match",
//           "Refund": "Refund",
//           "only_mobile_support":
//               "These features are only available from the mobile app.",
//           "only_mobile_support_desc":
//               "Please download it in order to use them.",
//           "Payment was successful but there was an error in the booking.":
//               "Payment was successful but there was an error in the booking. We’ve refunded automatically to your payment method",
//           "Payment was successful but there was an error in booking and refund too, please contact us":
//               "Payment was successful but there was an error in booking and refund too, please contact us",
//           "entered_promotion_code_is_not_valid_please_enter_valid_code":
//               "Unfortunately, the promotion code entered is invalid. Please enter a valid code.",
//           "enter_the_coupon_here": "Enter the coupon here",
//           "do_you_have_a_discount_coupon": "Do you have a discount coupon?",
//           "offset": "Offset",
//           "pay_with_wallet_card": "Pay with wallet & Card",
//           //Changes to friendly
//           "change_match_type_to_friendly":
//               "are you sure you want to change it to a friendly match?",
//           "change_match_type_to_friendly_subtitle":
//               "The score will not be reflected on the ranking system.\n\nYou should discuss it with the other players.",
//           "btn_title_friendly": "Yes, make it a friendly match",
//           "success_changed_to_friendly":
//               "You have changed it to a friendly match",
//           //Change to ranked
//           "change_match_type_to_ranked":
//               "are you sure you want to change it to a Ranked match?",
//           "change_match_type_to_ranked_subtitle":
//               "The score will be reflected on the ranking system.\n\nYou should discuss it with the other players.",
//           "btn_title_ranked": "Yes, make it a ranked match",
//           "success_changed_to_ranked": "You have changed it to a ranked match",
//           "you_cant_change_a_match_setting": "You ca't change a match setting",
//           "only_the_organizer_can_change_this_match_setting":
//               "Only the organizer can change this match setting",
//           "score": "Score",
//           "enter_match_result": "Enter Match Results",
//           "edit_match_result": "Edit Match Results",
//           "also_help_us_rank_the_other_player":
//               "Also, help us rank the other players",
//           "help_us_rank_the_other_play": "Help us rank the other players",
//           "rank_the_other_players": "Rank the other players",
//           "enter_result": "Enter Results",
//           "draw": "Draw",
//           "who_did_you_play_with": "Who did you play with?",
//           "click_on_the_player_that_was_on_your_team":
//               "Click on the player that was on your team",
//           "select_player_level": "Select player level",
//           "winners": "Winners",
//           "your_open_match": "Your Open Match",
//           "confirm_the_score": "Confirm the score",
//           "ranking_logic": "Ranking logic",
//           "you_start_with_a_self_assessed_level":
//               "You start with a self-assessed level, then:",
//           "level_difference_between_players":
//               "Level difference between players",
//           "Game_outcome": "Game outcome (Win, Loss, Draw)",
//           "points_based_on_level_difference":
//               "points based on level difference:",
//           "win": "Win: +0.10 to +0.02 points",
//           "loss": "Loss: -0.10 to -0.18 points",
//           "draw_points": "Draw: 0.00 to -0.09 points",
//           "A_multiplier_is_applied_based_on_the_number_of_games_played_per_player":
//               "A multiplier is applied based on the number of games played per player:",
//           "1_to_10_games_2_to_multiplier": "1 to 10 games: 2 to 1.1 multiplier",
//           "More_than_10_games__multiplier":
//               "More than 10 games: 1.0 multiplier",
//           "assessment_by_other_players": "Assesment by other players",
//           "this_is_only_valid_for_ranked_games":
//               "This is valid only for ranked games.",
//           "no_past_matches": "No past matches",
//           "match_pending": "Match Pending",
//           "players_waiting_for_approval": "Players waiting for your approval",
//           "you_are_waiting_for_approval": "You are waiting for approval",
//           "approve": "Approve",
//           "withdraw_from_the_match": "Withdraw from the match",
//           "are_you_sure_you_want_to_approve_this_player":
//               "are you sure you want to approve this player?",
//           "are_you_sure_you_want_to_withdraw_from_the_match":
//               "Are you sure you want to withdraw from the match",
//           "this_action_cant_be_undone": "This action cannot be undone",
//           "approve_player": "Approve player",
//           "yes_withdraw": "Yes, withdraw",
//           "player_waiting_to_enter_your_match":
//               "Players waiting to enter your match",
//           "date_time": "Date & Time",
//           "current_players": "Current players",
//           "you_have_withdraw_from_the_match":
//               "You have withdrawn from the match",
//           "waiting_for_approval": "Waiting for Approval",
//           "you_have_withdrawn_from_the_match":
//               "you have withdrawn from the match",
//           "needs_organizers_approval": "Needs organizers approval",
//           "if_approved_you_will_receive_a_notification":
//               "If approved, you will receive a notification",
//           "apply_to_match": "Apply to match",
//           "you_are_now_waiting_for_approval":
//               "You are now waiting for approval",
//           "here_are_other_players_waiting_for_approval_for_this_match":
//               "Here are other players waiting for approval for this match",
//           "you_have_already_requested_for_the_match":
//               "you have already requested for the match",
//           "select_payment_method_or_redeem_from_wallet_and_pay_the_balance_with_card":
//               "Select your preferred payment method or redeem your credits from the Wallet and pay the balance with your card",
//           "amount_payable": "Amount Payable",
//           "redeem_credits": "Redeem Credits",
//           "proceed_with_payment": "Proceed WIth Payment"
//         },
//       };
// }
