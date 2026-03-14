// ドロップダウンメニューの初期化
export function initDropdown() {
  const toggleButton = document.querySelector('.user-icon-button');
  const dropdownMenu = document.querySelector('.dropdown-menu');

  // 要素が存在しない場合は処理を中断
  if (!toggleButton || !dropdownMenu) return;

  // ボタンクリックでメニューを開閉
  toggleButton.addEventListener('click', (event) => {
    event.preventDefault();
    event.stopPropagation();
    dropdownMenu.classList.toggle('show');
  });

  // メニュー外をクリックしたら閉じる
  document.addEventListener('click', (event) => {
    if (!event.target.closest('.account-switcher')) {
      dropdownMenu.classList.remove('show');
    }
  });

  // メニュー項目をクリックしたら閉じる
  const dropdownItems = dropdownMenu.querySelectorAll('.dropdown-item');
  dropdownItems.forEach(item => {
    item.addEventListener('click', () => {
      dropdownMenu.classList.remove('show');
    });
  });
}
