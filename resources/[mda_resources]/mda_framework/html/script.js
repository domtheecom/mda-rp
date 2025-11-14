const meters = {
  health: document.getElementById('meter-health'),
  hunger: document.getElementById('meter-hunger'),
  thirst: document.getElementById('meter-thirst'),
  stamina: document.getElementById('meter-stamina'),
  stress: document.getElementById('meter-stress')
};

const wallet = document.getElementById('wallet');
const bank = document.getElementById('bank');

window.addEventListener('message', (event) => {
  const data = event.data || {};
  if (data.action === 'updateStatus') {
    const payload = data.payload || {};
    Object.entries(payload.meters || {}).forEach(([key, value]) => {
      if (meters[key]) {
        meters[key].style.width = `${Math.min(100, Math.max(0, value))}%`;
      }
    });

    if (payload.accounts) {
      wallet.textContent = payload.accounts.wallet || '$0';
      bank.textContent = payload.accounts.bank || '$0';
    }
  }
});
