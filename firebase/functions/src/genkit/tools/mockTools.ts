// @ts-nocheck
import { z } from 'genkit';
import { ai, inventoryRetriever } from '../config';

export const searchInventoryTool = ai.defineTool(
  {
    name: 'searchInventory',
    description: 'Searches for travel inventory items such as tours, hotels, concerts, and fine dining using vector similarity matching.',
    inputSchema: z.object({
      query: z.string().describe('The search query or description of the user preferences to match against inventory.'),
      category: z.enum(['tours', 'hotels', 'concerts', 'dining']).optional(),
      limit: z.number().optional().default(3),
    }),
    outputSchema: z.array(z.object({
      id: z.string(),
      title: z.string(),
      description: z.string(),
      price: z.number().optional(),
    })),
  },
  async ({ query, limit }) => {
    // Perform vector search using the defined retriever
    const docs = await ai.retrieve({
      retriever: inventoryRetriever,
      query: query,
      options: { limit: limit },
    });

    return (docs as any[]).map(doc => ({
      id: (doc.metadata?.id as string) || 'unknown',
      title: doc.text || 'Untitled',
      description: doc.text || '',
      price: (doc.metadata?.price as number),
    }));
  }
);

export const createItineraryTool = ai.defineTool(
  {
    name: 'createItinerary',
    description: 'Creates a custom travel itinerary based on user preferences and selected items.',
    inputSchema: z.object({
      destination: z.string(),
      days: z.number(),
      items: z.array(z.string()),
    }),
    outputSchema: z.object({
      itineraryId: z.string(),
      status: z.string(),
    }),
  },
  async ({ destination, days, items }) => {
    return {
      itineraryId: `itin-${Date.now()}`,
      status: 'success',
    };
  }
);

export const bookTicketTool = ai.defineTool(
  {
    name: 'bookTicket',
    description: 'Books a ticket for a specific inventory item.',
    inputSchema: z.object({
      itemId: z.string(),
      date: z.string(),
    }),
    outputSchema: z.object({
      bookingId: z.string(),
      status: z.string(),
    }),
  },
  async ({ itemId, date }) => {
    return {
      bookingId: `book-${Date.now()}`,
      status: 'confirmed',
    };
  }
);

export const addToCalendarTool = ai.defineTool(
  {
    name: 'addToCalendar',
    description: 'Adds a confirmed booking or itinerary to the user calendar.',
    inputSchema: z.object({
      title: z.string(),
      date: z.string(),
    }),
    outputSchema: z.object({
      success: z.boolean(),
    }),
  },
  async ({ title, date }) => {
    return {
      success: true,
    };
  }
);
