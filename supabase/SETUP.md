# Supabase setup for The Usual

This backend keeps the existing library shape (`items`, `people`, and library display names) as one shared JSON document. Membership is stored separately and protected by row level security. A signed-in user can belong to one library. Invite codes expire after seven days.

## Create the Supabase project

1. Create a project at [supabase.com/dashboard](https://supabase.com/dashboard).
2. In **Project Settings → API**, copy the **Project URL** and the **publishable key** (or legacy `anon` key). The website must never use the `service_role` key.
3. In **SQL Editor**, open `schema.sql` from this folder, paste it, and run it once.
4. In **Authentication → URL Configuration**, add the website's final HTTPS origin to **Site URL** and **Redirect URLs**. For local development, add the local origin too.
5. In **Authentication → Providers**, leave Email enabled. Choose whether new accounts must confirm their email; if enabled, configure the email provider and redirect URL before inviting other people.

## Connect the website

The app is configured with the project URL and publishable key. The publishable key is intended for browser use; database access is restricted by the row level security policies in `schema.sql`. The app uses email/password sign-in and includes create-library, invite-code, and join-library controls in **Settings**.

## First use

The first person creates an account and library. Creating the library uploads the current browser's shelf. From Settings, they create an invite code and give it to the other person. That person creates an account, signs in, and joins with the code. Joining loads the shared library over any local shelf on that device. Both accounts then read and edit the same shelf across devices. The existing JSON export remains available as a backup.

## Accounts, usernames and invitations

Run `accounts.sql` once in the SQL Editor, after `schema.sql`. It adds usernames, a search for other people by username, and invitations between accounts.

1. Each person creates their own account and picks a username the first time they sign in.
2. The person who has the library opens **Settings**, types the other person's username, and presses **Invite**.
3. The invited person sees the invitation as soon as they sign in (the page also checks every few seconds) and presses **Accept**. If they had started an empty library of their own, it is replaced by the shared one.

Search matches the start of a username and needs at least three characters. Once both of you are in, you can switch off **Allow new users to sign up** under Authentication → Sign In / Providers so nobody else can create an account.

Until `accounts.sql` has been run, the app falls back to the older invite-code flow.
