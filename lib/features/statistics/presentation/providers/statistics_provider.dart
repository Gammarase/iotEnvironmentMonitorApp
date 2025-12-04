import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../features/devices/domain/entities/device.dart';
import '../../domain/entities/sensor_reading.dart';
import '../../domain/usecases/get_current_reading_usecase.dart';
import '../../domain/usecases/get_readings_history_usecase.dart';

enum StatisticsPeriod { week, month }

class StatisticsProvider extends ChangeNotifier {
  final GetCurrentReadingUseCase getCurrentReadingUseCase;
  final GetReadingsHistoryUseCase getReadingsHistoryUseCase;

  StatisticsProvider({
    required this.getCurrentReadingUseCase,
    required this.getReadingsHistoryUseCase,
  });

  // State
  Device? _selectedDevice;
  SensorReading? _currentReading;
  List<SensorReading> _historyReadings = [];
  bool _isLoading = false;
  bool _isLoadingHistory = false;
  String? _error;
  StatisticsPeriod _period = StatisticsPeriod.week;
  DateTime _selectedDate = DateTime.now();

  // Getters
  Device? get selectedDevice => _selectedDevice;
  SensorReading? get currentReading => _currentReading;
  List<SensorReading> get historyReadings => _historyReadings;
  bool get isLoading => _isLoading;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get error => _error;
  StatisticsPeriod get period => _period;
  DateTime get selectedDate => _selectedDate;

  // Date range based on period
  DateTimeRange get dateRange {
    final now = _selectedDate;
    if (_period == StatisticsPeriod.week) {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      return DateTimeRange(start: startOfWeek, end: endOfWeek);
    } else {
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      return DateTimeRange(start: startOfMonth, end: endOfMonth);
    }
  }

  // Set selected device
  void setDevice(Device device) {
    if (_selectedDevice?.id != device.id) {
      _selectedDevice = device;
      _currentReading = null;
      _historyReadings = [];
      _error = null;
      notifyListeners();
      loadData();
    }
  }

  // Set period
  void setPeriod(StatisticsPeriod newPeriod) {
    if (_period != newPeriod) {
      _period = newPeriod;
      notifyListeners();
      if (_selectedDevice != null) {
        loadHistory();
      }
    }
  }

  // Navigate to previous period
  void goToPreviousPeriod() {
    if (_period == StatisticsPeriod.week) {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
    } else {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
    }
    notifyListeners();
    if (_selectedDevice != null) {
      loadHistory();
    }
  }

  // Navigate to next period
  void goToNextPeriod() {
    if (_period == StatisticsPeriod.week) {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
    } else {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
    }
    notifyListeners();
    if (_selectedDevice != null) {
      loadHistory();
    }
  }

  // Load all data
  Future<void> loadData() async {
    if (_selectedDevice == null) return;

    await Future.wait([
      loadCurrentReading(),
      loadHistory(),
    ]);
  }

  // Load current reading
  Future<void> loadCurrentReading() async {
    if (_selectedDevice == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getCurrentReadingUseCase(deviceId: _selectedDevice!.id);

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (reading) {
        _currentReading = reading;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Load history
  Future<void> loadHistory() async {
    if (_selectedDevice == null) return;

    _isLoadingHistory = true;
    _error = null;
    notifyListeners();

    final range = dateRange;
    final startDate = _formatDate(range.start);
    final endDate = _formatDate(range.end);

    final result = await getReadingsHistoryUseCase(
      deviceId: _selectedDevice!.id,
      startDate: startDate,
      endDate: endDate,
    );

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoadingHistory = false;
        notifyListeners();
      },
      (readings) {
        _historyReadings = readings;
        _isLoadingHistory = false;
        notifyListeners();
      },
    );
  }

  // Format date for API (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
