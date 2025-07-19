#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\e[1;36m🔧 Installation complète de l'environnement TS sous Termux (avec vérification des modules)\e[0m"

# Autorisation 
echo -e "\e[1;34m[•] Autorisation du stockage...\e[0m"
termux-setup-storage

# Mise à jour
echo -e "\e[1;34m[•] Mise à jour Termux...\e[0m"
pkg update -y && pkg upgrade -y

# eto aho no milance an sys
echo -e "\e[1;34m[•] Installation des paquets système requis...\e[0m"
pkg install -y clang python fftw libzmq freetype libpng pkg-config libjpeg-turbo zlib sqlite ncurses-utils rust

echo -e "\e[1;34m[•] Mise à jour pip, setuptools, wheel...\e[0m"
pip install --upgrade pip setuptools wheel

is_pip_installed() {
    python3 -c "import $1" >/dev/null 2>&1
}

declare -A MODULES
MODULES=(
    [numpy]="numpy"
    [pillow]="PIL"
    [rich]="rich"
    [termcolor]="termcolor"
    [telethon]="telethon"
    [requests]="requests"
    [instagrapi]="instagrapi"
    [instaloader]="instaloader"
    [certifi]="certifi"
)

declare -A MODULES_VERSION
MODULES_VERSION=(
    [numpy]="numpy==1.26.4"
    [pillow]="pillow>=9.5.0"
    [rich]="rich>=13.7.1"
    [termcolor]="termcolor>=2.4.0"
    [telethon]="telethon>=1.34.0"
    [requests]="requests>=2.31.0"
    [instagrapi]="instagrapi==1.16.0"
    [instaloader]="instaloader>=4.10"
    [certifi]="certifi>=2024.2.2"
)

for module in "${!MODULES[@]}"; do
    import_name="${MODULES[$module]}"
    echo -e "\e[1;34m[•] Vérification de $module...\e[0m"
    if is_pip_installed "$import_name"; then
        echo -e "\e[1;32m[✓] $module déjà installé, aucune action nécessaire.\e[0m"
    else
        echo -e "\e[1;33m[→] Installation de $module...\e[0m"
        if [ "$module" = "numpy" ]; then
            LDFLAGS=" -lm -lcompiler_rt" pip install --no-cache-dir --no-build-isolation "${MODULES_VERSION[$module]}"
        else
            pip install --no-cache-dir --no-build-isolation "${MODULES_VERSION[$module]}"
        fi

        if is_pip_installed "$import_name"; then
            echo -e "\e[1;32m[✓] $module installé avec succès.\e[0m"
        else
            echo -e "\e[1;31m[✗] Échec d'installation de $module.\e[0m"
        fi
    fi
done

python -c "from instagrapi import Client; print('✅ instagrapi fonctionnel')" 2>/dev/null

if [ $? -eq 0 ]; then
    termux-toast -g bottom "✅ Environnement TS prêt"
    echo -e "\e[1;32m[✅] Environnement TS installé avec succès.\e[0m"
else
    termux-toast -g bottom "⚠️ TS prêt mais instagrapi a échoué"
    echo -e "\e[1;31m[⚠️] TS installé, mais instagrapi non fonctionnel.\e[0m"
fi

echo -e "\e[1;34m[•] Rend les scripts et binaires exécutables...\e[0m"
set_executable_rights() {
    local thisdir
    thisdir="$(dirname "$(realpath "$0")")"
    for f in "$thisdir"/*.sh "$thisdir"/*.py "$thisdir"/*.bin; do
        [ -e "$f" ] && chmod +x "$f"
    done
}
set_executable_rights

sleep 2
clear

echo -e "\e[1;32m[✅] Environnement prêt. Vous pouvez lancer vos scripts TS maintenant.\e[0m"

if [ -d "TS" ]; then
    cd TS
    if [ -f "authorisation.py" ]; then
        echo -e "\e[1;34m[•] Lancement de authorisation.py...\e[0m"
        python3 authorisation.py
    fi
    if [ -f "ts.bin" ]; then
        echo -e "\e[1;34m[•] Lancement de ts.bin...\e[0m"
        ./ts.bin
    else
        echo -e "\e[1;33m[⚠️] ts.bin non trouvé dans TS.\e[0m"
    fi
else
    echo -e "\e[1;33m[⚠️] Dossier TS non trouvé, aucun lancement automatique effectué.\e[0m"
fi
