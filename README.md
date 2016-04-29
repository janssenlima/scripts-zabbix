# Script Zabbix
Scripts para utilização de monitoramento diversos com o NMS Zabbix

<b>Monitoramento Amazon RDS </b><p>
Necessário preencher os valores das macros {$AWS_ACCESS_KEY} e {$AWS_SECRET_KEY} dentro da configuração do template.

<b>Monitoramento Apache </b><p>
Necessário habilitar server-status do Apache.

<b>Monitoramento de portas TCP com LLD </b><p>
Necessário instalar pacote <b>nmap</b><br>
Copiar script .sh para diretório externalscripts do Zabbix<br>
Importar o template e associar aos hosts desejados
