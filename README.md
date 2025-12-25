# 🌌 Cosmic Vision

Explore o universo com as imagens astronômicas da NASA através da API APOD (Astronomy Picture of the Day).

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Funcionalidades

- 📷 **Imagem do Dia** - Visualize a imagem astronômica do dia da NASA
- 📅 **Exploração por Data** - Navegue pelo arquivo histórico desde 16/06/1995
- 🎲 **Imagens Aleatórias** - Descubra imagens aleatórias do acervo
- ⭐ **Favoritos** - Salve suas imagens favoritas com persistência local
- 🔍 **Zoom HD** - Visualize imagens em alta qualidade com zoom
- 💾 **Download** - Salve imagens diretamente na galeria do dispositivo
- 🔗 **Compartilhamento** - Compartilhe imagens com amigos
- 🎬 **Vídeos** - Suporte a vídeos do YouTube quando disponíveis
- 🌙 **Tema Escuro** - Interface otimizada para visualização noturna

## 📱 Screenshots

*Em breve*

## 🛠️ Tecnologias

- **Flutter 3.x** - Framework de UI multiplataforma
- **Clean Architecture** - Separação clara de responsabilidades
- **Provider** - Gerenciamento de estado
- **Dio** - Cliente HTTP
- **SQLite** - Persistência local de favoritos
- **NASA APOD API** - Fonte de dados astronômicos

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK 3.6.0 ou superior
- Dart SDK 3.6.0 ou superior
- API Key da NASA (obtenha grátis em [api.nasa.gov](https://api.nasa.gov/))

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/cosmic_vision.git
cd cosmic_vision
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o app (substitua pela sua API Key):
```bash
flutter run --dart-define=NASA_API_KEY=sua_chave_aqui
```

## 📦 Build para Release

### Android (AAB para Play Store)
```bash
flutter build appbundle --dart-define=NASA_API_KEY=sua_chave_aqui
```

### Android (APK)
```bash
flutter build apk --dart-define=NASA_API_KEY=sua_chave_aqui
```

### iOS
```bash
flutter build ios --dart-define=NASA_API_KEY=sua_chave_aqui
```

## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture**:

```
lib/
├── app/              # Configuração do app e temas
├── core/             # Utilitários, constantes e extensões
├── data/             # Implementação de repositórios e datasources
├── di/               # Injeção de dependências
├── domain/           # Entidades, repositórios (contratos) e casos de uso
├── presentation/     # Telas, widgets e viewmodels
└── services/         # Serviços (notificações, download, etc)
```

## 🔑 Configuração da API Key

A API Key da NASA é passada via `--dart-define` para não expor no código:

```dart
// Uso no código
static const String apiKey = String.fromEnvironment(
  'NASA_API_KEY',
  defaultValue: 'DEMO_KEY',
);
```

> **Nota:** `DEMO_KEY` tem limite de 30 req/hora. Obtenha sua chave gratuita para 1000 req/hora.

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🙏 Créditos

- **NASA** - Pela incrível API APOD
- **Flutter Team** - Pelo framework fantástico
- Ícones e imagens astronômicas © NASA

---

Feito com 💜 e ☕ por [Marcus Paixão](https://marcuspaixao.com.br)
