#!/bin/bash

# @Programa 
# 	@name: integraGZ.sh
#	@versao: 1.0 for CentOS
#	@Data 16 de Setembro de 2016
#	@Copyright: Verdanatech Soluções em TI, 2016
#	@Copyright: Pillares Consulting, 2016
#	@Copyright: Conectsys Tecnologia da Informacao, 2016
# --------------------------------------------------------------------------
# LICENSE
#
# integraGZ-CentOS.sh is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# integraGZ.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------------

# Variaveis

versionDate="Setember 09, 2016"
TITULO="integraGZ.sh - v.1.0 for CentOS"
BANNER="http://www.verdanatech.com | http://www.conectsys.com.br"

devMail=janssenreislima@gmail.com
zabbixVersion=zabbix-3.2
TMP_DIR=/tmp
zabbixSource=$TMP_DIR/$zabbixVersion
linkJanssen=https://github.com/janssenlima/zabbix-glpi.git
externalScriptsDir=/usr/local/zabbix/share/zabbix/externalscripts/
serverAddress=$(hostname -I | cut -d' ' -f1)

clear


reqsToUse ()
{
# Testa se o usuário é o root
if [ $UID -ne 0 ]
then
	whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "Step 1 - We apologize! You need root access to use this script." --fb 10 50
	kill $$
fi

# Testa a versão do sistema
centosVersion=$(cat /etc/redhat-release | awk '{print $4}' | cut -d "." -f1)

if [ $centosVersion -ne 7 ]
then
	whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "Step 1 - We apologize! This script was developed for Debian 8.x I will close the running now." --fb 10 50
	kill $$
fi
}

menuPrincipal ()
{
 
menu01Option=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --menu "Escolha uma opção na lista abaixo" --fb 15 50 4 \
"1" "Install GLPI and Zabbix" \
"2" "More Information" \
"3" "Credits and License" \
"4" "Exit" 3>&1 1>&2 2>&3)
 
status=$?

if [ $status != 0 ]; then
	echo "
You have selected out. Bye!
"
	exit;
fi

}

showCredits ()
{
clear

whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "
Copyright:
- Pillares Consulting, $versionDate
- Conectsys Tecnologia da Informacao, $versionDate

Licence:
- GPL v3 <http://www.gnu.org/licenses/>

Project partners:
- Gustavo Soares <slot.mg@gmail.com>
- Halexsandro Sales <halexsandro@gmail.com>
- Janssen Lima <janssenreislima@gmail.com>

API Integration Script:
- Janssen Lima <janssenreislima@gmail.com>
"  --fb 0 0 0

}


#
# Garante que o usuário tenha o whiptail instalado no computador

INSTALA_WHIPTAIL () 
{

yum install newt -y

clear

[ ! -e /usr/bin/whiptail ] && { echo -e "

 ###########################################################
#                       WARNING!!!                          #
 -----------------------------------------------------------
#                                                           #
#                                                           #
# There was an error installing the whiptail.               #
#  - Check your internet connection.                        #
#                                                           #
# The whiptail package is required to run the integraGZ.sh  #
# Please contact us: $devMail                               #
#                                                           #
#                                                           #
 ----------------------------------------------------------
      Verdanatech Solucoes em TI - www.verdanatech.com 
 ----------------------------------------------------------"; 

	exit 1; }

}


