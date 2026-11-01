# Aqutopus — Dağıtım ve Kurulum Merkezi 🐙

[![Dağıtım Portalı](https://img.shields.io/badge/Portal-monomem--release.frax.tr-blue?style=for-the-badge)](https://monomem-release.frax.tr)
[![Lisans](https://img.shields.io/badge/Lisans-MIT-green?style=for-the-badge)](LICENSE)
[![Son Sürüm](https://img.shields.io/github/v/release/aquin0x/aqutopus-releases?style=for-the-badge&color=purple)](https://github.com/aquin0x/aqutopus-releases/releases)

**Aqutopus**; yapay zekâ ajanları, ekipler ve bireysel kullanıcılar için hibrit hafıza (RAG + pgvector), otonom çalışma ortamı ve cihazlar arası senkronizasyon sunan yeni nesil bir **Ajan Ofisi** ekosistemidir.

Bu depo; tüm platformlar (Windows, macOS, Linux, Android), tek satırlık VPS kurulum betiği, Docker Compose dağıtım şablonları ve eklentiler için **merkezi ve doğrulanmış resmi dağıtım noktasıdır**.

🌐 **Canlı Dağıtım Portalı:** [https://monomem-release.frax.tr](https://monomem-release.frax.tr)  
📦 **Releases & Binary İndirmeleri:** [https://github.com/aquin0x/aqutopus-releases/releases](https://github.com/aquin0x/aqutopus-releases/releases)

---

## 📦 İndirme ve Platform Desteği

| Platform | Mimari / Format | Açıklama | İndirme Bağlantısı |
|:---|:---|:---|:---:|
| **Windows** | Windows 10 / 11 (x64) `.exe` | **Tauri v2 + Rust**: Sıfır Chromium, ~5 MB kurulum, sistem tepsisi arka plan düğümü | [⬇️ İndir (.exe)](https://github.com/aquin0x/aqutopus-releases/releases/latest/download/aqutopus-windows-x64.exe) |
| **macOS** | Apple Silicon (M1..M4) `.dmg` | Metal & WebKit tabanlı hafif masaüstü istemcisi | [⬇️ İndir (.dmg)](https://github.com/aquin0x/aqutopus-releases/releases/latest/download/aqutopus-mac-arm64.dmg) |
| **macOS** | Intel x64 `.dmg` | Intel tabanlı Mac cihazlar için optimize | [⬇️ İndir (.dmg)](https://github.com/aquin0x/aqutopus-releases/releases/latest/download/aqutopus-mac-x64.dmg) |
| **Android** | Android 9.0+ `.apk` | Yerel mobil asistan, sesli notlar & Erişilebilirlik Servisi otomasyonu | [⬇️ İndir (.apk)](https://github.com/aquin0x/aqutopus-releases/releases/latest/download/aqutopus-android.apk) |
| **Linux & VPS** | x86_64 / arm64 | Docker Compose, Headless CLI düğümü & Web Paneli | [📄 compose.yml](docker/compose.yml) |
| **Eklentiler** | Browser & MCP | Tarayıcı köprüsü (Chrome/Edge/Brave) & Claude/Codex/agy MCP | [📖 Rehber](extensions/README.md) |

---

## ⚡ Hızlı Başlangıç: Linux & VPS Kurulumu

Linux sunucunuza (veya macOS / WSL2) tek satırda tüm Aqutopus ekosistemini (PostgreSQL pgvector, Core API, Web panel ve sohbet arayüzü) kurup başlatın:

```bash
curl -fsSL https://monomem-release.frax.tr/install.sh | bash
```

> **Kurulum Betiği Ne Yapar?**
> 1. Sisteminizdeki Docker ve Docker Compose durumunu denetler (yoksa resmi depodan kurar).
> 2. Güvenli rastgele kriptografik anahtarlar (`POSTGRES_PASSWORD`, `MCP_SIGNING_KEY`, `APP_STATE_SECRET`) üreterek `.env` dosyanızı oluşturur.
> 3. En güncel üretim imajlarını çeker (`docker compose pull`) ve servisleri ayağa kaldırır (`docker compose up -d`).

---

## 🏗️ Sistem Mimarisi

```
 ┌───────────────────────────────────────────────────────────────┐
 │                       Aqutopus Hub                            │
 │              (Resmi Skill'ler & Topluluk Şablonları)           │
 └──────────────────────────────┬────────────────────────────────┘
                                │
 ┌──────────────────────────────▼────────────────────────────────┐
 │                 Aqutopus Core API (Fastify)                    │
 │       • Hibrit RAG (PostgreSQL + pgvector)                     │
 │       • Ajan Yetkilendirme, Bölüm & Cihaz Yönetimi             │
 │       • Model Context Protocol (MCP) Sunucusu                  │
 └──────────────┬────────────────┬───────────────────────────────┘
                │                │
 ┌──────────────▼──────┐  ┌──────▼──────────────┐  ┌─────────────▼──────────┐
 │   Masaüstü Düğümü    │  │   Android Mobil     │  │   Terminal Ajanları    │
 │  (Tauri v2 + Rust)  │  │   (Kotlin / APK)    │  │  (Claude, Codex, agy)  │
 │  • Cihazı ofise     │  │  • Sesli not kaydı  │  │  • MCP bellek köprüsü  │
 │    güvenle bağlar   │  │  • Erişilebilirlik  │  │  • Kalıcı akıl yürütme │
 │  • Düşük RAM/CPU    │  │    otomasyonu       │  │                        │
 └─────────────────────┘  └─────────────────────┘  └────────────────────────┘
```

---

## 🛠️ Manuel Docker Dağıtımı

Kendi VPS sunucunuzda elle yapılandırmak isterseniz:

1. Dağıtım deposundaki `docker` dizinini alın:
   ```bash
   git clone https://github.com/aquin0x/aqutopus-releases.git
   cd aqutopus-releases/docker
   ```

2. `.env` dosyanızı hazırlayın:
   ```bash
   cp .env.example .env
   # .env içindeki gizli anahtarları ve domain ayarlarını düzenleyin
   ```

3. Konteynerleri başlatın:
   ```bash
   docker compose up -d
   ```

4. Servislere erişin:
   - **Sohbet Uygulaması:** `http://localhost:3000` (veya alan adınız)
   - **Ofis Yönetim Paneli:** `http://localhost:8788`
   - **Sağlık Denetimi:** `http://localhost:8788/healthz`

---

## 🤖 Model Context Protocol (MCP) Entegrasyonu

Terminal ve geliştirici ortamı ajanlarınızı (Claude Code, OpenAI Codex, Google Antigravity `agy`) doğrudan Aqutopus hafızasına bağlayın.

### Claude Code (`~/.claude/config.json`)
```json
{
  "mcpServers": {
    "aqutopus": {
      "url": "https://monomem.frax.tr/mcp",
      "headers": {
        "Authorization": "Bearer <MCP_ERISIM_TOKENINIZ>"
      }
    }
  }
}
```

### Başlıca MCP Araçları
- `recall`: Hibrit vektör + tam metin aramasıyla geçmiş kararları, mimari notları ve bağlamı getirir.
- `remember`: Yeni bir kararı, kod yapısını veya kuralı kalıcı ortak hafızaya kaydeder.
- `search_memory`: Semantik benzerlik ve anahtar kelime filtreleri ile derin hafıza sorgulaması yapar.

---

## 📲 Platform Kurulum Rehberi

### 📱 Android
1. `aqutopus-android.apk` dosyasını indirin ve cihaza kurun.
2. Android güvenlik uyarısı gelirse *"Bilinmeyen kaynaklardan yüklemeye izin ver"* seçeneğini onaylayın.
3. Ekran ve mesajlaşma otomasyonlarının çalışabilmesi için **Ayarlar → Erişilebilirlik → Aqutopus** servisini etkinleştirin.

### 🪟 Windows (Tauri v2 + Rust)
1. `aqutopus-windows-x64.exe` dosyasını çalıştırın.
2. Windows SmartScreen uyarısı çıkarsa:
   - **Ek Bilgi (More info)** linkine tıklayın.
   - **Yine de çalıştır (Run anyway)** butonunu seçin.
3. Uygulama saatin yanındaki sistem tepsisinde (system tray) sessizce çalışacaktır.

### 🍎 macOS
1. İndirilen `.dmg` dosyasını açıp `Aqutopus.app` ikonunu `Applications` klasörüne sürükleyin.
2. Apple Gatekeeper uyarısı alırsanız sağ tıklayıp **Aç** diyebilir ya da Terminal'den şu komutu verebilirsiniz:
   ```bash
   xattr -cr /Applications/Aqutopus.app
   ```

---

## 🔒 Güvenlik, Gizlilik ve Lisans

- **Sıfır Kaynak Kod Sızıntısı:** Bu dağıtım deposunda yalnızca derlenmiş ikili dosyalar (binary), doğrulanmış Docker imajları ve açık kaynak kurulum şablonları yer alır; hassas API anahtarları veya özel sunucu kodları asla barındırılmaz.
- **Yerel Öncelikli (Local-First) Güvenlik:** Masaüstü ve mobil düğümler sunucuyla güvenli şifrelenmiş WebSocket/TLS protokolleri üzerinden haberleşir.
- **Lisans:** Bu proje [MIT Lisansı](LICENSE) altında dağıtılmaktadır.
