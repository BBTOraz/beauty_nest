import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/stylist.dart';
import '../repositories/stylist_repository.dart';
import '../services/stylist_service.dart';
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
  final List<String> _specializations = ['Все', 'Стрижки', 'Окрашивание', 'Укладка', 'Макияж'];
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Load stylists when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StylistService>(context, listen: false).loadStylists();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Имитация фильтрации
  List<Stylist> filteredStylists(List<Stylist> stylists) {
    return stylists.where((stylist) {
      // Поиск по имени или фамилии
      bool matchesSearch = _searchQuery.isEmpty ||
          stylist.firstName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          stylist.lastName.toLowerCase().contains(_searchQuery.toLowerCase());

      // Фильтр по специализации
      bool matchesSpecialization = _selectedSpecialization == 'Все' ||
          stylist.specialization == _selectedSpecialization;

      // Фильтр по доступности (просто для примера, на практике нужна реальная логика)
      bool matchesAvailability = !_onlyAvailableNow || stylist.isAvailable! ?? false;

      return matchesSearch && matchesSpecialization && matchesAvailability;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stylistService = Provider.of<StylistService>(context);
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
                  for (final specialization in _specializations.where((s) => s != 'Все'))
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
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
                        Provider.of<StylistService>(context, listen: false).loadStylists();
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
                itemBuilder: (context, index) => ImprovedStylistCard(
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
                const Text(
                  'Услуги',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
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
                const Text(
                  'Рейтинг',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [4, 4.5, 4.8].map((rating) {
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(' $rating+'),
                        ],
                      ),
                      selected: false, // Логика выбора рейтинга
                      onSelected: (selected) {
                        // Логика фильтрации по рейтингу
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Стоимость услуг',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                RangeSlider(
                  values: const RangeValues(1000, 5000),
                  min: 0,
                  max: 10000,
                  divisions: 20,
                  labels: const RangeLabels('1000₽', '5000₽'),
                  onChanged: (values) {
                    // Логика фильтрации по цене
                  },
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Показать только с фото работ'),
                  value: true, // Логика переключения
                  onChanged: (_) {
                    // Логика фильтрации
                  },
                ),
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
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Сбросить все фильтры
                          setModalState(() {
                            _selectedSpecialization = 'Все';
                            _onlyAvailableNow = false;
                          });
                          setState(() {
                            _selectedSpecialization = 'Все';
                            _onlyAvailableNow = false;
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
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text('По рейтингу (высокий → низкий)'),
              onTap: () {
                Navigator.pop(context);
                // Логика сортировки
              },
            ),
            ListTile(
              leading: const Icon(Icons.price_change, color: Colors.green),
              title: const Text('По цене (низкая → высокая)'),
              onTap: () {
                Navigator.pop(context);
                // Логика сортировки
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.blue),
              title: const Text('По доступности (ближайшее время)'),
              onTap: () {
                Navigator.pop(context);
                // Логика сортировки
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review, color: Colors.purple),
              title: const Text('По количеству отзывов'),
              onTap: () {
                Navigator.pop(context);
                // Логика сортировки
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickBookingOptions(BuildContext context) {
    // Получаем список доступных стилистов
    final List<Stylist> availableStylists = static_stylists.where((stylist) => stylist.isAvailable ?? false).toList();

    // Определяем список услуг для выбора
    final List<String> services = _specializations.where((s) => s != 'Все').toList();
    String selectedService = services[0]; // По умолчанию первая услуга

    // Создаем список доступных временных слотов (пример)
    final List<String> timeSlots = List.generate(8, (index) => '${10 + index}:00');
    String selectedTimeSlot = timeSlots[0]; // По умолчанию первый временной слот

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.7,
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
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: availableStylists.length,
                  itemBuilder: (context, index) {
                    final stylist = availableStylists[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: AssetImage(stylist.photo),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${stylist.firstName} ${stylist.lastName[0]}.',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const SizedBox(width: 2),
                              Text('${stylist.rating.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                            ],
                          ),
                        ],
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
                children: services.map((service) => ChoiceChip(
                  label: Text(service),
                  selected: selectedService == service,
                  onSelected: (selected) {
                    if (selected) {
                      setModalState(() {
                        selectedService = service;
                      });
                    }
                  },
                )).toList(),
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
                          color: selectedTimeSlot == timeSlot ? Colors.white : Colors.black87,
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
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Логика записи с использованием выбранных данных
                    final selectedStylist = availableStylists.isNotEmpty ? availableStylists[0] : null;

                    Navigator.pop(context);

                    if (selectedStylist != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Вы успешно записаны к ${selectedStylist.firstName} на $selectedService в $selectedTimeSlot!'
                          ),
                          backgroundColor: Colors.green,
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
                          '${stylist.rating.toStringAsFixed(2)}',
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
                          '${stylist.commentCount}',
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