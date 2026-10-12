# Waja Editor — Ready Project Package

This folder contains a responsive installable-web-app (PWA) front end and a Supabase database setup script for a shared online prompt gallery.

## Included
- `index.html` — Waja Editor gallery, search, categories, favorites, prompt copying, sharing, admin sign-in and publishing.
- `manifest.webmanifest`, `sw.js`, `assets/icon.svg` — PWA install metadata, offline shell and app icon.
- `supabase_setup.sql` — table, access policies and image bucket.
- This guide.

## Important: not deployed yet
This project is not a live website and is not an Android APK yet. A Supabase project and a web host are required to make the shared gallery work for all users. Do not share admin credentials or a Supabase service-role key. The app only needs the public anon/publishable key in the browser.

## 1. Create the online database
1. Create a project at https://supabase.com/ and open its SQL Editor.
2. Run all statements from `supabase_setup.sql`.
3. In Authentication settings, configure sign-in options. Create your own admin user in Authentication > Users.
4. In the SQL editor, if you want only one administrator, replace the insert/delete policies with a check against your chosen admin user UUID, or create a separate admin role table. The starter policies permit any authenticated account to publish and delete its own posts, so restrict sign-ups or tighten policies before a public launch.

## 2. Connect the website
Open `index.html` and replace:
- `YOUR_SUPABASE_PROJECT_URL` with your project's Project URL.
- `YOUR_SUPABASE_ANON_KEY` with the project's public anon/publishable key.

Never put a service-role key in the HTML.

## 3. Publish the website
Upload the project files preserving their folder structure to a static host such as Netlify, Cloudflare Pages, or GitHub Pages. Use HTTPS. The gallery reads from the shared Supabase database; the admin login and uploads require the policies and bucket above.

## 4. Install on Android
After publishing over HTTPS, open the website in Chrome on Android and use the browser menu's “Install app” or “Add to Home screen” option if available. For a store-ready APK/AAB, package the hosted PWA using PWABuilder or Android Studio/TWA and test it on real devices. This project package itself is not an APK.

## Before public launch
- Restrict admin sign-up and update database policies so only your own admin account can publish/delete.
- Add moderation/reporting, privacy policy, terms, image rights guidance and backups.
- Test image uploads, prompt copy, authentication, small screens and slow connections.
- The browser-based favorites are saved per device; cross-device favorites require a user account and a database table.

## Run locally for design preview
Serve this folder from a local web server; PWA service workers do not work when opened as a raw `file://` URL. For example, with Python installed, run `python -m http.server 8000` inside this folder and open `http://localhost:8000`.
