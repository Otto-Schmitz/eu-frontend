# API Contract Mapping

## Auth
- POST /auth/login
- POST /auth/register
- POST /auth/refresh

## Profile
- GET /me/profile
- PUT /me/profile

## Health
- GET /me/health
- PUT /me/health
- GET /me/allergies
- POST /me/allergies
- DELETE /me/allergies/{id}
- GET /me/medications
- POST /me/medications
- DELETE /me/medications/{id}

## Emergency Contacts
- GET /me/emergency-contacts
- POST /me/emergency-contacts
- PUT /me/emergency-contacts/{id}
- DELETE /me/emergency-contacts/{id}

## Addresses
- GET /me/addresses
- POST /me/addresses
- PUT /me/addresses/{id}
- DELETE /me/addresses/{id}

## Mapping Rules
- DTOs must mirror backend fields
- Never assume optional fields exist
- Handle empty lists gracefully
