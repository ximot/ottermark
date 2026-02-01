<script lang="ts">
  import { onMount } from 'svelte';
  import { EditorView, basicSetup } from 'codemirror';
  import { markdown } from '@codemirror/lang-markdown';
  import { oneDark } from '@codemirror/theme-one-dark';
  import { marked } from 'marked';

  let editorElement: HTMLDivElement;
  let markdownContent = "# Witaj w OtterMark!";
  let htmlPreview = "";

  onMount(() => {
    const view = new EditorView({
      doc: markdownContent,
      extensions: [
        basicSetup,
        markdown(),
        oneDark,
        EditorView.updateListener.of((update) => {
          if (update.docChanged) {
            markdownContent = update.state.doc.toString();
            renderPreview();
          }
        })
      ],
      parent: editorElement
    });

    renderPreview();
  });

  async function renderPreview() {
    htmlPreview = await marked.parse(markdownContent);
  }
</script>

<main class="container">
  <div class="editor-shell" bind:this={editorElement}></div>
  <div class="preview-shell">
    {@html htmlPreview}
  </div>
</main>

<style>
  .container {
    display: flex;
    height: 100vh;
    gap: 10px;
  }
  .editor-shell, .preview-shell {
    flex: 1;
    height: 100%;
    overflow: auto;
    padding: 20px;
  }
  .preview-shell {
    background: #fff;
    color: #333;
  }
</style>