# Trabajo Bloque V
Trabajo de scripts en bash del bloque V

Ejercicio 1
Realiza un script llamado comprobarApache.sh, que compruebe cada minuto si el servicio apache2 está activo (running).
Si está parado, entonces:
1.- Introduce una línea: “Error-Apache: Fecha y hora actual” en /root/ApacheError.tmp, donde FechaActual, representa día, mes, año, hora y minuto.
2.- Reinicia el servicio apache2
Para comprobarlo, para el servicio. Ejecuta el script en segundo plano y observa si lo reinicia y crea el archivo.
3.- Además del script, crea una tarea programada, de forma que ese script se ejecute cada 6 horas, todos los días. Y si el ordenador está apagado, se debe ejecutar la próxima vez que se inicie, transcurrido cinco minutos.


#!/bin/bash
#Autor: Jose Maria Jaén, Alejandro Lamprea, Javier Barrero
#Versión: 1.0
#Fecha:26-04-24
#Descripción: Este script comprueba cada minuto si el servidor apache se encuentra en funcionamiento.
#Parámetros/Variables
informe="estado.txt"
fecha=$(date +%d-%m-%Y-%H-%M)

#Funciones

comprobarRoot ()
{
if [ `id -u` != 0 ]
then 
	echo "No estás como administrador"
	exit
fi
}
ComprobarApache ()
{
systemctl status apache2 > $informe
cat $informe | grep -w "running" > /dev/null 2>&1
if [ $? -ne 0 ];
	then
	 	echo "Error-Apache: $fecha" > /root/ApacheError.tmp
	 	systemctl restart apache2
fi
 }

#Bloque principal
comprobarRoot
ComprobarApache 
