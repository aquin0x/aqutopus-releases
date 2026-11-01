#!/bin/sh
# ==============================================================================
# Aqutopus Tek Satırlık VPS Kurulum Betiği 🐙
# https://monomem-release.frax.tr
#
# Kullanım:
#   curl -fsSL https://monomem-release.frax.tr/install.sh | bash
#   veya:
#   curl -fsSL https://raw.githubusercontent.com/aquin0x/aqutopus-releases/main/install.sh | bash
#
# Etkileşimsiz kullanım:
#   AQUTOPUS_YES=1 curl -fsSL https://monomem-release.frax.tr/install.sh | bash
# ==============================================================================
set -eu

AQUTOPUS_DIR=${AQUTOPUS_DIR:-${MONOMEM_DIR:-$HOME/aqutopus}}
YES=${AQUTOPUS_YES:-${MONOMEM_YES:-0}}
RAW_BASE=${RAW_BASE:-https://raw.githubusercontent.com/aquin0x/aqutopus-releases/main}

# Renkler ve Yardımcılar
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

rand_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 16
  else
    head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n'
  fi
}

ask() {
  _var=$1 _q=$2 _def=${3-}
  eval "_cur=\${$_var-}"
  if [ -n "$_cur" ]; then return 0; fi
  if [ "$YES" = 1 ]; then
    eval "$_var=\$_def"
    return 0
  fi
  if [ -n "$_def" ]; then printf "${C_BOLD}%s${C_RESET} [%s]: " "$_q" "$_def"; else printf "${C_BOLD}%s${C_RESET}: " "$_q"; fi
  _ans=
  read -r _ans </dev/tty || _ans=
  [ -n "$_ans" ] || _ans=$_def
  eval "$_var=\$_ans"
}

# -----------------------------------------------------------------------------
# 1. Platform & Önkoşul Kontrolü
# -----------------------------------------------------------------------------
printf "\n"
printf "${C_BLUE}    __  ___                                           ${C_RESET}\n"
printf "${C_BLUE}   /  |/  /___  ____  ____  ____ ___  ___  ____ ___  ${C_RESET}\n"
printf "${C_BLUE}  / /|_/ / __ \/ __ \/ __ \/ __ \`__ \/ _ \/ __ \`__ \ ${C_RESET}\n"
printf "${C_BLUE} / /  / / /_/ / / / / /_/ / / / / / /  __/ / / / / / ${C_RESET}\n"
printf "${C_BLUE}/_/  /_/\____/_/ /_/\____/_/ /_/ /_/\___/_/ /_/ /_/  ${C_RESET}\n"
printf "        ${C_BOLD}Merkezi Dağıtım ve Kurulum Merkezi${C_RESET}\n"
printf "        ${C_BLUE}https://monomem-release.frax.tr${C_RESET}\n\n"

case "$(uname -s)" in
  Linux)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      info "WSL2 (Windows Subsystem for Linux) algılandı."
    fi
    ;;
  Darwin)
    info "macOS algılandı."
    ;;
  MINGW* | MSYS* | CYGWIN*)
    die "Doğrudan Windows komut satırında çalıştırılamaz. Lütfen WSL2 (Ubuntu) terminalinde çalıştırın."
    ;;
  *)
    warn "Bilinmeyen işletim sistemi: $(uname -s)"
    ;;
esac

# Docker Kontrolü
if ! command -v docker >/dev/null 2>&1; then
  warn "Docker kurulu bulunamadı."
  if [ "$YES" = 1 ]; then
    info "Docker resmi script ile kuruluyor..."
    curl -fsSL https://get.docker.com | sh
  else
    printf "Docker otomatik kurulsun mu? [E/h]: "
    read -r _do_install </dev/tty || _do_install=E
    case "$_do_install" in
      e|E|evet|y|Y|yes|"")
        info "Docker resmi betik ile kuruluyor..."
        curl -fsSL https://get.docker.com | sh
        ;;
      *)
        die "Docker olmadan devam edilemez. Lütfen Docker kurup tekrar deneyin: https://docs.docker.com/engine/install/"
        ;;
    esac
  fi
fi

if ! docker compose version >/dev/null 2>&1; then
  die "Docker Compose v2 bulunamadı. Lütfen 'docker compose' eklentisini kurun."
fi

