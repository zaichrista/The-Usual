# The Usual — Product Design Requirements (PDR)

**Version:** 0.7 · **Date:** 2026-11-05 · **Owner:** Zai
**Build status:** Front-end prototype built (`index.html`, mock data, no backend). Supabase, TMDB and real auth are not started.

> Status key: **[LOCKED]** = decided, build to it. **[DEFAULT]** = recommended, assumed unless overruled. **[LATER]** = explicitly not in the first build.

### Changelog v0.7 (from v0.6): the room is the app
- **A diary for two.** Your partner is **Tim** (all examples updated). Copy never assumes their pronouns.
- **Home is one full-screen room** in a single flat, warm illustrated style (no dashboard beneath it). Four things to touch: the **lamp** (start/end a film), the **TV** (what to watch, opens the picker as a sheet and mirrors the current pick on its screen), the **shelf** (playable miniature, opens the full shelf), and the **diary** on the coffee table.
- **New Diary page** (`/diary`): your nights, newest first, grouped by month. Each entry has the poster, date, who with, where, what you ate, your note, and both ratings. It also holds the highlights (first one, most rewatched, biggest disagreement, usual order, longest sit) and the waiting Sealed Take.
- **Shelf is quiet and poster-led**: posters by default (Spines is one toggle away), one filter row, Ours / Mine / All. The sort and layout controls moved off the page.
- **Nav is Room · Shelf · Diary, plus (+)**; Me is the avatar.
- The picker and the Sealed Take open as **sheets** from the room. "How this works" starts collapsed.
- Round windows on the wall, taken from the reference photos, use the iridescent blue and mauve.

### Changelog v0.6 (from v0.5): the product loop
- **The app now follows one loop: Decide, Watch, React, Remember.** Three places instead of four: **Home** (the room), **Shelf**, **Me** (avatar menu). Together and Tonight are folded into Home and the Shelf.
- **The lamp starts and ends a watch.** Lights down = the film starts (a timer runs). Lights up = "How was it?" opens the log sheet with the rating, which is also your Sealed Take.
- **One shelf (trial).** Films you want to see sit on the shelf *in shrink-wrap*; logging a watch unwraps them. This replaces the separate lists-and-diary pair. **A switch ("One shelf" / "Shelf + lists") lets you go back** until we lock the choice (§6.15).
- **Notifications are out of v1** (§6.12).
- Three jobs the app must do well: **make lists, log what you watched, decide what to watch.**

### Changelog v0.5 (from v0.4)
- **Together hero is playful but quiet**: a big arc lamp arches over the sofa (click it to dim the lights for "movie mode"), a throw on the sofa arm, a popcorn bowl on a small table, and the two of you who say a dry line when clicked.
- **The miniature shelf is a toy, not a link**: drag spines to rearrange (the order is saved), hover for the title and rating, click to open the real case, **Shuffle**, and **Pull one out** to surface a random shared film. "Open the full shelf" sits beside them.
- **"How Tonight works" is collapsible** with an explicit chevron button; it starts open for new users and remembers when you close it.
- **Phones:** the hero stacks (sofa and lamp above, shelf below) so the lamp has room and the shelf is big enough to drag.

### Changelog v0.4 (from v0.3)
- **Couples only.** The product is for two people. Solo, Duo and Long-Distance personas are removed (§3, §4.1). People you watch with who are not your partner are **Guest companions**.
- **Tonight rebuilt around two lists**: **Our list** (shared) and **My list** (private to you). The picker shows the film's blurb, explains each mode, and has separate actions for *Watch this tonight*, *Add to Our list* and *Save to My list* (§6.7).
- **Together hero redesigned**: a quiet sofa with no pattern, and **our shelf in miniature** beside it. Click it to open the full Shared Shelf at `/together/shelf` (§6.6).
- **Shelf layout fix**: the cabinet now lays itself out from the space it actually has, so it holds together when the case panel is open (§8.9).

