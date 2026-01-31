# Frontend Prompts (Cursor)

## Global Context Prompt
You are a senior mobile frontend engineer.

Generate a Flutter app with a clean, minimal, Apple/Google-style design.

Strictly follow:
- frontend/docs/rules.md
- frontend/docs/architecture.md
- frontend/docs/design.md
- frontend/docs/screens.md
- frontend/docs/api-contract.md
- frontend/docs/style.md

Constraints:
- Use Magic UI as the design system
- Clean, calm, accessible UI
- No business logic in widgets
- Backend is already implemented
- Follow API contracts strictly
- Produce production-quality code

---

## Prompt 1 — Project Setup
Create a Flutter project with:
- Magic UI configured
- Light/Dark themes
- Routing
- Base layout
- Dummy screens

---

## Prompt 2 — Auth Flow
Implement login and register screens:
- Validation
- Error handling
- Token storage
- Navigation on success

---

## Prompt 3 — Home Screen
Implement Home with:
- Status cards
- Calm layout
- Dummy data
- Loading & empty states

---

## Prompt 4 — Wallet
Implement Wallet screen:
- Category cards
- Status indicators
- Navigation

---

## Prompt 5 — Detail Screens
Implement detail screens for:
- Profile
- Health
- Contacts
- Addresses

---

## Prompt 6 — Emergency Screen
Implement emergency read-only screen:
- High contrast
- Large text
- Call buttons

---

## Prompt 7 — API Integration
Connect to backend:
- Dio client
- Interceptors
- Error mapping
- State management

---

## Prompt 8 — Polish
Add:
- Micro-interactions
- Skeleton loaders
- Accessibility improvements
- Final theme adjustments
