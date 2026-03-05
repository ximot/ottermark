import { writable, derived } from "svelte/store";

export const content = writable("# Welcome to OtterMark\n\nStart writing your markdown here...\n");
export const currentFilePath = writable<string | null>(null);
export const isDirty = writable(false);
export const theme = writable<"light" | "dark">(
  typeof window !== "undefined" &&
    window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light",
);


export const windowTitle = derived(
  [currentFilePath, isDirty],
  ([$path, $dirty]) => {
    const fileName = $path ? $path.split("/").pop() : "Untitled";
    return `${$dirty ? "* " : ""}${fileName} - OtterMark`;
  },
);
