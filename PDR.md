# The Usual — Product Design Requirements (PDR)

**Version:** 0.2 · **Date:** 2026-11-05 · **Owner:** Zai
**Build status:** NOT STARTED. No code is written until the owner gives the go-ahead.

> Status key: **[LOCKED]** = decided, build to it. **[DEFAULT]** = recommended, assumed unless overruled. **[LATER]** = explicitly not in the first build.

### Changelog from v0.1
- New 9-colour palette adopted (§8.2); dark ("Espresso") is the home theme.
- **Auth is email + password**, stored in Supabase (§6.1). Magic link removed.
- **TV shows are in v1** (§6.14). A season is a case, like a DVD season set.
- **Rewatches are always logged as Rewatches**, explicitly labelled (§6.3).
- **Vocabulary simplified** to plain words (§4).
- **Navigation simplified** to three tabs plus one button (§7).
- **Desktop is a first-class design target**, not a stretched phone layout (§8.9).
- **"Avoid the AI look" is now a written design rule** (§8.1).
- Monetisation kept for reference but excluded from the first build (§11).

---

## 1. Vision [LOCKED]

**The Usual** is a film diary built around the ritual of watching with someone you care about. Letterboxd asks "what did you watch and what did you think?" The Usual asks "**who did you watch it with, and what was that night like?**"

Every film or season you watch becomes a **case on your shelf**, a warm, tactile, DVD-style keepsake that remembers the title, the person, the date, the snacks and the feeling. It exists purely for the love of film.

**Tagline:** "Movies are better with someone."

**Name logic:** "The usual" is what you order without asking, the regular night, the person you always watch with.

## 2. Product principles [LOCKED]

1. **Together first.** Every flow assumes there may be a second person. Solo watching is fully supported.
2. **Intimate, not performative.** No follower counts, no public like-counts, no leaderboards, no trending. Small circle by default. Purely for the love of film.
3. **Tactile and warm.** A shelf of well-loved discs in a lamp-lit room, not a dashboard.
4. **Memory over metrics.** Stats exist, but the hero is the memory: the note, the snack, the date.
5. **Fast to log.** Logging takes under 20 seconds. Richness is optional, never required.
6. **Nothing shouts.** Calm motion, no streaks, no guilt notifications.
7. **Plain words.** If a new user has to ask what a label means, rename it.

## 3. Audience [LOCKED]

| Persona | Description | Core need |
|---|---|---|
| **The Couple** (primary) | Partners with a regular movie night | A shared record of their nights; pick something without arguing |
| **The Duo** | Best friends / siblings / roommates with a ritual | Same, with a "we've watched N together" history |
| **The Solo Cinephile** | Letterboxd-style logger who sometimes watches with others | A better-looking diary; tag who they watched with |
| **The Long-Distance Pair** | Watching in sync over a call | Shared shelf and planning from afar |

v1 optimises for the Couple and the Duo. Groups of 3+ work via multiple companion tags but get no special design.

## 4. Vocabulary [LOCKED, simplified]

Rule: use words people already know. Anything "clever" must be self-explanatory in context, and the first-run UI explains each term once, inline.

| Term shown to users | Meaning | Replaces (v0.1) |
|---|---|---|
| **Shelf** | Your collection of cases | (same) |
| **Case** | One film, or one season of a show, shown as a DVD case | (same) |
| **Watch** | One viewing. First time = "Watch"; again = **"Rewatch"** | (same + Rewatch) |
| **Rewatch** | A repeat viewing of something already on your shelf. Always labelled | new |
| **With** | The person or people you watched with | "Companion" |
| **Us** | The shared space between you and a person you've linked with | "Shared Shelf / Together" |
| **Tonight** | Your shared "to watch" list and the "help us pick" tool | (same) |
| **Snacks** | What you ate and drank during the watch | "The Order" |
| **Secret ratings** | You each rate privately, then reveal together | "Sealed Take" |
| **Your Usual** | The one person you pin as your main watch partner | "The Usual" (as a pair concept) |
| **Guest** | A person you watched with who has no account yet | "Guest companion" |
| **Lists** | Hand-made groups of films | "Boxset" ([LATER]) |
| **Year in Review** | End-of-year summary ([LATER]) | "Rotation" |

