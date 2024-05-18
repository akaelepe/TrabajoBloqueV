![MasterHead](https://user-images.githubusercontent.com/74038190/213910845-af37a709-8995-40d6-be59-724526e3c3d7.gif)

![](https://img.shields.io/badge/scripts-orange?style=for-the-badge)           
![](https://img.shields.io/badge/github-blue?style=for-the-badge)







#### Trabajo realizado por Javier Barrero, Jose María Jaén y Alejandro Lamprea.
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

<img src="https://cdn-icons-png.flaticon.com/512/2037/2037149.png" style="width: 25px; height: 25px;"/> Índice 
- [x] 1. [Ejercicio 1](comprobar_Apache_final.png)
- [x] 2. [Ejercicio 2]
- [x] 3. [Ejercicio 3]
- [x] 4. [Ejercicio 4]
- [x] 5. [Ejercicio 5]
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
> *Trabajando en este script, concretamente en la función "comprobarApache" nos dimos cuenta que a la hora de redireccionar el error a "/root/ApacheError.tmp" nos denegaría el permiso ya que necesitamos ser root. Decidimos añadir la típica función de "comprobarRoot" para hacerle saber al usuario final que debe logearse como root.*.
<br>
<br>


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

#Esta función comprueba si el usuario está en modo root.
comprobarRoot ()
{
if [ `id -u` != 0 ]
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
#Esta condición realiza la ejecución del script a los 5 minutos de estar encendido el equipo.
if [ "$(systemctl is-system-running)" == "poweroff" ];
    then
   	 sleep 300
   	 /home/javi/TRABAJOSCRIPTS/comprobarApache.sh
fi

```
#### *Screenshots*
[Pantallazo que muestra el script en gedit](comprobar_Apache_final.png)  
[Pantallazo del crontab con la tarea programada del script](crontab_comprobarApache.png)  
[Pantallazo del "comprobarApache.sh" funcionando](ej1_funcionando.png)  

<br>
<br>
<br>
<br>
<br>


![](https://img.shields.io/badge/ejercicio2-blue?style=for-the-badge)
#### *Enunciado*  
`Realiza un script llamado usuariosBloqueados.sh, que nos muestre un menú:
1.- Usuarios Bloqueados.
2.- Bloquear un usuario.
3.- Desbloquear usuario.
4.- Cerrar sesión usuario
5.- Salir
Cada opción del menú corresponde con una función.
UsuariosBloqueados → nos muestra en pantalla los usuarios (uid>1000 y <2000) que tengan la cuenta bloqueada.
BloquearUsuario → Nos pregunta el nombre de un usuario y lo bloqueamos.
DesbloquearUsuario → Nos pregunta el nombre de un usuario y lo desbloqueamos.
CerrarSesion → Nos pregunta el nombre de un usuario, y si el usuario lleva más de 30 minutos (1800 seg) sin actividad, se le cierra la sesión.`  


<br>
<br>

> [!NOTE]
> *En este script estuvimos bastante atascados en la función "UsuariosBloqueados", ya que no se nos ocurría la forma en la que podiamos obtener los usuarios con UID entre 1000 y 2000 a la vez que la condición de que estuviesen bloqueados. Al final recurrimos a redirigir los usuarios con UID entre 1000 y 2000 a un archivo, posteriormente hemos utilizado un "passwd -S -a" para comprobar el estado de las contraseñas de todos los usuarios del sistema *
.
<br>
<br> 

<br>
<br>
<br>
<br>
<br>


![](https://img.shields.io/badge/ejercicio3-blue?style=for-the-badge)
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

> [!NOTE]
> *En este script nos encontramos con un muro que nos impidió avanzar. En la función de **Usuarios bloqueados** nos trabamos a la hora de sacar la lista de usuarios con UID entre 1000 y 2000 a la vez que estuviesen bloqueados.* 


<br>
<br>
<br>
<br>
<br>

![](https://img.shields.io/badge/ejercicio4-blue?style=for-the-badge)
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

> [!NOTE]
> *En este script nos encontramos con un muro que nos impidió avanzar. En la función de **Usuarios bloqueados** nos trabamos a la hora de sacar la lista de usuarios con UID entre 1000 y 2000 a la vez que estuviesen bloqueados.*  


<br>
<br>
<br>
<br>
<br>


![](https://img.shields.io/badge/ejercicio5-blue?style=for-the-badge)
#### *Enunciado* 
`Partimos de que tenemos varios usuarios: usuario1, usuario2, usuario3.`    
`Al usuario1, se le ha establecido una cuota de disco: 40k y 100K (soft y hard respectivamente).`  
`Realiza un script llamado cuotasUsuarios.sh, que nos copie la cuota del usuario1 a todos los usuarios cuyo uid >1000 y uid<2000.`

> [!NOTE]
> *En este script nos encontramos con un muro que nos impidió avanzar. En la función de **Usuarios bloqueados** nos trabamos a la hora de sacar la lista de usuarios con UID entre 1000 y 2000 a la vez que estuviesen bloqueados.*


<br>
<br>
<br>
<br>
<br>
