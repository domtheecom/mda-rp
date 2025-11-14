const speedElement = document.getElementById('speed');
const gearElement = document.getElementById('gear');
const vehicleElement = document.getElementById('vehicle');
const container = document.getElementById('speedometer');

window.addEventListener('message', (event) => {
  const data = event.data || {};
  if (data.action === 'updateSpeed') {
    const payload = data.payload || {};
    speedElement.textContent = String(payload.speed || 0).padStart(3, '0');
    gearElement.textContent = payload.gear || 'P';
    vehicleElement.textContent = payload.vehicle || 'Unknown';
    container.style.display = payload.visible ? 'flex' : 'none';
  }
});

container.style.display = 'none';
