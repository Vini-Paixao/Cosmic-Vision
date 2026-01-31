---
applyTo: '**'
---
# Prompt para Desenvolvimento: Cosmic Vision - NASA APOD Viewer

## Visão Geral do Projeto
Cosmic Vision é um aplicativo mobile multiplataforma (Android/iOS) desenvolvido em Flutter que conecta os usuários com o universo através da API APOD (Astronomy Picture of the Day) da NASA. O app oferece uma experiência imersiva e visualmente deslumbrante para explorar imagens astronômicas desde 1995 até hoje.

## 🎨 Identidade Visual e Design System

### Paleta de Cores Cósmica

#### Cores Principais
- **Deep Space (Primária):** `#0B0D21` - Azul escuro profundo do espaço sideral
- **Nebula Purple (Secundária):** `#6B4CE6` - Roxo vibrante inspirado em nebulosas
- **Cosmic Blue (Terciária):** `#1E3A8A` - Azul cósmico profundo
- **Stardust (Accent):** `#818CF8` - Azul-lavanda luminoso para destaques

#### Cores de Suporte
- **Supernova Orange:** `#FF6B35` - Laranja energético para CTAs importantes
- **Galactic Teal:** `#06B6D4` - Ciano brilhante para elementos interativos
- **Moonlight White:** `#F8FAFC` - Branco suave para textos e backgrounds claros
- **Asteroid Gray:** `#64748B` - Cinza neutro para textos secundários
- **Event Horizon:** `#1E293B` - Cinza escuro para cards e superfícies

#### Gradientes Cósmicos
- **Gradient 1 (Galaxy):** Linear de `#0B0D21` → `#1E3A8A` → `#6B4CE6`
- **Gradient 2 (Nebula):** Linear de `#6B4CE6` → `#818CF8` → `#06B6D4`
- **Gradient 3 (Aurora):** Linear de `#FF6B35` → `#6B4CE6` → `#1E3A8A`

### Tipografia

#### Fonte Padrão: Poppins
```yaml
Hierarquia Tipográfica:
- Display Large: Poppins Bold, 57sp
- Display Medium: Poppins Bold, 45sp
- Display Small: Poppins Bold, 36sp
- Headline Large: Poppins SemiBold, 32sp
- Headline Medium: Poppins SemiBold, 28sp
- Headline Small: Poppins SemiBold, 24sp
- Title Large: Poppins SemiBold, 22sp
- Title Medium: Poppins Medium, 16sp
- Title Small: Poppins Medium, 14sp
- Body Large: Poppins Regular, 16sp
- Body Medium: Poppins Regular, 14sp
- Body Small: Poppins Regular, 12sp
- Label Large: Poppins Medium, 14sp
- Label Medium: Poppins Medium, 12sp
- Label Small: Poppins Medium, 11sp
```

### Espaçamento e Grid
- **Unidade Base:** 8dp
- **Padding Padrão:** 16dp (2 unidades)
- **Margens de Cards:** 16dp horizontal, 12dp vertical
- **Border Radius Padrão:** 16dp
- **Border Radius Cards:** 20dp
- **Border Radius Buttons:** 12dp

### Elevação e Sombras
```dart
Sombras Cósmicas (com tom azulado):
- Elevation 1: offset(0,2), blur 4, color #6B4CE6 com 10% opacity
- Elevation 2: offset(0,4), blur 8, color #6B4CE6 com 15% opacity
- Elevation 3: offset(0,8), blur 16, color #6B4CE6 com 20% opacity
- Glow Effect: offset(0,0), blur 20, color #818CF8 com 30% opacity
```

### Efeitos Visuais

#### Elementos de Atmosfera Cósmica
- **Particle Effects:** Pequenas estrelas animadas no background
- **Shimmer Loading:** Efeito de brilho estelar durante carregamentos
- **Glassmorphism:** Cards com efeito de vidro fosco e blur
- **Glow Buttons:** Botões com brilho sutil em hover/press

#### Animações
- **Transições de Tela:** Slide com fade (300ms, curve: easeInOut)
- **Loading States:** Shimmer com movimento estelar
- **Image Reveal:** Fade in progressivo com scale sutil (400ms)
- **Button Press:** Scale down para 0.95 (100ms)
- **Card Hover:** Elevação aumenta + glow effect (200ms)

## 📱 Estrutura de Telas e Funcionalidades

