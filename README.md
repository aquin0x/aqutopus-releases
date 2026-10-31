# Monomem — Dağıtım ve Kurulum Merkezi 🧠

[![Dağıtım Portalı](https://img.shields.io/badge/Portal-monomem--release.frax.tr-blue?style=for-the-badge)](https://monomem-release.frax.tr)
[![Lisans](https://img.shields.io/badge/Lisans-MIT-green?style=for-the-badge)](LICENSE)
[![Sürüm](https://img.shields.io/badge/Sürüm-v0.2.11-purple?style=for-the-badge)](https://github.com/aquin0x/monomem-releases/releases)

Tüm **Monomem** platformları (Windows, macOS, Android, Linux, Docker VPS) ve eklentileri için resmi, merkezi ve güvenli indirme/kurulum deposudur.

🌐 **Canlı Dağıtım Portalı:** [https://monomem-release.frax.tr](https://monomem-release.frax.tr)

---

## ⚡ Hızlı Başlangıç: Linux & VPS Kurulumu

Linux sunucunuza (veya macOS / WSL2) tek bir komutla tüm Monomem altyapısını kurun:

```bash
curl -fsSL https://monomem-release.frax.tr/install.sh | bash
```

> **Bu betik ne yapar?**
> 1. Sisteminizde Docker ve Docker Compose'u kontrol eder, yoksa kurar.
> 2. Kriptografik rastgele güvenli anahtarlar ile `.env` dosyanızı oluşturur.
> 3. En güncel üretim imajlarını çeker (`docker compose pull`) ve arka planda ayağa kaldırır (`docker compose up -d`).

---

## 📦 İstemci ve Uygulama İndirmeleri

| Platform | Format / Paket | Açıklama | İndirme Bağlantısı |
|:---|:---|:---|:---:|
| **Windows** | `.exe` (x64) | Masaüstü düğümü & arka plan asistanı | [İndir (.exe)](https://github.com/aquin0x/monomem/releases/latest/download/monomem-windows-x64.exe) |
| **macOS** | `.dmg` (Apple Silicon) | M1/M2/M3/M4 işlemciler için optimize | [İndir (.dmg)](https://github.com/aquin0x/monomem/releases/latest/download/monomem-mac-arm64.dmg) |
| **macOS** | `.dmg` (Intel) | Intel tabanlı Mac'ler için | [İndir (.dmg)](https://github.com/aquin0x/monomem/releases/latest/download/monomem-mac-x64.dmg) |
| **Android** | `.apk` (Sideload) | Sesli notlar & Erişilebilirlik Servisi | [İndir (.apk)](https://github.com/aquin0x/monomem/releases/latest/download/monomem-android.apk) |
| **Linux & VPS** | `compose.yml` | Üretim sunucusu için Docker şablonu | [İncele](docker/compose.yml) |
| **Eklentiler** | Browser & MCP | Tarayıcı uzantısı ve ajan köprüleri | [Rehber](extensions/README.md) |

---

## 🛠️ Manuel Docker Kurulumu (Kendi Sunucunuzda)

Sunucunuzda betik kullanmadan el ile ayağa kaldırmak isterseniz:

1. Bu depoyu klonlayın veya doğrudan `docker` klasörünü indirin:
   ```bash
   git clone https://github.com/aquin0x/monomem-releases.git
   cd monomem-releases/docker
   ```

2. Örnek yapılandırma dosyasını kopyalayın ve anahtarları düzenleyin:
   ```bash
   cp .env.example .env
   ```

3. Servisleri başlatın:
   ```bash
   docker compose up -d
   ```

4. Arayüzlere erişin:
   - **Sohbet Uygulaması:** `http://localhost:3000`
   - **Ofis Yönetim Paneli:** `http://localhost:8788`

---

## 📱 Android Kurulum Notları

1. İndirilen `monomem-android.apk` dosyasına dokunun.
2. Android güvenlik uyarısı verirse *"Bilinmeyen kaynaklardan yüklemeye izin ver"* seçeneğini onaylayın.
3. Uygulamayı açtıktan sonra, mobil ajan özelliklerinin (mesajlaşma ve ekran otomasyonu) çalışabilmesi için **Ayarlar → Erişilebilirlik → Monomem** servisini etkinleştirin.

---

## 🪟 Windows SmartScreen Notları

Uygulama henüz ticari bir kod imzalama sertifikası taşımıyorsa Windows açılışta *"Windows kişisel bilgisayarınızı korudu"* uyarısı verebilir:
- **Ek Bilgi** (More info) linkine tıklayın.
- **Yine de çalıştır** (Run anyway) butonunu seçin.

---

## 🍎 macOS Güvenlik İzni

Apple Gatekeeper uyarısı alırsanız:
- Uygulamaya sağ tıklayıp **Aç**'ı seçin ya da terminalden:
  ```bash
  xattr -cr /Applications/Monomem.app
  ```

---

## 🔒 Güvenlik ve Gizlilik

Bu dağıtım deposu **sıfır kaynak kod sızıntısı** ilkesiyle yönetilir. Yalnızca derlenmiş ikili dosyalar (binary), doğrulanmış Docker imajları ve açık kaynak kurulum şablonları barındırılır.

Lisans: [MIT](LICENSE)
