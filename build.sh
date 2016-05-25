#!/bin/bash
echo Building OpenPLC environment:

echo [MATIEC COMPILER]
cd matiec_src
autoreconf -i
./configure
make

echo [LADDER]
cd ..
cp ./matiec_src/iec2c ./
./iec2c ./st_files/blank_program.st
mv -f POUS.c POUS.h LOCATED_VARIABLES.h VARIABLES.csv Config0.c Config0.h Res0.c ./core/

echo [GLUE GENERATOR]
cd glue_generator_src
g++ glue_generator.cpp -o glue_generator
cd ..
cp ./glue_generator_src/glue_generator ./core/glue_generator

cd core
rm -f ./hardware_layer.cpp
rm -f ../build_core.sh
echo The OpenPLC needs a driver to be able to control physical or virtual hardware.
echo Please select the driver you would like to use:
OPTIONS="Blank Fischertechnik RaspberryPi Simulink Unipi"
select opt in $OPTIONS; do
	if [ "$opt" = "Blank" ]; then
		cp ./hardware_layers/blank.cpp ./hardware_layer.cpp
		cp ./core_builders/build_linux.sh ../build_core.sh
		echo [OPENPLC]
		cd ..
		./build_core.sh
		exit
	elif [ "$opt" = "Fischertechnik" ]; then
		cp ./hardware_layers/fischertechnik.cpp ./hardware_layer.cpp
		cp ./core_builders/build_rpi.sh ../build_core.sh
		echo [OPENPLC]
		cd ..
		./build_core.sh
		exit
	elif [ "$opt" = "RaspberryPi" ]; then
		cp ./hardware_layers/raspberrypi.cpp ./hardware_layer.cpp
		cp ./core_builders/build_rpi.sh ../build_core.sh
		echo [OPENPLC]
		cd ..
		./build_core.sh
		exit
	elif [ "$opt" = "Simulink" ]; then
		cp ./hardware_layers/simulink.cpp ./hardware_layer.cpp
		cp ./core_builders/build_linux.sh ../build_core.sh
		echo [OPENPLC]
		cd ..
		./build_core.sh
		exit
	elif [ "$opt" = "Unipi" ]; then
		cp ./hardware_layers/unipi.cpp ./hardware_layer.cpp
		cp ./core_builders/build_rpi.sh ../build_core.sh
		echo [OPENPLC]
		cd ..
		./build_core.sh
		exit
	else
		#clear
		echo bad option
	fi
done