### 1. Splash Screen
**Elementos:**
- Logo do Cosmic Vision centralizado
- Animação de estrelas piscando no background
- Gradient Galaxy como fundo
- Loader minimalista (circular com glow effect)

### 2. Tela Principal (Home) - Imagem do Dia
**Layout:**
- **AppBar customizada:**
  - Título "Cosmic Vision" (Poppins SemiBold, 24sp)
  - Ícone de menu/configurações no topo direito
  - Background transparente com blur (glassmorphism)
  
- **Imagem Destacada:**
  - Card principal com border radius 20dp
  - Imagem APOD do dia em alta resolução
  - Shimmer loading enquanto carrega
  - Padding 16dp
  
- **Informações da Imagem:**
  - Card secundário abaixo da imagem com glassmorphism
  - Título da imagem (Poppins SemiBold, 20sp)
  - Data (Poppins Regular, 14sp, cor Asteroid Gray)
  - Descrição expandível (Poppins Regular, 14sp)
  - Badge de tipo (Imagem/Vídeo) com cor Galactic Teal
  
- **Botões de Ação:**
  - Row com 3 botões:
    1. Download (ícone + label)
    2. Compartilhar (ícone + label)
    3. Favoritar (ícone + label)
  - Botões com background Nebula Purple e glow effect
  - Border radius 12dp

- **Navegação Inferior:**
  - BottomNavigationBar customizada
  - 4 itens: Home, Explorar, Favoritos, Configurações
  - Ícones com animação de seleção
  - Background Event Horizon com glassmorphism

### 3. Tela de Exploração (Explore)
**Seções:**

#### A) Explorar por Data
- DatePicker customizado com tema cósmico
- Botão "Ver Imagem" (Supernova Orange)
- Calendário com datas disponíveis destacadas

#### B) Explorar por Período
- Dois DatePickers (Data Início e Data Fim)
- Validação de período (máx. 30 dias)
- Lista/Grid de resultados com scroll infinito
- Cards menores com preview da imagem

#### C) Imagens Aleatórias
- Slider para selecionar quantidade (1-10)
- Botão "Surpreenda-me" (Gradient Nebula)
- Grid responsivo com imagens aleatórias
- Loading com animação de estrelas

**Layout Geral:**
- TabBar no topo com 3 tabs estilizadas
- Indicador customizado (Stardust color)
- Padding consistente de 16dp
- Cards com elevation 2

### 4. Tela de Favoritos
**Layout:**
- Lista/Grid de imagens favoritadas
- Opção de visualização (Lista ou Grid)
- Card compacto com:
  - Thumbnail da imagem
  - Título truncado
  - Data
  - Ícone de remover favorito
- Empty state bonito quando sem favoritos
- Busca/filtro por título ou data

### 5. Tela de Configurações
**Seções:**
- **Notificações:**
  - Toggle para lembrete diário
  - Seletor de horário
  
- **Tema:**
  - Opção Dark/Light (app focado em dark)
  
- **Qualidade de Imagem:**
  - Opções: SD, HD, Original
  
- **Cache:**
  - Limpar cache de imagens
  - Tamanho atual do cache
  
- **Sobre:**
  - Versão do app
  - Créditos NASA APOD
  - Link para API
  - Desenvolvedor

### 6. Tela de Detalhes da Imagem (Full Screen)
**Layout:**
- Imagem em tela cheia com zoom/pinch
- Overlay com informações (pode ser ocultado)
- Botões de ação flutuantes
- Transição hero animation da home
- Swipe para navegar entre datas (opcional)

## 🏗️ Arquitetura e Estrutura do Projeto

### Padrão de Arquitetura: Clean Architecture + MVVM

