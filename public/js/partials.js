// js/partials.js
async function inject(targetId, url) {
  const host = document.getElementById(targetId);
  if (!host) return;
  const res = await fetch(url, { cache: "no-cache" });
  const html = await res.text();
  host.innerHTML = html;
}

  
  // make available globally
  window.inject = inject;
  