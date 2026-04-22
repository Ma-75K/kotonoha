document.addEventListener('turbo:load', () => {
  const detailPage = document.getElementById('recording-detail-page');
  if (!detailPage) return;

  const audioPlayer = document.getElementById('audio-player');
  const seekBar = document.getElementById('seek-bar');
  const currentTime = document.getElementById('current-time');
  const playToggleButton = document.getElementById('play-toggle-button');
  const playIcon = document.getElementById('play-icon');

  if (!audioPlayer || !seekBar || !currentTime || !playToggleButton || !playIcon) {
    console.log('show page audio controls not found');
    return;
  }

  function updateSeekBarProgress(seekBar) {
    const value = seekBar.value || 0;
    seekBar.style.setProperty('--progress', `${value}%`);
  }

  console.log('show page audio controls initialized');

  playToggleButton.addEventListener('click', async () => {
    try {
      if (audioPlayer.paused) {
        await audioPlayer.play();
        playIcon.classList.replace('fa-play', 'fa-pause');
      } else {
        audioPlayer.pause();
        playIcon.classList.replace('fa-pause', 'fa-play');
      }
    } catch (error) {
      console.error('再生エラー:', error);
    }
  });

  audioPlayer.addEventListener('ended', () => {
    playIcon.classList.replace('fa-pause', 'fa-play');
    seekBar.value = 0;
    updateSeekBarProgress(seekBar);
    currentTime.textContent = '00:00';
  });

  audioPlayer.addEventListener('timeupdate', () => {
    if (!audioPlayer.duration) return;

    const progress = (audioPlayer.currentTime / audioPlayer.duration) * 100;
    seekBar.value = progress;
    updateSeekBarProgress(seekBar);

    const minutes = Math.floor(audioPlayer.currentTime / 60).toString().padStart(2, '0');
    const seconds = Math.floor(audioPlayer.currentTime % 60).toString().padStart(2, '0');
    currentTime.textContent = `${minutes}:${seconds}`;
  });

  seekBar.addEventListener('input', () => {
    if (!audioPlayer.duration) return;

    const seekTime = audioPlayer.duration * (seekBar.value / 100);
    audioPlayer.currentTime = seekTime;
    updateSeekBarProgress(seekBar);
  });

  updateSeekBarProgress(seekBar);
});
