import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

class BookPage extends StatefulWidget {
  final String imageUrl;
  final dom.Document doc;
  const BookPage({super.key, required this.doc, required this.imageUrl});

  @override
  State<BookPage> createState() => _BookPageState();
}

late Book book;

class _BookPageState extends State<BookPage> {
  @override
  void initState() {
    super.initState();
    book = Book(
      name: widget.doc.getElementsByClassName("pr_header__heading")[0].text,
      author: widget.doc.getElementsByClassName("pr_producers__publisher")[0].getElementsByClassName("pr_producers__item")[0].getElementsByClassName("pr_producers__link")[0].text,
      image: widget.imageUrl,
      price: widget.doc.getElementsByClassName("price__item")[0].text,
      description: widget.doc.getElementsByClassName("info__text")[0].text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 150,
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Image.network(book.image, fit: BoxFit.cover),
                ),
                Column(
                  children: [
                    Text(book.name),
                    Text(book.author),
                    Text(book.price),
                  ],
                ),
              ],
            ),
            Text(book.description),
          ],
        ),
      ),
    );
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
