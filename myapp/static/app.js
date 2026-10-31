/* TODO app logic. Shared theme + dialog wiring lives in the vendored
   dialogs.js: initTheme("<actions container selector>") and
   wireDialog("<dialog-id>", "<button-id>"). */

const help = wireDialog("help", "help_btn");

document.addEventListener("keydown", (event) => {
  if (event.key === "Escape" && help.isOpen) {
    help.close();
    return;
  }
  const tag = event.target.tagName;
  if (tag === "INPUT" || tag === "TEXTAREA" || tag === "SELECT" || event.target.isContentEditable) return;
  if (event.key === "?") {
    event.preventDefault();
    help.toggle();
  }
  // TODO: app shortcuts.
});

initTheme(".controls");
