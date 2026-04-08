document.addEventListener("turbo:load", () => {
  const button = document.getElementById("hamburger-button");
  const overlay = document.getElementById("menu-overlay");
  const body = document.body;

  if (!button || !overlay) return;

  button.addEventListener("click", () => {
    body.classList.toggle("menu-open");
  });

  overlay.addEventListener("click", () => {
    body.classList.remove("menu-open");
  });
});
