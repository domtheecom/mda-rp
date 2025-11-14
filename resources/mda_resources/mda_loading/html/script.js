const audio = new Audio();
const config = window.MDA_LOADING_CONFIG;
let tipsIndex = 0;

function setText(id, value) {
  const element = document.getElementById(id);
  if (element) {
    element.textContent = value;
  }
}

function appendResource(text) {
  const list = document.getElementById('resourceList');
  if (!list) return;
  const item = document.createElement('li');
  item.textContent = text;
  list.prepend(item);
  while (list.children.length > 8) {
    list.removeChild(list.lastChild);
  }
}

function updateProgress(percent) {
  const progressBar = document.getElementById('progressBar');
  const loadingText = document.getElementById('loadingText');
  if (!progressBar || !loadingText) return;
  progressBar.style.width = `${percent}%`;
  loadingText.textContent = percent >= 100 ? 'Finalizing academy systems...' : `Loading assets (${percent.toFixed(0)}%)`;
}

function nextTip() {
  tipsIndex = (tipsIndex + 1) % config.tips.length;
  appendResource(`Tip: ${config.tips[tipsIndex]}`);
}

window.addEventListener('message', (event) => {
  const data = event.data || {};

  if (data.action === 'playMusic') {
    if (config.musicFile) {
      audio.src = config.musicFile;
      audio.loop = true;
      audio.volume = 0.45;
      audio.play().catch(() => {});
    }
  }

  if (data.action === 'stopMusic') {
    audio.pause();
  }

  if (data.action === 'setPlayerInfo') {
    setText('rpName', data.rpName || 'Recruit');
    setText('miamiId', data.miamiId || '0000');
    setText('discordTag', data.discord || 'Pending');
  }

  if (data.action === 'setPlayerCount') {
    setText('currentPlayers', `Players: ${data.count} / ${config.maxPlayers}`);
  }

  if (data.action === 'setProgress') {
    updateProgress(data.value || 0);
  }

  if (data.action === 'resourceStart') {
    appendResource(`Loaded: ${data.resource}`);
  }

  if (data.action === 'setTip') {
    appendResource(`Tip: ${data.tip}`);
  }
});

setInterval(nextTip, 10000);

setText('discordInvite', config.discordInvite.replace('https://', ''));
appendResource('Welcome to the Miami-Dade Academy RP loading experience.');
appendResource(`Tip: ${config.tips[0]}`);
