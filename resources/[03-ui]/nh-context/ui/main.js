let Buttons = [];
let Button = [];
const RESOURCE_NAME = GetParentResourceName();

const OpenMenu = (data, showSearchBar) => {
    DrawButtons(data, showSearchBar)
    if (showSearchBar) {
        $("#container").prepend(`<div class="searchbar"><input type="text" id="search" placeholder="Procurar..."></div>`)
    }
}

const CloseMenu = () => {
    $(".button").remove();
    $(".searchbar").remove();
    $(".buttonDisabled").remove();
    Buttons = [];
    Button = [];
};

const DrawButtons = (data, showSearchBar) => {
    for (let i = 0; i < data.length; i++) {
        let context = data[i].context ? data[i].context : ""
        let footer = data[i].footer ? data[i].footer : ""
        let element = $(`
            <div class="${data[i].disabled ? "buttonDisabled" : "button"}" id=${i}>
              <div class="header" id=${`${i}_HEADER`}>${data[i].header}</div>
              <div class="context" id=${`${i}_CONTEXT`}>${context}</div>
              <div class="footer" id=${`${i}_FOOTER`}>${footer}</div>
              ${data[i].subMenu && !data[i].disabled ? `<svg class="submenuicon" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M5 3l3.057-3 11.943 12-11.943 12-3.057-3 9-9z"/></svg>` : ""}
            </div>`
        );
        $('#buttons').append(element);
        if (showSearchBar) {
            data[i].header = data[i].header.toLowerCase();
            data[i].context = context.toLowerCase();
            data[i].footer = footer.toLowerCase();
        }
        Buttons[i] = element
        Button[i] = data[i]
    }
};

$(document).click(function (event) {
    let $target = $(event.target);
    if ($target.closest('.button').length && $('.button').is(":visible")) {
        let id = (event.target.id).split('_')[0];
        if (Button[id].disabled) return;
        if (!Button[id].event && !Button[id].args) return;
        PostData(id)
        document.getElementById('imageHover').style.display = 'none';
    }
})

const PostData = (id) => {
    $.post(`https://${RESOURCE_NAME}/dataPost`, JSON.stringify({id: id}))
}

const CancelMenu = () => {
    $.post(`https://${RESOURCE_NAME}/cancel`)
}

window.addEventListener("message", (evt) => {
    const data = evt.data
    const info = data.data
    const searchbar = data.searchbar
    const action = data.action
    switch (action) {
        case "OPEN_MENU":
            return OpenMenu(info, searchbar);
        case "CLOSE_MENU":
            return CloseMenu();
        case "CANCEL_MENU":
            return CancelMenu();
        default:
            return;
    }
})

window.addEventListener("keyup", (ev) => {
    if (ev.which == 27) {
        CancelMenu();
        document.getElementById('imageHover').style.display = 'none';
    }
})

window.addEventListener('mousemove', (event) => {
    let $target = $(event.target);
    if ($target.closest('.button:hover').length && $('.button').is(":visible")) {
        let id = event.target.id;
        if (!Button[id]) return
        if (Button[id].image) {
            document.getElementById('image').src = Button[id].image;
            document.getElementById('imageHover').style.display = 'block';
        }
    }
    else {
        document.getElementById('imageHover').style.display = 'none';
    }
})

$('#container').on('input', '#search', function() {
    let searchText = $(this).val().toLowerCase();
    if (searchText == "") {
        for (let i = 1; i < Buttons.length; i++) {
            Buttons[i].show()
        }
    } else {
        for (let i = 1; i < Button.length; i++) {
            const data = Button[i]
            const header = data.header
            const context = data.context
            const footer = data.footer
            if (header.includes(searchText) || context.includes(searchText) || footer.includes(searchText)) {
                Buttons[i].show()
            } else {
                Buttons[i].hide()
            }
        }
    }
});