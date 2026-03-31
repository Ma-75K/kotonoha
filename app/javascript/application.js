import "./src/recordings"
import "./src/recording_show"
import "./src/children"
import "@hotwired/turbo-rails"
import "controllers"
import { initDropdown } from "src/dropdown"

// ページ読み込み時に初期化
document.addEventListener('turbo:load', () => {
  initDropdown();
});
