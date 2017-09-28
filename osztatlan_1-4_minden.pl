#!/usr/bin/perl
#
#   Copyright (c) Kis János Tamás, 2013. december 18.
#   VERZIOSZAM ='1.01 (2014. szeptember 10.)'
#   VERZIOSZAM ='1.20 (2015. február 5.)'
#
#   A program szabad szoftver, bárki továbbadhatja és/vagy módosíthatja
#   a legfrissebb GNU General Public Licence feltételei szerint, ahogy
#   azt a Free Software Foundation közli. A program módosított változatai,
#   a változatlan másolatokkal megegyezô feltételek alapján másolhatók
#   és terjeszthetôk, ha a módosított változatot is, az ezzel az enge-
#   déllyel megegyezô feltételek szerint terjesztik. A lefordított kód
#   is a módosított változat kategóriájába tartozik. Az üzleti célú
#   terjesztés NEM MEGENGEDETT. Módosítás és terjesztés elôtt a dolgok
#   naprakészségének biztosítása végett ajánlott kapcsolatba lépni a
#   szerzôvel. A program módosítása esetén, kérlek juttatsd el a szerzô-
#   nek a módosított forráskódot valamilyen formában, hogy a hasznos
#   változás mihamarabb bekerüljön a szoftver "hivatalos" disztribúció-
#   jába. A nyomtatott változat jobban néz ki...   :-)
#   E programot (én, a szerzô) azzal a reménnyel terjesztem, hogy hasznos
#   lesz, de MINDENFÉLE GARANCIA VÁLLALÁSA NÉLKÜL. A részletek a GNU
#   General Public Licence-ben találhatók. A programmal együtt kapnod
#   kellett egy másolatot a GNU General Public Licence-bôl, ha nem kaptál,
#   írj a következô címre:
#   Free Software Foundation, Inc. 675 Mass Ave, Cambridge, MA 02139, USA
#   A program szerzôje a következô címeken érhetô el :
#   ×----------------------------------------------------------------×
#   |  Kis János Tamás, E-mail: kjt@takarnet.hu, kijato@gmail.com    |
#   |                   Tel.: (76) 502-562                           |
#   ×----------------------------------------------------------------×
#   *================================================================×
#   |       A PROGRAM SZABADON TERJESZTHETÖ, HA A COPYRIGHT ÉS       |
#   |         AZ ENGEDÉLY SZÖVEGÉT MINDEN MÁSOLATON MEGÕRZIK.        |
#   ×================================================================*
#
use strict;
#use warnings;
#use Encoding;
use Data::Dumper;
use locale; # Ez kell az ABC szerinti helyes rendezéshez.

if ( @ARGV<2 ) {
print <<'END';
	
	A program az osztatlan közös tulajdon megszüntetésével kapcsolatos,
	(1-2-3-4-es) jelentés összeállítására készült.
	
	Elsõ paraméterként a megye nevét, másodikként (gyakorlatilag) egy fájl
	listát vár, amit megadhatunk helyettesítõ karakterekkel is. A program
	feltételezi, hogy a feldolgozandó CSV állományok (járásonként 4-4 darab)
	a következõ analógia szerint vannak elnevezve:
	1. A fájlnévben az adatokat "_" jel választja el egymástól.
	2. Az 1. adat az "osztatlan" szó.
	3. A 2. adat az eljárás típusának sorszáma.
	4. A 3. adat a hónap kódja.
	5. A 4. adat a járás neve.
	Azaz pl: "osztatlan_1_2014-08_Baja.csv"
	
	Kimenetként az összemásolt állományok  mellett elkészíti az összesítõt is
	melynek kijelölt tartalmát Ctrl+C & Ctrl+V-vel könnyen bemásolhatjuk az
	FM FF által megadott Excel állományba.
	
	Példa:
	------
	Nálam a járások által megadott állományok egyetlen, a program melletti
	"adatok"/ könytárba vannak másolva. Így készítettem egy batch fájlt
	("osztatlan_1-4_minden.bat" néven), a következõ tartalommal:
		chcp 1250
		set honap=2014-08
		perl osztatlan_1-4_minden.pl Bács-Kiskun adatok\osztatlan_?_%HONAP%*.csv > %HONAP%_Napló.log
		
	A batch fájlt futtatva elkészülnek a típusonként összemásolt
	(2014-08_Bács-Kiskun_*.csv) állományok és az összesítõ
	(2014-08_Bács-Kiskun_Osszesites.csv), plusz kapok egy naplót amiben minden
	lényeges mozzanat és tárolt adat látható. Hónapról-hónapra változtatni
	csupán a batch fájlon kell, a honap helyes megadásával, illetve a továbbítás
	elõtt a hónap megírásokat törölni kell a fájl nevekbõl.
	
END
exit;
}

