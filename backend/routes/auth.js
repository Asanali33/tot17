const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET || 'your_secret_key_change_in_env';

// POST /api/auth/register - Регистрация нового пользователя
router.post('/register', async(req, res) => {
    try {
        const { username, email, password, confirmPassword } = req.body;

        // Валидация
        if (!username || !email || !password) {
            return res.status(400).json({ error: 'Все поля обязательны' });
        }

        if (password !== confirmPassword) {
            return res.status(400).json({ error: 'Пароли не совпадают' });
        }

        if (password.length < 6) {
            return res.status(400).json({ error: 'Пароль должен быть минимум 6 символов' });
        }

        // Проверка существования пользователя
        const existingUser = await User.findOne({
            $or: [{ username }, { email }]
        });

        if (existingUser) {
            return res.status(400).json({ error: 'Пользователь с таким именем или email уже существует' });
        }

        // Хеширование пароля
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        // Создание пользователя
        const user = new User({
            username,
            email,
            password: hashedPassword
        });

        await user.save();

        // Генерация токена
        const token = jwt.sign({ userId: user._id, username: user.username },
            JWT_SECRET, { expiresIn: '7d' }
        );

        res.status(201).json({
            message: 'Пользователь успешно зарегистрирован',
            token,
            user: {
                id: user._id,
                username: user.username,
                email: user.email
            }
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// POST /api/auth/login - Вход в аккаунт
router.post('/login', async(req, res) => {
    try {
        const { username, password } = req.body;

        // Валидация
        if (!username || !password) {
            return res.status(400).json({ error: 'Пожалуйста введите имя пользователя и пароль' });
        }

        // Поиск пользователя
        const user = await User.findOne({
            $or: [{ username }, { email: username }]
        });

        if (!user) {
            return res.status(400).json({ error: 'Неверное имя пользователя или пароль' });
        }

        // Проверка пароля
        const isValidPassword = await bcrypt.compare(password, user.password);

        if (!isValidPassword) {
            return res.status(400).json({ error: 'Неверное имя пользователя или пароль' });
        }

        // Генерация токена
        const token = jwt.sign({ userId: user._id, username: user.username },
            JWT_SECRET, { expiresIn: '7d' }
        );

        res.json({
            message: 'Успешный вход',
            token,
            user: {
                id: user._id,
                username: user.username,
                email: user.email
            }
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET /api/auth/verify - Проверка токена
router.get('/verify', async(req, res) => {
    try {
        const token = req.headers.authorization?.split(' ')[1];

        if (!token) {
            return res.status(401).json({ error: 'Токен отсутствует' });
        }

        const decoded = jwt.verify(token, JWT_SECRET);
        const user = await User.findById(decoded.userId);

        if (!user) {
            return res.status(404).json({ error: 'Пользователь не найден' });
        }

        res.json({
            user: {
                id: user._id,
                username: user.username,
                email: user.email
            }
        });
    } catch (error) {
        res.status(401).json({ error: 'Недействительный токен' });
    }
});

module.exports = router;