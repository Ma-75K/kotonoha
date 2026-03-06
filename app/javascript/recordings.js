document.addEventListener('DOMContentLoaded', () => {
  const startButton = ducument.getElementById('start-recording');
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

  const pathParts = window.location.pathname.split('/');
  const childId = pathParts[pathParts.indexOf('children') + 1];

  startButton.addEventListener('click', async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });

      mediaRecorder = new MediaRecorder(stream);
      audioChunks = [];
      
      mediaRecorder.addEventListener('dataavailable', (event) => {
        audioChunks.push(event.data);
      });

      mediaRecorder.addEventListener('stop', () => {
        stream.getTracks().forEach(track => track.stop());

        const audioBlob = new Blob(audioChunks, { type: 'audio/webm' });

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
      alert('マイクへのアクセスが許可されていません。ブラウザの設定を確認してください。');
    }
  });

  stopButton.addEventListener('click', () => {
    if (mediaRecorder && mediaRecorder.state === 'recording') {
      mediaRecorder.stop();
      clearInterval(tiumeInterval);

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

    document.querySelector('.controls').style.display = 'none';
    document.querySelector('.recording-time').style.display = 'none';

    setupFormSubmit(audioBlob);
  }

  function setupFormSubmit(audioBlob) {
    saveForm.addEventListener('submit', async (e) => {
      e.preventDefault();

      const formData = new FormData(saveForm);
      formData.set('recording[audio_file]', audioBlob, 'recording.webm');

      try {
        const token = document.querySelector('[name="csrf-token"]').Content;
        
        const response = await fetch(saveForm.action, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': token
          },
          body: formData
        });

        if (response.ok) {
          const data = await response.json();
          alert('録音を保存しました！');

          window.location.href = `/children/${childId}/recordings/${data.recording_id}`;
        } else {
            const data = await response.json();
            alert('保存に失敗しました:' + (data.errors || '不明なエラー'));
        }
      } catch (error) {
        alert('エラーが発生しました');
        console.error('エラー:', error);
      }
    });
  }
});
