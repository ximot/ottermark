<script lang="ts">
  import { onMount } from "svelte";
  import { open, save } from "@tauri-apps/plugin-dialog";
  import { readTextFile, writeTextFile } from "@tauri-apps/plugin-fs";
  import { getCurrentWindow } from "@tauri-apps/api/window";
  import Editor from "$lib/components/Editor.svelte";
  import Preview from "$lib/components/Preview.svelte";
  import Toolbar from "$lib/components/Toolbar.svelte";
  import AboutDialog from "$lib/components/AboutDialog.svelte";
  import {
    content,
    currentFilePath,
    isDirty,
    windowTitle,
    theme,
  } from "$lib/stores/editor";

  let editorComponent: Editor;
  let currentTheme = $state<"light" | "dark">("light");
  let showAbout = $state(false);

  theme.subscribe((t) => (currentTheme = t));

  onMount(() => {
    const unsub = windowTitle.subscribe((title) => {
      getCurrentWindow().setTitle(title);
    });

    function handleKeydown(e: KeyboardEvent) {
      if (e.ctrlKey || e.metaKey) {
        switch (e.key) {
          case "s":
            e.preventDefault();
            if (e.shiftKey) {
              saveAs();
            } else {
              saveFile();
            }
            break;
          case "o":
            e.preventDefault();
            openFile();
            break;
          case "n":
            e.preventDefault();
            newFile();
            break;
        }
      }
    }

    window.addEventListener("keydown", handleKeydown);
    return () => {
      unsub();
      window.removeEventListener("keydown", handleKeydown);
    };
  });

  async function newFile() {
    content.set("# \n\n");
    currentFilePath.set(null);
    isDirty.set(false);
    editorComponent?.setContent("# \n\n");
  }

  async function openFile() {
    try {
      const path = await open({
        filters: [
          { name: "Markdown", extensions: ["md", "markdown", "mdx", "txt"] },
          { name: "All Files", extensions: ["*"] },
        ],
      });
      if (!path) return;

      const text = await readTextFile(path);
      currentFilePath.set(path);
      content.set(text);
      isDirty.set(false);
      editorComponent?.setContent(text);
    } catch (err) {
      console.error("Failed to open file:", err);
    }
  }

  async function saveFile() {
    let path: string | null = null;
    currentFilePath.subscribe((p) => (path = p))();

    if (!path) {
      await saveAs();
      return;
    }

    try {
      let text = "";
      content.subscribe((c) => (text = c))();
      await writeTextFile(path, text);
      isDirty.set(false);
    } catch (err) {
      console.error("Failed to save file:", err);
    }
  }

  async function saveAs() {
    try {
      const path = await save({
        filters: [
          { name: "Markdown", extensions: ["md", "markdown"] },
          { name: "All Files", extensions: ["*"] },
        ],
      });
      if (!path) return;

      let text = "";
      content.subscribe((c) => (text = c))();
      await writeTextFile(path, text);
      currentFilePath.set(path);
      isDirty.set(false);
    } catch (err) {
      console.error("Failed to save file:", err);
    }
  }

  function insertMarkdown(syntax: string) {
    const view = editorComponent?.getView();
    if (!view) return;

    const { from, to } = view.state.selection.main;
    const selected = view.state.sliceDoc(from, to);

    let insert = "";
    switch (syntax) {
      case "bold":
        insert = `**${selected || "bold text"}**`;
        break;
      case "italic":
        insert = `*${selected || "italic text"}*`;
        break;
      case "heading":
        insert = `## ${selected || "Heading"}`;
        break;
      case "link":
        insert = `[${selected || "link text"}](url)`;
        break;
      case "code":
        insert = selected.includes("\n")
          ? `\`\`\`\n${selected}\n\`\`\``
          : `\`${selected || "code"}\``;
        break;
      case "quote":
        insert = `> ${selected || "quote"}`;
        break;
      case "ul":
        insert = `- ${selected || "item"}`;
        break;
      case "ol":
        insert = `1. ${selected || "item"}`;
        break;
      case "hr":
        insert = "\n---\n";
        break;
    }

    view.dispatch({
      changes: { from, to, insert },
    });
    view.focus();
  }
</script>

<div class="flex flex-col h-full">
  <Toolbar
    onNewFile={newFile}
    onOpenFile={openFile}
    onSaveFile={saveFile}
    onSaveAs={saveAs}
    onInsertMarkdown={insertMarkdown}
    onAbout={() => (showAbout = true)}
  />

  <div class="flex flex-1 min-h-0">
    <div
      class="w-1/2 h-full border-r
        {currentTheme === 'dark' ? 'border-[#313244]' : 'border-[#e2e8f0]'}"
    >
      <Editor bind:this={editorComponent} />
    </div>
    <div class="w-1/2 h-full">
      <Preview />
    </div>
  </div>
</div>

<AboutDialog open={showAbout} onClose={() => (showAbout = false)} />
