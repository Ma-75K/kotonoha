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

document.addEventListener('DOMContentLoaded', () => {

  showScreen('initial-screen');

  const startButton = document.getElementById('start-recording');
  const stopButton = document.getElementById('stop-recording');
  const recordingDuration = document.getElementById('recording-duration');
  const previewArea = document.getElementById('preview-area');
  const saveForm = document.getElementById('save-recording-form');
  const durationField = document.getElementById('duration-field');

  let mediaRecorder;
  let audioChunks = [];
  let startTime;
  let timerInterval;
  let recordingSeconds = 0;
  let selectedMimeType = '';
  let selectedFileExtension = '';

  const pathParts = window.location.pathname.split('/');
  const childId = pathParts[pathParts.indexOf('children') + 1];

  function updateTimer(seconds) {
    const minutes = Math.floor(seconds / 60).toString().padStart(2, '0');
    const secs = (seconds % 60).toString().padStart(2, '0');
    recordingDuration.textContent = `${minutes}:${secs}`;
  }

  startButton.addEventListener('click', async () => {
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
      } else if (MediaRecorder.isTypeSupported('audio/webm')) {
        selectedMimeType = 'audio/webm';
        selectedFileExtension = 'webm';
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
      startTime = Date.now();
      recordingSeconds = 0;

      timerInterval = setInterval(() => {
        recordingSeconds++;
        updateTimer(recordingSeconds);
      }, 1000);

      startButton.disabled = true;
      stopButton.disabled = false;

    } catch (error) {
      console.error('マイクへのアクセスエラー:', error);
      ahowError('マイクへのアクセスが許可されていません。ブラウザの設定を確認してください。');
    }
  });

  stopButton.addEventListener('click', () => {
    if (mediaRecorder && mediaRecorder.state === 'recording') {
      mediaRecorder.stop();
      clearInterval(timerInterval);

      startButton.disabled = false;
      stopButton.disabled = true;
    }
  });

  function showPreview(audioBlob) {
    const audioUrl = URL.createObjectURL(audioBlob);
    const audioPlayer = document.getElementById('audio-player');
    audioPlayer.src = audioUrl;

    const previewDuration = document.getElementById('preview-duration');
    const minutes = Math.floor(recordingSeconds / 60).toString().padStart(2, '0');
    const seconds = (recordingSeconds % 60).toString().padStart(2, '0');
    previewDuration.textContent = `${minutes}:${seconds}`;

    durationField.value = recordingSeconds;

    previewArea.style.display = 'block';

    document.getElementById('audio-preview').style.display = 'block';

    document.querySelector('.controls').style.display = 'none';
    document.querySelector('.recording-time').style.display = 'none';

    setupFormSubmit(audioBlob);
  }

  function setupFormSubmit(audioBlob) {
    // フォームのクローンを作成
    const newSaveForm = saveForm.cloneNode(true);
    saveForm.parentNode.replaceChild(newSaveForm, saveForm);
    // 新しいフォームにイベントリスナーを追加
    newSaveForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      // 新しいフォームからFormDataを取得
      const formData = new FormData(newSaveForm);
      formData.set('recording[audio_file]', audioBlob, `recording.${selectedFileExtension}`);

      try {
        const token = document.querySelector('[name="csrf-token"]').content;
        // newSaveFormのactionを使用
        const response = await fetch(newSaveForm.action, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': token
          },
          body: formData
        });

        if (response.ok) {
          const data = await response.json();
          showSuccess('録音を保存しました！');

          setTimeout(() => {
          window.location.href = `/children/${childId}/recordings/${data.recording_id}`;
          }, 1000);
        } else {
          const data = await response.json();
          showError('保存に失敗しました:' + (data.errors || '不明なエラー'));
        }
      } catch (error) {
        showError('エラーが発生しました');
        console.error('エラー:', error);
      }
    });
  }
});
