<script lang="ts">
  import {
    FileText,
    FolderOpen,
    Save,
    FilePlus,
    Sun,
    Moon,
    Bold,
    Italic,
    Heading,
    Link,
    List,
    ListOrdered,
    Quote,
    Code,
    Minus,
    Info,
  } from "lucide-svelte";
  import { theme, isDirty, currentFilePath } from "$lib/stores/editor";

  interface Props {
    onNewFile: () => void;
    onOpenFile: () => void;
    onSaveFile: () => void;
    onSaveAs: () => void;
    onInsertMarkdown: (syntax: string) => void;
    onAbout: () => void;
  }

  let { onNewFile, onOpenFile, onSaveFile, onSaveAs, onInsertMarkdown, onAbout }: Props =
    $props();

  let currentTheme = $state<"light" | "dark">("light");
  let dirty = $state(false);
  let filePath = $state<string | null>(null);

  theme.subscribe((t) => (currentTheme = t));
  isDirty.subscribe((d) => (dirty = d));
  currentFilePath.subscribe((p) => (filePath = p));

  function toggleTheme() {
    theme.update((t) => (t === "light" ? "dark" : "light"));
  }
</script>

<div
  class="toolbar flex items-center gap-1 px-3 py-1.5 border-b select-none
    {currentTheme === 'dark'
    ? 'bg-[#181825] border-[#313244] text-[#cdd6f4]'
    : 'bg-[#f8fafc] border-[#e2e8f0] text-[#1e1e2e]'}"
>
  <div class="flex items-center gap-1">
    <button
      class="toolbar-btn"
      onclick={onNewFile}
      title="New File (Ctrl+N)"
    >
      <FilePlus size={18} />
    </button>
    <button
      class="toolbar-btn"
      onclick={onOpenFile}
      title="Open File (Ctrl+O)"
    >
      <FolderOpen size={18} />
    </button>
    <button
      class="toolbar-btn"
      onclick={onSaveFile}
      title="Save (Ctrl+S)"
    >
      <Save size={18} />
    </button>
    <button class="toolbar-btn" onclick={onSaveAs} title="Save As (Ctrl+Shift+S)">
      <FileText size={18} />
    </button>
  </div>

  <div class="w-px h-5 mx-1 {currentTheme === 'dark' ? 'bg-[#313244]' : 'bg-[#e2e8f0]'}"></div>

  <div class="flex items-center gap-1">
    <button class="toolbar-btn" onclick={() => onInsertMarkdown("bold")} title="Bold (Ctrl+B)">
      <Bold size={18} />
    </button>
    <button class="toolbar-btn" onclick={() => onInsertMarkdown("italic")} title="Italic (Ctrl+I)">
      <Italic size={18} />
    </button>
    <button class="toolbar-btn" onclick={() => onInsertMarkdown("heading")} title="Heading">
      <Heading size={18} />
    </button>
    <button class="toolbar-btn" onclick={() => onInsertMarkdown("link")} title="Link">
      <Link size={18} />
    </button>
    <button class="toolbar-btn" onclick={() => onInsertMarkdown("code")} title="Code">
      <Code size={18} />
    </button>
    <button class="toolbar-btn" onclick={() => onInsertMarkdown("quote")} title="Blockquote">
      <Quote size={18} />
    </button>
    <button class="toolbar-btn" onclick={() => onInsertMarkdown("ul")} title="Unordered List">
      <List size={18} />
    </button>
    <button class="toolbar-btn" onclick={() => onInsertMarkdown("ol")} title="Ordered List">
      <ListOrdered size={18} />
    </button>
    <button class="toolbar-btn" onclick={() => onInsertMarkdown("hr")} title="Horizontal Rule">
      <Minus size={18} />
    </button>
  </div>

  <div class="flex-1"></div>

  <div class="flex items-center gap-2 text-xs opacity-70">
    {#if dirty}
      <span class="text-amber-500 font-medium">Unsaved</span>
    {/if}
    {#if filePath}
      <span class="truncate max-w-48">{filePath.split("/").pop()}</span>
    {:else}
      <span>Untitled</span>
    {/if}
  </div>

  <div class="w-px h-5 mx-1 {currentTheme === 'dark' ? 'bg-[#313244]' : 'bg-[#e2e8f0]'}"></div>

  <button class="toolbar-btn" onclick={onAbout} title="About OtterMark">
    <Info size={18} />
  </button>

  <button class="toolbar-btn" onclick={toggleTheme} title="Toggle Theme">
    {#if currentTheme === "dark"}
      <Sun size={18} />
    {:else}
      <Moon size={18} />
    {/if}
  </button>
</div>

<style>
  .toolbar-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 30px;
    height: 30px;
    border: none;
    background: transparent;
    border-radius: 6px;
    cursor: pointer;
    color: inherit;
    transition: background-color 0.15s;
  }
  .toolbar-btn:hover {
    background: rgba(127, 127, 127, 0.15);
  }
  .toolbar-btn:active {
    background: rgba(127, 127, 127, 0.25);
  }
</style>
