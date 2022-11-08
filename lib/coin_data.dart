import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList =  [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {

  Future getCryptoPrice(currency) async {
    Map<String, String> cryptoPrices = {};
    for(String coin in cryptoList) {
      http.Response response = await http.get(Uri.https(
          'rest.coinapi.io',
          'v1/exchangerate/$coin/$currency',
          {
            'apikey': 'ADB22CC7-D8A7-4D54-9D23-62B85B7EBBEF'
          }
      ));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        double price = data['rate'];
        cryptoPrices[coin] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}