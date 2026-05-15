// エラーメッセージ表示用の関数
function showError(message) {
  const errorDiv = document.getElementById('error-messages');
  if (errorDiv) {
    errorDiv.innerHTML = `
      <div class="alert alert-danger" role="alert">
        ${message}
      </div>
    `;
    errorDiv.scrollIntoView({ behavior: 'smooth' });
  } else {
    // error-messages要素が見つからない場合はalertにフォールバック
    alert(message);
  }
}

// 成功メッセージ表示用の関数
function showSuccess(message) {
  const successDiv = document.getElementById('success-messages');
  if (successDiv) {
    successDiv.innerHTML = `
      <div class="alert alert-success" role="alert">
        ${message}
      </div>
    `;
    successDiv.scrollIntoView({ behavior: 'smooth' });
  } else {
    // success-messages要素が見つからない場合はalertにフォールバック
    alert(message);
  }
}

// 画面切り替え関数を追加
function showScreen(screen) {
  document.getElementById('initial-screen').style.display = 'none';
  document.getElementById('recording-screen').style.display = 'none';
  document.getElementById('preview-area').style.display = 'none';

  document.getElementById(screen).style.display = 'block';
}

document.addEventListener('turbo:load', () => {
  const page = document.getElementById('recording-page');
  if (!page) return;

  const startButton = document.getElementById('start-recording');
  const stopRecordingButton = document.getElementById('stop-recording');
  const recordingDuration = document.getElementById('recording-duration');
  const saveForm = document.getElementById('save-recording-form');
  const durationField = document.getElementById('duration-field');
  const backToInitialButton = document.getElementById('back-to-initial');

  if (!startButton || !stopRecordingButton || !recordingDuration) return;

  if (backToInitialButton) {
    backToInitialButton.addEventListener('click', () => {
      const confirmed = confirm(
        'この録音はまだ保存されていません。\n戻ると録音が消えてしまいますが､よろしいですか？'
      );

      if (!confirmed) return;

      clearMessages();

      const audioPlayer = document.getElementById('audio-player');
      const seekBar = document.getElementById('seek-bar');
      const currentTime = document.getElementById('current-time');
      const previewDuration = document.getElementById('preview-duration');

      if (audioPlayer) {
        audioPlayer.pause();
        audioPlayer.currentTime = 0;
        audioPlayer.src = '';
      }

      if (seekBar) seekBar.value = 0;
      if (currentTime) currentTime.textContent = '00:00';
      if (previewDuration) previewDuration.textContent = '00:00';
      if (durationField) durationField.value = '';

      recordedAudioBlob = null;
      audioChunks = [];
      recordingSeconds = 0;
      updateTimer(0);

      showScreen('initial-screen');
    });
  }

  let audioControlsInitialized = false;
  let mediaRecorder;
  let audioChunks = [];
  let timerInterval;
  let recordingSeconds = 0;
  let selectedMimeType = '';
  let selectedFileExtension = '';
  let recordedAudioBlob = null;

  const pathParts = window.location.pathname.split('/');
  const childId = pathParts[pathParts.indexOf('children') + 1];

  showScreen('initial-screen');

  function updateSeekBarProgress(seekBar) {
    const value = seekBar.value || 0;
    seekBar.style.setProperty('--progress', `${value}%`);
  }

  function updateTimer(seconds) {
    const minutes = Math.floor(seconds / 60).toString().padStart(2, '0');
    const secs = (seconds % 60).toString().padStart(2, '0');
    recordingDuration.textContent = `${minutes}:${secs}`;
  }

  startButton.addEventListener('click', async () => {
    clearMessages();
    showScreen('recording-screen');

    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });

      if (MediaRecorder.isTypeSupported('audio/mp4')) {
        selectedMimeType = 'audio/mp4';
        selectedFileExtension = 'mp4';
      } else if (MediaRecorder.isTypeSupported('audio/aac')) {
        selectedMimeType = 'audio/aac';
        selectedFileExtension = 'aac';
      } else if (MediaRecorder.isTypeSupported('audio/mpeg')) {
        selectedMimeType = 'audio/mpeg';
        selectedFileExtension = 'mp3';
      } else {
        selectedMimeType = 'audio/webm';
        selectedFileExtension = 'webm';
      }

      console.log('選択された MIME タイプ:', selectedMimeType);

      mediaRecorder = new MediaRecorder(stream, { mimeType: selectedMimeType });
      audioChunks = [];

      mediaRecorder.addEventListener('dataavailable', (event) => {
        audioChunks.push(event.data);
      });

      mediaRecorder.addEventListener('stop', () => {
        stream.getTracks().forEach(track => track.stop());
        const audioBlob = new Blob(audioChunks, { type: selectedMimeType });
        showPreview(audioBlob);
      });

      mediaRecorder.start();
      recordingSeconds = 0;

      timerInterval = setInterval(() => {
        recordingSeconds++;
        updateTimer(recordingSeconds);
      }, 1000);

      startButton.disabled = true;
      stopRecordingButton.disabled = false;
    } catch (error) {
      console.error('マイクへのアクセスエラー:', error);
      showError('マイクへのアクセスが許可されていません。ブラウザの設定を確認してください。');
    }
  });

  stopRecordingButton.addEventListener('click', () => {

    if (mediaRecorder && mediaRecorder.state === 'recording') {
      mediaRecorder.stop();
      clearInterval(timerInterval);

      startButton.disabled = false;
      stopRecordingButton.disabled = true;
    }
  });

  function showPreview(audioBlob) {
    recordedAudioBlob = audioBlob;

    const audioUrl = URL.createObjectURL(audioBlob);
    const audioPlayer = document.getElementById('audio-player');
    audioPlayer.src = audioUrl;

    const previewDuration = document.getElementById('preview-duration');
    const minutes = Math.floor(recordingSeconds / 60).toString().padStart(2, '0');
    const seconds = (recordingSeconds % 60).toString().padStart(2, '0');
    previewDuration.textContent = `${minutes}:${seconds}`;

    const durationField = document.getElementById('duration-field');
    if (durationField) {
      durationField.value = recordingSeconds;
    }

    showScreen('preview-area');
    setupAudioControls();
  }

  function clearMessages() {
    const errorMessages = document.getElementById('error-messages');
    const successMessages = document.getElementById('success-messages');

    if (errorMessages) errorMessages.innerHTML = '';
    if (successMessages) successMessages.innerHTML = '';
  }

  function setupFormSubmit() {
    if (!saveForm) return;

    const saveButton = document.getElementById('save-button');

    saveForm.addEventListener('submit', async (e) => {
      e.preventDefault();

      clearMessages();

      // 二重送信防止
      if (saveButton && saveButton.disabled) return;

      if (!recordedAudioBlob) {
        showError('保存する音声がありません。先に録音してください。');
        return;
      }

      const formData = new FormData(saveForm);
      formData.set(
        'recording[audio]',
        recordedAudioBlob,
        `recording.${selectedFileExtension}`
      );

      // 保存中の表示
      if (saveButton) {
        saveButton.disabled = true;
        saveButton.value = '保存中…';
      }

      try {
        const token = document.querySelector('[name="csrf-token"]').content;

        const response = await fetch(saveForm.action, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': token,
            'Accept': 'application/json'
          },
          body: formData
        });

        const data = await response.json();

        if (response.ok) {
          clearMessages();
          showSuccess('録音を保存しました！');

          if (saveButton) {
            saveButton.value = '保存しました';
          }

          setTimeout(() => {
            window.location.href = `/children/${childId}/recordings/${data.recording_id}`;
          }, 800);
        } else {
          showError(data.message || '保存に失敗しました。もう一度お試しください。');

          if (saveButton) {
            saveButton.disabled = false;
            saveButton.value = '保存';
          }
        }
      } catch (error) {
        console.error('保存エラー:', error);
        showError('保存中にエラーが発生しました。');

        if (saveButton) {
          saveButton.disabled = false;
          saveButton.value = '保存';
        }
      }
    });
  }

  // ▶ 再生ボタン制御
  function setupAudioControls() {
    if (audioControlsInitialized) return;

    const audioPlayer = document.getElementById('audio-player');
    const playToggleButton = document.getElementById('play-toggle-button');
    const playIcon = document.getElementById('play-icon');
    const seekBar = document.getElementById('seek-bar');
    const currentTime = document.getElementById('current-time');

    if (!audioPlayer || !playToggleButton || !playIcon) {
      console.log('audio controls not found');
      return;
    }

    audioControlsInitialized = true;

    playToggleButton.addEventListener('click', () => {
      if (audioPlayer.paused) {
        audioPlayer.play();
        playIcon.classList.replace('fa-play', 'fa-pause');
      } else {
        audioPlayer.pause();
        playIcon.classList.replace('fa-pause', 'fa-play');
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
  }

  setupFormSubmit();
});
