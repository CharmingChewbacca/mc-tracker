# MC Tracker — sync version

A copy of the Morgan Creative Client & Hours Tracker that saves to a private online database instead of the browser. The same data shows up on your Mac and iPhone, and on the phone it can be added to the home screen like an app.

This is a **separate project**. Your current tracker file isn't touched, and the two never share data unless you choose to import a backup.

---

## What's in the folder

| File | What it is |
|---|---|
| `index.html` | The app: same design and features as your current tracker |
| `config.js` | The only file you edit: your Supabase address and key |
| `supabase.js` | The Supabase library, included here so the app doesn't load code from anyone else's server |
| `supabase-setup.sql` | One-time database setup you paste into Supabase |
| `manifest.webmanifest`, `icon-*.png` | Home-screen icon and app settings |
| `.github/workflows/keep-awake.yml` | Pings the database every 3 days so the free plan never pauses it |

---

## Step 1 — Set up Supabase (about 10 minutes)

1. Go to **supabase.com** and sign up for the free plan.
2. Click **New project**. Name it something like `mc-tracker`, choose a strong database password (save it in your password manager), and pick an East US region.
3. When the project is ready, open **SQL Editor** and start a new query. Paste in the whole of `supabase-setup.sql` and click **Run**. You should see "Success."
4. Create your login. Go to **Authentication → Users → Add user → Create new user**, enter your email and a strong password, and check **Auto Confirm User**.
5. Lock the door behind you. In the **Authentication** settings (sign-in / providers), turn **off** "Allow new users to sign up" and save. Now nobody else can create an account.
6. Get your two values. Click **Connect**, or go to **Project Settings → API**, and copy:
   - the **Project URL**
   - the **publishable** key (it may be labeled **anon**)

   ⚠️ Never use the **secret** / **service_role** key.

## Step 2 — Try it on your Mac first (about 2 minutes)

1. Open `config.js` in TextEdit and paste the two values between the quote marks. Save.
2. Double-click `index.html` and sign in with the email and password from Step 1.
3. Click **Load sample data to test**. Everything in it is made up.
4. Try anything you like. To see syncing work, open the same file in a second browser (Safari and Chrome), make a change in one, then click into the other.

## Step 3 — Put it online with GitHub Pages (about 10 minutes)

1. Sign up at **github.com** (free).
2. Create a **New repository** called `mc-tracker` and set it to **Public**. Free GitHub Pages needs a public repo.
   This is safe: only the app's *code* goes here. Your client data lives in Supabase. The key in `config.js` is designed to be public, and it can't read anything without your login.
3. In the new repo, click **uploading an existing file**. Drag in every file from the folder *except* the `.github` folder, which your Mac hides anyway. Click **Commit changes**.
4. Add the keep-awake job. Click **Add file → Create new file**, name it exactly `.github/workflows/keep-awake.yml`, paste in the contents of that file from the folder, and commit.
5. Go to **Settings → Pages**. Under Source, choose **Deploy from a branch**, then select **main** and **/ (root)**, and click **Save**.
   About a minute later your app is live at `https://YOUR-USERNAME.github.io/mc-tracker/`.
6. Test the keep-awake job. Go to the **Actions** tab, choose **Keep database awake**, and click **Run workflow**. A green check means it's working.

## Step 4 — Add it to your iPhone

1. Open your app's address in **Safari** and sign in.
2. Tap **Share → Add to Home Screen**.
3. From then on, open it from the icon. It runs full screen, and the blue **+ Log Hours** button gets you straight to logging time.

---

## Moving your real data over (only when you're ready)

1. In your **current** tracker on your Mac, click **↓ Backup**. This saves a `.json` file and changes nothing in the tracker.
2. In the **new** app on your Mac, click **↑ Restore** and choose that file. It replaces the sample data.

Keep the backup file on your Mac. Don't upload it to GitHub.

## If you decide not to use it

Delete the GitHub repository and the Supabase project. Nothing else is affected.

---

## Good to know

- **Syncing:** the dot in the header shows **Synced**, **Saving…**, or **Offline — will retry**. Changes save within a second. If you're offline, the app keeps retrying, but **leave it open until it says Synced**. Changes made offline are lost if you close the app before they save.
- **Phone and Mac at the same time:** each save checks whether the other device saved first. If it did, the two sets of changes are merged record by record, so neither one overwrites the other.
- **Backups still work:** ↓ Backup and ↓ CSV are on the desktop layout. They're hidden on the phone to keep it simple.
- **Keep-awake:** GitHub may switch off scheduled jobs in a repo that hasn't changed for about 60 days. If you get an email about that, re-enable it from the Actions tab. Even if the database did pause, nothing would be deleted. You'd click "Restore project" in Supabase.
- **Privacy:** your data sits in your own Supabase project, behind your login, and the database only allows the signed-in owner to read or write it. No AI service is involved anywhere in the app.
