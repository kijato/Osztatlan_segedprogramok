#!/usr/bin/perl
#
#	Copyright (c) Kis J�nos Tam�s, 2017. febru�r 10.
#	VERZIOSZAM ='0.32 (2017. �prilis 25.)'
#

use strict;
#use warnings;
#use Encoding;
use Data::Dumper;
#use locale; # Ez kell(het) az ABC szerinti helyes rendez�shez.
$| = 1; # STDOUT buffer out;

#if ( @ARGV<1 ) { die "Hib�s param�terez�s...!" }
if ( @ARGV!=1 ) { die <<END

A program a TAKAROS-Osztatlan modulj�b�l sz�rmaz�, NKP-ra sz�rt "v�llalkoz�i"
adatszolg�ltat�s (azaz "n�v szerinti lek�rdez�s") eredm�ny�b�l el��ll�tja a
k�rlevelekhez felhaszn�lhat� adatforr�st.

Rendszer-k�vetelm�nyek:
------------------------
- Minim�lis Perl k�rnyezet;

Haszn�lat:
----------
[perl.exe] $0 adatfile.csv

Kimenet:
--------
Egy olyan CSV f�jl, mely alkalmas a k�rlevelek adatforr�sak�nt t�rt�n�
felhaszn�l�sra. A kimeneti f�jl neve a bemeneti f�jl nev�b�l k�pz�dik,
a f�jln�v '_$0' karakterekkel t�rt�n� kieg�sz�t�s�vel.

END
}

my $riport_file = shift(@ARGV);
unless (-f $riport_file) { die "\nA(z) '$riport_file' nem l�tezik...!\n"; }
my ($sorszam,$ervenyes_hrsz,$ervenyes_hrszok,$ervenytelen_hrszok)=0;
my ($hrsz,$nev_cim)='';
my %adatok;

open FH,$riport_file;

print "A beolvas�s indul: ".`time /t`."\n";
while(<FH>) {
	chomp;
	print "\tBeolvasott sorok sz�ma: ".++$sorszam."\t�tv�nyes HRSZ-ek sz�ma: ".$ervenyes_hrszok."\t�rv�nytelen HRSZ-ek sz�ma: ".$ervenytelen_hrszok.".\r";
	my @sor = split(/;/);
	if($sor[0] == 1 && $sor[17] == 1) { # Ez a 'hrsz' sora �s a st�tusz '1', azaz 'el nem ind�tott elj�r�s'-r�l van sz�.
		$ervenyes_hrsz=1;
		$ervenyes_hrszok++;
		if($sor[3] =~ /^k/) {	$sor[4]="0".$sor[4]; } # Ha a fekv�s 'k'-val kezd�dik, akkor a hrsz el� besz�runk egy '0'-�t.
		if($sor[5] eq '') {
			$hrsz = $sor[2].";".$sor[3].";".$sor[4]; # Nincs al�t�r�s a hrsz-ban...
		} else {
			$hrsz = $sor[2].";".$sor[3].";".$sor[4]."/".$sor[5]; # ...van al�t�r�s a hrsz-ban.
		}
	} elsif ( $sor[0] == 1 && $sor[17] != 1)   {	$ervenyes_hrsz=0; $ervenytelen_hrszok++; $nev_cim=''; next; # Ez a 'hrsz' sora, de a st�tusz nem 'el nem ind�tott'
	} elsif ( $ervenyes_hrsz && $sor[0] == 2 ) {	next; # A '2'-essel kezd�d� sorok a k�relmez�k adatait tartalmazz�k.
	} elsif ( $ervenyes_hrsz && $sor[0] == 3 ) {	$nev_cim=$sor[1].";".$sor[2]; # A '3'-assal kezd�d� sorok a tulajdonosok adatait tartalmazz�k.
	} elsif ( $ervenyes_hrsz && $sor[0] == 4 ) {	next; # A '4'-essel kezd�d� sorok a nem k�relmez�k (visszamarad�k) adatait tartalmazz�k.
	} elsif ( !$ervenyes_hrsz )                {	next; # Ha a hrsz sora '�rv�nytelen', �j sort olvasunk be az adat-f�jlb�l.
	} else                                     {	die "Ez meg mif�le sor lehet...? ($sorszam.)"; # Ilyen eset elvileg nem lehet...
	}
	# push @{$adatok{$hrsz}},$nev_cim;
	push @{$adatok{$nev_cim}},$hrsz; # A 'nev_cim' kulcshoz tartoz� t�mbh�z hozz�adjuk a hrsz-t.
	$nev_cim=''; # Kinull�zzuk a 'nev_cim'-et, hogy a k�vetkez� sorn�l biztosan ne okozzon galib�t...
}
close FH;
print "\n\nA beolvas�s k�sz: ".`time /t`;

