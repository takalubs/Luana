#!/bin/bash
set -e

# 1. Escolha do Ambiente de Desktop
echo "--- AMBIENTE DE DESKTOP ---"
echo "1) LXQt - Wayland via Testing"
echo "2) Outro (Mantém versão Stable)"
read -p "Escolha: " AMBIENTE

groupadd -f nopasswdlogin
usermod -aG nopasswdlogin aluno
mkdir -p /etc/sddm.conf.d

if [ "$AMBIENTE" == "1" ]; then
cat <<EOF > /etc/sddm.conf.d/autologin.conf
[Autologin]
User=aluno
Session=lxqt-wayland
EOF
else
cat <<EOF > /etc/sddm.conf.d/autologin.conf
[Autologin]
User=aluno
EOF
fi

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

# 3. Lógica específica para LXQt (Wayland e Root)
if [ "$AMBIENTE" == "1" ]; then
    # Instala Wayland puxando do Testing
    echo "deb http://deb.debian.org/debian/ testing main" > /etc/apt/sources.list.d/teste.list
    apt update
    apt install -y lxqt-wayland-session
    rm /etc/apt/sources.list.d/teste.list
    apt update
fi

# Descomenta a linha no PAM do SDDM
if [ -f /etc/pam.d/sddm ]; then
    sed -i '/pam_succeed_if.so user ingroup nopasswdlogin/s/^#\s*//' /etc/pam.d/sddm
fi

# 4. Instalação de Ferramentas de Sistema e Veyon (Stable)
apt install -y zram-tools btrfs-assistant ufw veyon-service

# 5. Configuração do Firewall (UFW)
ufw allow 11100/tcp
ufw allow 11400/tcp
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
