# Illustrative Almasix journey for the marketing hero (no real install).
# Sourced harness prints realistic CLI output at a snappy pace.
#
#   export PATH="/tmp:/path/to/vhs:$PATH"
#   cd /tmp/vhs-rec && vhs /path/to/hero-demo.tape

Output install-demo.gif
Output install-demo.webm
Output install-demo.mp4

Set Shell bash
Set FontSize 15
Set Width 1100
Set Height 640
Set Padding 18
Set TypingSpeed 22ms
Set Framerate 30
Set PlaybackSpeed 1
Set WindowBar Colorful
Set BorderRadius 10
Set Margin 0
Set Theme {"name":"Almasix","black":"#17120f","red":"#e07a5a","green":"#8fbf9a","yellow":"#d4a574","blue":"#7eb6d9","magenta":"#c7929a","cyan":"#7eb6d9","white":"#f3ebe4","brightBlack":"#6a5c54","brightRed":"#ff7a4d","brightGreen":"#a8d4b0","brightYellow":"#e8c49a","brightBlue":"#9ec9e6","brightMagenta":"#d4a8b0","brightCyan":"#9ec9e6","brightWhite":"#fffaf6","background":"#17120f","foreground":"#f3ebe4","cursor":"#ff7a4d","selection":"#3a2c26"}

Hide
Type `cd /tmp/vhs-rec && rm -rf myapp && source /home/smaosa/Projects/almasix-website/scripts/hero-demo.sh && clear`
Enter
Show

# —— Install ——
Type `pipx install almasix`
Enter
Sleep 700ms

# —— Scaffold (illustrative prompts) ——
Type `almasix new myapp`
Enter
Sleep 2.2s

Type `cd myapp`
Enter
Type `source .venv/bin/activate`
Enter
Sleep 350ms

# —— Make + ship ——
Type `python smith make:model Post`
Enter
Sleep 550ms
Type `python smith make:controller PostController --resource --model=Post`
Enter
Sleep 650ms

Type `cat app/http/controllers/post_controller.py`
Enter
Sleep 1.6s

Type `python smith migrate`
Enter
Sleep 550ms
Type `python smith db:seed`
Enter
Sleep 500ms
Type `python smith serve`
Enter
Sleep 2.2s
Type `clear`
Enter
Type `# http://127.0.0.1:3000 — myapp is live`
Enter
Sleep 1.8s
