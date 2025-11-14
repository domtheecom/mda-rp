const audio = new Audio();
const config = window.MDA_LOADING_CONFIG || {};
const tips = Array.isArray(config.tips) && config.tips.length ? config.tips : ['Stay sharp, cadet.'];
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
  tipsIndex = (tipsIndex + 1) % tips.length;
  appendResource(`Tip: ${tips[tipsIndex]}`);
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
    const maxPlayers = data.max || config.maxPlayers || 48;
    const currentCount = typeof data.count === 'number' ? data.count : 0;
    setText('currentPlayers', `Players: ${currentCount} / ${maxPlayers}`);
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

if (config.backgroundImage) {
  const overlay = document.getElementById('overlay');
  if (overlay) {
    overlay.style.setProperty('--mda-loading-background', `url('${config.backgroundImage}')`);
  }
}

if (config.logoImage) {
  const logo = document.getElementById('serverLogo');
  if (logo) {
    logo.src = config.logoImage;
  }
}

if (config.serverName) {
  setText('serverName', config.serverName);
  const serverNameRow = document.getElementById('serverNameRow');
  if (serverNameRow) {
    serverNameRow.textContent = `Server Name: ${config.serverName}`;
  }
}

if (config.serverTagline) {
  setText('serverTagline', config.serverTagline);
}

if (config.address) {
  const serverAddressRow = document.getElementById('serverAddressRow');
  if (serverAddressRow) {
    serverAddressRow.textContent = `Address: ${config.address}`;
  }
}

if (config.discordInvite) {
  setText('discordInvite', config.discordInvite.replace('https://', ''));
}

const welcomeName = config.serverName || 'Miami-Dade Academy RP';
appendResource(`Welcome to the ${welcomeName} loading experience.`);
appendResource(`Tip: ${tips[0]}`);
