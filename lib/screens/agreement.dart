import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class AgreementPage extends StatelessWidget {
  const AgreementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        Icons.contact_page_rounded,
        "Üyelik Sözleşmesi",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(""" 
                Cezai olarak sorumlu olacağını, bu yazılımları ya da servisleri hiçbir şekilde izinsiz çoğaltıp dağıtmayacağını, yayınlamayacağını, pazarlamayacağını,
- MSA’nın İnternet Sitesi’ndeki hizmetleri kullanırken ileri sürdüğü şahsi fikir, düşünce ve ifadelerin, İnternet Sitesi'ne eklediği dosyaların ve içeriklerin sorumluluğunun kendisine ait olduğunu ve MSA'nın bu içeriklerden dolayı hiçbir şekilde sorumlu tutulamayacağını,
- İnternet Sitesi'ne zarar verecek veya MSA'yı başka internet siteleri ile uyuşmazlık durumuna getirecek herhangi bir yazılım veya materyal bulunduramayacağını, paylaşamayacağını, bu sebeplerden dolayı herhangi bir cezai durumun doğması halinde tüm hukuka ve cezai sorumlulukları üstüne aldığını,
- Üye’lerin hizmetlerin kullanımı sırasında kaybolacak, ve/veya eksik alınacak, yanlış bir adresin verilmiş olmasından dolayı yanlış adrese iletilecek bilgi, mesaj ve dosyalardan MSA'nın sorumlu olmayacağını,
- İnternet Sitesi’nde sunulan hizmetlere MSA tarafından belirlenen şekil dışında ve yetkisiz şekilde ulaşmamayı, yazılım ile servislerin özelliklerini hiçbir şekilde değiştirmemeyi, değiştirilmiş olduğu belli olanları kullanmamayı ve sözü geçen maddelere uymadığı durumlarda MSA'in uğrayabileceği tüm maddi ve manevi zararları ödemeyi,
- Üye verilerinin MSA'nın ihmali görülmeden yetkisiz kişilerce okunmasından (üyenin bilgilerini başka kişiler ile paylaşması, siteden ayrılırken çıkış yapmaması, ve benzeri durumlardan kaynaklı olarak) dolayı gelebilecek zararlardan ötürü MSA'nın sorumlu olmayacağını,
- Tehdit edici, ahlak dışı, ırkçı, ayrımcı, Türkiye Cumhuriyeti Yasalarına, vatandaşı olduğu diğer ülkelerin yasalarına ve uluslararası anlaşmalara aykırı mesajlar göndermemeyi,
- İnternet sitesi üzerinde eklenecek yazışmaların, konu başlıklarının, rumuzların, genel ahlak, görgü ve hukuk kurallarına uygun olmasını,
- Diğer Üye ve kullanıcıları taciz ve tehdit etmemeyi,
- Diğer Üye ve kullanıcıların hizmetleri kullanmasını etkileyecek şekilde davranmamayı, diğer kullanıcıların bilgisayarındaki bilgilere ya da yazılıma zarar verecek bilgi veya programlar göndermemeyi,
- MSA hizmetlerini kullanarak elde edilen herhangi bir kayıt veya elde edilmiş bilgilerin tamamiyle kullanıcının rızası dahilinde olduğunu, kullanıcı bilgisayarında yaratacağı arızalar, bilgi kaybı ve diğer kayıpların sorumluluğunun tamamiyle kendisine ait olduğunu, servisin kullanımından dolayı uğrayabileceği zararlardan dolayı MSA'dan tazminat talep etmemeyi, MSA'dan izin almadan MSA servislerini ticari ya da reklam amacıyla kullanmamayı, MSA'nın, dilediği zaman veya sürekli olarak tüm sistemi izleyebileceğini, kurallara aykırı davrandığı takdirde MSA'nın gerekli müdahalelerde bulunma, üyeyi servis dışına çıkarma ve üyeliğe son verme hakkına sahip olduğunu, MSA'nın, kendi sistemini ticari amaçla kullanabileceğini,
- Kanunlara göre postalanması/paylaşılması yasak olan bilgileri paylaşmamayı ve zincir posta (chain mail), yazılım virüsü (vb.) gibi gönderilme yetkisi olmayan postaları dağıtmamayı,
- Başkalarına ait olan kişisel bilgileri kayıt etmemeyi, kötüye kullanmamayı,
- Üye "Kullanıcı Adı"yla yapacağı her türlü işlemden bizzat kendisinin sorumlu olduğunu,
- Üyeliğini tek taraflı olarak iptal ettirse bile, bu iptal işleminden önce, üyeliği sırasında gerçekleştirdiği tüm icraatlardan birebir sorumlu olacağını,
- Tüm bu maddeleri daha sonra hiçbir itiraza mahal vermeyecek şekilde okuduğunu, kabul ve taahhüt etmiştir.


MSA'YA VERİLEN HAK VE YETKİLER:

Madde 6.MSA İnternet Sitesi’nin, herhangi bir zamanda, sistemin çalışmasını geçici bir süre askıya alabilir veya tamamen durdurabilir. Sistemin geçici bir süre askıya alınması veya tamamen durdurulmasından dolayı MSA'nın üyelerine veya üçüncü şahıslara karşı hiçbir sorumluluğu olmayacaktır.

MSA, İnternet Sitesi hizmetlerinde meydana gelecek teknik arızalar nedeniyle Üye’nin uğrayacağı zarardan sorumlu değildir. MSA, servislerinin her zaman ve her şart altında zamanında, güvenli ve hatasız olarak sunulacağını, servis kullanımından elde edilen sonuçların her zaman doğru ve güvenilir olacağını, servis kalitesinin herkesin beklentilerine cevap vereceğini taahhüt etmez. MSA, kendi sitesi üstünden yapılan ve zarar doğurabilecek her türlü haberleşmeyi, yayını, bilgi aktarımını istediği zaman kesme hakkını ve gereken koşullar oluştuğu takdirde üye mesajlarını silme, üyeyi servislerden menetme ve üyeliğine son verme hakkını saklı tutar.

ÜYE VERİLERİ, E- BÜLTEN VE GİZLİLİK:

Madde 7.

MSA, İnternet Sitesi üyelerine daha nitelikli ve güvenilir hizmet verebilmek amacıyla üyelik aşamasında ve İnternet Sitesini kullanırken kullanıcılardan, Üyelerden bazı kişisel bilgilerin (isim, yaş, ilgi alanlarınız, e-posta adresiniz vb.) verilmesini talep etmektedir. MSA sistemlerinde toplanan bu bilgiler, Üyelerin MSA’dan ve İnternet sitesi hizmetlerinden en iyi ve güncel şekilde faydalanmasını sağlamak, haber, kampanya, yeni ürün/eğitim içerikleri, tanıtım, reklam ve benzeri duyurulardan haberdar olmaları amacıyla ticari elektronik iletilerin gönderilmesi, Üye tarafından istenmeyen e-postaların/bilgilerin filtrelenebilmesi, paylaşımların, gönderilerin Üye’nin belirlemiş olduğu tercihlerine göre yönetilebilmesi amacıyla MSA bünyesinde kullanılmaktadır.

Üye’nin MSA ve İnternet Sitesi ile paylaşmış olduğu kişisel bilgiler bu amaç dışında kullanılmaz ve 3. Şahıslar ile paylaşılmaz.

Üye, kişisel bilgilerinin MSA tarafından bu koşullar ile kullanılmasını ve saklanmasını kabul eder. Üye, MSA İnternet Sitesi üzerinden vermiş olduğu e-posta adresine MSA ürün ve servisleri ile ilgili kampanya, bülten, tanıtım, reklam ve duyurulardan haberdar olması amacıyla MSA tarafından ticari elektronik ileti gönderilmesini, ve bu iletilerin belirlemiş olduğu tercihler bazında yapılacağını kabul eder. MSA tarafından gönderilen bu ticari elektronik iletileri almak istemiyor veya almayı onaylamıyor ise Üye, gönderilen ticari elektronik iletide yer alan ‘E-bülten listesinden çıkma’ seçeneğini kullanır.

MSA, üyelik formlarında Üyelerden talep ettiği kişisel bilgileri, üçüncü şahıslarla kesinlikle paylaşmaz, faaliyet dışı hiçbir nedenle ticari amaçla kullanmaz.

Üye’nin kişisel bilgileri, ancak resmi makamlarca usulüne uygun şekilde talep edilmesi halinde ve yürürlükteki emredici mevzuat hükümleri gereğince resmi makamlara açıklama yapmak zorunda olunan durumlarda resmi makamlara açıklanabilir. MSA, üyelerinin bilgilerini aşağıda belirtilen koşullardan birinin ya da hepsinin gerçekleşmesi halinde ilgili resmi merciler ile paylaşma hakkına sahiptir:

- Resmi makamlardan üyeye yönelik suç duyurusu ya da resmi soruşturma talebi gelmesi durumunda,
- Üyenin sistemin çalışmasını engelleyecek bir sabotaj ya da saldırı yaptığının tespit edilmesi durumunda,
- Üyeliği sözleşmede belirtilen sebeplerden dolayı iptal edilmiş bir üyenin yeniden üye olarak sözleşme ihlalini tekrarlaması durumunda ve bunlarla sınırlı olmayan benzeri diğer hallerde

MSA, Üyelerin dosyalarının saklanması için uygun göreceği büyüklükte kota tahsisi yapabilir. MSA, İhtiyaca göre kotaları artırma ve azaltma yetkisini saklı tutar. MSA üyelerin servislerden yararlanmaları sırasında ortamda bulunduracakları dosyaların, mesajların, bilgilerin bazılarını veya tamamını uygun göreceği periyodlarla yedekleme ve silme yetkisine sahiptir. Yedekleme ve silme işlemlerinden dolayı MSA sorumlu tutulmayacaktır. MSA kendi ürettiği ve/veya dışardan satın aldığı bilgi, belge, yazılım, tasarım, grafik vb. eserlerin mülkiyet ve mülkiyetten doğan telif haklarına sahiptir. MSA üyelerinin ürettiği ve yayınlanmak üzere kendi iradesiyle sisteme yüklediği (örneğin İnternet Sitesi'ne eklediği mesaj, şiir, haber, dosya, video web sayfası gibi) bilgi, belge, yazılım, tasarım, grafik, resim vb. tüm eserleri tanıtım, duyurum amacı ile yayınlama ve/veya site içerisinde MSA tarafından uygun görülecek başka bir adrese taşıma haklarına sahiptir. Yayınlanan bu bilgilerin başka kullanıcılar tarafından kopyalanması ve/veya yayınlanması ihtimal dahilindedir. Bu hallerde Üye, MSA'den telif ve benzeri hiçbir ücret talep etmeyecektir. Üyeler başkalarına ait fikri ve sınai mülkiyet haklarının korunması için gerekli özeni göstermekle yükümlüdür. Üyeler sadece telif hakları kendisine ait olan İçeriği sisteme yükleyebilir. Eğer Üye, fikri ve sınai mülkiyet hakları başkasına ait olan yazı, fotoğraf, resim, logo, video ve sair içeriği, söz konusu eser ve hak sahiplerinin izni olmaksızın sisteme yüklerse, MSA ihlale konu olan İçeriği derhal yayından kaldırmak ve gerektiğinde bu ihlali gerçekleştiren üyelerin üyeliğine son vermek haklarına sahiptir. Üçüncü şahısların fikri ve sınai mülkiyet haklarını ihlal eden üyeler, bu ihlallerden ve bu ihlallerden doğan her türlü zarardan üçüncü şahıslar ile kamu kurum ve kuruluşlarına karşı hukuki ve cezai olarak bizzat sorumludurlar. MSA, üyenin ilettiği kişisel bilgilerin içerik sağlayıcılar ve web servisleri kullanıcılarına üyenin özlük haklarını taciz etmeyecek şekilde gerekli iletişim, tanıtım, mal teslimi, reklam vb. amaçlar için kullandırılması konusunda tam yetkilidir.

MSA, başka internet sitelerine link verebilir. Link verilen internet sitelerinde yayınlanan içeriklerin doğruluğu MSA tarafından garanti edilmemekte ve Link verilmesi, link verilen web sitelerinin içeriğinin MSA tarafından onaylandığı anlamına gelmez. Üye, link verilen internet sitelerinin içeriklerinden MSA'in sorumlu olmadığını kabul eder. Bu sitelerin kullanımı veya içerikleri nedeniyle ya da sağlanan hizmetler nedeniyle doğabilecek her türlü zarardan Üye'nin kendisi sorumludur. MSA, ileride doğacak teknik zaruretler ve mevzuata uyum amacıyla üyelere haber vermek zorunda olmadan işbu sözleşmenin uygulamasında değişiklikler yapabileceği gibi mevcut maddelerini değiştirebilir, iptal edebilir veya yeni maddeler ilave edebilir. Üyeler sözleşmeyi her zaman http://uyeler.msa.com.tr/yardim/uyeliksozlesme.htm adresinde bulabilir ve okuyabilirler. Servisler ile ilgili değişiklikler site içerisinde duyurulacaktır ve gerektiğinde üyenin hizmetlerden yararlanabilmesi için sözleşme değişikliklerini ilgili butonu tıklamak suretiyle onaylaması istenecektir. Bu sebeple, kullanıcılara, üyelere siteye her girişte yasal uyarı sayfasını ziyaret etmeleri tavsiye edilmektedir. MSA üyelik gerektirmeyen servisleri zaman içerisinde üyelik gerektiren bir duruma dönüştürülebilir. MSA ilave servisler açabilir, bazı servislerini kısmen veya tamamen değiştirebilir veya ücretli hale dönüştürebilir.

Üye’nin kendisi tarafından sonlandırılan üyelik hesabına ait her türlü kaydı silip silmeme kararı MSA’ya aittir. Üye, silinen kayıtlarla, saklanmayan, yedeği alınmayan bilgi ve belgelerle ilgili olarak yasal ya da sözleşmesel herhangi bir gerekçe ileri sürerek MSA’dan herhangi bir hak veya tazminat talebinde bulunmayacağını, MSA’ya bir kusur atfetmeyeceğini, ceza sorumluluğu yükletmeyeceğini kabul, beyan ve taahhüt eder.

MSA KAYITLARININ GEÇERLİLİĞİ:

Madde 8.

Üye işbu sözleşmeden doğabilecek ihtilaflarda MSA'in defter kayıtlarıyla, mikrofilm, mikrofiş ve bilgisayar kayıtlarının 6100 Sayılı HMK 193. Madde anlamında muteber, bağlayıcı, kesin ve münhasır delil teşkil edeceğini ve bu maddenin delil sözleşmesi niteliğinde olduğunu beyan ve taahhüt eder.

MÜCBİR SEBEPLER:

Madde 9. Mücbir sebep terimi; yasalarca kabul edilen hallere ilave olarak, doğal afet, grev, iletişim sorunları, altyapı ve internet arızaları, sisteme ilişkin iyileştirme veya yenileştirme çalışmaları, bu sebeple meydana gelebilecek arızalar, elektrik kesintisi, kötü hava koşulları da dâhil ancak bunlarla sınırlı olmamak kaydıyla, MSA’nın kontrolü dışında, gerekli özeni göstermesine rağmen önleyemediği olaylar olarak yorumlanacaktır.

MSA, hukuken mücbir sebep sayılan tüm hallerde, işbu sözleşmedeki edimlerini ifa ile yükümlü olmayacak; edimlerin tamamen veya kısmen, geç veya eksik ifa edildiği ileri sürülerek herhangi bir biçim ve seviye de sorumlu tutulmayacaktır. Üye bu vb. hiçbir durumu gerekçe göstererek MSA’dan herhangi bir nam altında tazminat talep etmeyeceğini kabul ve taahhüt eder.

UYGULANACAK HÜKÜMLER:

Madde 10.

Bu sözleşmeyle ilgili olarak çıkabilecek ihtilaflarda öncelikle işbu sözleşmedeki hükümler, hüküm bulunmayan hallerde ise Türk Kanunları (TBK, TTK, HMK, TMK ve 5651 Sayılı Yasa vesair) uygulanacaktır.

TEBLİGAT:

Madde 11.

Üyenin, MSA’ya bildirdiği elektronik posta adresi, işbu sözleşme ile ilgili olarak yapılacak her türlü bildirim için yasal posta adresi olarak kabul edilir. Üye, mevcut elektronik posta adreslerindeki değişiklikleri, yazılı olarak MSA’ya 3 (üç) gün içinde bildirmedikçe, eski elektronik postalara yapılacak bildirimlerin geçerli olacağını ve bildirimlerin kendilerine yapılmış sayılacağını kabul eder.

YÜRÜRLÜK:

Madde 12.

Kullanıcı Kayıt Formu'nu doldurup formun altında bulunan "Kabul Ediyorum" butonunu tıkladığında bu sözleşme taraflar arasında süresiz olarak yürürlüğe girer. Üye, işbu sözleşmede yer alan maddelerin tümünü okuduğunu, anladığını, kabul ettiğini; kendisiyle ilgili verdiği bilgilerin doğruluğunu onayladığını kabul, beyan ve taahhüt eder.

FESİH:

Madde 13.

Taraflar dilediği zaman işbu sözleşmeyi sona erdirebilir.

Copyright © 2016 MSA A.Ş. İşbu sözleşmenin telif hakları MSA Mesleki Eğitim ve Ticaret Anonim Şirleti’ne Aittir.
                """),
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
                    borderRadius: BorderRadius.circular(10),
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
