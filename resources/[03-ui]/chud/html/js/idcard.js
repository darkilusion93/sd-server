function idcardInventorySetup(data) {
    $("#otherInventory").html("");

    $.each(data.itemList, function (index, item) {
        $("#otherInventory").append(/*html*/`
            <div class="idcard-container" id="idcard-${index}">
                <div class="idcard-img-container">
                    <div class="idcard-title">${item.title}</div>
                    ${item.param1 ? /*html*/`<div class="idcard-name"><span>${item.param1.label}:</span>${item.param1.value}</div>` : ""}
                    ${item.param2 ? /*html*/`<div class="idcard-birthdate"><span>${item.param2.label}:</span>${item.param2.value}</div>` : ""}
                    ${item.param3 ? /*html*/`<div class="idcard-sex"><span>${item.param3.label}:</span>${item.param3.value}</div>` : ""}
                    ${item.param4 ? /*html*/`<div class="idcard-height"><span>${item.param4.label}:</span>${item.param4.value}</div>` : ""}
                    ${item.param5 ? /*html*/`<div class="idcard-citizenid"><span>${item.param5.label}:</span>${item.param5.value}</div>` : ""}
                    ${item.signature ? /*html*/`<div class="idcard-signature">${item.signature}</div>` : ""}
                    ${item.mugshot ? /*html*/`<div class="idcard-mugshot-container"><img class="idcard-mugshot" src="${data.mugshot}" alt="Mugshot"></div>` : ""}
                    <img src="img/idcard/${item.img}.png">
                </div>
            </div>`
        );

        $(`#idcard-${index}`).on("click", function () {
            $.post("http://chud/idcardClick", JSON.stringify({type: index}));
        });
    });
}


// replace existing idcardBlobSetup with this:
function idcardBlobSetup(data) {
    // helper: wait for all images inside element to load (or error)
    function waitForImages(el, timeoutMs = 2000) {
        const imgs = Array.from(el.querySelectorAll('img'));
        if (imgs.length === 0) return Promise.resolve();

        return new Promise((resolve) => {
            let remaining = imgs.length;
            const onDone = () => {
                if (--remaining <= 0) resolve();
            };
            imgs.forEach(img => {
                if (img.complete && (img.naturalWidth || img.naturalHeight)) {
                    onDone();
                } else {
                    const t = setTimeout(() => { // fallback in case onload never fires
                        img.removeEventListener('load', onDone);
                        img.removeEventListener('error', onDone);
                        onDone();
                    }, timeoutMs);
                    img.addEventListener('load', () => { clearTimeout(t); onDone(); });
                    img.addEventListener('error', () => { clearTimeout(t); onDone(); });
                }
            });
        });
    }

    // create off-screen container
    const tempContainer = document.createElement('div');
    tempContainer.style.position = 'absolute';
    tempContainer.style.left = '-9999px';
    tempContainer.style.top = '-9999px';
    tempContainer.style.width = '31%';
    tempContainer.style.height = '53%';
    tempContainer.style.pointerEvents = 'none';
    tempContainer.style.opacity = '1'; // must be visible to html2canvas
    document.body.appendChild(tempContainer);

    // iterate and build each idcard element inside tempContainer, capture and remove
    (async () => {
        try {
            for (const [index, item] of Object.entries(data.itemList)) {
                // build markup (same structure you used) but with unique id inside off-screen container
                const wrapper = document.createElement('div');
                wrapper.className = 'idcard-container';
                wrapper.id = `idcard-temp-${index}`;

                // Only render the inner idcard image-container (matching your UI)
                wrapper.innerHTML = (() => {
                    return `
                        <div class="idcard-img-container">
                            <div class="idcard-title">${item.title}</div>
                            ${item.param1 ? /*html*/`<div class="idcard-name"><span>${item.param1.label}:</span>${item.param1.value}</div>` : ""}
                            ${item.param2 ? /*html*/`<div class="idcard-birthdate"><span>${item.param2.label}:</span>${item.param2.value}</div>` : ""}
                            ${item.param3 ? /*html*/`<div class="idcard-sex"><span>${item.param3.label}:</span>${item.param3.value}</div>` : ""}
                            ${item.param4 ? /*html*/`<div class="idcard-height"><span>${item.param4.label}:</span>${item.param4.value}</div>` : ""}
                            ${item.param5 ? /*html*/`<div class="idcard-citizenid"><span>${item.param5.label}:</span>${item.param5.value}</div>` : ""}
                            ${item.signature ? /*html*/`<div class="idcard-signature">${item.signature}</div>` : ""}
                            ${item.mugshot ? /*html*/`<div class="idcard-mugshot-container"><img class="idcard-mugshot" src="${data.mugshot}" alt="Mugshot"></div>` : ""}
                            <img src="img/idcard/${item.img}.png">
                        </div>`;
                })();

                tempContainer.appendChild(wrapper);

                // ensure images loaded
                await waitForImages(wrapper, 2500);

                // capture with html2canvas
                try {
                    const canvas = await html2canvas(wrapper.firstElementChild, { useCORS: true, scale: 2, backgroundColor: null });
                    let dataUrl = canvas.toDataURL('image/png'); // default PNG
                    let base64 = dataUrl.split(',')[1] || '';

                    // if too large, try compressed JPEG fallback
                    const maxBase64Len = 1024 * 1024; // ~1 MB base64
                    if (base64.length > maxBase64Len) {
                        // try JPEG compression to reduce size
                        dataUrl = canvas.toDataURL('image/jpeg', 0.8);
                        base64 = dataUrl.split(',')[1] || '';
                        // if still too large, you may opt to skip
                        if (base64.length > maxBase64Len) {
                            console.warn('idcard capture still too large, skipping index', index, base64.length);
                            tempContainer.removeChild(wrapper);
                            continue;
                        }
                    }

                    // POST to client endpoint (your existing handler expects { base64, mime })
                    fetch(`https://${GetParentResourceName()}/sendCapturedIdcard`, {
                        method: 'POST',
                        body: JSON.stringify({
                            mime: dataUrl.split(';')[0].replace('data:', '') || 'image/png',
                            base64: base64,
                            nameHint: `idcard-${index}.png`
                        })
                    }).catch(err => {
                        console.error('sendCapturedIdcard fetch failed', err);
                    });

                } catch (capErr) {
                    console.error('html2canvas capture error for idcard', index, capErr);
                } finally {
                    // remove the single wrapper element
                    //if (wrapper.parentElement) tempContainer.removeChild(wrapper);
                }
            }
        } finally {
            // cleanup temp container
            if (tempContainer.parentElement) {
                //document.body.removeChild(tempContainer);
            }
        }
    })();
}