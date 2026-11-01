# Aqutopus Eklentileri ve Araç Köprüleri 🐙

Bu dizin, **Aqutopus** ekosistemine entegre olabilen tarayıcı uzantıları, Model Context Protocol (MCP) adaptörleri ve istemci eklentileri için resmi kılavuzları içerir.

---

## 1. Tarayıcı Eklentisi (Chrome / Brave / Edge)

Web sayfalarını, teknik makaleleri, GitHub PR'larını ve araştırma notlarını tek tıkla Aqutopus'un hibrit RAG hafızasına aktarır.

### Kurulum (Geliştirici Modu / Sideload):
1. Eklenti arşivini indirin ve bir klasöre çıkartın.
2. Chromium tabanlı tarayıcınızda `chrome://extensions` adresine gidin.
3. Sağ üstten **Geliştirici modu**'nu (Developer mode) açın.
4. **Paketlenmemiş öğe yükle** (Load unpacked) düğmesine tıklayarak çıkarttığınız klasörü seçin.
5. Eklenti simgesine tıklayıp Aqutopus sunucu adresinizi (`http://localhost:8788` veya `https://monomem.frax.tr`) ve kullanıcı erişim tokenınızı girin.

---

## 2. MCP (Model Context Protocol) Ajan Köprüsü

Terminal veya IDE ajanlarınızı (Claude Code, OpenAI Codex, Google Antigravity `agy`) doğrudan Aqutopus'un hibrit hafızasına bağlar.

### Claude Code Yapılandırması:
`~/.claude/config.json` veya proje ayarlarınıza ekleyin:
```json
{
  "mcpServers": {
    "aqutopus": {
      "url": "https://monomem.frax.tr/mcp",
      "headers": {
        "Authorization": "Bearer <MCP_TOKENUNUZ>"
      }
    }
  }
}
```

### Sunulan Başlıca MCP Araçları:
- `recall`: Hibrit vektör ve tam metin aramasıyla ilgili hafıza notlarını ve geçmiş konuşmaları getirir.
- `remember`: Yeni bir kararı veya teknik kuralı kalıcı hafızaya yazar.
- `search_memory`: Geniş kapsamlı bilgi ve belge taraması yürütür.
