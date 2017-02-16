# Script Zabbix
Scripts para utilização de monitoramento diversos com o NMS Zabbix


<b>Monitoramento Apache </b><p>
Necessário habilitar server-status do Apache.

<b>Monitoramento de portas TCP com LLD </b><p>
Necessário instalar pacote <b>nmap</b><br>
Copiar script .sh para diretório externalscripts do Zabbix<br>
Importar o template e associar aos hosts desejados

<b>Instalação automática do Zabbix com GLPI </b><p>
O script integraGZ.sh faz a instalação automática do Zabbix e do GLPI e prepara a integração entre os dois sitemas, bastando apenas configurar a ação necessária para abrir o chamado no GLPI após a ocorrência de um incidente no Zabbix.
