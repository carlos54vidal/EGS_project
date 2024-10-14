import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_sitter/src/entities/image.dart';
import 'package:pet_sitter/src/entities/petsitter.dart';

class IsarService {
  late Future<Isar> db;
  final log = Logger();

  IsarService() {
    db = openDB();
  }

  /* Future<void> deletePet(int id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      isar.pets.delete(id);
    });
  }

  Future<void> savePet(Pet newPet) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.pets.putSync(newPet));
  }

  Future<Id> savePetsitter(Petsitter newPetsitter) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.petsitters.putSync(newPetsitter));
    return newPetsitter.id;
  }

  Future<Pet?> getPetById(int id) async {
    final isar = await db;
    return await isar.pets.get(id);
  } */
  Future<List<Petsitter?>> getAllSitters() async {
    final isar = await db;
    final petsitters = await isar.petsitters.where().findAll();
    return petsitters;
  }

  Future<Petsitter?> updatePetsitter(Petsitter newinfo, int id) async {
    final isar = await db;
    Petsitter? novo;

    await isar.writeTxn(() async {
      novo = await isar.petsitters.get(id);
      if (novo != null) {
        novo!.fname = newinfo.fname;
        novo!.lname = newinfo.lname;
        novo!.username = newinfo.username;
        novo!.pass = newinfo.pass;
        novo!.birthDate = newinfo.birthDate;
        if (newinfo.description != null) {
          novo!.description = newinfo.description!;
        }
        novo!.cc = newinfo.cc;
        await isar.petsitters.put(novo!);
      }
    });

    log.i("isardb $novo");
    return novo;
  }

  /* Future<int> savePetToSitter(Petsitter newPetsitter, Pet pet) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.petsitters.putSync(newPetsitter));
    isar.writeTxnSync<int>(() => isar.pets.putSync(pet));
    newPetsitter.pet.add(pet);
    isar.writeTxn(() async => await newPetsitter.pet.save());

    return newPetsitter.id;
  } */

  Future<void> storeImage(List<byte> imageBytes, int id) async {
    final image = ImageEntity()..imagebytes = imageBytes;
    Petsitter? novo;
    final isar = await db;

    isar.writeTxn(() async => image..id = await isar.imageEntitys.put(image));
    novo = await isar.petsitters.get(id);
    novo!.images.add(image);
    isar.writeTxn(() async => await novo!.images.save());
  }

  Future<List<List<byte>>> getImagesSitter(int id) async {
    final isar = await db;
    final images = await isar.imageEntitys
        .filter()
        .petsitter((q) => q.idEqualTo(id))
        .findAll();
    return images.map((image) => image.imagebytes).toList();
  }

  /* Future<List<Pet>> getPetsitterPets(Petsitter petsitter) async {
    final isar = await db;
    final petlist = await isar.pets
        .filter()
        .petsitter((q) => q.idEqualTo(petsitter.id))
        .findAll();
    return petlist;
  } */

  Future<Petsitter?> getPetsitterById(Id id) async {
    final isar = await db;
    final petsitter = isar.petsitters.filter().idEqualTo(id).findFirst();
    return petsitter;
  }

  /* Future<int> getlogin(String user, String pass) async {
    final isar = await db;
    try {
      final loggedUser = await isar.petsitters
          .filter()
          .usernameEqualTo(user)
          .passMatches(pass)
          .findFirst();
      if (loggedUser != null) {
        return loggedUser.id;
      } else {
        return 0;
      }
    } catch (e) {
      log.i('An exception occurred: $e');
      return 0;
    }
  } */

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [PetsitterSchema, ImageEntitySchema],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
