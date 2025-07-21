document.addEventListener("turbo:load", function () {
  const mapElement = document.getElementById("map");
  if (!mapElement) return;

  const latInput = document.getElementById("latitude");
  const lngInput = document.getElementById("longitude");

  // 初期位置（フォームに値があるならそれを使う）
  const defaultLat = parseFloat(latInput.value) || 35.681236;
  const defaultLng = parseFloat(lngInput.value) || 139.767125;

  const map = L.map("map").setView([defaultLat, defaultLng], 13);

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution: '&copy; OpenStreetMap contributors'
  }).addTo(map);

  const marker = L.marker([defaultLat, defaultLng], { draggable: true }).addTo(map);

  // ピンを動かしたら緯度経度を更新
  marker.on("dragend", function (e) {
    const position = marker.getLatLng();
    latInput.value = position.lat.toFixed(6);
    lngInput.value = position.lng.toFixed(6);
  });
});
