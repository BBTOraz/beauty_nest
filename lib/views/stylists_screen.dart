import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../enum/sort_options.dart';
import '../model/stylist.dart';
import '../repositories/stylist_repository.dart';
import '../services/stylist_service.dart';
import '../utils/minPrice.dart';
import '../viewmodels/auth_view_model.dart';
import '../views/stylist_details_screen.dart';

class StylistsListScreen extends StatefulWidget {
  const StylistsListScreen({super.key});

  @override
  State<StylistsListScreen> createState() => _StylistsListScreenState();
}

class _StylistsListScreenState extends State<StylistsListScreen> {
  String _searchQuery = '';
  String _selectedSpecialization = 'Все';
  bool _onlyAvailableNow = false;
  double _selectedMinRating = 0.0;
  RangeValues _priceRange = const RangeValues(0, 10000);
  bool _showOnlyWithPhoto = false;
  SortOption? _sortOption;

  final List<String> _specializations = [
    'Стрижки',
    'Окрашивание',
    'Укладка',
    'Химическая завивка',
    'Восстановительные процедуры',
    'Маникюр',
    'Педикюр',
    'Дизайн ногтей',
    'Чистка лица',
    'Пилинги',
    'Маски',
    'Мезотерапия',
    'Инъекции',
    'Лазерные процедуры',
    'Депиляция (восковая)',
    'Депиляция (шугаринг)',
    'Депиляция (лазерная)',
    'Депиляция (электроэпиляция)',
    'Макияж (дневной)',
    'Макияж (вечерний)',
    'Макияж (свадебный)',
    'Макияж (пробный)',
    'Макияж (перманентный)',
    'Уход за бровями и ресницами',
    'Коррекция бровей',
    'Оформление бровей',
    'Окрашивание бровей',
    'Ламинирование',
    'Наращивание ресниц',
    'Уход за телом',
    'Массаж',
    'SPA-процедуры',
    'Обертывания',
    'Консультации стилиста',
  ];
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StylistService>(context, listen: false).loadStylists();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Stylist> filteredStylists(List<Stylist> stylists) {
    List<Stylist> result = stylists.where((stylist) {
      final matchesSearch = _searchQuery.isEmpty ||
          stylist.firstName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          stylist.lastName.toLowerCase().contains(_searchQuery.toLowerCase());

      // 2. По специализации
      final matchesSpecialization = _selectedSpecialization == 'Все' ||
          stylist.specialization == _selectedSpecialization;

      // 3. Свободны сегодня
      final matchesAvailability = !_onlyAvailableNow || (stylist.isAvailable ?? false);

      // 4. Рейтинг
      final matchesRating = stylist.rating >= _selectedMinRating;

      // 5. Есть ли хотя бы одна услуга в нужном ценовом диапазоне?
      //    Допустим, в stylist.services есть Service.price
      bool matchesPrice = false;
      for (final service in stylist.services) {
        if (service.price >= _priceRange.start && service.price <= _priceRange.end) {
          matchesPrice = true;
          break;
        }
      }

      // 6. Фото работ (например, если portfolioImages не пуст)
      final matchesPhoto = !_showOnlyWithPhoto || stylist.portfolioImages.isNotEmpty;

      return matchesSearch
          && matchesSpecialization
          && matchesAvailability
          && matchesRating
          && matchesPrice
          && matchesPhoto;
    }).toList();

    switch (_sortOption) {
      case SortOption.ratingDesc:
      // Сначала самые высокие рейтинги
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;

      case SortOption.priceAsc:
      // Сортируем по минимальной цене услуги. Нужно определить функцию getMinPrice(stylist)
        result.sort((a, b) => getMinPrice(a).compareTo(getMinPrice(b)));
        break;

      case SortOption.availability:
      // Например, доступных (true) ставим в начало
      // isAvailable == true → 1, false → 0, и сравниваем в обратном порядке
        result.sort((a, b) {
          int valA = (a.isAvailable == true) ? 1 : 0;
          int valB = (b.isAvailable == true) ? 1 : 0;
          return valB.compareTo(valA);
        });
        break;

      case SortOption.reviewsDesc:
      // У кого больше commentCount, тот выше
        result.sort((a, b) => b.commentCount.compareTo(a.commentCount));
        break;

    // Если _sortOption может быть null или ещё что-то
      default:
        break;
    }

    return result;
  }