```
lib/
├── main.dart
├── app/
│   ├── app.dart (MaterialApp principal)
│   └── themes/
│       ├── app_theme.dart (tema claro/escuro)
│       ├── app_colors.dart (paleta de cores)
│       ├── app_text_styles.dart (estilos de texto)
│       ├── app_dimensions.dart (espaçamentos)
│       ├── app_gradients.dart (gradientes cósmicos)
│       └── app_shadows.dart (sombras com glow)
├── core/
│   ├── constants/
│   │   ├── api_constants.dart (config da API NASA)
│   │   ├── app_constants.dart (constantes gerais + cache)
│   │   └── route_constants.dart (rotas nomeadas)
│   ├── utils/
│   │   ├── logger.dart (logging estruturado)
│   │   └── result.dart (Result pattern para erros)
│   ├── extensions/
│   │   ├── context_extensions.dart
│   │   ├── date_extensions.dart
│   │   └── string_extensions.dart
│   └── errors/
│       ├── exceptions.dart (exceções customizadas)
│       └── failures.dart (failures para camada domain)
├── data/
│   ├── models/
│   │   ├── apod_model.dart (com toDatabase/fromDatabase)
│   │   └── favorite_model.dart
│   ├── repositories/
│   │   ├── apod_repository_impl.dart (cache-first strategy)
│   │   ├── favorites_repository_impl.dart
│   │   └── settings_repository_impl.dart
│   └── datasources/
│       ├── remote/
│       │   └── apod_remote_datasource.dart (API NASA)
│       └── local/
│           ├── database_helper.dart (SQLite config)
│           ├── apod_local_datasource.dart (cache de APODs)
│           ├── favorites_local_datasource.dart
│           └── settings_local_datasource.dart
├── di/
│   └── dependency_injection.dart (service locator)
├── domain/
│   ├── entities/
│   │   ├── apod_entity.dart
│   │   └── favorite_entity.dart
│   └── repositories/
│       ├── apod_repository.dart (interface)
│       ├── favorites_repository.dart
│       └── settings_repository.dart
├── presentation/
│   ├── widgets/
│   │   ├── cosmic_card.dart
│   │   ├── cosmic_button.dart
│   │   ├── cosmic_app_bar.dart
│   │   ├── loading_shimmer.dart
│   │   └── error_view.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── explore_screen.dart
│   │   ├── favorites_screen.dart
│   │   ├── settings_screen.dart (com seção de cache)
│   │   └── detail_screen.dart
│   └── viewmodels/
│       ├── base_viewmodel.dart
│       ├── home_viewmodel.dart
│       ├── explore_viewmodel.dart
│       ├── favorites_viewmodel.dart
│       └── settings_viewmodel.dart (com cache stats)
└── services/
    ├── cache_service.dart (gerenciamento de cache)
    ├── favorites_sync_service.dart
    └── image_service.dart (download/share)
```

## 🔧 Dependências Principais Sugeridas

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # HTTP Client
  dio: ^5.4.0
  
  # Local Storage
  shared_preferences: ^2.2.2
  sqflite: ^2.3.0
  
  # Cache de Imagens
  cached_network_image: ^3.3.0
  
  # Date Picker
  flutter_datetime_picker_plus: ^2.1.0
  
  # Notificações
  flutter_local_notifications: ^16.3.0
  
  # Download
  path_provider: ^2.1.1
  permission_handler: ^11.1.0
  
  # Share
  share_plus: ^7.2.1
  
  # Loading
  shimmer: ^3.0.0
  
  # Image Viewer
  photo_view: ^0.14.0
  
  # Animações
  lottie: ^2.7.0
  
  # Icons
  flutter_svg: ^2.0.9
