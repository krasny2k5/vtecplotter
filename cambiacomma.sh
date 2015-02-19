#!/bin/bash

# Este programa cambia todas las comas de los archivos contenidos en un directorio por puntos.
# Llamar al programa utilizando como argumento el directorio donde se encuentran los archivo.
# En caso de no contener comas el archivo se queda igual.

#Joaquín Escayo 2015


directorio=$1/*
total=0

for f in $directorio
do
	echo "Procesando archivo $f"
	echo $f
	sed -e "s/\,/\./" $f > $f.tmp
	mv $f.tmp $f
	total=$((total+1))
done

echo "Procesados $total archivos"
