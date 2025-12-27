# App do MacMagazine para iOS

![Build Status](https://app.bitrise.io/app/b04bb172ee4330fd/status.svg?token=hWsWH4V5VQAavaZAQZMEhA&branch=release/v5)

O aplicativo do MacMagazine agora é um projeto de código aberto (_open source_), para que a enorme comunidade de desenvolvedores/leitores do site possa colaborar e construir um app cada vez melhor e mais completo.

## Funcionalidades

- Posts com imagens dos artigos
- Compartilhamento de posts
- Favoritar posts
- Podcasts, com compartilhamento e favoritar
- Videos, com compartilhamento e favoritar
- Buscas em Posts, Podcasts e Videos
- Notificações _push_ de todos os posts ou apenas de destaques
- `WKWebView` para leitura dos artigos e visualização dos comentários
- Modo Escuro
- Fontes dinâmicas para melhor visualização
- Leitura dos posts em fullscreen no iPad
- App para `watchOS`
- Widgets, tanto na Lock Screen como na Home screen

## Sobre esta versão

- Totalmente escrita em Swift e usando SwiftUI
- Interface Liquid Glass
- Design diferenciado por plataforma: iOS, iPadOS, macOS e watchOS
- Totalmente modular usando Swift Package Manager
- Analytics usando Firebase
- Uso de Swift Concurrency, SwiftData, SwiftTest
- Sincronização entre dispositivos usando iCloud

## Requisitos

- Xcode e Swift atualizados na última versão
- iOS 26+

## Começando

Para instruções completas sobre como configurar o ambiente, contribuir com código, criar pull requests e muito mais, consulte nosso **[Guia de Contribuição](Support/CONTRIBUTING.md)**.

### Configuração rápida

```bash
# Clone o repositório
git clone https://github.com/MacMagazine/app-iOS.git
cd app-iOS

# Configure o Firebase (cria arquivo de configuração local)
./Support/Scripts/setup-firebase.sh

# Abra o projeto no Xcode
open MacMagazine/MacMagazine.xcodeproj
```

## Contribuindo

Quer contribuir? Consulte o **[Guia de Contribuição](Support/CONTRIBUTING.md)** para instruções detalhadas sobre:

- Configuração do ambiente de desenvolvimento
- Padrões de código e SwiftLint
- Fluxo de trabalho com branches
- Como criar Pull Requests
- Validações automáticas (GitHub Actions)

## Bug Reporting e Feature Requests

Use as [Issues](https://github.com/MacMagazine/app-iOS/issues) para:
- Reportar problemas encontrados
- Sugerir novas funcionalidades

## Documentação adicional

| Documento | Descrição |
|-----------|-----------|
| [CONTRIBUTING.md](Support/CONTRIBUTING.md) | Guia completo de contribuição |
| [FIREBASE.md](Support/FIREBASE.md) | Configuração do Firebase |

---

Bom desenvolvimento!

Equipe MM :-)
