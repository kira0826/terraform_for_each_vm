#!/bin/bash

INPUT_FILE="output_ip.txt"
ANSIBLE_HOSTS="/home/zai/Documents/semester7/automatizacion/tallerSubir/ansible-pipeline/inventory/hosts.ini"
NGINX_CONF="/home/zai/Documents/semester7/automatizacion/tallerSubir/ansible-pipeline/roles/enable_nginx/templates/nginx-site.conf.j2"

# Extraer IPs
while IFS= read -r line; do
    if [[ $line =~ \"ip\"[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
        ip=${BASH_REMATCH[1]}
    elif [[ $line =~ \"name\"[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
        name=${BASH_REMATCH[1]}
        case $name in
            "frontend-public-ip") frontend_ip=$ip ;;
            "pipelines-public-ip") pipeline_ip=$ip ;;
        esac
    fi
done < "$INPUT_FILE"

# 1. Update ansible hosts.
sed -i "/^\[azure_vm_frontend\]$/{n;s/^[^ ]*/$frontend_ip/}" "$ANSIBLE_HOSTS"
sed -i "/^\[azure_vm_pipeline\]$/{n;s/^[^ ]*/$pipeline_ip/}" "$ANSIBLE_HOSTS"

# 2. Update Nginx conf (Replace all after "server_name")
sed -i "/server_name/s/server_name.*/server_name $frontend_ip;/" "$NGINX_CONF"

# Verification
echo -e "\n=== Nginx conf updated ==="
grep "server_name" "$NGINX_CONF"    
  


CONFIG_FILE="/home/zai/Documents/semester7/automatizacion/tallerSubir/ansible-pipeline/roles/jenkins/defaults/main.yml"

# Setting devops vm ip on Jenkins vars.
sed -i "s|^\(devops_vm_ip:\s*\).*|\1$pipeline_ip|" "$CONFIG_FILE"

# Verification
echo -e "\n=== Setting DEVOPS vm ip on Jenkins folder ==="
grep "devops_vm_ip:" "$CONFIG_FILE"

# Setting frontend vm ip on Jenkins vars.

sed -i "s|^\(frontend_ip:\s*\).*|\1$frontend_ip|" "$CONFIG_FILE"

# Verificación
echo -e "\n=== Setting FRONTEND vm ip on Jenkins folder ==="

grep "frontend_ip:" "$CONFIG_FILE"

# ---------------- Setting sonarqube IPs ------------------


CONFIG_FILE="/home/zai/Documents/semester7/automatizacion/tallerSubir/ansible-pipeline/roles/sonarqube/defaults/main.yml"

# Setting devops vm ip on Jenkins vars.
sed -i "s|^\(devops_vm_ip:\s*\).*|\1$pipeline_ip|" "$CONFIG_FILE"

# Verification
echo -e "\n=== Setting DEVOPS vm ip on Sonarqube folder ==="
grep "devops_vm_ip:" "$CONFIG_FILE"


