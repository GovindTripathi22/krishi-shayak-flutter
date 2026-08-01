# KrishiSahayak Phase 2 — REST API Specifications

Production REST API endpoints implemented for Authentication and Profile Management in Phase 2.

---

## 🔐 1. Authentication Endpoints (`/api/v1/auth`)

### `POST /api/v1/auth/send-otp`
- **Description**: Sends SMS OTP to Indian mobile phone number.
- **Request Body**:
  ```json
  { "phoneNumber": "+919876543210" }
  ```
- **Response (200 OK)**:
  ```json
  { "success": true, "message": "OTP sent successfully." }
  ```

### `POST /api/v1/auth/verify-otp`
- **Description**: Verifies OTP, logs in or registers user, and returns JWT tokens.
- **Request Body**:
  ```json
  { "phoneNumber": "+919876543210", "otp": "123456" }
  ```
- **Response (200 OK)**:
  ```json
  {
    "success": true,
    "user": { "id": "664b1f...", "phoneNumber": "+919876543210", "isVerified": true },
    "tokens": { "accessToken": "eyJhbG...", "refreshToken": "eyJhbG..." }
  }
  ```

### `POST /api/v1/auth/google`
- **Description**: Authenticates user via Google Sign-In.
- **Request Body**:
  ```json
  { "email": "farmer@gmail.com", "fullName": "Ramesh Patil", "googleToken": "..." }
  ```

### `POST /api/v1/auth/refresh`
- **Description**: Generates new Access Token using valid Refresh Token.

### `POST /api/v1/auth/logout`
- **Headers**: `Authorization: Bearer <accessToken>`
- **Description**: Clears refresh token session.

---

## 👤 2. Profile Management Endpoints (`/api/v1/profile`)

### `GET /api/v1/profile`
- **Headers**: `Authorization: Bearer <accessToken>`
- **Description**: Fetches authenticated farmer profile from MongoDB.

### `PUT /api/v1/profile`
- **Headers**: `Authorization: Bearer <accessToken>`
- **Request Body**:
  ```json
  {
    "fullName": "Ramesh Patil",
    "gender": "Male",
    "age": 38,
    "state": "Maharashtra",
    "district": "Nashik",
    "landSize": 3.0,
    "cropType": ["Cotton", "Wheat"],
    "category": "Small Farmer",
    "annualIncome": 120000,
    "preferredLanguage": "en"
  }
  ```
- **Response (200 OK)**:
  ```json
  { "success": true, "profile": { "_id": "664b2...", "fullName": "Ramesh Patil", ... } }
  ```
