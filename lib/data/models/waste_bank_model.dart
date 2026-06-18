class WasteBankModel {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String phone;
  final String openHours; // e.g., "08:00 - 16:00"
  final List<String> acceptedWasteTypes; // waste type IDs
  final String? imageUrl;
  final bool isOpen;
  final double rating;
  final String operationalDays; // e.g., "Senin - Jumat"

  const WasteBankModel({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.phone,
    required this.openHours,
    required this.acceptedWasteTypes,
    this.imageUrl,
    this.isOpen = true,
    this.rating = 4.5,
    required this.operationalDays,
  });

  double distanceFrom(double userLat, double userLng) {
    // Simple Euclidean approximation for display
    final dlat = lat - userLat;
    final dlng = lng - userLng;
    return (dlat * dlat + dlng * dlng) * 111000; // rough meters
  }
}
