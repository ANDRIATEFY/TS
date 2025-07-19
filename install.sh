pkg update -y
pkg upgrade -y

# Installation des outils de base avec vérification
echo -e "\033[1;34m> Installation de Python...\033[0m"
pkg install python -y || { echo -e "\033[1;31mErreur: Python n'a pas pu être installé !\033[0m"; exit 1; }

echo -e "\033[1;36m> Installation de Git...\033[0m"
pkg install git -y || { echo -e "\033[1;31mErreur: Git n'a pas pu être installé !\033[0m"; exit 1; }

echo -e "\033[1;35m> Installation de libjpeg-turbo et zlib...\033[0m"
pkg install libjpeg-turbo zlib -y || { echo -e "\033[1;31mErreur: libjpeg-turbo ou zlib n'ont pas pu être installés !\033[0m"; exit 1; }

# Autorisation de stockage
echo -e "\033[1;33m> Autorisation de stockage...\033[0m"
termux-setup-storage

# Liste des modules Python à installer
MODULES="telethon rich pillow termcolor requests instagrapi"

# Fonction pour installer et vérifier un module Python
install_module() {
    module=$1
    echo -e "\033[1;32mInstallation de $module...\033[0m"
    pip install $module
    python -c "import $module" 2>/dev/null
    if [ $? -eq 0 ]; then
        python - <<END
from rich.console import Console
console = Console()
console.print(":white_check_mark: [bold green]$module installé avec succès[/bold green]")
END
    else
        python - <<END
from rich.console import Console
console = Console()
console.print(":x: [bold red]Erreur : $module n'a pas pu être importé après installation ![/bold red]")
END
        exit 1
    fi
}

# Installation et vérification de chaque module
for m in $MODULES; do
    install_module $m
done

# Récapitulatif coloré en Python avec rich
python - <<END
from rich.console import Console
console = Console()
console.print("[bold green]Installation terminée. Toutes les dépendances nécessaires sont installées (instagrapi inclus) ![/bold green]")
END


cd TS
chmod +x *
./ts.bin
