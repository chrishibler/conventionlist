

enum Category {
  unlisted('Unlisted'),
  scienceFictionAndFantasy('ScienceFictionAndFantasy'),
  anime('Anime'),
  gaming('Gaming'),
  comics('Comics'),
  book('Book'),
  collectibles('Collectibles'),
  sports('Sports');

  final String val;

  const Category(this.val);
}
