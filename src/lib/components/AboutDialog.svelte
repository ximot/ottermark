<script lang="ts">
  import { X } from "lucide-svelte";
  import { getVersion } from "@tauri-apps/api/app";
  import { theme } from "$lib/stores/editor";

  interface Props {
    open: boolean;
    onClose: () => void;
  }

  let { open, onClose }: Props = $props();

  let currentTheme = $state<"light" | "dark">("light");
  let version = $state("...");

  theme.subscribe((t) => (currentTheme = t));

  getVersion().then((v) => (version = v));

  function handleBackdropClick(e: MouseEvent) {
    if (e.target === e.currentTarget) {
      onClose();
    }
  }

  function handleKeydown(e: KeyboardEvent) {
    if (e.key === "Escape") {
      onClose();
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
      class="relative rounded-xl shadow-xl p-6 w-80 text-center
        {currentTheme === 'dark'
        ? 'bg-[#1e1e2e] text-[#cdd6f4] border border-[#313244]'
        : 'bg-white text-[#1e1e2e] border border-[#e2e8f0]'}"
    >
      <button
        class="absolute top-3 right-3 p-1 rounded-md transition-colors
          {currentTheme === 'dark'
          ? 'hover:bg-[#313244] text-[#6c7086]'
          : 'hover:bg-[#f1f5f9] text-[#94a3b8]'}"
        onclick={onClose}
        title="Close"
      >
        <X size={16} />
      </button>

      <div class="flex flex-col items-center gap-3 mt-2">
        <img
          src="/ottermark-icon.jpg"
          alt="OtterMark"
          class="w-20 h-20 rounded-2xl"
        />

        <h2 class="text-xl font-semibold">OtterMark</h2>
        <p
          class="text-sm {currentTheme === 'dark' ? 'text-[#6c7086]' : 'text-[#94a3b8]'}"
        >
          v{version}
        </p>
        <p
          class="text-sm {currentTheme === 'dark' ? 'text-[#a6adc8]' : 'text-[#64748b]'}"
        >
          Markdown editor
        </p>

        <div
          class="mt-2 text-xs {currentTheme === 'dark' ? 'text-[#6c7086]' : 'text-[#94a3b8]'}"
        >
          Made by
          <a
            href="https://github.com/ximot"
            target="_blank"
            rel="noopener noreferrer"
            class="underline {currentTheme === 'dark'
              ? 'text-[#89b4fa] hover:text-[#b4d0fb]'
              : 'text-[#3b82f6] hover:text-[#2563eb]'}"
          >
            Tomasz 'XimoT' Wyderka
          </a> 
          <i>🦦</i>
        </div>
      </div>
    </div>
  </div>
{/if}
