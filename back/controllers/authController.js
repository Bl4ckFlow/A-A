// controllers/authController.js
const bcrypt = require('bcrypt');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.signup = async (req, res) => {
  const { email, password, first_name, last_name, phone, gender, birthdate } = req.body;

  try {
    const existingUser = await prisma.users.findUnique({
      where: { email }
    });

    if (existingUser) {
      return res.status(400).json({ error: 'Email already in use' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await prisma.users.create({
      data: {
        email,
        password_hash: hashedPassword,
        first_name,
        last_name,
        phone,
        date_of_birth: new Date(birthdate + "T00:00:00.000Z"),
        gender
      }
    });

    res.status(201).json({ message: 'User created', userId: newUser.user_id });
  } catch (error) {
    console.error('Signup error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await prisma.users.findUnique({
      where: { email }
    });

    if (!user) {
      return res.status(400).json({ error: 'Invalid email or password' });
    }

    const validPassword = await bcrypt.compare(password, user.password_hash);

    if (!validPassword) {
      return res.status(400).json({ error: 'Invalid email or password' });
    }

    // Here you can create a JWT token or session for user authentication
    res.json({ message: 'Login successful', userId: user.user_id });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
