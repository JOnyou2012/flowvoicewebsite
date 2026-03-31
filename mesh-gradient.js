(function () {
    'use strict';

    var TAU = Math.PI * 2;

    function MeshGradient(canvas, blobs, opts) {
        opts = opts || {};
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.blobs = blobs.map(function (b) {
            return {
                x: b.x, y: b.y,
                r: b.r || 0.35,
                color: b.color,
                vx: (Math.random() - 0.5) * 0.0003,
                vy: (Math.random() - 0.5) * 0.0003,
                ox: b.x, oy: b.y
            };
        });
        this.speed = opts.speed || 1;
        this.running = false;
        this._resize();
        this._bind = this._resize.bind(this);
        window.addEventListener('resize', this._bind);
    }

    MeshGradient.prototype._resize = function () {
        var dpr = Math.min(window.devicePixelRatio || 1, 2);
        var rect = this.canvas.getBoundingClientRect();
        this.canvas.width = rect.width * dpr;
        this.canvas.height = rect.height * dpr;
        this.ctx.scale(dpr, dpr);
        this.w = rect.width;
        this.h = rect.height;
    };

    MeshGradient.prototype.start = function () {
        if (this.running) return;
        this.running = true;
        var self = this;
        var t = 0;
        (function loop() {
            if (!self.running) return;
            t += 0.008 * self.speed;
            self._draw(t);
            requestAnimationFrame(loop);
        })();
    };

    MeshGradient.prototype.stop = function () {
        this.running = false;
        window.removeEventListener('resize', this._bind);
    };

    MeshGradient.prototype._draw = function (t) {
        var ctx = this.ctx;
        var w = this.w;
        var h = this.h;
        ctx.clearRect(0, 0, w, h);
        for (var i = 0; i < this.blobs.length; i++) {
            var b = this.blobs[i];
            var x = b.ox + Math.sin(t + i * 1.7) * 0.12;
            var y = b.oy + Math.cos(t + i * 2.3) * 0.10;
            b.x = x;
            b.y = y;
            var grad = ctx.createRadialGradient(x * w, y * h, 0, x * w, y * h, b.r * Math.max(w, h));
            grad.addColorStop(0, b.color);
            grad.addColorStop(1, 'rgba(0,0,0,0)');
            ctx.fillStyle = grad;
            ctx.fillRect(0, 0, w, h);
        }
    };

    window.MeshGradient = MeshGradient;
})();
