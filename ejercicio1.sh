#!/bin/bash

#Se necesita verificar si lo que se recibe es un archivo como argumento
if [ $# -ne 1 ]; then
	echo "Usar: $0 <archivo>"
	exit 1
fi

archivo=$1


#Ahora se necesita verificar si el archivo que se nos da existe
if [ ! -e "$archivo" ]; then
	echo "Se ha detectado un error: El archivo $archivo no existe."
	exit 2
fi

#Se obtienen los permisos del archivo
permisos=$(stat -c "%A" "$archivo")

#Se va a crear una funcion para obtener los permisos desglosadamente
get_permissions_verbose() {
	local permsisos=$1
	user_perm=${permisos:1:3}
	group_perm=${permisos:4:3}
	other_perm=${permisos:7:3}

	echo "Permisos del ususario: "
	for ((i=0; i<${#user_perm}; i++)); do
		char=${user_perm:$i:1}
		case $char in
			"r") echo "Lectura permitida";;
			"w") echo "Escritura permitida";;
			"x") echo "Ejecucion permitida";;
			"-") echo "Sin permiso";;
		esac
	done

	echo "Permisos del grupo: "
        for ((i=o; i<${#group_perm}; i++)); do
                char=${group_perm:$i:1}
                case $char in
                        "r") echo "Lectura permitida";;
                        "w") echo "Escritura permitida";;
                        "x") echo "Ejecucion permitida";;
                        "-") echo "Sin permiso";;
                esac
        done

	echo "Permisos de otros usuarios: "
        for ((i=o; i<${#other_perm}; i++)); do
                char=${other_perm:$i:1}
                case $char in
                        "r") echo "Lectura permitida";;
                        "w") echo "Escritura permitida";;
                        "x") echo "Ejecucion permitida";;
                        "-") echo "Sin permiso";;
                esac
        done

}

#Se invoca la funcion para obtener los permisos
get_permissions_verbose "$permisos"
