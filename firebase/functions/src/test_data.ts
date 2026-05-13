import * as admin from 'firebase-admin';

// Initialize admin if not already initialized
if (admin.apps.length === 0) {
  admin.initializeApp({
    projectId: 'travelanatolia-prod',
  });
}

const db = admin.firestore();

const mockInventory = [
  {
    title: 'Galata Wine Cellar',
    description: 'Tucked away in a 14th-century vault, featuring Thracian varietals and historic ambiance.',
    category: 'Fine Dining',
    location: 'Istanbul',
    price: 45,
  },
  {
    title: 'Cappadocia Hot Air Balloon',
    description: 'A breathtaking sunrise flight over the fairy chimneys and valleys of Goreme.',
    category: 'Tours',
    location: 'Cappadocia',
    price: 250,
  },
  {
    title: 'Ephesus Ancient City Tour',
    description: 'A guided walk through one of the best-preserved Greco-Roman cities in the Mediterranean.',
    category: 'Tours',
    location: 'Selcuk',
    price: 60,
  },
  {
    title: 'Bodrum Yacht Cruise',
    description: 'A private day trip on a traditional gulet along the turquoise Aegean coast.',
    category: 'Tours',
    location: 'Bodrum',
    price: 500,
  },
  {
    title: 'Sultanahmet Fine Dining',
    description: 'Experience Ottoman palace cuisine with a view of the Hagia Sophia.',
    category: 'Fine Dining',
    location: 'Istanbul',
    price: 120,
  },
  {
    title: 'Mardin Silk Workshop',
    description: 'Learn the ancient art of silk weaving from local masters in Mesopotamia.',
    category: 'Workshops',
    location: 'Mardin',
    price: 85,
  },
  {
    title: 'Antalya Coastal Run',
    description: 'Join local enthusiasts for a sunrise run along the cliffs of Antalya.',
    category: 'Run Clubs',
    location: 'Antalya',
    price: 0,
  },
  {
    title: 'Cave Hotel Suite',
    description: 'Stay in a luxury suite carved directly into the volcanic tuff of Cappadocia.',
    category: 'Boutique Hotels',
    location: 'Uchisar',
    price: 350,
  },
  {
    title: 'Izmir Culinary Tour',
    description: 'Explore the vibrant food markets and hidden eateries of the Aegean coast.',
    category: 'Fine Dining',
    location: 'Izmir',
    price: 75,
  },
  {
    title: 'Ebru Marbling Class',
    description: 'Discover the meditative art of Turkish paper marbling in a historic Istanbul studio.',
    category: 'Workshops',
    location: 'Istanbul',
    price: 55,
  },
  {
    title: 'Pamukkale Travertines',
    description: 'Walk through the white thermal pools and explore the ancient city of Hierapolis.',
    category: 'Tours',
    location: 'Denizli',
    price: 40,
  },
  {
    title: 'Ottoman Mansion Stay',
    description: 'A beautifully restored 19th-century mansion in the heart of the Old City.',
    category: 'Boutique Hotels',
    location: 'Istanbul',
    price: 220,
  }
];

export async function seedInventory() {
  const inventoryRef = db.collection('inventory');
  
  // Clear existing items first to avoid duplicates
  const snapshot = await inventoryRef.get();
  const deleteBatch = db.batch();
  snapshot.docs.forEach((doc) => deleteBatch.delete(doc.ref));
  await deleteBatch.commit();
  console.log('Cleared existing inventory.');

  const batch = db.batch();
  for (const item of mockInventory) {
    const docRef = inventoryRef.doc();
    batch.set(docRef, {
      ...item,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log(`Prepared ${item.title}...`);
  }
  
  await batch.commit();
  console.log('Seeding complete!');
}

// If running directly
if (require.main === module) {
  seedInventory().catch(console.error);
}
