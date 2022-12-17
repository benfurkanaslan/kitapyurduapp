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

  Uri url = Uri.parse("https://www.kitapyurdu.com/index.php?route=product/best_sellers&page=2&list_id=1&filter_in_stock=1&filter_in_stock=1");
  List<String> data = [];
  List<BookforList> books = [];
  String headline = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(headline),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: SizedBox(
                    height: 100,
                    width: 200,
                    child: Card(
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircularProgressIndicator(),
                            Text("Yükleniyor..."),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );

              Uri uri = Uri.parse(books[index].url);
              http.Response response = await http.get(uri);
              dom.Document document = parser.parse(response.body);
              if (!mounted) return;
              Navigator.of(context).pop();
              if (!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (builder) => BookPage(doc: document, imageUrl: books[index].image),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text("Sıra: ${books[index].order}"),
                      Image.network(books[index].image),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text("Kitap adı: ${books[index].bookName}"),
                      Text("Yayın evi: ${books[index].publisher}"),
                      Text(books[index].author),
                      Text(books[index].price),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
