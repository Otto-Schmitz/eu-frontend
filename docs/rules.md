# Frontend Rules

## Product Goal
Provide a calm, minimal, and reliable interface for a personal information wallet, focused on fast access to critical data in normal and emergency situations.

## Design Principles
- Clarity over decoration
- Calm over stimulation
- Accessibility over density
- Familiar patterns (Apple / Google)
- Minimal cognitive load

## UX Rules
- Never overwhelm the user with too much information
- Never require filling everything at once
- Always show status (complete / incomplete)
- Emergency information must be reachable in 1 tap
- No social, no gamification, no noise

## Architecture Rules
- Screens must not directly handle API logic
- State management must be centralized
- UI components must be reusable and dumb
- API responses must be mapped to view models
- No business logic in UI widgets

## Security Rules
- Tokens stored using secure storage
- No sensitive data cached in plain storage
- Emergency screen must never expose edit actions
- Auto logout on token expiration

## Non-goals (MVP)
- No offline-first logic
- No push notifications
- No real-time updates
- No file uploads yet
