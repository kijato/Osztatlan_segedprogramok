#!/usr/bin/perl
#
#   Copyright (c) Kis J�nos Tam�s, 2013. december 18.
#   VERZIOSZAM ='1.01 (2014. szeptember 10.)'
#   VERZIOSZAM ='1.20 (2015. febru�r 5.)'
#
#   A program szabad szoftver, b�rki tov�bbadhatja �s/vagy m�dos�thatja
#   a legfrissebb GNU General Public Licence felt�telei szerint, ahogy
#   azt a Free Software Foundation k�zli. A program m�dos�tott v�ltozatai,
#   a v�ltozatlan m�solatokkal megegyez� felt�telek alapj�n m�solhat�k
#   �s terjeszthet�k, ha a m�dos�tott v�ltozatot is, az ezzel az enge-
#   d�llyel megegyez� felt�telek szerint terjesztik. A leford�tott k�d
#   is a m�dos�tott v�ltozat kateg�ri�j�ba tartozik. Az �zleti c�l�
#   terjeszt�s NEM MEGENGEDETT. M�dos�t�s �s terjeszt�s el�tt a dolgok
#   naprak�szs�g�nek biztos�t�sa v�gett aj�nlott kapcsolatba l�pni a
#   szerz�vel. A program m�dos�t�sa eset�n, k�rlek juttatsd el a szerz�-
#   nek a m�dos�tott forr�sk�dot valamilyen form�ban, hogy a hasznos
#   v�ltoz�s mihamarabb beker�lj�n a szoftver "hivatalos" disztrib�ci�-
#   j�ba. A nyomtatott v�ltozat jobban n�z ki...   :-)
#   E programot (�n, a szerz�) azzal a rem�nnyel terjesztem, hogy hasznos
#   lesz, de MINDENF�LE GARANCIA V�LLAL�SA N�LK�L. A r�szletek a GNU
#   General Public Licence-ben tal�lhat�k. A programmal egy�tt kapnod
#   kellett egy m�solatot a GNU General Public Licence-b�l, ha nem kapt�l,
#   �rj a k�vetkez� c�mre:
#   Free Software Foundation, Inc. 675 Mass Ave, Cambridge, MA 02139, USA
#   A program szerz�je a k�vetkez� c�meken �rhet� el :
#   �----------------------------------------------------------------�
#   |  Kis J�nos Tam�s, E-mail: kjt@takarnet.hu, kijato@gmail.com    |
#   |                   Tel.: (76) 502-562                           |
#   �----------------------------------------------------------------�
#   *================================================================�
#   |       A PROGRAM SZABADON TERJESZTHET�, HA A COPYRIGHT �S       |
#   |         AZ ENGED�LY SZ�VEG�T MINDEN M�SOLATON MEG�RZIK.        |
#   �================================================================*
#
use strict;
#use warnings;
#use Encoding;
use Data::Dumper;
use locale; # Ez kell az ABC szerinti helyes rendez�shez.

if ( @ARGV<2 ) {
print <<'END';
	
	A program az osztatlan k�z�s tulajdon megsz�ntet�s�vel kapcsolatos,
	(1-2-3-4-es) jelent�s �ssze�ll�t�s�ra k�sz�lt.
	
	Els� param�terk�nt a megye nev�t, m�sodikk�nt (gyakorlatilag) egy f�jl
	list�t v�r, amit megadhatunk helyettes�t� karakterekkel is. A program
	felt�telezi, hogy a feldolgozand� CSV �llom�nyok (j�r�sonk�nt 4-4 darab)
	a k�vetkez� anal�gia szerint vannak elnevezve:
	1. A f�jln�vben az adatokat "_" jel v�lasztja el egym�st�l.
	2. Az 1. adat az "osztatlan" sz�.
	3. A 2. adat az elj�r�s t�pus�nak sorsz�ma.
	4. A 3. adat a h�nap k�dja.
	5. A 4. adat a j�r�s neve.
	Azaz pl: "osztatlan_1_2014-08_Baja.csv"
	
	Kimenetk�nt az �sszem�solt �llom�nyok  mellett elk�sz�ti az �sszes�t�t is
	melynek kijel�lt tartalm�t Ctrl+C & Ctrl+V-vel k�nnyen bem�solhatjuk az
	FM FF �ltal megadott Excel �llom�nyba.
	
	P�lda:
	------
	N�lam a j�r�sok �ltal megadott �llom�nyok egyetlen, a program melletti
	"adatok"/ k�nyt�rba vannak m�solva. �gy k�sz�tettem egy batch f�jlt
	("osztatlan_1-4_minden.bat" n�ven), a k�vetkez� tartalommal:
		chcp 1250
		set honap=2014-08
		perl osztatlan_1-4_minden.pl B�cs-Kiskun adatok\osztatlan_?_%HONAP%*.csv > %HONAP%_Napl�.log
		
	A batch f�jlt futtatva elk�sz�lnek a t�pusonk�nt �sszem�solt
	(2014-08_B�cs-Kiskun_*.csv) �llom�nyok �s az �sszes�t�
	(2014-08_B�cs-Kiskun_Osszesites.csv), plusz kapok egy napl�t amiben minden
	l�nyeges mozzanat �s t�rolt adat l�that�. H�napr�l-h�napra v�ltoztatni
	csup�n a batch f�jlon kell, a honap helyes megad�s�val, illetve a tov�bb�t�s
	el�tt a h�nap meg�r�sokat t�r�lni kell a f�jl nevekb�l.
	
END
exit;
}

