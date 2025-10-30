import 'package:get/get.dart';
import 'package:yousef1234321/features/home/model/garage_model.dart';


class HomeController extends GetxController {
  var garages = <GarageModel>[
    GarageModel(
      name: "Al Majid Auto Service",
      rating: 4.8,
      reviews: 127,
      distance: 2.3,
      status: "Open",
      tags: ["AC", "Engine", "Brakes"],
      imageUrl: "https://images.pexels.com/photos/909907/pexels-photo-909907.jpeg?cs=srgb&dl=pexels-alex-amorales-321095-909907.jpg",
    ),
    GarageModel(
      name: "Emirates Auto Care",
      rating: 4.9,
      reviews: 89,
      distance: 1.8,
      status: "Open",
      tags: ["Luxury", "German Cars"],
      imageUrl: "https://images.pexels.com/photos/909907/pexels-photo-909907.jpeg?cs=srgb&dl=pexels-alex-amorales-321095-909907.jpg",
    ),
  ].obs;

  var services = [
    "AC Repair",
    "Battery",
    "Engine",
    "Tires",
    "Electrical",
    "Spares",
  ];

  var selectedService = RxnString();
  var selectedLocation = RxnString();

  final serviceTypes = [
    "AC Repair",
    "Battery",
    "Engine",
    "Tires",
    "Electrical",
    "Spares",
    "Brakes",
    "Body Work",
  ];

  final locations = ["Dubai", "Abu Dhabi", "Sharjah", "Ajman"];
}
