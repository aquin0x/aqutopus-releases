#!/bin/sh
# ==============================================================================
# Aqutopus Çalıştırıcı Düğüm (VPS Worker) Tek Satırlık Kurulum Betiği 🐙
# https://monomem-release.frax.tr/node.sh
#
# Kullanım:
#   curl -fsSL https://monomem-release.frax.tr/node.sh | bash
# veya doğrudan kod ile:
#   curl -fsSL https://monomem-release.frax.tr/node.sh | bash -s -- <ESLEME_KODU>
# ==============================================================================
set -eu

PANEL_URL=${AQUTOPUS_URL:-https://aqutopus.frax.tr}
CODE=${1:-}
INSTALL_DIR="$HOME/aqutopus"
WORK_DIR="$HOME/work"

C_BLUE='\033[0;34m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_RED='\033[0;31m'
C_BOLD='\033[1m'
C_RESET='\033[0m'

say() { printf "${C_BOLD}%s${C_RESET}\n" "$*"; }
info() { printf "${C_BLUE}==>${C_RESET} %s\n" "$*"; }
success() { printf "${C_GREEN}✓${C_RESET} %s\n" "$*"; }
warn() { printf "${C_YELLOW}UYARI:${C_RESET} %s\n" "$*" >&2; }
die() { printf "\n${C_RED}HATA:${C_RESET} %s\n\n" "$*" >&2; exit 1; }

printf "\n"
printf "${C_BLUE}    ___                   __                         ${C_RESET}\n"
printf "${C_BLUE}   /   | ____ ___  ______/ /_____  ____  __  _______ ${C_RESET}\n"
printf "${C_BLUE}  / /| |/ __ \`/ / / / __  / __ \ \/ / / / / / / ___/ ${C_RESET}\n"
printf "${C_BLUE} / ___ / /_/ / /_/ / /_/ / /_/ / /_/ / /_/ (__  )  ${C_RESET}\n"
printf "${C_BLUE}/_/  |_\__, /\__,_/\__,_/\____/\____/\__,_/____/   ${C_RESET}\n"
printf "${C_BLUE}          /_/                                       ${C_RESET}\n"
printf "        ${C_BOLD}Aqutopus Başsız Düğüm (VPS Worker) Kurulumu${C_RESET}\n"
printf "        ${C_BLUE}Merkezi Panel: %s${C_RESET}\n\n" "$PANEL_URL"

# 1. İşletim sistemi kontrolü
case "$(uname -s)" in
  Linux)
    ;;
  Darwin)
    info "macOS algılandı."
    ;;
  *)
    warn "Desteklenmeyen platform: $(uname -s)"
    ;;
esac

# 2. Node.js 24+ ve pnpm kontrolü / otomatik kurulum
NEED_NODE=0
if ! command -v node >/dev/null 2>&1; then
  NEED_NODE=1
elif [ "$(node -p 'process.versions.node.split(".")[0]')" -lt 24 ]; then
  info "Mevcut Node.js sürümü ($(node -v)) 24'ten küçük, güncelleniyor..."
  NEED_NODE=1
fi

if [ "$NEED_NODE" -eq 1 ]; then
  info "Node.js 24 ve paket yöneticisi kuruluyor..."
  curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
  sudo apt-get install -y nodejs git
  sudo corepack enable
  sudo corepack prepare pnpm@latest --activate
fi

if ! command -v pnpm >/dev/null 2>&1; then
  sudo corepack enable
  sudo corepack prepare pnpm@latest --activate
fi

success "Node.js $(node -v) ve pnpm hazır."

# 3. Eşleme kodu kontrolü
if [ -z "$CODE" ]; then
  say "\nWeb panelinden (Ayarlar -> Cihazlar) aldığınız Eşleme Kodunu girin:"
  printf "${C_BOLD}Eşleme Kodu:${C_RESET} "
  read -r CODE </dev/tty || CODE=""
  if [ -z "$CODE" ]; then
    die "Eşleme kodu boş bırakılamaz."
  fi
fi

# 4. Proje deposunu çek / güncelle
if [ ! -d "$INSTALL_DIR" ]; then
  info "Aqutopus çalışma motoru indiriliyor..."
  git clone --depth 1 https://github.com/aquin0x/aqutopus.git "$INSTALL_DIR"
else
  info "Mevcut kurulum güncelleniyor..."
  cd "$INSTALL_DIR" && git pull || true
fi

cd "$INSTALL_DIR"
mkdir -p "$WORK_DIR"

# 5. Düğüm bağımlılıklarını yükle
info "Düğüm bağımlılıkları yükleniyor..."
pnpm install --filter @office/node...

# 6. Global CLI bağlantısı
NODE_BIN="$(command -v node)"
sudo tee /usr/local/bin/aqutopus-node > /dev/null <<EOF
#!/bin/sh
exec "$NODE_BIN" "$INSTALL_DIR/apps/node/bin/monomem-node.js" "\$@"
EOF
sudo chmod 0755 /usr/local/bin/aqutopus-node

# 7. Eşleme (Pairing) yap
info "Aqutopus Merkezi Paneliyle eşleniyor..."
"$NODE_BIN" "$INSTALL_DIR/apps/node/bin/monomem-node.js" pair --url "$PANEL_URL" --code "$CODE" --name "$(hostname)" || die "Eşleme başarısız! Eşleme kodunuzu kontrol edin."

success "Düğüm başarıyla eşlendi!"

# 8. 7/24 Kesintisiz Systemd Servisi Kur ve Başlat
if command -v systemctl >/dev/null 2>&1; then
  info "7/24 arka plan servisi (systemd) yapılandırılıyor..."
  sudo tee /etc/systemd/system/aqutopus-node.service > /dev/null <<EOF
[Unit]
Description=Aqutopus Calistirici Dugum (VPS Worker)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$(whoami)
WorkingDirectory=$HOME
ExecStart=/usr/local/bin/aqutopus-node run --work-root $WORK_DIR
Restart=always
RestartSec=5
NoNewPrivileges=yes

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reload
  sudo systemctl enable --now aqutopus-node
  success "Arka plan servisi (aqutopus-node) başlatıldı ve otomatik açılışa eklendi."
fi

printf "\n"
success "TEBRİKLER! Aqutopus VPS Düğümü başarıyla kuruldu ve çalışıyor."
say "Durumu kontrol etmek için: sudo systemctl status aqutopus-node"
say "Web panelinizdeki (https://aqutopus.frax.tr) Cihazlar ekranında bu makineyi artık yeşil görebilirsiniz."
printf "\n"
