#!/bin/bash
set -e

# 1. Localiza a pasta de perfil do Firefox (Linux/Unix)
# O Firefox guarda os perfis em ~/.mozilla/firefox/
# Este comando pega a pasta que termina em '.default-release' ou '.default'
FF_DIR="/home/professor/.mozilla/firefox"
PROFILE_PATH=$(grep 'Path=' "$FF_DIR/profiles.ini" | head -n 1 | cut -d'=' -f2)
TARGET_DIR="$FF_DIR/$PROFILE_PATH"

if [ -d "$TARGET_DIR" ]; then
    echo "Instalando user.js em: $TARGET_DIR"

    # 2. Gera o arquivo user.js usando o 'Here Document'
    cat <<EOF > "$TARGET_DIR/user.js"
// Configurações Geradas via Script
user_pref("browser.display.document_color_use", 0);
user_pref("dom.security.https_only_mode_ever_enabled", true);
user_pref("dom.security.https_only_mode", true);
user_pref("media.eme.enabled", true);
user_pref("privacy.clearOnShutdown_v2.formdata", true);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("privacy.globalprivacycontrol.was_ever_enabled", true);
user_pref("privacy.sanitize.clearOnShutdown.hasMigratedToNewPrefs3", true);
user_pref("sidebar.backupState", "{\"command\":\"\",\"panelOpen\":false,\"launcherWidth\":0,\"launcherExpanded\":false,\"launcherVisible\":false}");
EOF

    echo "Sucesso! O arquivo user.js foi criado."
else
    echo "Erro: Pasta de perfil não encontrada."
fi

# Instala o gerenciador
sudo apt install snapd -y

# Instala o AdGuard usando o caminho absoluto (mais seguro para scripts)
sudo /usr/bin/snap install adguard-home

# 4. Instalação de Ferramentas de Sistema e Veyon (Stable)
apt install -y zram-tools btrfs-assistant ufw veyon-master veyon-service

# 5. Configuração do Firewall (UFW)
#ufw allow 11100/tcp
#ufw allow 11400/tcp
ufw enable

# 7. Limpeza de pacotes padrão (Ajuste esta lista conforme sua preferência)
# Removendo apps comuns do KDE, Cinnamon e LXQt (ex: jogos, chats, reprodutores)
echo "Removendo pacotes padrão indesejados..."
#apt purge -y

apt autoremove -y

# 8. Finalização
echo "------------------------------------------------------------"
echo "PROCESSO CONCLUÍDO!"
echo "Faça REBOOT agora."
echo "------------------------------------------------------------"
