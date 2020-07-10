class Note {
  String title;
  String text;
  String image;

  Note(this.title, this.text , this.image);


  Note.fromJson(Map<String, dynamic> json) {
    title = json['movie_name'];
    text = json['movie_genre'];
    image=json['movie_image'];
  }


}