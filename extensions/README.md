# Monomem Eklentileri ve Araç Köprüleri

Bu dizin, Monomem ekosistemine entegre olabilen tarayıcı uzantıları, MCP (Model Context Protocol) adaptörleri ve istemci eklentileri için kılavuzları içerir.

---

## 1. Tarayıcı Eklentisi (Chrome / Brave / Edge)

Web sayfalarını, makaleleri ve araştırma notlarını tek tıkla Monomem'in hibrit RAG hafızasına aktarır.

### Kurulum (Geliştirici Modu / Sideload):
1. Eklenti arşivini indirin ve bir klasöre çıkartın.
2. Tarayıcınızda `chrome://extensions` adresine gidin.
3. Sağ üstten **Geliştirici modu**'nu (Developer mode) açın.
4. **Paketlenmemiş öğe yükle** (Load unpacked) düğmesine tıklayarak çıkarttığınız klasörü seçin.
5. Eklenti simgesine tıklayıp Monomem sunucu adresinizi (`http://localhost:8788` veya `https://monomem.frax.tr`) ve erişim tokenınızı girin.

---

## 2. MCP (Model Context Protocol) Ajan Köprüsü

Terminal veya IDE ajanlarınızı (Claude Code, OpenAI Codex, Google Antigravity `agy`) doğrudan Monomem'in hafızasına bağlar.

### Claude Code Yapılandırması:
`~/.claude/config.json` veya proje ayarlarınıza ekleyin:
```json
{
  "mcpServers": {
    "monomem": {
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
- `remember`: Yeni bir kararı veya bilgiyi kalıcı hafızaya yazar.
- `search_memory`: Geniş kapsamlı bilgi taraması yürütür.
