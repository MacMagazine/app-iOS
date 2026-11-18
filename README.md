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

## Desenvolvimento com IA (Claude Code)

O projeto é configurado para desenvolvimento assistido por IA usando o [Claude Code](https://code.claude.com/docs/), com guardrails que garantem que o código gerado siga os padrões do projeto.

### Como funciona

O arquivo [CLAUDE.md](CLAUDE.md) é a "constituição" do projeto — carregado em toda sessão, define as regras de ouro, comandos de build e o contrato anti-alucinação. O detalhamento fica em `.claude/`:

```
CLAUDE.md             ← regras principais (carregado em toda sessão)
.claude/
  rules/              ← convenções detalhadas, lidas sob demanda
                        (arquitetura, cards/WebView/tema, SwiftData/busca,
                         estilo Swift, concorrência, testes, git)
  skills/             ← workflows reutilizáveis (/ios-start, /ios-implement,
                        /ios-fix, /ios-dod, /ios-design-guidelines,
                        /ios-sanity-check, /factory)
  agents/             ← subagentes especializados (ios-principal-engineer,
                        swift-code-reviewer, architecture-guardian, test-runner
                        + agentes da factory: intake, spec-writer, builder,
                          reviewer-*, approver)
  hooks/              ← guardrails determinísticos (bloqueiam comandos
                        perigosos e rodam SwiftLint a cada arquivo editado)
  settings.json       ← permissões compartilhadas + ativação dos hooks
```

### Como usar

```bash
# Na raiz do repositório — o CLAUDE.md carrega automaticamente
claude

# Fluxo típico de uma feature
> /ios-start          # checklist antes de escrever código
> /ios-implement      # implementação seguindo os padrões do projeto
> /ios-dod            # Definition of Done: build + testes + lint reais

# Correção de bug
> /ios-fix            # análise de causa raiz antes de qualquer correção

# Revisão e auditoria
> use o agente swift-code-reviewer       # revisão rigorosa do diff
> use o agente architecture-guardian     # verifica fronteiras entre módulos
> /ios-sanity-check                      # auditoria de saúde do código
```

### Guardrails

- **Permissões** (`.claude/settings.json`): toolchain pré-aprovado (xcodebuild, swiftlint, git, gh); leitura de segredos (`GoogleService-Info.plist`, `*.xcconfig`, certificados) e comandos destrutivos negados.
- **Hooks**: `rm -rf`, `sudo`, force-push e `git reset --hard` são bloqueados; todo arquivo Swift editado passa por `swiftlint --strict` na hora; `try!`, `as!` e `@unchecked Sendable` são rejeitados automaticamente.
- **Qualidade**: nada é considerado "pronto" sem build, testes e lint passando com saída real — nunca resultados presumidos.

Preferências pessoais (modelo, permissões extras da sua máquina) vão em `.claude/settings.local.json`, que não é versionado.

## Software Factory

A **factory** transforma issues do GitHub em Pull Requests de forma autônoma, usando agentes do Claude Code. Cada issue com o label `factory` passa por um pipeline com portões de qualidade, e **um PR é criado por issue**.

### Pipeline

```
intake      → decide ACCEPT, NEEDS-INFO ou REJECT (comenta na issue)
route       → escolhe revisores e modelos conforme risco/superfícies da issue
spec-writer → escreve spec.md com critérios de aceite testáveis
builder     → implementa na branch factory/<job-id> e abre o PR em rascunho
gate        → factory/checks.sh (SwiftLint --strict + xcodebuild test)
reviewers   → code, ux, ui, security (conforme o roteamento), em paralelo
approver    → APPROVE (merge automático) ou ESCALATE (vai para um humano)
```

Se o gate ou algum revisor reprovar, o builder recebe o feedback e faz uma nova rodada (máximo de `max_rounds`, hoje 3). Esgotadas as rodadas, o job vai para `needs-human`.

### Pré-requisitos

- [Claude Code](https://code.claude.com/docs/) e [GitHub CLI](https://cli.github.com/) (`gh`) instalados e autenticados
- Setup do Firebase concluído (veja [Configuração rápida](#configuração-rápida)); o `checks.sh` copia o template do `GoogleService-Info.plist` se ele não existir
- Labels `factory`, `factory:needs-info` e `factory:needs-human` criados no repositório

### Como usar

1. Abra uma issue descrevendo a mudança e aplique o label `factory`. O label é a fronteira de confiança: só quem tem permissão de triagem/escrita consegue aplicá-lo.
2. Na raiz do repositório, abra o Claude Code e execute:

```bash
claude

> /factory run          # processa todas as issues com o label `factory`
> /factory run 123      # processa somente a issue #123
> /factory              # conversar com a factory: status, custo, feedback, nova feature
```

A sessão que roda `/factory` vira o **orquestrador único**: ela dispara os agentes de cada job, mas nunca escreve código nem edita o estado diretamente. Se a sessão cair, basta rodar `/factory run` de novo: o estado fica em arquivos e os jobs são retomados de onde pararam.

### Quando a factory pede ajuda

| Estado | Significado | O que fazer |
|--------|-------------|-------------|
| `needs-info` | O intake precisa de mais informações | Responda na issue (ou via `/factory`) e rode `/factory run` |
| `needs-human` | O approver escalou, ou as rodadas acabaram | Revise o PR e faça o merge, ou dê feedback com `/factory` |
| `rejected` | O intake recusou a issue | Veja o comentário na issue |

Exemplos:

```bash
> /factory o que o reviewer de segurança disse sobre o job 003?
> /factory feedback no job 003: use o card existente em vez de criar um novo
> /factory rejeite o job 004: não vamos mais fazer isso
```

Um PR pode ser mergeado manualmente a qualquer momento; a factory detecta o merge e encerra o job.

### Configuração e arquivos

| Caminho | Descrição |
|---------|-----------|
| `factory/config.json` | Concorrência, número de rodadas, branch base (`release/v5`), labels, roteamento de revisores/modelos |
| `factory/checks.sh` | Checagens executadas pelo gate (SwiftLint estrito + testes) |
| `factory/bin/` | Scripts (`job`, `gate`, `route`): únicos que alteram o estado dos jobs |
| `factory/jobs/` | Estado em tempo de execução de cada job (ignorado pelo git) |
| `.worktrees/<job-id>/` | Checkout isolado de cada job (ignorado pelo git) |

Cada job vive em `factory/jobs/<job-id>/` com `issue.md`, `intake.md`, `spec.md`, `build.md`, os resultados de cada rodada (`round-N/`) e `decision.md`.

### Dashboard

Acompanhe os jobs em tempo real:

```bash
python3 -m http.server --directory factory
# abra http://localhost:8000/dashboard.html
```

### Garantias

- Somente issues com o label `factory` são executadas; o texto da issue chega aos agentes apenas como dado citado.
- Agentes só fazem push na branch `factory/<job-id>`; o merge acontece apenas via `factory/bin/job merge` (`gh pr merge`), e a factory nunca faz deploy.
- `factory/checks.sh` e `factory/config.json` são caminhos protegidos.

## Bug Reporting e Feature Requests

Use as [Issues](https://github.com/MacMagazine/app-iOS/issues) para:
- Reportar problemas encontrados
- Sugerir novas funcionalidades

## Documentação adicional

| Documento | Descrição |
|-----------|-----------|
| [CONTRIBUTING.md](Support/CONTRIBUTING.md) | Guia completo de contribuição |
| [FIREBASE.md](Support/FIREBASE.md) | Configuração do Firebase |
| [CLAUDE.md](CLAUDE.md) | Regras para desenvolvimento assistido por IA (Claude Code) |
| [.claude/skills/README.md](.claude/skills/README.md) | Referência rápida de skills e agentes |

---

Bom desenvolvimento!

Equipe MM :-)
