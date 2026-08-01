/**
 * KrishiSahayak — MongoDB Production Index Script
 * Run: node scripts/create-indexes.js
 * 
 * Creates all production indexes for performance and query optimization.
 */
require('dotenv').config();
const mongoose = require('mongoose');

async function createIndexes() {
  const mongoURI = process.env.MONGODB_URI;
  if (!mongoURI) {
    console.error('❌ MONGODB_URI not set in .env');
    process.exit(1);
  }

  try {
    await mongoose.connect(mongoURI);
    console.log('✅ Connected to MongoDB Atlas');

    const db = mongoose.connection.db;

    // ── Users Collection ──────────────────────────────────────────────────────
    await db.collection('users').createIndexes([
      { key: { phoneNumber: 1 }, unique: true, name: 'idx_users_phone' },
      { key: { email: 1 }, sparse: true, name: 'idx_users_email' },
      { key: { createdAt: -1 }, name: 'idx_users_created' },
    ]);
    console.log('✅ Users indexes created');

    // ── Profiles Collection ───────────────────────────────────────────────────
    await db.collection('profiles').createIndexes([
      { key: { userId: 1 }, unique: true, name: 'idx_profiles_user' },
      { key: { state: 1 }, name: 'idx_profiles_state' },
      { key: { cropTypes: 1 }, name: 'idx_profiles_crops' },
    ]);
    console.log('✅ Profiles indexes created');

    // ── GovernmentSchemes Collection ──────────────────────────────────────────
    await db.collection('governmentschemes').createIndexes([
      { key: { schemeCode: 1 }, unique: true, name: 'idx_schemes_code' },
      { key: { category: 1 }, name: 'idx_schemes_category' },
      { key: { isActive: 1 }, name: 'idx_schemes_active' },
      { key: { applicableStates: 1 }, name: 'idx_schemes_states' },
      { key: { title: 'text', description: 'text', benefits: 'text' }, name: 'idx_schemes_fulltext' },
      { key: { applicationDeadline: 1 }, name: 'idx_schemes_deadline' },
    ]);
    console.log('✅ GovernmentSchemes indexes created');

    // ── Notifications Collection ──────────────────────────────────────────────
    await db.collection('notifications').createIndexes([
      { key: { userId: 1, isRead: 1 }, name: 'idx_notif_user_read' },
      { key: { topic: 1 }, name: 'idx_notif_topic' },
      { key: { createdAt: -1 }, name: 'idx_notif_created' },
    ]);
    console.log('✅ Notifications indexes created');

    // ── ChatHistories Collection ──────────────────────────────────────────────
    await db.collection('chathistories').createIndexes([
      { key: { userId: 1 }, name: 'idx_chat_user' },
      { key: { createdAt: -1 }, name: 'idx_chat_created' },
    ]);
    console.log('✅ ChatHistories indexes created');

    // ── Bookmarks Collection ──────────────────────────────────────────────────
    await db.collection('bookmarks').createIndexes([
      { key: { userId: 1, schemeId: 1 }, unique: true, name: 'idx_bookmark_user_scheme' },
      { key: { userId: 1 }, name: 'idx_bookmark_user' },
    ]);
    console.log('✅ Bookmarks indexes created');

    // ── EligibilityRules Collection ───────────────────────────────────────────
    await db.collection('eligibilityrules').createIndexes([
      { key: { schemeId: 1 }, name: 'idx_eligibility_scheme' },
      { key: { isActive: 1 }, name: 'idx_eligibility_active' },
    ]);
    console.log('✅ EligibilityRules indexes created');

    // ── Recommendations Collection ────────────────────────────────────────────
    await db.collection('recommendations').createIndexes([
      { key: { userId: 1 }, name: 'idx_recommendations_user' },
      { key: { createdAt: -1 }, name: 'idx_recommendations_created' },
    ]);
    console.log('✅ Recommendations indexes created');

    console.log('\n🎉 All production indexes created successfully!');
    process.exit(0);
  } catch (err) {
    console.error('❌ Index creation failed:', err.message);
    process.exit(1);
  }
}

createIndexes();
