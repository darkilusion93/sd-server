$('.phone-application-container').append(/*html*/`
    <style type="text/css">
        .notes-app {
            display: none;
            height: 100%;
            width: 100%;
            background: white;
            overflow: hidden;
        }

        .notes-note {
            display: none;
            height: 100%;
            width: 100%;
            background: white;
            overflow: hidden;
        }

        .notes-list-container {
            display: block;
            height: 100%;
            width: 100%;
            background: #ececec;
            overflow: hidden;
        }

        #noteinput {
            width: 98%;
            height: 85%;
            outline: none;
            border: none;
            resize: none;
            padding: 1.5vh;
            padding-right: 0.5vh;
        }

        #noteinput::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.0);
            border-radius: 1vh;
            background-color: #ffffff00;
        }

        #noteinput::-webkit-scrollbar {
            width: 0.5vh;
            background-color: #F5F5F5;
        }

        #noteinput::-webkit-scrollbar-thumb {
            border-radius: 1vh;
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);
            background-color: #555;
        }

        .notes-header {
            margin: auto;
            margin-top: 5vh;
            display: flex;
            justify-content: space-between;
            width: 90%;
            color: #ff9500;
            transition: color 0.25s;
        }

        .notes-back:hover {
            color: #ffcc00;
        }

        .notes-delete:hover {
            color: #ffcc00;
        }

        .notes-title-input {
            outline: none;
            border: none;
            text-align: center;
            font-weight: 700;
            color: black;
            width: 100%;
        }

        .notes-title {
            font-size: 2vh;
            margin-right: auto;
            margin-left: 8%;
            margin-top: 20%;
            margin-bottom: 1%;
            color: black;
        }

        .notes-searchbox {
            width: 84%;
            margin: auto;
            margin-bottom: 4%;
            background-color: white;
            padding: 2%;
            border-radius: 0.5vh;
            display: flex;
            align-items: center;
        }

        .notes-searchbox svg {
            width: 20px;
            opacity: .7;
        }

        .notes-searchbox input {
            width: 92%;
            border: none;
            outline: none;
            font-family: Roboto;
            font-size: 1.2vh;
            background-color: transparent;
        }

        .notes-body {
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            overflow-y: scroll;
            height: 70%;
        }

        .notes-list {
            width: 84%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 0 6%;
            border-radius: 0.5vh;
            background-color: white;
        }

        .notes-list::-webkit-scrollbar {
            display: none;
        }

        
        .notes-body::-webkit-scrollbar {
            display: none;
        }

        .note-item {
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 3%;
            cursor: pointer;
            padding: 2.5% 0;
            border-bottom: 1px solid #50505033;
        }

        .note-item:last-child {
            border-bottom: none;
        }

        .note-title {
            font-size: 1.5vh;
            width: 45%;
            font-style: bold;
            color: black;
        }

        .note-details {
            display: flex;
            flex-direction: row;
            align-items: center;
            gap: .5rem;
            color: #8e8e93;
            font-size: 1vh;
        }

        .notes-bottom {
            position: relative;
            display: flex;
            flex-direction: row;
            align-items: center;
            padding: 4%;
            margin: auto;
            font-size: 1.7vh;
            width: 90%;
            justify-content: space-between;
        }

        .notes-amount {
            color: black;
            opacity: .8;
            font-size: 1.1vh;
            text-align: center;
        }

        .note-details-date {
            white-space: nowrap; 
        }

        .note-details-content {
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
    </style>
    <div class="notes-app">
        <div class="notes-list-container">
            <div class="notes-title">Notas</div>
            <div class="notes-searchbox">
                <svg width="18" height="18" viewBox="0 0 18 18" fill="#636366" xmlns="http://www.w3.org/2000/svg"><path d="M7.53223 14.0332C8.92969 14.0332 10.2393 13.6113 11.3291 12.8906L15.1787 16.749C15.4336 16.9951 15.7588 17.1182 16.1104 17.1182C16.8398 17.1182 17.376 16.5469 17.376 15.8262C17.376 15.4922 17.2617 15.167 17.0156 14.9209L13.1924 11.0801C13.9834 9.95508 14.4492 8.59277 14.4492 7.11621C14.4492 3.31055 11.3379 0.199219 7.53223 0.199219C3.73535 0.199219 0.615234 3.31055 0.615234 7.11621C0.615234 10.9219 3.72656 14.0332 7.53223 14.0332ZM7.53223 12.1875C4.74609 12.1875 2.46094 9.90234 2.46094 7.11621C2.46094 4.33008 4.74609 2.04492 7.53223 2.04492C10.3184 2.04492 12.6035 4.33008 12.6035 7.11621C12.6035 9.90234 10.3184 12.1875 7.53223 12.1875Z"></path></svg>
                <input placeholder="Search" class="notes-search">
            </div>
            <div class="notes-body">
                <div class="notes-list"></div>
            </div>
            <div class="notes-bottom">
                <svg stroke="#0099ff" fill="#0099ff" style="opacity: 0.0" stroke-width="0" viewBox="0 0 512 512" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg"><path fill="none" stroke-linecap="round" stroke-linejoin="round" stroke-width="32" d="M256 112v288m144-144H112"></path></svg>
                <div class="notes-amount">3 Notes</div>
                <svg stroke="#0099ff" fill="#0099ff" class="notes-create" stroke-width="0" viewBox="0 0 512 512" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg"><path fill="none" stroke-linecap="round" stroke-linejoin="round" stroke-width="32" d="M384 224v184a40 40 0 01-40 40H104a40 40 0 01-40-40V168a40 40 0 0140-40h167.48"></path><path d="M459.94 53.25a16.06 16.06 0 00-23.22-.56L424.35 65a8 8 0 000 11.31l11.34 11.32a8 8 0 0011.34 0l12.06-12c6.1-6.09 6.67-16.01.85-22.38zM399.34 90L218.82 270.2a9 9 0 00-2.31 3.93L208.16 299a3.91 3.91 0 004.86 4.86l24.85-8.35a9 9 0 003.93-2.31L422 112.66a9 9 0 000-12.66l-9.95-10a9 9 0 00-12.71 0z"></path></svg>
            </div>
        </div>

        <div class="notes-note">
            <div class="notes-header">
                <div class="notes-back"><i class="fa-solid fa-chevron-left"></i>&nbsp;&nbsp;Notas</div>
                <div class="note-title"><input class="notes-title-input" value="Nova Nota"></div>
                <div class="notes-delete">Apagar</div>
            </div>
            <textarea name="noteinput" id="noteinput" cols="50" rows="50" placeholder="Criar nota..."></textarea>
        </div>
    </div>
`);

