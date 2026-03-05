<script lang="ts">
  import { AlertTriangle } from "lucide-svelte";
  import { theme } from "$lib/stores/editor";

  interface Props {
    open: boolean;
    onRecover: () => void;
    onDiscard: () => void;
  }

  let { open, onRecover, onDiscard }: Props = $props();

  let currentTheme = $state<"light" | "dark">("light");

  theme.subscribe((t) => (currentTheme = t));

  function handleBackdropClick(e: MouseEvent) {
    if (e.target === e.currentTarget) {
      onDiscard();
    }
  }

  function handleKeydown(e: KeyboardEvent) {
    if (e.key === "Escape") {
      onDiscard();
    }
  }
</script>

{#if open}
  <!-- svelte-ignore a11y_no_static_element_interactions -->
  <div
    class="fixed inset-0 z-50 flex items-center justify-center bg-black/50"
    onclick={handleBackdropClick}
    onkeydown={handleKeydown}
  >
    <div
      class="relative rounded-xl shadow-xl p-6 w-96
        {currentTheme === 'dark'
        ? 'bg-[#1e1e2e] text-[#cdd6f4] border border-[#313244]'
        : 'bg-white text-[#1e1e2e] border border-[#e2e8f0]'}"
    >
      <div class="flex flex-col items-center gap-4">
        <div
          class="rounded-full p-3
            {currentTheme === 'dark'
            ? 'bg-[#f9e2af]/10'
            : 'bg-[#fef3c7]'}"
        >
          <AlertTriangle
            size={32}
            class={currentTheme === 'dark' ? 'text-[#f9e2af]' : 'text-[#f59e0b]'}
          />
        </div>

        <h2 class="text-xl font-semibold">Unsaved Work Detected</h2>

        <p
          class="text-sm text-center {currentTheme === 'dark' ? 'text-[#a6adc8]' : 'text-[#64748b]'}"
        >
          OtterMark found unsaved content from a previous session. Would you
          like to recover it?
        </p>

        <div class="flex gap-3 w-full mt-2">
          <button
            class="flex-1 px-4 py-2 rounded-lg font-medium transition-colors
              {currentTheme === 'dark'
              ? 'bg-[#313244] text-[#a6adc8] hover:bg-[#45475a]'
              : 'bg-[#f1f5f9] text-[#64748b] hover:bg-[#e2e8f0]'}"
            onclick={onDiscard}
          >
            Discard
          </button>

          <button
            class="flex-1 px-4 py-2 rounded-lg font-medium transition-colors
              {currentTheme === 'dark'
              ? 'bg-[#89b4fa] text-[#1e1e2e] hover:bg-[#b4d0fb]'
              : 'bg-[#3b82f6] text-white hover:bg-[#2563eb]'}"
            onclick={onRecover}
          >
            Recover
          </button>
        </div>
      </div>
    </div>
  </div>
{/if}