#print Dumper \%adatok;

print "\nA feldolgoz�s indul: ".`time /t`;
foreach my $kulcs ( keys %adatok ) { # V�gigmegy�nk a hash-en: fogjuk az egyik kulcsot...
	my %adat;
	foreach my $a ( @{$adatok{$kulcs}} ) { # ... v�gigmegy�nk a kulccsal azonos�tott t�mb elemein...
		$adat{$a}++; # ... megsz�moljuk a t�mb elemeinek el�fordul�sait. (Ebb�l t�bb is lehet, mivel egy hrsz-en bel�l, egy embernek t�bb bejegyz�se is lehet.)
	}
	$adatok{$kulcs}= \%adat; # Az �gy k�sz�tett HASH-sel fel�l�rjuk az eredeti hash-nek az adott kulcshoz tartoz� T�MB-j�t! (Azaz itt t�rt�nik a 'var�zslat', ami a t�bbsz�r�s hrsz-ekb�l egyet, pontosabban egy kulcsot csin�l �s mell�kesen a kulcshoz tartoz� �rt�k az el�fordul�sok sz�m�t adja vissza.)
}
print "\nA feldolgoz�s k�sz: ".`time /t`;

#print Dumper \%adatok;

print "\nA ki�r�s indul: ".`time /t`;
$riport_file=~s/(\.\w*)$//; # T�r�lj�k a kiterjeszt�st, a '.'-tal egy�tt. (A '$1' t�rolja az eredeti kiterjeszt�st...)
open FH,">$riport_file.$0$1" || die "$!\n"; # A szkript aktu�lis nev�t ($0) �s az eredeti kiterjeszt�st ($1) hozz�f�zz�k a f�jln�vhez.
binmode FH; # Ez biztos�tja a 'nyers' �r�st a f�jlba, en�lk�l a vez�rl� karakterek nem minden esetben �rtelmez�dnek megfelel�en.
print FH "n�v;c�m;hrszek".chr(13).chr(10);
foreach my $kulcs ( sort keys %adatok ) { # V�gigmegy�nk a rendezett kulcsokkal a hash-en...
	#if($kulcs=~/.*;.*;.*/) {next;}
	if($kulcs eq '' || !defined($kulcs)){next;} # .. ha nincs kulcs, vagy '�res', akkor 'ugrunk'...

	#my $sor="$kulcs;\"";
	
	# Kulcs minta: "vezet�kn�v keresztn�v;irsz telep�l�s utca h�zsz�m."
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
print "\nA ki�r�s k�sz: ".`time /t`;


__END__

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
#   |  Kis J�nos Tam�s, E-mail: kijato@gmail.com, kjt@takarnet.hu    |
#   |                   Tel.: (76) 795-810                           |
#   �----------------------------------------------------------------�
#   *================================================================�
#   |       A PROGRAM SZABADON TERJESZTHET�, HA A COPYRIGHT �S       |
#   |         AZ ENGED�LY SZ�VEG�T MINDEN M�SOLATON MEG�RZIK.        |
#   �================================================================*
# 