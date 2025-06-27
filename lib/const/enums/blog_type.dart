enum BlogType {
  blogs,
  news,
  sucessStories;

  @override
  String toString() {
    switch (this) {
      case BlogType.blogs:
        return 'Blogs';
      case BlogType.news:
        return 'News';
      case BlogType.sucessStories:
        return 'Success Stories';
    }
  }
}
