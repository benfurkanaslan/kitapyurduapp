import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

class BookPage extends StatefulWidget {
  final String imageUrl;
  final dom.Document doc;
  const BookPage({super.key, required this.doc, required this.imageUrl});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  void initState() {
    super.initState();
    getDataofBook();
  }

  @override
  Widget build(BuildContext context) {
    Book book = Book(
      name: widget.doc.getElementsByClassName("pr_header__heading")[0].text,
      author: widget.doc.getElementsByClassName("pr_producers__publisher")[0].getElementsByClassName("pr_producers__item")[0].getElementsByClassName("pr_producers__link")[0].text,
      image: widget.imageUrl,
      price: widget.doc.getElementsByClassName("price__item")[0].text,
      description: widget.doc.getElementsByClassName("info__text")[0].text,
    );
    return Scaffold();
  }

  Future<void> getDataofBook() async {
    debugPrint(widget.doc.getElementsByClassName("info__text")[0].text);
    debugPrint(widget.doc.getElementsByClassName("pr_header__heading")[0].text);
    debugPrint(widget.doc.getElementsByClassName("price__item")[0].text);
    debugPrint(
        widget.doc.getElementsByClassName("pr_producers__publisher")[0].getElementsByClassName("pr_producers__item")[0].getElementsByClassName("pr_producers__link")[0].text);
  }
}

class Book {
  final String name;
  final String author;
  final String image;
  final String price;
  final String description;
  Book({
    required this.name,
    required this.author,
    required this.image,
    required this.price,
    required this.description,
  });
}