my $megye = shift(@ARGV);

# Eredeti verzi�:
# my $fejlec_1_4 = "Sor t�pusa;Telep�l�s sorsz�m;K�zs�gn�v;Fekv�sn�v;Hrsz;Hrsz al�t�r�s;Ingatlan ter�lete;Sz�m�tott kiosztand� ter�let;K�relmez�k darabsz�ma;Tulajdonosok sz�ma;�llami tulajdon megjel�l�s;Perfeljegyz�s darabsz�ma;Terhek darabsz�ma;Helyhez k�thet� terhek darabsz�ma;Tul3 sz�vegek darabsz�ma;Sz�ljegyek darabsz�ma;Hivataln�v;Elj�r�s st�tusz\n";
# 2015-01-t�l alkalmazott verzi�:
my $fejlec_1_4 = "Sor t�pusa;Telep�l�s sorsz�m;K�zs�gn�v;Fekv�sn�v;Hrsz;Hrsz al�t�r�s;Ingatlan ter�lete;Sz�m�tott kiosztand� ter�let;K�relmez�k darabsz�ma;Tulajdonosok sz�ma;�llami tulajdon megjel�l�s;Perfeljegyz�s darabsz�ma;Terhek darabsz�ma;Helyhez k�thet� terhek darabsz�ma;Tul3 sz�vegek darabsz�ma;Sz�ljegyek darabsz�ma;Hivataln�v;Elj�r�s st�tusz;K�relmezett �ssz.tul.h�nyad sz�ml�l�;K�relmezett �ssz.tul.h�nyad nevez�\n";
#
# 2014-04-t�l alkalmazott verzi�:
my $feljec_osszesito = "Sorsz�m;J�r�si f�ldhivatal;A f�ldhivatal �ltal megkezdett �s befejezend� elj�r�sok (f�ldr�szletek);el nem ind�tott elj�r�sok (f�ldr�szletek);folyamatban l�v� elj�r�sok (f�ldr�szletek);megszakadt elj�r�sok (f�ldr�szletek);befejezett elj�r�sok (f�ldr�szletek);Soron k�v�l k�relem alapj�n megosztott f�ldr�szletek;el nem ind�tott elj�r�sok (f�ldr�szletek);folyamatban l�v� elj�r�sok (f�ldr�szletek);megszakadt elj�r�sok (f�ldr�szletek);befejezett elj�r�sok (f�ldr�szletek);NKP NKft. k�zrem�k�d�s�vel norm�l elj�r�s alapj�n megosztant� f�ldr�szletek;el nem ind�tott elj�r�sok (f�ldr�szletek);folyamatban l�v� elj�r�sok (f�ldr�szletek);megszakadt elj�r�sok (f�ldr�szletek);befejezett elj�r�sok (f�ldr�szletek);NKP NKft. k�zrem�k�d�s�vel a II. fejezet alapj�n megosztand� f�ldr�szletek;el nem ind�tott elj�r�sok (f�ldr�szletek);folyamatban l�v� elj�r�sok (f�ldr�szletek);megszakadt elj�r�sok (f�ldr�szletek);befejezett elj�r�sok (f�ldr�szletek);�sszes megosztand� f�ldr�szlet;el nem ind�tott elj�r�sok (f�ldr�szletek);folyamatban l�v� elj�r�sok (f�ldr�szletek);megszakadt elj�r�sok (f�ldr�szletek);befejezett elj�r�sok (f�ldr�szletek)\n";

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

