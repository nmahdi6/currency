import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:tech_plog/model/Currency.dart';

void main() {
  runApp(myApp());
}

// ignore: camel_case_types
class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', ''), // farsi
      ],
      theme: ThemeData(
          fontFamily: 'nazanin',
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontFamily: 'nazanin',
                fontSize: 16,
                fontWeight: FontWeight.w700),
            bodyText1: TextStyle(
                fontFamily: 'nazanin',
                fontSize: 13,
                fontWeight: FontWeight.w300),
            headline2: TextStyle(
                fontFamily: 'nazanin',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700),
            headline3: TextStyle(
                fontFamily: 'nazanin',
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w700),
            headline4: TextStyle(
                fontFamily: 'nazanin',
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w700),
          )),
      debugShowCheckedModeBanner: false,
      home: const HOME(),
    );
  }
}

class HOME extends StatefulWidget {
  const HOME({Key? key}) : super(key: key);

  @override
  State<HOME> createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {
  List<Currency> currency = [];

  Future getResponse(BuildContext cntx) async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url));

    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        _ShowSnackBar(context, "بروز رسانی اطلاعات با موفقیت انجام شد.");
        List jsonList = convert.jsonDecode(value.body);
        if (jsonList.length > 0) {
          setState(() {
            for (int i = 0; i < jsonList.length; i++) {
              currency.add(Currency(
                  id: jsonList[i]["id"],
                  title: jsonList[i]["title"],
                  price: jsonList[i]["price"],
                  changes: jsonList[i]["changes"],
                  status: jsonList[i]["status"]));
            }
          });
        }
      }
    }
    return value;
  }

  @override
  void initState() {
    super.initState();
    getResponse(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          const SizedBox(
            width: 6,
          ),
          Image.asset("assets/images/money2.png"),
          Align(
              alignment: Alignment.centerRight,
              child: Text(
                "قیمت به روز ارز",
                style: Theme.of(context).textTheme.headline1,
              )),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset("assets/images/menu.png"))),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/?icon.png"),
                  const SizedBox(width: 9),
                  Text("این یک موضوع میباشد.",
                      style: Theme.of(context).textTheme.headline1),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "نرخ ارز ها در معاملات نقدی و رایج روزانه است . معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله  ارز و ریال را باهم تبادل می نمایند.",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Color.fromARGB(255, 130, 130, 130)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "نام آزاد ارز",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(
                        "قیمت",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(
                        "تغییرات",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ],
                  ),
                ),
              ),
              // list
              SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: listFutureBuilder(context)),
              // update button box
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 16,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 232, 232),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // update btn
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 16,
                        child: TextButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 202, 193, 255)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1000))),
                          ),
                          onPressed: () {
                            currency.clear();
                            listFutureBuilder(context);
                          },
                          icon: const Icon(
                            CupertinoIcons.refresh_bold,
                            color: Colors.black,
                          ),
                          label: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(
                              "بروز رسانی",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ),
                      ),
                      Text("آخرین به روز رسانی ${_getTime()}"),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: currency.length,
                itemBuilder: (BuildContext context, int position) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 2),
                    child: MyItem(position, currency),
                  );
                })
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
      future: getResponse(context),
    );
  }

  String _getTime() {
    DateTime now = DateTime.now();

    return DateFormat('kk:mm:ss').format(now);
  }
}

// ignore: non_constant_identifier_names
void _ShowSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.headline1,
    ),
    backgroundColor: Colors.green,
  ));
}

// ignore: must_be_immutable
class MyItem extends StatelessWidget {
  int position;
  List<Currency> currency;
  MyItem(
    this.position,
    this.currency,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 1.0, color: Colors.grey)
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            currency[position].title!,
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            getFarsiNumber(currency[position].price.toString()),
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            getFarsiNumber(currency[position].changes.toString()),
            style: currency[position].status == "n"
                ? Theme.of(context).textTheme.headline3
                : Theme.of(context).textTheme.headline4,
          )
        ],
      ),
    );
  }
}

String getFarsiNumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });
  return number;
}
