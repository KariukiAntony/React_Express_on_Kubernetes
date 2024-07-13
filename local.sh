#! /bin/bash 

set -e
mv ./.env.example ./.env

docker compose up -d --build 