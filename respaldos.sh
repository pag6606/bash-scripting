#!/bin/bash
fecha=`date +"%d-%m-%Y"`
hora=`date +"%H:%M"`
dialog --title "Backup" --msgbox "Respaldo de web.  Presiones <Enter> \ to start backup or <Esc> to cancel." 10 50
# Return status of non-zero indicates cancel
if [ "$?" != "0" ]
then
  dialog --title "Backup" --msgbox "Backup cancelado." 10 50
else
  dialog --title "Backup" --infobox "Backup en proceso..." 10 50
  cd /var/www/html
  # respaldando y comprimiendo
  tar -czf web$fecha.tar.gz web/* > /tmp/ERRORS$$ 2>&1
  # moviendo a carpeta de respaldos
  mv web$fecha.tar.gz /respaldos/web
  #registrando proceso
  echo "Respaldo web exitoso: "$fecha"-"$hora >> /root/registros/respaldos.txt

  # zero status indicates backup was successfuil
  if [ "$?" = "0" ]
    then
    dialog --title "Backup" --textbox /root/registros/respaldos.txt 22 72
    # Mark script with current date and time
  else
    # Backup failed, display error log
    dialog --title "Backup" --msgbox "Backup fallido \ -- Presione <Enter>
    to see error log." 10 50
   dialog --title "Error Log" --textbox /tmp/ERRORS$$ 22 72
  fi
fi
rm -f /tmp/ERRORS$$
clear

