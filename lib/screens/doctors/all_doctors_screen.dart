import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/doctor.dart';
import '../../models/doctor.dart' show dummyDoctors;
import 'doctor_detail_screen.dart';

// ФИКЦИИ: Типы услуг (Обновлено)
const List<String> _serviceTypes = [
  'All Services', 'Online Chat', 'Video Consultation', 'In-Person Meeting'
];
// ФИКЦИИ: Специальности
const List<String> _specialtyTags = [
  'All', 'Gynecologist', 'Fertility', 'Mammologist', 'Endocrinologist', 'Therapist'
];

class AllDoctorsScreen extends StatefulWidget {
  const AllDoctorsScreen({super.key});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {

  final Color primaryPink = const Color(0xFFFF89AC);
  final Color darkTextColor = const Color(0xFF4A4A6A);
  final Color lightBackgroundColor = const Color(0xFFFDEEF2);

  // --- Состояния Фильтров ---
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'Rating (High)'; // Сортировка по умолчанию: Звезды
  String _filterGender = 'All';
  String _filterServiceType = 'All Services';
  RangeValues _priceRange = const RangeValues(0, 30000);

  List<Doctor> _filteredDoctors = dummyDoctors;

  // --- ЛОГИКА ---

  @override
  void initState() {
    super.initState();
    _applyFiltersAndSort();
  }

  void _launchMap() async {
    // Используем центр Астаны для примера
    const url = 'https://www.google.com/maps/search/doctors+near+me';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open map application.')),
      );
    }
  }

  void _applyFiltersAndSort() {
    List<Doctor> result = dummyDoctors;

    // 1. ФИЛЬТРАЦИЯ ПО КАТЕГОРИИ
    if (_selectedCategory != 'All') {
      result = result
          .where((d) => d.specialty.contains(_selectedCategory))
          .toList();
    }

    // 2. ФИЛЬТРАЦИЯ ПО ПОЛУ
    if (_filterGender != 'All') {
      result = result.where((d) => d.gender == _filterGender).toList();
    }

    // 3. ФИЛЬТРАЦИЯ ПО ТИПУ УСЛУГИ (ОБНОВЛЕНО)
    if (_filterServiceType == 'Video Consultation') {
      // Пример: только дорогие врачи
      result = result.where((d) => d.consultationFee >= 10000).toList();
    } else if (_filterServiceType == 'Online Chat') {
      // Пример: все, кто ниже 15000
      result = result.where((d) => d.consultationFee < 15000).toList();
    } else if (_filterServiceType == 'In-Person Meeting') {
      // Пример: только врачи с наивысшим рейтингом (для живой встречи)
      result = result.where((d) => d.rating > 4.5).toList();
    }


    // 4. ФИЛЬТРАЦИЯ ПО ЦЕНОВОМУ ДИАПАЗОНУ
    result = result.where((d) =>
    d.consultationFee >= _priceRange.start &&
        d.consultationFee <= _priceRange.end
    ).toList();

    // 5. ПОИСК ПО ЗАПРОСУ
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result
          .where((d) =>
      d.name.toLowerCase().contains(query) ||
          d.specialty.toLowerCase().contains(query))
          .toList();
    }

    // 6. СОРТИРОВКА (ОБНОВЛЕНО)
    if (_sortBy == 'Price (Low)') {
      result.sort((a, b) => a.consultationFee.compareTo(b.consultationFee));
    } else if (_sortBy == 'Rating (High)') {
      // Сортировка по звездам
      result.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'Recommended') {
      // Сортировка по рекомендованным (например, по рейтингу)
      result.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    }

    setState(() {
      _filteredDoctors = result;
    });
  }

  // --- WIDGETS ---

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'kk_KZ',
      symbol: '₸',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Widget _buildFilterChip(String label, String currentState, StateSetter setModalState, ValueChanged<String> onStateChange) {
    final isSelected = label == currentState;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setModalState(() {
            onStateChange(label);
          });
        }
      },
      selectedColor: primaryPink.withOpacity(0.9),
      backgroundColor: lightBackgroundColor.withOpacity(0.5),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : darkTextColor,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  void _showFilterSheet() {
    String tempSortBy = _sortBy;
    String tempFilterGender = _filterGender;
    String tempFilterServiceType = _filterServiceType;
    RangeValues tempPriceRange = _priceRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50, height: 5, margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  Text('Sort & Filter', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkTextColor)),
                  const Divider(height: 30),

                  // СОРТИРОВКА (ОБНОВЛЕНО)
                  Text('Sort By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: darkTextColor)),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildFilterChip('Rating (High)', tempSortBy, setModalState, (val) => tempSortBy = val), // Сортировка по звездам
                      _buildFilterChip('Price (Low)', tempSortBy, setModalState, (val) => tempSortBy = val),
                      _buildFilterChip('Recommended', tempSortBy, setModalState, (val) => tempSortBy = val),
                    ],
                  ),
                  const Divider(height: 30),

                  // ФИЛЬТР ПО ПОЛУ
                  Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: darkTextColor)),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildFilterChip('All', tempFilterGender, setModalState, (val) => tempFilterGender = val),
                      _buildFilterChip('Female', tempFilterGender, setModalState, (val) => tempFilterGender = val),
                      _buildFilterChip('Male', tempFilterGender, setModalState, (val) => tempFilterGender = val),
                    ],
                  ),
                  const Divider(height: 30),

                  // ФИЛЬТР: ТИП УСЛУГИ (ОБНОВЛЕНО)
                  Text('Service Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: darkTextColor)),
                  Wrap(
                    spacing: 10,
                    children: _serviceTypes.map((type) =>
                        _buildFilterChip(type, tempFilterServiceType, setModalState, (val) => tempFilterServiceType = val)
                    ).toList(),
                  ),
                  const Divider(height: 30),

                  // ФИЛЬТР: ДИАПАЗОН ЦЕН
                  Text('Price Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: darkTextColor)),
                  Text(
                    '${formatCurrency(tempPriceRange.start)} - ${formatCurrency(tempPriceRange.end)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryPink),
                  ),
                  RangeSlider(
                    values: tempPriceRange,
                    min: 0,
                    max: 30000,
                    divisions: 60,
                    activeColor: primaryPink,
                    inactiveColor: lightBackgroundColor,
                    labels: RangeLabels(
                      formatCurrency(tempPriceRange.start),
                      formatCurrency(tempPriceRange.end),
                    ),
                    onChanged: (RangeValues newValues) {
                      setModalState(() {
                        tempPriceRange = newValues;
                      });
                    },
                  ),
                  const SizedBox(height: 20),


                  // Кнопка Применить
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _sortBy = tempSortBy;
                          _filterGender = tempFilterGender;
                          _filterServiceType = tempFilterServiceType;
                          _priceRange = tempPriceRange;
                          _applyFiltersAndSort();
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBarAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: lightBackgroundColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: primaryPink.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _applyFiltersAndSort();
                });
              },
              style: TextStyle(color: darkTextColor, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Search doctor...',
                hintStyle: TextStyle(color: darkTextColor.withOpacity(0.5), fontSize: 16),
                prefixIcon: Icon(Icons.search, color: primaryPink, size: 24),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 54,
          width: 54,
          decoration: BoxDecoration(
            color: primaryPink,
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune_outlined, color: Colors.white),
            onPressed: _showFilterSheet,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTags() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _specialtyTags.length,
        itemBuilder: (context, index) {
          final tag = _specialtyTags[index];
          final isSelected = tag == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = tag;
                    _applyFiltersAndSort();
                  });
                }
              },
              selectedColor: primaryPink,
              backgroundColor: lightBackgroundColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : darkTextColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              elevation: 2,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    final bool isFemale = doctor.gender == 'Female';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailScreen(doctor: doctor),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: darkTextColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: lightBackgroundColor,
              child: Icon(
                isFemale ? Icons.person_3_rounded : Icons.person_rounded,
                color: primaryPink,
                size: 40,
              ),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    doctor.specialty,
                    style: TextStyle(
                      fontSize: 13,
                      color: primaryPink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: darkTextColor.withOpacity(0.6), size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          doctor.hospital,
                          style: TextStyle(
                            fontSize: 12,
                            color: darkTextColor.withOpacity(0.8),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Рейтинг и Цена справа
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: darkTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  formatCurrency(doctor.consultationFee),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: primaryPink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor.withOpacity(0.5),
      appBar: AppBar(
        title: Text(
          'All Doctors',
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextColor),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildSearchBarAndFilter(),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildCategoryTags(),
          ),
          const SizedBox(height: 15),

          Expanded(
            child: _filteredDoctors.isEmpty
                ? Center(
              child: Text(
                'No doctors match your criteria. Try adjusting the filters.',
                style: TextStyle(fontSize: 16, color: darkTextColor.withOpacity(0.7)),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 100),
              itemCount: _filteredDoctors.length,
              itemBuilder: (context, index) {
                return _buildDoctorCard(context, _filteredDoctors[index]);
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchMap,
        label: const Text('View on Map', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        icon: const Icon(Icons.map_outlined),
        backgroundColor: primaryPink,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}