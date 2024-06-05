import 'package:isar/isar.dart';

import 'petsitter.dart';

part 'image.g.dart';

@collection
class ImageEntity {
  Id id = Isar.autoIncrement;
  late List<byte> imagebytes;

  @Backlink(to: "images")
  final petsitter = IsarLink<Petsitter>();
}