success "Docker ve Docker Compose hazır."

# -----------------------------------------------------------------------------
# 2. Kurulum Klasörü ve Dosyaların İndirilmesi
# -----------------------------------------------------------------------------
info "Kurulum klasörü hazırlanıyor: $AQUTOPUS_DIR"
mkdir -p "$AQUTOPUS_DIR"
cd "$AQUTOPUS_DIR"

info "Docker Compose dosyaları indiriliyor..."
curl -fsSL "$RAW_BASE/docker/compose.yml" -o "$AQUTOPUS_DIR/compose.yml" || die "compose.yml indirilemedi."

# -----------------------------------------------------------------------------
# 3. .env Dosyası ve Güvenlik Anahtarlarının Üretilmesi
# -----------------------------------------------------------------------------
ENV_FILE="$AQUTOPUS_DIR/.env"
if [ ! -f "$ENV_FILE" ]; then
  info "Güvenli anahtarlar üretiliyor..."
  _pg_pass=$(rand_secret)
  _mcp_key=$(rand_secret)
  _app_sec=$(rand_secret)

  _app_port=3000
  _core_port=8788
  _gemini_key=""

  if [ "$YES" != 1 ]; then
    say "\nTemel Yapılandırma:"
    ask _app_port "Sohbet Arayüzü Portu" "3000"
    ask _core_port "Ofis Paneli & API Portu" "8788"
    say "\n(İsteğe bağlı) Google Gemini API Anahtarı (Hibrit RAG / vektör arama için):"
    say "Boş bırakırsanız sadece yerel tam metin araması çalışır."
    ask _gemini_key "Gemini API Key" ""
  fi

  cat > "$ENV_FILE" <<EOF
# Aqutopus Otomatik Üretilmiş Yapılandırma
# Oluşturulma Tarihi: $(date -u)

POSTGRES_USER=office
POSTGRES_DB=office
POSTGRES_PASSWORD=$_pg_pass

MCP_SIGNING_KEY=$_mcp_key
APP_STATE_SECRET=$_app_sec

APP_PORT=$_app_port
CORE_PORT=$_core_port

PANEL_URL=http://localhost:$_core_port
PUBLIC_URL=http://localhost:$_app_port

GOOGLE_GENERATIVE_AI_API_KEY=$_gemini_key

TZ=Europe/Istanbul
EOF
  chmod 600 "$ENV_FILE"
  success "Güvenli .env dosyası oluşturuldu."
else
  info "Mevcut .env dosyası bulundu, korunuyor."
fi

# -----------------------------------------------------------------------------
# 4. Servislerin Başlatılması
# -----------------------------------------------------------------------------
info "Aqutopus servisleri başlatılıyor (docker compose pull & up)..."
docker compose --env-file "$ENV_FILE" -f "$AQUTOPUS_DIR/compose.yml" pull
docker compose --env-file "$ENV_FILE" -f "$AQUTOPUS_DIR/compose.yml" up -d

# -----------------------------------------------------------------------------
# 5. Başarı Özeti ve Erişim Bilgisi
# -----------------------------------------------------------------------------
_HOST_IP=$(curl -fsS --max-time 3 https://api.ipify.org 2>/dev/null || echo "localhost")

printf "\n"
success "Aqutopus başarıyla kuruldu ve başlatıldı!"
printf "\n"
printf "  ${C_BOLD}Sohbet Arayüzü:${C_RESET}   http://%s:3000 (veya http://localhost:3000)\n" "$_HOST_IP"
printf "  ${C_BOLD}Ofis Yönetim Paneli:${C_RESET} http://%s:8788 (veya http://localhost:8788)\n" "$_HOST_IP"
printf "\n"
printf "  ${C_BOLD}Kurulum Dizini:${C_RESET}    %s\n" "$AQUTOPUS_DIR"
printf "  ${C_BOLD}Durdurmak için:${C_RESET}    cd %s && docker compose down\n" "$AQUTOPUS_DIR"
printf "  ${C_BOLD}Logları görmek için:${C_RESET} cd %s && docker compose logs -f\n" "$AQUTOPUS_DIR"
printf "\n"
printf "Masaüstü, mobil veya eklenti indirmeleri için:\n"
printf "${C_BLUE}https://monomem-release.frax.tr${C_RESET}\n\n"
