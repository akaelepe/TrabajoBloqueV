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
