// @ts-nocheck
import * as admin from 'firebase-admin';
import { onCall } from 'firebase-functions/v2/https';
import { onDocumentWritten } from 'firebase-functions/v2/firestore';
import { ai } from './genkit/config'; 
import { assistantFlow } from './genkit/flows/assistantFlow';

admin.initializeApp();

// Export the Genkit flow as a Firebase Callable Function in the europe-west3 region
export const chatWithAssistant = onCall(
  { region: 'europe-west3' },
  async (request) => {
    // Flows are callable functions in modern Genkit
    const result = await assistantFlow(request.data);
    return result;
  }
);

// Firestore Trigger: Combines onboarding answers into a User Identity Profile
export const onUserOnboardingUpdate = onDocumentWritten(
  {
    document: 'users/{userId}/onboarding/{docId}',
    region: 'europe-west3',
  },
  async (event) => {
    if (!event.data) return;
    
    const snapshot = event.data.after;
    if (!snapshot.exists) return; 

    const data = snapshot.data();
    const userId = event.params.userId;

    const userRef = admin.firestore().collection('users').doc(userId);
    await userRef.set({
      identityProfileUpdated: true,
      latestOnboardingData: data,
      lastUpdatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });
  }
);
