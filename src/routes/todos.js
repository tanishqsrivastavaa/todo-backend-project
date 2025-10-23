const express = require('express');
const {
  getTodos,
  getTodo,
  createTodo,
  updateTodo,
  deleteTodo,
  getTodoStats,
} = require('../controllers/todoController');
const { protect } = require('../middleware/auth');
const { createLimiter } = require('../middleware/rateLimiter');

const router = express.Router();

// All routes require authentication
router.use(protect);

router.route('/').get(getTodos).post(createLimiter, createTodo);

router.route('/stats').get(getTodoStats);

router.route('/:id').get(getTodo).put(updateTodo).delete(deleteTodo);

module.exports = router;
