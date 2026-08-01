const { isConnected } = require('../config/database');
const Notification = require('../models/Notification');

// In-memory fallback store
const inMemoryNotifications = [
  {
    _id: 'notif_1',
    id: 'notif_1',
    title: '🌾 PM-KISAN 17th Installment',
    body: 'The 17th installment of PM-KISAN (₹2,000) has been released. Check your bank account.',
    category: 'Scheme Update',
    isRead: false,
    createdAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
  },
  {
    _id: 'notif_2',
    id: 'notif_2',
    title: '⏰ PMFBY Application Deadline',
    body: 'Crop insurance (PMFBY) deadline for Kharif season is August 31. Apply now to secure coverage.',
    category: 'Deadline Reminder',
    isRead: false,
    createdAt: new Date(Date.now() - 6 * 60 * 60 * 1000).toISOString(),
  },
  {
    _id: 'notif_3',
    id: 'notif_3',
    title: '✅ New Scheme Eligible for You',
    body: 'Based on your profile, you are eligible for SMAM subsidy up to 50% on farm machinery.',
    category: 'Recommendation',
    isRead: true,
    createdAt: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    _id: 'notif_4',
    id: 'notif_4',
    title: '📄 Documents Required',
    body: 'Complete your KCC (Kisan Credit Card) application. Missing: Aadhaar copy, 7/12 Extract.',
    category: 'Document Reminder',
    isRead: true,
    createdAt: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    _id: 'notif_5',
    id: 'notif_5',
    title: '🌿 PM Krishi Sinchayee Yojana',
    body: 'New 80% subsidy available for drip irrigation in Maharashtra. Limited quota available.',
    category: 'Scheme Update',
    isRead: false,
    createdAt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(),
  },
];

class NotificationController {
  // GET /api/v1/notifications
  static async getNotifications(req, res, next) {
    try {
      if (isConnected()) {
        const userId = req.user?.id;
        const query = userId ? { $or: [{ userId }, { topic: 'all' }] } : { topic: 'all' };
        const notifications = await Notification.find(query)
          .sort({ createdAt: -1 })
          .limit(50);
        return res.status(200).json({ success: true, notifications });
      }

      // Fallback in-memory
      res.status(200).json({
        success: true,
        notifications: inMemoryNotifications,
      });
    } catch (err) {
      next(err);
    }
  }

  // PUT /api/v1/notifications/read
  static async markAsRead(req, res, next) {
    try {
      const { notificationId } = req.body;
      if (!notificationId) {
        return res.status(400).json({ success: false, message: 'notificationId is required.' });
      }

      if (isConnected()) {
        await Notification.findByIdAndUpdate(notificationId, {
          isRead: true,
          readAt: new Date(),
        });
      }

      res.status(200).json({ success: true, message: 'Notification marked as read.' });
    } catch (err) {
      next(err);
    }
  }

  // DELETE /api/v1/notifications/:id
  static async deleteNotification(req, res, next) {
    try {
      const { id } = req.params;

      if (isConnected()) {
        await Notification.findByIdAndDelete(id);
      }

      res.status(200).json({ success: true, message: 'Notification deleted.' });
    } catch (err) {
      next(err);
    }
  }

  // POST /api/v1/notifications/test (for testing only)
  static async createTestNotification(req, res, next) {
    try {
      const payload = {
        title: req.body.title || '🔔 Test Notification',
        body: req.body.body || 'This is a test notification from the KrishiSahayak backend.',
        category: req.body.category || 'General',
        topic: 'all',
      };

      if (isConnected()) {
        const notif = await Notification.create(payload);
        return res.status(201).json({ success: true, notification: notif });
      }

      res.status(201).json({
        success: true,
        notification: { ...payload, _id: 'test_' + Date.now(), createdAt: new Date().toISOString() },
      });
    } catch (err) {
      next(err);
    }
  }
}

module.exports = NotificationController;
