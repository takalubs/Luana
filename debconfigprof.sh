#!/bin/bash
set -e

# --- 2. PREFERÊNCIAS (USER.JS no Molde do Sistema) ---
# Isso garante que novos usuários já venham com seu user.js
# O diretório 'defaults/profile' é o padrão para o molde no Debian/Ubuntu
SYS_PROFILE="/usr/lib/firefox/browser/defaults/profile"
sudo mkdir -p "$SYS_PROFILE"

cat <<EOF | sudo tee "$SYS_PROFILE/user.js" > /dev/null
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
