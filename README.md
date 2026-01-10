# Ace Parking App

A REST API for managing customers, products, and orders built with Node.js, Express, and SQL Server.

## Prerequisites

- [Docker](https://www.docker.com/get-started) and Docker Compose
- [Node.js](https://nodejs.org/) (v14 or higher)

## Quick Start

1. **Clone and install dependencies**
   ```bash
   npm install
   ```

2. **Start the database**
   ```bash
   docker compose up -d
   ```
   This will start SQL Server and automatically initialize the database using `database/init.sql`.

3. **Configure environment** (optional)
   Create a `.env` file in the root directory:
   ```env
   PORT=3000
   SA_PASSWORD=YourStrong@Passw0rd
   DB_USER=sa
   DB_PASSWORD=YourStrong@Passw0rd
   DB_SERVER=localhost
   DB_DATABASE=AceParkingDB
   API_KEY=your-api-key-here
   ```

4. **Start the API**
   ```bash
   npm run dev      # Development mode with auto-reload
   npm start        # Production mode
   ```

5. **Test the API**
   ```bash
   curl http://localhost:3000/api/public/hello
   ```

## API Endpoints

- `GET /api/public/hello` - Public health check
- `/api/customer` - Customer management (requires API key)
- `/api/product` - Product management (requires API key)
- `/api/order` - Order management (requires API key)

Protected endpoints require an `X-API-Key` header.

## Stopping Services

```bash
docker compose down       # Stop and remove containers
docker compose down -v    # Stop and remove containers + volumes
```