Internally (code, database) we may keep the old names; user-facing copy uses only the table above.

## 5. Scope

### 5.1 First build (MVP) — must ship [LOCKED]
- Accounts (email + password), profile, linking with another person
- Search and metadata for **movies and TV** (TMDB)
- **Log a Watch** incl. **Rewatch** handling, with person, date, rating, note, snacks, setting, mood
- **DVD-case shelf** UI (shelf view, grid view, flip-open case)
- **Us** space: shared shelf between two linked accounts
- **Secret ratings** and reveal
- **Tonight**: shared list + "help us pick"
- Title detail page with watch history
- Simple stats on profile and per pair
- Letterboxd CSV import
- Mobile-first responsive web app, equally good on desktop, installable (PWA)

### 5.2 Later [LATER]
- Year in Review share cards
- Lists
- Where-to-watch (streaming availability)
- Press-play-together countdown
- Native iOS/Android
- Reminders / calendar
- Groups of 3+ as a designed experience
- Physical keepsake export
- **Paid tier (not part of first build; see §11)**

### 5.3 Never
Public follower counts, algorithmic "trending", ads, selling user data, streaks or guilt gamification, AI-written reviews.

## 6. Features in detail

### 6.1 Accounts and onboarding [LOCKED]

**Sign-up / sign-in:** email + password.
- Handled by **Supabase Auth**. Credentials live in Supabase's managed `auth` schema in our Supabase project. Passwords are stored only as salted bcrypt hashes; our own code and database tables never see or store a plain password.
- Email verification required before first sign-in completes.
- Password rules: minimum 10 characters, no forced symbols/cases (length over complexity), "show password" toggle, breached-password check where the Supabase plan supports it.
- "Forgot password" by emailed reset link. Change password and change email in Settings.
- Rate limiting and lockout on repeated failures.
- Social sign-in (Google / Apple) is **not** in the first build. See open question Q1.

**Where data lives:** everything (accounts, profiles, cases, watches, queue, notifications) is in the same **Supabase Postgres** project. Profile details sit in our own `profiles` table linked to the auth user ID. Row-level security makes each user's data private to them and the people they've explicitly linked with.

**Onboarding (3 short steps, all skippable):**
1. Display name + `@handle`
2. Pick a spine colour (from the palette)
3. "Who do you usually watch with?" Invite one person by link/email, or skip.

**Profile:** display name, handle, avatar, short bio, privacy setting.
**Account deletion and full data export (JSON/CSV)** in Settings. [LOCKED]

### 6.2 Linking with people ("With" and "Us") [LOCKED]

- **Everyone who links has their own account, their own shelf, their own ratings.** Linking creates a mutual connection and unlocks the shared **Us** space; it never merges accounts.
- **Invite** by shareable link, handle or email. Both sides must accept.
- **Guests:** for people without an account, type a name ("Mum", "Jess"). Guests appear on your cases but have no shelf. If the guest later signs up, you can invite them to claim those past cases; nothing transfers without their consent.
- Pin one person as **Your Usual**.
- **Unlinking:** the shared Us view disappears for both; each person keeps their own cases and notes. Nothing is deleted from either shelf.
- **Blocking:** severs the link and hides each from the other.

### 6.3 Log a Watch (core flow) [LOCKED]

Entry points: the central "+" button, any title page, and Tonight ("We watched it").

One sheet. Only the title is required. Order top to bottom:
1. **Title** (search as you type; movies and shows)
2. **Who with** (your linked people as chips; "Just me"; add a Guest)
3. **When** (default Today; Last night; date picker)
4. **Rating** (half-stars, 0.5–5, optional)
5. **Note** (500-character soft limit, optional)
6. **Snacks** (free text chips with suggestions from your past snacks)
7. **Where** (Couch · Cinema · Outdoors · Video call · Bed · Other)
8. **Mood** (up to 3: cosy, tense, laughed, cried, fell asleep, rewatch-worthy, never again)

On Save, the case slides onto the shelf.

