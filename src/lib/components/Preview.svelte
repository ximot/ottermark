<script lang="ts">
  import { marked } from "marked";
  import { content, theme } from "$lib/stores/editor";

  marked.setOptions({
    gfm: true,
    breaks: true,
  });

  let htmlContent = $state("");
  let currentTheme = $state<"light" | "dark">("light");

  theme.subscribe((t) => (currentTheme = t));

  content.subscribe(async (md) => {
    htmlContent = await marked.parse(md);
  });
</script>

<div
  class="preview h-full overflow-auto p-6 prose max-w-none
    {currentTheme === 'dark' ? 'dark-preview' : 'light-preview'}"
>
  {@html htmlContent}
</div>

<style>
  .light-preview {
    background: #ffffff;
    color: #1e1e2e;
  }
  .dark-preview {
    background: #1e1e2e;
    color: #cdd6f4;
  }
  .dark-preview :global(h1),
  .dark-preview :global(h2),
  .dark-preview :global(h3),
  .dark-preview :global(h4),
  .dark-preview :global(h5),
  .dark-preview :global(h6) {
    color: #cdd6f4;
  }
  .dark-preview :global(a) {
    color: #89b4fa;
  }
  .dark-preview :global(code) {
    background: #313244;
    color: #f38ba8;
  }
  .dark-preview :global(pre) {
    background: #181825;
  }
  .dark-preview :global(blockquote) {
    border-left-color: #585b70;
    color: #a6adc8;
  }
  .dark-preview :global(hr) {
    border-color: #313244;
  }
  .dark-preview :global(table th),
  .dark-preview :global(table td) {
    border-color: #313244;
  }

  .preview :global(h1) {
    font-size: 2em;
    font-weight: 700;
    margin-bottom: 0.5em;
    padding-bottom: 0.3em;
    border-bottom: 1px solid #e2e8f0;
  }
  .preview :global(h2) {
    font-size: 1.5em;
    font-weight: 600;
    margin-bottom: 0.5em;
    padding-bottom: 0.3em;
    border-bottom: 1px solid #e2e8f0;
  }
  .preview :global(h3) {
    font-size: 1.25em;
    font-weight: 600;
    margin-bottom: 0.5em;
  }
  .preview :global(p) {
    margin-bottom: 1em;
    line-height: 1.7;
  }
  .preview :global(code) {
    padding: 0.2em 0.4em;
    border-radius: 4px;
    font-size: 0.9em;
    background: #f1f5f9;
  }
  .preview :global(pre) {
    padding: 1em;
    border-radius: 8px;
    overflow-x: auto;
    background: #f8fafc;
  }
  .preview :global(pre code) {
    background: none;
    padding: 0;
  }
  .preview :global(blockquote) {
    border-left: 4px solid #e2e8f0;
    padding-left: 1em;
    margin-left: 0;
    color: #64748b;
  }
  .preview :global(ul),
  .preview :global(ol) {
    padding-left: 2em;
    margin-bottom: 1em;
  }
  .preview :global(li) {
    margin-bottom: 0.25em;
  }
  .preview :global(table) {
    border-collapse: collapse;
    width: 100%;
    margin-bottom: 1em;
  }
  .preview :global(table th),
  .preview :global(table td) {
    border: 1px solid #e2e8f0;
    padding: 0.5em 0.75em;
    text-align: left;
  }
  .preview :global(table th) {
    font-weight: 600;
  }
  .preview :global(img) {
    max-width: 100%;
  }
  .preview :global(a) {
    color: #7c3aed;
    text-decoration: underline;
  }
</style>
