# OtterMark

Markdown editor built with Tauri v2 + SvelteKit + CodeMirror 6.

## Features

- Live dual-pane editing (editor + preview)
- GFM (GitHub Flavored Markdown) support
- Light / dark theme
- Toolbar with common markdown formatting
- Keyboard shortcuts (Ctrl+S, Ctrl+O, Ctrl+N, Ctrl+Shift+S)

## Tech Stack

- **Runtime**: Tauri v2 (Rust backend, WebView frontend)
- **Frontend**: SvelteKit (SPA mode), Svelte 5
- **Editor**: CodeMirror 6
- **Preview**: marked
- **Styling**: Tailwind CSS v4
- **Package manager**: Bun

## Development

```bash
bun install
bun run tauri dev
```

## Building

```bash
bun run tauri build
```
