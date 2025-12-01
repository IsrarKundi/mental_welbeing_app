# Mental Wellbeing App

A professional mental wellbeing application built with Flutter, GetX, and a "Liquid Glass" UI design.

## Features

- **Liquid Glass UI**: Deep calming gradients, glassmorphic containers, and fluid animations using `glassmorphism` and `flutter_animate`.
- **Mood Tracking**: Track your daily mood with animated emojis and dynamic background gradients.
- **AI Chat**: A supportive AI chat interface with distinct user and AI message bubbles.
- **Onboarding**: A serene onboarding experience with animated backgrounds.
- **Daily Actions**: Access to meditation and sleep stories.

## Folder Structure

The project follows a strict GetX pattern structure:

```
lib/
├── app/
│   ├── data/
│   │   ├── models/          # Data models (e.g., Message, Mood)
│   │   ├── providers/       # API providers (Placeholder)
│   │   └── services/        # App services (Placeholder)
│   ├── modules/             # Screen modules (Controller + Binding + View)
│   │   ├── home/            # Home screen with Mood Tracker and Daily Actions
│   │   ├── chat/            # Chat screen with AI interface
│   │   ├── onboarding/      # Onboarding flow
│   │   └── journal/         # Journal screen (Placeholder)
│   ├── routes/              # Route definitions (AppPages, AppRoutes)
│   ├── theme/               # App Theme, Colors, and TextStyles
│   └── widgets/             # Reusable widgets (LiquidGlassContainer)
├── main.dart                # App entry point
```

## Key Components

### LiquidGlassContainer
Located in `lib/app/widgets/liquid_glass_container.dart`.
A reusable widget that combines `GlassmorphicContainer` with `flutter_animate` to create a floating, shimmering glass effect.

### AppColors
Located in `lib/app/theme/app_colors.dart`.
Defines the color palette, including the deep ocean/muted purple background gradients and mood-specific gradients.

## Dependencies

- `get`: State management and route management.
- `glassmorphism`: For the glass effect.
- `flutter_animate`: For animations.
- `google_fonts`: For typography (Poppins).
- `flutter_svg`: For SVG assets.
- `lottie`: For Lottie animations.

## Getting Started

1.  Run `flutter pub get` to install dependencies.
2.  Run `flutter run` to start the app.
