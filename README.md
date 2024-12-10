# Kotlin Multiplatform (KMP) - NotesApp 
NotesApp je aplikacija koja stavlja fokus na demonstraciju osnovnih i kljucnih koncepata **Kotlin Multiplatform** tenologije za potrebe ispita iz Naprednog Softverskog Inzinjerstva

## Svrha tutorijala
- Upoznavanje sa tehnologijom Kotlin Multiplatform
- Prikaz osnovnih koncepata koji se primenjuju kod aplikacija koje koriste ovu tehnologiju
- Demonstracija na koji nacin se glavni koncepti tehnologije prakticno koriste
- Prikazivanje glavnih prednosti Kotlin Multiplatforma u odnosu na konkurente tehnologije
- Pregled glavnih use-case-ova Kotlin Multiplatforma (kada koristiti KMP)

## Sta je Kotlin Multiplatform

Kotlin Multiplatform (KMP) je skup alata koji omogucava razvoj aplikacija za razlicite platforme koristeci zajednicki kod baziran na Kotlin programskom jeziku. KMP omogucava programerima da pisu kod koji moze da se koristi na vise platformi, kao sto su Android, iOS, web, desktop, bez potrebe da se svaka od funkcionalnosti kao i logika pise za svaku platformu zasebno. Dakle, on omogucava jednostavniji razvoj multiplatformskih aplikacija kao i smanjenje vremena potrebnog za pisanje i odrzavanje koda namenjenog za razlicite platforme. 

## Problemi koje KMP resava
1. Ponovno pisanje koda za razlicite platforme 
  - Problem: Poslovna logika, algoritmi, modeli podataka i ostale funkcionalnosti moraju biti implementirani vise puta za svaku platformu
  - Resenje: KMP omogucava da se poslovna logika, algoritmi, modeli podataka i druge funkcionalnosti napisu na Kotlinu i dele medju platformama u       specijalnim deljivim modulima
2. Fragmentacija izmedju razlicitih platformi
  - Problem: Svaka od platformi ima prilagodjene i specificne biblioteke, alate, API-je, samim tim razvojni timovi moraju da se nose za razlicitim   tehnologijama koje su podlozne promenama sto moze dovesti do nekonzistencije izmedju funkcionalnosti.
  - Resenje: Fragmentacija kod KMP-a nestaje jer sada za logiku koriste API-ji koji su platformski nezavisni i isti za sve
3. Odrzavanje koda
  - Problem: Promena bilo koje funkcionalnosti zahteva promene u svakoj od platformski specificnih implamentacija
  - Resenje: oOdrzavanje KMP projekta se svodi na odrzavanje jednog koda.
4. Podrska za nove platforme 
  - Problem: Aplikacija za novu platformu zahteva implementaciju celog koda iz pocetka
  - Resenje: Prosirljivost za nove platforme postaje olaksano jer se do sada vec deljiva biznis logika moze samo iskoristiti za potrebe nove platforme
5. Kompleksnost u testiranju
  - Problem: Moraju se pisati odvojeni testovi za svaku od platformi
  - Resenje: Testiranje je olaksano i sada postaje centralizovano, tj pisu se testovi za deljiv kod

## Glavni koncepti KMP-a

1. **Target** - platforma za koju ce kod koji je napisan u deljivom modulu moci da se iskompajlira
2. **Source set** - skup fajlova u kojima se nalazi kod koji koristi platformski zavisne biblioteke i api-je. Svaki target treba da ima svoj odgovarajuci source set
3. **Common code** - vrsta source seta koja sadrzi zajednicki kod, odnosno kod koji se moze iskompajlirati za bilo koju platformu
4. **expect** i **actual** - kljucne reci koje omogucavaju pozivanje platformski zavisnog koda u platformski nezavisnom modulu

### Target (deklaracija ciljane platforma)

Target je zapravo deklaracija koja definise za koje platforme je neophodno da se zajednicki kod iskompajlira. On definise kog formata ce biti izvrsna datoteka koja se izgenerise.
Target-i se deklarisu u **Gradle** fajlu unutar **kotlin { }** bloka, i upravo na ovaj nacin Kotlin zna za koje platforme ne neophodno kreirati izvrsnu datoteku. 

