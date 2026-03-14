// import "./src/recordings"

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { initDropdown } from "src/dropdown"

// ページ読み込み時に初期化
document.addEventListener('turbo:load', () => {
  initDropdown();
});
