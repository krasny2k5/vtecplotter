#!/bin/bash
# Program to plot daily values of vTEC. Data files must be converted using gg2db.sh.
# Use the folder of datafiles as program argument.
# Joaquín Escayo Menéndez 2015

directory=$1/*
#muestra parámetros de debug si $debug=1, para cualquier otro valor no los saca
debug=0

#configuro el directorio de salida de los plots (working dir)
wdir=$1/daily

# Elimino el directorio donde voy a sacar los plots:
rm -r $wdir
# Creo el directorio
mkdir $wdir

#Comienza el procesador de arcchivos
for f in $directory
do
	echo "Processing file $f"
	file=$(basename $f)
	#Name of station
	station=$(echo $file | cut -c -4)
	#date of plot
	doy=$(echo $file | sed 's/.......//' | sed 's/....$//')
	yearshort=$(echo $file | eval sed 's/...........//' | eval sed 's/.$//')
        if [ $yearshort -gt 60 ]; then
                yearlong=$(echo "19$yearshort")
        else
                yearlong=$(echo "20$yearshort")
        fi

	#Debugging options
	if [ $debug == 1 ]; then
		echo "Procesando archivo: $file"
		echo "Nombre de la estación: $station"
		echo "DOY: $doy"
		echo "Directorio de trabajo: $wdir"
		echo "Año corto: $yearshort, Año largo: $yearlong"
	fi
	# Empiezo a configurar el archivo gnuplot.conf
	echo "set terminal png" > $wdir/gnuplot.conf
	echo "set xdata time" >> $wdir/gnuplot.conf
	echo 'set timefmt "%j-%Y %H:%M:%S"'>> $wdir/gnuplot.conf
	echo 'set format x "%H:%M"' >> $wdir/gnuplot.conf
	echo 'set xlabel "DOY: '$doy'"' >> $wdir/gnuplot.conf
	echo "set xtics 10800" >> $wdir/gnuplot.conf
	echo 'set ylabel "vTEC"' >> $wdir/gnuplot.conf
	echo 'set title "STATION: '$station' YEAR: '$yearlong'"' >> $wdir/gnuplot.conf
	echo 'set grid' >> $wdir/gnuplot.conf
	echo 'set output "'$wdir'/'$station'F0_'$doy'_'$yearlong'.png"' >> $wdir/gnuplot.conf
	echo 'plot "'$f'" using 1:4 with lines notitle' >> $wdir/gnuplot.conf
	#FIN ARCHIVO CONFIGURACION
	
	#ploteo el archivo
	cat $wdir/gnuplot.conf | gnuplot

	# Elimino el archivo gnuplot.conf para que este limpio
	rm $wdir/gnuplot.conf
done
