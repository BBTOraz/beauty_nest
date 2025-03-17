import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/stylist.dart';
import '../viewmodels/auth_view_model.dart';
import '../widgets/comments.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class StylistDetailScreen extends StatefulWidget {
  final Stylist stylist;
  const StylistDetailScreen({super.key, required this.stylist});

  @override
  State<StylistDetailScreen> createState() => _StylistDetailScreenState();
}


class _StylistDetailScreenState extends State<StylistDetailScreen> {
  double _userRating = 5.0;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Comment> _sortedComments = [];

  @override
  void initState() {
    super.initState();
    _sortedComments = List.from(widget.stylist.comments ?? []);
  }


  Future<void> _fetchComments() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('stylists')
        .doc(widget.stylist.id)
        .get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null && data.containsKey('comments')) {
        final commentsList = data['comments'] as List<dynamic>;
        final updatedComments = commentsList
            .map((e) => Comment.fromMap(e as Map<String, dynamic>))
            .toList();
        print("updated comments: $updatedComments");
        setState(() {
          _sortedComments = List.from(updatedComments);
        });
      }
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.stylist.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black45,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.stylist.photo,
                    fit: BoxFit.cover,
                  ),
                  // Градиент для читаемости текста
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black45,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Информация о стилисте
          SliverToBoxAdapter(
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.stylist.rating.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' (${_sortedComments.length} отзывов)',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Записаться'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: widget.stylist.isAvailable == true
                              ? () {
                            _showBookingDialog(context);
                          }
                              : null,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Статус доступности стилиста
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.stylist.isAvailable == true
                            ? Colors.green[50]
                            : Colors.red[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: widget.stylist.isAvailable == true
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      child: Text(
                        widget.stylist.isAvailable == true
                            ? 'Доступен для записи'
                            : 'Недоступен для записи',
                        style: TextStyle(
                          color: widget.stylist.isAvailable == true
                              ? Colors.green[800]
                              : Colors.red[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Цитата стилиста
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.format_quote,
                            color: Colors.blueAccent,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '"${widget.stylist.quote}"',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[800],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Специализация и адрес
                    _buildInfoRow(Icons.design_services, 'Специализация',
                        widget.stylist.specialization),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        Icons.location_on, 'Адрес', widget.stylist.address),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.store, 'Салон', widget.stylist.salon),

                    // Опыт и информация
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        Icons.work, 'Опыт', '${widget.stylist.experience} лет'),

                    const SizedBox(height: 24),

                    // Раздел с сертификатами
                    if (widget.stylist.certificates.isNotEmpty) ...[
                      const Text(
                        'Сертификаты',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...widget.stylist.certificates.map((cert) =>
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.verified, color: Colors.green,
                                    size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(cert),
                                ),
                              ],
                            ),
                          )).toList(),
                      const SizedBox(height: 16),
                    ],

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'О стилисте',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.stylist.description,
                          style: TextStyle(
                            height: 1.5,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),

                    // Список услуг
                    if (widget.stylist.services.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Услуги',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.stylist.services.map((service) =>
                          _buildServiceItem(service)).toList(),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Портфолио (если есть)
          if (widget.stylist.portfolioImages.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Text(
                      'Портфолио',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: widget.stylist.portfolioImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              widget.stylist.portfolioImages[index],
                              height: 200,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

          // Секция отзывов
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Отзывы клиентов',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.sort),
                    label: const Text('Сортировать'),
                    onPressed: () {
                      _showSortDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Список отзывов
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final comment = _sortedComments[index];
                return ImprovedCommentCard(comment: comment);
              },
              childCount: _sortedComments.length,
            ),
          ),

          // Форма для нового отзыва
          SliverToBoxAdapter(
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Оставить отзыв',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RatingBar.builder(
                      initialRating: 5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 24,
                      itemBuilder: (context, _) =>
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _userRating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Поделитесь своим опытом...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _submitComment();
                        },
                        child: const Text('Опубликовать'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Отступ внизу
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  // Отображение услуги
  Widget _buildServiceItem(Service service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (service.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      service.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '${service.durationMinutes} мин',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${service.price.toStringAsFixed(0)} ₽',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.blueAccent,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  void _showBookingDialog(BuildContext context) {
    String selectedDate = widget.stylist.availableTimeSlots.keys.first;
    List<TimeSlot> availableSlots = widget.stylist
        .availableTimeSlots[selectedDate] ?? [];
    TimeSlot? selectedTimeSlot = availableSlots.isNotEmpty ? availableSlots
        .first : null;
    Service? selectedService = widget.stylist.services.isNotEmpty ? widget
        .stylist.services.first : null;

    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(
            builder: (context, setState) =>
                AlertDialog(
                  title: const Text('Запись к стилисту'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Выберите дату:'),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: selectedDate,
                          items: widget.stylist.availableTimeSlots.keys.map((
                              date) {
                            return DropdownMenuItem(
                              value: date,
                              child: Text(date),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedDate = newValue!;
                              availableSlots = widget.stylist
                                  .availableTimeSlots[selectedDate] ?? [];
                              selectedTimeSlot = availableSlots.isNotEmpty
                                  ? availableSlots.first
                                  : null;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text('Выберите время:'),
                        const SizedBox(height: 8),
                        if (availableSlots.isEmpty)
                          const Text('Нет доступного времени на эту дату')
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: availableSlots.map((slot) {
                              final startTime = '${slot.startTime.hour
                                  .toString().padLeft(2, '0')}:${slot.startTime
                                  .minute.toString().padLeft(2, '0')}';
                              return ChoiceChip(
                                label: Text(startTime),
                                selected: selectedTimeSlot == slot,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      selectedTimeSlot = slot;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 16),
                        const Text('Выберите услугу:'),
                        const SizedBox(height: 8),
                        DropdownButton<Service>(
                          isExpanded: true,
                          value: selectedService,
                          items: widget.stylist.services.map((service) {
                            return DropdownMenuItem(
                              value: service,
                              child: Text(
                                  '${service.name} - ${service.price} ₽'),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedService = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Отмена'),
                    ),
                    ElevatedButton(
                      onPressed: selectedTimeSlot != null &&
                          selectedService != null
                          ? () async {
                        // Формирование объекта бронирования
                        final bookingData = {
                          'stylistId': widget.stylist.id,
                          'stylistName': widget.stylist.fullName,
                          'selectedDate': selectedDate,
                          'selectedTime': '${selectedTimeSlot!.startTime.hour
                              .toString().padLeft(2, '0')}:${selectedTimeSlot!
                              .startTime.minute.toString().padLeft(2, '0')}',
                          'service': selectedService!.name,
                          'price': selectedService!.price,
                          'bookingTimestamp': Timestamp.now(),
                        };

                        try {
                          await FirebaseFirestore.instance
                              .collection('bookings')
                              .add(bookingData);
                          final authVM = Provider.of<AuthViewModel>(
                              context, listen: false);
                          if (authVM.user != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(authVM.user!.uid)
                                .update({
                              'bookings': FieldValue.arrayUnion([bookingData])
                            });
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Вы записаны к ${widget.stylist
                                      .fullName} на $selectedDate в ${selectedTimeSlot!
                                      .startTime.hour.toString().padLeft(
                                      2, '0')}:${selectedTimeSlot!.startTime
                                      .minute.toString().padLeft(2, '0')}'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ошибка записи: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                          : null,
                      child: const Text('Подтвердить'),
                    ),
                  ],
                ),
          ),
    );
  }


  void _showSortDialog(BuildContext context) {
    final currentOffset = _scrollController.offset;
    showDialog(
      context: context,
      builder: (context) =>
          SimpleDialog(
            title: const Text('Сортировать отзывы'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _sortedComments.sort((a, b) => b.date.compareTo(a.date));
                  });
                  _scrollController.jumpTo(currentOffset);
                },
                child: const Text('По дате (сначала новые)'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _sortedComments.sort((a, b) => a.date.compareTo(b.date));
                  });
                  _scrollController.jumpTo(currentOffset);
                },
                child: const Text('По дате (сначала старые)'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _sortedComments.sort((a, b) =>
                        b.ratingCount.compareTo(a.ratingCount));
                  });
                  _scrollController.jumpTo(currentOffset);
                },
                child: const Text('По рейтингу (высокий рейтинг)'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _sortedComments.sort((a, b) =>
                        a.ratingCount.compareTo(b.ratingCount));
                  });
                  _scrollController.jumpTo(currentOffset);
                },
                child: const Text('По рейтингу (низкий рейтинг)'),
              ),
            ],
          ),
    );
  }


  void _submitComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, введите текст отзыва'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    if (authVM.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, войдите, чтобы оставить отзыв'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final commentId = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    final commentData = {
      'id': commentId,
      'text': commentText,
      'likes': 0,
      'userId': authVM.user!.uid,
      'photo': 'assets/avatars/anonymous.jpg',
      'name': '${authVM.userModel?.firstName ?? ''} ${authVM.userModel
          ?.lastName ?? ''}',
      'ratingCount': _userRating,
      'date': DateTime.now().toIso8601String(),
      'isLiked': false,
    };

    final stylistRef =
    FirebaseFirestore.instance.collection('stylists').doc(widget.stylist.id);
    final userRef =
    FirebaseFirestore.instance.collection('users').doc(authVM.user!.uid);

    try {
      // Выполняем транзакцию: обе операции будут атомарными
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Обновляем комментарии стилиста
        transaction.update(stylistRef, {
          'comments': FieldValue.arrayUnion([commentData])
        });
        // Обновляем комментарии пользователя
        transaction.update(userRef, {
          'comments': FieldValue.arrayUnion([commentData])
        });
      });

      await _fetchComments();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ваш отзыв успешно отправлен'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _commentController.clear();
        _userRating = 5.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка отправки отзыва: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}



  class ImprovedCommentCard extends StatelessWidget {
  final Comment comment;

  const ImprovedCommentCard({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: comment.photo.isNotEmpty
                      ? AssetImage(comment.photo)
                      : null,
                  backgroundColor: Colors.blueAccent,
                  child: comment.photo.isEmpty
                      ? Text(
                    comment.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatDate(comment.date),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      comment.ratingCount.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              comment.text,
              style: TextStyle(
                height: 1.4,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),

            // Кнопки действий
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: Icon(
                      Icons.thumb_up_outlined,
                      size: 18,
                      color: comment.isLiked ? Colors.blue : Colors.grey[600],
                    ),
                    label: Text(
                      comment.likes.toString(),
                      style: TextStyle(
                        color: comment.isLiked ? Colors.blue : Colors.grey[600],
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () {
                      // Логика лайка
                    },
                  ),
                  TextButton.icon(
                    icon: Icon(
                      Icons.reply,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    label: Text(
                      'Ответить',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () {
                      // Логика ответа
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}