### Changelog v0.3 (from v0.2)
- **Vocabulary restored** to the original set: Companion, Shared Shelf, The Usual, The Order, Sealed Take, Boxset, Rotation (§4). The tab is **Together** again.
- **Personas are product terms**: onboarding asks "How do you watch?" with Solo, The Couple, The Duo, Long-Distance Pair (§4.1, §6.1).
- **One typeface**: a single grotesk in different weights. No serif, no script, no condensed (§8.3).
- **Welcome screen**: the TV sits centre stage with the room (a wall of shelves, a lamp) behind it (§6.1).
- **Eyebrow headers removed** from screens; labels only where a form needs them (§8.1).
- **Shelves tightened**: consistent row height, objects stand on boards, spine text fits (§8.4).
- **Site map and architecture added** (§7).

### Changelog v0.2 (from v0.1)
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

## 3. Audience [LOCKED, narrowed in v0.4]

**Couples.** Two people who watch films together, most commonly partners, who want a shared record of those nights and an easier way to choose the next one.

| Who | Need |
|---|---|
| **The couple** (the only account type) | A shared shelf of what they have watched together; a private shelf each; a shared list and a fair way to pick the next film |
| **The person with a guest** | Occasionally watching with family or friends. These are **Guest companions**: a name on a case, no account, no shelf |

Out of scope for v1: solo-first accounts, groups of three or more, long-distance features such as synchronised play. Nothing in the data model prevents adding them later.

## 4. Vocabulary [LOCKED, restored in v0.3]

The original vocabulary is back. To keep it friendly, each term is explained once in context (first use, plus a tooltip), and every term is a normal English word.

| Term | Meaning |
|---|---|
| **Case** | One film, or one season of a show, shown as a DVD case. The atomic unit. |
| **Shelf** | Your collection of cases. |
| **Watch** | One viewing. |
| **Rewatch** | A repeat viewing of something already on your shelf. Always labelled, never silent. |
| **Companion** | The person you watched with. A registered user (own account, own shelf) or a Guest. |
| **Guest companion** | A person with no account yet: a name on your cases. |
| **Together** | The area of the app for your Companions and what you share with each. |
| **Shared Shelf** | The merged shelf of two linked users: everything watched together. |
| **The Usual** | A pair's designated ritual, with its own name ("Sunday nights") and its own Shared Shelf and stats. |
| **Your Usual** | The one Companion you pin as your main watch partner. |
| **Tonight** | The shared "to watch" list and the picker. |
| **The Order** | What you ate and drank during the watch. |
| **Sealed Take** | Each person rates privately; the ratings are revealed together. |
| **Boxset** | A hand-made group of films ([LATER]). |
| **Rotation** | The year in review, e.g. "Your Rotation, 2026" ([LATER] as a shareable card; the stats view exists in v1). |
| **Mood match / Roulette / Both said yes** | The three ways Tonight picks a title. |

### 4.1 Couples only
There is no "How do you watch?" step. An account has **at most one linked partner** (**Your Usual**). Anyone else you watch with is a Guest companion. Onboarding invites your partner (skippable); until they accept, Together shows an invite state and the app works as a private diary.

| Added in v0.4 | Meaning |
|---|---|
| **Our list** | The shared to-watch list. Either of you can add or remove. |
| **My list** | Your private to-watch list. Your partner keeps their own. Titles on both My lists count as "Both said yes". |

## 5. Scope

### 5.1 First build (MVP) — must ship [LOCKED]
- Accounts (email + password), profile, linking with another person
- Search and metadata for **movies and TV** (TMDB)
- **Log a Watch** incl. **Rewatch** handling, with person, date, rating, note, snacks, setting, mood
- **DVD-case shelf** UI (shelf view, grid view, flip-open case)
- **Together** space: shared shelf between two linked accounts
- **Sealed Take** and reveal
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

**Welcome screen:** a wood-cased TV centred in the viewport, with the room behind it (a wall of shelves full of spines, an arc lamp). The tagline and sign-in are on the TV screen itself, so the first thing a visitor sees is the product, not a form below a hero.