### Common (zajednicki/platformski nezavisan) kod

To je kod koji se deli i koristi od strane svih platformi i nalazi se najcesce u **commonMain** direktorijumu. U zavisnosti od konfiguracije zeljenih platformi, kod iz ovog direktorijuma se moze direktno prevesti za odgovarajucu platformu.
Ogranicenje koje se namece kod pisanja zajednickog koda je to sto Kotlin zabranjuje koriscenje platformski zavisnih biblioteka u ovod delu koda, tj dozvoljeno je koriscenje samo Kotlin Multiplatform biblioteka, u suprotnom prijavice gresku.

### Source set (grupa fajlova sa platformski zavisnim kodom)

Kotlin source set je zapravo direktorijum koji sadrzi fajlove izvornog koda namenjene konkretnoj platformi sa njoj prilagodjenim bibliotekama i opcijama za kompajliranje. Oni su zapravo centralni deo tehnologije koji omogucava deljenje koda.
Gotovo nemoguce je da se sve zeljene funkcionalnosti implementiraju koriscenjem samo Kotlin Multiplatform biblioteka i alata. Za tu namenu koriste se ovi platformski zavisni source setovi koji omogucavaju da se koriste platformski zavisne biblioteke i alati.
Svaki source set u KMP projektu :
- Ima ime koje je jedinstveno u projektu
- Ima skup platformski zavisnih fajlova i resursa
- Ima odgovarajuci target za koji se kompajlira, i upravo target ukazuje na to koji dependency-ji i biblioteke su dostupne u tom source setu
- Definise svoj biblioteke i platformske specificnosti 

**Zajednicki kod koji je prethodno pominjan i koji se nalazi u commonMain direktorijumu je upravo jedan source set i to jedini platformski nezavisni source set.**

Source setovi se nalaze unutar **shared/src** direktorijuma koji postoji pri kreiranju projekta
Konfiguracije za svaki od source seta pisu se u **Gradle** fajl-u , unutar **sourceSets { }** bloka.

Komplajliranje koda za odredjenu platformu se vrsi tako sto se pokupi sav kod iz commonMain source seta ali i iz source seta namenjenom za tu platformu, nakon cega se sav prikupljen kod kompajlira u jednu izvrsnu datoteku koja sadrzi funkcionalnosti iz oba source seta.

### expect i actual

Ove dve kljucne reci koriste se u paru i omogucavaju deklaraciju platformski zavisnog koda koji zelimo da pozivamo iz zajednickog koda. Princip koriscenja je najslicniji implementaciji i deklaraciji interfejsa kod objektno-orijentisanog programiranja:
1. U commonMain-u deklarise se bilo koja programska konstrukcija (funkcija, properti, klasa, interfejs …)
2. Oznaci se kljucnom recju expect. Ova deklaracija ne treba da ima svoju implementaciju.
3. U platformski zavisnim source setovima deklarise se identicna konstrukcija samo oznacena kljucnom recju actual. Ovde je neophodno implementirati zeljenu konstrukciju koriscenjem platformski zavisnih biblioteka.

Tokom prevodjenja kompajler ukoliko naidje na kljucnu rec expect trazi u odgovarajucem platformski zavisnom source setu isto deklarisanu konstrukciju koja je oznacena sa actual i na to mesto ubacuje kod iz platformski zavisnog seta. 

## Kada koristiti KMP

- Kada zelite da delite logiku dok zadrzavate UI native
- Kada zelite da delite i logiku i UI - ComposeMultiplatform
- Kada zelite da delite deo logike (npr. sloj pristupa podacima)
- Kada zelite da ucinite svoju aplikaciju multiplatformskom

  
## KMP vs Flutter vs React Native
1. **Brzina razvoja aplikacije:**
  - Flutter - Brzi razvoj jer postoji jedan kod kao i hot reload ficer. Takodje omogucava i cross-platform razvoj korisnickog interfejsa.
  - KMP - Brzina razvoja moze da varira jer UI kod mora da bude napisan za svaku od platformi, a vrlo cesto i deo logike
  - RN - Brzi razvoj jer postoji jedan kod kao i hot reload ficer.
