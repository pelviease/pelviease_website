import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/firebase_services/doctor_service.dart';
import 'package:pelviease_website/backend/models/our_content.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorService _doctorService = DoctorService();

  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  String _selectedLocation = '';
  bool _hasInitialized = false;

  List<Doctor> get allDoctors => _allDoctors;
  List<Doctor> get filteredDoctors => _filteredDoctors;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedLocation => _selectedLocation;
  bool get hasInitialized => _hasInitialized;

  List<String> get availableLocations {
    return _allDoctors.map((doctor) => doctor.location).toSet().toList()
      ..sort();
  }

  List<String> get availableSpecializations {
    return _allDoctors.map((doctor) => doctor.specialization).toSet().toList()
      ..sort();
  }

  Future<void> initializeDoctors() async {
    if (_hasInitialized) return;

    _setLoading(true);
    try {
      _allDoctors = await _doctorService.fetchDoctorsOnce();
      _filteredDoctors = List.from(_allDoctors);
      _errorMessage = '';
      _hasInitialized = true;
    } catch (e) {
      _errorMessage = e.toString();
      _allDoctors = [];
      _filteredDoctors = [];
    } finally {
      _setLoading(false);
    }
  }

  void searchDoctors(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void filterByLocation(String location) {
    _selectedLocation = location;
    _applyFilters();
  }

  void filterBySpecialization(String specialization) {
    _searchQuery = specialization.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    List<Doctor> filtered = List.from(_allDoctors);

    if (_selectedLocation.isNotEmpty) {
      filtered = filtered
          .where((doctor) =>
              doctor.location.toLowerCase() == _selectedLocation.toLowerCase())
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((doctor) {
        return doctor.name.toLowerCase().contains(_searchQuery) ||
            doctor.specialization.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    _filteredDoctors = filtered;
    notifyListeners();
  }

  Doctor? getDoctorById(String doctorId) {
    try {
      return _allDoctors.firstWhere((doctor) => doctor.id == doctorId);
    } catch (e) {
      return null;
    }
  }

  List<Doctor> getDoctorsBySpecialization(String specialization) {
    return _allDoctors
        .where((doctor) =>
            doctor.specialization.toLowerCase() == specialization.toLowerCase())
        .toList();
  }

  List<Doctor> getDoctorsByLocation(String location) {
    return _allDoctors
        .where(
            (doctor) => doctor.location.toLowerCase() == location.toLowerCase())
        .toList();
  }

  void sortDoctorsByName({bool ascending = true}) {
    _filteredDoctors.sort((a, b) {
      return ascending
          ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
          : b.name.toLowerCase().compareTo(a.name.toLowerCase());
    });
    notifyListeners();
  }

  void sortDoctorsBySpecialization({bool ascending = true}) {
    _filteredDoctors.sort((a, b) {
      return ascending
          ? a.specialization
              .toLowerCase()
              .compareTo(b.specialization.toLowerCase())
          : b.specialization
              .toLowerCase()
              .compareTo(a.specialization.toLowerCase());
    });
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedLocation = '';
    _filteredDoctors = List.from(_allDoctors);
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
  }

  void clearLocationFilter() {
    _selectedLocation = '';
    _applyFilters();
  }

  int get totalDoctorsCount => _allDoctors.length;
  int get filteredDoctorsCount => _filteredDoctors.length;

  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty || _selectedLocation.isNotEmpty;

  String get filterSummary {
    List<String> filters = [];
    if (_searchQuery.isNotEmpty) filters.add('Search: "$_searchQuery"');
    if (_selectedLocation.isNotEmpty) {
      filters.add('Location: "$_selectedLocation"');
    }

    return filters.join(', ');
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void reset() {
    _allDoctors = [];
    _filteredDoctors = [];
    _isLoading = false;
    _errorMessage = '';
    _searchQuery = '';
    _selectedLocation = '';
    _hasInitialized = false;
    notifyListeners();
  }
}