  @override
  Widget build(BuildContext context) {
    final stylistService = Provider.of<StylistService>(context);
    print(stylistService.stylists);
    final List<Stylist> allStylists = stylistService.stylists;
    final bool isLoading = stylistService.isLoading;
    final String? error = stylistService.error;


    final List<Stylist> stylists = filteredStylists(allStylists);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Найти стилиста'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              _searchFocusNode.unfocus();
              _showFilterBottomSheet(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _searchFocusNode.unfocus();
              _showSortOptions(context);
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Убрать фокус с поискового поля при тапе за пределами поля
          _searchFocusNode.unfocus();
        },
        child: Column(
          children: [
            // Поисковая строка
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                focusNode: _searchFocusNode,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Найти стилиста...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Чипы для быстрой фильтрации
            SizedBox(
              height: 50,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip(
                    label: 'Все услуги',
                    isSelected: _selectedSpecialization == 'Все',
                    onTap: () {
                      _searchFocusNode.unfocus();
                      setState(() {
                        _selectedSpecialization = 'Все';
                      });
                    },
                  ),
                  for (final specialization in _specializations.where((
                      s) => s != 'Все'))
                    _buildFilterChip(
                      label: specialization,
                      isSelected: _selectedSpecialization == specialization,
                      onTap: () {
                        _searchFocusNode.unfocus();
                        setState(() {
                          _selectedSpecialization = specialization;
                        });
                      },
                    ),
                  _buildFilterChip(
                    label: 'Свободны сегодня',
                    isSelected: _onlyAvailableNow,
                    onTap: () {
                      _searchFocusNode.unfocus();
                      setState(() {
                        _onlyAvailableNow = !_onlyAvailableNow;
                      });
                    },
                    icon: Icons.today,
                  ),
                ],
              ),
            ),

            // Информация о количестве найденных стилистов
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Найдено ${stylists.length} стилистов',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('Салоны'),
                    onPressed: () {
                      _searchFocusNode.unfocus();
                      // Показать салоны на карте
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              )
                  : error != null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                        Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Ошибка загрузки данных',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<StylistService>(context, listen: false)
                            .loadStylists();
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              )
                  : stylists.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Стилисты не найдены',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Попробуйте изменить параметры поиска',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: stylists.length,
                itemBuilder: (context, index) =>
                    ImprovedStylistCard(
                      stylist: stylists[index],
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _searchFocusNode.unfocus();
          // Логика для быстрой записи
          _showQuickBookingOptions(context);
        },
        label: const Text('Записаться сегодня'),
        icon: const Icon(Icons.event_available),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.pink,
              ),
              const SizedBox(width: 4),
            ],
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: Colors.pink,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        expand: false,
        builder: (_, controller) => StatefulBuilder(
          builder: (context, setModalState) => Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              controller: controller,
              children: [
                const Center(
                  child: Text(
                    'Фильтры',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 30),

                // 1. Фильтр "Услуги" (как и было)
                const Text('Услуги', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _specializations.map((spec) {
                    return ChoiceChip(
                      label: Text(spec),
                      selected: _selectedSpecialization == spec,
                      onSelected: (selected) {
                        setModalState(() {
                          _selectedSpecialization = selected ? spec : 'Все';
                        });
                        setState(() {
                          _selectedSpecialization = selected ? spec : 'Все';
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 2. Фильтр по рейтингу (минимальный рейтинг)
                const Text('Рейтинг', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [4.0, 4.5, 4.8].map((rating) {
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(' $rating+'),
                        ],
                      ),
                      selected: _selectedMinRating == rating, // _selectedMinRating - переменная в State
                      onSelected: (selected) {
                        setModalState(() {
                          // если выбираем — ставим рейтинг, если снимаем выбор — обнуляем
                          _selectedMinRating = selected ? rating : 0.0;
                        });
                        setState(() {
                          _selectedMinRating = selected ? rating : 0.0;
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // 3. Фильтр по стоимости услуг (RangeSlider)
                const Text('Стоимость услуг', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                RangeSlider(
                  values: _priceRange, // _priceRange - переменная типа RangeValues
                  min: 0,
                  max: 10000,
                  divisions: 20,
                  labels: RangeLabels(
                    '${_priceRange.start.round()}₽',
                    '${_priceRange.end.round()}₽',
                  ),
                  onChanged: (values) {
                    setModalState(() {
                      _priceRange = values;
                    });
                    setState(() {
                      _priceRange = values;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // 4. Фильтр "Показать только с фото работ"
                SwitchListTile(
                  title: const Text('Показать только с фото работ'),
                  value: _showOnlyWithPhoto, // _showOnlyWithPhoto - bool
                  onChanged: (value) {
                    setModalState(() {
                      _showOnlyWithPhoto = value;
                    });
                    setState(() {
                      _showOnlyWithPhoto = value;
                    });
                  },
                ),

                // 5. Свободны сегодня (уже было, но добавили setModalState)
                SwitchListTile(
                  title: const Text('Свободны сегодня'),
                  value: _onlyAvailableNow,
                  onChanged: (value) {
                    setModalState(() {
                      _onlyAvailableNow = value;
                    });
                    setState(() {
                      _onlyAvailableNow = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Кнопки "Сбросить" и "Применить"
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Сбросить все фильтры
                          setModalState(() {
                            _selectedSpecialization = 'Все';
                            _onlyAvailableNow = false;
                            _selectedMinRating = 0.0;
                            _priceRange = const RangeValues(0, 10000);
                            _showOnlyWithPhoto = false;
                          });
                          setState(() {
                            _selectedSpecialization = 'Все';
                            _onlyAvailableNow = false;
                            _selectedMinRating = 0.0;
                            _priceRange = const RangeValues(0, 10000);
                            _showOnlyWithPhoto = false;
                          });
                        },
                        child: const Text('Сбросить'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // После закрытия окна — фильтрация уже будет
                          // учтена в filteredStylists(), если вы её используете.
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                        ),
                        child: const Text('Применить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Сортировка',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 1) Сортировка по рейтингу (высокий → низкий)
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text('По рейтингу (высокий → низкий)'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _sortOption = SortOption.ratingDesc;
                });
              },
            ),

            // 2) Сортировка по цене (низкая → высокая)
            ListTile(
              leading: const Icon(Icons.price_change, color: Colors.green),
              title: const Text('По цене (низкая → высокая)'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _sortOption = SortOption.priceAsc;
                });
              },
            ),

            // 3) По доступности (сначала доступные)
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.blue),
              title: const Text('По доступности (ближайшее время)'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _sortOption = SortOption.availability;
                });
              },
            ),

            // 4) По количеству отзывов (много → мало)
            ListTile(
              leading: const Icon(Icons.rate_review, color: Colors.purple),
              title: const Text('По количеству отзывов'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _sortOption = SortOption.reviewsDesc;
                });
              },
            ),
          ],
        ),
      ),
    );
  }


  void _showQuickBookingOptions(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final stylistService = Provider.of<StylistService>(context, listen: false);
    final List<Stylist> availableStylists =
    stylistService.stylists.where((stylist) => stylist.isAvailable ?? false).toList();
    final List<String> services =
    _specializations.where((s) => s != 'Все').toList();
    String selectedService = services.isNotEmpty ? services[0] : '';

    final List<String> timeSlots =
    List.generate(8, (index) => '${10 + index}:00');
    String selectedTimeSlot = timeSlots.isNotEmpty ? timeSlots[0] : '';

    // Выбираем любого стилиста по умолчанию (если есть)
    Stylist? selectedStylist =
    availableStylists.isNotEmpty ? availableStylists[0] : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            // Высота 70% экрана, можно регулировать
            height: MediaQuery.of(context).size.height * 0.7,
            // Для прокрутки всего содержимого оборачиваем в SingleChildScrollView
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Запись на сегодня',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 30),
                  const Text(
                    'Свободные стилисты сегодня',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 125,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableStylists.length,
                      itemBuilder: (context, index) {
                        final stylist = availableStylists[index];
                        final bool isSelected = selectedStylist == stylist;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedStylist = stylist;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.pink : Colors.transparent,
                                width: 2,
                              ),
                              color: isSelected ? Colors.pink.withOpacity(0.1) : Colors.transparent,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: AssetImage(stylist.photo),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.pink,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${stylist.firstName} ${stylist.lastName[0]}.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.pink : Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 14),
                                    const SizedBox(width: 2),
                                    Text(
                                      stylist.rating.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected ? Colors.pink[700] : Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Выберите услугу',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: services.map((service) {
                      return ChoiceChip(
                        label: Text(service),
                        selected: selectedService == service,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              selectedService = service;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Выберите время',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        final timeSlot = timeSlots[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(timeSlot),
                            selected: selectedTimeSlot == timeSlot,
                            backgroundColor: Colors.grey[200],
                            selectedColor: Colors.pink,
                            labelStyle: TextStyle(
                              color: selectedTimeSlot == timeSlot
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() {
                                  selectedTimeSlot = timeSlot;
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Кнопка "Записаться"
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // 1. Валидация: проверяем, выбраны ли услуга и время
                        if (selectedService.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Выберите услугу'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        if (selectedTimeSlot.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Выберите время'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final now = DateTime.now();
                        final dateString =
                        DateFormat('dd-MM-yyyy').format(now);

                        final bookingData = {
                          'userId': authVM.user?.uid ?? '',
                          'service': selectedService,
                          'selectedTime': selectedTimeSlot,
                          'selectedDate': DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1))).toString(),
                          'bookingTimestamp': Timestamp.now(),
                          'stylistName': selectedStylist != null
                              ? '${selectedStylist!.firstName} ${selectedStylist!.lastName}'
                              : '',
                        };

                        try {
                          // Записываем в коллекцию bookings -> документ dateString
                          // set(..., SetOptions(merge: true)) чтобы не перетирать данные, если док уже есть
                          await FirebaseFirestore.instance
                              .collection('bookings')
                              .doc(dateString)
                              .set(bookingData, SetOptions(merge: true));

                          if (authVM.user != null) {
                            final userRef = FirebaseFirestore.instance
                                .collection('users')
                                .doc(authVM.user!.uid);

                            // Пример - добавляем в массив "bookings"
                            await userRef.update({
                              'bookings': FieldValue.arrayUnion([bookingData])
                            });
                          }

                          // Успешное бронирование
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Запись оформлена: ${selectedStylist?.firstName ?? ''} на $selectedService в $selectedTimeSlot'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ошибка записи: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Записаться',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

  class ImprovedStylistCard extends StatelessWidget {
  final Stylist stylist;

  const ImprovedStylistCard({super.key, required this.stylist});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StylistDetailScreen(stylist: stylist),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Фото стилиста
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  stylist.photo,
                  width: 100,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              // Информация о стилисте
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${stylist.firstName} ${stylist.lastName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (stylist.isAvailable ?? false)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Доступен',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Специализация
                    Text(
                      stylist.specialization,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Рейтинг
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          stylist.rating.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' (${stylist.ratingCount})',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${stylist.comments.length}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Салон или адрес
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            stylist.address,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Кнопки действий
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // Логика открытия профиля
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 0,
                              ),
                              minimumSize: const Size(0, 32),
                            ),
                            child: const Text(
                              'Профиль',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Логика записи к стилисту
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 0,
                              ),
                              minimumSize: const Size(0, 32),
                            ),
                            child: const Text(
                              'Записаться',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}