# Guia de Contribuição

Obrigado por considerar contribuir com o app do MacMagazine! Este guia detalha todo o processo, desde a configuração do ambiente até a aprovação do seu Pull Request.

## Sumário

1. [Pré-requisitos](#pré-requisitos)
2. [Configuração do ambiente](#configuração-do-ambiente)
3. [Fluxo de trabalho](#fluxo-de-trabalho)
4. [Padrões de código](#padrões-de-código)
5. [Executando testes](#executando-testes)
6. [Criando um Pull Request](#criando-um-pull-request)
7. [Validações automáticas](#validações-automáticas)
8. [Processo de revisão](#processo-de-revisão)

---

## Pré-requisitos

Antes de começar, certifique-se de ter:

- **Xcode**: Última versão disponível na App Store
- **Swift**: Versão incluída no Xcode mais recente
- **SwiftLint**: Para validação de código
  ```bash
  brew install swiftlint
  ```
- **Git**: Para controle de versão
- **Conta no GitHub**: Para criar forks e pull requests

---

## Configuração do ambiente

### 1. Clone o repositório

```bash
# Fork o repositório no GitHub primeiro, depois clone seu fork
git clone https://github.com/SEU_USUARIO/app-iOS.git
cd app-iOS

# Adicione o repositório original como upstream
git remote add upstream https://github.com/MacMagazine/app-iOS.git
```

### 2. Configure o Firebase

O projeto usa Firebase para analytics. Execute o script de configuração:

```bash
./Support/Scripts/setup-firebase.sh
```

Isso cria um arquivo de configuração local com valores de placeholder. O app funciona normalmente sem credenciais reais do Firebase.

Para mais detalhes, consulte [Support/Scripts/README.md](Support/Scripts/README.md).

### 3. Abra o projeto no Xcode

```bash
open MacMagazine/MacMagazine.xcodeproj
```

### 4. Resolva as dependências

O Xcode resolverá automaticamente os Swift Packages na primeira abertura. Aguarde o download completar.

### 5. Selecione o scheme e dispositivo

- Scheme: `MacMagazine`
- Dispositivo: Simulador iOS 26+ (iPhone ou iPad)

### 6. Build inicial

Pressione `Cmd + B` para verificar se o projeto compila corretamente.

---

## Fluxo de trabalho

### 1. Mantenha seu fork atualizado

Antes de começar qualquer trabalho, sincronize com o repositório principal:

```bash
git fetch upstream
git checkout release/v5
git merge upstream/release/v5
git push origin release/v5
```

### 2. Crie uma branch

Use o padrão de nomenclatura adequado:

| Tipo | Prefixo | Exemplo |
|------|---------|---------|
| Bug fix | `hotfix/` | `hotfix/fix-91-tableview-crash` |
| Nova funcionalidade | `feature/` | `feature/add-dark-mode-toggle` |
| Documentação | `docs/` | `docs/update-readme` |
| Refatoração | `refactor/` | `refactor/improve-feed-parser` |

```bash
# Para bug fixes (inclua o número da issue)
git checkout -b hotfix/fix-123-descricao-curta

# Para novas funcionalidades
git checkout -b feature/nome-da-feature
```

### 3. Desenvolva

- Faça commits pequenos e frequentes
- Escreva mensagens de commit descritivas
- Mantenha o escopo focado na issue/feature

### 4. Teste localmente

Antes de criar o PR, certifique-se de que:

- [ ] O código compila sem erros
- [ ] SwiftLint não reporta erros
- [ ] Todos os testes passam
- [ ] Você testou manualmente a funcionalidade

---

## Padrões de código

### SwiftLint

O projeto usa [SwiftLint](https://github.com/realm/SwiftLint) para manter a consistência do código.

```bash
# Verificar erros de lint
swiftlint lint

# Corrigir automaticamente quando possível
swiftlint lint --fix
```

### Code Style

Seguimos o [Swift Style Guide do Ray Wenderlich](https://github.com/raywenderlich/swift-style-guide). Principais pontos:

- Use `camelCase` para variáveis e funções
- Use `PascalCase` para tipos
- Prefira `let` sobre `var` quando possível
- Use `guard` para early exits
- Documente APIs públicas

### Arquitetura

- O projeto é modular usando Swift Package Manager
- Cada feature tem seu próprio package em `MacMagazine/Features/`
- Use SwiftUI para novas views
- Use Swift Concurrency (`async/await`) para código assíncrono

---

## Executando testes

### Via Xcode

1. Selecione o scheme `MacMagazine`
2. Pressione `Cmd + U` para rodar todos os testes
3. Ou use `Product > Test Plan > MacMagazine` para o test plan completo

### Via linha de comando

```bash
xcodebuild test \
  -project MacMagazine/MacMagazine.xcodeproj \
  -scheme MacMagazine \
  -testPlan MacMagazine \
  -destination "platform=iOS Simulator,name=iPhone 16 Pro" \
  -skipPackagePluginValidation \
  -skipMacroValidation
```

---

## Criando um Pull Request

### 1. Push da sua branch

```bash
git push origin sua-branch
```

### 2. Abra o Pull Request

Vá ao GitHub e clique em "Compare & pull request".

### 3. Título do PR (IMPORTANTE)

O título **DEVE** seguir o formato [Conventional Commits](https://www.conventionalcommits.org/):

```
<tipo>[escopo opcional]: <descrição>
```

#### Tipos válidos

| Tipo | Descrição |
|------|-----------|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `docs` | Apenas documentação |
| `style` | Formatação, sem mudança de código |
| `refactor` | Refatoração de código |
| `perf` | Melhoria de performance |
| `test` | Adição ou correção de testes |
| `chore` | Tarefas de manutenção |
| `build` | Mudanças no sistema de build |
| `ci` | Mudanças em CI/CD |
| `revert` | Reverter commit anterior |

#### Exemplos de títulos válidos

```
feat: add push notification settings screen
fix(#123): resolve crash on feed refresh
docs: update contribution guidelines
refactor: improve date parsing performance
```

#### Regra especial para `fix`

PRs do tipo `fix` **DEVEM** incluir o número da issue:

```
fix(#123): resolve authentication timeout
```

### 4. Preencha o template

O PR template será carregado automaticamente. Preencha todas as seções:

- **Description**: Descreva suas mudanças
- **Type of Change**: Marque o tipo apropriado
- **Related Issue**: Link para a issue (ex: `Fixes #123`)
- **Screenshots/Videos**: Adicione evidências visuais
- **Testing**: Descreva como testou
- **Checklist**: Marque os itens completados

### 5. Verifique a base branch

Certifique-se de que o PR aponta para a branch correta:
- `release/v5` para a maioria das contribuições
- `develop` para desenvolvimento ativo

---

## Validações automáticas

Quando você abre um PR, o GitHub Actions executa validações automáticas:

### 1. Branch atualizada

Sua branch deve estar sincronizada com a branch base. Se não estiver:

```bash
git fetch origin release/v5
git rebase origin/release/v5
git push --force-with-lease origin sua-branch
```

### 2. Título do PR

O título deve seguir Conventional Commits (veja seção anterior).

### 3. SwiftLint

O código deve passar em todas as verificações do SwiftLint:

```bash
swiftlint lint --strict
```

### 4. Testes

Todos os testes devem passar. Verifique localmente antes de criar o PR.

### Status das validações

| Status | Significado |
|--------|-------------|
| Passing (verde) | Todas as verificações passaram |
| Failing (vermelho) | Alguma verificação falhou - veja os logs |
| Pending (amarelo) | Verificações em andamento |

Se alguma verificação falhar, clique em "Details" para ver os logs e corrigir o problema.

---

## Processo de revisão

### 1. Aguarde revisão

Um membro da equipe revisará seu PR. Isso pode incluir:

- Feedback sobre código
- Sugestões de melhorias
- Perguntas sobre implementação

### 2. Responda aos comentários

- Responda a todos os comentários
- Faça as alterações solicitadas
- Marque conversas como resolvidas quando apropriado

### 3. Atualize seu PR

Após fazer alterações:

```bash
git add .
git commit -m "address review feedback"
git push origin sua-branch
```

### 4. Aprovação e merge

- Após aprovação, um maintainer fará o merge
- Não faça squash de commits antes do merge (usamos squash merge)
- Sua branch será deletada automaticamente após o merge

---

## Dúvidas?

- Abra uma [issue](https://github.com/MacMagazine/app-iOS/issues) para perguntas
- Consulte issues existentes para ver se sua dúvida já foi respondida

---

Obrigado por contribuir!

Equipe MM :-)
