@echo off
set "src=.\fix_mingw_patch\thirdparty\CMakeLists.txt"
set "dest=.\thirdparty\CMakeLists.txt"
rem 
xcopy "%src%" "%dest%" /y

mkdir build
cd build
cmake ..