<script lang="ts">
  import { onMount } from "svelte";
  import { EditorView, basicSetup } from "codemirror";
  import { markdown } from "@codemirror/lang-markdown";
  import { oneDark } from "@codemirror/theme-one-dark";
  import { keymap } from "@codemirror/view";
  import { content, isDirty, theme } from "$lib/stores/editor";

  let editorElement: HTMLDivElement;
  let view: EditorView | null = null;

  let currentTheme: "light" | "dark" = "light";
  theme.subscribe((t) => (currentTheme = t));

  export function getView(): EditorView | null {
    return view;
  }

  export function setContent(text: string) {
    if (!view) return;
    view.dispatch({
      changes: { from: 0, to: view.state.doc.length, insert: text },
    });
    isDirty.set(false);
  }

  function buildExtensions(isDark: boolean) {
    const extensions = [
      basicSetup,
      markdown(),
      EditorView.updateListener.of((update) => {
        if (update.docChanged) {
          content.set(update.state.doc.toString());
          isDirty.set(true);
        }
      }),
      EditorView.theme({
        "&": { height: "100%" },
        ".cm-scroller": { overflow: "auto" },
      }),
      keymap.of([]),
    ];
    if (isDark) {
      extensions.push(oneDark);
    }
    return extensions;
  }

  onMount(() => {
    let initialContent = "";
    const unsub = content.subscribe((c) => (initialContent = c));
    unsub();

    view = new EditorView({
      doc: initialContent,
      extensions: buildExtensions(currentTheme === "dark"),
      parent: editorElement,
    });

    const themeUnsub = theme.subscribe((t) => {
      if (!view) return;
      const doc = view.state.doc.toString();
      const sel = view.state.selection;
      view.destroy();
      view = new EditorView({
        doc,
        extensions: buildExtensions(t === "dark"),
        parent: editorElement,
      });
      view.dispatch({ selection: sel });
    });

    return () => {
      themeUnsub();
      view?.destroy();
    };
  });
</script>

<div class="h-full w-full overflow-hidden" bind:this={editorElement}></div>
