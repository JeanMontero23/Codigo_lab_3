#!/bin/bash

# Función para imprimir el menú de ayuda
print_help() {
    echo "Uso: $0 [-h] [-m MODE] [-d DATE]"
    echo "  -h: Imprimir este menú de ayuda"
    echo "  -m MODE: Modo de funcionamiento del informe (opciones disponibles: servidor_web, base_de_datos, proceso_batch, aplicación, monitoreo)"
    echo "  -d DATE: Fecha en formato año-mes-día (ejemplo: 2024-03-08)"
}

# Función para generar el informe
generate_report() {
    if [ -z "$mode" ] && [ -z "$date" ]; then
        grep -E "ERROR \[$selected_mode\]" *.log
    elif [ -n "$mode" ] && [ -n "$date" ]; then
        grep -E "ERROR \[$mode\]" *.log | grep "$date"
    elif [ -z "$mode" ] && [ -n "$date" ]; then
        grep -E "ERROR" *.log | grep "$date"
    else
        grep -E "ERROR \[$mode\]" *.log
    fi
}

#Revisar si se dio algun argumento
if [ $# -eq 0 ]; then
        echo "Se debe dar al menos una opcion. Digite -h si necesita ayuda" >&2
        exit 1
fi

# Variables para almacenar los argumentos
mode=""
date=""

# Procesar los argumentos de línea de comandos
while getopts "hm:d:" opt; do
    case ${opt} in
        h )
            print_help
            exit 0
            ;;
        m )
            mode=$OPTARG
            ;;
        d )
            date=$OPTARG
            ;;
        \? )
            echo "Opción inválida: -$OPTARG" 1>&2
            print_help
            exit 1
            ;;
    esac
done

# Verificar si se especificó un modo válido
if [ -n "$mode" ]; then
    case $mode in
        servidor_web|base_de_datos|proceso_batch|aplicación|monitoreo )
            selected_mode=$mode
            ;;
        * )
            echo "Modo inválido: $mode" 1>&2
            print_help
            exit 1
            ;;
    esac
fi

# Verificar si la fecha está en el formato correcto
if [ -n "$date" ]; then
    if [[ ! $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "Formato de fecha incorrecto: $date. Debe estar en formato año-mes-día (ejemplo: 2024-03-08)" 1>&2
        print_help
        exit 1
    fi
fi

# Generar el informe
generate_report        
