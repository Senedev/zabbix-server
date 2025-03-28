#!/bin/bash

# AUTOR:            Guilherme Henrique de Sene Oliveira
# CONTATO:          <guihenriquesene@gmail.com>
# DATA CRIAÇÃO:     08 Outubro 2024

# ======================

# [Controles]
ATUALIZAR=1
MYSQL=1
ZABBIX=1

# [Variáveis]
URL_ZABBIX="https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-2+ubuntu24.04_all.deb"
MYSQL_ROOT_PASSWORD=""
ZABBIX_PASSWORD="XlJX1Z40&w[N"

# ======================

# Etapa 0: Atualizando o sistema e seus pacotes
if [[ "$ATUALIZAR" -eq 1 ]]; then
    echo -e "\e[33mEtapa 0: Atualizando o sistema e seus pacotes\e[0m"
    echo "Iniciando o processo de atualização..."
    sudo apt update && sudo apt upgrade -y
    sudo apt full-upgrade -y
    if ! sudo apt update && sudo apt upgrade -y; then
        echo "Ocorreu um erro ao atualizar o sistema!"
        exit 1
    fi
    echo -e "\e[92mO sistema operacional e seus pacotes foram atualizados com sucesso!\e[0m"
    echo ""
fi

# Etapa 1: Instalando o MySQL Server e fazendo a configuração
if [[ "$MYSQL" -eq 1 ]]; then
    echo -e "\e[33mEtapa 1: Instalando o MySQL Server e fazendo a configuração\e[0m"
    echo "Iniciando o processo de instalação e configuração do banco de dados..."
    sudo apt install mysql-server -y
    echo -e "\e[92mO banco de dados foi instalado com sucesso!\e[0m"
    echo "Iniciando o processo de configuração do MySQL Server..."
    expect -c "
    set timeout 10
    spawn mysql_secure_installation
    expect \"Enter current password for root (enter for none):\"
    send \"$MYSQL_ROOT_PASSWORD\r\"
    expect \"Set root password?\"
    send \"Y\r\"
    expect \"New password:\"
    send \"$MYSQL_ROOT_PASSWORD\r\"
    expect \"Remove anonymous users?\"
    send \"Y\r\"
    expect \"Disallow root login remotely?\"
    send \"Y\r\"
    expect \"Remove test database and access to it?\"
    send \"Y\r\"
    expect \"Reload privilege tables now?\"
    send \"Y\r\"
    expect eof"
    echo -e "\e[92mO MySQL Server foi instalado e configurado com sucesso!\e[0m"
    echo ""
fi

# Etapa 2: Baixando e instalando o Zabbix Server
if [[ "$ZABBIX" -eq 1 ]]; then
    echo -e "\e[33mEtapa 2: Baixando e instalando o Zabbix server\e[0m"
    echo "Fazendo o download da versão mais recente do Zabbix..."
    wget $URL_ZABBIX
    echo "Instalando a aplicação..."
    sudo dpkg -i *.deb
    sudo apt --fix-broken install -y
    sudo apt update
    sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
    mysql -uroot <<EOF
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '$ZABBIX_PASSWORD';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
EOF
    zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p$ZABBIX_PASSWORD zabbix
    sudo mysql -uroot -p$ZABBIX_PASSWORD
    mysql -uroot <<EOF
SET GLOBAL log_bin_trust_function_creators = 0;
EOF
    sudo cp /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf.bkp
    sudo sed -i "s/DBPassword=password/DBPassword=$ZABBIX_PASSWORD/g" /etc/zabbix/zabbix_server.conf
    sudo systemctl restart zabbix-server zabbix-agent apache2
    sudo systemctl enable zabbix-server zabbix-agent apache2
    sudo sed -i 's/^# *//' /etc/locale.gen
    sudo locale-gen
    sudo service apache2 restart
    sudo apt install nmap -y
    echo "zabbix ALL=(root) NOPASSWD: /usr/bin/nmap" | sudo tee -a /etc/sudoers 
    echo -e "\e[92mO Zabbix foi instalado e configurado com sucesso!\e[0m"
    echo -e ""
    echo "Acesse o endereço http://SEUIP/zabbix para utilizar o serviço!"
    echo ""
fi
