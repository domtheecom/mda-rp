const selectors = {
  rpName: document.getElementById('hud-rp-name'),
  miamiId: document.getElementById('hud-miami-id'),
  employment: document.getElementById('hud-employment'),
  time: document.getElementById('hud-time'),
  street: document.getElementById('hud-street'),
  postal: document.getElementById('hud-postal'),
  money: document.getElementById('hud-money'),
  alert: document.getElementById('hud-alert')
};

window.addEventListener('message', (event) => {
  const data = event.data || {};
  if (data.action === 'updateHUD') {
    const payload = data.payload || {};
    selectors.rpName.textContent = payload.rpName || 'Recruit';
    selectors.miamiId.textContent = `Miami ID ${payload.miamiId || '0000'}`;
    selectors.employment.textContent = payload.employment || 'Employment Pending';
    selectors.time.textContent = payload.time || '';
    selectors.street.textContent = payload.street || '';
    selectors.postal.textContent = payload.postal ? `Postal ${payload.postal}` : '';
    selectors.money.textContent = payload.money || '';
  }

  if (data.action === 'setVisible') {
    document.getElementById('hud').style.display = data.visible ? 'flex' : 'none';
  }

  if (data.action === 'weatherAlert') {
    const message = data.message || '';
    selectors.alert.textContent = message;
    selectors.alert.style.display = message !== '' ? 'block' : 'none';
  }
});
