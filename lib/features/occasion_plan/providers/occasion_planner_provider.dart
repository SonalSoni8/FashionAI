import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/calendar_ai_curator_service.dart';
import '../domain/models/calendar_outfit_slot.dart';

class OccasionPlannerState {
  final List<CalendarOutfitSlot> slots;
  final bool globalRemindersEnabled;
  final String activeLocation;

  const OccasionPlannerState({
    required this.slots,
    this.globalRemindersEnabled = true,
    this.activeLocation = 'New York, USA',
  });

  OccasionPlannerState copyWith({
    List<CalendarOutfitSlot>? slots,
    bool? globalRemindersEnabled,
    String? activeLocation,
  }) {
    return OccasionPlannerState(
      slots: slots ?? this.slots,
      globalRemindersEnabled:
          globalRemindersEnabled ?? this.globalRemindersEnabled,
      activeLocation: activeLocation ?? this.activeLocation,
    );
  }
}

class OccasionPlannerNotifier extends StateNotifier<OccasionPlannerState> {
  final CalendarAiCuratorService _curatorService = CalendarAiCuratorService();

  OccasionPlannerNotifier()
      : super(
          OccasionPlannerState(
            slots: CalendarAiCuratorService().generateDefaultSchedule(),
          ),
        );

  void reorderSlots(int oldIndex, int newIndex) {
    var index = newIndex;
    if (oldIndex < index) {
      index -= 1;
    }
    final updatedList = List<CalendarOutfitSlot>.from(state.slots);
    final item = updatedList.removeAt(oldIndex);
    updatedList.insert(index, item);

    state = state.copyWith(slots: updatedList);
  }

  void toggleReminder(String slotId) {
    final updatedList = state.slots.map((s) {
      if (s.id == slotId) {
        return s.copyWith(hasReminder: !s.hasReminder);
      }
      return s;
    }).toList();

    state = state.copyWith(slots: updatedList);
  }

  void toggleGlobalReminders() {
    state = state
        .copyWith(globalRemindersEnabled: !state.globalRemindersEnabled);
  }
}

final occasionPlannerProvider =
    StateNotifierProvider<OccasionPlannerNotifier, OccasionPlannerState>(
        (ref) {
  return OccasionPlannerNotifier();
});
