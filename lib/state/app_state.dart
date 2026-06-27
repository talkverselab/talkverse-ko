import 'package:flutter/foundation.dart';

/// Top-level app state. Kept tiny for MVP — most reading goes through drift
/// streams directly. This holds the few cross-cutting bits that don't fit
/// cleanly inside a single screen.
class AppState extends ChangeNotifier {
  String? _activeScenarioId;
  String? get activeScenarioId => _activeScenarioId;

  void setActiveScenario(String? id) {
    _activeScenarioId = id;
    notifyListeners();
  }
}
