import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoController extends GetxController {
  late Db db;
  late DbCollection bookingsCollection;

  // Observable list to store documents
  var bookings = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    initDb(); // initialize DB when controller starts
  }

  // Initialize MongoDB connection
  Future<void> initDb() async {
    db = await Db.create('mongodb://10.0.2.2:27017/volks_db');
    await db.open();
    bookingsCollection = db.collection('bookings');

    // Fetch data immediately after opening DB
    await fetchBookings();
  }

  // Fetch specific fields from bookings
  Future<void> fetchBookings() async {
    try {
      final data = await bookingsCollection.find(
        where.fields(['service_type', 'preferred_date', 'preferred_time', 'status'])
      ).toList();

      bookings.assignAll(data);
      print('Fetched bookings: $data');
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  // Close DB connection
  @override
  void onClose() {
    closeDb();
    super.onClose();
  }

  Future<void> closeDb() async {
    await db.close();
    print('MongoDB Closed');
  }
}
