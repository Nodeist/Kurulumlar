# Fiyat Oracle Komut Dosyası
Bu, CoinGecko'dan farklı jeton çiftlerinin piyasa fiyatlarını getiren basit bir kehanet betiğidir. 

# Kurulum (Yerel)
Coingecko api'yi node'unuza yükleyin.

```
git clone https://github.com/man-c/pycoingecko.git
cd pycoingecko
python3 setup.py install
```

Mevcut Oracle belirteç çiftleri beyaz listesini kontrol edin, mevcut Oracle'ın yalnızca beyaz listeye alınmış belirteç fiyatlarını kabul ettiğini unutmayın. Örnek:
```
seid query oracle params
```

Çıktı buna benzemeli:
```
➜ params:
    lookback_duration: "3600"
    min_valid_per_window: "0.050000000000000000"
    reward_band: "0.020000000000000000"
    slash_fraction: "0.000100000000000000"
    slash_window: "201600"
    vote_period: "10"
    vote_threshold: "0.500000000000000000"
    whitelist:
    - name: uatom
    - name: uusdc
    - name: usei
```

Fiyat besleyiciyi arka planda başlatın, beyaz listedeki tüm madeni paraların fiyatını göndermek isteyebileceğinizi unutmayın, aksi takdirde kehanet ödülü için uygun olmayabilirsiniz. ${coin_list} örneği: 'cosmos', 'usd-coin'
Yeni bir screen oluşturun ve komutu çalıştırın.
```
nohup python3 -u price_feeder.py WALLETNAME WALLETPASS atlantic-1 'cosmos','usd-coin' --node http://localhost:36377
```

Komut dosyasında hemen bir hata olmadığını inceleyin
```
tail -f nohup.out
```

Fiyatları başarıyla gönderdikten sonra, şu anki fiyat beslemelerini görmelisiniz.
```
seid query oracle exchange-rates
```