2. **Performanse:**
- Flutter : priiblizno native performanse, ali ne nuzno i native nivoi optimizacije
- KMP : obezbedjuje native performanse buduci da UI ostaje native
- RN - jako dobar sa stanovista performansi ali i dalje zaostaje za native performansama
3. **Fleksibilnost UI-a:**
- Flutter: jako fleksibilan i prilagodljiv UI sa bogatim setom podrzanih vidzeta
- KMP : fleksiblan koliko i sam native UI
- RN - jedan UI koji koristi React komponente
4. **Ekosistem i programerska zajednica:**
- Flutter : Dobro dokumentovana podrska za koriscenje, brojni plug-in-ovi, paketi i biblioteke, siroko koriscen
- KMP : Jos u razvoju, nema mnogo dokumentacije, postaje dosta popularan, donekle ogranicen broj resursa i biblioteka, brojne funkcionalnosti su jos u beta ili alfa verziji, jos uvek ga ne koristi veliki broj ljudi
- RN : Siroko rasporstanjena zajednica developera koji ga koriste, brojni tutorijali, plug-inovi, biblioteke, dokumentacija
5. **Integracija i koriscenje:**
- Flutter : najpogodnije za implementaciju celokupnih aplikacija
- KMP : dobro se integrise u postojece projekte, omogucava deljenje logike bez potrebe za menjanjem UI-a
- RN : najpogodnije za implementaciju novih celokupnih aplikacija, kada UI nije previse slozen

## Prednosti i mane KMP
Prednosti:
- Impementirana aplikacija je 100% native za svaku platformu
- Lako se integrise u vec postojeci kod 
- Lak za koriscenje
- UI se pise native za svaku od platformi pa je samim tim konzistentnta i prilagodjena platformi
- Olaksano ispravljanje bagova i dodavanje funkcionalnosti

Mane:
- I dalje neke od funkcionalnosti su u svojoj alfa ili beta verziji
- Mala zajednica ljudi koji ga koristi
- Malo dokumentacije

## NotesApp

Ova aplikacija predstavlja jednostavnu CRUD mobilnu aplikaciju na kojoj je demonstrirano koriscenje KMP tehnologije. Aplikacija omogucava korisnicima kreiranje jednostavnih beleski, njihov pregled, pretragu, izmenu i brisanje. Aplikacija zapravo predstavlja jednostavnog klona notes aplikacije koja postoji na bilo kom telefonu. Ovu aplikaciju moguce je pokrenuti i na Android i na iOS operativnom sistemu.

### Pokretanje projekta i koraci za instalaciju
#### Instalacija neophodna za pokretanje projekta