**Rewatch rules [LOCKED, per owner]:**
- If the title (or season) is already on your shelf, the app asks once: **"You've watched this before. Log as a Rewatch?"** Default answer: Rewatch. The only alternative offered is "Log as new date for the first watch" (correcting a mistake); it is never the default.
- A Rewatch is stored as its own Watch (`kind = rewatch`), never overwriting the original.
- The case shows a clear **"Rewatch ×N"** badge. The case's flip side shows a timeline of every watch: "First watch · 12 Mar 2025 · with Sam", "Rewatch · 3 Nov 2026 · with Jess".
- Rewatch ratings and notes are separate from the first watch; the case face shows the latest rating, the timeline shows the history.
- Stats count first watches and rewatches separately ("142 films, 31 rewatches").
- Filters include **Rewatches only**.

Drafts autosave locally.

### 6.4 The Case and the Shelf (signature UI) [LOCKED]
- **Shelf view (default):** spines on wooden shelves. Tap or hover pulls a case forward.
- **Grid view:** front covers in a grid for fast scanning.
- **Case detail:** the case lifts and opens.
  - **Front:** poster as cover art, title strip, rating badge, Rewatch badge if any.
  - **Spine:** title, year, a colour tab for the person you watched with, rating.
  - **Back (like a DVD back cover):** synopsis, "Watched with ___ on ___", snacks, both people's ratings (after reveal), mood, runtime, director, cast, and the watch timeline.
  - **Disc:** shown inside the case; tapping it opens the Rewatch timeline.
- **Sort:** date watched, rating, title, release year, person. **Filter:** movies/shows, person, year, genre, rating, where, mood, Rewatches only.
- **Wear:** cases you've rewatched look slightly more handled (softer corners, faint scuffs). Decorative only. [DEFAULT]

### 6.5 Secret ratings [LOCKED]
- After a watch with a linked person, each of you gets a private prompt: rating + one-line take.
- Neither sees the other's until **both submit**, or 48 hours pass, or either taps "Reveal now".
- Reveal moment: the two takes appear side by side on the case back. Copy is warm and a little wry ("You were half a star apart"), never judgemental.
- Optional, skippable, off-switchable in Settings.

### 6.6 Us (shared space) [LOCKED]
- Per linked person: everything watched together, both of your ratings, shared snacks and moods.
- Header: "You & Sam · 47 titles · since March 2025".
- Highlights: first watch together · most-rewatched · biggest disagreement · favourite snack · longest watch.
- Either person can add to the shared shelf; the other receives it and, if relevant, a secret-rating prompt.
- Also home to the **Secret ratings inbox** (anything waiting for you).

### 6.7 Tonight [LOCKED]
- **Shared list:** both people add titles; each shows who added it.
- **Help us pick** (three modes, one screen):
  1. *We both want these*: overlaps first.
  2. *Surprise us*: random from the list with a disc-spin animation.
  3. *In the mood*: choose a mood and time available; suggestions come from TMDB genres/runtime and your list.
- **One veto each** per round.
- Choosing a title starts a draft Watch that you finish logging afterwards.
- For shows, Tonight can also hold **"Currently watching together"** with a simple "up to S2 E4" marker.
- No calendar integration in v1.

### 6.8 Title page [LOCKED]
- Poster, backdrop, synopsis, cast and crew, runtime, genres (TMDB).
- **Your history:** your watches and Rewatches, who with, your notes.
- **Together history:** when you've watched it with a linked person.
- Actions: **Log a Watch**, **Add to Tonight**.
- No public reviews. A linked person's rating is visible only through Us/secret-rating reveal.

### 6.9 Profile and stats [LOCKED]
- Public profile **off by default**; linked people see what you choose to share. Opt-in public URL.
- Stats: titles watched, hours, rewatches, top people, favourite genres, rating spread, favourite snacks, busiest month, where you watch.
- Charts use only palette colours (no cold default chart blues).

### 6.10 Search [LOCKED]
- One search entry (top bar on mobile, persistent field on desktop): titles (TMDB), your cases, your people.
- Results grouped, with a Movies / Shows toggle.

### 6.11 Import / export [LOCKED]
- **Import:** Letterboxd `diary.csv` / `ratings.csv`. Imported rows become cases (movies only, "Just me"); user can later bulk-tag who they watched with. Repeat entries in the diary import as Rewatches.
- **Export:** everything as JSON and CSV.

