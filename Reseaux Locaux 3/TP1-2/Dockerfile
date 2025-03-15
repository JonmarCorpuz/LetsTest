# Utiliser l'image CentOS la plus récente comme base pour l'image Docker
FROM centos:latest

# Corriger les dépôts pour utiliser vault.centos.org
RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/CentOS-*.repo && \
    sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/CentOS-*.repo && \
    sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/CentOS-*.repo

# Mettre à jour les paquets et installer httpd et net-tools
RUN yum update -y && yum -y install httpd net-tools

# Créer un index.html simple pour tester le serveur
RUN echo "<html><body><h1>Bienvenue sur le serveur CentOS!</h1></body></html>" > /var/www/html/index.html

# Assurer les bonnes permissions pour le répertoire web
RUN chmod -R 755 /var/www/html && chown -R apache:apache /var/www/html

# Ouvrir le port 80 pour le serveur web
EXPOSE 80

# Démarrer le serveur Apache en mode foreground pour garder le conteneur actif
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]