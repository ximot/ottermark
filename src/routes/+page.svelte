<script lang="ts">
  import { onMount } from "svelte";
  import { open, save } from "@tauri-apps/plugin-dialog";
  import { readTextFile, writeTextFile } from "@tauri-apps/plugin-fs";
  import { getCurrentWindow } from "@tauri-apps/api/window";
  import { invoke } from "@tauri-apps/api/core";
  import Editor from "$lib/components/Editor.svelte";
  import Preview from "$lib/components/Preview.svelte";
  import Toolbar from "$lib/components/Toolbar.svelte";
  import AboutDialog from "$lib/components/AboutDialog.svelte";
  import RecoveryDialog from "$lib/components/RecoveryDialog.svelte";
  import { get } from "svelte/store";
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
  let showRecoveryDialog = $state(false);
  let recoveryContentToRestore = $state("");

  theme.subscribe((t) => (currentTheme = t));

  onMount(() => {
    // Check for crash recovery on startup
    checkForRecovery();

    const unsub = windowTitle.subscribe((title) => {
      getCurrentWindow().setTitle(title);
    });

    // Autosave timer - runs every 30 seconds
    const autosaveInterval = setInterval(async () => {
      if (get(isDirty)) {
        try {
          await invoke("write_recovery_file", { content: get(content) });
        } catch (err) {
          console.error("Failed to autosave:", err);
        }
      }
    }, 30000);

    // Cleanup recovery file on normal app exit
    let unlistenClose: (() => void) | null = null;
    getCurrentWindow()
      .onCloseRequested(async () => {
        try {
          await invoke("delete_recovery_file");
        } catch (err) {
          // Silently ignore if recovery file doesn't exist
        }
      })
      .then((unlisten) => {
        unlistenClose = unlisten;
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
      if (unlistenClose) unlistenClose();
      clearInterval(autosaveInterval);
      window.removeEventListener("keydown", handleKeydown);
    };
  });

  async function checkForRecovery() {
    try {
      const exists = await invoke<boolean>("recovery_exists");
      if (!exists) return;
      const recoveryContent = await invoke<string>("read_recovery_file");
      if (recoveryContent) {
        recoveryContentToRestore = recoveryContent;
        showRecoveryDialog = true;
      }
    } catch (err) {
      // Silently ignore if recovery check fails
    }
  }

  async function handleRecover() {
    content.set(recoveryContentToRestore);
    isDirty.set(true);
    if (editorComponent) {
      editorComponent.setContent(recoveryContentToRestore);
    }
    await invoke("delete_recovery_file");
    showRecoveryDialog = false;
  }

  async function handleDiscard() {
    await invoke("delete_recovery_file");
    showRecoveryDialog = false;
  }

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
    const path = get(currentFilePath);

    if (!path) {
      await saveAs();
      return;
    }

    try {
      await writeTextFile(path, get(content));
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

      await writeTextFile(path, get(content));
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

<RecoveryDialog
  open={showRecoveryDialog}
  onRecover={handleRecover}
  onDiscard={handleDiscard}
/>
