# Real Almasix install journey for the marketing hero.
# Requires: vhs, ttyd, ffmpeg, chromium; pipx almasix + npm on PATH.
#
#   mkdir -p /tmp/vhs-rec && cp scripts/install-demo.tape /tmp/vhs-rec/
#   export PATH="/path/to/ttyd:/path/to/vhs:$PATH"
#   cd /tmp/vhs-rec && vhs install-demo.tape
#   cp install-demo.webm install-demo.mp4 ../…/public/

Output install-demo.gif
Output install-demo.webm
Output install-demo.mp4

Set Shell bash
Set FontSize 14
Set Width 980
Set Height 580
Set Padding 20
Set TypingSpeed 32ms
Set Framerate 30
Set PlaybackSpeed 1
Set WindowBar Colorful
Set BorderRadius 10
Set Margin 0
Set Theme {"name":"Almasix","black":"#17120f","red":"#e07a5a","green":"#8fbf9a","yellow":"#d4a574","blue":"#7eb6d9","magenta":"#c7929a","cyan":"#7eb6d9","white":"#f3ebe4","brightBlack":"#6a5c54","brightRed":"#ff7a4d","brightGreen":"#a8d4b0","brightYellow":"#e8c49a","brightBlue":"#9ec9e6","brightMagenta":"#d4a8b0","brightCyan":"#9ec9e6","brightWhite":"#fffaf6","background":"#17120f","foreground":"#f3ebe4","cursor":"#ff7a4d","selection":"#3a2c26"}

Hide
Type `export PATH="/home/smaosa/.local/bin:/home/smaosa/.nvm/versions/node/v24.18.0/bin:$PATH"`
Enter
Type `cd /tmp/vhs-rec && rm -rf myapp && clear`
Enter
Show

# —— 1. Install the global CLI ——
Type `pipx install almasix`
Enter
Sleep 1.4s

# —— 2. Interactive create (kit → stack → database → confirms) ——
Type `almasix new myapp`
Enter
Sleep 1s

# Starter kit: browse SPA options, land on Web (Conduit)
Down
Sleep 400ms
Down
Sleep 320ms
Down
Sleep 320ms
Down
Sleep 320ms
Up
Sleep 260ms
Up
Sleep 260ms
Up
Sleep 400ms
Enter
Sleep 800ms

# Frontend stack: peek at Bootstrap, keep Tailwind
Down
Sleep 450ms
Up
Sleep 400ms
Enter
Sleep 700ms

# Database: SQLite
Sleep 500ms
Enter
Sleep 550ms

# Scaffold pytest suite? Yes
Sleep 450ms
Enter
Sleep 500ms

# Initialize git? Yes
Sleep 450ms
Enter
Sleep 500ms

# Create .venv and install? Yes
Sleep 450ms
Enter
Sleep 500ms

# npm install && build? Yes
Sleep 450ms
Enter
Sleep 500ms

# Run default migrations? Yes
Sleep 450ms
Enter

# Full install (venv + pip + npm + migrate) — wall-clock, cached deps ~40–55s
Sleep 55s

# —— 3. Seed + serve ——
Type `cd myapp`
Enter
Type `source .venv/bin/activate`
Enter
Type `python smith db:seed`
Enter
Sleep 2s
Type `python smith serve`
Enter
Sleep 5s
Ctrl+C
Sleep 1s
Type `clear`
Enter
Type `# App ready — http://127.0.0.1:3000`
Enter
Sleep 2.5s
