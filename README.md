# OtterMark

A lightweight, cross-platform markdown editor with live preview. Built with Tauri v2, SvelteKit, and CodeMirror 6.

![License](https://img.shields.io/badge/license-MIT-green)
![Version](https://img.shields.io/badge/version-0.1.0-blue)

## Features

### Editor
- CodeMirror 6 with markdown syntax highlighting
- GFM (GitHub Flavored Markdown) live preview
- Resizable split-pane layout (editor + preview)
- Light and dark theme (Catppuccin-inspired dark palette)
- System theme detection on first launch

### File operations
- Open `.md`, `.markdown`, `.mdx`, `.txt` files
- Save / Save As with format selection
- Window title shows current filename and unsaved indicator

### Formatting toolbar
- Bold, italic, headings, links, inline code, blockquotes
- Ordered and unordered lists, horizontal rule
- All actions available as toolbar buttons with icons

### Keyboard shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl+N` | New file |
| `Ctrl+O` | Open file |
| `Ctrl+S` | Save |
| `Ctrl+Shift+S` | Save As |
| `Ctrl+B` | Bold |
| `Ctrl+I` | Italic |

### Autosave & crash recovery
- Editor content is saved to a temporary recovery file every 30 seconds
- On startup, if a previous session crashed, a dialog offers to restore unsaved work
- Recovery file is automatically cleaned up on normal exit

## Tech Stack

| Layer | Technology |
|---|---|
| Runtime | Tauri v2 (Rust backend, WebView frontend) |
| Frontend | SvelteKit (SPA mode), Svelte 5 (runes) |
| Editor | CodeMirror 6 |
| Markdown | marked (GFM) |
| Styling | Tailwind CSS v4 |
| Icons | lucide-svelte |
| Package manager | Bun |

## Getting Started

### Prerequisites

- [Bun](https://bun.sh/) (package manager)
- [Rust](https://rustup.rs/) (for Tauri backend)
- System dependencies for Tauri v2 — see [Tauri prerequisites](https://v2.tauri.app/start/prerequisites/)

### Development

```bash
bun install
bun run tauri dev
```

### Building

```bash
bun run tauri build
```

Build artifacts are generated per platform:

| Platform | Formats |
|---|---|
| Linux | `.deb`, `.rpm`, `.AppImage` |
| Windows | NSIS installer, `.msi` |
| macOS | `.dmg` (Intel & Apple Silicon) |

### Flatpak

A Flatpak manifest is included for sandboxed Linux distribution:

```bash
bun run flatpak
```

## Project Structure

```
src/
  routes/
    +page.svelte          # Main layout (editor + preview + recovery)
    +layout.svelte        # Root layout, global styles, theme
  lib/
    components/
      Editor.svelte       # CodeMirror 6 wrapper
      Preview.svelte      # Markdown preview pane
      Toolbar.svelte      # Top toolbar with actions
      Splitter.svelte     # Draggable split-pane handle
      AboutDialog.svelte  # App info dialog
      RecoveryDialog.svelte  # Crash recovery prompt
    stores/
      editor.ts           # Shared state (content, filePath, isDirty, theme)
  app.css                 # Tailwind theme tokens
src-tauri/
  src/lib.rs              # Tauri commands (recovery file ops) & plugin registration
  capabilities/           # Permission scoping
  tauri.conf.json         # App config
flatpak/                  # Flatpak manifest, desktop entry, metainfo
.github/workflows/        # CI build for Linux, Windows, macOS
```

## License

[MIT](https://opensource.org/licenses/MIT)
