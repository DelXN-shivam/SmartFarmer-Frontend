import '../constants/app_constants.dart';
import '../models/crop.dart';
import 'dart:math';

class AIService {
  static final Random _random = Random();

  /// Generate AI insights based on crop data
  static List<String> generateInsights(Crop crop) {
    final insights = <String>[];

    // Crop age based insights
    insights.addAll(_getAgeBasedInsights(crop));

    // Soil type based insights
    insights.addAll(_getSoilBasedInsights(crop));

    // Crop type specific insights
    insights.addAll(_getCropTypeInsights(crop));

    // Weather and seasonal insights
    insights.addAll(_getSeasonalInsights(crop));

    // Random AI insights
    insights.add(_getRandomInsight());

    return insights.take(5).toList(); // Limit to 5 insights
  }

  /// Get insights based on crop age
  static List<String> _getAgeBasedInsights(Crop crop) {
    final insights = <String>[];
    final age = crop.cropAgeInDays;

    if (age < 15) {
      insights.add(
        'Crop is in germination stage. Ensure proper soil moisture.',
      );
      insights.add('Monitor for early pest infestation and disease symptoms.');
    } else if (age < 45) {
      insights.add('Vegetative growth phase. Apply nitrogen-rich fertilizers.');
      insights.add('Optimal time for weed control and irrigation management.');
    } else if (age < 90) {
      insights.add(
        'Flowering stage approaching. Monitor pollination conditions.',
      );
      insights.add('Consider micronutrient application for better yield.');
    } else if (age < 120) {
      insights.add('Fruiting stage. Protect crops from birds and pests.');
      insights.add('Reduce irrigation frequency to prevent lodging.');
    } else {
      insights.add(
        'Harvesting stage. Monitor weather for optimal harvest timing.',
      );
      insights.add('Prepare storage facilities and post-harvest management.');
    }

    return insights;
  }

  /// Get insights based on soil type
  static List<String> _getSoilBasedInsights(Crop crop) {
    final insights = <String>[];

    switch (crop.soilType.toLowerCase()) {
      case 'clay':
        insights.add(
          'Clay soil retains moisture well. Reduce irrigation frequency.',
        );
        insights.add('Consider soil aeration to improve root development.');
        break;
      case 'sandy':
        insights.add(
          'Sandy soil requires frequent irrigation and nutrient application.',
        );
        insights.add('Apply organic matter to improve water retention.');
        break;
      case 'loamy':
        insights.add(
          'Loamy soil is ideal for most crops. Maintain balanced nutrients.',
        );
        insights.add(
          'Regular soil testing recommended for optimal management.',
        );
        break;
      case 'silt':
        insights.add('Silt soil has good water retention. Monitor drainage.');
        insights.add('Apply balanced fertilizers for optimal growth.');
        break;
      default:
        insights.add(
          'Consider soil testing for specific nutrient recommendations.',
        );
    }

    return insights;
  }

  /// Get crop type specific insights
  static List<String> _getCropTypeInsights(Crop crop) {
    final insights = <String>[];

    switch (crop.cropType.toLowerCase()) {
      case 'wheat':
        insights.add(
          'Wheat requires cool temperatures. Monitor for rust diseases.',
        );
        insights.add('Apply phosphorus during early growth stages.');
        break;
      case 'rice':
        insights.add(
          'Rice needs consistent water levels. Check for water management.',
        );
        insights.add('Monitor for blast disease and stem borer infestation.');
        break;
      case 'maize':
        insights.add(
          'Maize benefits from nitrogen-rich fertilizers during growth.',
        );
        insights.add('Monitor for fall armyworm and corn borer.');
        break;
      case 'cotton':
        insights.add('Cotton requires warm temperatures and adequate spacing.');
        insights.add('Monitor for bollworm and whitefly infestation.');
        break;
      case 'sugarcane':
        insights.add(
          'Sugarcane needs regular irrigation and ratoon management.',
        );
        insights.add('Monitor for red rot and smut diseases.');
        break;
      case 'pulses':
        insights.add(
          'Pulses fix nitrogen. Reduce nitrogen fertilizer application.',
        );
        insights.add('Monitor for pod borer and wilt diseases.');
        break;
      default:
        insights.add(
          'Follow general crop management practices for optimal yield.',
        );
    }

    return insights;
  }

