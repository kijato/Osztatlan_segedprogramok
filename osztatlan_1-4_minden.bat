chcp 1250

rem set honap=2016-12
call osztatlan_1-4_minden.conf.bat

rem osztatlan_1-4_minden.pl B�cs-Kiskun adatok\osztatlan_?_%HONAP%*.csv
rem osztatlan_1-4_minden.pl B�cs-Kiskun adatok\osztatlan_?_%HONAP%*.csv > %0.log
perl.exe osztatlan_1-4_minden.pl B�cs-Kiskun adatok\osztatlan_?_%HONAP%*.csv > %HONAP%_Napl�.log

rem zip -j B�cs-Kiskun_%HONAP%.zip adatok\%HONAP%_*_id�k�vet�si.csv
rem zip B�cs-Kiskun_%HONAP%.zip %HONAP%_B�cs-Kiskun_?.csv
rem zip B�cs-Kiskun_%HONAP%.zip %HONAP%_B�cs-Kiskun_Osszesites.csv
rem zip B�cs-Kiskun_%HONAP%.zip %HONAP%_B�cs-Kiskun_Osszesites.xls
rem zip B�cs-Kiskun_%HONAP%.zip %HONAP%_Napl�.log

set tempdir=%HONAP%_temp
mkdir %TEMPDIR%
copy adatok\%HONAP%_*_id�k�vet�si.csv	%TEMPDIR%
move %HONAP%_B�cs-Kiskun_?.csv			%TEMPDIR%
move %HONAP%_B�cs-Kiskun_Osszesites.csv	%TEMPDIR%
move %HONAP%_Napl�.log					%TEMPDIR%
rem rename ...
powershell -Command "dir %TEMPDIR% | rename-item -newname { $_.name -replace \"%HONAP%_\",\"\" }"
zip -jm B�cs-Kiskun_%HONAP%.zip %TEMPDIR%\*
rd %TEMPDIR%

pause
