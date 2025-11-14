# Miami-Dade Academy RP Discord Configuration

Use this guide to align your Discord server roles and channels with the in-game systems.

## Core Roles
Create the following roles in the order listed and copy their Discord role IDs into `resources/mda_resources/mda_rolesync/config.lua`.

| Role Name | Purpose | Notes |
|-----------|---------|-------|
| Academy Director | Server Owner / Administrator | Assign to yourself. Required for `/mdaweather`, `/mdapayout`, etc. |
| Academy Staff | Moderation team | Configure moderation permissions. |
| Academy Recruit | Default role after whitelist approval | Maps to `ROLE_ID_CIVILIAN` |
| Business Owner | Approved business owners | Maps to `ROLE_ID_BUSINESS` |
| Gang Leader | Gang management | Maps to `ROLE_ID_GANG` |
| Florida Highway Patrol | Agency role | Maps to `ROLE_ID_FHP` |
| Miami Dade Fire Rescue | Agency role | Maps to `ROLE_ID_MDFR` |
| Florida Fish & Wildlife | Agency role | Maps to `ROLE_ID_FWC` |
| Miami-Dade Police Department | Agency role | Maps to `ROLE_ID_MDPD` |
| Miami-Dade SWAT | Specialized unit | Maps to `ROLE_ID_SWAT` |
| Florida Department of Transportation | Agency role | Maps to `ROLE_ID_FDOT` |
| Miami-Dade Dispatch | Dispatchers | Maps to `ROLE_ID_DISPATCH` |

### Additional Roles
- **Training In-Session** – assign temporarily while players attend academy classes.
- **Suspended** – prevents login by setting status to `pending` in the Miami ID database.

## Channel Categories & Channels
Create categories and channels to mirror server operations.

### 📋 Administration
- `#welcome` – automated welcome message, community guidelines.
- `#announcements` – server-wide updates and patch notes.
- `#server-status` – webhook for server online/offline notifications.

### 📝 Applications
- `#how-to-apply` – instructions for whitelist application.
- `#application-links` – link to external forms (Sonoran CAD, Google Forms, etc.).
- `#application-updates` – staff can post acceptance/denial messages.

### 🎓 Academy Operations
- `#academy-schedule` – upcoming class times.
- `#academy-materials` – documents, SOPs, and training outlines.
- `#academy-voice` (Voice) – used during training sessions.

### 🚓 Agencies
Create one category per agency containing:
- `#briefings` – shift briefings and announcements.
- `#operations` – day-to-day coordination.
- `#evidence` – optional channel for case files (limit read/write).
- Voice channels: `Patrol 1`, `Patrol 2`, `Command Net`.

### 👔 Civilian Life
- `#business-registry` – submit business proposals.
- `#gang-registration` – gang approval requests.
- `#civ-roleplay` – share RP stories and schedule events.
- Voice channels: `Community Hub`, `Events`.

### 📡 Communications
- `#dispatch-logs` – integrate Sonoran CAD webhook.
- `#panic-alerts` – optional webhook from in-game panic button.
- Voice channels: `Dispatch HQ`, `TAC-1`, `TAC-2`.

### 💼 Staff Tools
- `#staff-chat` – private moderator chat.
- `#action-log` – moderation log webhooks.
- `#development` – track upcoming features and bug reports.

## Permissions Overview
- **Academy Director**: Full admin rights, manage roles, manage webhooks.
- **Academy Staff**: Manage messages, mute/kick members, manage applications.
- **Agency Roles**: Access to their respective categories + academy channels.
- **Business Owner / Gang Leader**: Limited read/write to business or gang channels.
- **Academy Recruit**: Read-only access to announcements, academy materials, and civilian channels.

Configure channel permissions so only verified roles can see agency channels. Ensure the default `@everyone` role cannot view restricted categories.

## Bot & Integration Setup
1. Create a Discord bot and invite it with `Guild Members` intent enabled.
2. Set the bot token in your server configuration: `setr mda_discord_bot_token "YOUR_TOKEN"`.
3. Add webhooks for:
   - `#server-status` (use a monitoring bot or Uptime Kuma).
   - `#dispatch-logs` (Sonoran CAD or custom integration).
   - `#panic-alerts` (bind to in-game panic command in future updates).
4. Configure the bot with slash commands for `/academy`, `/registerbusiness`, etc. to link to application forms.

## Role Synchronization Checklist
- Update every `ROLE_ID_*` placeholder in `mda_rolesync/config.lua` with the matching role IDs.
- Restart the server or run `/mda_rolesync` in the server console to refresh all players.
- Verify that HUD employment status updates and that `/mdapaynow` respects the new payout groups.

## Suggested Automation Ideas
- Use Discord forms for academy registration to automatically post to `#application-updates`.
- Sync punishment logs to `#action-log` using moderation bots.
- Add stage channels for graduation ceremonies or live briefings.
