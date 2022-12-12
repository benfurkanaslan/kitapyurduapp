import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitapyurdu App',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: const Home(),
    );
  }
}

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

  Uri url = Uri.parse("https://www.kitapyurdu.com/cok-satan-kitaplar/haftalik/1.html");
  List<String> data = [];
  List<Book> books = [];
  String headline = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(headline),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      debugPrint(books[index].url);
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Text("Sıra: ${books[index].order}"),
                          Image.network(books[index].image, width: 100, height: 200),
                          Text("Kitap adı: ${books[index].bookName}"),
                          Text("Yayın evi: ${books[index].publisher}"),
                          Text("Yazar: ${books[index].author}"),
                          Text("Fiyat: ${books[index].price}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
          Book(
            order: i.toString(),
            image: element.children[3].children[0].children[0].children[0].attributes['src'].toString(),
            url: element.children[3].children[0].children[0].attributes['href'].toString(),
            bookName: element.children[4].text.toString(),
            publisher: element.children[5].text.toString(),
            author: element.children[6].text.toString(),
            price: element.children[9].children[0].text.toString(),
          ),
        );
        if (!mounted) return;
        setState(() {});
      });
    }
  }
}

class Book {
  String order;
  String image;
  String url;
  String bookName;
  String publisher;
  String author;
  String price;
  Book({
    required this.order,
    required this.image,
    required this.url,
    required this.bookName,
    required this.publisher,
    required this.author,
    required this.price,
  });
}
