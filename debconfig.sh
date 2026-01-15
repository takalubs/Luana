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

# 1. Localiza a pasta de perfil do Firefox (Linux/Unix)
# O Firefox deve ser aberto antes de rodar o codigo para que a pasta seja criada
# Este comando pega a pasta que termina em '.default-release' ou '.default'
FF_DIR="/home/aluno/.mozilla/firefox"
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
