import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:kitapyurduapp/book.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getHeadline();
    getData();
  }

  Uri url = Uri.parse("https://www.kitapyurdu.com/yeni-cikan-kitaplar/haftalik/1.html");
  List<String> data = [];
  List<BookforList> books = [];
  String headline = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Future<void> getHeadline() async {
    http.Response response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    headline = document.getElementsByClassName("grid_9")[0].children[0].text;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> getData() async {
    int i = 0;
    if (data.isEmpty) {
      http.Response response = await http.get(url);
      dom.Document document = parser.parse(response.body);
      document.getElementsByClassName("product-grid")[0].getElementsByClassName("product-cr").forEach((element) {
        i++;
        books.add(
          BookforList(
            order: i.toString(),
            image: element.children[3].children[0].children[0].children[0].attributes['src'].toString(),
            url: element.children[3].children[0].children[0].attributes['href'].toString(),
            bookName: element.children[4].text.toString(),
            publisher: element.children[5].text.toString(),
            author: element.children[6].text.toString(),
            price: element.children[9].children[1].text.toString(),
          ),
        );
        if (!mounted) return;
        setState(() {});
      });
    }
  }
}

class BookforList {
  String order;
  String image;
  String url;
  String bookName;
  String publisher;
  String author;
  String price;
  BookforList({
    required this.order,
    required this.image,
    required this.url,
    required this.bookName,
    required this.publisher,
    required this.author,
    required this.price,
  });
}
