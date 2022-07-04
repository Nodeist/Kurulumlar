## ICAD kqcosmos-1 keplr cüzdan entegrasyonu
<!--
#### Gereksinimler
[keplr cüzdan uzantısı](https://google.com)
-->
### Otomatik kurulum
1) Sadece bu bağlantıyı ziyaret edin. Keplr penceresi açılırken onayla düğmesine basın.  
2) Ağ bölümünde ICAD ağını seçin  
3) bu kadar. İyi eğlenceler:)  

### Manuel kurulum

Geliştirici konsolunu açın:

- Chromium tabanlı tarayıcılar: Görünüm> Geliştirici>Geliştirici Araçları(ctrl-shift-j)

- Kodu kopyalayıp yapıştırın ve enter'a basın. Kodda rpc'yi ve api url'lerini düzenlenmeyi unutmayın! :


```markdown
await window.keplr.experimentalSuggestChain({
    chainId: "kqcosmos-1",
    chainName: "ICAD",
    rpc: "http://162.55.235.69:2865", // rpc adresiniz ile degistirin
    rest: "http://162.55.235.69:1387", // api urlniz ile degistirin
    bip44: {
        coinType: 118,
    },
    bech32Config: {
        bech32PrefixAccAddr: "cosmos",
        bech32PrefixAccPub: "cosmos" + "pub",
        bech32PrefixValAddr: "cosmos" + "valoper",
        bech32PrefixValPub: "cosmos" + "valoperpub",
        bech32PrefixConsAddr: "cosmos" + "valcons",
        bech32PrefixConsPub: "cosmos" + "valconspub",
    },
    currencies: [ 
        { 
            coinDenom: "ATOM", 
            coinMinimalDenom: "uatom", 
            coinDecimals: 6, 
            coinGeckoId: "uatom", 
        }, 
    ],
    feeCurrencies: [
        {
            coinDenom: "ATOM",
            coinMinimalDenom: "uatom",
            coinDecimals: 6,
            coinGeckoId: "uatom",
        },
    ],
    stakeCurrency: {
        coinDenom: "ATOM",
        coinMinimalDenom: "uatom",
        coinDecimals: 6,
        coinGeckoId: "uatom",
    },
    coinType: 118,
    gasPriceStep: {
        low: 0.01,
        average: 0.025,
        high: 0.03,
    },
    
    features: [
        "cosmwasm", "ibc-transfer", "ibc-go", "wasmd_0.24+"
        ],
});
}
```
