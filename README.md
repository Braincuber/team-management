# Team Management System - API

This is a REST API backend for managing teams and memberships within an organization. It allows users to create and manage teams, assign roles to members, and control access based on role-based authorization.

## Features

- Team Management: Create, update, view, and delete teams.
- Membership Management: Add and remove members, assign roles (`Admin` or `Member`).
- Authorization: Only team owners can modify team details and manage memberships.
- Authentication: User authentication is managed with Devise.

## Technologies Used

- **Ruby on Rails**: API backend framework
- **PostgreSQL**: Database
- **Devise**: Authentication
- **CanCanCan**: Authorization
- **Docker**: Containerization

## Getting Started

### Prerequisites

Ensure you have the following installed:

- **Docker** and **Docker Compose**
- **Git**

### Setup

1. **Clone the Repository**:

   ```bash
   git clone <repository_url>
   cd team-management-system
   ```


2. **Install Dependencies**:

Install project dependencies using Bundler.

```bash
bundle install
```

3. **Database Setup**:

Create and migrate the database:

```bash

rails db:create db:migrate

# then do 
rails db:seed

```

4. **Start the Rails Server**:
Start the server locally on port 3000:

```bash
rails server
```
The application should now be running at http://localhost:3000.



**Notes**

Ensure PostgreSQL is running whenever you start the application.
Adjust the Ruby and Rails versions in the setup commands if they differ in your environment.
## API Documentation

### Authentication

This application uses Devise for authentication. You can register a new user and log in to receive an authentication token. This token should be included in the `Authorization` header for requests that require authentication.

### Endpoints

## Authentication Endpoints

The following endpoints allow users to sign up, sign in, and sign out of the application.

### Sign Up

**Endpoint**: `POST /signup`

**Description**: Registers a new user.

**Request Body**:

```json
{
  "user": {
    "email": "user@example.com",
    "password": "password123",
  }
}
```

### Sign In
Endpoint: POST /login

Description: Authenticates a user and returns a token in the response headers.

Request Body:

```json
Copy code
{
  "user": {
    "email": "user@example.com",
    "password": "password123"
  }
}
```
Response:

200 OK: Returns a success message and user data. The authentication token is provided in the Authorization header.

401 Unauthorized: If credentials are invalid, returns an error message.


### Sign Out
Endpoint: DELETE /logout

Description: Signs out the authenticated user.

Headers:

Authorization: The Bearer token received during sign-in.
Response:

200 OK: Returns a success message upon successful sign-out.
401 Unauthorized: If the token is missing or invalid.

#### Teams

- `POST /teams`: Create a new team
- `GET /teams`: List all teams with pagination
- `GET /teams/:id`: Get details of a specific team
- `PUT /teams/:id`: Update team details (Owner only)
- `DELETE /teams/:id`: Delete a team (Owner only)

#### Memberships

- `POST /teams/:team_id/memberships`: Add a new member to the team (Owner only)
- `DELETE /teams/:team_id/memberships/:id`: Remove a member from the team (Owner only)
- `GET /teams/:team_id/memberships`: List all members of a team, with role information
- `GET /teams/:team_id/memberships/:id`: View details of a team member

### Error Handling

Unauthorized actions return a `403 Forbidden` status with an `Access Denied` message.