INFORMATION () 
{

whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "
This script aims to perform the installation automated systems:
 - GLPI 0.90.3  [http://glpi-project.com]
  -- Webservice 1.6.0
  -- Racks 1.6.1 
  -- DashBoard 0.7.3
  -- SimCard 1.4.1
  -- FusionInventory 0.90.1.3
 - Zabbix 3.2   [http://zabbix.com]
  -- zabbix-server
  -- zabbix-agent
NOTE: After instalation, the API Scripts are at /usr/local/share/zabbix/externalscripts/
" --fb 0 0 0

}



timeZone ()

# Configura timezone do PHP para o servidor
# Ref: http://php.net/manual/pt_BR/timezones.php
# 

{

whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "Now we configure the server's timezone. Select the timezone that best meets!." --fb 10 50

while [ -z $timePart1 ]
do

timePart1=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --radiolist \
"Select the timezone for your Server!" 20 60 10 \
	"Africa" "" OFF \
	"America" "" OFF \
	"Antarctica" "" OFF \
	"Arctic" "" OFF \
	"Asia" "" OFF \
	"Atlantic" "" OFF \
	"Australia" "" OFF \
	"Europe" "" OFF \
	"Indian" "" OFF \
	"Pacific" "" OFF  3>&1 1>&2 2>&3)
done

case $timePart1 in

	Africa)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Abidjan" "" OFF \
			"Accra" "" OFF \
			"Addis_Ababa" "" OFF \
			"Algiers" "" OFF \
			"Asmara" "" OFF \
			"Asmera" "" OFF \
			"Bamako" "" OFF \
			"Bangui" "" OFF \
			"Banjul" "" OFF \
			"Bissau" "" OFF \
			"Blantyre" "" OFF \
			"Brazzaville" "" OFF \
			"Bujumbura" "" OFF \
			"Cairo" "" OFF \
			"Casablanca" "" OFF \
			"Ceuta" "" OFF \
			"Conakry" "" OFF \
			"Dakar" "" OFF \
			"Dar_es_Salaam" "" OFF \
			"Djibouti" "" OFF \
			"Douala" "" OFF \
			"El_Aaiun" "" OFF \
			"Freetown" "" OFF \
			"Gaborone" "" OFF \
			"Harare" "" OFF \
			"Johannesburg" "" OFF \
			"Juba" "" OFF \
			"Kampala" "" OFF \
			"Khartoum" "" OFF \
			"Kigali" "" OFF \
			"Kinshasa" "" OFF \
			"Lagos" "" OFF \
			"Libreville" "" OFF \
			"Lome" "" OFF \
			"Luanda" "" OFF \
			"Lubumbashi" "" OFF \
			"Lusaka" "" OFF \
			"Malabo" "" OFF \
			"Maputo" "" OFF \
			"Maseru" "" OFF \
			"Mbabane" "" OFF \
			"Mogadishu" "" OFF \
			"Monrovia" "" OFF \
			"Nairobi" "" OFF \
			"Ndjamena" "" OFF \
			"Niamey" "" OFF \
			"Nouakchott" "" OFF \
			"Ouagadougou" "" OFF \
			"Porto-Novo" "" OFF \
			"Sao_Tome" "" OFF \
			"Timbuktu" "" OFF \
			"Tripoli" "" OFF   3>&1 1>&2 2>&3)
	done
	;;

	America)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Adak" "" OFF \
			"Anchorage" "" OFF \
			"Anguilla" "" OFF \
			"Antigua" "" OFF \
			"Araguaina" "" OFF \
			"Argentina/Buenos_Aires" "" OFF \
			"Argentina/Catamarca" "" OFF \
			"Argentina/ComodRivadavia" "" OFF \
			"Argentina/Cordoba" "" OFF \
			"Argentina/Jujuy" "" OFF \
			"Argentina/La_Rioja" "" OFF \
			"Argentina/Mendoza" "" OFF \
			"Argentina/Rio_Gallegos" "" OFF \
			"Argentina/Salta" "" OFF \
			"Argentina/San_Juan" "" OFF \
			"Argentina/San_Luis" "" OFF \
			"Argentina/Tucuman" "" OFF \
			"Argentina/Ushuaia" "" OFF \
			"Aruba" "" OFF \
			"Asuncion" "" OFF \
			"Atikokan" "" OFF \
			"Atka" "" OFF \
			"Bahia" "" OFF \
			"Bahia_Banderas" "" OFF \
			"Barbados" "" OFF \
			"Belem" "" OFF \
			"Belize" "" OFF \
			"Blanc-Sablon" "" OFF \
			"Boa_Vista" "" OFF \
			"Bogota" "" OFF \
			"Boise" "" OFF \
			"Buenos_Aires" "" OFF \
			"Cambridge_Bay" "" OFF \
			"Campo_Grande" "" OFF \
			"Cancun" "" OFF \
			"Caracas" "" OFF \
			"Catamarca" "" OFF \
			"Cayenne" "" OFF \
			"Cayman" "" OFF \
			"Chicago" "" OFF \
			"Chihuahua" "" OFF \
			"Coral_Harbour" "" OFF \
			"Cordoba" "" OFF \
			"Costa_Rica" "" OFF \
			"Creston" "" OFF \
			"Cuiaba" "" OFF \
			"Curacao" "" OFF \
			"Danmarkshavn" "" OFF \
			"Dawson" "" OFF \
			"Dawson_Creek" "" OFF \
			"Denver" "" OFF \
			"Detroit" "" OFF \
			"Dominica" "" OFF \
			"Edmonton" "" OFF \
			"Eirunepe" "" OFF \
			"El_Salvador" "" OFF \
			"Ensenada" "" OFF \
			"Fort_Nelson" "" OFF \
			"Fort_Wayne" "" OFF \
			"Fortaleza" "" OFF \
			"Glace_Bay" "" OFF \
			"Godthab" "" OFF \
			"Goose_Bay" "" OFF \
			"Grand_Turk" "" OFF \
			"Grenada" "" OFF \
			"Guadeloupe" "" OFF \
			"Guatemala" "" OFF \
			"Guayaquil" "" OFF \
			"Guyana" "" OFF \
			"Halifax" "" OFF \
			"Havana" "" OFF \
			"Hermosillo" "" OFF \
			"Indiana/Indianapolis" "" OFF \
			"Indiana/Knox" "" OFF \
			"Indiana/Marengo" "" OFF \
			"Indiana/Petersburg" "" OFF \
			"Indiana/Tell_City" "" OFF \
			"Indiana/Vevay" "" OFF \
			"Indiana/Vincennes" "" OFF \
			"Indiana/Winamac" "" OFF \
			"Indianapolis" "" OFF \
			"Inuvik" "" OFF \
			"Iqaluit" "" OFF \
			"Jamaica" "" OFF \
			"Jujuy" "" OFF \
			"Juneau" "" OFF \
			"Kentucky/Louisville" "" OFF \
			"Kentucky/Monticello" "" OFF \
			"Knox_IN" "" OFF \
			"Kralendijk" "" OFF \
			"La_Paz" "" OFF \
			"Lima" "" OFF \
			"Los_Angeles" "" OFF \
			"Louisville" "" OFF \
			"Lower_Princes" "" OFF \
			"Maceio" "" OFF \
			"Managua" "" OFF \
			"Manaus" "" OFF \
			"Marigot" "" OFF \
			"Martinique" "" OFF \
			"Matamoros" "" OFF \
			"Mazatlan" "" OFF \
			"Mendoza" "" OFF \
			"Menominee" "" OFF \
			"Merida" "" OFF \
			"Metlakatla" "" OFF \
			"Mexico_City" "" OFF \
			"Miquelon" "" OFF \
			"Moncton" "" OFF \
			"Monterrey" "" OFF \
			"Montevideo" "" OFF \
			"Montreal" "" OFF \
			"Montserrat" "" OFF \
			"Nassau" "" OFF \
			"New_York" "" OFF \
			"Nipigon" "" OFF \
			"Nome" "" OFF \
			"Noronha" "" OFF \
			"North_Dakota/Beulah" "" OFF \
			"North_Dakota/Center" "" OFF \
			"North_Dakota/New_Salem" "" OFF \
			"Ojinaga" "" OFF \
			"Panama" "" OFF \
			"Pangnirtung" "" OFF \
			"Paramaribo" "" OFF \
			"Phoenix" "" OFF \
			"Port-au-Prince" "" OFF \
			"Port_of_Spain" "" OFF \
			"Porto_Acre" "" OFF \
			"Porto_Velho" "" OFF \
			"Puerto_Rico" "" OFF \
			"Rainy_River" "" OFF \
			"Rankin_Inlet" "" OFF \
			"Recife" "" OFF \
			"Regina" "" OFF \
			"Resolute" "" OFF \
			"Rio_Branco" "" OFF \
			"Rosario" "" OFF \
			"Santa_Isabel" "" OFF \
			"Santarem" "" OFF \
			"Santiago" "" OFF \
			"Santo_Domingo" "" OFF \
			"Sao_Paulo" "" OFF \
			"Scoresbysund" "" OFF \
			"Shiprock" "" OFF \
			"Sitka" "" OFF \
			"St_Barthelemy" "" OFF \
			"St_Johns" "" OFF \
			"St_Kitts" "" OFF \
			"St_Lucia" "" OFF \
			"St_Thomas" "" OFF \
			"St_Vincent" "" OFF \
			"Swift_Current" "" OFF \
			"Tegucigalpa" "" OFF \
			"Thule" "" OFF \
			"Thunder_Bay" "" OFF \
			"Tijuana" "" OFF \
			"Toronto" "" OFF \
			"Tortola" "" OFF \
			"Vancouver" "" OFF \
			"Virgin" "" OFF \
			"Whitehorse" "" OFF \
			"Winnipeg" "" OFF \
			"Yakutat" "" OFF   3>&1 1>&2 2>&3)
		done
		;;
		

	Antarctica)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Casey" "" OFF \
			"Davis" "" OFF \
			"DumontDUrville" "" OFF \
			"Macquarie" "" OFF \
			"Mawson" "" OFF \
			"McMurdo" "" OFF \
			"Palmer" "" OFF \
			"Rothera" "" OFF \
			"South_Pole" "" OFF \
			"Syowa" "" OFF \
			"Troll" "" OFF \
			"Vostok"  "" OFF    3>&1 1>&2 2>&3)
	done
	;;

	Arctic)
	while [ -z $timePart2 ]
	do

		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Longyearbyen" "" OFF    3>&1 1>&2 2>&3)
	done
	;;

	Asia)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Aden" "" OFF \
			"Almaty" "" OFF \
			"Amman" "" OFF \
			"Anadyr" "" OFF \
			"Aqtau" "" OFF \
			"Aqtobe" "" OFF \
			"Ashgabat" "" OFF \
			"Ashkhabad" "" OFF \
			"Baghdad" "" OFF \
			"Bahrain" "" OFF \
			"Baku" "" OFF \
			"Bangkok" "" OFF \
			"Beirut" "" OFF \
			"Bishkek" "" OFF \
			"Brunei" "" OFF \
			"Calcutta" "" OFF \
			"Chita" "" OFF \
			"Choibalsan" "" OFF \
			"Chongqing" "" OFF \
			"Chungking" "" OFF \
			"Colombo" "" OFF \
			"Dacca" "" OFF \
			"Damascus" "" OFF \
			"Dhaka" "" OFF \
			"Dili" "" OFF \
			"Dubai" "" OFF \
			"Dushanbe" "" OFF \
			"Gaza" "" OFF \
			"Harbin" "" OFF \
			"Hebron" "" OFF \
			"Ho_Chi_Minh" "" OFF \
			"Hong_Kong" "" OFF \
			"Hovd" "" OFF \
			"Irkutsk" "" OFF \
			"Istanbul" "" OFF \
			"Jakarta" "" OFF \
			"Jayapura" "" OFF \
			"Jerusalem" "" OFF \
			"Kabul" "" OFF \
			"Kamchatka" "" OFF \
			"Karachi" "" OFF \
			"Kashgar" "" OFF \
			"Kathmandu" "" OFF \
			"Katmandu" "" OFF \
			"Khandyga" "" OFF \
			"Kolkata" "" OFF \
			"Krasnoyarsk" "" OFF \
			"Kuala_Lumpur" "" OFF \
			"Kuching" "" OFF \
			"Kuwait" "" OFF \
			"Macao" "" OFF \
			"Macau" "" OFF \
			"Magadan" "" OFF \
			"Makassar" "" OFF \
			"Manila" "" OFF \
			"Muscat" "" OFF \
			"Nicosia" "" OFF \
			"Novokuznetsk" "" OFF \
			"Novosibirsk" "" OFF \
			"Omsk" "" OFF \
			"Oral" "" OFF \
			"Phnom_Penh" "" OFF \
			"Pontianak" "" OFF \
			"Pyongyang" "" OFF \
			"Qatar" "" OFF \
			"Qyzylorda" "" OFF \
			"Rangoon" "" OFF \
			"Riyadh" "" OFF \
			"Saigon" "" OFF \
			"Sakhalin" "" OFF \
			"Samarkand" "" OFF \
			"Seoul" "" OFF \
			"Shanghai" "" OFF \
			"Singapore" "" OFF \
			"Srednekolymsk" "" OFF \
			"Taipei" "" OFF \
			"Tashkent" "" OFF \
			"Tbilisi" "" OFF \
			"Tehran" "" OFF \
			"Tel_Aviv" "" OFF \
			"Thimbu" "" OFF \
			"Thimphu" "" OFF \
			"Tokyo" "" OFF \
			"Ujung_Pandang" "" OFF \
			"Ulaanbaatar" "" OFF \
			"Ulan_Bator" "" OFF \
			"Urumqi" "" OFF \
			"Ust-Nera" "" OFF \
			"Vientiane" "" OFF \
			"Vladivostok" "" OFF \
			"Yakutsk" "" OFF \
			"Yekaterinburg" "" OFF     3>&1 1>&2 2>&3)
	done
	;;

	Atlantic)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Azores" "" OFF \
			"Bermuda" "" OFF \
			"Canary" "" OFF \
			"Cape_Verde" "" OFF \
			"Faeroe" "" OFF \
			"Faroe" "" OFF \
			"Jan_Mayen" "" OFF \
			"Madeira" "" OFF \
			"Reykjavik" "" OFF \
			"South_Georgia" "" OFF \
			"St_Helena" "" OFF \
			"Stanley" "" OFF      3>&1 1>&2 2>&3)
	done
	;;

	Australia)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"ACT" "" OFF \
			"Adelaide" "" OFF \
			"Brisbane" "" OFF \
			"Broken_Hill" "" OFF \
			"Canberra" "" OFF \
			"Currie" "" OFF \
			"Darwin" "" OFF \
			"Eucla" "" OFF \
			"Hobart" "" OFF \
			"LHI" "" OFF \
			"Lindeman" "" OFF \
			"Lord_Howe" "" OFF \
			"Melbourne" "" OFF \
			"North" "" OFF \
			"NSW" "" OFF \
			"Perth" "" OFF \
			"Queensland" "" OFF \
			"South" "" OFF \
			"Sydney" "" OFF \
			"Tasmania" "" OFF \
			"Victoria" "" OFF \
			"West" "" OFF \
			"Yancowinna" "" OFF      3>&1 1>&2 2>&3)
	done
	;;

	Europe)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Amsterdam" "" OFF \
			"Andorra" "" OFF \
			"Athens" "" OFF \
			"Belfast" "" OFF \
			"Belgrade" "" OFF \
			"Berlin" "" OFF \
			"Bratislava" "" OFF \
			"Brussels" "" OFF \
			"Bucharest" "" OFF \
			"Budapest" "" OFF \
			"Busingen" "" OFF \
			"Chisinau" "" OFF \
			"Copenhagen" "" OFF \
			"Dublin" "" OFF \
			"Gibraltar" "" OFF \
			"Guernsey" "" OFF \
			"Helsinki" "" OFF \
			"Isle_of_Man" "" OFF \
			"Istanbul" "" OFF \
			"Jersey" "" OFF \
			"Kaliningrad" "" OFF \
			"Kiev" "" OFF \
			"Lisbon" "" OFF \
			"Ljubljana" "" OFF \
			"London" "" OFF \
			"Luxembourg" "" OFF \
			"Madrid" "" OFF \
			"Malta" "" OFF \
			"Mariehamn" "" OFF \
			"Minsk" "" OFF \
			"Monaco" "" OFF \
			"Moscow" "" OFF \
			"Nicosia" "" OFF \
			"Oslo" "" OFF \
			"Paris" "" OFF \
			"Podgorica" "" OFF \
			"Prague" "" OFF \
			"Riga" "" OFF \
			"Rome" "" OFF \
			"Samara" "" OFF \
			"San_Marino" "" OFF \
			"Sarajevo" "" OFF \
			"Simferopol" "" OFF \
			"Skopje" "" OFF \
			"Sofia" "" OFF \
			"Stockholm" "" OFF \
			"Tallinn" "" OFF \
			"Tirane" "" OFF \
			"Tiraspol" "" OFF \
			"Uzhgorod" "" OFF \
			"Vaduz" "" OFF \
			"Vatican" "" OFF \
			"Vienna" "" OFF \
			"Vilnius" "" OFF \
			"Volgograd" "" OFF \
			"Warsaw" "" OFF \
			"Zagreb" "" OFF \
			"Zaporozhye" "" OFF \
			"Zurich" "" OFF      3>&1 1>&2 2>&3)
	done
	;;

	Indian)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Antananarivo" "" OFF \
			"Chagos" "" OFF \
			"Christmas" "" OFF \
			"Cocos" "" OFF \
			"Comoro" "" OFF \
			"Kerguelen" "" OFF \
			"Mahe" "" OFF \
			"Maldives" "" OFF \
			"Mauritius" "" OFF \
			"Mayotte" "" OFF \
			"Reunion" "" OFF      3>&1 1>&2 2>&3)
	done
	;;

	Pacific)
	while [ -z $timePart2 ]
	do
		timePart2=$(whiptail --title  "${TITULO}" --backtitle "${BANNER}" --radiolist \
		"Select the timezone for your Server!" 20 50 12 \
			"Apia" "" OFF \
			"Auckland" "" OFF \
			"Bougainville" "" OFF \
			"Chatham" "" OFF \
			"Chuuk" "" OFF \
			"Easter" "" OFF \
			"Efate" "" OFF \
			"Enderbury" "" OFF \
			"Fakaofo" "" OFF \
			"Fiji" "" OFF \
			"Funafuti" "" OFF \
			"Galapagos" "" OFF \
			"Gambier" "" OFF \
			"Guadalcanal" "" OFF \
			"Guam" "" OFF \
			"Honolulu" "" OFF \
			"Johnston" "" OFF \
			"Kiritimati" "" OFF \
			"Kosrae" "" OFF \
			"Kwajalein" "" OFF \
			"Majuro" "" OFF \
			"Marquesas" "" OFF \
			"Midway" "" OFF \
			"Nauru" "" OFF \
			"Niue" "" OFF \
			"Norfolk" "" OFF \
			"Noumea" "" OFF \
			"Pago_Pago" "" OFF \
			"Palau" "" OFF \
			"Pitcairn" "" OFF \
			"Pohnpei" "" OFF \
			"Ponape" "" OFF \
			"Port_Moresby" "" OFF \
			"Rarotonga" "" OFF \
			"Saipan" "" OFF \
			"Samoa" "" OFF \
			"Tahiti" "" OFF \
			"Tarawa" "" OFF \
			"Tongatapu" "" OFF \
			"Truk" "" OFF \
			"Wake" "" OFF \
			"Wallis" "" OFF \
			"Yap" "" OFF      3>&1 1>&2 2>&3)
	done
	;;
	
