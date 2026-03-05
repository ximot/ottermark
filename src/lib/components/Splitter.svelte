<script lang="ts">
  import { theme } from '$lib/stores/editor';

  let {
    position = $bindable(50),
    min = 20,
    max = 80,
  }: {
    position: number;
    min?: number;
    max?: number;
  } = $props();

  let currentTheme = $state<"light" | "dark">("light");
  theme.subscribe((t) => (currentTheme = t));

  let dragging = $state(false);
  let containerEl: HTMLElement | null = null;

  function onPointerDown(e: PointerEvent) {
    e.preventDefault();
    dragging = true;
    containerEl = (e.currentTarget as HTMLElement).parentElement;

    const onPointerMove = (e: PointerEvent) => {
      if (!containerEl) return;
      const rect = containerEl.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const pct = (x / rect.width) * 100;
      position = Math.min(max, Math.max(min, pct));
    };

    const onPointerUp = () => {
      dragging = false;
      containerEl = null;
      window.removeEventListener('pointermove', onPointerMove);
      window.removeEventListener('pointerup', onPointerUp);
    };

    window.addEventListener('pointermove', onPointerMove);
    window.addEventListener('pointerup', onPointerUp);
  }
</script>

<!-- svelte-ignore a11y_no_static_element_interactions -->
<div
  class="splitter"
  class:dragging
  class:dark={currentTheme === 'dark'}
  onpointerdown={onPointerDown}
></div>

<style>
  .splitter {
    width: 4px;
    cursor: col-resize;
    flex-shrink: 0;
    background: transparent;
    border-left: 1px solid #e2e8f0;
    transition: background-color 0.15s;
  }

  .splitter.dark {
    border-left-color: #313244;
  }

  .splitter:hover,
  .splitter.dragging {
    background-color: rgba(59, 130, 246, 0.5);
  }
</style>
