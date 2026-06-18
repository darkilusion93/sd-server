(function () {
    const RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'jsfour-register';
    const post = (cbName, body) => fetch(`https://${RES}/${cbName}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(body || {})
    }).catch(() => {});

    const app = document.getElementById('app');
    const scrIdent = document.getElementById('screen-identity');
    const scrApp   = document.getElementById('screen-appearance');

    /* ═══════════ FASE 1 — IDENTIDADE ═══════════ */
    const sexBox = document.getElementById('sex');
    const fn = document.getElementById('firstname');
    const ln = document.getElementById('lastname');
    const dob = document.getElementById('dob');
    const height = document.getElementById('height');
    const hval = document.getElementById('hval');
    const err = document.getElementById('err');
    const submit = document.getElementById('submit');
    let sex = 'm';

    function resetIdentity() {
        sex = 'm';
        [...sexBox.children].forEach(b => b.classList.toggle('active', b.dataset.val === 'm'));
        fn.value = ''; ln.value = ''; dob.value = '';
        height.value = 180; hval.textContent = '180';
        err.classList.remove('show');
        submit.disabled = false; submit.style.opacity = '1';
    }

    sexBox.addEventListener('click', e => {
        const btn = e.target.closest('button'); if (!btn) return;
        sex = btn.dataset.val;
        [...sexBox.children].forEach(b => b.classList.toggle('active', b === btn));
        post('setSex', { sex });   // preview ao vivo do modelo
    });
    height.addEventListener('input', () => { hval.textContent = height.value; });
    dob.addEventListener('input', () => {
        let v = dob.value.replace(/\D/g, '').slice(0, 8);
        if (v.length > 4) v = v.slice(0, 2) + '/' + v.slice(2, 4) + '/' + v.slice(4);
        else if (v.length > 2) v = v.slice(0, 2) + '/' + v.slice(2);
        dob.value = v;
    });

    const nameRe = /^[A-Za-zÀ-ÿ' -]{2,20}$/;
    const validName = s => nameRe.test(s.trim());
    function validDob(s) {
        const m = s.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);
        if (!m) return false;
        const d = +m[1], mo = +m[2], y = +m[3];
        return mo >= 1 && mo <= 12 && d >= 1 && d <= 31 && y >= 1900 && y <= 2012;
    }
    const showErr = m => { err.textContent = m; err.classList.add('show'); };

    function doIdentity() {
        const firstname = fn.value.trim(), lastname = ln.value.trim(), birth = dob.value.trim(), h = parseInt(height.value, 10);
        if (!validName(firstname)) return showErr('Primeiro nome inválido (2–20 letras).');
        if (!validName(lastname)) return showErr('Apelido inválido (2–20 letras).');
        if (!validDob(birth)) return showErr('Data de nascimento inválida (DD/MM/AAAA).');
        if (!(h >= 120 && h <= 220)) return showErr('Altura fora do intervalo (120–220 cm).');
        err.classList.remove('show');
        submit.disabled = true; submit.style.opacity = '.7';
        post('register', { sex, firstname, lastname, dob: birth, height: h });
    }
    submit.addEventListener('click', doIdentity);

    /* ═══════════ FASE 2 — APARÊNCIA ═══════════ */
    const CAT_ORDER = ['rosto', 'maquilhagem', 'cabelo', 'roupa', 'acessorios', 'outros'];
    const CAT_NAME = { rosto: 'Rosto', maquilhagem: 'Maquilhagem', cabelo: 'Cabelo', roupa: 'Roupa', acessorios: 'Acessórios', outros: 'Outros' };
    // z = altura ACIMA dos pés que a câmara mira (cabeça ~1.6, tronco ~1.1, corpo inteiro ~0.95)
    const CAT_CAM = {
        rosto: { dist: 0.9, z: 1.6 }, maquilhagem: { dist: 0.85, z: 1.62 }, cabelo: { dist: 0.95, z: 1.62 },
        roupa: { dist: 2.6, z: 0.95 }, acessorios: { dist: 1.8, z: 1.25 }, outros: { dist: 2.2, z: 1.05 }
    };
    // name -> [categoria, label]. Para overlays faciais expomos TIPO (_1) e COR (_3);
    // a opacidade (_2) é tratada automaticamente no client.lua (não é um controlo).
    const MAP = {
        // ── ROSTO ──
        face: ['rosto', 'Forma do rosto'], skin: ['rosto', 'Tom de pele'], eye_color: ['rosto', 'Cor dos olhos'],
        beard_1: ['rosto', 'Barba'], beard_3: ['rosto', 'Cor da barba'],
        eyebrows_1: ['rosto', 'Sobrancelhas'], eyebrows_3: ['rosto', 'Cor das sobrancelhas'],
        age_1: ['rosto', 'Envelhecimento'], complexion_1: ['rosto', 'Compleição'],
        moles_1: ['rosto', 'Sardas / sinais'], blemishes_1: ['rosto', 'Borbulhas'], sun_1: ['rosto', 'Bronzeado'],
        chest_1: ['rosto', 'Pelo no peito'], chest_3: ['rosto', 'Cor pelo peito'],
        // ── MAQUILHAGEM ──
        makeup_1: ['maquilhagem', 'Maquilhagem'], makeup_3: ['maquilhagem', 'Cor da maquilhagem'],
        blush_1: ['maquilhagem', 'Blush'], blush_3: ['maquilhagem', 'Cor do blush'],
        lipstick_1: ['maquilhagem', 'Batom'], lipstick_3: ['maquilhagem', 'Cor do batom'],
        // ── CABELO ──
        hair_1: ['cabelo', 'Cabelo'], hair_color_1: ['cabelo', 'Cor do cabelo'], hair_color_2: ['cabelo', 'Madeixas'],
        // ── ROUPA ──
        tshirt_1: ['roupa', 'Camisola interior'], tshirt_2: ['roupa', 'Cor camisola'],
        torso_1: ['roupa', 'Tronco / casaco'], torso_2: ['roupa', 'Cor tronco'],
        arms: ['roupa', 'Braços'], decals_1: ['roupa', 'Emblemas'],
        pants_1: ['roupa', 'Calças'], pants_2: ['roupa', 'Cor calças'],
        shoes_1: ['roupa', 'Sapatos'], shoes_2: ['roupa', 'Cor sapatos'],
        mask_1: ['roupa', 'Máscara'], bproof_1: ['roupa', 'Colete'],
        // ── ACESSÓRIOS ──
        chain_1: ['acessorios', 'Colar'], chain_2: ['acessorios', 'Cor do colar'],
        glasses_1: ['acessorios', 'Óculos'], glasses_2: ['acessorios', 'Cor óculos'],
        watches_1: ['acessorios', 'Relógio'], helmet_1: ['acessorios', 'Chapéu / capacete'],
        bracelets_1: ['acessorios', 'Pulseira'], bags_1: ['acessorios', 'Mochila'], ears_1: ['acessorios', 'Brincos']
    };
    const HIDE = new Set(['sex']);

    const catsBox = document.getElementById('cats');
    const compsBox = document.getElementById('components');
    const rotL = document.getElementById('rotL');
    const rotR = document.getElementById('rotR');
    const finish = document.getElementById('finish');

    let comps = [];           // [{name, label, cat, min, value}]
    let maxOf = {};           // name -> max
    let activeCat = 'rosto';

    function buildAppearance(components, maxVals) {
        comps = [];
        maxOf = {};
        (components || []).forEach(c => {
            const m = MAP[c.name];
            if (!m) return;   // só expomos tipo/cor mapeados; opacidade/texturas são automáticas
            comps.push({
                name: c.name,
                label: m[1],
                cat: m[0],
                min: typeof c.min === 'number' ? c.min : 0,
                value: typeof c.value === 'number' ? c.value : 0
            });
        });
        Object.assign(maxOf, maxVals || {});

        // categorias com pelo menos 1 componente
        const present = CAT_ORDER.filter(cat => comps.some(c => c.cat === cat));
        catsBox.innerHTML = '';
        present.forEach(cat => {
            const b = document.createElement('button');
            b.className = 'cat' + (cat === present[0] ? ' active' : '');
            b.textContent = CAT_NAME[cat];
            b.dataset.cat = cat;
            b.addEventListener('click', () => selectCat(cat));
            catsBox.appendChild(b);
        });
        activeCat = present[0] || 'rosto';
        renderRows();
        applyCam(activeCat);
    }

    function selectCat(cat) {
        activeCat = cat;
        [...catsBox.children].forEach(b => b.classList.toggle('active', b.dataset.cat === cat));
        renderRows();
        applyCam(cat);
    }

    function applyCam(cat) {
        const cam = CAT_CAM[cat] || CAT_CAM.rosto;
        post('skinZoom', cam);
    }

    function maxFor(c) { const m = maxOf[c.name]; return (typeof m === 'number' && m >= 0) ? m : 0; }

    function renderRows() {
        compsBox.innerHTML = '';
        comps.filter(c => c.cat === activeCat).forEach(c => {
            const row = document.createElement('div');
            row.className = 'crow';
            const name = document.createElement('div'); name.className = 'cname'; name.textContent = c.label;
            const step = document.createElement('div'); step.className = 'cstep';
            const bL = document.createElement('button'); bL.textContent = '‹';
            const val = document.createElement('div'); val.className = 'cval';
            const bR = document.createElement('button'); bR.textContent = '›';
            const refresh = () => { val.textContent = (c.value + 1) + ' / ' + (maxFor(c) + 1); };
            refresh();
            const change = dir => {
                const max = maxFor(c);
                let v = c.value + dir;
                if (v > max) v = c.min; else if (v < c.min) v = max;
                c.value = v; refresh();
                post('skinChange', { name: c.name, value: v }).then(r => r && r.json && r.json()).then(d => {
                    if (d && d.maxVals) { Object.assign(maxOf, d.maxVals); refresh(); }
                }).catch(() => {});
            };
            bL.addEventListener('click', () => change(-1));
            bR.addEventListener('click', () => change(1));
            step.appendChild(bL); step.appendChild(val); step.appendChild(bR);
            row.appendChild(name); row.appendChild(step);
            compsBox.appendChild(row);
        });
    }

    rotL.addEventListener('click', () => post('skinRotate', { delta: -25 }));
    rotR.addEventListener('click', () => post('skinRotate', { delta: 25 }));
    finish.addEventListener('click', () => { finish.disabled = true; finish.style.opacity = '.7'; post('skinSave', {}); });

    /* ═══════════ mensagens do client.lua ═══════════ */
    window.addEventListener('message', e => {
        const d = e.data || {};
        if (d.action === 'open') {
            resetIdentity();
            scrApp.classList.add('hidden');
            scrIdent.classList.remove('hidden');
            app.classList.remove('hidden');
            setTimeout(() => fn.focus(), 350);
        } else if (d.action === 'appearance') {
            scrIdent.classList.add('hidden');
            scrApp.classList.remove('hidden');
            finish.disabled = false; finish.style.opacity = '1';
            buildAppearance(d.components, d.maxVals);
        } else if (d.action === 'close') {
            app.classList.add('hidden');
        }
    });

    document.addEventListener('keydown', e => {
        if (app.classList.contains('hidden')) return;
        if (e.key === 'Enter' && !scrIdent.classList.contains('hidden')) doIdentity();
    });
})();
