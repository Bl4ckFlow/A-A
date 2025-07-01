const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/auth');

const app = express();

app.use(cors());
app.use(express.json());

const session = require('express-session');

app.use(session({
  secret: 'your-secret-key', 
  resave: false,
  saveUninitialized: false
}));


app.use('/api', authRoutes);

const PORT = process.env.PORT || 3750;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
