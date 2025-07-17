#!/usr/bin/env python3

import os
from pathlib import Path
bin_files = ["install.bin", "maj.bin", "ts.bin"]
script_dir = Path(__file__).resolve().parent
for bin_name in bin_files:
    bin_path = script_dir / bin_name
    if bin_path.exists():
        try:
            os.chmod(bin_path, os.stat(bin_path).st_mode | 0o111)
            print(f"[OK] Autorisation d'exécution donnée à {bin_name}")
        except Exception as e:
            print(f"[ERREUR] Impossible de modifier {bin_name}: {e}")
    else:
        print(f"[!] Fichier {bin_name} introuvable dans {script_dir}")
print("Terminé.")
