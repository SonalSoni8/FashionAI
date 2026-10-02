import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../domain/models/calendar_outfit_slot.dart';
import '../providers/occasion_planner_provider.dart';

class OccasionPlannerView extends ConsumerStatefulWidget {
  const OccasionPlannerView({super.key});

  @override
  ConsumerState<OccasionPlannerView> createState() =>
      _OccasionPlannerViewState();
}

class _OccasionPlannerViewState extends ConsumerState<OccasionPlannerView> {
  @override
  Widget build(BuildContext context) {
    final plannerState = ref.watch(occasionPlannerProvider);
    final slots = plannerState.slots;

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "AI Outfit Calendar",
          style: AuraTypography.title(isDark: true),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              plannerState.globalRemindersEnabled
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_rounded,
              color: plannerState.globalRemindersEnabled
                  ? AuraColors.auraViolet
                  : Colors.white70,
            ),
            onPressed: () {
              ref
                  .read(occasionPlannerProvider.notifier)
                  .toggleGlobalReminders();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Real Weather Header & Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(18),
                isGlowing: true,
                glowColor: AuraColors.auraViolet,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AuraColors.auraAmber.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.wb_sunny_rounded,
                        color: AuraColors.auraAmber,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Text(
                            "72°F · Clear Skies",
                            style: AuraTypography.title(isDark: true),
                          ),
                          Text(
                            "${plannerState.activeLocation} · Weather Synced",
                            style: AuraTypography.caption(isDark: true),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AuraColors.auraViolet.withOpacity(0.2),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.alarm_rounded,
                            color: AuraColors.auraViolet,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "7:30 AM Push Active",
                            style: AuraTypography.caption(isDark: true)
                                .copyWith(
                              color: AuraColors.auraViolet,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Occasion Slots",
                    style: AuraTypography.title(isDark: true),
                  ),
                  Text(
                    "Hold & drag to reorder",
                    style: AuraTypography.caption(isDark: true).copyWith(
                      color: AuraColors.auraCyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Reorderable Drag & Drop List of 8 Occasion Slots
            Expanded(
              child: ReorderableListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                itemCount: slots.length,
                onReorder: (oldIndex, newIndex) {
                  ref
                      .read(occasionPlannerProvider.notifier)
                      .reorderSlots(oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final slot = slots[index];
                  return Container(
                    key: ValueKey(slot.id),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      borderRadius: 22,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Occasion Tag Icon
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getOccasionColor(slot.occasionType)
                                      .withOpacity(0.15),
                                ),
                                child: Icon(
                                  _getOccasionIcon(slot.occasionType),
                                  color: _getOccasionColor(slot.occasionType),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAlignment.start,
                                  children: [
                                    Text(
                                      slot.title,
                                      style: AuraTypography.title(isDark: true)
                                          .copyWith(fontSize: 15),
                                    ),
                                    Text(
                                      "${slot.dateLabel} · ${slot.temperature} ${slot.weatherCondition}",
                                      style:
                                          AuraTypography.caption(isDark: true),
                                    ),
                                  ],
                                ),
                              ),

                              // Match Score Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      AuraColors.auraEmerald.withOpacity(0.15),
                                ),
                                child: Text(
                                  slot.matchScore,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AuraColors.auraEmerald,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Push Reminder Toggle
                              IconButton(
                                icon: Icon(
                                  slot.hasReminder
                                      ? Icons.notifications_active_rounded
                                      : Icons.notifications_none_rounded,
                                  color: slot.hasReminder
                                      ? AuraColors.auraViolet
                                      : AuraColors.textMutedDark,
                                  size: 20,
                                ),
                                onPressed: () {
                                  ref
                                      .read(occasionPlannerProvider.notifier)
                                      .toggleReminder(slot.id);
                                },
                              ),

                              // Drag Handle Icon
                              const Icon(
                                Icons.drag_handle_rounded,
                                color: AuraColors.textMutedDark,
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Curated Outfit Items Preview
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white.withOpacity(0.04),
                              border: Border.all(
                                color: AuraColors.glassBorderDark,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAlignment.start,
                              children: [
                                if (slot.outerwearItem.isNotEmpty)
                                  _buildOutfitItemRow(
                                    "Outerwear",
                                    slot.outerwearItem,
                                  ),
                                _buildOutfitItemRow("Top", slot.topItem),
                                _buildOutfitItemRow("Bottom", slot.bottomItem),
                                _buildOutfitItemRow("Footwear", slot.footwearItem),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutfitItemRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: AuraTypography.caption(isDark: true).copyWith(
              color: AuraColors.textMutedDark,
              fontSize: 11,
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AuraTypography.caption(isDark: true).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getOccasionIcon(OccasionType type) {
    switch (type) {
      case OccasionType.today:
        return Icons.today_rounded;
      case OccasionType.tomorrow:
        return Icons.event_rounded;
      case OccasionType.office:
        return Icons.business_center_rounded;
      case OccasionType.wedding:
        return Icons.favorite_rounded;
      case OccasionType.travel:
        return Icons.flight_takeoff_rounded;
      case OccasionType.gym:
        return Icons.fitness_center_rounded;
      case OccasionType.college:
        return Icons.school_rounded;
      case OccasionType.festival:
        return Icons.festival_rounded;
    }
  }

  Color _getOccasionColor(OccasionType type) {
    switch (type) {
      case OccasionType.today:
        return AuraColors.auraViolet;
      case OccasionType.tomorrow:
        return AuraColors.auraCyan;
      case OccasionType.office:
        return AuraColors.auraViolet;
      case OccasionType.wedding:
        return AuraColors.auraRose;
      case OccasionType.travel:
        return AuraColors.auraAmber;
      case OccasionType.gym:
        return AuraColors.auraEmerald;
      case OccasionType.college:
        return AuraColors.auraCyan;
      case OccasionType.festival:
        return AuraColors.auraRose;
    }
  }
}
