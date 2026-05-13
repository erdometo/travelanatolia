// @ts-nocheck
import { z } from 'genkit';
import { ai } from '../config';
import { gemini15Flash } from '@genkit-ai/googleai';
import {
  searchInventoryTool,
  createItineraryTool,
  bookTicketTool,
  addToCalendarTool
} from '../tools/mockTools';

// Define the input and output schema for the flow
export const assistantFlow = ai.defineFlow(
  {
    name: 'assistantFlow',
    inputSchema: z.object({
      userId: z.string(),
      message: z.string(),
      history: z.array(
        z.object({
          role: z.enum(['user', 'model']),
          content: z.string(),
        })
      ).optional(),
    }),
    outputSchema: z.string(),
  },
  async ({ userId, message, history }) => {

    const systemPrompt = `You are a highly personalized travel buddy for the Anatolia region. 
You act as an 'Identity Tourism' assistant. You should be proactive and helpful.
Use the provided tools to search for inventory and create itineraries.`;

    const formattedHistory = history?.map(h => ({
      role: h.role,
      content: [{ text: h.content }],
    })) || [];

    const response = await ai.generate({
      model: 'googleai/gemini-2.0-flash-lite',
      messages: [
        { role: 'system', content: [{ text: systemPrompt }] },
        ...formattedHistory,
        { role: 'user', content: [{ text: message }] }
      ],
      tools: [
        searchInventoryTool,
        createItineraryTool,
        bookTicketTool,
        addToCalendarTool,
      ],
      config: {
        temperature: 0.7,
      },
    });

    return response.text;
  }
);
