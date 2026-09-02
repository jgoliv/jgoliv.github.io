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
    '<defs><path id="cur-arc" d="M 8,36 A 28,28 0 0 1 64,36" /></defs>' +
    '<text text-anchor="middle"><textPath href="#cur-arc" startOffset="50%"></textPath></text>' +
    '</svg>';
  document.body.appendChild(label);
  var labelPath = label.querySelector('textPath');

  document.documentElement.classList.add('pointer-fine');

  var tx = window.innerWidth / 2, ty = window.innerHeight / 2;
  var x = tx, y = ty;

  function place(px, py) {
    var t = 'translate3d(' + px + 'px,' + py + 'px,0)';
    cur.style.transform = t;
    dot.style.transform = t;
    label.style.transform = t;
  }
  place(x, y);

  var running = false;

  function loop() {
    x += (tx - x) * 0.18;
    y += (ty - y) * 0.18;
    place(x, y);

    if (Math.abs(tx - x) < 0.05 && Math.abs(ty - y) < 0.05) {
      running = false;
      return;
    }
    requestAnimationFrame(loop);
  }

  window.addEventListener('mousemove', function (e) {
    tx = e.clientX;
    ty = e.clientY;
    if (reduced) {
      x = tx; y = ty;
      place(x, y);
    } else if (!running) {
      running = true;
      requestAnimationFrame(loop);
    }
  });

  document.querySelectorAll('[data-cursor]').forEach(function (el) {
    el.addEventListener('mouseenter', function () {
      cur.classList.add('cur--hover');
      dot.classList.add('cur__dot--on');
      labelPath.textContent = el.getAttribute('data-cursor') || '';
      label.classList.add('cur__label--on');
    });
    el.addEventListener('mouseleave', function () {
      cur.classList.remove('cur--hover');
      dot.classList.remove('cur__dot--on');
      label.classList.remove('cur__label--on');
    });
  });
})();
