# Miami-Dade Academy RP Custom Resources

All custom scripts for the Miami-Dade Academy RP server live under the `[mda_resources]` category folder. Ensure these resources load after the core FiveM resources and before any optional community scripts.

## Resource Order
1. `mda_miami_id`
2. `mda_rolesync`
3. `mda_framework`
4. `mda_payouts`
5. `mda_postals`
6. `mda_weather`
7. `mda_import_blips`
8. `mda_hud`
9. `mda_loading`
10. `mda_nametags`
11. `mda_speedometer`
12. `mda_keybinds`
13. `mda_mlo_loader`
14. `mda_civ_careers`

Adjust the order if you add new dependencies. The loading screen must be referenced in `server.cfg` via `load_server_icon` and `sets banner_connecting` if desired.

## Customizing the Loading Screen Assets
Drop your own files inside `mda_loading/html/` (or subfolders) and update `mda_loading/html/config.js`:

- `backgroundImage`: path to your full-screen backdrop (e.g. `assets/miami-skyline.jpg`).
- `logoImage`: path to the academy badge/icon displayed in the header.
- `musicFile`: path to the ambient soundtrack (`.mp3` preferred).
- `maxPlayers`: update this to match `sv_maxclients` (currently **48**) so the loading screen always shows the correct slot cap.

All three properties support relative paths, so you can organize assets under `mda_loading/html/assets/`. No stock images, icons, or audio are committed—add them on your server host after deploying the scripts. Replace `assets/background.jpg`, `assets/logo.png`, and `assets/music.mp3` with your branded files (keeping the same names) or adjust the config paths to match your filenames.
