document.addEventListener('turbo:load', () => {
  const calendarEl = document.getElementById('recordings-calendar');
  if (!calendarEl) return;

  const eventsUrl = calendarEl.dataset.eventsUrl;

  const calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'dayGridMonth',
    locale: 'ja',

    buttonText: {
      today: '今日'
    },

    height: 'auto',
    events: eventsUrl,

    eventClick: function(info) {
      info.jsEvent.preventDefault();

      window.location.href = info.event.url;
    }
  });

  calendar.render();
});