let openNoteIndex = -1;

$(document).on('click', '.notes-delete', function(e){
    let notes = localStorage.notes;

    if (notes === undefined || notes === null) {
        notes = JSON.stringify([]);
    }

    notes = JSON.parse(notes);

    let index = openNoteIndex;
    notes.splice(index, 1);
    localStorage.notes = JSON.stringify(notes);

    OpenNotes();
    $(".notes-note").hide();
    $(".notes-list-container").show();
});

$(document).on('click', '.notes-back', function(e){
    OpenNotes();
    $(".notes-note").hide();
    $(".notes-list-container").show();
});

$(document).on('click', '.notes-create', function(e){
    let notes = localStorage.notes;

    if (notes === undefined || notes === null) {
        notes = JSON.stringify([]);
    }

    notes = JSON.parse(notes);

    let date = new Date().getTime();
    let note = {
        title: "Nova Nota",
        content: "",
        date: date
    };

    notes.push(note);
    localStorage.notes = JSON.stringify(notes);

    OpenNote(notes.length - 1);
});

$("#noteinput").on("keyup", function() {
    var value = $(this).val();

    var title = $(".notes-title-input").val();
    var date = new Date().getTime();
    var notes = localStorage.notes;

    if (notes === undefined || notes === null) {
        notes = JSON.stringify([]);
    }
    notes = JSON.parse(notes);

    let index = openNoteIndex;
    if (index === -1) {
        return;
    }
    let note = notes[index];

    note.content = value;
    note.title = title;
    note.date = date;
    notes[index] = note;
    localStorage.notes = JSON.stringify(notes);
});

$(".notes-title-input").on("keyup", function() {
    var title = $(this).val();

    var value = $("#noteinput").val();
    var date = new Date().getTime();
    var notes = localStorage.notes;

    if (notes === undefined || notes === null) {
        notes = JSON.stringify([]);
    }
    notes = JSON.parse(notes);

    let index = openNoteIndex;
    if (index === -1) {
        return;
    }
    let note = notes[index];

    note.content = value;
    note.title = title;
    note.date = date;
    notes[index] = note;
    localStorage.notes = JSON.stringify(notes);
});

function OpenNote(index) {
    let notes = localStorage.notes;

    if (notes === undefined || notes === null) {
        notes = JSON.stringify([]);
    }

    notes = JSON.parse(notes);

    $(".notes-note").show();
    $(".notes-list-container").hide();

    let note = notes[index];

    openNoteIndex = index;

    $(".notes-title-input").val(note.title);
    $("#noteinput").val(note.content);
}

function appendNotes(notes, search) {
    if (search !== "") {
        notes = notes.filter(note => note.title.toLowerCase().includes(search)/* || note.content.toLowerCase().includes(search)*/);
    }

    for (let i = 0; i < notes.length; i++) {
        let note = notes[i];
        let date = new Date(note.date);
        let dateString = "";

        //if its today show only hours and minutes
        if (date.toDateString() === new Date().toDateString()) {
            dateString = date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        } else if (date.getTime() < new Date().getTime() - 86400000) {
            let diff = Math.floor((new Date().getTime() - date.getTime()) / 86400000);
            if (diff === 1) {
                dateString = "Ontem";
            } else {
                dateString = diff + " dias atrás";
            }
        }

        dateString = dateString + " - "
        
        $(".notes-list").append(/*html*/`
            <div class="note-item" onclick="OpenNote(${i})">
                <div class="note-title">${note.title}</div>
                <div class="note-details">
                    <div class="note-details-date">${dateString}</div>
                    <div class="note-details-content">${note.content}</div>
                </div>
            </div>
        `);
    }

    $(".notes-amount").text(notes.length + " Notas");

    $(document).on('click', '.note-item', function(e){
        let index = $(this).index();
        
        OpenNote(index);
    });
}

function OpenNotes() {
    let notes = localStorage.notes;

    if (notes === undefined || notes === null) {
        notes = JSON.stringify([]);
    }

    notes = JSON.parse(notes);

    if (localStorage.note !== undefined && localStorage.note !== null) { //Retrofit the old notes code (so players don't loose their notes)
        let note = {
            title: "Nova Nota",
            content: localStorage.note,
            date: new Date().getTime()
        };

        localStorage.removeItem("note");

        notes.push(note);
        localStorage.notes = JSON.stringify(notes);
    }

    $(".notes-list").empty();
    
    const search = $(".notes-search").val().toLowerCase();

    appendNotes(notes, search);
}

$(".notes-search").on("keyup", function() {
    var notes = localStorage.notes;

    if (notes === undefined || notes === null) {
        notes = JSON.stringify([]);
    }

    notes = JSON.parse(notes);

    $(".notes-list").empty();

    const search = $(".notes-search").val().toLowerCase();

    appendNotes(notes, search);    
});