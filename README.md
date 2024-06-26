![MasterHead](https://user-images.githubusercontent.com/74038190/213910845-af37a709-8995-40d6-be59-724526e3c3d7.gif)

# <p align="center">*Trabajo Bloque 5*</p>
### <p align="left">*Creación de scripts intermedios en Debian/Ubuntu*<p>
En este proyecto trabajaremos detectando problemas de rendimiento monitorizando el sistema con las herramientas adecuadas y documentando el procedimiento

### *Herramientas usadas*
![Static Badge](https://img.shields.io/badge/Virtual-Box-blue?style=plastic)  ![Static Badge](https://img.shields.io/badge/Scripting-Bash-green?style=plastic)  ![Static Badge](https://img.shields.io/badge/Github-red?style=plastic) ![Static Badge](https://img.shields.io/badge/Markdown-Language-yellow?style=plastic)











<h5 align="right"> Trabajo realizado por Javier Barrero,  Alejandro Lamprea y Jose María Jaén. </h5>
<br>
<br>
<br>
<br>
<br>


<img src="https://cdn-icons-png.flaticon.com/512/2037/2037149.png" style="width: 25px; height: 25px;"/> Índice  
 <br>
 ![](https://img.shields.io/badge/ejercicio1-blue?style=for-the-badge)  
 > Enunciado.    
 > Problemas/Soluciones.    
 > Bloque de script.    
 > Screenshots.

![](https://img.shields.io/badge/ejercicio2-red?style=for-the-badge)  
 > Enunciado.    
 > Problemas/Soluciones.    
 > Bloque de script.    
 > Screenshots.

![](https://img.shields.io/badge/ejercicio3-yellow?style=for-the-badge)
 > Enunciado.    
 > Problemas/Soluciones.    
 > Bloque de script.    
 > Screenshots.

![](https://img.shields.io/badge/ejercicio4-orange?style=for-the-badge)  
 > Enunciado.    
 > Problemas/Soluciones.    
 > Bloque de script.    
 > Screenshots.

![](https://img.shields.io/badge/ejercicio5-green?style=for-the-badge)  
 > Enunciado.    
 > Problemas/Soluciones.    
 > Bloque de script.    
 > Screenshots.




<br>
<br>
<br>
<br>



```
__________.__                                    .___          
\______   \  |   ____   ________ __   ____     __| _/____      
 |    |  _/  |  /  _ \ / ____/  |  \_/ __ \   / __ |/ __ \     
 |    |   \  |_(  <_> < <_|  |  |  /\  ___/  / /_/ \  ___/     
 |______  /____/\____/ \__   |____/  \___  > \____ |\___  >    
        \/                |__|           \/       \/    \/     
             __                     .__       .__              
   ____     |__| ___________   ____ |__| ____ |__| ____  ______
 _/ __ \    |  |/ __ \_  __ \_/ ___\|  |/ ___\|  |/  _ \/  ___/
 \  ___/    |  \  ___/|  | \/\  \___|  \  \___|  (  <_> )___ \ 
  \___  >\__|  |\___  >__|    \___  >__|\___  >__|\____/____  >
      \/\______|    \/            \/        \/              \/
```
<br>


![](https://img.shields.io/badge/ejercicio1-blue?style=for-the-badge)

#### *Enunciado*
`Realiza un script llamado comprobarApache.sh, que compruebe cada minuto si el servicio apache2 está activo (running).`    
`Si está parado, entonces:`    
`1.- Introduce una línea: “Error-Apache: Fecha y hora actual” en /root/ApacheError.tmp, donde FechaActual, representa día, mes, año, hora y minuto.`    
`2.- Reinicia el servicio apache2`  
`Para comprobarlo, para el servicio. Ejecuta el script en segundo plano y observa si lo reinicia y crea el archivo.`   
`3.- Además del script, crea una tarea programada, de forma que ese script se ejecute cada 6 horas, todos los días. Y si el ordenador está apagado, se debe ejecutar la próxima vez que se inicie, transcurrido cinco minutos.`  
<br>
<br>

> [!NOTE]
> *Trabajando en este script, concretamente en la función "comprobarApache" nos dimos cuenta que a la hora de redireccionar el error a "/root/ApacheError.tmp" nos denegaría el permiso ya que necesitamos ser root. Decidimos añadir la típica función de "comprobarRoot" para hacerle saber al usuario final que debe logearse como root. Después nos dimos cuenta que también hacía falta que el script se iniciase 5 minutos despues de arrancar el sistema. Como solución introdujimos el script en /etc/rc.local para que así funcionase correctamente.*
<br>
<br>


#### *Bloque del script*  
<details>
	<sumary>Script 1</sumary>

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

#Esta función comprueba si el usuario está en modo root.
comprobarRoot ()
{
if [ id -u != 0 ]
then
    echo "No estás como administrador"
    exit
fi
}

#Esta función realiza un analisis de estado de apache2, dicho analisis se redirigirá a un informe que previamente hemos creado llamado estado.txt. Posteriormente se leera el informe y se buscará dentro de este la palabra "running". Terminaremos comprobando si el script se ha ejecutado bien ( es decir igual a 0) o se ha ejecutado mal ( es decir diferente a 0).
#También hemos aplicado un "sleep" al final para que el script espere unos 60 segundos antes de ejecutarse de nuevo. Esto hace que el script compruebe el estado cada minutos.
ComprobarApache ()
{
while true
do
    systemctl status apache2 > $informe
    cat $informe | grep -w "running" > /dev/null 2>&1
   	 if [ $? -ne 0 ];
   		 then
        		 echo "Error-Apache: $fecha" > /root/ApacheError.tmp
        		 systemctl restart apache2
         fi
         sleep 60
done
}
#Bloque principal
comprobarRoot

ComprobarApache &

```
</details>

<br>
<br>

#### *Screenshots*
[Pantallazo que muestra el script en gedit](imagenes/ComprobarApache_final.png)  
[Pantallazo del crontab con la tarea programada del script](imagenes/crontab_comprobarApache.png)  
[Pantallazo de como hacer que el script se inicie al arrancar el sistema 1](imagenes/iniciar_script_al_encender_1.png)  
[Pantallazo de como hacer que el script se inicie al arrancar el sistema 2](imagenes/iniciar_script_al_encender_2.png)  
[Pantallazo del "comprobarApache.sh" funcionando](imagenes/ej1_funcionando.png)  

<br>
<br>
<br>
<br>
<br>


![](https://img.shields.io/badge/ejercicio2-red?style=for-the-badge)
#### *Enunciado*  
`Realiza un script llamado usuariosBloqueados.sh, que nos muestre un menú:`  
`1.- Usuarios Bloqueados`      
`2.- Bloquear un usuario`     
`3.- Desbloquear usuario`  
`4.- Cerrar sesión usuario`  
`5.- Salir`  
`Cada opción del menú corresponde con una función.`  
`UsuariosBloqueados → nos muestra en pantalla los usuarios (uid>1000 y <2000) que tengan la cuenta bloqueada.`  
`BloquearUsuario → Nos pregunta el nombre de un usuario y lo bloqueamos.`  
`DesbloquearUsuario → Nos pregunta el nombre de un usuario y lo desbloqueamos.`  
`CerrarSesion → Nos pregunta el nombre de un usuario, y si el usuario lleva más de 30 minutos (1800 seg) sin actividad, se le cierra la sesión.`
  


<br>
<br>

> [!NOTE]
> *En este script estuvimos bastante atascados en la función "UsuariosBloqueados", ya que no se nos ocurría la forma en la que podiamos obtener los usuarios con UID entre 1000 y 2000 a la vez que la condición de que estuviesen bloqueados. Al final recurrimos a redirigir los usuarios con UID entre 1000 y 2000 a un archivo, posteriormente hemos utilizado un "passwd -S -a" para comprobar el estado de las contraseñas de todos los usuarios del sistema.*

<br>
<br>
  
#### *Bloque del script*  
<details>
	<sumary>Script 2</sumary>

```  
#!/bin/bash
#Autor: Jose María Jaén, Alejandro Lamprea, Javier Barrero
#Versión: 1.0
#Fecha: 16/05/24
#Descripción: Este script nos permite elegir desde un menú diferentes opciones como bloquear usuarios, mostrar usuarios bloqueados y desbloquear usuarios.
#Parámetros/Variables
usuarios="/home/javi/TRABAJOSCRIPTS/usuarios.txt"
usuariosBloqueados="/home/javi/TRABAJOSCRIPTS/bloqueados.txt"



#Funciones
menu ()
{
    echo ""
    echo "Servidor de usuarios:"
    echo "_____________________________________________"
    echo "1.- Usuarios Bloqueados."
    echo "2.- Bloquear un usuario."
    echo "3.- Desbloquear usuario."
    echo "4.- Cerrar sesión usuario."
    echo "5.- Salir."
    read -p "Pulse un número: " opcion

case $opcion in
1)
    UsuariosBloqueados
    ;;
2)
    BloquearUsuario
    ;;
3)
    DesbloquearUsuario
    ;;
4)
    CerrarSesion
    ;;

5)
    exit
    ;;
*)
    clear
    echo "Has introducido un número incorrecto"
    ;;
esac
}

#Esta función comprueba si el usuario está en modo root.
comprobarRoot ()
{
if [ `id -u` != 0 ]
then
    echo "No estás como administrador"
    exit
fi
}

# Esta función nos indican los usuarios que están bloqueados cuyo identificador oscila entre 1000 y 2000 en nuestro sistema. Estos usuarios serán redirigidos a un archivo llamado usuarios.txt.
# Después identificaremos el estado de las contraseñas de todos los usuarios del sistema e intentaremos buscar como coincidencia la letra L para identificar a los usuarios bloqueados. Todo esto será redirigido a un archivo llamado bloqueados.txt
# Por último uniremos ambos archivos para buscar las coincidencias de los usuarios que están bloqueados y lo sacaremos por pantalla.
UsuariosBloqueados()
{
 echo "Usuarios bloqueados: "
 awk -F: '$3 >= 1000 && $3 < 2000 {print $1}' /etc/passwd > $usuarios
 sudo passwd -S -a | grep "L" | cut -d " " -f1 > $usuariosBloqueados
 union=$(grep -f $usuarios $usuariosBloqueados)
 echo $union
 echo "_____________________________________________"
}

# Esta función nos bloquaría el usuario que deseemos.
BloquearUsuario()
{
	read -p "Ingrese el nombre de usuario que desea bloquear: " usuario
	`sudo usermod -L $usuario`
	echo "_____________________________________________"
}

# Esta función nos desbloquaría el usuario que deseemos.
DesbloquearUsuario()
{
	read -p "Ingrese el nombre de usuario que desea desbloquear: " usuario
	`sudo usermod -U $usuario`
	echo "_____________________________________________"
}

# Esta función nos indicaría si un usuario está inactivo.
# Primero introduciríamos el nombre del usuario que al que queramos comprobar su actividad.
# Luego comprobariamos si ese usuario está conectado y si está conectado nos dará el tiempo de inactividad. Si ese tiempo de inactividad es mayor a 1800 segundos se le cerraría la sesión de manera automática.
# Si ese usuario no está inactivo en ese rango de tiempo saldrá por pantalla que el usuario tiene la sesión activa.
CerrarSesion()
{
	read -p "Ingrese el nombre de usuario para cerrar sesión si está inactivo: " usuario
	if who | grep -q $usuario
 	then
    	tiempoInactividad=$(who -u | grep $usuario | awk '{print $5}')
    	if [ $tiempoInactividad > 1800 ] > /dev/null 2>&1
   		 then
       			 `sudo pkill -KILL -u $usuario`
        	echo "La sesión del usuario $usuario ha sido cerrada por inactividad."
    	else
        	echo "El usuario $usuario tiene la sesión activa. $tiempoInactividad"
    	fi
	else
    	echo "El usuario $usuario no tiene sesión activa."
	fi
	echo "_____________________________________________"
}


#Bloque principal
clear
while true
do
    menu
done

```
</details>  

<br>
<br>

#### *Screenshots*  
[Pantallazo que muestra el script en gedit(1)](imagenes/Ejercicio2_parte1.png)  
[Pantallazo que muestra el script en gedit(2)](imagenes/Ejercicio2_parte2.png)  
[Pantallazo que muestra el script en gedit(3)](imagenes/Ejercicio2_parte3.png)   
[Pantallazo del "usuariosBloqueados.sh" funcionando](imagenes/Ejercicio2_corriendo.png)  
    
<br>
<br>
<br>
<br>
<br>


![](https://img.shields.io/badge/ejercicio3-yellow?style=for-the-badge)
#### *Enunciado*  
`Realiza un script llamado crearBorrarUsuarios.sh, que nos muestre un menú:
1.- Crear Usuarios.` 

`2.- Borrar Usuarios.`  

`3.- Salir  `

`CrearUsuarios → Crea de forma masiva usuarios almacenados en el fichero /root/usuarios.csv
usuarios.csv `

`Los campos son los siguientes:`

`El campo 1 representa el nombre de usuario.` 

`El campo 2 representa la contraseña.` 

`El campo 3 representa el nombre.`

`El campo 4 representa su primer apellido.` 

`El campo 5 representa su correo electrónico.`

`Además, queremos que esas cuentas queden inactivas el 30 de junio de 2024.`

`BorrarUsuarios → Borra de forma masiva usuarios almacenados en el fichero /root/usuarios.csv.`
<br>
<br>

> [!NOTE]
> *En este script el único inconveniente que tuvimos fue tener que revisar temas anteriores para repasar comandos y propiedades que estaban un poco oxidados. Por ejemplo: useradd -m, -s, -p, -c y -e.*
 

#### *Bloque del script*  
<details>
	<sumary>Script 3</sumary>

```#!/bin/bash
#Autor: Jose María Jaén, Alejandro Lamprea, Javier Barrero
#Versión: 1.0
#Fecha:17-05-24
#Descripción: Este script permite crear usuarios d emanera masiva y también permite borrarlos de la misma manera.
#Parámetros/Variables


#Funciones
#Esta función nos realizaría un menú repetitivo el cual dejaria de repetirse hasta que el usuario pulse el número 3.
menu ()
{
	while true;
	do
		echo " "
		echo "Menú: "
		echo "___________________________________"
		echo "1.- Crear Usuarios"
		echo "2.- Borrar Usuarios"
		echo "3.- Salir"
		read -p "Pulse un número: " numero
	
		case $numero in
		1)
		crearUsuarios
		;;
		2)
		borrarUsuarios
		;;
		3)
		clear
		;;
		*)
		echo "Has pulsado una tecla erronea"
		;;
		esac
	done
		}

