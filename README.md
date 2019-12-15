# App do MacMagazine para iOS
[![Build Status](https://travis-ci.org/MacMagazine/app-iOS.svg?branch=release%2F4.0)](https://travis-ci.org/MacMagazine/app-iOS)
[![Build Status](https://app.bitrise.io/app/6f28cb498b13bb1c/status.svg?token=2PD4qUNQM_mN0irLn8idyA)](https://app.bitrise.io/app/6f28cb498b13bb1c)

O aplicativo do MacMagazine agora é um projeto de código aberto (_open source_), para que a enorme comunidade de desenvolvedores/leitores do site possa colaborar e construir um app cada vez melhor e mais completo.

## Funcionalidades existentes
- Posts com imagens dos artigos
- Compartilhamento de posts
- Favoritar posts
- Podcasts, com compartilhamento e favoritar
- Videos, com compartilhamento e favoritar
- Buscas em Posts, Podcasts e Videos
- Notificações _push_ de todos os posts ou apenas de destaques
- `WKWebView` para leitura dos artigos e visualização dos comentários
- Modo Escuro
- Opcão de tamanho de fontes para melhor visualização
- App para `watchOS`

## Bug Reporting e Feature request
Use as [Issues](https://github.com/MacMagazine/app-iOS/issues) para cadastrar problemas encontrados ou features desejadas.

## Instruções para colaboração
Optamos pela não utilização de Gerenciadores de Dependências, como Cocoapods ou Carthage, para permitir um melhor entendimento do projeto, além de servir como estudo de Swift. Porém se tiver uma biblioteca que realmente faça a diferença no projeto, use Carthage.

Tenha sempre seu Xcode e Swift atualizado na última versão e a versão de iOS suportada é 11+.

Antes de iniciar seu desenvolvimento, o código-fonte está disponível aqui mesmo neste repositório, na branch `release/4.0`.

Instale o utitlitário [swiftlint](https://github.com/realm/SwiftLint) e observe o [code style](https://github.com/raywenderlich/swift-style-guide) para manter o padrão no desenvolvimento.

Para cada bug/nova funcionalidade que for desenvolver, crie uma nova branch, no formato `hotfix/[descricao]` (no título, mencione o número do issue, usando hashtag (ex: branch: `hotfix/Fix_91_TableView_bug` e título: `Correção #91 TableView bug`)) ou `feature/[descricao]` para nova funcionalidade e utilize [Pull Requests](https://github.com/MacMagazine/app-iOS/pulls) para enviar o código para aprovação do nosso time de revisores.

Bom desenvolvimento.

Equipe MM
:-)
