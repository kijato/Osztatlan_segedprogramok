chcp 1250

rem set honap=2016-12
call osztatlan_1-4_minden.conf.bat

rem osztatlan_1-4_minden.pl Bács-Kiskun adatok\osztatlan_?_%HONAP%*.csv
rem osztatlan_1-4_minden.pl Bács-Kiskun adatok\osztatlan_?_%HONAP%*.csv > %0.log
perl.exe osztatlan_1-4_minden.pl Bács-Kiskun adatok\osztatlan_?_%HONAP%*.csv > %HONAP%_Napló.log

rem zip -j Bács-Kiskun_%HONAP%.zip adatok\%HONAP%_*_idõkövetési.csv
rem zip Bács-Kiskun_%HONAP%.zip %HONAP%_Bács-Kiskun_?.csv
rem zip Bács-Kiskun_%HONAP%.zip %HONAP%_Bács-Kiskun_Osszesites.csv
rem zip Bács-Kiskun_%HONAP%.zip %HONAP%_Bács-Kiskun_Osszesites.xls
rem zip Bács-Kiskun_%HONAP%.zip %HONAP%_Napló.log

set tempdir=%HONAP%_temp
mkdir %TEMPDIR%
copy adatok\%HONAP%_*_idõkövetési.csv	%TEMPDIR%
move %HONAP%_Bács-Kiskun_?.csv			%TEMPDIR%
move %HONAP%_Bács-Kiskun_Osszesites.csv	%TEMPDIR%
move %HONAP%_Napló.log					%TEMPDIR%
rem rename ...
powershell -Command "dir %TEMPDIR% | rename-item -newname { $_.name -replace \"%HONAP%_\",\"\" }"
zip -jm Bács-Kiskun_%HONAP%.zip %TEMPDIR%\*
rd %TEMPDIR%

pause
