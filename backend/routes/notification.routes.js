const express = require('express');
const router = express.Router();
const NotificationController = require('../controllers/NotificationController');
const { protect } = require('../middleware/auth.middleware');

// GET /api/v1/notifications — fetch notifications (auth optional for dev)
router.get('/', protect, NotificationController.getNotifications);

// PUT /api/v1/notifications/read — mark notification as read
router.put('/read', protect, NotificationController.markAsRead);

// POST /api/v1/notifications/test — create test notification
router.post('/test', NotificationController.createTestNotification);

// DELETE /api/v1/notifications/:id — delete a notification
router.delete('/:id', protect, NotificationController.deleteNotification);

module.exports = router;
