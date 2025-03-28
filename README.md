
# Instalação Automatizada do Zabbix Server em Ubuntu/Debian

## O que é o script?

Este é um script automatizado para a instalação e configuração do Zabbix Server em servidores Ubuntu e Debian. O script realiza o download, instalação, e configuração completa do Zabbix Server, incluindo a criação de banco de dados e usuário MySQL, além da configuração de firewall e outras etapas essenciais para o funcionamento do Zabbix.

## Funcionalidades Principais

O script oferece as seguintes funcionalidades para configurar o Zabbix Server de maneira automatizada:

- Download da versão mais recente do Zabbix Server.
- Instalação de pacotes necessários, como o Zabbix Server, Frontend PHP e o agente Zabbix.
- Criação automática de banco de dados e usuário MySQL para o Zabbix.
- Aplicação de configurações específicas no arquivo de configuração do Zabbix.
- Reinicialização automática dos serviços necessários após a configuração.
- Configuração de permissões de uso do Nmap para o Zabbix.

## Como Executar

### No Ubuntu ou Debian

1. **Baixar o script:**

   Clone o repositório ou faça o download do script diretamente:

   ```bash
   git clone https://github.com/Senedev/zabbix-server.git
   ```

2. **Dar permissão de execução ao script:**

   Navegue até o diretório onde o script está localizado e use o seguinte comando:

   ```bash
   chmod +x zabbix-autoinstall.sh
   ```

3. **Editar as opções de configuração:**

   O script possui variáveis configuráveis no início do arquivo, como as senhas do MySQL e Zabbix. Você pode editar essas opções diretamente no início do arquivo `zabbix-autoinstall.sh` para ajustar conforme suas necessidades.

4. **Executar o script:**

   Para iniciar a instalação e configuração do Zabbix Server, use o comando:

   ```bash
   sudo ./zabbix-autoinstall.sh
   ```

5. **Acompanhar as etapas:**

   O script realiza operações como a criação do banco de dados MySQL, configuração do arquivo `zabbix_server.conf`, reinicialização de serviços, entre outros. Cada etapa será exibida no terminal para acompanhamento.

## Requisitos

- **Sistema Operacional:** Ubuntu 18.04 ou superior, Debian 10 ou superior.
- **Permissões:** A execução requer privilégios de superusuário (root ou sudo)