### 6.12 Notifications [LOCKED]
- In-app, email, and push when installed.
- Only these: invite received, secret-rating request, reveal ready, someone added to Tonight.
- Never: "log your movie", streak nudges, marketing without opt-in. Each type individually toggleable.

### 6.13 Privacy and safety [LOCKED]
- Private by default; sharing is an explicit action per person.
- Block and report. Minimum age 13. Terms and privacy policy reviewed before public launch.
- Guest names visible only to their creator.

### 6.14 TV shows [LOCKED, new]

Shows are in v1. The DVD metaphor is a natural fit: **a season is a case, like a season set.**

- **Search** returns movies and shows together, with a toggle.
- **Unit of logging = season (default).** One Watch = a season (or a whole miniseries). The case is titled "Show name · Season 2" and styled as a season-set case (slightly thicker spine to differ from a film case).
- **Optional episode progress** for in-flight viewing: on the Tonight "Currently watching together" card, mark "up to S2 E4". Individual episodes are *not* separate cases and are not required to be logged. [DEFAULT]
- **Show page** groups all seasons you have on the shelf, with their ratings and who you watched with.
- **Rating** is per season; the show page shows the average as a convenience.
- **Rewatch** applies per season, same rules as §6.3.
- **Runtime/mood picker:** for shows uses typical episode runtime and count.
- **Letterboxd import** is movies only; TV has no import in v1.
- **Stats:** counted in hours and as "seasons" separately from films.
- Data source: TMDB TV endpoints (shows, seasons, episode counts).

## 7. Information architecture [LOCKED, simplified]

Goal: fewest taps to the two things people do most, which are **log something** and **look at the shelf**, with the intimate part (Us) always one tap away.

```
Top bar (always):   [The Usual wordmark]        [Search]  [Avatar → Me]
Bottom bar (mobile) / left rail (desktop):

   Shelf        Us        ( + )        Tonight

Shelf   → shelf / grid views → case (opens)
Us      → people you're linked with → shared shelf per person
          → secret ratings waiting for you
+       → Log a Watch (sheet)
Tonight → shared list → help us pick
Me      → profile, stats, settings, import/export
```

- Three tabs plus one central button. Search and profile live in the top bar so the bar stays calm.
- Maximum two taps to reach any main screen; maximum one tap to start a log.
- Intimacy cues in the structure: **Us** has equal billing with your own Shelf; the "Your Usual" person is pre-selected as "With" in the log sheet.

## 8. Visual and interaction design

### 8.1 Mood and the "no AI look" rule [LOCKED]

**Target mood:** a warm, lamp-lit living room; a well-loved video-rental shelf; polished wood, brushed metal, a bit of foil on a disc. Tactile and slightly imperfect. Grown-up and quiet.

**Explicitly avoid (design review checklist; any of these in a screen is a defect):**
- Purple-to-blue or any rainbow gradient backgrounds, mesh gradients, glowing blobs
- Glassmorphism / frosted-blur cards stacked on gradients
- Uniform grids of identical rounded cards with soft drop shadows as the default layout
- Centered hero + two buttons + three feature-icon columns patterns
- Sparkle / magic-wand icons, emoji as UI icons, stock "3D blob" illustrations
- Default-looking font stacks (Inter, Roboto, Space Grotesk, system-ui used as the personality)
- Over-rounded everything, pill buttons everywhere, giant pastel shadows
- Chirpy, over-friendly copy ("Welcome back! 🎉", "Let's get started!", "Oops!")
- Fake testimonials, stock-people photos, generic dashboards with KPI tiles

**Instead:**
- Real materials: wood grain on the shelf, soft paper/linen grain on surfaces, a faint film-grain overlay (very low opacity), plastic sheen on cases.
- Irregularity: spines of slightly different heights and thicknesses, cases leaning, rewatched cases a little worn.
- Hand-set typography with a clear hierarchy and generous whitespace.
- Copy that sounds like a person: short, dry, specific.
- Iridescence is a **material**, not a background: only on disc surfaces, a foil edge on a case, and the secret-rating reveal. It never fills a page or a button.

### 8.2 Colour palette [LOCKED, provided by owner]

