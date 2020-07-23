import 'package:brewcrew/models/brews.dart';
import 'package:brewcrew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  //create a collection for a new user

  Future updateUserData(String sugars, String name, int strenght) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strenght,
    });
  }

  //brew list snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((e) {
      return Brew(
          name: e.data['name'] ?? '',
          sugars: e.data['sugars'] ?? '0',
          strength: e.data['strength'] ?? 0);
    }).toList();
  }

  //UserData
  UserData _userDataFormSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
    );
  }

  //get brew stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //get User Doc Stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFormSnapshot);
  }
}
