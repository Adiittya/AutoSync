import 'package:flutter/material.dart';
import 'package:frontend/components/cards.dart';
import '../../../models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/button.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/constants/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalActionCards {
  static Widget build(Message msg, Function(String)? onUserAction) {
    final data = msg.metadata ?? {};

    switch (msg.type) {
      case MessageType.payment:
        return _paymentCard(data, onUserAction);
      case MessageType.booking:
        return _bookingCard(data, onUserAction);
      case MessageType.map:
        return _mapCard(data, onUserAction);
      case MessageType.feedback:
        return _feedbackCard(data, onUserAction);
      case MessageType.delivery:
        return _deliveryCard(data, onUserAction);
      case MessageType.buttons:
        return _buttonsCard(data, onUserAction);
      case MessageType.inventory:
        return _inventoryCard(data, onUserAction);
      default:
        return Text(
          msg.text,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          softWrap: true,
        );
    }
  }

  // -------- PAYMENT ----------
  static Widget _paymentCard(
    Map<String, dynamic> data,
    Function(String)? onUserAction,
  ) {
    return PaymentCard(paymentData: {});
  }

  // -------- BOOKING ----------
  static Widget _bookingCard(
    Map<String, dynamic> data,
    Function(String)? onUserAction,
  ) {
    final service = data['service'] ?? 'Service';
    final date = data['date'] ?? '';
    final time = data['time'] ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Book $service",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text("Date: $date"),
        Text("Time: $time"),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => onUserAction?.call("Confirm Booking"),
          child: const Text("Confirm"),
        ),
      ],
    );
  }

  // -------- MAP ----------
  static Widget _mapCard(
    Map<String, dynamic> data,
    Function(String)? onUserAction,
  ) {
    final title = data['title'] ?? 'Location';
    final lat = data['lat'];
    final lng = data['lng'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text("Lat: $lat, Lng: $lng"),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => onUserAction?.call("Open Map: $title"),
          child: const Text("Open in Maps"),
        ),
      ],
    );
  }

  // -------- FEEDBACK ----------
  static Widget _feedbackCard(
    Map<String, dynamic> data,
    Function(String)? onUserAction,
  ) {
    final question = data['question'] ?? "Rate your experience";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (i) {
            return IconButton(
              onPressed: () => onUserAction?.call("Rated ${i + 1} stars"),
              icon: const Icon(Icons.star_border, color: Colors.amber),
            );
          }),
        ),
      ],
    );
  }

  // -------- DELIVERY ----------
  static Widget _deliveryCard(
    Map<String, dynamic> data,
    Function(String)? onUserAction,
  ) {
    final status = data['status'] ?? "Status Unknown";
    final eta = data['eta'] ?? "N/A";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(status, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text("ETA: $eta"),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => onUserAction?.call("Track Delivery"),
          child: const Text("Track Now"),
        ),
      ],
    );
  }

  // -------- BUTTONS ----------
  static Widget _buttonsCard(
    Map<String, dynamic> data,
    Function(String)? onUserAction,
  ) {
    final buttons = (data['buttons'] as List?) ?? [];
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: buttons.map<Widget>((b) {
        final label = b['label'] ?? '';
        return OutlinedButton(
          onPressed: () => onUserAction?.call(label),
          child: Text(label),
        );
      }).toList(),
    );
  }

  // -------- BUTTONS ----------
  static Widget _inventoryCard(
    Map<String, dynamic> data,
    Function(String)? onUserAction,
  ) {
    final buttons = (data['buttons'] as List?) ?? [];
    return ChatbotAutoServiceCard(centerData: data);
  }
}

class PaymentCard extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const PaymentCard({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const SizedBox(height: 10),

          Center(
            child: Text(
              "VW",
              style: AppTheme.navLabel.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              "₹ 1,200",
              style: AppTheme.title.copyWith(fontSize: 30),
            ),
          ),

          const SizedBox(height: 10),

          // Parts list
          Center(
            child: Text(
              "Payment Modes",
              style: AppTheme.navLabel.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 10),

          CustomCard(
            title: "Online Payment Options",
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.payment_outlined, color: Colors.black54),
                        const SizedBox(width: 10),

                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {},
                          child: Text(
                            "Credit / Debit Card",
                            style: AppTheme.subtitle.copyWith(
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.black87,
                        ),
                      ],
                    ),

                    Divider(color: Colors.grey[300]),

                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.paypal, color: Colors.black54),
                        const SizedBox(width: 10),

                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {},
                          child: Text(
                            "Unified Payments Interface",
                            style: AppTheme.subtitle.copyWith(
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatbotAutoServiceCard extends StatelessWidget {
  final Map<String, dynamic> centerData;

  const ChatbotAutoServiceCard({super.key, required this.centerData});

  @override
  Widget build(BuildContext context) {
    final center = centerData;
    final address = center['address'];
    final parts = center['parts_available'];
    final location = center['location']['coordinates']; // [lng, lat]
    final lat = location[1];
    final lng = location[0];
    final markerPosition = LatLng(lat, lng);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                key: ValueKey(
                  center['center_name'],
                ), // prevent map rebuild issues
                options: MapOptions(
                  initialCenter: markerPosition,
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40,
                        height: 40,
                        point: markerPosition,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          Center(
            child: Text(
              center["center_name"],
              style: AppTheme.navLabel.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "${address['street']}, ${address['city']}, ${address['state']} - ${address['pincode']}",
            style: AppTheme.navLabel.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Parts list
          Center(
            child: Text(
              "Availability",
              style: AppTheme.navLabel.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 4),

          ...parts.map<Widget>((part) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  Text(
                    part['part_name'],
                    style: AppTheme.subtitle.copyWith(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "₹${part['price']}", // Add currency symbol and convert to string
                    style: AppTheme.subtitle.copyWith(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 15),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                final url =
                    "https://www.openstreetmap.org/?mlat=$lat&mlon=$lng&zoom=17";
                launchUrl(Uri.parse(url));
              },
              child: Text(
                "Drive Now",
                style: AppTheme.subtitle.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                final url = "tel:${center['contact']}";
                launchUrl(Uri.parse(url));
              },
              child: Text(
                "Call Center",
                style: AppTheme.subtitle.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
