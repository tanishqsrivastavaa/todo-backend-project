# Todo Backend Project

A comprehensive and production-ready todo backend API with CRUD operations, user authentication, Google OAuth integration, and AWS deployment configuration.

## Features

- ✅ **CRUD Operations**: Complete Create, Read, Update, Delete functionality for todos
- 🔐 **User Authentication**: JWT-based authentication with bcrypt password hashing
- 🔑 **Google OAuth**: Social login integration with Google
- 📊 **Todo Statistics**: Get insights about your todos (total, completed, pending)
- 🔍 **Filtering & Sorting**: Filter by status/priority, sort by date/priority
- 🛡️ **Security**: Helmet.js for security headers, input validation
- ☁️ **AWS Deployment**: Ready-to-deploy on AWS Elastic Beanstalk
- 📝 **MongoDB**: NoSQL database with Mongoose ODM

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose
- **Authentication**: JWT (jsonwebtoken), Passport.js
- **Security**: Helmet, bcryptjs, CORS
- **Deployment**: AWS Elastic Beanstalk

## Getting Started

### Prerequisites

- Node.js (v14 or higher)
- MongoDB (local or Atlas)
- Google Cloud Console account (for OAuth)
- AWS account (for deployment)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd todo-backend-project
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   
   Create a `.env` file in the root directory:
   ```bash
   cp .env.example .env
   ```
   
   Update the `.env` file with your configuration:
   ```env
   PORT=5000
   NODE_ENV=development
   MONGODB_URI=mongodb://localhost:27017/todo-app
   JWT_SECRET=your_jwt_secret_key_here
   JWT_EXPIRE=7d
   GOOGLE_CLIENT_ID=your_google_client_id
   GOOGLE_CLIENT_SECRET=your_google_client_secret
   GOOGLE_CALLBACK_URL=http://localhost:5000/api/auth/google/callback
   FRONTEND_URL=http://localhost:3000
   ```

4. **Start MongoDB**
   
   Make sure MongoDB is running on your system:
   ```bash
   # For local MongoDB
   mongod
   
   # Or use MongoDB Atlas connection string in .env
   ```

5. **Run the application**
   
   Development mode (with auto-reload):
   ```bash
   npm run dev
   ```
   
   Production mode:
   ```bash
   npm start
   ```

The server will start on `http://localhost:5000`

## API Endpoints

### Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/register` | Register new user | No |
| POST | `/api/auth/login` | Login user | No |
| GET | `/api/auth/me` | Get current user | Yes |
| GET | `/api/auth/google` | Initiate Google OAuth | No |
| GET | `/api/auth/google/callback` | Google OAuth callback | No |

### Todos

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/todos` | Get all todos | Yes |
| GET | `/api/todos/:id` | Get single todo | Yes |
| POST | `/api/todos` | Create new todo | Yes |
| PUT | `/api/todos/:id` | Update todo | Yes |
| DELETE | `/api/todos/:id` | Delete todo | Yes |
| GET | `/api/todos/stats` | Get todo statistics | Yes |

### Health Check

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/health` | Health check | No |
| GET | `/` | API info | No |

## API Examples

### Register User

```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Login User

```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Create Todo

```bash
curl -X POST http://localhost:5000/api/todos \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "title": "Complete project",
    "description": "Finish the todo backend project",
    "priority": "high",
    "dueDate": "2025-12-31"
  }'
```

### Get All Todos

```bash
curl -X GET http://localhost:5000/api/todos \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Update Todo

```bash
curl -X PUT http://localhost:5000/api/todos/:id \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "completed": true
  }'
```

### Delete Todo

```bash
curl -X DELETE http://localhost:5000/api/todos/:id \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Google OAuth Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google+ API
4. Go to Credentials → Create Credentials → OAuth client ID
5. Configure OAuth consent screen
6. Add authorized redirect URIs:
   - Development: `http://localhost:5000/api/auth/google/callback`
   - Production: `https://your-domain.com/api/auth/google/callback`
7. Copy Client ID and Client Secret to `.env` file

## AWS Deployment

### Prerequisites

- AWS CLI installed and configured
- EB CLI installed (`pip install awsebcli`)
- AWS account with appropriate permissions

### Deployment Steps

1. **Initialize Elastic Beanstalk**
   ```bash
   eb init
   ```
   
   Follow the prompts:
   - Select region
   - Choose application name
   - Select Node.js platform
   - Setup SSH (optional)