esac

}

INSTALA_DEPENDENCIAS ()
{

clear 

echo "Exec Step 2..."
sleep 1

echo "Updatind and upgrading the system..."

yum install epel-release -y

yum update -y

clear

echo "Intalling CentOS packages..."
sleep 1

yum groupinstall "Development Tools" -y

yum install iksemel-devel libcurl-devel net-snmp-devel mariadb-devel fping OpenIPMI-devel libssh2-devel java-1.8.0-openjdk-devel libxml2-devel unixODBC-devel openldap-devel gnutls-devel git python-pip curl net-snmp php-cli php-bcmath php-mbstring php php-mysql php-pdo php-common php-gd httpd php-xml php-ldap php-mcrypt php-xmlrpc mariadb-server php-imap php-soap php-snmp dejavu-fonts-common libtool-ltdl-devel wget -y

pip install zabbix-api

systemctl enable mariadb
service mariadb start
sleep 5
mysql_secure_installation

}

INSTALL ()
{

clear 

echo "Exec Step 3..."
sleep 1


	## Processo de instalação do Zabbix 3.0

	# Criação de usuário e grupo do sistema

	groupadd zabbix

	useradd -g zabbix zabbix

	# Baixando e compilando o zabbix

	cd /tmp

	#wget http://ufpr.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.0.4/zabbix-3.0.4.tar.gz
	#tar -zxvf zabbix-3.0.4.tar.gz
	#cd zabbix-3.0.4

	wget http://tenet.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.2.0/zabbix-3.2.0.tar.gz
	tar -zxvf zabbix-3.2.0.tar.gz
	cd zabbix-3.2.0

	./configure --enable-server --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2 --with-ssh2 --with-ldap --with-iconv --with-gnutls --with-unixodbc --with-openipmi --with-jabber=/usr --enable-ipv6 --prefix=/usr/local/zabbix

	make install

	# Preparando scripts de serviço

	ln -s /usr/local/zabbix/etc /etc/zabbix

	mv misc/init.d/fedora/core5/zabbix* /etc/init.d/

	chmod 755 /etc/init.d/zabbix*
	sed -i 's/ZABBIX_BIN="\/usr\/local\/sbin\/zabbix_server"*/ZABBIX_BIN="\/usr\/local\/zabbix\/sbin\/zabbix_server"/' /etc/init.d/zabbix_server
	sed -i 's/ZABBIX_BIN="\/usr\/local\/sbin\/zabbix_agentd"*/ZABBIX_BIN="\/usr\/local\/zabbix\/sbin\/zabbix_agentd"/' /etc/init.d/zabbix_agentd

	systemctl enable zabbix_server
	systemctl enable zabbix_agentd
	systemctl daemon-reload

	# Adequando arquivos de log de zabbix-server e zabbix-agent
	mkdir /var/log/zabbix
	chown root:zabbix /var/log/zabbix
	chmod 775 /var/log/zabbix

	sed -i 's/LogFile=\/tmp\/zabbix_agentd.log*/LogFile=\/var\/log\/zabbix\/zabbix_agentd.log/' /etc/zabbix/zabbix_agentd.conf
	sed -i 's/LogFile=\/tmp\/zabbix_server.log*/LogFile=\/var\/log\/zabbix\/zabbix_server.log/' /etc/zabbix/zabbix_server.conf
	
	# Habilitando execução de comandos via Zabbix
	sed -i 's/# EnableRemoteCommands=0*/EnableRemoteCommands=1/' /etc/zabbix/zabbix_agentd.conf

	# Preparando o zabbix frontend
	mv frontends/php /var/www/html/zabbix

	timeZone

	echo -e "

Alias /zabbix /var/www/html/zabbix

<Directory "/var/www/html/zabbix">
    Options FollowSymLinks
    AllowOverride None
    Require all granted

    <IfModule mod_php5.c>
        php_value max_execution_time 300
        php_value memory_limit 128M
        php_value post_max_size 16M
        php_value upload_max_filesize 2M
        php_value max_input_time 300
        php_value always_populate_raw_post_data -1
        php_value date.timezone $timePart1/$timePart2
    </IfModule>
</Directory>

<Directory "/var/www/html/zabbix/conf">
    Require all denied
</Directory>

<Directory "/var/www/html/zabbix/app">
    Require all denied
</Directory>

<Directory "/var/www/html/zabbix/include">
    Require all denied
</Directory>

<Directory "/var/www/html/zabbix/local">
    Require all denied
</Directory>

" > /etc/httpd/conf.d/zabbix.conf

	# Reiniciando apache2

	chmod 775 /var/www/html/zabbix -Rf
	chown apache:apache /var/www/html/zabbix -Rf
	service httpd restart


	## Processo de instalação do GLPI
	# Baixando o GLPI
	wget https://github.com/glpi-project/glpi/releases/download/0.90.5/glpi-0.90.5.tar.gz
	tar -zxvf glpi-0.90.5.tar.gz
	mv glpi /var/www/html/

	# Baixando o Webservice
	wget https://forge.glpi-project.org/attachments/download/2099/glpi-webservices-1.6.0.tar.gz
	tar -zxvf glpi-webservices-1.6.0.tar.gz
	mv webservices /var/www/html/glpi/plugins/

	# Baixando o Racks
	wget https://github.com/InfotelGLPI/racks/releases/download/1.6.2/glpi-racks-1.6.2.tar.gz
	tar -zxvf glpi-racks-1.6.2.tar.gz
	mv racks /var/www/html/glpi/plugins/

	# Baixando o DashBoard
	wget https://forge.glpi-project.org/attachments/download/2154/GLPI-dashboard_plugin-0.7.6.tar.gz
	tar -zxvf GLPI-dashboard_plugin-0.7.6.tar.gz
	mv dashboard /var/www/html/glpi/plugins/
	
	# Baixando o MyDashboard
	wget https://github.com/InfotelGLPI/mydashboard/releases/download/1.2.1/glpi-mydashboard-1.2.1.tar.gz
	tar -zxvf glpi-mydashboard-1.2.1.tar.gz
	mv mydashboard /var/www/html/glpi/plugins/mydashboard

	# Baixando Seasonality
	wget https://github.com/InfotelGLPI/seasonality/releases/download/1.1.0/glpi-seasonality-1.1.0.tar.gz
	tar glpi-seasonality-1.1.0.tar.gz
	mv seasonality /var/www/html/glpi/plugins/seasonality

	# Baixando More LDAP
	wget https://github.com/pluginsGLPI/moreldap/releases/download/0.90-0.2.2/glpi-moreldap-0.90-0.2.2.tar.gz
	tar -zxvf glpi-moreldap-0.90-0.2.2.tar.gz
	mv glpi /var/www/html/glpi/plugins/moreldap

	# Baixando SimCard Beta
	wget https://github.com/pluginsGLPI/simcard/archive/1.4.1.tar.gz
	tar -zxvf 1.4.1.tar.gz
	mv simcard-1.4.1 /var/www/html/glpi/plugins/simcard

	# Baixando Hidefields
	wget https://github.com/tomolimo/hidefields/archive/1.0.0.tar.gz
	tar -zxvf 1.0.0.tar.gz
	mv hidefields-1.0.0 /var/www/html/glpi/plugins/hidefields

	# Baixando Form Validation
	wget https://github.com/tomolimo/formvalidation/archive/0.1.2.tar.gz
	tar -zxvf 0.1.2.tar.gz
	mv formvalidation-0.1.2 /var/www/html/glpi/plugins/formvalidation

	# Baixando PDF
	wget https://forge.glpi-project.org/attachments/download/2139/glpi-pdf-1.0.2.tar.gz
	tar -zxvf glpi-pdf-1.0.2.tar.gz
	mv pdf /var/www/html/glpi/plugins/pdf

	# Baixando Data Injection
	wget https://github.com/pluginsGLPI/datainjection/releases/download/2.4.1/glpi-datainjection-2.4.1.tar.gz
	tar -zxvf glpi-datainjection-2.4.1.tar.gz
	mv datainjection /var/www/html/glpi/plugins/datainjection

	# Baixando IP Reports
	wget https://forge.glpi-project.org/attachments/download/2128/glpi-addressing-2.3.0.tar.gz
	tar -zxvf glpi-addressing-2.3.0.tar.gz
	mv addressing /var/www/html/glpi/plugins/addressing

	# Baixando Generic Objects Management
	wget https://github.com/pluginsGLPI/genericobject/archive/0.85-1.0.tar.gz
	tar -zxvf 0.85-1.0.tar.gz
	mv genericobject-0.85-1.0 /var/www/html/glpi/plugins/genericobject

	# Baixando Barscode
	wget https://forge.glpi-project.org/attachments/download/2153/glpi-barcode-0.90+1.0.tar.gz
	tar -zxvf glpi-barcode-0.90+1.0.tar.gz
	mv barcode /var/www/html/glpi/plugins/barcode

	# Baixando Timezones
	#wget https://github.com/tomolimo/timezones/archive/2.0.0.tar.gz
	#tar -zxvf 2.0.0.tar.gz
	#mv timezones-2.0.0 /var/www/html/glpi/plugins/timezones

	# Baixando Monitoring
	wget https://github.com/ddurieux/glpi_monitoring/releases/download/0.90%2B1.1/glpi_monitoring_0.90.1.1.tar.gz
	tar glpi_monitoring_0.90.1.1.tar.gz
	mv monitoring /var/www/html/glpi/plugins/monitoring

	# Baixando Applince
	wget https://forge.glpi-project.org/attachments/download/2147/glpi-appliances-2.1.tar.gz
	tar -zxvf glpi-appliances-2.1.tar.gz
	mv appliances /var/www/html/glpi/plugins/appliances

	# Baixando Certificates Inventory
 	wget https://github.com/InfotelGLPI/certificates/releases/download/2.1.1/glpi-certificates-2.1.1.tar.gz
	tar -zxvf glpi-certificates-2.1.1.tar.gz
	mv certificates /var/www/html/glpi/plugins/certificates

	# Baixando Databases Inventory
	wget https://github.com/InfotelGLPI/databases/releases/download/1.8.1/glpi-databases-1.8.1.tar.gz
	tar -zxvf glpi-databases-1.8.1.tar.gz
	mv databases /var/www/html/glpi/plugins/databases

	# Baixando Domains
	wget https://github.com/InfotelGLPI/domains/releases/download/1.7.0/glpi-domains-1.7.0.tar.gz
	tar -zxvf glpi-domains-1.7.0.tar.gz
	mv domains /var/www/html/glpi/plugins/domains

	# Baixando Human Resources Management
	wget https://github.com/InfotelGLPI/resources/releases/download/2.2.1/glpi-resources-2.2.1.tar.gz
	tar -zxvf glpi-resources-2.2.1.tar.gz
	mv resources /var/www/html/glpi/plugins/resources

	# Baixando Web Applications Inventory
 	wget https://github.com/InfotelGLPI/webapplications/releases/download/2.1.1/glpi-webapplications-2.1.1.tar.gz
	tar -zxvf glpi-webapplications-2.1.1.tar.gz
	mv webapplications /var/www/html/glpi/plugins/webapplications

	# Baixando Order Management
	wget https://github.com/pluginsGLPI/order/archive/0.85+1.1.tar.gz
	tar -zxvf 0.85+1.1.tar.gz
	mv order-0.85-1.1 /var/www/html/glpi/plugins/order

	# Baixando Inventory Number Generation
 	wget https://github.com/pluginsGLPI/geninventorynumber/releases/download/0.85%2B1.0/glpi-geninventorynumber-0.85.1.0.tar.gz
	tar -zxvf glpi-geninventorynumber-0.85.1.0.tar.gz
	mv geninventorynumber /var/www/html/glpi/plugins/geninventorynumber

	# Baixando GLPI Connections BETA4 0.90-1.7.3
 	wget https://github.com/pluginsGLPI/connections/releases/download/0.90-1.7.3/glpi-connections-0.90-1.7.3.tar.gz
	tar -zxvf glpi-connections-0.90-1.7.3.tar.gz
	mv connections /var/www/html/glpi/plugins/connections

	# Baixando GLPI Renamer 0.90-1.0
	wget https://github.com/pluginsGLPI/renamer/releases/download/0.90-1.0/glpi-renamer-0.90-1.0.tar.gz
	tar -zxvf glpi-renamer-0.90-1.0.tar.gz
	mv renamer /var/www/html/glpi/plugins/renamer

	# Baixando Behaviors
	wget https://forge.glpi-project.org/attachments/download/2124/glpi-behaviors-1.0.tar.gz
	tar -zxvf glpi-behaviors-1.0.tar.gz
	mv behaviors /var/www/html/glpi/plugins/behaviors

	# Baixando Ticket Cleaner
	wget https://github.com/tomolimo/ticketcleaner/archive/2.0.4.tar.gz
	tar -zxvf 2.0.4.tar.gz
	mv ticketcleaner-2.0.4 /var/www/html/glpi/plugins/ticketcleaner

	# Baixando Escalation
	wget https://forge.glpi-project.org/attachments/download/2150/glpi-escalation-0.90+1.0.tar.gz
	tar -zxvf glpi-escalation-0.90+1.0.tar.gz
	mv escalation /var/www/html/glpi/plugins/escalation

	# Baixando News
	wget https://github.com/pluginsGLPI/news/releases/download/0.90-1.3/glpi-news-0.90-1.3.tar.gz
	tar -zxvf glpi-news-0.90-1.3.tar.gz
	mv news /var/www/html/glpi/plugins/news

	# Baixando Historical purge
	wget https://github.com/pluginsGLPI/purgelogs/releases/download/0.85%2B1.1/glpi-purgelogs-0.85-1.1.tar.gz
	tar -zxvf glpi-purgelogs-0.85-1.1.tar.gz
	mv purgelogs-0.85-1.1 /var/www/html/glpi/plugins/purgelogs

	# Baixando Escalade 
	wget https://github.com/pluginsGLPI/escalade/releases/download/0.90-1.2/glpi-escalade-0.90-1.2.tar.gz
	tar -zxvf glpi-escalade-0.90-1.2.tar.gz
	mv escalade /var/www/html/glpi/plugins/escalade

	# Baixando ITIL Category Groups
	wget https://github.com/pluginsGLPI/itilcategorygroups/releases/download/0.90%2B1.0.3/glpi-itilcategorygroups-0.90-1.0.3.tar.gz
	tar -zxvf glpi-itilcategorygroups-0.90-1.0.3.tar.gz
	mv itilcategorygroups /var/www/html/glpi/plugins/itilcategorygroups

	# Baixando Consumables
	wget https://github.com/InfotelGLPI/consumables/releases/download/1.1.0/glpi-consumables-1.1.0.tar.gz
	tar -zxvf glpi-consumables-1.1.0.tar.gz
	mv consumables /var/www/html/glpi/plugins/consumables

	# Baixando PrinterCounters
	wget https://github.com/InfotelGLPI/printercounters/releases/download/1.2.1/glpi-printercounters-1.2.1.tar.gz
	tar -zxvf glpi-printercounters-1.2.1.tar.gz
	mv printercounters /var/www/html/glpi/plugins/printercounters

	# Baixando Financial Reports
	wget https://github.com/InfotelGLPI/financialreports/releases/download/2.2.1/glpi-financialreports-2.2.1.tar.gz
	tar -zxvf glpi-financialreports-2.2.1.tar.gz
	mv financialreports /var/www/html/glpi/plugins/financialreports

	# Baixando Timelineticket
	wget https://github.com/pluginsGLPI/timelineticket/releases/download/0.90%2B1.0/glpi-timelineticket-0.90.1.0.tar.gz
	tar -zxvf glpi-timelineticket-0.90.1.0.tar.gz
	mv timelineticket /var/www/html/glpi/plugins/timelineticket

	# Baixando Accounts Inventory
	wget https://github.com/InfotelGLPI/accounts/releases/download/2.1.1/glpi-accounts-2.1.1.tar.gz
	tar -zxvf glpi-accounts-2.1.1.tar.gz
	mv  accounts /var/www/html/glpi/plugins/accounts

	# Baixando FusionInventory
	wget "https://github.com/fusioninventory/fusioninventory-for-glpi/releases/download/glpi090%2B1.4/fusioninventory-for-glpi_0.90.1.4.tar.gz"
	tar -zxvf "fusioninventory-for-glpi_0.90.1.4.tar.gz"
	mv fusioninventory /var/www/html/glpi/plugins/fusioninventory

	# Adequando Apache
	
	echo -e "<Directory \"/var/www/html/glpi\">
    AllowOverride All
</Directory>

" > /etc/httpd/conf.d/glpi.conf

	# Reiniciando apache2

	chmod 775 /var/www/html/glpi -Rf
	chown apache:apache /var/www/html/glpi -Rf

	chcon -Rv --type=httpd_sys_content_t /var/www/html

	setsebool -P httpd_can_network_connect=1
	setsebool -P httpd_can_network_connect_db=1
	setsebool -P httpd_can_sendmail=1

	setsebool -P zabbix_can_network=1
	setsebool -P httpd_unified=1

	chmod +x /var/www/html/zabbix/conf/

	service httpd restart

}