  /// Get seasonal and weather based insights
  static List<String> _getSeasonalInsights(Crop crop) {
    final insights = <String>[];
    final month = DateTime.now().month;

    if (month >= 3 && month <= 5) {
      insights.add('Summer season. Increase irrigation frequency.');
      insights.add('Monitor for heat stress and pest outbreaks.');
    } else if (month >= 6 && month <= 9) {
      insights.add('Monsoon season. Ensure proper drainage.');
      insights.add('Monitor for fungal diseases due to high humidity.');
    } else if (month >= 10 && month <= 11) {
      insights.add('Post-monsoon season. Reduce irrigation gradually.');
      insights.add('Prepare for winter crop planning.');
    } else {
      insights.add('Winter season. Protect crops from cold stress.');
      insights.add('Monitor for frost damage in sensitive crops.');
    }

    return insights;
  }

  /// Get a random AI insight
  static String _getRandomInsight() {
    return AppConstants.aiInsights[_random.nextInt(
      AppConstants.aiInsights.length,
    )];
  }

  /// Predict crop yield based on current conditions
  static double predictYield(Crop crop) {
    final baseYield = crop.expectedYield;
    final age = crop.cropAgeInDays;
    final lifespan = AppConstants.cropLifespan[crop.cropType] ?? 120;

    // Simple prediction model
    double multiplier = 1.0;

    // Age factor
    if (age < lifespan * 0.3) {
      multiplier *= 0.8; // Early stage
    } else if (age < lifespan * 0.7) {
      multiplier *= 1.0; // Mid stage
    } else {
      multiplier *= 1.2; // Late stage
    }

    // Soil type factor
    switch (crop.soilType.toLowerCase()) {
      case 'loamy':
        multiplier *= 1.1;
        break;
      case 'clay':
        multiplier *= 1.0;
        break;
      case 'sandy':
        multiplier *= 0.9;
        break;
    }

    // Random variation (±10%)
    final variation = 0.9 + (_random.nextDouble() * 0.2);
    multiplier *= variation;

    return (baseYield * multiplier).roundToDouble();
  }

  /// Get growth stage recommendations
  static Map<String, String> getGrowthRecommendations(Crop crop) {
    final recommendations = <String, String>{};
    final age = crop.cropAgeInDays;
    final lifespan = AppConstants.cropLifespan[crop.cropType] ?? 120;

    if (age < lifespan * 0.1) {
      recommendations['stage'] = 'Germination';
      recommendations['action'] = 'Ensure proper soil moisture and temperature';
      recommendations['fertilizer'] = 'Apply starter fertilizer';
    } else if (age < lifespan * 0.3) {
      recommendations['stage'] = 'Vegetative';
      recommendations['action'] = 'Apply nitrogen-rich fertilizers';
      recommendations['fertilizer'] = 'Urea or NPK 20:20:20';
    } else if (age < lifespan * 0.6) {
      recommendations['stage'] = 'Flowering';
      recommendations['action'] =
          'Monitor pollination and apply micronutrients';
      recommendations['fertilizer'] = 'Micronutrient mix';
    } else if (age < lifespan * 0.8) {
      recommendations['stage'] = 'Fruiting';
      recommendations['action'] = 'Protect from pests and reduce irrigation';
      recommendations['fertilizer'] = 'Potassium-rich fertilizer';
    } else {
      recommendations['stage'] = 'Harvesting';
      recommendations['action'] = 'Prepare for harvest and storage';
      recommendations['fertilizer'] = 'No additional fertilizer needed';
    }

    return recommendations;
  }
}
