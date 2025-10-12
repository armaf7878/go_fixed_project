class Service {
  final String id;
  final String title;
  final String? iconUrl;
  final int? price;
  final bool isActive;

  Service({required this.id, required this.title, this.iconUrl, this.price, required this.isActive});

  // mapper từ DTO
  factory Service.fromDto(dynamic dto) => Service(
    id: dto.id,
    title: dto.name,
    iconUrl: dto.iconUrl,
    price: dto.price,
    isActive: dto.isActive,
  );
}
