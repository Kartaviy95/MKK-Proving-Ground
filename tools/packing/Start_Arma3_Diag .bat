@echo off
rem _______________________________
rem [31st]Cookie & [RON]Kartaviy
rem _______________________________
rem MKK Git "SolidGames"
rem _______________________________

rem Устанавливаем пути к инструментам и директориям
set "build_addons=C:\Users\kt95\Desktop\packing"
set "arma3=F:\Steam\steamapps\common\Arma 3"

rem Убедимся, что директории существуют
if not exist "%build_addons%" (
    echo Ошибка: Директория для инструментов упаковки не найдена: %build_addons%
    exit /b 1
)

if not exist "%arma3%" (
    echo Ошибка: Директория игры Arma 3 не найдена: %arma3%
    exit /b 1
)

rem Устанавливаем дополнения
set MODS="F:\Steam\steamapps\common\Arma 3\!Workshop\@RHSAFRF;"
set MODS1="F:\Steam\steamapps\common\Arma 3\!Workshop\@RHSGREF;"
set MODS2="F:\Steam\steamapps\common\Arma 3\!Workshop\@RHSSAF;"
set MODS3="F:\Steam\steamapps\common\Arma 3\!Workshop\@RHSUSAF;"
set MODS4="F:\Steam\steamapps\common\Arma 3\!Workshop\@CUP Terrains - Core;"
set MODS5="F:\Arma3\SolidGames_dev\@sg_core;"
set MODS6="F:\Steam\steamapps\common\Arma 3\SolidGames\@sg_islands;"
set MODS7="F:\Arma3\SolidGames_dev\@sg_islands_dev;"
set MODS8="F:\Steam\steamapps\common\Arma 3\@GIT_alpha;"
set MODS9="F:\Arma3\SolidGames_dev\@sg_connect;"
set MODS10="F:\Arma3\SolidGames_dev\@sg_test;"
set MODS11="F:\Arma3\SolidGames_dev\@sg_server_test;"

rem Запуск сборки дополнений с проверкой на ошибки
@start "" /W "%build_addons%\new_build.py"
if errorlevel 1 (
    echo Ошибка: Сборка дополнений завершилась неудачей.
    exit /b 1
)

rem Запуск игры Arma 3 с параметрами
start "" "%arma3%\arma3diag_x64.exe" -name=[RON]Kartaviy -mallock=mimalloc_v212 -noPause -skipintro -noSplash -debug -world=empty -hugePages -mod=%MODS% -mod=%MODS1% -mod=%MODS2% -mod=%MODS3% -mod=%MODS4% -mod=%MODS5% -mod=%MODS6% -mod=%MODS7% -mod=%MODS8% -mod=%MODS9% -mod=%MODS10% -mod=%MODS11%

rem Завершение работы скрипта
exit /b 0