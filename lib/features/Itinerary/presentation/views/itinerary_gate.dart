import 'package:flutter/material.dart';
import 'package:etrip/features/auth/data/services/local_storage_service.dart';
import 'package:etrip/features/Itinerary/presentation/views/itinerary_step_one.dart';
import 'package:etrip/features/Itinerary/presentation/views/itinerary_result_view.dart';
import 'package:etrip/features/Itinerary/presentation/views/itinerary_home.dart';

enum _ItineraryMode { home, planning, result }

class ItineraryGate extends StatefulWidget {
  const ItineraryGate({super.key});

  @override
  State<ItineraryGate> createState() => _ItineraryGateState();
}

class _ItineraryGateState extends State<ItineraryGate> {
  _ItineraryMode _mode = _ItineraryMode.home;
  Map<String, dynamic>? _args;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _userId = LocalStorageService().currentUid ?? '';
  }

  void _startNew() {
    setState(() {
      _args = null;
      _mode = _ItineraryMode.planning;
    });
  }

  void _onStepOneDone(Map<String, dynamic> stepOneArgs) {
    setState(() {
      _args = {
        ...stepOneArgs,
        'categoryWeights': <String>[],
      };
      _mode = _ItineraryMode.result;
    });
  }

  void _onViewSaved(Map<String, dynamic> savedArgs) {
    setState(() {
      _args = savedArgs;
      _mode = _ItineraryMode.result;
    });
  }

  void _backToHome() {
    setState(() {
      _args = null;
      _mode = _ItineraryMode.home;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_mode == _ItineraryMode.planning) {
      return ItineraryStepOne(onStepTwo: _onStepOneDone, onBack: _backToHome);
    }

    if (_mode == _ItineraryMode.result && _args != null) {
      return ItineraryResultView(
        args: _args!,
        onStartNew: _backToHome,
      );
    }

    // home mode
    return ItineraryHome(
      userId: _userId,
      onNewItinerary: _startNew,
      onViewItinerary: _onViewSaved,
    );
  }
}
