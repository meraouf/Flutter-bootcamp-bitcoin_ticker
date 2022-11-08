import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'crypto_card.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';


  DropdownButton<String> drpdwnButtom() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      DropdownMenuItem<String> ddmItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(ddmItem);
    }
      return DropdownButton(
          value: selectedCurrency,
          items: dropdownItems,
          onChanged: (value) {
            setState(() {
              selectedCurrency = value.toString();
              getData(selectedCurrency);
            });
          },
      );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItem = [];
    for(String currency in currenciesList) {
      pickerItem.add(Text(currency));
    }

    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (value) {
          print(value);
        },
        children: pickerItem
    );
  }

  Map<String, String> priceList = {};
  bool isLoading = false;
  void getData(String currency) async {
    isLoading = true;
    try {
      var data = await CoinData().getCryptoPrice(currency);
      setState(() {
        priceList = data;
      });
      isLoading = false;
    }catch (e) {
      print(e);
    }
  }

  Column cardList() {

    List<CryptoCard> cards = [];
      for (String crypto in cryptoList) {
        cards.add(
          CryptoCard(
              value : isLoading ? '?' : priceList[crypto],
              selectedCurrency : selectedCurrency,
              cryptoCurrency: crypto)
        );
      }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cards
    );
  }

  @override
  void initState() {
    super.initState();
    getData(selectedCurrency);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('😛 Bitcoin Tricker'),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: cardList(),
          ),
          Container(
            height: 155.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : drpdwnButtom()
          ),
        ],
      ),
    );
  }
}



//DropdownButton(
//value: selectedCurrency,
//items: getDropdownItems(),
//onChanged: (value) {
//print(value);
//setState(() {
//selectedCurrency = value.toString();
//});
//},
//)