```

## 🎯 Fluxo de Desenvolvimento Inicial

### Fase 1: Setup e Design System
1. Criar projeto Flutter com suporte Android/iOS
2. Configurar estrutura de pastas (Clean Architecture)
3. Implementar Design System completo:
   - `app_colors.dart` com todas as cores
   - `app_text_styles.dart` com Poppins configurada
   - `app_theme.dart` com ThemeData customizado
   - `app_dimensions.dart` com espaçamentos
4. Criar widgets base reutilizáveis

### Fase 2: Integração com API
1. Setup de serviço HTTP (Dio)
2. Criar models para APOD Response
3. Implementar repository pattern
4. Criar casos de uso para cada funcionalidade

### Fase 3: Telas Principais
1. Splash Screen com animação
2. Home Screen com imagem do dia
3. Sistema de navegação (BottomNavBar)
4. Tela de detalhes com hero animation

### Fase 4: Funcionalidades Core
1. Exploração por data
2. Exploração por período
3. Imagens aleatórias
4. Sistema de favoritos (local storage)

### Fase 5: Features Adicionais
1. Download de imagens
2. Compartilhamento
3. Notificações diárias
4. Cache de imagens

### Fase 6: Sistema de Cache Offline ✅
1. Tabela `apod_cache` no SQLite para persistir APODs
2. `ApodLocalDataSource` com operações de cache
3. Estratégia cache-first no `ApodRepositoryImpl`
4. `CacheService` para gerenciamento e limpeza
5. Pré-carregamento automático dos últimos 14 dias
6. Seção de cache nas Configurações

### Fase 7: Polimento e Publicação
1. Testes
2. Otimização de performance
3. Tratamento de erros
4. Preparação para stores

## 💾 Sistema de Cache (Modo Offline)

### Arquitetura Cache-First
O app implementa uma estratégia **cache-first with network refresh** que permite funcionamento 100% offline quando a API NASA APOD está indisponível.

```
┌─────────────────────────────────────────────────────────────────┐
│                     FLUXO CACHE-FIRST                           │
├─────────────────────────────────────────────────────────────────┤
│  1. Usuário solicita APOD → Verifica cache SQLite               │
│  2. Cache válido? → Retorna imediatamente                       │
│  3. Cache expirado/inexistente? → Busca API + salva no cache    │
│  4. API indisponível? → Usa cache expirado como fallback        │
│  5. Em background: pré-carrega últimos 14 dias                  │
└─────────────────────────────────────────────────────────────────┘
```

### Tabela SQLite: `apod_cache`
```sql
CREATE TABLE apod_cache (
  date TEXT PRIMARY KEY,           -- YYYY-MM-DD
  title TEXT NOT NULL,
  explanation TEXT NOT NULL,
  url TEXT NOT NULL,
  hdurl TEXT,
  media_type TEXT NOT NULL,
  copyright TEXT,
  thumbnail_url TEXT,
  cached_at TEXT NOT NULL,         -- Timestamp do cache
  expires_at TEXT NOT NULL         -- Expiração do cache
);
```

### Estratégia de Expiração
- **APOD de hoje:** 24 horas (pode ser atualizado pela NASA)
- **APODs antigos:** 30 dias (dados históricos nunca mudam)
- **Limpeza automática:** a cada 6 horas remove itens expirados
- **Máximo em cache:** 500 APODs

### Constantes de Cache (`app_constants.dart`)
```dart
static const int todayApodCacheHours = 24;
static const int oldApodCacheDays = 30;
static const int preloadDays = 14;
static const int maxCachedApods = 500;
```

### CacheService
Responsável por:
- Limpeza periódica de cache expirado
- Pré-carregamento de APODs recentes em background
- Estatísticas de uso (total, válidos, expirados, cobertura)
- Interface na tela de Settings para limpar cache manualmente

## 📝 Requisitos da API NASA APOD

**Base URL:** `https://api.nasa.gov/planetary/apod`

**API Key:** Você precisará obter uma chave em: https://api.nasa.gov/

**Endpoints principais:**
- `GET /` - Imagem do dia
- `GET /?date=YYYY-MM-DD` - Imagem por data
- `GET /?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD` - Por período
- `GET /?count=N` - N imagens aleatórias

**Response exemplo:**
```json
{
  "date": "2024-01-15",
  "explanation": "Descrição da imagem...",
  "hdurl": "https://...",
  "media_type": "image",
  "title": "Título da imagem",
  "url": "https://..."
}
```

## 🎨 Detalhes de Implementação do Design

### Cards com Glassmorphism
```dart
Container(
  decoration: BoxDecoration(
    color: Color(0x1A1E293B), // Event Horizon com 10% opacity
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Color(0x33818CF8), // Stardust com 20% opacity
      width: 1,
    ),
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: // conteúdo
  ),
)
```

### Botões com Glow Effect
```dart
Container(
  decoration: BoxDecoration(
    color: Color(0xFF6B4CE6), // Nebula Purple
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Color(0x4D818CF8), // Stardust com 30% opacity
        blurRadius: 20,
        offset: Offset(0, 0),
      ),
    ],
  ),
)
```

### Loading Shimmer Cósmico
- Base color: `#0B0D21` (Deep Space)
- Highlight color: `#818CF8` (Stardust)
- Animação com movimento diagonal (estrela cadente)

## 🎯 Instruções para a IA

Por favor, me ajude a desenvolver o Cosmic Vision seguindo este guia:

1. **Comece pelo Design System:** Crie primeiro todos os arquivos de tema, cores e estilos
2. **Mostre exemplos visuais:** Sempre que possível, descreva como os elementos devem parecer
3. **Código comentado:** Explique cada decisão de design e implementação
4. **Progressão lógica:** Vamos construir do básico ao complexo
5. **Padrões consistentes:** Mantenha o design system em todas as telas
6. **Performance em mente:** Otimizações de imagem e cache desde o início