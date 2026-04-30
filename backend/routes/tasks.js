const express = require('express');
const jwt = require('jsonwebtoken');
const Task = require('../models/Task');

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET || 'your_secret_key_change_in_env';

const authMiddleware = (req, res, next) => {
    try {
        const token = req.headers.authorization ? .split(' ')[1];
        if (!token) {
            return res.status(401).json({ error: 'Токен отсутствует' });
        }

        const decoded = jwt.verify(token, JWT_SECRET);
        req.user = decoded;
        next();
    } catch (error) {
        return res.status(401).json({ error: 'Недействительный токен' });
    }
};

router.use(authMiddleware);

// GET /api/tasks - Get current user's tasks
router.get('/', async(req, res) => {
    try {
        const tasks = await Task.find({ userId: req.user.userId });
        res.json(tasks);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// POST /api/tasks - Create a new task
router.post('/', async(req, res) => {
    try {
        const task = new Task({
            ...req.body,
            userId: req.user.userId,
        });
        await task.save();
        res.status(201).json(task);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// PUT /api/tasks/:id - Update a task
router.put('/:id', async(req, res) => {
    try {
        const updateData = {...req.body };
        delete updateData.userId;

        const task = await Task.findOneAndUpdate({ _id: req.params.id, userId: req.user.userId },
            updateData, { new: true }
        );
        if (!task) return res.status(404).json({ error: 'Task not found or access denied' });
        res.json(task);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// DELETE /api/tasks/:id - Delete a task
router.delete('/:id', async(req, res) => {
    try {
        const task = await Task.findOneAndDelete({ _id: req.params.id, userId: req.user.userId });
        if (!task) return res.status(404).json({ error: 'Task not found or access denied' });
        res.json({ message: 'Task deleted' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;