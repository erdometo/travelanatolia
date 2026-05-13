---
name: TravelAnatolia
colors:
  surface: '#fef8f3'
  surface-dim: '#ded9d4'
  surface-bright: '#fef8f3'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f8f3ee'
  surface-container: '#f3ede8'
  surface-container-high: '#ede7e2'
  surface-container-highest: '#e7e1dd'
  on-surface: '#1d1b19'
  on-surface-variant: '#584238'
  inverse-surface: '#32302d'
  inverse-on-surface: '#f6f0eb'
  outline: '#8c7166'
  outline-variant: '#e0c0b2'
  surface-tint: '#a04100'
  primary: '#9c3f00'
  on-primary: '#ffffff'
  primary-container: '#c45100'
  on-primary-container: '#fffbff'
  inverse-primary: '#ffb693'
  secondary: '#2e628c'
  on-secondary: '#ffffff'
  secondary-container: '#9dcefe'
  on-secondary-container: '#215882'
  tertiary: '#964141'
  on-tertiary: '#ffffff'
  tertiary-container: '#b55958'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbcc'
  primary-fixed-dim: '#ffb693'
  on-primary-fixed: '#351000'
  on-primary-fixed-variant: '#7a3000'
  secondary-fixed: '#cee5ff'
  secondary-fixed-dim: '#9acbfb'
  on-secondary-fixed: '#001d32'
  on-secondary-fixed-variant: '#0b4a73'
  tertiary-fixed: '#ffdad8'
  tertiary-fixed-dim: '#ffb3b0'
  on-tertiary-fixed: '#400107'
  on-tertiary-fixed-variant: '#7b2c2e'
  background: '#fef8f3'
  on-background: '#1d1b19'
  surface-variant: '#e7e1dd'
typography:
  display-lg:
    fontFamily: notoSerif
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: notoSerif
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: notoSerif
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  assistant-voice:
    fontFamily: plusJakartaSans
    fontSize: 20px
    fontWeight: '500'
    lineHeight: 30px
    letterSpacing: 0.01em
  body-md:
    fontFamily: plusJakartaSans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-sm:
    fontFamily: plusJakartaSans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-padding-desktop: 40px
  container-padding-mobile: 20px
  gutter: 24px
  chat-gap: 12px
---

## Brand & Style

This design system centers on the concept of "Identity Tourism"—a philosophy that travel should be a deeply personal dialogue between the traveler and the soul of the destination. The brand persona is the "Sophisticated Travel Buddy": someone who has explored every hidden alley of the Grand Bazaar but speaks with the warmth of a lifelong friend.

The visual style utilizes **Glassmorphism** as its core structural driver. By layering translucent surfaces over rich, organic background imagery, the UI achieves a sense of depth and openness. The emotional response is one of "Atmospheric Luxury"—premium and curated, yet devoid of the coldness often found in high-end travel apps. The "Assistant-First" approach ensures that every interaction feels like a conversation, reducing cognitive load and fostering a sense of expert guidance.

## Colors

The palette is an evocative journey through the Turkish landscape.
- **Primary (Sunset Orange):** A vibrant, energetic orange used for primary actions, assistant highlights, and key brand moments.
- **Secondary (Mediterranean Blue):** A deep, reliable navy that provides grounding and professional contrast. Used for headers and primary text.
- **Tertiary (Terracotta):** An earthy, clay-like tone that adds warmth to background elements and supporting UI components.
- **Neutral (Sand & Bone):** A warm-toned off-white base that avoids the sterile feel of pure white, providing a soft canvas for glass effects.

Color application should favor a 60-30-10 ratio, where the warm neutrals dominate, the blue provides professional structure, and the orange serves as the "spark" of the assistant's personality.

## Typography

This design system uses a sophisticated pairing of **Noto Serif** and **Plus Jakarta Sans**. 

- **Noto Serif** is reserved for display headings and titles, providing a literary, culturally rich foundation that feels established and "expert."
- **Plus Jakarta Sans** serves as the "assistant's voice." Its rounded terminals and modern geometry make the conversational interface feel approachable and friendly. 

The `assistant-voice` style is specifically tuned for chat bubbles, utilizing a slightly larger font size and generous line-height to ensure the primary interaction point is effortless to read.

## Layout & Spacing

The layout follows a **Fluid Grid** model with a heavy emphasis on vertical "Conversational Flow." 

- **Desktop:** A centered 12-column container (max-width 1280px). The chat interface resides in a flexible sidebar or a central focused column (8 columns wide).
- **Mobile:** A single-column layout with 20px safe-area margins.
- **Rhythm:** An 8px base unit drives all spacing. The distance between the assistant’s messages and user responses is kept tight (12px) to signify a cohesive dialogue.

The primary entry point is always the "Chat Horizon"—a fixed bottom-area where the conversational input lives, elevated by a glassmorphic panel that allows the destination content to peek through.

## Elevation & Depth

This design system utilizes **Atmospheric Glassmorphism** to create a sense of presence.

- **Level 1 (Base):** Earthy neutral backgrounds or high-quality photography with a slight dark overlay.
- **Level 2 (Panels):** Semi-transparent surfaces (Background Blur: 20px, Opacity: 70%) with a 1px inner white border to simulate light catching the edge of glass.
- **Level 3 (Interactive):** Elements like "Book Now" cards or active chat bubbles use soft, diffused ambient shadows (Color: Mediterranean Blue at 5% opacity, Blur: 30px) to appear lifted without feeling heavy.

Avoid harsh, high-contrast shadows. Depth should feel like layers of silk or vellum rather than stacked plastic.

## Shapes

The shape language is **Rounded**, mirroring the organic arches of Anatolian architecture and the soft curves of pottery.

- **Standard Elements:** Buttons and input fields use a 0.5rem (8px) radius.
- **Chat Bubbles:** Use a "Asymmetric Pill" (rounded-xl) where the tail pointing to the speaker has a smaller radius, giving the interface a directional, conversational flow.
- **Images:** Always feature rounded-lg (16px) corners to maintain the soft, inviting aesthetic.

## Components

- **Conversational Input:** A wide, pill-shaped field with a frosted glass background. The "Send" button is a solid Sunset Orange circle with a minimal icon.
- **Assistant Bubbles:** These use a subtle Mediterranean Blue tint (low opacity) with Jakarta Sans typography to signify expertise.
- **User Bubbles:** These use a clean Terracotta or White glass effect to distinguish the user's voice.
- **Experience Cards:** These feature full-bleed imagery with a glassmorphic "Identity Tag" (e.g., "Hand-woven," "Local Secret") in the top left corner.
- **Curated Lists:** Instead of standard bullet points, use small Mediterranean Blue tile icons or organic Mediterranean-inspired glyphs.
- **Primary Buttons:** High-saturation Sunset Orange with white text. Use a soft glow (box-shadow) on hover to simulate warmth.
- **Destination Chips:** Small, semi-transparent pills used for filtering interests (e.g., "History," "Gastronomy," "Hidden Gems").