| Name | Hex | Role |
|---|---|---|
| **Espresso** | `#261F1D` | Primary dark background (home theme) |
| **Cinema Cream** | `#F5E6D2` | Primary text on dark; light-mode background |
| **Champagne** | `#D8B596` | Metallic highlights: foil edges, rating stars, thin rules |
| **Brushed Copper** | `#B77D55` | Warm accents: primary buttons on dark, active states |
| **Walnut** | `#78462F` | Wood-inspired surfaces: the shelf, panels |
| **Oxblood** | `#63352F` | Secondary brand colour: secondary buttons, case labels, light-mode accents |
| **Soft Gold** | `#E4C6A3` | Gradient highlight (paired with Champagne/Copper for metallic sheen) |
| **Dusty Mauve** | `#806C82` | Iridescent accent (disc, reveal) |
| **Iridescent Blue** | `#9CAFCB` | Iridescent accent (disc, reveal) |

**Themes**
- **Dark ("Espresso") is the home theme:** background Espresso, text Cinema Cream, shelf Walnut, accents Copper/Champagne, secondary Oxblood.
- **Light ("Cream"):** background Cinema Cream, text Espresso, shelf Walnut, accents Oxblood and Copper (non-text).
- Auto follows the system setting; the user can override.

**Usage rules**
- Metallic effects: a subtle linear gradient Champagne → Soft Gold → Brushed Copper, used on thin edges, stars, and the case foil only.
- Iridescent effect: a narrow angled blend Mauve ↔ Iridescent Blue ↔ Champagne, used on the disc and reveal only.
- Companion/person spine colours (8 curated): Copper, Oxblood, Mauve, Iridescent Blue, Champagne, Walnut, Soft Gold, and a muted Cream. Always paired with a name or initial.

**Contrast notes (approximate, to be verified in build with a checker)**
- Cinema Cream on Espresso: very high contrast (body text, passes AAA).
- Brushed Copper on Espresso ≈ 4.6:1 — OK for text; fine for UI.
- Dusty Mauve on Espresso ≈ 3.3:1 — **UI/decorative or large text only**.
- Brushed Copper on Cinema Cream ≈ 2.8:1 — **fails for text**; in light mode use Oxblood for accent text and Copper for non-text only.
- Oxblood on Cinema Cream ≈ 9:1 — good for text and buttons.

### 8.3 Typography [DEFAULT, final choice made in the prototype]
- **Display:** a warm, characterful serif that feels like film titling, not a trend font. Candidates to test: *Gloock* and *Young Serif*. No Playfair Display (overused).
- **Interface/body:** a humanist sans with some personality. Candidates: *Figtree*, *Familjen Grotesk*, *Public Sans*. Not Inter.
- **Spines:** a condensed sans in tracked caps (e.g. *Barlow Condensed*), like printed spine labels.
- **Handwritten:** a restrained script only on snack and note snippets, used sparingly.
- Final selection happens during the case prototype; the choice is locked after the owner approves.

### 8.4 The case component [LOCKED]
- Front ratio about 135 × 190 mm; film spine ~14 mm; **season-set spine slightly thicker** to differ from a film.
- Built with CSS 3D transforms (no WebGL in v1).
- Layers: plastic sheen, poster art, title strip, rating badge (Champagne foil), Rewatch ×N badge, small person-colour tab.
- States: resting, lift (hover or tap), open, flipped (back).
- Missing poster: a generated cover from palette + title typography.
- Performance: 60 fps with 100 spines on a mid-range phone; virtualised beyond.
- Reduced motion: cross-fades instead of rotations.
- Accessibility: a case is a real button; its details are real DOM text.

### 8.5 Motion [LOCKED]
- 250–450 ms, gentle easing, slight overshoot only when a case lands on the shelf.
- Signature moments: case slides onto shelf, case opens, disc spin (Surprise us), seal-break on secret-rating reveal.
- Optional soft sounds (case click, disc whir), off by default.

### 8.6 Layout fundamentals
4/8 px grid, 16 px mobile gutters, max content width 1280 px on large desktop. See §8.9 for breakpoints.

### 8.7 Empty states
In voice and drawn from the world: an empty shelf with one lamp: "Nothing here yet. What was the last one?"

### 8.8 Voice and tone [LOCKED]
Warm, brief, a little wry; never saccharine. Examples: "Pick tonight's." · "You two disagreed on this one." · "Same again?" · "Rewatch ×3. Good taste, or a bad habit."

