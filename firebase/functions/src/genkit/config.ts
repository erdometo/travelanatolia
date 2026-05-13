// @ts-nocheck
import { genkit } from 'genkit';
import { googleAI } from '@genkit-ai/googleai';
import { defineFirestoreRetriever } from '@genkit-ai/firebase';
import * as admin from 'firebase-admin';

if (!admin.apps.length) {
  admin.initializeApp();
}

export const ai = genkit({
  plugins: [
    googleAI(),
  ],
});

// Define the Firestore Vector Search retriever for the inventory collection
export const inventoryRetriever = defineFirestoreRetriever(ai, {
  name: 'inventoryRetriever',
  firestore: admin.firestore(),
  collection: 'inventory',
  embedder: 'googleai/text-embedding-004',
  vectorField: 'embedding',
  contentField: 'description',
  distanceMeasure: 'COSINE',
});
