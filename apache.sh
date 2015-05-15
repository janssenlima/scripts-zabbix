#!/bin/bash
#######################################################################################################
# Autor: Janssen dos Reis Lima                                                                        #
# Data atualizacao: 15/05/2015                                                                        #
# Changelog:                                                                                          #
#   - Inclusão de CPULoad após atualização do Apache ter adicionado essa métrica no server-status     #
#######################################################################################################
host="localhost"
resposta=0
tmp="/opt/zabbix/tmp/apache_status"
pega_status=`wget --quiet -O $tmp http://$host/server-status?auto`
case $1 in
   TotalAccesses)
      $pega_status
      fgrep "Total Accesses:" $tmp | awk '{print $3}'
      resposta=$?;;
   TotalKBytes)
      $pega_status
      fgrep "Total kBytes:" $tmp | awk '{print $3}'
      resposta=$?;;
   CPULoad)
      $pega_status
      fgrep "CPULoad:" $tmp | awk '{print $2}'
      resposta=$?;;
   Uptime)
      $pega_status
      fgrep "Uptime:" $tmp | awk '{print $2}'
      resposta=$?;;
   ReqPerSec)
      $pega_status
      fgrep "ReqPerSec:" $tmp | awk '{print $2}'
      resposta=$?;;
   BytesPerSec)
      $pega_status
      fgrep "BytesPerSec:" $tmp | awk '{print $2}'
      resposta=$?;;
   BytesPerReq)
      $pega_status
      fgrep "BytesPerReq:" $tmp | awk '{print $2}'
      resposta=$?;;
   BusyWorkers)
      $pega_status
      fgrep "BusyWorkers:" $tmp | awk '{print $2}'
      resposta=$?;;
   IdleWorkers)
      $pega_status
      fgrep "IdleWorkers:" $tmp | awk '{print $2}'
      resposta=$?;;
   WaitingForConnection)
      $pega_status
      fgrep "Scoreboard:" $tmp | awk '{print $2}'| awk 'BEGIN { FS = "_" } ; { print NF-1 }'
      resposta=$?;;
   StartingUp)
      $pega_status
      fgrep "Scoreboard:" $tmp | awk '{print $2}'| awk 'BEGIN { FS = "S" } ; { print NF-1 }'
      resposta=$?;;
   ReadingRequest)
      $pega_status
      fgrep "Scoreboard:" $tmp| awk '{print $2}'| awk 'BEGIN { FS = "R" } ; { print NF-1 }'
      resposta=$?;;
   SendingReply)
      $pega_status
      fgrep "Scoreboard:" $tmp | awk '{print $2}'| awk 'BEGIN { FS = "W" } ; { print NF-1 }'
      resposta=$?;;
   KeepAlive)
      $pega_status
      fgrep "Scoreboard:" $tmp | awk '{print $2}'| awk 'BEGIN { FS = "K" } ; { print NF-1 }'
      resposta=$?;;
   DNSLookup)
      $pega_status
      fgrep "Scoreboard:" $tmp | awk '{print $2}'| awk 'BEGIN { FS = "D" } ; { print NF-1 }'
      resposta=$?;;
   ClosingConnection)
      $pega_status
      fgrep "Scoreboard:" $tmp | awk '{print $2}'| awk 'BEGIN { FS = "C" } ; { print NF-1 }'
      resposta=$?;;
   Logging)
      $pega_status
      fgrep "Scoreboard:" $tmp | awk '{print $2}'| awk 'BEGIN { FS = "L" } ; { print NF-1 }'
      resposta=$?;;
   GracefullyFinishing)
      $pega_status
      fgrep "Scoreboard:" $tmp | awk '{print $2}'| awk 'BEGIN { FS = "G" } ; { print NF-1 }'
      resposta=$?;;
  IdleCleanupOfWorker)
      $pega_status
      fgrep "Scoreboard:" $tmp | awk '{print $2}'| awk 'BEGIN { FS = "I" } ; { print NF-1 }'
      resposta=$?;;
  OpenSlotWithNoCurrentProcess)
      $pega_status
      fgrep "Scoreboard:" $tmp | awk '{print $2}'| awk 'BEGIN { FS = "." } ; { print NF-1 }'
      resposta=$?;;
   *)
      echo "ZBX_NOTSUPPORTED"
esac
if [ "$resposta" -ne 0 ]; then
   echo "ZBX_NOTSUPPORTED"
fi
exit $resposta
