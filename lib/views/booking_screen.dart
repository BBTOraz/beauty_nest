import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    _loadUserBookings();
  }

  Future<void> _loadUserBookings() async {
    await _authViewModel.loadUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Мои брони',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              text: "На дом",
            ),
            Tab(
              icon: Icon(Icons.store),
              text: "В салоне",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAtHomeList(),
          _buildBookingList(),
        ],
      ),
    );
  }

  Widget _buildAtHomeList() {
    final atHomeServices = _authViewModel.userModel?.atHome ?? [];

    if (atHomeServices.isEmpty) {
      print('Booking Service Page atHome : ${atHomeServices.length}');
      return _buildEmptyState("У вас нет заказов стилиста на дом");
    }

    return RefreshIndicator(
      onRefresh: _loadUserBookings,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: atHomeServices.length,
        itemBuilder: (context, index) {
          final booking = atHomeServices[index];
          return _buildAtHomeCard(booking);
        },
      ),
    );
  }

  Widget _buildBookingList() {
    final bookingServices = _authViewModel.userModel?.booking ?? [];

    if (bookingServices.isEmpty) {
      print('Booking Service Page bookings: ${bookingServices.length}');
      return _buildEmptyState("У вас нет забронированных услуг в салоне");
    }

    return RefreshIndicator(
      onRefresh: _loadUserBookings,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: bookingServices.length,
        itemBuilder: (context, index) {
          final booking = bookingServices[index];
          return _buildSalonBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildAtHomeCard(dynamic booking) {
    // Форматирование даты
    final DateTime bookingDate = DateTime.parse(booking['date']);
    final String formattedDate = DateFormat('d MMMM yyyy, HH:mm', 'ru_RU').format(bookingDate);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showBookingDetails(booking, isAtHome: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: booking['img'] != null
                  ? Image.asset(
                booking['img'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 120,
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          booking['stylist'] ?? "Стилист",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${booking['amount']} ₸",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          booking['address'] ?? "Адрес не указан",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.receipt, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        "Заказ №${booking['orderNumber']}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _showBookingDetails(booking, isAtHome: true),
                        child: Text("Подробнее"),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _showCancelDialog(booking, isAtHome: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Отменить"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalonBookingCard(dynamic booking) {
    final String formattedDate = "${_formatDate(booking['selectedDate'])} в ${booking['selectedTime']}";

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showBookingDetails(booking, isAtHome: false),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['service'] ?? "Услуга",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Стилист: ${booking['stylistName'] ?? "Не указан"}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${booking['price'] + " ₸" ?? "Не указан" }",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "Создано: ${_formatTimestamp(booking['bookingTimestamp'])}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _showBookingDetails(booking, isAtHome: false),
                    child: Text("Подробнее"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _showCancelDialog(booking, isAtHome: false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Отменить"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadUserBookings,
            child: Text("Обновить"),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(dynamic booking, {required bool isAtHome}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(20),
            child: ListView(
              controller: controller,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  isAtHome ? "Заказ стилиста на дом" : "Бронь в салоне",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Детальная информация в зависимости от типа брони
                if (isAtHome) ...[
                  if (booking['img'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        booking['img'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(height: 16),
                  _buildDetailRow("Стилист:", booking['stylist'] ?? "Не указан"),
                  _buildDetailRow("Адрес:", booking['address'] ?? "Не указан"),
                  _buildDetailRow("Дата и время:", "${_formatDateFromIso(booking['date'])} в ${booking['time']}"),
                  _buildDetailRow("Стоимость:", "${booking['amount']} ₸"),
                  _buildDetailRow("Номер заказа:", booking['orderNumber'] ?? "Не указан"),
                  _buildDetailRow("Создано:", _formatTimestamp(booking['timestamp'])),
                ] else ...[
                  _buildDetailRow("Услуга:", booking['serviceName'] ?? "Не указана"),
                  _buildDetailRow("Стилист:", booking['stylistName'] ?? "Не указан"),
                  _buildDetailRow("Дата и время:", "${_formatDate(booking['selectedDate'])} в ${booking['selectedTime']}"),
                  _buildDetailRow("Стоимость:", "${booking['price']} ₸"),
                  _buildDetailRow("Создано:", _formatTimestamp(booking['bookingTimestamp'])),
                ],
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _showCancelDialog(booking, isAtHome: isAtHome),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Отменить бронь",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 12),
                if (isAtHome)
                  OutlinedButton(
                    onPressed: () {
                      // Логика для связи со стилистом
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Связаться со стилистом",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Закрыть",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(dynamic booking, {required bool isAtHome}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Отменить бронь?"),
        content: Text(
          "Вы уверены, что хотите отменить данную бронь? Это действие нельзя отменить.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Нет"),
          ),
          ElevatedButton(
            onPressed: () {
              // Логика отмены брони
              Navigator.pop(context);
              _showCancellationSuccess();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text("Да, отменить"),
          ),
        ],
      ),
    );
  }

  void _showCancellationSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Бронь успешно отменена"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    _loadUserBookings();
  }

  String _formatDate(String date) {
    final parts = date.split('-'); // например, ["2025", "03", "07"]
    if (parts.length != 3) return date; // Если формат не "yyyy-MM-dd", просто вернём исходное значение

    final year = int.parse(parts[0]);  // "2025"
    final month = int.parse(parts[1]); // "03"
    final day = int.parse(parts[2]);   // "07"

    final dateTime = DateTime(year, month, day);

    return DateFormat('yyyy-MM-dd').format(dateTime); // "2025-03-07"
  }


  String _formatDateFromIso(String isoDate) {
    final DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('d MMMM yyyy', 'ru_RU').format(dateTime);
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return '';
    }

    if (timestamp is Timestamp) {
      final dateTime = timestamp.toDate();
      return DateFormat('d MMMM yyyy, HH:mm', 'ru_RU').format(dateTime);
    }

    if (timestamp is String) {
      return timestamp
          .replaceAll(" at ", " ")
          .replaceAll(" UTC+5", "");
    }
    return timestamp.toString();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}