**Onboarding (3 short steps, on the TV):**
1. Display name, `@handle`, email, password
2. Pick a spine colour (from the palette)
3. **Invite your partner** by link or email, or skip

**Profile:** display name, handle, avatar, short bio, privacy setting.
**Account deletion and full data export (JSON/CSV)** in Settings. [LOCKED]

### 6.2 Linking with your partner [LOCKED]

**v0.4:** an account links to **one** partner. The text below about "people" applies to that one link plus Guest companions.

- **Everyone who links has their own account, their own shelf, their own ratings.** Linking creates a mutual connection and unlocks the shared **Together** space; it never merges accounts.
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
6. **The Order** (free text chips with suggestions from your past snacks)
7. **Where** (Couch · Cinema · Outdoors · Video call · Bed · Other)
8. **Mood** (up to 3: cosy, tense, laughed, cried, fell asleep, rewatch-worthy, never again)

On Save, the case slides onto the shelf.

**Rewatch rules [LOCKED, per owner]:**
- If the title (or season) is already on your shelf, the app asks once: **"You've watched this before. Log as a Rewatch?"** Default answer: Rewatch. The only alternative offered is "Log as new date for the first watch" (correcting a mistake); it is never the default.
- A Rewatch is stored as its own Watch (`kind = rewatch`), never overwriting the original.
- The case shows a clear **"Rewatch ×N"** badge. The case's flip side shows a timeline of every watch: "First watch · 12 Mar 2025 · with Tim", "Rewatch · 3 Nov 2026 · with Jess".
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

### 6.5 Sealed Take [LOCKED]
- After a watch with a linked person, each of you gets a private prompt: rating + one-line take.
- Neither sees the other's until **both submit**, or 48 hours pass, or either taps "Reveal now".
- Reveal moment: the two takes appear side by side on the case back. Copy is warm and a little wry ("You were half a star apart"), never judgemental.
- Optional, skippable, off-switchable in Settings.

### 6.6 Together and the Shared Shelf [LOCKED]
- **Hero:** a calm room with one big arc lamp over the sofa, the two of you on it, a throw on the arm and a popcorn bowl on a small table. **Our shelf in miniature** stands beside the sofa and is interactive:
  - **Drag** a spine to rearrange; the order is saved.
  - **Hover** a spine for its title and rating; **click** it to open the real case.
  - **Shuffle** hops the spines into a new order. **Pull one out** slides a random shared film forward.
  - Click the **lamp** to dim the lights (the room goes dark and the two of you get a faint screen glow). Click either person for a dry line.
  - "Open the full shelf" goes to the Shared Shelf page.
  - All motion respects reduced-motion.
- **Shared Shelf page** (`/together/shelf`): the full cabinet (or grid) of every case you have watched together, with Films / Shows / Rewatches filters. Opening a case shows both ratings.
- Header: "You & Tim", titles, hours, "since March 2025", and **The Usual** ritual name ("Sunday nights", renamable).
- **Sealed Take** card appears here when your partner has sealed theirs and you have not.
- Highlights as ticket stubs: first one, most rewatched, biggest disagreement, usual order, longest sit.
- Either person can add a case to the Shared Shelf; the other receives it and, if relevant, a Sealed Take prompt.

### 6.7 Home: deciding, watching, reacting [LOCKED, rebuilt in v0.6]

Home is a state machine with four moments. The room (sofa, two of you, big arc lamp, our shelf in miniature) is always there; a panel below it changes.

