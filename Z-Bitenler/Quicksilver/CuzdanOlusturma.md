<p style="font-size:14px" align="right">
 100$ Free VPS for 2 Month <br>
 <a target="_blank" href="https://www.digitalocean.com/?refcode=410c988c8b3e&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge"><img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" alt="DigitalOcean Referral Badge" /></a></br>
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>
<p align="center">
  <img height="100" src="https://i.hizliresim.com/k29umk7.png">
</p>
# Quicksilver Ağı için adres oluşturma
Bu kılavuz, terminal (komut satırı) kullanarak Quicksilver ağı için bir adres oluşturmanıza yardımcı olacaktır. Git ve bir terminale erişimi olan herkesin bunu yapabilmesi için takip etmesi çok kolay bir kılavuzdur.

## Gereksinimler
1. Git
2. Golang (sisteminizde yüklü)

## 1. Quicksilver CLI aracı oluşturun
Bu adım, kullanıcının Git ve Golang'ın zaten kurulu olmasını bekler. Mac kullanıcıları bunları yüklemek için Homebrew kullanabilir.

```
$ git clone https://github.com/ingenuity-build/quicksilver.git
$ cd quicksilver
$ git checkout tags/v0.3.0
$ make build
$ cd build
```


Derleme dizininin içeriğini listeledikten sonra 'quicksilverd' yürütülebilir dosyasını görmelisiniz. Adresimizi oluşturmak için bundan sonra kullanacağımız şey budur.

## 2. Ledger kullanarak adres oluşturma
Bu adım, USB aracılığıyla makinenize bağlı bir defter aygıtınız olduğunu varsayıyordu. Bu adımı gerçekleştirmeden önce Cosmos uygulamasının Ledger'da yüklü ve açık olduğundan emin olun. Aşağıdaki komutu çalıştırdığınızda, Ledger üzerinde işlemi gözden geçirmeniz istenecektir. Ledger'daki tüm alanları gözden geçirdikten sonra 'Onayla'ya basın.
```
$ ./quicksilverd keys add my-key-name --ledger 


- name: my-key-name
  type: ledger
  address: quick15q94h723t1v444q2po10iurfkgq659lnzdcp35
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"Wi1ZloQklTNwBPEbxj0GEnMivbdTiPo85jo+1qL34sxV"}'
  mnemonic: ""
```



## 3. Eski bir anımsatıcı kullanarak adres oluşturma
Bu adım, bir Ledger'a sahip olmayan veya ham anımsatıcılarından bir Quicksilver adresi oluşturmak isteyen kullanıcılar içindir.


> _Aşağıda gösterilen anımsatıcı rastgeledir ve herhangi bir gerçek adrese karşılık gelmez. Sadece örnekleme amacıyla kullanılmıştır_


```
$ ./quicksilverd keys add my-key-name --interactive
> Enter your bip39 mnemonic, or hit enter to generate one.
ice dwarf wonder woman moriarty rubber ship cosmos rack hurt idea drop zintec mule strange ironman flash power thanos stick zoomcar nordic half fango
> Enter your bip39 passphrase. This is combined with the mnemonic to derive the seed. Most users should just hit enter to use the default, ""


- name: my-key-old-mnemomic
  type: local
  address: quick1dfgtqrxqeuf9po4prarewjlam2a9nrjty54xae
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"Dk22D0qtilaKQEmeTxrjXXowoy753v8HupMJtJmAcW52"}'
  mnemonic: ""


**Important** write this mnemonic phrase in a safe place.
It is the only way to recover your account if you ever forget your password.

ice dwarf wonder woman moriarty rubber ship cosmos rack hurt idea drop zintec mule strange ironman flash power thanos stick zoomcar nordic half fango
```

## 4. Yeni bir anımsatıcı kullanarak adres oluşturma
Bu adım, sıfırdan bir kağıt cüzdan ve bir cıva adresi oluşturmak isteyen kullanıcılar içindir. Bu adımda 24 kelimelik bir anımsatıcı oluşturacaksınız.

> **Not:** Bu anımsatıcıyı güvenli bir yerde YEDEKLEMELİSİNİZ. Bu, fonlarınıza erişmenin tek yolu olacak. **Bunu kaybederseniz, fonlarınıza erişiminizi kaybedersiniz!** Bu anımsatıcıya sahip olan herkes fonlarınızı çalabilir!

```
$ ./quicksilverd keys add my-key-new-mnemomic

- name: my-key-new-mnemomic
  type: local
  address: quick1wel9cittgvpo23fumg5cchgmv8tlm9l2ginesh
  pubkey: '{"@type":"/cosmos.crypto.secp256k1.PubKey","key":"Jpiter8s/z5nR/M63wAZ8ZaQ+Nhsahasgh/ADf3HEz0Z"}'
  mnemonic: ""


**Important** write this mnemonic phrase in a safe place.
It is the only way to recover your account if you ever forget your password.

word1 word2 word3 word4 soon allword some word could drink plastic target indoor material city need file zone lambo greece town never goat arrest
```


<br>

---

işte! Quicksilver adresiniz artık elinizde. Cosmos SDK ağlarında stake deneyimi yaşamaya hazırsınız!
