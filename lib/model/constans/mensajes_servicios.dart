// Modelo para el número con sus servicios
class ServiceItem {
  final String code;
  final String name;
  bool isSelected;

  ServiceItem({required this.code, required this.name, this.isSelected = false});
}

class NumberItem {
  final int number;
  final List<ServiceItem> services;

  NumberItem({required this.number, required this.services});
}