#!/bin/bash
#Este programa convierte la salida del programa de Gigi en un archivo de tres columnas donde la columna 1 contiene el día del año y el año,
#la columna dos la hora en formato HH:MM:SS, la columna tres la hora en segundos y la columna 4 el valor de vTEC.
#Los datos deben encontrarse en una capeta, y se debe llamar al conversor desde el directorio inmediatamente superior.
#Version 2.1
#
#TO-DO: comprobar si el archivo que intentas convertir tiene el formato correcto, y si no es así dar un error.
#
#Joaquín Escayo Menéndez Febrero 2015
#changelog: Solucionado un error al utilizar directorios de más de 4 caracteres, añadidas opciones de debugging (si $debug=1)

echo "Hay que llamar gg2db con el argumento del directorio que quieras convertir"

FILES=./$1/*
debug=0
total=0

for f in $FILES
do
	file=$(basename $f)
	echo "Procesando el archivo $file"
	#Me quedo con el día del año y lo almaceno en dia
	dia=$(echo $file | eval sed 's/.......//' | eval sed 's/....$//')
	#almaceno el año del archivo:
	yearshort=$(echo $file | eval sed 's/...........//' | eval sed 's/.$//')
	if [ $yearshort -gt 60 ]; then
        	yearlong=$(echo "19$yearshort")
	else
        	yearlong=$(echo "20$yearshort")
	fi
	#formateo del archivo
	# Primer intento, sustituido para formatear la hora en 6 dígitos: 
	# awk '{print "'$dia'-'$yearlong'",int($12d/n/3600)":"$1/60%60":"$1%60,$2}' $f > $f.tmp
	awk '{printf "%s  %02d%c%02d%c%02d  %s  %s\n","'$dia'-'$yearlong'",$1/3600,":",$1/60%60,":",$1%60,$1,$2}' $f > $f.tmp
	#sobreescribo el archivo original:
	mv $f.tmp $f
	total=$((total+1))
	if [ $debug == 1 ]; then
		echo "Nombre del archivo: $file"
		echo "Día: $dia"
		echo "Año corto: $yearshort"
		echo "Año largo: $yearlong"
		echo "---------------------"
	fi
done

echo "Se ha procesador un total de $total archivos"
