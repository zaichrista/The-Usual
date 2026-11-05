# The Usual — Product Design Requirements

**Version:** 1.0 · **Date:** 2026-11-05 · **Owner:** Zai
**Build status:** Front-end prototype (`index.html`, one file, no backend). Data lives in the browser. Supabase, TMDB and real accounts are not started.
**Previous direction:** v0.7 ("the room") is archived in `archive/v0.7-the-room/`. It is not being developed.

> **[LOCKED]** decided, build to it · **[DEFAULT]** recommended, assumed unless overruled · **[LATER]** not in the first build

---

## What changed in v1.2 (TMDB)

- **Live search** across all of TMDB (films and series; people are filtered out). Your own shelf matches appear first, so "log another evening" is one tap. Falls back to the starter catalogue if there is no key or TMDB can't be reached, and says so.
- **Real metadata on pick:** poster, director (or creator), runtime, genres, synopsis. **Series ask which season**; each season is its own case with that season's poster and year. Picking a season you already keep logs a rewatch instead of making a duplicate.
- **Settings → TMDB key** (v3 key or v4 read token), with *Save and test*. **Find posters for my shelf** fetches art for everything already shelved (season posters for series).
- A cover that fails to load falls back to the typographic one. Spines stay typographic.
- TMDB attribution is in the footer, as their terms require.
- **Key handling:** by default each person pastes their own key (stays in their browser). `TMDB_BAKED` at the top of the script ships one key to every visitor. A key in a public page is visible to anyone who views source, so it's only suitable for a private deployment.

## What changed in v1.1 (more intimate, more playful)

- **Type:** *Fraunces* (soft, warm serif, light weights) with *DM Sans* for small controls. Replaces Instrument Serif and Schibsted Grotesk.
- **Fewer labels.** Eyebrow headers are gone from every page, sheet and panel. "Arranged by" and "Find" are screen-reader labels only. The date line in the masthead is gone; the library name is a quiet italic beside the wordmark. Only the *Waiting in the wrapper* shelf keeps a label.
- **Day/night is a sun-and-moon switch** in the masthead (a proper `switch` for assistive tech). The settings sheet no longer repeats it.
- **The case is back, in 3D.** On any title: drag (or use arrow keys) to turn it, click the cover or *Open the case* to swing it open, *Turn it over* for the back cover. Opened, the left side is a paper insert carrying your latest note and who you watched with; the right is the tray with a disc you can spin (tap it). The back cover has the synopsis, credits and a barcode.
- **Playful, still minimal:** the headline's numbers are links (tap *and seven still in the wrapper* to filter, tap again to undo); neighbouring spines part when you hover or pull one; **drag a spine to re-order the shelf** (in "the order I added them"); *Pull one out at random*.
- **Real art is plumbed in.** Any item with a `poster` URL shows that image on the case front, cover and index; spines stay typographic. Nothing fetches posters yet (see open question 2).

## What changed in v1.0

The product is reset around one idea: **a library you build, slowly, by hand.** The shelf is the product. Everything else exists to put something on it, or to remember what it meant.

| Was (v0.7) | Is (v1.0) |
|---|---|
| A cosy illustrated room: lamp, TV, sofa, coffee table | A printed-matter feel: serif headlines, hairline rules, plain type, a real bookcase |
| Home was the room; the shelf was one of four objects in it | **The shelf is home.** It is in the first screen on every device |
| Spines and cases in varied heights, props, lean | **Every spine is exactly the same height.** Only the width varies |
| Decide / Watch / React / Remember loop, picker, roulette, lamp timer | Add, shelve, remember. No picker, no timer |
| Sealed Take, shared accounts, partner linking, stats page | Cut for now (see "Parked") |

## 1. Vision [LOCKED]

**The Usual** is a private library of the films and series you keep, shelved by hand. It is intimate rather than social: one shelf, kept by one person or a pair, built over years. Each spine is a night you can remember.

**Tagline (working):** "Movies are better with someone."

**Name logic:** "the usual" is what you order without asking, the regular night, the person you always watch with.

## 2. Principles [LOCKED]

1. **The shelf is the focus.** If a screen doesn't help you add to, look at, or remember the shelf, it doesn't belong.
2. **One height.** Every case is the same height, always. Variety comes from thickness, colour and what's written on it.
3. **Editorial, not dashboard.** Type does the work: a serif for voices and titles, a quiet grotesk for labels. Hairline rules. No cards, no badges, no gradients for their own sake.
4. **Built, not generated.** You choose the spine colour. You add a title by hand if the catalogue doesn't know it. New titles go on the end, like real life.
5. **Memory over metrics.** A line you wrote outweighs a number. The few figures that exist sit under the shelf, not above it.
6. **Private by default.** No followers, no public ratings, no trending. Nothing leaves the device in the prototype.
7. **Nothing shouts.** Calm motion. No streaks, no nudges.

## 3. The shelf [LOCKED]

- **Same height.** All spines render at one fixed height (190 design units, scaled with the viewport). A test asserts a single distinct height across the shelf.
- **Width by format.** A film is slim; a **season of a series is a thicker boxset** and shows its season number (S2) in a band at the top. Width varies slightly by title so the row has rhythm.
- **Order added.** The default arrangement is the order you added things, oldest on the left. New spines land at the end of the shelf with a short drop animation. Other arrangements: title A–Z, year released, last watched, colour.
- **Two groups, shown as labelled shelves.** *On the shelf* (watched) and *Waiting in the wrapper* (saved for later). Waiting spines have a cellophane sheen. Groups never share a row.
- **Rows pack to the width.** The bookcase always shows at least four shelves, so it reads as furniture with room to grow.
- **Spine anatomy (top to bottom):** colour band (film) or band with season (series) · title set vertically in the serif · year stacked in two lines · a dot for who you watched it with first. A small pip marks anything watched more than once.
- **You choose the colour.** Eight spine colours, taken from the owner palette. The cover follows the spine.
- **Hover or focus** lifts the spine and shows a paper tag with title, year and rating. Arrow keys move around the shelf. Find (`/`) dims everything that doesn't match, and searches titles, directors, names, snacks and **the notes you wrote**.
- **No reflow.** Opening a title never changes how the shelf is laid out. The pulled spine stays raised while its page is open.

