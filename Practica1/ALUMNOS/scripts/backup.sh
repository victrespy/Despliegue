#!/bin/sh
set -e

# Establecer valores por defecto (en caso de no estar en el .env)
: "${SLEEP_SECONDS:=60}"
: "${MYSQL_HOST:=db}" # El nombre del servicio de la BD
: "${MYSQL_USER:=root}"
: "${MYSQL_PASSWORD:=rootpass}"
: "${MYSQL_DATABASE:=testdb}"

echo "[backup] Iniciando ciclo (cada $SLEEP_SECONDS s) contra ${MYSQL_HOST}/${MYSQL_DATABASE}"

while true; do
  TS=$(date +%F-%H%M%S)
  FILE="/backups/backup-$TS.sql"
  
  echo "[backup] Generando $FILE ..."
  mariadb-dump -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --databases "$MYSQL_DATABASE" --skip-ssl > "$FILE"
  echo "[backup] OK -> $FILE"
  
  sleep "$SLEEP_SECONDS"
done