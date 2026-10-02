import 'package:flutter/foundation.dart';

@immutable
class PhotoQualityRule {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final bool isPassed;

  const PhotoQualityRule({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.isPassed = true,
  });

  static List<PhotoQualityRule> get defaultTwinRules => const [
        PhotoQualityRule(
          id: 'rule_full_body',
          title: 'Full Body Frame',
          description: 'Head to toe must be fully visible in the viewport.',
          iconName: 'aspect_ratio',
        ),
        PhotoQualityRule(
          id: 'rule_fitted_attire',
          title: 'Form-Fitting Attire',
          description: 'Wear fitted clothes (gym wear) for 33 joint mesh precision.',
          iconName: 'accessibility_new',
        ),
        PhotoQualityRule(
          id: 'rule_high_contrast',
          title: 'Lighting & Contrast',
          description: 'Stand against a plain wall with bright, even frontal lighting.',
          iconName: 'wb_sunny',
        ),
        PhotoQualityRule(
          id: 'rule_standing_pose',
          title: 'Natural Standing Pose',
          description: 'Stand straight with feet shoulder-width and arms slightly apart.',
          iconName: 'boy',
        ),
        PhotoQualityRule(
          id: 'rule_no_blur',
          title: 'High Resolution',
          description: 'No beauty filters, dark shadows, or camera blur.',
          iconName: 'camera_alt',
        ),
      ];
}
