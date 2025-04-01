#!/bin/bash

INPUT_FILE="output_ip.txt"
ANSIBLE_HOSTS="/home/zai/Documents/semester7/automatizacion/tallerSubir/ansible-pipeline/inventory/host.ini"

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

# Actualizar solo la IP en cada sección
sed -i "/^\[azure_vm_frontend\]$/{n;s/^[^ ]*/$frontend_ip/}" "$ANSIBLE_HOSTS"
sed -i "/^\[azure_vm_pipeline\]$/{n;s/^[^ ]*/$pipeline_ip/}" "$ANSIBLE_HOSTS"

echo "IPs actualizadas:"
grep -E "^\[azure_vm_|^[0-9]" "$ANSIBLE_HOSTS"