SQL ()
{


clear 

echo "Exec Step 4..."
echo "Creating Data Base for systems.."
sleep 1


test_connection=1

while [ $test_connection != 0 ]
do

rootPWD_SQL=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --passwordbox "Step 4 - Enter the root password for the MariaDB database" --fb 10 50 3>&1 1>&2 2>&3) 

mysql -uroot -p$rootPWD_SQL -e "" 2> /dev/null

test_connection=$?

	if [ $test_connection != 0 ]
	then
whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "

Step 4 - Error! The root password entered is not valid. Try again!
" --fb 0 0 0
	fi
done

zabbixPWD_SQL1=0
zabbixPWD_SQL2=1

while [ $zabbixPWD_SQL1 != $zabbixPWD_SQL2 ]
do

	zabbixPWD_SQL1=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --passwordbox "Step 4 - Enter the user's password zabbix to the Database." --fb 10 50 3>&1 1>&2 2>&3) 

	zabbixPWD_SQL2=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --passwordbox "Step 4 - Confirm password zabbix user to the Database." --fb 10 50 3>&1 1>&2 2>&3)
	
	if [ $zabbixPWD_SQL1 != $zabbixPWD_SQL2 ]
	then
whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "

Step 4 - Error! Informed passwords do not match. Try again.
" --fb 0 0 0

	fi
