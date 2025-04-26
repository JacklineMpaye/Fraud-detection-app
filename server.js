<<<<<<< HEAD
require('dotenv').config({ path: __dirname + '/.env' });

=======
require('dotenv').config();
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f



const express = require('express');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');
const cors = require('cors');
const jwt = require('jsonwebtoken');

const app = express();

// Log the JWT_SECRET to verify it's loaded
console.log('Loaded JWT_SECRET:', process.env.JWT_SECRET);

// ======================
// Enhanced CORS Configuration
// ======================
const corsOptions = {
    origin: '*',  // Allow all origins in development
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
    optionsSuccessStatus: 200
};

app.use(cors(corsOptions));
app.options('*', cors(corsOptions)); // Handle preflight requests

// ======================
// Database Setup
// ======================
const pool = new Pool({
    user: process.env.DB_USER || 'postgres',
    host: process.env.DB_HOST || 'localhost',
    database: process.env.DB_NAME || 'Fraudsense_DB',
    password: process.env.DB_PASSWORD || '256Tiwaj?',
    port: process.env.DB_PORT || 5432,
});

// Test connection
pool.query('SELECT NOW()')
    .then(() => console.log('✅ Database connected'))
    .catch(err => console.error('❌ Database connection error:', err));

// ======================
// Middleware
// ======================
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logger
app.use((req, res, next) => {
    console.log(`\n[${new Date().toISOString()}] ${req.method} ${req.path}`);
    console.log('Origin:', req.headers.origin);
    console.log('Headers:', req.headers);
    console.log('Body:', req.body);
    next();
});

// ======================
// Registration Endpoint
// ======================
app.post('/api/register', async (req, res) => {
    console.log("Register endpoint hit!");
    try {
        const { fullName, email, password } = req.body;

        if (!fullName || !email || !password) {
            return res.status(400).json({ error: 'All fields are required' });
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 12);

        // Insert user into database
        const result = await pool.query(
            `INSERT INTO users (full_name, email, password_hash) 
             VALUES ($1, $2, $3)
             RETURNING id, email, full_name`,
            [fullName, email, hashedPassword]
        );

        res.status(201).json({
            success: true,
            user: result.rows[0]
        });

    } catch (err) {
        console.error('Error:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// ======================
// Login Endpoint
// ======================
app.post('/api/login', async (req, res) => {
  try {
      const { email, password } = req.body;

      if (!email || !password) {
          return res.status(400).json({ error: "Email and password are required" });
      }

      // Check if user exists
      const userResult = await pool.query("SELECT * FROM users WHERE email = $1", [email]);

      if (userResult.rows.length === 0) {
          return res.status(401).json({ error: "Invalid email or password" });
      }

      // Validate password
      const user = userResult.rows[0];
      const isMatch = await bcrypt.compare(password, user.password_hash);
      
      if (!isMatch) {
          return res.status(401).json({ error: "Invalid email or password" });
      }

      // Generate JWT Token
      const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, { expiresIn: "1h" });

      res.status(200).json({ success: true, token });

  } catch (err) {
      console.error("Login Error:", err);
      res.status(500).json({ error: "Internal server error" });
  }
});

<<<<<<< HEAD
app.get('/debug-env', (req, res) => {
    res.json({
        JWT_SECRET: process.env.JWT_SECRET,
        DB_USER: process.env.DB_USER,
    });
});
=======
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f

// ======================
// Server Start
// ======================
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`\n🚀 Server running on http://localhost:${PORT}`);
    console.log('CORS configured for:');
    console.log('- All origins in development');
    console.log(process.env.FRONTEND_URL ? `- Production: ${process.env.FRONTEND_URL}` : '- No production URL set');
});