#Esta función nos permitiría crear masivamente los usuarios que existan dentro del archivo usuarios.csv que se encuentra en el root. Si ya estaban creados en nuestro sistema saldrá por pantalla que ya han sido creados y si no lo estaban nos saldrá que se han creado. Cuando termine el bucle se enviará el contenido de la variable email al archivo email.txt que se encuentra en el direfctorio de trabajo de el usuario al que pertenece dicho email.
crearUsuarios ()
{
	while read linea
	do
		id_usuario=$(echo $linea | cut -d: -f1)
		contrasena=$(echo $linea | cut -d: -f2)
		nombre=$(echo $linea | cut -d: -f3)
		apellidos=$(echo $linea | cut -d: -f4)
		email=$(echo $linea | cut -d: -f5)
	
			sudo useradd -m -s /bin/bash -p $contrasena -c "$nombre $apellidos" -e "2024-06-30" $id_usuario > /dev/null 2>&1
			if [ $? -eq 0 ]
				then
					echo "El usuario: $id_usuario ha sido creado."
				else
					echo "El usuario: $id_usuario ya está creado."
			fi
					echo "$email" > /home/$id_usuario/email.txt
		
	done </root/usuarios.csv
}

#Esta función nos permitiría borrar masivamente los usuarios que coincidan con la variable id_usurio que provenga del archivo usuarios.csv que se encuentra en el root.
borrarUsuarios ()
{
	while read linea
		do
			id_usuario=$(echo $linea | cut -d: -f1)
			sudo userdel -r $id_usuario > /dev/null 2>&1
			if [ $? -eq 0 ]
				then
					echo "El usuario: $id_usuario ha sido eliminado "
				else
					echo "El usuario: $id_usuario ha sido imposible de eliminar"
			fi
		done</root/usuarios.csv
}	
#Bloque principal
clear
menu 
```
</details>  

#### *Screenshots*  

[Pantallazo que muestra el script en gedit(parte1)](imagenes/gedit_crearBorrarUsuarios_1.png)  
[Pantallazo que muestra el script en gedit(parte1))](imagenes/gedit_crearBorrarUsuarios_2.png)   
[Pantallazo que muestra la ejecución del script](imagenes/ejecución_crearBorrarUsuarios.png)  

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

![](https://img.shields.io/badge/ejercicio4-orange?style=for-the-badge)
#### *Enunciado* 
`Crea en un script llamado crearUsuarios.sh que permita crear usuarios de forma automática.`   
`Indicaciones:`  
`1.- Al script se le pasa dos parámetros:`  
`a) El primer parámetro representa el nombre de un usuario genérico.`  
`b) El segundo parámetro representa el número de usuarios que quiere crearse.`  
`Ejemplo:` 
`sh crearUsuarios.sh alumno 3 → Creará los usuarios: alumno1, alumno2, alumno3`  
`2.- A cada usuario se le asigna la contraseña que coincida con el nombre de usuario.`  
`3.- Al usuario se le obliga a cambiar de contraseña, cuando se loguee.`  
`4.- Se crea un archivo: usuariosCreados-FechaActual.tmp con el nombre de los usuarios creados y la contraseña asignado, separados por “:”.`  
`5.- El archivo usuariosCreados-FechaActual.tmp tiene que ser mostrado en pantalla tras la ejecución del script.`  
<br>


> [!NOTE]
> *En este script nuestro mayor problema fue referente a la línea "sudo useradd -m -p", nos daba error constantemente. Tras un tiempo de investigación por foros, páginas oficiales como openssl y consultas a inteligencia artificial, descubrimos que teníamos que añadir una manera para encriptar las contraseñas de esos usuarios que iban a ser creados.* 

#### *Bloque del script*  
<details>
	<sumary>Script 4</sumary>

```
#!/bin/bash
#Autor: Jose María Jaén, Alejandro Lamprea, Javier Barrero
#Versión: 1.0
#Fecha:15-05-24
#Descripción: Este script crea usuarios de forma automática.
#Parámetros/Variables
#Declaramos las variables nombreUsuario, numUsuario y fecha para la ejecución de nuestro script.
nombreUsuario=$1
numUsuario=$2
fecha=$(date +"%Y-%m-%d %H:%M")