### 8.9 Mobile-first AND desktop [LOCKED]

Both are first-class. Design the phone first, then design the desktop deliberately; never just scale the phone up.

| Aspect | Mobile (≥ 360 px) | Tablet (≥ 768 px) | Desktop (≥ 1100 px) |
|---|---|---|---|
| Navigation | Bottom bar: Shelf · Us · (+) · Tonight; search + avatar in top bar | Same bottom bar or rail | **Left rail** with the same four items; search is a persistent field in the top bar |
| Shelf | 1 shelf row = ~7 spines; vertical scroll | ~12 spines | **Full "wall" of shelves**, ~20+ spines per row, wood-panel backdrop |
| Case opens | Full-screen sheet with flip | Large sheet | **Side-by-side**: shelf stays visible; open case on the right as a docked panel |
| Log a Watch | Bottom sheet | Centred sheet | **Centred modal**; keyboard-friendly, Tab through fields |
| Tonight | Single column | Two columns | Two panes: list on the left, "help us pick" on the right |
| Us | Person list → shelf | Split | Person list left, shared shelf right |
| Input | Touch, 44 px targets, swipe to flip | Touch + pointer | Mouse hover effects, **keyboard shortcuts** (`N` new watch, `/` search, `←/→` through shelf, `Esc` close) |

- Hover-only effects always have a tap equivalent; touch-only gestures always have a click equivalent.
- The site is a normal web page at every size (real URLs, back button, shareable links to your own pages), installable as a PWA on phones.
- QA matrix: iPhone Safari, Android Chrome, iPad Safari, desktop Chrome/Safari/Firefox/Edge.

## 9. Accessibility [LOCKED]
- WCAG 2.2 AA minimum.
- Every 3D interaction has a keyboard and screen-reader equivalent.
- `prefers-reduced-motion` honoured.
- Rating widget usable by keyboard in half-star steps and clearly labelled.
- Colour never carries meaning alone (person colour always has a name/initial).
- Text resizable to 200% without breaking layout.
- Colour contrast verified against §8.2 notes.

## 10. Technical approach

### 10.1 Stack [DEFAULT]
| Layer | Choice |
|---|---|
| Framework | Next.js (App Router) + TypeScript |
| Styling | Tailwind CSS with CSS variables for the §8.2 tokens |
| Animation | Framer Motion + CSS 3D |
| Database | **Supabase Postgres** |
| Auth | **Supabase Auth, email + password** |
| ORM | Drizzle (or Prisma) |
| Storage | Supabase Storage (avatars only); posters come from TMDB's image CDN |
| Film and TV data | TMDB API (movies and TV endpoints) |
| Hosting | Vercel |
| Email | Resend (invites, reveals) plus Supabase's auth emails (verify, reset) |
| Analytics | Plausible |
| Errors | Sentry |
| PWA | Serwist / next-pwa |

### 10.2 Data model (v1)
```
auth.users        (managed by Supabase: email, hashed password)
profiles          id (= auth.users.id), handle, display_name, avatar_url, bio, spine_colour, is_public, created_at
links             id, user_a, user_b, status(pending|active|blocked), a_pins_b, b_pins_a, created_at
guests            id, owner_id, name, colour, claimed_by_user_id?
titles            tmdb_id, media_type(movie|tv), title, year, poster_path, runtime, genres[], cached_at
seasons           title_tmdb_id, season_number, name, episode_count, poster_path
cases             id, owner_id, tmdb_id, media_type, season_number?, created_at   -- one per user per movie or per season
watches           id, case_id, kind(first|rewatch), watched_on, where, snacks[], mood[], note, rating, is_solo
watch_people      id, watch_id, user_id?, guest_id?
secret_ratings    id, watch_id, author_id, rating, note, submitted_at, revealed_at
tonight_items     id, link_id|owner_id, tmdb_id, media_type, season_number?, added_by, vetoed_by?, progress_season?, progress_episode?
notifications     id, user_id, type, payload, read_at
```
- **Row-level security:** a watch is readable only by the case owner and people tagged on it who have an active link.
- Rewatch number is derived (count of earlier watches on the case), not user-typed.

