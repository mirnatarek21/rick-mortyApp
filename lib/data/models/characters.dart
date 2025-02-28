class Character {
  late int charId;
  late String charName;
  late String statsAliveOrDead;
  late String speciesHumanOrWhat;
  late String type;
  late String gender;
  late String image;
  late String created;
  late List<String> episodes;

  Character.fromJson(Map<String, dynamic> json) {
    charId = json["id"];
    charName = json["name"];
    statsAliveOrDead = json["status"];
    speciesHumanOrWhat = json["species"];
    type = json["type"];
    gender = json["gender"];
    image = json["image"];
    created = json["created"];

    episodes = List<String>.from(json["episode"] ?? []);
  }
}
