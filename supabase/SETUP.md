# Supabase setup for The Usual

This backend keeps the existing library shape (`items`, `people`, and library display names) as one shared JSON document. Membership is stored separately and protected by row level security. A signed-in user can belong to one library. Invite codes expire after seven days.

## Create the Supabase project

1. Create a project at [supabase.com/dashboard](https://supabase.com/dashboard).
2. In **Project Settings → API**, copy the **Project URL** and the **publishable key** (or legacy `anon` key). The website must never use the `service_role` key.
3. In **SQL Editor**, open `schema.sql` from this folder, paste it, and run it once.
4. In **Authentication → URL Configuration**, add the website's final HTTPS origin to **Site URL** and **Redirect URLs**. For local development, add the local origin too.
5. In **Authentication → Providers**, leave Email enabled. Choose whether new accounts must confirm their email; if enabled, configure the email provider and redirect URL before inviting other people.

## Finish connecting the website

The app still needs the project URL and publishable key to connect. Provide those two values (they are designed for browser use) and the deployed website URL. Do not share a database password, `service_role` key, or email provider secret. Once supplied, the app can be wired to sign-in, library creation, invite creation/joining, and cloud loading/saving while retaining the current shelf and watch-history interface.

## First use

The first person creates an account and library. From the library settings, they create an invite code and give it to the other person. That person signs in and joins with the code. Both accounts then read and edit the same shelf on any device. The current prototype data is in browser storage; migration/import needs to be done from the browser that holds the shelf after the account and library are connected.
