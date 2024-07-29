
require('dotenv').config();

const express = require('express');
const mssql = require('mssql');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const port = 3001;




// Configuración de CORS
app.use(cors());

// Configuración del cuerpo de las peticiones
app.use(bodyParser.json());

// Configuración de la conexión a SQL Server
const sqlConfig = {
  user: process.env.DB_USER,
  password: process.env.Db_password,
  server: process.env.DB_SERVER,// o tu servidor SQL
  database: process.env.DB_DATABASE,
  options: {
    encrypt: false,// Para Azure SQL
    trustServerCertificate: true
  }
};

// Conexión a la base de datos
mssql.connect(sqlConfig, err => {
  if (err) {
    console.error('Database connection failed:', err);
    return;
  }
  console.log('Database connected');
});

// Registro de usuarios


// Registro de usuarios



app.post('/registro', async (req, res) => {
  const { Nombre, Apellidos , NombreUsuario, Correo, ContrasenaHash} = req.body;
  try {
    const hashedPassword = await bcrypt.hash(ContrasenaHash, 10);
    const result = await mssql.query`INSERT INTO Users (Nombre, Apellidos, NombreUsuarios, Correo , ContrasenaHash) VALUES (${Nombre},${Apellidos},${NombreUsuario},${Correo} ${hashedPassword})`;
    res.status(201).send('User registered');
  } catch (error) {
    res.status(500).send('Error registering user');
  }
});

// Autenticación de usuarios
app.post('/login', async (req, res) => {
  const { Correo, ContrasenaHash } = req.body;
  try {
    const result = await mssql.query`SELECT * FROM Users WHERE Correo = ${Correo}`;
    const user = result.recordset[0];
    if (!user || !(await bcrypt.compare(ContrasenaHash, user.ContrasenaHash))) {
      return res.status(401).send('Invalid credentials');
    }
    const token = jwt.sign({ id: user.id }, 'your_jwt_secret', { expiresIn: '1h' });
    res.json({ token });
  } catch (error) {
    res.status(500).send('Error logging in');
  }
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});