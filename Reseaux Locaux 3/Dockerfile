# Utilise une image alpine comme base
FROM ubuntu:latest

# Installez le serveur DHCP et autres dépendances nécessaires
RUN apt add --no-cache dhcp

# Créer le fichier de leases pour DHCP
RUN mkdir -p /var/lib/dhcp && touch /var/lib/dhcp/dhcpd.leases

# Copie de la configuration dhcpd.conf
COPY dhcpd.conf /etc/dhcp/dhcpd.conf

# Commande à exécuter pour lancer dhcpd
CMD ["/usr/sbin/dhcpd", "-4", "-f", "-d", "--no-pid", "-cf", "/etc/dhcp/dhcpd.conf"]

# Expose le port UDP 67 pour le serveur DHCP
EXPOSE 67/udp
