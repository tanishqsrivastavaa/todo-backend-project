# Quick Setup Guide

Get the Todo Backend API running in minutes!

## Prerequisites

- Node.js v14+ installed
- MongoDB installed locally OR MongoDB Atlas account
- Git

## Option 1: Local Setup (Fastest)

### 1. Clone and Install

```bash
git clone <repository-url>
cd todo-backend-project
npm install
```

### 2. Setup Environment Variables

```bash
cp .env.example .env
```

Edit `.env` with your preferred editor:
```bash
nano .env
# or
code .env
```

Minimal configuration:
```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/todo-app
JWT_SECRET=your_random_secret_key_change_this
```

### 3. Start MongoDB

```bash
# On macOS with Homebrew
brew services start mongodb-community

# On Linux with systemd
sudo systemctl start mongod

# On Windows
# MongoDB should start automatically, or start MongoDB Compass
```

### 4. Run the Application

```bash
npm run dev
```

Your API is now running at `http://localhost:5000`!

## Option 2: Docker Setup (Easiest)

### 1. Prerequisites
- Docker installed
- Docker Compose installed

### 2. Clone and Configure

```bash
git clone <repository-url>
cd todo-backend-project
cp .env.example .env
```

Edit `.env` with your settings (JWT_SECRET is required).

### 3. Start with Docker Compose

```bash
docker-compose up
```

Everything is configured! Your API is at `http://localhost:5000` with MongoDB running in a container.

## Option 3: MongoDB Atlas (Cloud Database)

### 1. Setup MongoDB Atlas

1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create free account
3. Create a free cluster
4. Create database user
5. Whitelist your IP (0.0.0.0/0 for testing)
6. Get connection string

### 2. Configure Application

```bash
git clone <repository-url>
cd todo-backend-project
npm install
cp .env.example .env
```

Edit `.env`:
```env
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/todo-app?retryWrites=true&w=majority
JWT_SECRET=your_random_secret_key
```

### 3. Run

```bash
npm run dev
```

## Testing Your Setup

### 1. Check Health

```bash
curl http://localhost:5000/health
```

Expected response:
```json
{
  "success": true,
  "message": "Server is running",
  "timestamp": "2025-10-23T..."
}
```

### 2. Register a User

```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123"
  }'
```

Expected response:
```json
{
  "success": true,
  "data": {
    "id": "...",
    "name": "Test User",
    "email": "test@example.com",
    "token": "eyJhbGciOiJIUzI1NiIs..."
  }
}
```

### 3. Create a Todo

Save the token from step 2, then:

```bash
curl -X POST http://localhost:5000/api/todos \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "title": "My first todo",
    "description": "Testing the API",
    "priority": "high"
  }'
```

### 4. Get All Todos

```bash
curl http://localhost:5000/api/todos \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## Google OAuth Setup (Optional)

If you want to enable Google authentication:

### 1. Create Google OAuth Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create new project
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URI: `http://localhost:5000/api/auth/google/callback`

### 2. Update .env

```env
GOOGLE_CLIENT_ID=your_client_id_here
GOOGLE_CLIENT_SECRET=your_client_secret_here
GOOGLE_CALLBACK_URL=http://localhost:5000/api/auth/google/callback
FRONTEND_URL=http://localhost:3000
```

### 3. Test Google Login

Visit in browser:
```
http://localhost:5000/api/auth/google
```

## Using Postman

Import the `postman_collection.json` file into Postman:

1. Open Postman
2. Click Import
3. Select `postman_collection.json`
4. Update the `token` variable after login
5. Start testing!

## Troubleshooting

### "Cannot connect to MongoDB"

- **Local MongoDB**: Make sure MongoDB is running
  ```bash
  # Check if MongoDB is running
  ps aux | grep mongod
  ```

- **MongoDB Atlas**: 
  - Check connection string
  - Verify IP is whitelisted
  - Ensure database user credentials are correct

### "EADDRINUSE: Port 5000 already in use"

Another process is using port 5000:
```bash
# Find the process
lsof -i :5000

# Kill it
kill -9 <PID>

# Or use a different port in .env
PORT=5001
```

### "JWT_SECRET is not defined"

Make sure `.env` file exists and contains:
```env
JWT_SECRET=your_secret_key_here
```

### Rate Limiting Issues During Testing

If you hit rate limits during testing:
- Wait 15 minutes, or
- Temporarily increase limits in `src/middleware/rateLimiter.js`

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Check [AWS_DEPLOYMENT.md](AWS_DEPLOYMENT.md) for deployment guide
- Explore the API endpoints
- Build a frontend application
- Add more features!

## Development Tips

### Auto-reload on Changes

The `npm run dev` command uses nodemon for automatic reloading.

### View Logs

Application logs appear in the console. For production, consider using a logging service.

### Database GUI Tools

- **MongoDB Compass**: Official MongoDB GUI
- **Studio 3T**: Feature-rich MongoDB IDE
- **Robo 3T**: Lightweight MongoDB client

### API Testing Tools

- **Postman**: Full-featured API testing (collection included)
- **Insomnia**: Alternative to Postman
- **curl**: Command-line testing
- **HTTPie**: Modern curl alternative

## Common Commands

```bash
# Start development server (auto-reload)
npm run dev

# Start production server
npm start

# Install dependencies
npm install

# Check for vulnerabilities
npm audit

# Update dependencies
npm update

# Run test script (server must be running)
./test-api.sh
```

## Getting Help

- Check existing documentation
- Review error messages carefully
- Check GitHub issues
- Stack Overflow for common problems

## Success! 🎉

You now have a fully functional Todo Backend API with:
- ✅ CRUD operations for todos
- ✅ User authentication
- ✅ Security features
- ✅ Ready for deployment

Start building your frontend or integrate with your existing application!