#Funciones
#Bloque principal
clear
#Utilizamos un if que: Mientras que el número de parametros que se introduzcan no sean 2 nos recordará que debemos introducir 2 parámetros y si no es así nos echará del script.
#Despues recorrerá una secuencia que empezará por el numero 1 e irá recorriendo los siguientes numeros de 1 en 1. 
if [ $# -ne 2 ]; then
  echo "Introduce dos parámetros:<nombreUsuario> y :<numUsuario>"
  exit
fi
#A continuación recorrerá una secuencia que empezará por el numero 1 e irá recorriendo los siguientes numeros de 1 en 1. 
#Más tarde crearemos un nuevo usuario con su nuevo directorio y especificaremos que la contraseña quede encriptada o cifrada. Hemos tenido que utilizar el OpenSSL para poder cifrar la contraseña.
#Después forzaremos al usuario a cambiar su contraseña la próxima vez que inicie sesión.
#Finalmente redirigiremos los datos obtenidos de nuestras dos anteriores variables a un archivo .tmp.
for i in $(seq 1 1 $numUsuario)
    do
      nombre_usuario="$nombreUsuario$i"
      password="$nombre_usuario"
	 sudo useradd -m -p $(echo -n "$password" | openssl passwd -1 -stdin) "$nombre_usuario"
    sudo chage -d 0 "$nombre_usuario"

 echo "$nombre_usuario:$password" >> usuariosCreados-$fecha.tmp
 done
cat "usuariosCreados-$fecha.tmp"
```


</details>
<br>
<br>

#### *Screenshots*  

[Pantallazo que muestra el script en gedit](imagenes/crearUsuarios.png)  
[Pantallazo que muestra la ejecución del script (parte1)](imagenes/ejecucion_crearUsuario_1.png)  
[Pantallazo que muestra la ejecución del script (parte2)](imagenes/ejecucion_crearUsuario_2.png)   
[Pantallazo que muestra la ejecución del script (parte3)](imagenes/ejecucion_crearUsuario_3.png)  

<br>
<br>
<br>
<br>
<br>


![](https://img.shields.io/badge/ejercicio5-green?style=for-the-badge)
#### *Enunciado* 
`Partimos de que tenemos varios usuarios: usuario1, usuario2, usuario3.`    
`Al usuario1, se le ha establecido una cuota de disco: 40k y 100K (soft y hard respectivamente).`  
`Realiza un script llamado cuotasUsuarios.sh, que nos copie la cuota del usuario1 a todos los usuarios cuyo uid >1000 y uid<2000.`

> [!NOTE]
> *En este script nos encontramos con un muro que nos impidió avanzar. En la función de **Usuarios bloqueados** nos trabamos a la hora de sacar la lista de usuarios con UID entre 1000 y 2000 a la vez que estuviesen bloqueados.*

#### *Bloque del script*  
<br>
<br>
<br>
<br>
<br>



#### *Bibliografía*  
| Ejercicio | Fuentes |
| --------- | ------ |
| 1 | https://computernewage.com/2019/03/09/scripting-linux-bash-ejecutar-script-arranque/ https://geekland.eu/programar-la-ejecucion-de-tareas-con-systemd-timers-y-reemplazar-cron/ |
| 2 | https://www.ionos.es/digitalguide/servidores/configuracion/comando-de-linux-passwd/ |
| 3 | https://www.openssl.org/docs/man3.0/man1/openssl-passwd.html |
| 4 | https://infolinux.es/comando-useradd-de-linux-creacion-de-usuarios-de-manera-tecnica/ |
| 5 |   |
<br>

> [!NOTE]
> Para algunos ejercicios  acudimos a apuntes de temas pasados y también alguna consulta a la inteligencia artificial.

<br>
<br>

#### *Conclusiones generales*
Los objetivos para la realización de este trabajo de scripts basados en bash creemos que se han cumplido. Se nos solicitaba detectar problemas de rendimiento monitorizando el sistema con las herramientas adecuadas documentando el proceso y también se nos indicaba auditar la utilización y acceso identificando y respectando la seguridad del sistema. Comparando detenidamente el trabajo que hemos realizado con lo que se nos solicitaba creemos que hemos estado a la altura aunque, por falta de tiempo en la última semana de los miembros del grupo, el ejercicio nº5 no conseguimos sacarlo adelante.  


#### *Conclusiones personales*
> He aprendido mucho acerca de bash y su gestión combinando los conocimientos adquiridos en clase con la realizacion del trabajo en grupo con mis compañeros.  -Javier Barrero Vázquez.
<br>

> En mi caso he descubierto dos herramientas que desconocía como son GitHub (en profundidad) y el lenguaje Markdown y, más allá de este trabajo, he investigado posibles utilidades de cara al futuro y me han sorprendido bastantes.  -Alejandro Lamprea Pérez.
<br>

> Yo he aprendido a gestionarme el tiempo además de coordinarme con mi grupo para la división de tareas. Respecto a lo que viene siendo los scripts, me han servido a modo de repaso de cara al final de trimestre y al segundo año.  -Jose María Jaén Castillo.





