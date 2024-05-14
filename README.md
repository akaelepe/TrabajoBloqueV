## Trabajo Bloque V
#### Trabajo realizado por Javier Barrero, Jose María Jaén y Alejandro Lamprea Pérez.
<img src="https://cdn-icons-png.flaticon.com/512/2037/2037149.png" style="width: 25px; height: 25px;"/> Índice 
1. [Ejercicio 1](#ComprobarApache.png)

<img src="https://images.emojiterra.com/google/noto-emoji/unicode-15/color/512px/27a1.png" style="width: 18px; height: 18px;"/>     **Ejercicio 1**
#### *Enunciado*  
`Realiza un script llamado comprobarApache.sh, que compruebe cada minuto si el servicio apache2 está activo (running).  
Si está parado, entonces:  
1.- Introduce una línea: “Error-Apache: Fecha y hora actual” en /root/ApacheError.tmp, donde FechaActual, representa día, mes, año, hora y minuto.  
2.- Reinicia el servicio apache2  
Para comprobarlo, para el servicio. Ejecuta el script en segundo plano y observa si lo reinicia y crea el archivo.  
3.- Además del script, crea una tarea programada, de forma que ese script se ejecute cada 6 horas, todos los días. Y si el ordenador está apagado, se debe ejecutar la próxima vez que se inicie, transcurrido cinco minutos.`  

#### *Desarrollo del script*  
*Trabajando en este script, concretamente en la función "comprobarApache" nos dimos cuenta que a la hora de redireccionar el error a "/root/ApacheError.tmp" nos denegaría el permiso ya que necesitamos ser root. Decidimos añadir la típica función de "comprobarRoot" para hacerle saber al usuario final que debe logearse como root.*

#### *Bloque del script*
```
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
ComprobarApache.
```
#### *Screenshots*
[Pantallazo que muestra el script en gedit](ComprobarApache.png)  
[Pantallazo del crontab con la tarea programada del script](crontab_comprobarApache.png)  
[Pantallazo del "comprobarApache.sh" funcionando](ej1_funcionando.png)  

