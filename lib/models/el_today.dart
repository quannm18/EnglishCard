class EnglishToday {
  String? id;
  String? noun;
  String? quote;
  bool isFavorite = false;

  EnglishToday({
    this.id,
    this.noun,
    this.quote,
    this.isFavorite = false,
  });

  String? get getId => this.id;

  set setId(String? id) => this.id = id;

  get getNoun => this.noun;

  set setNoun(noun) => this.noun = noun;

  get getQuote => this.quote;

  set setQuote(quote) => this.quote = quote;

  get getIsFavorite => this.isFavorite;

  set setIsFavorite(isFavorite) => this.isFavorite = isFavorite;
}
