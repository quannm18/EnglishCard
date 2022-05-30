class Quote {
  String? id;
  String? author;
  String? description;

  Quote({
    this.id = "",
    this.author,
    this.description,
  });

  String? get getId => this.id;

  set setId(String? id) => this.id = id;

  get getAuthor => this.author;

  set setAuthor(author) => this.author = author;

  get getDescription => this.description;

  set setDescription(description) => this.description = description;

  @override
  String toString() {
    // TODO: implement toString
    return " - $author, $description - ";
  }
}
