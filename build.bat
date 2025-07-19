::set /p i= Type the project name: 
set i=main
mkdir temp
cd asm
rgbasm -o "../temp/%i%.o" "%i%.asm"
cd ..
rgblink -o   "%i%.gb" "temp/%i%.o"
rgbfix -v -p 0xFF "%i%.gb"
rgblink -n "%i%.sym" "temp/%i%.o"
rmdir "temp" /s /q