1. **Deciding** (default). Headline: "What are we watching?" (or "It's Sunday night." when today matches your Usual's ritual). Below the room:
   - **How this works**: a collapsible three-step explainer (remembers when closed).
   - **Pick for us**: *Both said yes* (on both of your private lists, or both added to the shared one), *Roulette* (random from the shared list), *Mood match* (mood + length, searches both lists plus suggestions). Each mode is explained in a sentence. The result shows the **blurb** and why it was picked.
   - Result actions: **Watch tonight** (sets the pick), **Add to / Save to** a list, **Veto** (once each per round), **Another**.
   - **Up next**: the wrapped cases, with tabs **Ours** (shared) and **Mine** (private; titles your partner also wants are marked). Click a case to watch it, move it or remove it. **Add to Ours/Mine** opens search.
   - **Currently watching together**: an "up to S1 E4" marker for shows.
2. **Tonight's pick is set** ("Lights down when you're ready."). The lamp pulses. **Lights down** or click the lamp.
3. **Now showing**. Lights down, the room dims, a timer runs. Nothing else competes for attention. **Lights up** or click the lamp when it is over. *Not this one* cancels.
4. **That's a wrap** ("How was it?"). The log sheet opens with the title filled in, your partner pre-selected and the watch time shown. Saving unwraps the case, applies the Rewatch rule, and creates your **Sealed Take**. Your partner's (simulated in the prototype) appears on Home as a card to break the seal.

**The lamp with nothing chosen** opens a quick "What are you watching?" chooser: Up next first, then watch-again, then something new.

**Lists** are not a separate screen: "making a list" means adding titles to **Ours** or **Mine**; they appear wrapped on the shelf (§6.15).

### 6.8 Title page [LOCKED]
- Poster, backdrop, synopsis, cast and crew, runtime, genres (TMDB).
- **Your history:** your watches and Rewatches, who with, your notes.
- **Together history:** when you've watched it with a linked person.
- Actions: **Log a Watch**, **Add to Tonight**.
- No public reviews. A linked person's rating is visible only through Us/Sealed Take reveal.

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

### 6.12 Notifications [LATER, out of v1]
No push, email nudges or in-app alerts in the first build. The only prompts are visible on Home itself (a waiting Sealed Take, tonight's pick). Candidate later notifications, kept for planning: invite received, Sealed Take ready, a Sunday-afternoon "tonight's pick?" for your Usual, and "a year ago tonight".

### 6.13 Privacy and safety [LOCKED]
- Private by default; sharing is an explicit action per person.
- Block and report. Minimum age 13. Terms and privacy policy reviewed before public launch.
- Guest names visible only to their creator.

### 6.15 One shelf: wrapped and unwrapped cases [TRIAL, switchable]
One object model: a **case** is either **wrapped** (you want to see it) or **unwrapped** (you have watched it).

- A wrapped case looks like a case in shrink-wrap: a glossy film over the cover, a "New" sticker, a "New" mark on the spine.
- Wrapped cases belong to **Ours** (shared) or **Mine** (private) and sort to the front of the shelf.
- Logging a watch of a wrapped case **unwraps** it (it lands on the shelf with the usual animation) and removes it from the list.
- Shelf scope: **All / Ours / Mine**. Status filters: *To watch*, *Watched*, *Rewatches*, *Films*, *Shows*.
- **Switch back:** *Me → Shelf layout*, or the Layout control on the Shelf, toggles **One shelf** and **Shelf + lists**. In "Shelf + lists" the shelf shows only what you have watched, and Our list / My list appear as ordinary lists on Home and beneath the shelf. The two layouts share the same data, so switching loses nothing.
- **Decision gate:** keep whichever feels better after real use, then delete the other path.

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

## 7. Information architecture, site map and architecture

### 7.1 Navigation [LOCKED in v0.7]
Four places and one button: **Room**, **Shelf**, **Diary**, **Me** (avatar), and **(+)**.

- **Room (Home)**: the whole app in one scene. The lamp starts and ends a film; the TV opens the picker; the shelf opens the full shelf; the diary opens the diary.
- **Diary**: your nights together, newest first, with both ratings.
- **Home (older description)**: the room. It changes with the moment: *deciding*, *tonight's pick is set*, *now showing*, *that's a wrap*.
- **Shelf**: everything you have watched and everything you want to watch, in one cabinet. Switch between **All / Ours / Mine**.
- **Me** (avatar, top right): Rotation stats, settings, import, export.
- **(+)**: log something you already watched. (During a film, the lamp does this for you.)
- **Search** (top bar, `/`): your shelf, what is in the wrapper, and titles you have not met yet.

Mobile: bottom bar `Home · (+) · Shelf`. Desktop: left rail with the same three, and the open case docks on the right.

### 7.2 Site map

```
SIGNED OUT
/                       Welcome: the TV, centre stage
 ├─ sign in · forgot password
 └─ create account (on the TV, 3 steps): details → spine colour → invite your partner

SIGNED IN
/home                   The room: lamp, sofa, our shelf in miniature, then the moment's panel
 ├─ deciding            Pick for us (Both said yes / Roulette / Mood match) · Up next (Ours | Mine)
 ├─ tonight's pick set  "Lights down when you're ready"
 ├─ now showing         timer · "Lights up"
 └─ that's a wrap       "How was it?" → log sheet (rating = Sealed Take)
/diary                  Our diary: entries by month · highlights · Sealed Take waiting
/shelf                  One shelf (posters by default; Spines view): watched + wrapped · scope All/Ours/Mine · filters · cabinet/grid
 └─ case dock           front · open · back · disc · history · actions (Watch tonight, I've watched it, move, remove)
/me                     Rotation · settings (incl. shelf layout) · import · export · sign out

GLOBAL
(+) Log a watch (sheet, with the Rewatch prompt)
/   Search overlay (modes: open, add to a list, "what are you watching?")

ALIASES (old links keep working)
/tonight, /together, /us → /home        /together/shelf → /shelf (Ours)

LATER
Streaming availability · Rotation share card · Boxsets · opt-in public profile · notifications
```

### 7.3 Application architecture [DEFAULT]

```
 Browser (mobile web / desktop web / installed PWA)
   Next.js App Router, TypeScript, Tailwind tokens from §8.2
   ├─ Server components: title pages, shelf shell (fast first paint)
   ├─ Client components: case 3D, Log sheet, Tonight picker, Sealed Take reveal
   └─ Service worker: offline shell, push notifications
        │                              │
        ▼                              ▼
 Next.js route handlers / server actions        TMDB API (search, titles, seasons)
   ├─ validate input (zod)                       └─ cached in `titles` / `seasons`;
   ├─ call TMDB, cache results                      images hotlinked from TMDB CDN
   ├─ enforce rules the database cannot
   │    (Rewatch decision, Sealed Take reveal timing)
   └─ send email via Resend
        │
        ▼
 Supabase
   ├─ Auth (email + password; verification; reset)
   ├─ Postgres  ← source of truth, with row-level security on every table
   ├─ Realtime  ← Sealed Take "both submitted" and Tonight list updates
   └─ Storage   ← avatars only
```

**Key decisions**
1. **Postgres is the source of truth; RLS is the privacy model.** A Watch is readable only by the case owner and Companions tagged on it with an active link. The client can never be trusted to filter.
2. **A Case is per user.** Two people who watch together each own a Case and a Watch; they are linked by `watch_people`. That is why unlinking never deletes anyone's memories, and why the Shared Shelf is a *query*, not a copy.
3. **Rewatch is a server rule**, derived from existing Watches on the Case, never typed by the user.
4. **Sealed Take** values stay hidden until both rows exist (or 48 h pass). The reveal is computed server-side; the client only receives the partner's value after the condition is met.
5. **TMDB is cached, not mirrored.** Store the fields we show; refresh on a schedule; respect attribution and licensing (§10.4).
6. **Realtime only where it earns its keep:** Sealed Take reveals, Tonight list edits, invite acceptance.
7. **Covers:** posters from TMDB; a generated cover (palette plus title type) when one is missing. The 3D case is CSS transforms, no WebGL.

### 7.4 Prototype architecture (what exists today)
One `index.html`: CSS tokens and components, an in-memory store persisted to `localStorage`, string-template views, hash routing, and event delegation. Mock data stands in for Supabase and TMDB. Each function (cover, spine, case, shelf layout, log sheet, Sealed Take, picker) maps to a production component, so the prototype is the design reference, not throwaway.

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
- Iridescence is a **material**, not a background: only on disc surfaces, a foil edge on a case, and the Sealed Take reveal. It never fills a page or a button.

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

### 8.3 Typography [LOCKED in v0.3]
**One grotesk, many weights. No serif, no script, no condensed.**
- Family: **Schibsted Grotesk** (variable, weights 400–900, with italic). It is one CSS variable, so it can be swapped in one line if we find a better match.
- Titles and display: 700–800, tight tracking (about −0.03em).
- Body: 400–500.
- Labels, tabs, buttons: 600, small, uppercase, moderate tracking.
- Spines: 700 uppercase, sized to fit the spine (long titles get taller spines instead of tiny text).
- Handwritten notes: the same family in italic 500, never a script face.
- Rating and numbers: 700.

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
- Signature moments: case slides onto shelf, case opens, disc spin (Surprise us), seal-break on Sealed Take reveal.
- Optional soft sounds (case click, disc whir), off by default.

### 8.6 Layout fundamentals
4/8 px grid, 16 px mobile gutters, max content width 1280 px on large desktop. See §8.9 for breakpoints.

### 8.7 Empty states
In voice and drawn from the world: an empty shelf with one lamp: "Nothing here yet. What was the last one?"

### 8.8 Voice and tone [LOCKED]
Warm, brief, a little wry; never saccharine. Examples: "Pick tonight's." · "You two disagreed on this one." · "Same again?" · "Rewatch ×3. Good taste, or a bad habit."

### 8.9 Mobile-first AND desktop [LOCKED]

**Container-aware layout (v0.4):** the shelf cabinet lays itself out from the width it actually has, not from the screen width. Wide: open doors left and right of the main cabinet, slightly angled. Medium (for example, beside an open case panel): one full-width cabinet with Shows and Lately side by side beneath it. Narrow: everything stacked.


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
links             id, user_a, user_b, status(pending|active|blocked), a_pins_b, b_pins_a, ritual_name ("Sunday nights"), created_at
guests            id, owner_id, name, colour, claimed_by_user_id?
titles            tmdb_id, media_type(movie|tv), title, year, poster_path, runtime, genres[], cached_at
seasons           title_tmdb_id, season_number, name, episode_count, poster_path
cases             id, owner_id, tmdb_id, media_type, season_number?, created_at   -- one per user per movie or per season
watches           id, case_id, kind(first|rewatch), watched_on, where, snacks[], mood[], note, rating, is_solo
watch_people      id, watch_id, user_id?, guest_id?
secret_ratings    id, watch_id, author_id, rating, note, submitted_at, revealed_at
watchlist_items   id, list(ours|mine), owner_id, link_id? (ours only), tmdb_id, media_type, season_number?, added_by, created_at
tonight_state     link_id, picked_tmdb_id?, vetoes_used, progress_season?, progress_episode?
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
| Sealed Take completed by both | ≥ 70% of requested |
| Median time to log a Watch | < 25 s |
| Week-4 retention of linked pairs | ≥ 35% |
| Letterboxd import usage | ≥ 15% of sign-ups |

## 13. Rollout plan
| Phase | Content | Exit criteria |
|---|---|---|
| 0 – Design | Type + colour testing, **case prototype** (film + season), desktop and mobile layouts, copy | Owner signs off the case prototype |
| 1 – Foundations | Supabase project, auth (email + password), profiles, TMDB search (movies + TV) | Can sign up, sign in, search |
| 2 – Core loop | Log a Watch, **Rewatch logic**, shelf + case UI | Can log, rewatch, and view shelf |
| 3 – Us | Linking, shared shelf, Sealed Takes | Two testers complete a full reveal |
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
- A real pair can: sign up → link → pick something in Tonight → log it → exchange Sealed Takes → see the case on their Us shelf, in under five minutes, without help.
- Every screen passes the §8.1 "avoid" checklist.
