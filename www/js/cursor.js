(function () {
  if (!window.matchMedia('(pointer: fine)').matches) { return; }
  var reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  var cur = document.createElement('div');
  cur.className = 'cur';
  document.body.appendChild(cur);

  var dot = document.createElement('div');
  dot.className = 'cur__dot';
  document.body.appendChild(dot);

  var label = document.createElement('div');
  label.className = 'cur__label';
  label.innerHTML = '<svg viewBox="0 0 72 72" width="72" height="72">' +
    '<defs><path id="cur-arc" d="M 8,36 A 28,28 0 0 0 64,36" /></defs>' +
    '<text text-anchor="middle"><textPath href="#cur-arc" startOffset="50%"></textPath></text>' +
    '</svg>';
  document.body.appendChild(label);
  var labelPath = label.querySelector('textPath');

  document.documentElement.classList.add('pointer-fine');

  var IDLE_SCALE = 14 / 72;

  var tx = window.innerWidth / 2, ty = window.innerHeight / 2;
  var x = tx, y = ty;
  var targetScale = IDLE_SCALE, scale = IDLE_SCALE;

  function place(px, py, s) {
    var t = 'translate3d(' + px + 'px,' + py + 'px,0)';
    cur.style.transform = t + ' scale(' + s + ')';
    dot.style.transform = t;
    label.style.transform = t;
  }
  place(x, y, scale);

  var running = false;

  function settled() {
    return Math.abs(tx - x) < 0.05 && Math.abs(ty - y) < 0.05 && Math.abs(targetScale - scale) < 0.002;
  }

  function loop() {
    x += (tx - x) * 0.18;
    y += (ty - y) * 0.18;
    scale += (targetScale - scale) * 0.2;
    place(x, y, scale);

    if (settled()) {
      running = false;
      return;
    }
    requestAnimationFrame(loop);
  }

  function ensureRunning() {
    if (!running) {
      running = true;
      requestAnimationFrame(loop);
    }
  }

  window.addEventListener('mousemove', function (e) {
    tx = e.clientX;
    ty = e.clientY;
    if (reduced) {
      x = tx; y = ty;
      place(x, y, scale);
    } else {
      ensureRunning();
    }
  });

  function ariaLabelOf(link) {
    var el = link.hasAttribute('aria-label') ? link : link.querySelector('[aria-label]');
    return el ? el.getAttribute('aria-label') : '';
  }

  var navCursorLabels = [
    { match: function (link) { return ariaLabelOf(link) === 'Home'; }, label: 'HOME' },
    { match: function (link) { return (link.getAttribute('href') || '').indexOf('about-me') !== -1; }, label: 'ABOUT ME' }
  ];

  document.querySelectorAll('.navbar-nav .nav-link').forEach(function (link) {
    var found = navCursorLabels.filter(function (n) { return n.match(link); })[0];
    if (found) { link.setAttribute('data-cursor', found.label); }
  });

  document.querySelectorAll('[data-cursor]').forEach(function (el) {
    el.addEventListener('mouseenter', function () {
      dot.classList.add('cur__dot--on');
      labelPath.textContent = el.getAttribute('data-cursor') || '';
      label.classList.add('cur__label--on');
      targetScale = 1;
      if (reduced) { scale = 1; place(x, y, scale); } else { ensureRunning(); }
    });
    el.addEventListener('mouseleave', function () {
      dot.classList.remove('cur__dot--on');
      label.classList.remove('cur__label--on');
      targetScale = IDLE_SCALE;
      if (reduced) { scale = IDLE_SCALE; place(x, y, scale); } else { ensureRunning(); }
    });
  });
})();