## 4. Screens

### 4.1 Shelf (home) [LOCKED]
Two columns on desktop. **Left, sticky:** a one-sentence headline ("Twenty-eight titles on the shelf, and seven still in the wrapper."), who keeps it and since when, the filters (All / Films / Series / Waiting), arrangement and Find. **Right:** the bookcase. Below: four figures (on the shelf, evenings, hours together, returns) and three pull-quotes from your own notes ("From the margins"). On tablet and phone the columns stack and the shelf follows the headline.

### 4.2 A title ("pulling one out") [LOCKED]
Click a spine and its page replaces the left column; the shelf stays put. On phones it is a full-screen sheet. Contents: tilted cover, kind and year, title, byline, one-line synopsis, **Your copy** (evenings, latest rating, hours; a ledger of every watch with date, who with, rating, your line, what was on the table), **Log another watch**, the spine colour picker, and "Take it off the shelf". Waiting titles show why they're waiting and one action: **We watched it**. Previous/next walk the shelf in its current order.

**Rewatches are explicit.** The first evening is labelled "First watch" and every later one "Rewatch". Each keeps its own rating and note. A title can be returned to as many times as you like.

### 4.3 Add to the library [LOCKED]
One sheet, two steps. **Find:** type a title (starter catalogue for now), or **add it by hand** (title, year, film/series, season). **Shelve:** *We've watched it* (when, who was there, half-star rating, a line to remember it by, what was on the table) or *Saving it for later* (and why). Then choose the spine, with a live preview. Everything but the title is optional. Logging a title that's already on the shelf goes straight to "another evening".

### 4.4 Index [LOCKED]
The same library as a sortable table in plain type: title, year, format, last watched, with, rating. For when you want to read the shelf instead of look at it. Filters and Find work the same way. A row opens the same title page (as an overlay).

### 4.5 Settings [LOCKED]
Names (yours, and who you watch with), Daylight / Evening theme, **Take a copy** (JSON export), restore the example library, start with an empty shelf. The empty shelf says: "Nothing here yet. Start with the first one you ever loved."

## 5. Data model [DEFAULT]

```
Item   id, title, year, type (film | series), season?, episodes?, minutes, director,
       genres[], synopsis, short? (spine title), colour (0–7), status (seen | waiting),
       added (date), note? (why it is waiting), watches[]
Watch  date, who[] (people keys; empty = just you), rating (0.5–5 | null), note, ate
Person key → { name, colour }   (e.g. a partner, or a guest like "Mum")
```
A season is its own Item, like a DVD season set. Rewatches are additional Watches, never overwrites. Removing the last Watch returns an Item to Waiting.

## 6. Visual language [LOCKED]

- **Palette:** the owner's nine colours only (espresso, cream, champagne, copper, walnut, oxblood, gold, mauve, blue). Every other tone is a mix of these.
- **Type:** *Instrument Serif* (headlines, titles, spines, notes; italic for voice) and *Schibsted Grotesk* (labels, controls, body). Small caps labels at 10–11px with wide tracking.
- **Themes:** Daylight (warm paper) and Evening (espresso). The bookcase interior is dark in both, so colour reads the same.
- **Covers:** typographic and generated (one of five simple devices, in the spine's colours) until real posters arrive.
- **Motion:** spine lift, spine drop on add, panel slide. All collapse under `prefers-reduced-motion`.
- **Accessibility:** every spine is a labelled button; arrow-key navigation along and between shelves; visible focus; sheets close with Esc; ratings are a keyboard slider.

## 7. Parked from v0.7 (not deleted, not in v1.0)

Sealed Take (private ratings revealed together), partner accounts and linking, "pick for us" (both said yes, roulette, mood match), lamp/TV session timer, the illustrated room, per-person shelves ("Ours / Mine"), the stats page, Letterboxd CSV import, PWA install. These can return as additions *to the shelf*, not as new places.

## 8. Open questions

1. **One library or two?** v1.0 assumes a single shared library with a "who was there" tag per evening. If a couple wants separate private shelves plus a shared one, the model needs a person per Item.
2. **Posters.** Typographic covers are the aesthetic, but real posters (TMDB) may be wanted for recognition. A toggle is possible; the spine stays typographic either way.
3. **Where it lives.** Browser-only is fine for a prototype, but a library is something you keep for years. Accounts and sync (Supabase) are the next real decision.
4. **Catalogue and search.** The starter catalogue holds about 40 titles. TMDB search is the obvious replacement; it needs an API key and attribution.
5. **Seasons.** Should logging a series offer to add every season you've seen at once?

## 9. Build notes

Single file, no dependencies beyond two Google Fonts. State persists in `localStorage` (`the-usual-v4`; theme in `the-usual-theme`). Tested in headless Chrome at 1440, 900 and 390 widths: same-height spines, no reflow on open, add / manual add / rewatch / find / reload persistence, empty state, index, no horizontal scroll on phones, no console errors.