2. **Create environment**
   ```bash
   eb create todo-backend-env
   ```

3. **Set environment variables**
   ```bash
   eb setenv NODE_ENV=production \
     MONGODB_URI=your_mongodb_atlas_uri \
     JWT_SECRET=your_production_jwt_secret \
     GOOGLE_CLIENT_ID=your_google_client_id \
     GOOGLE_CLIENT_SECRET=your_google_client_secret \
     GOOGLE_CALLBACK_URL=https://your-eb-url.com/api/auth/google/callback \
     FRONTEND_URL=https://your-frontend-url.com
   ```

4. **Deploy application**
   ```bash
   eb deploy
   ```

5. **Open application**
   ```bash
   eb open
   ```

### MongoDB Atlas Setup (Recommended for Production)

1. Create account at [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a new cluster
3. Add database user
4. Whitelist IP addresses (or 0.0.0.0/0 for all)
5. Get connection string and update `MONGODB_URI` in environment variables

## Project Structure

```
todo-backend-project/
├── src/
│   ├── config/
│   │   ├── database.js       # MongoDB connection
│   │   └── passport.js       # Passport OAuth configuration
│   ├── controllers/
│   │   ├── authController.js # Authentication logic
│   │   └── todoController.js # Todo CRUD logic
│   ├── middleware/
│   │   ├── auth.js           # JWT authentication middleware
│   │   └── error.js          # Error handling middleware
│   ├── models/
│   │   ├── User.js           # User model
│   │   └── Todo.js           # Todo model
│   ├── routes/
│   │   ├── auth.js           # Auth routes
│   │   └── todos.js          # Todo routes
│   ├── utils/
│   │   └── generateToken.js  # JWT token generator
│   └── server.js             # Main application file
├── .ebextensions/            # AWS EB configuration
├── .elasticbeanstalk/        # EB CLI configuration
├── .env.example              # Environment variables template
├── .gitignore
├── package.json
└── README.md
```

## Security Features

- **Password Hashing**: Bcrypt with salt rounds
- **JWT Authentication**: Secure token-based auth
- **Helmet**: Security headers
- **CORS**: Configurable cross-origin requests
- **Input Validation**: Express-validator
- **MongoDB Injection Protection**: Mongoose sanitization

## Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| PORT | Server port | No | 5000 |
| NODE_ENV | Environment mode | No | development |
| MONGODB_URI | MongoDB connection string | Yes | - |
| JWT_SECRET | JWT secret key | Yes | - |
| JWT_EXPIRE | JWT expiration time | No | 7d |
| GOOGLE_CLIENT_ID | Google OAuth client ID | Yes* | - |
| GOOGLE_CLIENT_SECRET | Google OAuth secret | Yes* | - |
| GOOGLE_CALLBACK_URL | Google OAuth callback | Yes* | - |
| FRONTEND_URL | Frontend URL for CORS | No | http://localhost:3000 |

*Required only if using Google OAuth

## Error Handling

The API returns consistent error responses:

```json
{
  "success": false,
  "message": "Error message here"
}
```

Common HTTP status codes:
- 200: Success
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 404: Not Found
- 500: Server Error

## Todo Model Schema

```javascript
{
  title: String (required, max 100 chars),
  description: String (max 500 chars),
  completed: Boolean (default: false),
  priority: String (enum: ['low', 'medium', 'high'], default: 'medium'),
  dueDate: Date,
  user: ObjectId (reference to User),
  createdAt: Date,
  updatedAt: Date
}
```

## User Model Schema

```javascript
{
  name: String (required),
  email: String (required, unique),
  password: String (hashed, min 6 chars),
  googleId: String (for OAuth users),
  avatar: String,
  authProvider: String (enum: ['local', 'google']),
  createdAt: Date,
  updatedAt: Date
}
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

ISC

## Support

For support, email your-email@example.com or open an issue in the repository.

## Roadmap

- [ ] Add email verification
- [ ] Add password reset functionality
- [ ] Add todo sharing between users
- [ ] Add todo categories/tags
- [ ] Add file attachments to todos
- [ ] Add real-time updates with WebSockets
- [ ] Add rate limiting
- [ ] Add comprehensive unit and integration tests
- [ ] Add API documentation with Swagger/OpenAPI