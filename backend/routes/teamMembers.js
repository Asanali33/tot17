const express = require('express');
const TeamMember = require('../models/TeamMember');

const router = express.Router();

// GET /api/team-members - Get all team members
router.get('/', async (req, res) => {
  try {
    const members = await TeamMember.find();
    res.json(members);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/team-members - Create a new team member
router.post('/', async (req, res) => {
  try {
    const member = new TeamMember(req.body);
    await member.save();
    res.status(201).json(member);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// PUT /api/team-members/:id - Update a team member
router.put('/:id', async (req, res) => {
  try {
    const member = await TeamMember.findOneAndUpdate(
      { memberId: req.params.id },
      req.body,
      { new: true }
    );
    if (!member) return res.status(404).json({ error: 'Team member not found' });
    res.json(member);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// DELETE /api/team-members/:id - Delete a team member
router.delete('/:id', async (req, res) => {
  try {
    const member = await TeamMember.findOneAndDelete({ memberId: req.params.id });
    if (!member) return res.status(404).json({ error: 'Team member not found' });
    res.json({ message: 'Team member deleted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;

