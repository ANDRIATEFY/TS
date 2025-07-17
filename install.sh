#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\e[1;36m🔧 Installation des dépendances et outils nécessaires pour TS\e[0m"

# Fonction pour vérifier si un module Python est installé (par pip, pas juste import)
pkg install python
is_pip_installed() {
    python3 -m pip show "$1" >/dev/null 2>&1
}
# Fonction pour rendre tous les scripts exécutables dans le dossier du script
set_executable_rights() {
    local thisdir
    thisdir="$(dirname "$(realpath "$0")")"
    for f in "$thisdir"/*.sh "$thisdir"/*.py "$thisdir"/*.bin; do
        [ -e "$f" ] && chmod +x "$f"
    done
}

# Mise à jour système
echo -e "\e[1;34m[•] Mise à jour de Termux...\e[0m"
pkg update -y && pkg upgrade -y

# Installation des paquets système
echo -e "\e[1;34m[•] Installation des paquets Termux requis...\e[0m"
pkg install -y python git ncurses-utils libjpeg-turbo zlib sqlite rust

# Autorisation du stockage
echo -e "\e[1;34m[•] Autorisation de stockage...\e[0m"
termux-setup-storage

# Mise à jour pip et installation de base
echo -e "\e[1;34m[•] Mise à jour de pip et bibliothèques essentielles...\e[0m"
pip install --upgrade pip setuptools wheel filelock

# Liste des modules à vérifier/installer
PIP_MODULES=(telethon requests rich termcolor pillow cryptography instagrapi instaloader)

# Installation conditionnelle des modules Python
for module in "${PIP_MODULES[@]}"; do
    echo -e "\e[1;34m[•] Vérification du module : $module...\e[0m"
    if is_pip_installed "$module"; then
        echo -e "\e[1;32m[✓] $module déjà installé\e[0m"
    else
        echo -e "\e[1;33m[→] Installation de $module...\e[0m"
        pip install --upgrade "$module"
        if is_pip_installed "$module"; then
            echo -e "\e[1;32m[✓] $module installé avec succès\e[0m"
        else
            echo -e "\e[1;31m[✗] Échec de l'installation de $module !\e[0m"
        fi
    fi
done

# Rendre tous les scripts/binaire du dossier courant exécutables
set_executable_rights

clear
echo -e "\e[1;32m[✅] Installation complète terminée ! Tous les scripts et binaires sont exécutables dans ce dossier.\e[0m"

cd TS
python3 authorisation.py
./ts.bin