1. Kloniranje repozitorijuma
2. Ukoliko ne postoji neophodna je instalacija JDK-a ([link za preuzimanje JDK-a](https://www.oracle.com/java/technologies/downloads/)), moze se proveriti komandom java -version
3. Ukoliko ne postoji neophodna je istalacija Android Studio okruzenja ([link za preuzimanje Android Studio okruzenja](https://developer.android.com/studio))
4. Ukoliko ne postoji neophodna je istalacija Xcode okruzenja za pokretanje iOS aplikacije ([link za preuzimanje Xcode okruzenja](https://apps.apple.com/us/app/xcode/id497799835 ))
5. Ukoliko ne postoji, neophodno je preuzimanje plug-in-a za KMP ([link za preuzimanje KMP plug-in-a](https://plugins.jetbrains.com/plugin/14936-kotlin-multiplatform) )

#### Pokretanje projekta
> ⚠️ **NAPOMENA : Za pokretanje aplikacije za iOS operativni sistem neophodan je macOS uredjaj!**

1. Pokrenuti Android Studio okruzenje
2. Opcijom Open potrebno je izabrati projekat koji je preuzet kloniranjem repozitorijuma
3. Kada projekat zavrsi sa ucitavanjem, u gornjem desnom meniju okruzenja potrebno je odabrati opciju androidApp.
   
![Screenshot 2024-12-09 at 14 22 15](https://github.com/user-attachments/assets/d097c6cc-fe99-421f-8245-10e5e6b42495)

4. Klikom na zelenu strelicu zapocece pokretanje aplikacije na virtuelnom emulatoru za Android operativni sistem, nakon cijeg pokretanja je moguce isprobati aplikaciju.
5. Ukoliko zelite da pokrenete aplikaciju i za iOS uredjaj, pokrenite  Xcode okruzenje
6. Vratite se u Android Studio okruzenje i na mestu gde ste u koraku 3 odabrali androidApp sada izaberite iosApp

![Screenshot 2024-12-09 at 14 24 41](https://github.com/user-attachments/assets/a5f4b667-c7fe-469f-a072-d59a91305f1c)

7. Klikom na zelenu strelicu zapocece pokretanje aplikacije na virtuelnom emulatoru za iOS operativni sistem, nakon cijeg pokretanja je moguce isprobati aplikaciju.

### Tehnologije koje su koriscene

- Frontend : Kotlin (Jatpack Compose) i SwiftUI 
- Backend : Kotlin (KMP) i SqlDelight 

### Struktura projekta

Osnovna struktura projekta se moze podeliti na 3 celine :
- Deljivi modul izmedju Android-a i iOS-a (shared folder, commonMain, androidMain, iosMain)
- UI i logika za Android (androidApp)
- UI i logika za iOS (iosApp)

### Shared folder

**Build.gradle.kts fajl** 

Fajl u kome se definise hijerarhija source setova, nacin na koji su povezani kao i to koje dependency-je i biblioteke svaki od njih podrzava. NotesApp koristi kotlinx biblioteku za rad sa datumima i SqlDelight biblioteku. Ove biblioteke neophodno je koristiti iz zajednockog koda te se moraju navesti u commonMain.dependencies sekciji.

``` kotlin
sourceSets {
        commonMain.dependencies {
            implementation(libs.runtime)
            implementation(libs.kotlinx.datetime)
            implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.6.0-RC.2")
        }
//ostatak koda
}
```
``` kotlin
kotlinx-datetime = { module = "org.jetbrains.kotlinx:kotlinx-datetime", version.ref = "kotlinxDatetime" }

```
Kako SqlDelight zahteva driver prilagodjen platformi na kojoj se koristi, pored commonMain konfiguracije neophodno je importovati dependency-je za SqlDelight drivere u svakom od platformskih source setova.

```kotlin
sourceSets {
       //ovde ide neki kod
        androidMain.dependencies {
            implementation(libs.android.driver)
        }

        iosMain.dependencies {
            implementation(libs.native.driver)
        }
    }
```
```kotlin
android-driver = { module = "app.cash.sqldelight:android-driver", version.ref = "sqlDelight" }
native-driver = { module = "app.cash.sqldelight:native-driver", version.ref = "sqlDelight" }
```
Pored ovoga, u Gradle fajl neophodno je dodati i konfiguraciju za SqlDelight kojom se kreira baza podataka koja ce se koristiti
```kotlin
sqldelight{
    databases{
        create("NotesDatabase"){
         packageName="com.swe.notesapp.database"
        }
    }
}
```
**SqlDelightNoteDataSource.kt klasa**

Ovo je klasa koja se nalazi unutar commonMain source seta i zapravo vrsi pozive API-ja koji su izgenereisani od strane SqlDelight-a na osnovu skripte NotesDatabase.sq. Klasa ima parametar u konstrukoru kroz koji ce se, sto ce i kasnije biti objasnjeno, injectovati odgovarajuci platformski driver za SqlDelight. Ovo je neophodno kako bi rad sa SqlLite bazom bio moguc i na Android-u i na iOS-u
```kotlin
class SqlDelightNoteDataSource(db:NotesDatabase): NoteDataSource {

    private val queries = db.notesDatabaseQueries

    override suspend fun createNote(note: Note) {
        queries.insertNote(
            id = note.id,
            title = note.title,
            content = note.content,
            colorHex = note.colorHex,
            created = DateTimeUtil.toEpochMillis(note.created)
        )
    }

    override suspend fun getNoteById(id: Long): Note? {
        return queries
            .getNoteById(id)
            .executeAsOneOrNull()
            ?.toNote()

    }
//ostatak funkcionalnosti ..
}

```
**SearchNotes.kt**

Klasa koja sadrzi jednu funkciju search cija je namena da se koristi za pretragu beleski po naslovu ili tekstu. Nalazi se unutar shared/commonMain foldera i u potpunosti je napisana cross-platform.

**DateTimeUtil.kt**

Objekat koji sadrzi nekoliko funkcija koje se koriste za formatiranje vremena sa ciljem da se prikazu citljivo korisniku. Opet ovo je kod koji je u potpunosti pisan koristeci Kotlin Multiplatform biblioteke za rad sa datumima i vremenom tako da nema dodatne implementacije ovog dela koda u platformskim source setovima.

**DatabaseDriverFactory.kt**

Ovo je klasa koja oslikava jos jedan koncept KMP-a, odnosno expect i actual deklaracije. Klasa unutar commonMain-a oznacena je kao expect i ima jednu metodu createDriver koja treba da vrati SqlDelight drajver. Upravo zbog toga sto SqlDelight radi sa razlicitim drajverima za razlicite platforme, neophodno je da u androidMain i iOSMain source setovima postoje actual deklaracije ovakve kase sa implementacijom ove funkcije u kojoj ce svaka od platformi da vrati odgovarajuci drajver. Ovo ce se koristiti za instanciranje objekta baze podataka koji se prosledjuje kao parametar NoteDataSource objektu.

```kotlin
//unutar commonMain source seta

expect class DatabaseDriverFactory {
    fun createDriver():SqlDriver
}
```
```kotlin
//unutar androidMain source seta

actual class DatabaseDriverFactory(private val context:Context) {
    actual fun createDriver():SqlDriver{
        return AndroidSqliteDriver(NotesDatabase.Schema,context,"note.db")
    }
}
```
```kotlin
//unutar iosMain source seta

actual class DatabaseDriverFactory {
    actual fun createDriver():app.cash.sqldelight.db.SqlDriver{
        return NativeSqliteDriver(NotesDatabase.Schema,"note.db")
    }
}
```
**DatabaseModule.kt**

Jednostavna klasa koja je napisana u iosMain kodu. Ova klasa iako na prvi pogled nema nista specificno za iOS platformu, koristi se kako bi se sa strane iOS aplikacije moglo pristupiti NoteDataSource-u. Za kreiranje NoteDataSource-a neophodna je istanca baze koju je jedino moguce iskreirati iz Kotlin koda. Ova klasa upravo to i radi, i ima jedan public atribut kojem je sada moguce pristupiti i iz iOS aplikacije buduci da ona prepoznaje NoteDataSource interfejs koji je definisan unutar commonMain koda.
```kotlin
class DatabaseModule {
    private val factory by lazy {DatabaseDriverFactory()}
    public val noteDataSource : NoteDataSource by lazy {
        SqlDelightNoteDataSource(NotesDatabase(factory.createDriver()))
    }
}
```
### UI i logika za Android 

Da bi bilo omoguceno koriscenje NoteDataSource-a u Android kodu neophodno je da se sada otvori androidApp folder, koji cini potpuno nezavisnu Android aplikaciju. Kako se kod razvoja Android aplikacija koriste razne biblioteke za dependecy injection, ovde je upotrebljena Hilt biblioteka. Ovo je neki standard kod pisanja Android aplikacija tako da nece biti detaljnijeg objasnjenja ([detaljnije o dependency injetion-u uz pomoc Hilt biblioteke mozete procitati ovde](https://developer.android.com/training/dependency-injection/hilt-android ))
Nakon konfigurisanja Hilt DI-a moguce je koristiti NoteDataSource kao i sve njegove funkcionalnosti. Osim NoteDataSource-a, sve ostale klase i objekti koji su implementirani u zajednickom modulu na cistom Kotlin Multiplatformu mogu se direktno koristiti iz Android aplikacije.

### UI i logika za iOS 

Logika unutar iOS aplikacije jako je minimalna. Pisanjem DatabaseModula omoguceno je da iOS aplikacija sada pristupa svim funkcionalnostima definisanim NoteDataSource interfejsom. Kako Swift koristi dependecy injection po principu prosledjivanja zavisnosti putem konstruktora, nema neke dodatne konfigiracije na iOS strani aplikacije. Instanciranjem DatabaseModule klase moguce je pribaviti NoteDatabaseSource koji se prosledjuje dalje kroz aplikaciju i koristi za manipulaciju podacima. 