done

glpiPWD_SQL1=0
glpiPWD_SQL2=1

while [ $glpiPWD_SQL1 != $glpiPWD_SQL2 ]
do

	glpiPWD_SQL1=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --passwordbox "Step 4 - Enter the user's password glpi to the Database." --fb 10 50 3>&1 1>&2 2>&3) 

	glpiPWD_SQL2=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --passwordbox "Step 4 - Confirm password glpi user to the Database." --fb 10 50 3>&1 1>&2 2>&3)
	
	if [ $glpiPWD_SQL1 != $glpiPWD_SQL2 ]
	then
whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "

Step 4 - Error! Informed passwords do not match. Try again.
" --fb 0 0 0

	fi
done

# Criando a base de dados glpi
echo "Creating glpi database..."
mysql -u root -p$rootPWD_SQL -e "create database glpi character set utf8";
echo "Creating glpi user at MariaDB Database..."
mysql -u root -p$rootPWD_SQL -e "create user 'glpi'@'localhost' identified by '$glpiPWD_SQL1'";
echo "Making glpi user the owner to glpi database..."
mysql -u root -p$rootPWD_SQL -e "grant all on glpi.* to glpi with grant option";
sleep 2

# Criando a base de dados zabbix
echo "Creating zabbix database..."
mysql -u root -p$rootPWD_SQL -e "create database zabbix character set utf8";
echo "Creating zabbix user at MariaDB Database..."
mysql -u root -p$rootPWD_SQL -e "create user 'zabbix'@'localhost' identified by '$zabbixPWD_SQL1'";
echo "Making zabbix user the owner to glpi database..."
mysql -u root -p$rootPWD_SQL -e "grant all on zabbix.* to zabbix with grant option";
sleep 2