### 10.3 Non-functional requirements
| Area | Target |
|---|---|
| Performance | LCP < 2.5 s on mid-range phone over 4G; shelf interactive < 3 s |
| Availability | 99.5% |
| Scale assumption | 10k users, 2M watches in year 1 |
| Security | OWASP Top 10, RLS everywhere, rate limits on login, search, invites |
| Privacy | Data export, deletion, minimal collection; EU region database [DEFAULT] |
| Browsers | Last 2 versions of Chrome, Safari, Firefox, Edge; iOS 16+ |

### 10.4 Third-party obligations
- **TMDB:** required attribution ("This product uses the TMDB API but is not endorsed or certified by TMDB") with logo. TMDB's free API is for non-commercial use; **if the product is ever monetised, a commercial licence is needed first.** This only matters once §11 is activated.

## 11. Business model — reference only, NOT in the first build
Kept for planning, deliberately not implemented now.
- Free core; no ads, ever.
- Possible later optional paid tier: Year in Review share cards, custom case themes, printable shelf poster, extra pinned partners.
- Revenue is not a goal of v1; v1 validates the ritual.
- Before any monetisation: resolve TMDB commercial licensing (§10.4).

## 12. Success metrics
| Metric | Target (90 days after launch) |
|---|---|
| New users who link a person in week 1 | ≥ 40% |
| Watches logged with another person | ≥ 60% |
| Secret ratings completed by both | ≥ 70% of requested |
| Median time to log a Watch | < 25 s |
| Week-4 retention of linked pairs | ≥ 35% |
| Letterboxd import usage | ≥ 15% of sign-ups |

## 13. Rollout plan
| Phase | Content | Exit criteria |
|---|---|---|
| 0 – Design | Type + colour testing, **case prototype** (film + season), desktop and mobile layouts, copy | Owner signs off the case prototype |
| 1 – Foundations | Supabase project, auth (email + password), profiles, TMDB search (movies + TV) | Can sign up, sign in, search |
| 2 – Core loop | Log a Watch, **Rewatch logic**, shelf + case UI | Can log, rewatch, and view shelf |
| 3 – Us | Linking, shared shelf, secret ratings | Two testers complete a full reveal |
| 4 – Tonight | Shared list, help us pick, show progress | A pair can choose a title |
| 5 – Polish | Letterboxd import, stats, a11y pass, desktop pass, PWA | Audit passes |
| 6 – Private beta | 20–50 pairs | Baseline metrics |
| 7 – Public launch | | |

## 14. Risks and mitigations
| Risk | Impact | Mitigation |
|---|---|---|
| Value needs two people (cold start) | High | Guests give day-one value; invite link is one tap |
| 3D case jank on low-end phones | Med | CSS transforms, virtualisation, simple-mode fallback |
| Result looks like generic AI/template UI | High | §8.1 avoid-list in design review; real textures; owner approves the prototype before anything else is built |
| Desktop feels like a stretched phone app | Med | §8.9 layout table; desktop reviewed at each phase |
| TV adds data complexity | Med | Season = case; episodes only as optional progress |
| Password security | Med | Supabase-managed hashing, verification, rate limits, breached-password check |
| TMDB licensing if monetised | Med | Decide before §11 is activated |
| Falling-outs between linked people | Med | Unlinking keeps each person's memories; block and hide |
| Scope creep toward "social" | Med | Principle 2 and §5.3 are hard guardrails |

## 15. Open questions (only what's left)
1. **Social sign-in:** add "Continue with Google / Apple" later as a convenience, or never? *Default: not in first build; email + password only.*
2. **TV logging granularity:** season-as-case with optional episode progress is the default. Do you want to be able to log individual episodes as their own watches? *Default: no.*
3. **Display font:** final pick (§8.3) happens in the case prototype. *Default: decide then.*
4. **Hosting region** for the database (EU vs US). *Default: EU.*

## 16. Definition of done for v1
- All items in §5.1 shipped and passing QA on mobile and desktop.
- AA accessibility audit passed.
- A real pair can: sign up → link → pick something in Tonight → log it → exchange secret ratings → see the case on their Us shelf, in under five minutes, without help.
- Every screen passes the §8.1 "avoid" checklist.
