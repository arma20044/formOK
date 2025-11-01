// Modelo para el número con sus servicios
class NumberItem {
  final int number;
  final List<ServiceItem> services;

  NumberItem({required this.number, required this.services});
}

class ServiceItem {
  final String name;
  bool isSelected;

  ServiceItem({required this.name, this.isSelected = false});
}