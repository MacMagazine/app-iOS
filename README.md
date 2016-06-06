# MacMagazine-iOS
O aplicativo do MacMagazine agora é um projeto de código aberto (open source), para que a enorme comunidade de desenvolvedores/leitores do site possa colaborar e construir um app cada vez melhor e mais completo.

O código-fonte está disponível aqui mesmo neste repositório.
Para aqueles quiserem colaborar com o projeto, é só usar os [Pull Requests](https://github.com/madeatsampa/MacMagazine-iOS/pulls) para submeter correções de bugs ou novas funcionalidades ao app.

## Funcionalidades existentes
- Lista de posts com imagens dos artigos
- Compartilhamento de posts
- Notificações push de todos os posts ou apenas de destaques
- `WKWebView` para leitura dos artigos e visualização dos comentários

## Bug Reporting e Feature request
Use as [Issues](https://github.com/madeatsampa/MacMagazine-iOS/issues) para cadastrar problemas encontrados ou features desejadas.

### Instruções de instalação
Este projeto usa [CocoaPods](https://cocoapods.org). Colocar tudo pra funcionar é super simples.
Depois de clonar o projeto, é só instalar os `pods`, usando o [Bundler](http://bundler.io), com os seguintes comandos no `path` do projeto:

`bundle install`

`bundle exec pod install`

Ah, nós usamos um token para registrar novos devices no servidor de notificações. Quando o `cocoapods-keys` pedir por uma chave de pushes é só digitar `enter` (manter o valor em branco) que a instalação dos pods prossegue sem problemas.

:)
