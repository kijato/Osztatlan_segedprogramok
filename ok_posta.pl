#!/usr/bin/perl
#
#	Copyright (c) Kis János Tamás, 2017. február 10.
#	VERZIOSZAM ='0.32 (2017. április 25.)'
#

use strict;
#use warnings;
#use Encoding;
#use Data::Dumper;
#use locale; # Ez kell(het) az ABC szerinti helyes rendezéshez.
$| = 1; # STDOUT buffer out;

#if ( @ARGV<1 ) { die "Hibás paraméterezés...!" }
if ( @ARGV!=1 ) { die <<END

A program a TAKAROS-Osztatlan moduljából származó, NKP-ra szűrt "vállalkozói"
adatszolgáltatás (azaz "név szerinti lekérdezés") eredményéből előállítja a
körlevelekhez felhasználható adatforrást.

Rendszer-követelmények:
------------------------
- Minimális Perl környezet;

Használat:
----------
[perl.exe] $0 adatfile.csv

Kimenet:
--------
Egy olyan CSV fájl, mely alkalmas a körlevelek adatforrásaként történő
felhasználásra. A kimeneti fájl neve a bemeneti fájl nevéből képződik,
a fájlnév '_$0' karakterekkel történő kiegészítésével.

END
}

my $riport_file = shift(@ARGV);
unless (-f $riport_file) { die "\nA(z) '$riport_file' nem létezik...!\n"; }
my ($sorszam,$ervenyes_hrsz,$ervenyes_hrszok,$ervenytelen_hrszok)=0;
my ($hrsz,$nev_cim)='';
my %adatok;

open FH,$riport_file;

print "A beolvasás indul: ".`time /t`."\n";
while(<FH>) {
	chomp;
	print "\tBeolvasott sorok száma: ".++$sorszam."\tétvényes HRSZ-ek száma: ".$ervenyes_hrszok."\térvénytelen HRSZ-ek száma: ".$ervenytelen_hrszok.".\r";
	my @sor = split(/;/);
	if($sor[0] == 1 && $sor[17] == 1) { # Ez a 'hrsz' sora és a státusz '1', azaz 'el nem indított eljárás'-ról van szó.
		$ervenyes_hrsz=1;
		$ervenyes_hrszok++;
		if($sor[3] =~ /^k/) {	$sor[4]="0".$sor[4]; } # Ha a fekvés 'k'-val kezdődik, akkor a hrsz elé beszúrunk egy '0'-át.
		if($sor[5] eq '') {
			$hrsz = $sor[2].";".$sor[3].";".$sor[4]; # Nincs alátörés a hrsz-ban...
		} else {
			$hrsz = $sor[2].";".$sor[3].";".$sor[4]."/".$sor[5]; # ...van alátörés a hrsz-ban.
		}
	} elsif ( $sor[0] == 1 && $sor[17] != 1)   {	$ervenyes_hrsz=0; $ervenytelen_hrszok++; $nev_cim=''; next; # Ez a 'hrsz' sora, de a státusz nem 'el nem indított'
	} elsif ( $ervenyes_hrsz && $sor[0] == 2 ) {	next; # A '2'-essel kezdődő sorok a kérelmezők adatait tartalmazzák.
	} elsif ( $ervenyes_hrsz && $sor[0] == 3 ) {	$nev_cim=$sor[1].";".$sor[2]; # A '3'-assal kezdődő sorok a tulajdonosok adatait tartalmazzák.
	} elsif ( $ervenyes_hrsz && $sor[0] == 4 ) {	next; # A '4'-essel kezdődő sorok a nem kérelmezők (visszamaradók) adatait tartalmazzák.
	} elsif ( !$ervenyes_hrsz )                {	next; # Ha a hrsz sora 'érvénytelen', új sort olvasunk be az adat-fájlból.
	} else                                     {	die "Ez meg miféle sor lehet...? ($sorszam.)"; # Ilyen eset elvileg nem lehet...
	}
	# push @{$adatok{$hrsz}},$nev_cim;
	push @{$adatok{$nev_cim}},$hrsz; # A 'nev_cim' kulcshoz tartozó tömbhöz hozzáadjuk a hrsz-t.
	$nev_cim=''; # Kinullázzuk a 'nev_cim'-et, hogy a következő sornál biztosan ne okozzon galibát...
}
close FH;
print "\n\nA beolvasás kész: ".`time /t`;

#print Dumper \%adatok;

print "\nA feldolgozás indul: ".`time /t`;
foreach my $kulcs ( keys %adatok ) { # Végigmegyünk a hash-en: fogjuk az egyik kulcsot...
	my %adat;
	foreach my $a ( @{$adatok{$kulcs}} ) { # ... végigmegyünk a kulccsal azonosított tömb elemein...
		$adat{$a}++; # ... megszámoljuk a tömb elemeinek előfordulásait. (Ebből több is lehet, mivel egy hrsz-en belül, egy embernek több bejegyzése is lehet.)
	}
	$adatok{$kulcs}= \%adat; # Az így készített HASH-sel felülírjuk az eredeti hash-nek az adott kulcshoz tartozó TÖMB-jét! (Azaz itt történik a 'varázslat', ami a többszörös hrsz-ekből egyet, pontosabban egy kulcsot csinál és mellékesen a kulcshoz tartozó érték az előfordulások számát adja vissza.)
}
print "\nA feldolgozás kész: ".`time /t`;

#print Dumper \%adatok;

print "\nA kiírás indul: ".`time /t`;
$riport_file=~s/(\.\w*)$//; # Töröljük a kiterjesztést, a '.'-tal együtt. (A '$1' tárolja az eredeti kiterjesztést...)
open FH,">$riport_file.$0$1" || die "$!\n"; # A szkript aktuális nevét ($0) és az eredeti kiterjesztést ($1) hozzáfűzzük a fájlnévhez.
binmode FH; # Ez biztosítja a 'nyers' írást a fájlba, enélkül a vezérlő karakterek nem minden esetben értelmeződnek megfelelően.
print FH "név;cím;hrszek".chr(13).chr(10);
foreach my $kulcs ( sort keys %adatok ) { # Végigmegyünk a rendezett kulcsokkal a hash-en...
	#if($kulcs=~/.*;.*;.*/) {next;}
	if($kulcs eq '' || !defined($kulcs)){next;} # .. ha nincs kulcs, vagy 'üres', akkor 'ugrunk'...

	#my $sor="$kulcs;\"";
	
	# Kulcs minta: "vezetéknév keresztnév;irsz település utca házszám."
	#               $1                    $2   $3        $4
	my $sor="$kulcs";
	$sor=~/(.+);(\d+)\s+(\w+)\s+(.+)/;
	$sor="$1;\"$3".chr(10).$4.chr(10)."$2\";\"";

	foreach my $a ( sort keys %{$adatok{$kulcs}} ) {
		$a=~s/;/ /g;
		$sor.=$a.chr(10);
	}
	chop($sor);
	print FH "$sor\"".chr(13).chr(10);
}
close FH;
print "\nA kiírás kész: ".`time /t`;


__END__

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
#   |  Kis János Tamás, E-mail: kijato@gmail.com, kjt@takarnet.hu    |
#   |                   Tel.: (76) 795-810                           |
#   ×----------------------------------------------------------------×
#   *================================================================×
#   |       A PROGRAM SZABADON TERJESZTHETÖ, HA A COPYRIGHT ÉS       |
#   |         AZ ENGEDÉLY SZÖVEGÉT MINDEN MÁSOLATON MEGŐRZIK.        |
#   ×================================================================*
# 