print "Param�terek:'\n\tmegye:'$megye'\n\tszuro:'",join("\n\t\t",@dirs),"'\n\t";
#print '-' for (1..length(join("",@dirs))); print "\n";
print '-' for (1..70); print "\n";

my $adatok = ();
my (%korzetek) = ();
my $honap = "";

#
# V�gigmegy�nk a k�nyvt�rlist�n �s egy has�t�t�bl�ba (%korzetek) bet�ltj�k a f�jlnevekb�l kiszedett k�rzetneveket,
# illetve egy hash-referenci�ba (%$adatok) a f�jlok "rendezett" adatait.
#
foreach (@dirs) {
  if (-d) {
    print "'$_' -> Ez egy k�nyvt�r!\n"; next;
  } elsif (-f) {
    #print "'$_' -> Ez egy f�jl!\n";
    /osztatlan_(\d)_(\d{4}-\d{1,2})_(\D+)\.\D+$/;
    #print $1,"\t",$2,"\t",$3,"\n";
    my $tipus = $1;
    $honap = $2;
    my $korzet = $3;
    my (%statusz)=();
    $korzetek{$korzet.'_'.$tipus} = ucfirst($korzet);
    #$adatok->{ucfirst($korzet)} = [];
    # A f�jlokat egyenk�nt megnyitjuk, megsz�moljuk a sorokat �s megjegyezz�k a tartalmat.
      open FH,$_;
      my ($sorok,$teljesfajl)=0;
      while(<FH>) {
	    if (/^\D+/) { next; }
	    $sorok++;
	    #/;(\w+);(\d+)$/;
	    #if ($korzet!~/.+$1.*/x) { die "T�ves k�rzetn�v...? [$korzet]\n$sorok : $_\n"; }
	    /;(\d+);\d*;\d*;?$/;
	    $statusz{$1}++;
	    $teljesfajl.=$_;
      }
      close FH;
    push @$adatok, {'korzet'=>ucfirst($korzet), $tipus=>$sorok, 'adat'=>$teljesfajl, 'statusz'=>\%statusz};
  } else {
    die "Se nem k�nyvt�r, se nem f�jl... Akkor ez ($_) mi...?\n"
  }
}
# A teljes beolvasott strukt�ra list�z�sa:
print Dumper $adatok;

#
# A k�rzetnevek kigy�jt�se �n�ll� t�mbbe (@korzetek):
#
my (@korzetek) = ();
%korzetek = reverse(%korzetek);
while ( my ($key, $value) = each %korzetek ) {
	#print "'$key'\t'$value'\n";
	push(@korzetek,$key);
} #print Dumper \@korzetek;

#
# �sszem�soljuk a megfelel� adatokat 1-1 CSV f�jlba:
#
my @minden=();
foreach (@{$adatok}) {
  for (my $i=1; $i<5; $i++) {
    if ( exists($_->{$i}) && defined($_->{'adat'}) ) {
      $minden[$i] .= $_->{'adat'};
      $_->{'adat'}=''; # Kinull�zzuk az "adat-mez�t" hogy a Dump olvashat�bb legyen...
    }
  }
}
# A teljes beolvasott strukt�ra list�z�sa:
print Dumper @minden;

for (my $i=1; $i<5; $i++) {
  open FH,">".$honap."_".$megye."_$i.csv" || die "$!\n";
  print FH $fejlec_1_4;
  if ( defined($minden[$i]) ) { print FH $minden[$i]; }
  close FH;
  printf "\t%s\n","Az $i. t�pus� f�jl ki�r�sa k�sz!";
}
printf "%s\r","Az '1-4' f�jlok ki�r�sa k�sz!\n";
# A teljes beolvasott strukt�ra list�z�sa:
#print Dumper $adatok;

#
# Elk�sz�tj�k az �sszes�t�t:
#
print "\nAz '�sszes�t�' elk�sz�t�se indul...\n";
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
  printf "\t%s\n","$k feldolgoz�sa k�sz...";
}
printf "%s\r","Az '�sszes�t�' ki�r�sa k�sz!\n";
close FH;

exit;

# %hash = (key => "Hello");
# $hash{key} = $val;	
# %third = (%first, %second)
# delete $hash{$key}; # This is safe
# @first{keys %second} = values %second
# $hash -> {key} = $val;
