document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".password-toggle-button").forEach((button) => {
    button.addEventListener("click", () => {
      const field = button.closest(".password-field-wrap").querySelector(".password-field");
      const icon = button.querySelector("i");

      const isHidden = field.type === "password";
      field.type = isHidden ? "text" : "password";

      icon.classList.toggle("fa-eye", isHidden);
      icon.classList.toggle("fa-eye-slash", !isHidden);
    });
  });
});
