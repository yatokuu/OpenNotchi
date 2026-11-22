# Temirlan's notch setup

This local build is based on [OpenNotchi](https://github.com/nannndev/OpenNotchi) (MIT license).

- Clipboard tab keeps the newest 15 entries, including copied text and images.
- It also reads recent macOS screenshot files from the folder set in `com.apple.screencapture location` (or Desktop by default) and labels them **Screenshot**. It does not change the clipboard or record the screen.
- Notes and Timer tabs are enabled. The note from the previous Notchy installation was imported into OpenNotchi's local `notes.json`.
- Firefox YouTube playback uses the local `media-control` helper and the macOS media session. Firefox has no **Allow JavaScript from Apple Events** switch. Other supported browsers still use their Apple Events JavaScript integration.
- Install the helper with `brew install media-control` if this build is moved to another Mac. Firefox can be turned on or off in Settings → Media.
- The visible tabs are Home (music), Notes, Clipboard, Timer, AI, and Prompter.
- Markets and tickers, stats, weather, video preview, mascot animation, and the idle now-playing screen were disabled to reduce background work.
- The AI gateway binary comes from the `nannndev/eay-gateway` GitHub release and must be present inside the app bundle. AI providers may still require the user's own account or API configuration.
- Automatic upstream updates are off because they would replace this custom build.

The screenshot entries are rebuilt from files each launch; screenshots must remain in their original folder. Copied images that are not saved screenshots are held in memory for the current run. The original Notchy note backup remains at `~/Documents/Notchy notes backup.txt`.

Build with `SKIP_GATEWAY=1 make app`. The installed local build is `/Applications/OpenNotchi.app`.
