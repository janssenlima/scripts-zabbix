#!/bin/sh

usage() {
    echo Uso: $0 hostname
    echo "Exemplo: $0 localhost"
}


if [ -z $1 ]; then
    echo "Nenhum host especificado" > /dev/stderr
    usage
    exit 1
fi

Scan=$(nmap -Pn --open -n $1)

OldIFS=$IFS
IFS="
"
Pattern=".*/tcp open .*"

echo '{"data":['

contador=0
incremento=1

for linha in $Scan; do
    Tmp=$(echo $linha | sed -e 's/^[[:space:]]*//' | sed -r 's/ +/ /g' | grep $Pattern)
    if [ $? -eq 0 ]; then
        porta=$(echo -n $Tmp | cut -d "/" -f 1 | tr -d "\n")
        servico=$(echo -n $Tmp | cut -d " " -f 3 | tr -d "\n")

        if [ "$Name" = "unknown" ]; then
            Name="port $Port"
        fi

        if [ $contador -gt 0 ]; then
                printf  ','
                echo
        fi
        printf '{"{#PORTA}":"%s", "{#SERVICO}":"%s"}' "$porta" "$servico"

        contador=$(($contador+$incremento))

    fi
done

echo
echo ']}'

IFS=$OldIFS
