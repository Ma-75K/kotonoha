console.log("flash_message.js loaded")

const setupFlashMessages = () => {
  console.log("setupFlashMessages fired")

  const flashMessages = document.querySelectorAll(".auto-close-flash")
  console.log(flashMessages)

  flashMessages.forEach((message) => {
    setTimeout(() => {
      message.style.opacity = "0"

      setTimeout(() => {
        const wrapper = message.closest(".flash-wrapper")

        if (wrapper) {
          wrapper.remove()
        } else {
          message.remove()
        }
      }, 500)

    }, 3000)
  })
}

document.addEventListener("turbo:load", setupFlashMessages)
document.addEventListener("DOMContentLoaded", setupFlashMessages)
