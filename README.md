## Trabajo Bloque V
#### Trabajo realizado por Javier Barrero, Jose María Jaén y Alejandro Lamprea Pérez.
### Índice 
1. [Ejercicio 1](#comprobarApache.sh)

### **Ejercicio 1**
#### **Enunciado**  
Realiza un script llamado comprobarApache.sh, que compruebe cada minuto si el servicio apache2 está activo (running).  
Si está parado, entonces:  
1.- Introduce una línea: “Error-Apache: Fecha y hora actual” en /root/ApacheError.tmp, donde FechaActual, representa día, mes, año, hora y minuto.  
2.- Reinicia el servicio apache2  
Para comprobarlo, para el servicio. Ejecuta el script en segundo plano y observa si lo reinicia y crea el archivo.  
3.- Además del script, crea una tarea programada, de forma que ese script se ejecute cada 6 horas, todos los días. Y si el ordenador está apagado, se debe ejecutar la próxima vez que se inicie, transcurrido cinco minutos.  

#### **Desarrollo del script**  
Trabajando en este script, concretamente en la función "comprobarApache" nos dimos cuenta que a la hora de redireccionar el error a "/root/ApacheError.tmp" nos denegaría el permiso ya que necesitamos ser root. Decidimos añadir la típica función de "comprobarRoot" para hacerle saber al usuario final que debe logearse como root.


[Pantallazo que muestra el script en gedit](ComprobarApache.png)  
[Pantallazo del crontab con la tarea programada del script](crontab_comprobarApache.png)  
[Pantallazo del "comprobarApache.sh" funcionando](ej1_funcionando.png)  

