#!/bin/bash
set -e

# --- 2. PREFERÊNCIAS (USER.JS no Molde do Sistema) ---
# Isso garante que novos usuários já venham com seu user.js
# O diretório 'defaults/profile' é o padrão para o molde no Debian/Ubuntu
SYS_PROFILE="/usr/lib/firefox-esr/browser/defaults/preferences"

cat <<EOF | sudo tee "$SYS_PROFILE/custom.js" > /dev/null
pref("browser.display.document_color_use", 0);
pref("dom.security.https_only_mode_ever_enabled", true);
pref("dom.security.https_only_mode", true);
pref("media.eme.enabled", true);
pref("privacy.clearOnShutdown_v2.formdata", true);
pref("privacy.globalprivacycontrol.enabled", true);
pref("privacy.globalprivacycontrol.was_ever_enabled", true);
pref("privacy.sanitize.clearOnShutdown.hasMigratedToNewPrefs3", true);
pref("sidebar.backupState", "{\"command\":\"\",\"panelOpen\":false,\"launcherWidth\":0,\"launcherExpanded\":false,\"launcherVisible\":false}");
EOF

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
