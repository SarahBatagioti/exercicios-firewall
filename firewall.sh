# 1. Verificar Status:
# Como verificar o status atual do firewall e quais regras estão ativas? (em UFW e iptables).
sudo ufw status verbose
sudo iptables -L -n -v
sudo iptables -S

# 2. Habilitar e Desabilitar:
# Como habilitar o UFW? E como desabilitar?
# Por que iptables não tem um comando enable/disable simples? O que fazer em vez disso?
sudo ufw enable
sudo ufw disable
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F

# 3. Política Padrão (Entrada):
# Como configurar a política padrão para negar (DROP/DENY) todo o tráfego que entra (INPUT)?
sudo ufw default deny incoming
sudo iptables -P INPUT DROP

# 4. Política Padrão (Saída):
# Como configurar a política padrão para permitir (ALLOW) todo o tráfego que sai (OUTPUT)?
sudo ufw default allow outgoing
sudo iptables -P OUTPUT ACCEPT

# 5. Liberar SSH (TCP):
# Como permitir conexões de entrada na porta 22/tcp (SSH)?
sudo ufw allow in 22/tcp
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# 6. Liberar HTTP (TCP):
# Como permitir conexões de entrada na porta 80/tcp (HTTP)?
sudo ufw allow in 80/tcp
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# 7. Liberar TCP Porta Alta:
# Como permitir conexões de entrada na porta 8080/tcp (uma porta comum para aplicações web/API)?
sudo ufw allow in 8080/tcp
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT

# 8. Liberar DNS (UDP):
# Como permitir conexões de entrada na porta 53/udp (DNS)?
sudo ufw allow in 53/udp
sudo iptables -A INPUT -p udp --dport 53 -j ACCEPT

# 9. Bloquear Porta (Deny/Drop):
# Como negar (DENY/DROP) explicitamente o tráfego de entrada na porta 3306/tcp (MySQL), fazendo o pacote desaparecer?
sudo ufw deny in 3306/tcp
sudo iptables -A INPUT -p tcp --dport 3306 -j DROP

# 10. Rejeitar Porta (Reject):
# Como rejeitar (REJECT) explicitamente o tráfego de entrada na porta 5432/tcp (PostgreSQL), informando ativamente ao remetente que a porta está fechada?
sudo ufw reject in 5432/tcp
sudo iptables -A INPUT -p tcp --dport 5432 -j REJECT --reject-with tcp-reset

# 11. Bloquear um IP:
# Como bloquear todo o tráfego de entrada vindo do endereço IP 1.2.3.4?
sudo ufw deny in from 1.2.3.4
sudo iptables -A INPUT -s 1.2.3.4 -j DROP

# 12. Liberar Porta para um IP Específico:
# Como permitir o acesso à porta 22/tcp (SSH) apenas para o endereço IP 192.168.1.100?
sudo ufw insert 1 allow in from 192.168.1.100 to any port 22 proto tcp
sudo ufw insert 2 deny in to any port 22 proto tcp
sudo iptables -I INPUT 1 -p tcp -s 192.168.1.100 --dport 22 -j ACCEPT
sudo iptables -I INPUT 2 -p tcp --dport 22 -j DROP

# 13. Liberar Porta para uma Interface Específica:
# Como permitir o acesso à porta 3306 (MySQL) apenas se a conexão vier da sua rede interna (interface eth1)?
sudo ufw insert 1 allow in on eth1 to any port 3306 proto tcp
sudo ufw insert 2 deny in to any port 3306 proto tcp
sudo iptables -I INPUT 1 -i eth1 -p tcp --dport 3306 -j ACCEPT
sudo iptables -I INPUT 2 -p tcp --dport 3306 -j DROP

# 14. Bloquear Pacotes Inválidos (iptables):
# Como bloquear pacotes que são considerados INVALID?
sudo iptables -I INPUT 1 -m conntrack --ctstate INVALID -j DROP