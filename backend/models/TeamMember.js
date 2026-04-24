const mongoose = require('mongoose');

const teamMemberSchema = new mongoose.Schema({
  memberId: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  role: {
    name: { type: String, required: true },
    description: { type: String, default: '' },
    permissions: { type: [String], default: [] }
  },
  avatarUrl: { type: String },
  isActive: { type: Boolean, default: true },
  skills: { type: [String], default: [] },
  joinedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('TeamMember', teamMemberSchema);

