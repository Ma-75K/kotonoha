import "./src/recordings"
import "./src/recording_show"
import "./src/children"
import "./src/password_toggle"
import "@hotwired/turbo-rails"
import "controllers"
import { initDropdown } from "src/dropdown"
import "./src/hamburger_menu"
import "./src/calendar"
import "./src/flash_message"

// ページ読み込み時に初期化
document.addEventListener('turbo:load', () => {
  initDropdown();
});
