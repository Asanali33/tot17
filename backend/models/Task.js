const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
  title: { type: String, required: true },
  category: { type: String, default: 'general' },
  subcategory: { type: String },
  isDone: { type: Boolean, default: false },
  status: { type: String, default: 'todo' },
  deadline: { type: Date },
  teamDeadline: { type: Date },
  assignedTo: { type: String },
  assignedRole: { type: String },
  comments: [{
    text: { type: String, required: true },
    author: { type: String },
    createdAt: { type: Date, default: Date.now }
  }],
  estimatedDuration: { type: Number }, // in minutes
  xpGranted: { type: Boolean, default: false },
  completedAt: { type: Date },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Task', taskSchema);