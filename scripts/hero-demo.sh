#!/usr/bin/env bash
# Illustrative hero demo — prints realistic Almasix CLI output without a real install.
# Sourced by the VHS tape so typed commands stay snappy and deterministic.

demo_c_reset=$'\033[0m'
demo_c_dim=$'\033[2m'
demo_c_ok=$'\033[38;2;143;191;154m'
demo_c_hi=$'\033[38;2;126;182;217m'
demo_c_prompt=$'\033[38;2;255;122;77m'
demo_c_label=$'\033[38;2;126;182;217m'
demo_c_sel_bg=$'\033[48;2;143;191;154m'
demo_c_sel_fg=$'\033[38;2;23;18;15m'
demo_c_muted=$'\033[38;2;106;92;84m'

_demo_sleep() { sleep "${1:-0.12}"; }

pipx() {
	if [[ "$*" == "install almasix" ]]; then
		echo "${demo_c_dim}installing almasix from PyPI…${demo_c_reset}"
		_demo_sleep 0.25
		echo "${demo_c_ok}✓${demo_c_reset} installed package almasix 0.9.3"
		echo "${demo_c_ok}✓${demo_c_reset} these apps are now globally available"
		echo "  - almasix"
		return 0
	fi
	command pipx "$@"
}

_demo_select_line() {
	local selected="$1" text="$2"
	if [[ "$selected" == "1" ]]; then
		printf '%s❯ %s%s\n' "${demo_c_sel_bg}${demo_c_sel_fg}" "$text" "${demo_c_reset}"
	else
		printf '  %s\n' "$text"
	fi
}

almasix() {
	if [[ "$1" == "new" && -n "$2" ]]; then
		local name="$2"
		echo
		echo "${demo_c_label}Which starter kit?${demo_c_reset}"
		_demo_select_line 0 "None — Blank scaffold"
		_demo_select_line 1 "Web (Conduit) — auth, settings, teams, 2FA"
		_demo_select_line 0 "API (Signet) — JSON API + tokens"
		_demo_select_line 0 "SPA — React / Vue / Svelte + Inertia"
		echo "${demo_c_muted}  ↑/↓ navigate · enter select${demo_c_reset}"
		_demo_sleep 0.55
		echo
		echo "${demo_c_label}Which frontend stack?${demo_c_reset}"
		_demo_select_line 1 "Tailwind CSS — Vite + Tailwind CSS 4"
		_demo_select_line 0 "Bootstrap — Vite + Bootstrap 5"
		_demo_select_line 0 "No frontend build"
		echo "${demo_c_muted}  ↑/↓ navigate · enter select${demo_c_reset}"
		_demo_sleep 0.4
		echo
		echo "${demo_c_label}Which database?${demo_c_reset}"
		_demo_select_line 1 "SQLite"
		_demo_select_line 0 "PostgreSQL"
		_demo_select_line 0 "MySQL / MariaDB"
		echo "${demo_c_muted}  ↑/↓ navigate · enter select${demo_c_reset}"
		_demo_sleep 0.35
		echo
		echo "${demo_c_dim}Scaffolding ${demo_c_hi}${name}${demo_c_dim}…${demo_c_reset}"
		_demo_sleep 0.2
		echo "${demo_c_ok}✓${demo_c_reset} app · routes · config · resources · database"
		echo "${demo_c_ok}✓${demo_c_reset} Web kit · Tailwind · SQLite · tests · git"
		echo "${demo_c_ok}✓${demo_c_reset} .venv · deps · npm build · migrations"
		echo
		echo "Created Almasix application: ${demo_c_hi}./${name}${demo_c_reset}"
		mkdir -p "$name"
		return 0
	fi
	command almasix "$@" 2>/dev/null || true
}

cd() {
	builtin cd "$@" || return
	# Stay illustrative after entering the app dir.
	if [[ "${PWD##*/}" == "myapp" ]]; then
		export VIRTUAL_ENV="$PWD/.venv"
		# shellcheck disable=SC2034
		PS1="(.venv) ${demo_c_prompt}\$${demo_c_reset} "
	fi
}

source() {
	if [[ "$1" == ".venv/bin/activate" ]]; then
		echo "${demo_c_dim}(.venv) activated${demo_c_reset}"
		PS1="(.venv) ${demo_c_prompt}\$${demo_c_reset} "
		return 0
	fi
	builtin source "$@"
}

python() {
	if [[ "$1" == "smith" ]]; then
		shift
		_demo_smith "$@"
		return $?
	fi
	command python "$@"
}

cat() {
	if [[ "$1" == "app/http/controllers/post_controller.py" ]]; then
		demo_show_code
		return 0
	fi
	command cat "$@"
}

_demo_smith() {
	case "$1" in
	make:model)
		local model="${2:-Post}"
		local slug
		slug="$(printf '%s' "$model" | tr '[:upper:]' '[:lower:]')"
		echo "${demo_c_ok}✓${demo_c_reset} app/models/${slug}.py"
		echo "${demo_c_ok}✓${demo_c_reset} database/migrations/*_create_${slug}s_table.py"
		echo "${demo_c_ok}✓${demo_c_reset} database/factories/${slug}_factory.py"
		;;
	make:controller)
		local ctrl="${2:-PostController}"
		local slug
		slug="$(printf '%s' "$ctrl" | sed 's/Controller$//' | tr '[:upper:]' '[:lower:]')"
		echo "${demo_c_ok}✓${demo_c_reset} app/http/controllers/${slug}_controller.py"
		if [[ "$*" == *"--resource"* ]]; then
			echo "${demo_c_dim}  resource actions: index show create store edit update destroy${demo_c_reset}"
		fi
		;;
	migrate)
		echo "${demo_c_ok}✔${demo_c_reset} Migrated: create_users_table"
		echo "${demo_c_ok}✔${demo_c_reset} Migrated: create_posts_table"
		echo "${demo_c_ok}✔${demo_c_reset} Migrated: create_sessions_table"
		;;
	db:seed)
		echo "${demo_c_ok}✔${demo_c_reset} Database seeding completed successfully."
		;;
	serve)
		echo "Serving bootstrap.app:asgi on ${demo_c_hi}http://127.0.0.1:3000${demo_c_reset}"
		echo "${demo_c_dim}INFO:${demo_c_reset}     Uvicorn running on http://127.0.0.1:3000"
		echo "${demo_c_ok}✓${demo_c_reset} Application startup complete."
		;;
	*)
		echo "${demo_c_dim}smith $*${demo_c_reset}"
		;;
	esac
}

# Show a short controller snippet (illustrative code).
demo_show_code() {
	echo "${demo_c_dim}# app/http/controllers/post_controller.py${demo_c_reset}"
	command cat <<'PY'
from almasix.http import Controller, Request, Response
from almasix.prism import view
from app.models.post import Post

class PostController(Controller):
    async def index(self, request: Request) -> Response:
        posts = await Post.query().latest().get()
        return view("posts.index", posts=posts)
PY
}
