# Frontend Style Guide

## Naming
- Screens: PascalCaseScreen
- Widgets: PascalCaseWidget
- State: PascalCaseController

## UI
- Prefer composition over inheritance
- No inline magic numbers
- Use spacing constants

## States
- Always handle:
  - loading
  - success
  - empty
  - error

## Errors
- Friendly messages
- No raw API errors exposed

## Forms
- Group related fields
- Validate before submit
- Show errors inline
