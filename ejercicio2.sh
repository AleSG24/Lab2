#!/bin/bash

nombre_archivo=""
read -p "Ingrese el nombre del documento log (al final del nombre escriba .log):"  nombre_archivo

touch "$nombre_archivo"

process=$1

#Excecute process
$process &

#Obtains PID
pid=$!


#Adds headear 
echo "Tiempo | %CPU | %Memoria" > "$nombre_archivo"

#Loop to register
while true; do
    if ps -p "$pid" > /dev/null; then
        echo "$(ps -p "$pid" -o time,%cpu,%mem --no-headers)" >> "$nombre_archivo"
        sleep 1
    else
        gnuplot <<EOF 
	set terminal png
        set output 'grafico_memoria.png'
        set title "Memoria vs Tiempo"
        set xlabel "Tiempo"
        set ylabel "Uso de Memoria"
        set xdata time
        set timefmt "%H:%M:%S"
        set format x "%H:%M:%S"
        plot "$nombre_archivo" using 1:3 with lines title "Uso de Memoria"
EOF
	gnuplot <<EOF 
        set terminal png
        set output 'grafico_cpu.png'
        set title "CPU vs Tiempo"
        set xlabel "Tiempo"
        set ylabel "Uso de CPU"
        set xdata time
        set timefmt "%H:%M:%S"
        set format x "%H:%M:%S"
        plot "$nombre_archivo" using 1:2 with lines title "Uso de CPU"
EOF


        echo "Proceso finalizado"
        break
    fi
done



