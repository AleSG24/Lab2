#!/bin/bash

ruta_archivo=""
group_name=""
user_name=""

#checks if user is root
if [[ $(whoami) != "root" ]]; then
	echo "Unicamente root puede ejecutar este script"
	exit 1
fi

#asks for parameters user, group and route

read -p "Ingrese un nombre de usuario: " user_name

read -p "Ingrese el nombre del grupo: " group_name

read -p "Ingrese la ruta del archivo: " ruta_archivo

#checks if route exists

if [[ ! -e "$ruta_archivo" ]]; then

	echo "ejercicio.sh $user_name $group_name $ruta_archivo ERROR non existen file route"
         
	echo "ejercicio1.sh  $user_name $group_name $ruta_archivo"  >> error.log
	exit 1
fi

#checks if group exists and creates it if it doesnt

if grep -q "$group_name:" /etc/group; then
	echo "Grupo: $group_name existe"

else
	echo "grupo inexistente, creando....."
	addgroup "$group_name"
fi

#checks if user exists and if it doesnt it creates it

if grep -q "$user_name:" /etc/passwd; then
	echo "Usuario: $user_name existe"
	usermod -aG "$group_name" "$user_name"
else
	echo "El usuario no existe, creando..."
	adduser "$user_name"
	echo "agregando usuario nuevo al grupo..."
	usermod -aG "$group_name" "$user_name"
fi

#revokes permissions to other users and groups

chmod go-rwx $(basename "$ruta_archivo")

#Modifies ownership of the file

chown $user_name:$group_name $(basename "$ruta_archivo")

#gives reading, editing and excecution permissions to the owner

chmod u+rwx $(basename "$ruta_archivo")

#gives group reading permissions

chmod g+r $(basename "$ruta_archivo")