my $megye = shift(@ARGV);

# Eredeti verzió:
# my $fejlec_1_4 = "Sor típusa;Település sorszám;Községnév;Fekvésnév;Hrsz;Hrsz alátörés;Ingatlan területe;Számított kiosztandó terület;Kérelmezõk darabszáma;Tulajdonosok száma;Állami tulajdon megjelölés;Perfeljegyzés darabszáma;Terhek darabszáma;Helyhez köthetõ terhek darabszáma;Tul3 szövegek darabszáma;Széljegyek darabszáma;Hivatalnév;Eljárás státusz\n";
# 2015-01-tõl alkalmazott verzió:
my $fejlec_1_4 = "Sor típusa;Település sorszám;Községnév;Fekvésnév;Hrsz;Hrsz alátörés;Ingatlan területe;Számított kiosztandó terület;Kérelmezõk darabszáma;Tulajdonosok száma;Állami tulajdon megjelölés;Perfeljegyzés darabszáma;Terhek darabszáma;Helyhez köthetõ terhek darabszáma;Tul3 szövegek darabszáma;Széljegyek darabszáma;Hivatalnév;Eljárás státusz;Kérelmezett össz.tul.hányad számláló;Kérelmezett össz.tul.hányad nevezõ\n";
#
# 2014-04-tõl alkalmazott verzió:
my $feljec_osszesito = "Sorszám;Járási földhivatal;A földhivatal által megkezdett és befejezendõ eljárások (földrészletek);el nem indított eljárások (földrészletek);folyamatban lévõ eljárások (földrészletek);megszakadt eljárások (földrészletek);befejezett eljárások (földrészletek);Soron kívül kérelem alapján megosztott földrészletek;el nem indított eljárások (földrészletek);folyamatban lévõ eljárások (földrészletek);megszakadt eljárások (földrészletek);befejezett eljárások (földrészletek);NKP NKft. közremûködésével normál eljárás alapján megosztantó földrészletek;el nem indított eljárások (földrészletek);folyamatban lévõ eljárások (földrészletek);megszakadt eljárások (földrészletek);befejezett eljárások (földrészletek);NKP NKft. közremûködésével a II. fejezet alapján megosztandó földrészletek;el nem indított eljárások (földrészletek);folyamatban lévõ eljárások (földrészletek);megszakadt eljárások (földrészletek);befejezett eljárások (földrészletek);Összes megosztandó földrészlet;el nem indított eljárások (földrészletek);folyamatban lévõ eljárások (földrészletek);megszakadt eljárások (földrészletek);befejezett eljárások (földrészletek)\n";

my @dirs;
if ( $ENV{'OS'}=~/windows/i ) {
  my $szuro = join(" ",@ARGV);
  @dirs = glob $szuro;
  #my @dirs = <$szuro>;
} elsif ( $ENV{'OSTYPE'}=~/linux/i ) {
  @dirs = @ARGV;
} else {
  @dirs = ();
}

print "Paraméterek:'\n\tmegye:'$megye'\n\tszuro:'",join("\n\t\t",@dirs),"'\n\t";
#print '-' for (1..length(join("",@dirs))); print "\n";
print '-' for (1..70); print "\n";

my $adatok = ();
my (%korzetek) = ();
my $honap = "";

