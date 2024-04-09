#!/bin/bash

#Se revisa si reciben dos argumentos
if [ $# -ne 2 ]; then
	echo "Se usa: $0 <nombre_usuario> <nombre_grupo>"
	exit 1
fi

usuario=$1
grupo=$2

#Hay que verificar si el usuario ya existe
if id "$usuario" &>/dev/null; then
	echo "El usuario $usuario ya existe"
else
	#Se crea el usuario ya que no se encuentra
	sudo useradd "$usuario"
	echo "Usuario $usuario creado"
fi

#Ahora es verificar si el grupo ya existe
if grep -q "^$grupo:" /etc/group; then
	echo "El grupo $grupo ya existe"
else
	#Crear el grupo ya que se vio que no existe
	sudo groupadd "$grupo"
	echo "Grupo $grupo ha sido creado"
fi

#Se agrega al usuario "default al grupo"
sudo usermod -aG "$grupo" "$(whoami)"

#Agregar el nuevo usuario al grupo
sudo usermod -aG "$grupo" "$usuario"

#Hay que dar permisos de ejecucion al script ejercicio1.sh
sudo chown :"$grupo" ejercicio1.sh
sudo chmod 750 ejercicio1.sh

echo "Los permisos de ejecucion del script ejercicio1.sh fueron asignados al grupo $grupo"
