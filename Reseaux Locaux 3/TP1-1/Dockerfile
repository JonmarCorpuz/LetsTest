FROM ubuntu:latest

# Mettre à jour les paquets et installer Nginx, Vim, Lynx et Gimp
RUN apt-get update && apt-get install -y \
    nginx \
    vim \
    lynx \
    gimp

# Ajouter une page web simple avec votre nom et prénom
RUN echo "Bienvenue, [Votre Nom] [Votre Prénom]" > /var/www/html/index.html

# Exposer le port 80 pour le trafic HTTP
EXPOSE 80

# Lancer Nginx en arrière-plan
CMD ["nginx", "-g", "daemon off;"]