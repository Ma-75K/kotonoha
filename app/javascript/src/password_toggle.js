document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".password-toggle-button").forEach(button => {
    button.addEventListener("click", () => {
      const wrapper = button.closest(".password-field-wrap");
      const field = wrapper.querySelector(".password-field");
      const icon = button.querySelector("i");

      const isHidden = field.type === "password";

      field.type = isHidden ? "text" : "password";

      icon.classList.toggle("fa-eye");
      icon.classList.toggle("fa-eye-slash");
    });
  });
});