# Configurando /etc/zabbix/zabbix_server.conf

sed -i 's/# DBPassword=/DBPassword='$zabbixPWD_SQL1'/' /etc/zabbix/zabbix_server.conf
sed -i 's/# FpingLocation=\/usr\/sbin\/fping/FpingLocation=\/usr\/bin\/fping/' /etc/zabbix/zabbix_server.conf

chmod +s /usr/bin/ping
chmod +s /usr/sbin/fping
chmod +s /usr/bin/ping6
chmod +s /usr/sbin/fping6

# Avisar que a base está sendo populada....
# Popular base zabbix

cd database/mysql/
echo "Creating Zabbix Schema at MariaDB..."
mysql -uroot -p$rootPWD_SQL zabbix < schema.sql
echo "Importing zabbix images to MariaDB..."
mysql -uroot -p$rootPWD_SQL zabbix < images.sql
echo "Importing all Zabbix datas to MariaDB..."
mysql -uroot -p$rootPWD_SQL zabbix < data.sql
sleep 1

# Inicializando os serviços 

echo "Now re-initiate services Zabbix Server and Agent..."
service zabbix_agentd start
service zabbix_server start

}

INTEGRA ()
{

clear 

echo "Exec Step 5..."
echo "Making Systems Integration..."
sleep 1

git clone $linkJanssen
mv zabbix-glpi/*zabbix* $externalScriptsDir
chmod 775 $externalScriptsDir -Rf
chown zabbix:zabbix $externalScriptsDir -Rf

}

TextoFinal ()
{
clear

whiptail --title "${TITULO}" --backtitle "${BANNER}" --msgbox "

Copyright:
- Verdanatech Solucoes em TI, $versionDate
- Conectys Tecnologia da Informacao, $versionDate
Thank you for using our script. We are at your disposal to contact.
$devMail

PATHS: 
All Zabbix binary and configuration files have been installed in: /usr/local
The Zabbix FrontEnd and GLPI are in /var/www/html/
To access GLPI, try http://$serverAddress/glpi
To access Zabbix, try http://$serverAddress/zabbix

"  --fb 0 0 0

}



# Script start

clear

[ ! -e /usr/bin/whiptail ] && { INSTALA_WHIPTAIL; }

menuPrincipal

while true
do
case $menu01Option in

	1)
		reqsToUse
		INSTALA_DEPENDENCIAS
		INSTALL
		SQL
		INTEGRA
		TextoFinal
		kill $$
		
	;;
	
	2)
		INFORMATION
		menuPrincipal
	;;
		

	3)
		showCredits
		menuPrincipal
	;;
	
	4)
		TextoFinal
		kill $$
	;;

esac
done