#
# Végigmegyünk a könyvtárlistán és egy hasítótáblába (%korzetek) betöltjük a fájlnevekbõl kiszedett körzetneveket,
# illetve egy hash-referenciába (%$adatok) a fájlok "rendezett" adatait.
#
foreach (@dirs) {
  if (-d) {
    print "'$_' -> Ez egy könyvtár!\n"; next;
  } elsif (-f) {
    #print "'$_' -> Ez egy fájl!\n";
    /osztatlan_(\d)_(\d{4}-\d{1,2})_(\D+)\.\D+$/;
    #print $1,"\t",$2,"\t",$3,"\n";
    my $tipus = $1;
    $honap = $2;
    my $korzet = $3;
    my (%statusz)=();
    $korzetek{$korzet.'_'.$tipus} = ucfirst($korzet);
    #$adatok->{ucfirst($korzet)} = [];
    # A fájlokat egyenként megnyitjuk, megszámoljuk a sorokat és megjegyezzük a tartalmat.
      open FH,$_;
      my ($sorok,$teljesfajl)=0;
      while(<FH>) {
	    if (/^\D+/) { next; }
	    $sorok++;
	    #/;(\w+);(\d+)$/;
	    #if ($korzet!~/.+$1.*/x) { die "Téves körzetnév...? [$korzet]\n$sorok : $_\n"; }
	    /;(\d+);\d*;\d*;?$/;
	    $statusz{$1}++;
	    $teljesfajl.=$_;
      }
      close FH;
    push @$adatok, {'korzet'=>ucfirst($korzet), $tipus=>$sorok, 'adat'=>$teljesfajl, 'statusz'=>\%statusz};
  } else {
    die "Se nem könyvtár, se nem fájl... Akkor ez ($_) mi...?\n"
  }
}
# A teljes beolvasott struktúra listázása:
print Dumper $adatok;

#
# A körzetnevek kigyûjtése önálló tömbbe (@korzetek):
#
my (@korzetek) = ();
%korzetek = reverse(%korzetek);
while ( my ($key, $value) = each %korzetek ) {
	#print "'$key'\t'$value'\n";
	push(@korzetek,$key);
} #print Dumper \@korzetek;

#
# Összemásoljuk a megfelelõ adatokat 1-1 CSV fájlba:
#
my @minden=();
foreach (@{$adatok}) {
  for (my $i=1; $i<5; $i++) {
    if ( exists($_->{$i}) && defined($_->{'adat'}) ) {
      $minden[$i] .= $_->{'adat'};
      $_->{'adat'}=''; # Kinullázzuk az "adat-mezõt" hogy a Dump olvashatóbb legyen...
    }
  }
}
# A teljes beolvasott struktúra listázása:
print Dumper @minden;

for (my $i=1; $i<5; $i++) {
  open FH,">".$honap."_".$megye."_$i.csv" || die "$!\n";
  print FH $fejlec_1_4;
  if ( defined($minden[$i]) ) { print FH $minden[$i]; }
  close FH;
  printf "\t%s\n","Az $i. típusú fájl kiírása kész!";
}
printf "%s\r","Az '1-4' fájlok kiírása kész!\n";
# A teljes beolvasott struktúra listázása:
#print Dumper $adatok;

#
# Elkészítjük az összesítõt:
#
print "\nAz 'Összesítõ' elkészítése indul...\n";
open FH,">".$honap."_".$megye."_Osszesites.csv" || die "$!\n";
my $j=0;
print FH $feljec_osszesito;
foreach my $k (sort @korzetek) {
  $j++; print FH "$j;$k;";
  #while ( my ($key,$value) = each %{$adatok} ) {
  #foreach my $h ( keys %{$adatok} ) {
  foreach my $h (@{$adatok}) {
    if ($k eq $h->{'korzet'} ) {
      for ( my $i=1; $i<5; $i++ ) {
        if ( exists ($h->{$i}) && defined($h->{$i}) && $h->{$i} ne '' ) {
          print FH $h->{$i},";";
          foreach ( (1,2,4,3) ) {
			#if ( exists ($h->{'statusz'}->{$_}) && defined($h->{'statusz'}->{$_}) && $h->{'statusz'}->{$_} ne '' ) {
				print FH $h->{'statusz'}->{$_},";";
			#} else {
				#print FH 0,";";
			#}
          }
        } else {
		  #print FH 0,";";
        }
      }
    }
  }
  print FH "\n";
  printf "\t%s\n","$k feldolgozása kész...";
}
printf "%s\r","Az 'Összesítõ' kiírása kész!\n";
close FH;

exit;

# %hash = (key => "Hello");
# $hash{key} = $val;	
# %third = (%first, %second)
# delete $hash{$key}; # This is safe
# @first{keys %second} = values %second
# $hash -> {key} = $val;
