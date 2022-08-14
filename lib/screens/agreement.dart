import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

class AgreementPage extends StatefulWidget {
  const AgreementPage({Key? key,  required this.title}) : super(key: key);

  final String title;

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  String htmlData = "";

  fetchSearchResult() async {
      final response = await http.get(Uri.parse("http://api.qsres.com/mobileapp/agreement"));
      if (response.statusCode == 200) {
        htmlData = response.body.toString();
      }else{
        htmlData = "<h1>Sözleşme yüklenemedi!<h1>";
      }
      setState((){});
  }


  @override
  void initState() {
    fetchSearchResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        Icons.contact_page_rounded,
        widget.title,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Html(
                  data: htmlData,
                ),
                MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  height: 60,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  focusElevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Geri",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
