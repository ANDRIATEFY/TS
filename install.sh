#!/data/data/com.termux/files/usr/bin/bash
clear
echo -e "\e[1;36m🔧 Installation des dépendances et outils nécessaires pour TS\e[0m"
echo -e "\e[1;34m[•] Autorisation de stockage...\e[0m"
termux-setup-storage
echo -e "\e[1;34m[•] Mise à jour de Termux...\e[0m"
pkg update -y && pkg upgrade -y
echo -e "\e[1;34m[•] Installation des paquets Termux requis...\e[0m"
pkg install -y python python-dev clang fftw libzmq freetype libpng pkg-config openblas git ncurses-utils libjpeg-turbo zlib sqlite rust
echo -e "\e[1;34m[•] Mise à jour de pip, setuptools, wheel...\e[0m"
pip install --upgrade pip setuptools wheel
is_pip_installed() {
    python3 -m pip show "$1" >/dev/null 2>&1
}
echo -e "\e[1;34m[•] Installation de numpy...\e[0m"
LDFLAGS=" -lm -lcompiler_rt" pip install numpy
if python -c "import numpy" 2>/dev/null; then
    echo -e "\e[1;32m[✓] numpy installé correctement.\e[0m"
else
    echo -e "\e[1;33m[→] numpy bloqué, tentative d'installation sans isolation...\e[0m"
    pip install numpy --no-build-isolation
    if python -c "import numpy" 2>/dev/null; then
        echo -e "\e[1;32m[✓] numpy installé après forçage.\e[0m"
    else
        echo -e "\e[1;31m[✗] Echec d'installation de numpy. instagrapi pourrait échouer.\e[0m"
    fi
fi
PIP_MODULES=(telethon requests rich termcolor pillow instaloader instagrapi)
for module in "${PIP_MODULES[@]}"; do
    echo -e "\e[1;34m[•] Vérification du module : $module...\e[0m"
    if is_pip_installed "$module"; then
        echo -e "\e[1;32m[✓] $module déjà installé\e[0m"
    else
        echo -e "\e[1;33m[→] Installation de $module...\e[0m"
        if [ "$module" = "instagrapi" ]; then
            pip install "$module" --no-build-isolation
        else
            pip install "$module"
        fi
        if is_pip_installed "$module"; then
            echo -e "\e[1;32m[✓] $module installé avec succès\e[0m"
        else
            echo -e "\e[1;31m[✗] Échec de l'installation de $module !\e[0m"
        fi
    fi
done
set_executable_rights() {
    local thisdir
    thisdir="$(dirname "$(realpath "$0")")"
    for f in "$thisdir"/*.sh "$thisdir"/*.py "$thisdir"/*.bin; do
        [ -e "$f" ] && chmod +x "$f"
    done
}
set_executable_rights

python -c "from instagrapi import Client; print('✅ instagrapi fonctionnel')" 2>/dev/null
if [ $? -eq 0 ]; then
    termux-toast -g bottom "✅ Installation TS terminée avec succès"
    echo -e "\e[1;32m[✅] Installation complète terminée ! Tous les scripts et binaires sont exécutables dans ce dossier.\e[0m"
else
    termux-toast -g bottom "⚠️ TS installé, mais instagrapi a échoué"
    echo -e "\e[1;31m[⚠️] TS installé, mais instagrapi non fonctionnel.\e[0m"
fi
sleep 2
clear
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
        echo -e "\e[1;31m[✗] ts.bin non trouvé dans TS. Lancement annulé.\e[0m"
    fi
else
    echo -e "\e[1;31m[✗] Dossier TS non trouvé. Lancement annulé.\e[0m"
fi
