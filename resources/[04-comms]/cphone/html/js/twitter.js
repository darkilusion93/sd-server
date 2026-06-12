let tweets = [];
let messages = [];
let loggedIn = false;
let inFollowingPage = false;
let isRegistering = false;
let accountName = '';

$('.phone-application-container').append(/*html*/`
    <style type="text/css">
        .twitter-app {
            --twitter-background: #F5F8FA;
            --twitter-tweet-reply: rgba(0, 0, 0, 0.8);
            --twitter-transparent-black: rgb(20 23 26 / 15%);
            --twitter-gray: #797979;
            --twitter-blue: #0099ff;
            --twitter-light-blue: #3eb3fc;
            --twitter-white: #FFFFFF;
            --twitter-dirty-white: #EEEEEE;
            --twitter-dark-gray: #2d2d2d;
            --twitter-black: #000000;
            --twitter-red: #e82616;
            --twitter-like-red: #f91880;
            --twitter-light-red: #ea4335;
            --twitter-gray-fix: #797979;
            --twitter-white-fix: #FFFFFF;
            --twitter-dirty-white-fix: #EEEEEE;
        }

        .twitter-app-darkmode {
            --twitter-gray-fix: #797979;
            --twitter-white-fix: #FFFFFF;
            --twitter-dirty-white-fix: #EEEEEE;
            --twitter-background: #000000;
            --twitter-tweet-reply: rgb(228 228 228 / 80%);
            --twitter-transparent-black: rgb(168 193 218 / 15%);
            --twitter-gray: #c7c7c7;
            --twitter-blue: #0099ff;
            --twitter-light-blue: #0071b7;
            --twitter-white: #000000;
            --twitter-dirty-white: #212121;
            --twitter-dark-gray: #c5c5c5;
            --twitter-black: #ffffff;
            --twitter-red: #e82616;
            --twitter-like-red: #f91880;
            --twitter-light-red: #ea4335;
        }

        .twitter-app {
            display: none;
            height: 100%;
            width: 100%;
            background: var(--twitter-background);
            overflow: hidden;
            transition:all ease-in-out .3s;
        }
    </style>
    <div class="twitter-app"></div>
`);

//Tweet css
$('.twitter-app').append(/*html*/`
    <style type="text/css">
        .twitter-tweet {
            position: relative;
            height: auto;
            width: 100%;
            border-bottom: 1px solid var(--twitter-transparent-black);
            color: var(--twitter-dark-gray);
        }

        .tweet-tweeter {
            padding-left: 6vh;
            padding-top: .6vh;
            font-family: 'Samsung Sans Bold';
            font-size: 1.1vh;
        }

        .tweet-tweeter > span {
            position: relative;
            font-family: 'Helvetica';
            font-size: 1.0vh;
            top: -.1vh;
        }

        .tweet-message {
            margin-top: .3vh;
            padding-left: 6vh;
            padding-right: .8vh;
            top: .5vh;
            font-family: 'Helvetica';
            font-size: 1.3vh;
            padding-bottom: 1vh;
            overflow-wrap: break-word;
            word-wrap: break-word;
        }

        .twt-img {
            position: absolute;
            left: 1vh;
        }

        .twt-img > img {
            width: 4vh;
            height: 4vh;
            border-radius: 50%;
            object-fit: cover;
        }
    </style>
`);

//Home page
$('.twitter-app').append(/*html*/`
    <style type="text/css">
        .twitter-home-tab {
            display: block;
            position: absolute;
            height: 100%;
            width: 100%;
        }

        .twitter-home-header {
            margin-top: 5vh;
            line-height: 2vh;
            text-align: center;
            height: 2.8vh;
        }

        .twitter-home-logo {
            color: var(--twitter-blue);
            font-size: 2vh;
        }

        .twitter-home-settings {
            color: var(--twitter-gray);
            float: right;
            margin-right: 1.4vh;
            font-size: 2vh;
            color: var(--twitter-black);
        }

        .twitter-home-profile {
            float: left;
            margin-left: 1.4vh;
            background: var(--twitter-gray);
            width: 2vh;
            height: 2vh;
            text-align: center;
            border-radius: 6vh;
            color: var(--twitter-white);
            font-size: 1vh;
        }

        .twitter-home-tweets-container {
            width: 100%;
            height: 48vh;
        }

        .twitter-home-tweets {
            width: 100%;
            height: 46vh;
            overflow-y: scroll;
            overflow-x: hidden;
        }

        .twitter-home-tweets::-webkit-scrollbar {
            display: none;
        }

        .twitter-home-search {
            width: 100%;
            height: 48vh;
            display: none;
            background: var(--twitter-background);
            overflow-y: scroll;
            overflow-x: hidden;
            border-top: thin solid var(--twitter-transparent-black);
        }

        .twitter-home-search::-webkit-scrollbar {
            display: none;
        }

        .twitter-home-notifications {
            width: 100%;
            height: 48vh;
            display: none;
            background: var(--twitter-background);
            overflow-y: scroll;
            overflow-x: hidden;
            border-top: thin solid var(--twitter-transparent-black);
        }

        .twitter-home-notifications::-webkit-scrollbar {
            display: none;
        }

        .twitter-home-dm {
            width: 100%;
            height: 48vh;
            display: none;
            background: var(--twitter-background);
            transition: 0.2s;
            overflow-y: scroll;
            overflow-x: hidden;
            border-top: thin solid var(--twitter-transparent-black);
        }

        .twitter-home-dm::-webkit-scrollbar {
            display: none;
        }

        .twitter-home-footer {
            border-top: thin solid var(--twitter-transparent-black);
            display: flex;
            justify-content: space-between;
            font-size: 1.4vh;
            color: var(--twitter-gray);
        }

        .twitter-button-home {
            margin-left: 3vh;
            margin-top: 1.4vh;
        }

        .twitter-button-search {
            margin-top: 1.4vh;
        }

        .twitter-button-notifications {
            margin-top: 1.4vh;
        }

        .twitter-button-messages {
            margin-right: 3vh;
            margin-top: 1.4vh;
        }

        .twitter-footer-button {
            color: var(--twitter-gray);
            transition: .2s;
        }

        .twitter-footer-button:hover {
            color: var(--twitter-light-blue);
        }

        .twitter-footer-button:active {
            color: var(--twitter-blue);
        }

        .twitter-home-selected {
            color: var(--twitter-blue);
        }

        .twitter-new-tweet {
            position: absolute;
            bottom: 6vh;
            right: 0;
            width: 4.5vh;
            height: 4.5vh;
            background-color: var(--twitter-blue);
            margin: 1.2vh;
            border-radius: 50%;
            text-align: center;
            transition: .1s;
        }

        .twitter-new-tweet:hover {
            background-color: var(--twitter-light-blue);
        }

        .twitter-new-tweet > i {
            line-height: 4.5vh;
            font-size: 2vh;
            transform: rotate(-20deg);
            color: var(--twitter-white-fix);
        }

        .twitter-profile-image {
            width: 2vh;
            height: 2vh;
            border-radius: 6vh;
            object-fit: cover;
        }

        .tweet-picture {
            margin-top: .3vh;
            padding-left: 6vh;
            padding-right: .8vh;
            padding-bottom: 1vh;
        }

        .tweet-picture-img {
            width: 21vh;
            border-radius: 1vh;
            max-height: 25vh;
            object-fit: cover;
        }

        .tweet-buttons-container {
            width: fit-content;
            height: 2vh;
            margin-left: 6vh;
        }

        .tweet-buttons {
            float: left;
            margin-right: 4vh;
        }

        .tweet-like-button {
            color: var(--twitter-black);
            font-weight: 300;
        }

        .tweet-like-button:hover {
            color: var(--twitter-like-red);
        }

        .tweet-like-button:hover i {
            font-weight: 700;
        }

        .tweet-like-button-active {
            color: var(--twitter-like-red);
        }

        .tweet-like-button-active i {
            font-weight: 700;
        }

        .twitter-chat {
            display: flex;
            height: 6vh;
            width: 100%;
            padding: 3%;
            border-bottom: 1px solid var(--twitter-transparent-black);
            background: var(--twitter-white);
            color: var(--twitter-dark-gray);
            transition: 0.2s;
        }

        .twitter-chat:hover {
            background: var(--twitter-dirty-white);
        }

        .twitter-chat-partner {
            height: 100%;
            margin-right: 2%;
        }

        .twitter-chat-preview {
            overflow: hidden;
        }

        .twitter-chat-partner-image {
            height: 100%;
            aspect-ratio: 1 / 1;
            object-fit: cover;
            border-radius: 100%;
        }

        .twitter-chat-partner-label {
            font-size: 1.2vh;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .twitter-chat-partner-label span {
            color: var(--twitter-gray);
        }

        .twitter-chat-latest-message {
            color: var(--twitter-gray);
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .twitter-home-search-input {
            display: flex;
            width: 100%;
            height: 10%;
            padding: 3%;
            align-items: center;
            justify-content: space-between;
        }

        .twitter-home-search-input-text {
            border: none;
            background: var(--twitter-dirty-white);
            height: 100%;
            border-radius: 1.5vh;
            box-shadow: 0 0 0vh 0 #00000000;
            font-size: 1.4vh;
            outline: none;
            padding-left: 2vh;
            width: 100%;
            padding-right: 3.4vh;
        }

        .twitter-home-search-results {
            width: 100%;
            height: 90%;
            overflow-y: scroll;
            overflow-x: hidden;
        }

        .twitter-home-search-results::-webkit-scrollbar {
            display: none;
        }


        .twitter-search-user {
            height: 14%;
            display: flex;
            background: transparent;
            transition: 0.2s;
        }

        .twitter-search-user:hover {
            background: var(--twitter-transparent-black);
        }

        .twitter-search-user:active {
            background: var(--twitter-dirty-white);
        }

        .twitter-search-user-picture {
            width: 18%;
            height: 100%;
            margin-left: 3%;
            display: flex;
            align-items: center;
        }

        .twitter-search-user-name {
            padding: 2%;
            width: 79%;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .twitter-search-user-label {
            color: var(--twitter-black);
            font-size: 1.4vh;
            font-weight: 600;
        }

        .twitter-search-user-username {
            color: var(--twitter-gray);
            font-size: 1.2vh;
        }
        
        .twitter-search-user-image {
            height: 5vh;
            width: 5vh;
            aspect-ratio: 1 / 1;
            object-fit: cover;
            border-radius: 100%;
        }

        .twitter-home-feed-header {
            text-align: center;
            height: 2vh;
            display: flex;
            border-bottom: thin solid var(--twitter-transparent-black);
            justify-content: space-around;
            font-size: 1.2vh;
            color: var(--twitter-gray);

        }

        .twitter-home-feed-button {
            color: var(--twitter-gray);
            transition: 0.2s;
        }

        .twitter-home-feed-button:hover {
            color: var(--twitter-black);
        }

        .twitter-home-feed-button::after {
            content: "";
            width: 0%;
            height: 0.3vh;
            border-radius: 1vh;
            background: var(--twitter-blue);
            transition: 0.2s;
        }

        .twitter-home-feed-selected {
            display: flex;
            color: var(--twitter-black);
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
        }

        .twitter-home-feed-selected::after {
            content: "";
            width: 100%;
            height: 0.3vh;
            border-radius: 1vh;
            background: var(--twitter-blue);
        }
    </style>
    <div class="twitter-home-tab">
        <div class="twitter-home-header">
            <span class="twitter-home-profile"><img src="./img/default.png" class="twitter-profile-image twitter-profile-picture"></span>
            <span class="twitter-home-logo"><i class="fa-brands fa-twitter"></i></span>
            <span class="twitter-home-settings"><i class="fa-light fa-moon"></i></span>
        </div>

        <div class="twitter-home-tweets-container">
            <div class="twitter-home-feed-header">
                <div class="twitter-home-feed-all twitter-home-feed-button twitter-home-feed-selected">For You</div>
                <div class="twitter-home-feed-following twitter-home-feed-button">Following</div>
            </div>
            <div class="twitter-home-tweets"></div>
        </div>
        <div class="twitter-new-tweet"><i class="fas fa-feather-alt"></i></div>

        <div class="twitter-home-search">
            <div class="twitter-home-search-input">
                <input class="twitter-home-search-input-text" placeholder="Procurar">
            </div>
            <div class="twitter-home-search-results"></div>
        </div>
        <div class="twitter-home-notifications">notifications</div>
        <div class="twitter-home-dm">mensagens</div>

        <div class="twitter-home-footer">
            <span class="twitter-button-home twitter-footer-button twitter-home-selected"><i class="fa-solid fa-house"></i></span>
            <span class="twitter-button-search twitter-footer-button"><i class="fa-solid fa-magnifying-glass"></i></span>
            <span class="twitter-button-notifications twitter-footer-button"><i class="fa-solid fa-bell"></i></span>
            <span class="twitter-button-messages twitter-footer-button"><i class="fa-solid fa-envelope"></i></span>
        </div>
    </div>
`);

//Página novo tweet
$('.twitter-app').append(/*html*/`
    <style type="text/css">
        .twitter-new-tweet-tab {
            position: absolute;
            width: 100%;
            height: 100%;
            background-color: var(--twitter-white);
            bottom: -120%;
            display: none;
        }

        .twitter-new-tweet-buttons {
            margin: 2vh;
            margin-top: 5vh;
        }

        .twitter-new-tweet-cancel {
            float: left;
            height: 2.5vh;
            line-height: 2.5vh;
            color: var(--twitter-black);
            transition: 0.25s;
        }

        .twitter-new-tweet-cancel:hover {
            color: var(--twitter-gray);
        }

        .twitter-new-tweet-accept {
            float: right;
            font-weight: bold;
            color: var(--twitter-white-fix);
            background: var(--twitter-blue);
            height: 2.5vh;
            line-height: 2.5vh;
            font-size: 1vh;
            width: 5vh;
            text-align: center;
            border-radius: 3vh;
            transition: 0.25s;
        }

        .twitter-new-tweet-accept:hover {
            background: var(--twitter-light-blue);
        }

        .twitter-new-tweet-profile {
            height: 3vh;
            width: 3vh;
            margin: 1.9vh;
            margin-top: 4vh;
            line-height: 3vh;
            text-align: center;
            font-size: 1.5vh;
            position: absolute;
            border-radius: 5vh;
            color: var(--twitter-white); 
        }

        .twitter-new-tweet-image {
            height: 3vh;
            width: 3vh;
            background: transparent;
            border-radius: 5vh;
            color: var(--twitter-white);
            object-fit: cover;
        }

        .twitter-new-tweet-text {
            margin: 4vh;
            margin-top: 10.0vh;
            margin-left: 5.9vh;
            color: var(--twitter-gray);
            height: 50%;
        }

        .twitter-new-tweet-input {
            outline: none;
            border-width: 0;
            width: 100%;
            height: 100%;
            overflow-wrap: break-word;
            word-wrap: break-word;
            resize: none;
            background: transparent;
        }

        .twitter-new-tweet-input::-webkit-scrollbar {
            display: none;
        }
    </style>
    <div class="twitter-new-tweet-tab">
        <div class="twitter-new-tweet-buttons">
            <div class="twitter-new-tweet-cancel">Cancelar</div>
            <div class="twitter-new-tweet-accept">Tweet</div>
        </div>
        <div class="twitter-new-tweet-profile"><img src="./img/default.png" class="twitter-new-tweet-image twitter-profile-picture"></div>
        <div class="twitter-new-tweet-text"><textarea class="twitter-new-tweet-input" placeholder="O que está a acontecer?"></textarea></div>
    </div>
`);

//Página DM
$('.twitter-app').append(/*html*/`
    <style type="text/css">
        .twitter-dm-tab {
            display: none;
            position: absolute;
            top: 0;
            height: 100%;
            width: 100%;
            background: var(--twitter-white);
            overflow: hidden;
            z-index: 105;
            color: var(--twitter-black);
        }

        .twitter-dm-tab-header {
            width: 100%;
            height: 10%;
            margin-top: 14%;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 4%;
            padding-bottom: 2%;
            border-bottom: 1px solid var(--twitter-transparent-black);
        }

        .twitter-dm-tab-header-back {
            margin-left: 0;
            width: 10%;
            transition: 0.25s;
        }

        .twitter-dm-tab-header-back:hover {
            color: var(--twitter-gray);
        }

        .twitter-dm-tab-header-back:active {
            color: var(--twitter-dark-gray);
        }

        .twitter-dm-tab-header-right {
            margin-right: 0;
            width: 10%;
        }

        .twitter-dm-tab-header-title {
            height: 100%;
            margin: auto;
        }

        .twitter-dm-tab-header-picture {
            height: 50%;
            display: flex;
            justify-content: center;
        }

        .twitter-dm-tab-header-image {
            height: 100%;
            aspect-ratio: 1 / 1;
            object-fit: cover;
            border-radius: 100%;
        }

        .twitter-dm-tab-messages {
            width: 100%;
            height: 70%;
            overflow-y: scroll;
        }

        .twitter-dm-tab-messages::-webkit-scrollbar {
            display: none;
        }

        .twitter-dm-tab-input {
            display: flex;
            width: 100%;
            height: 9%;
            padding: 3%;
            align-items: center;
            justify-content: space-between;
            border-top: 1px solid var(--twitter-transparent-black);
        }

        .twitter-dm-tab-input-text {
            border: none;
            background: var(--twitter-background);
            height: 100%;
            border-radius: 1.5vh;
            box-shadow: 0 0 0vh 0 #00000000;
            font-size: 1.4vh;
            outline: none;
            padding-left: 2vh;
            width: 88%;
            padding-right: 3.4vh;
        }

        .twitter-dm-tab-input-button {
            height: 75%;
            aspect-ratio: 1 / 1;
            background: var(--twitter-blue);
            color: var(--twitter-white-fix);
            border-radius: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: 0.25s;
        }

        .twitter-dm-tab-input-button:hover {
            background: var(--twitter-light-blue);
        }

        .twitter-dm-tab-input-button:active {
            background: var(--twitter-white-fix);
        }

        .twitter-dm-message {
            width: 100%;
            height: fit-content;
            display: flex;
            padding: 1% 2% 1% 2.6%;
            flex-direction: column;
        }

        .twitter-dm-message-me {
            background: var(--twitter-blue);
            color: var(--twitter-white-fix);
            margin: auto;
            margin-right: 0;
            border-radius: 1vh;
            padding: 2%;
            max-width: 64%;
        }

        .twitter-dm-message-me-time {
            margin: auto;
            margin-right: 0.5%;
            font-size: 0.9vh;
            color: var(--twitter-dark-gray);
        }

        .twitter-dm-message-them {
            background: var(--twitter-transparent-black);
            color: var(--twitter-black);
            margin: auto;
            margin-left: 0;
            border-radius: 1vh;
            padding: 2%;
            max-width: 64%;
        }

        .twitter-dm-message-them-time {
            margin: auto;
            margin-left: 0.5%;
            font-size: 0.9vh;
            color: var(--twitter-dark-gray);
        }
    </style>
    <div class="twitter-dm-tab">
        <div class="twitter-dm-tab-header">
            <div class="twitter-dm-tab-header-back"><i class="fa-solid fa-arrow-left"></i></div>
            <div class="twitter-dm-tab-header-title">
                <div class="twitter-dm-tab-header-picture"><img src="./img/default.png" class="twitter-dm-tab-header-image"></div>
                <div class="twitter-dm-tab-header-name">John Doe</div>
            </div>
            <div class="twitter-dm-tab-header-right"></div>
        </div>
        <div class="twitter-dm-tab-messages"></div>
        <div class="twitter-dm-tab-input">
            <input class="twitter-dm-tab-input-text" placeholder="Mensagem">
            <div class="twitter-dm-tab-input-button"><i class="fa-solid fa-paper-plane"></i></div>
        </div>
    </div>
`);

//Página Perfil
$('.twitter-app').append(/*html*/`
    <style type="text/css">
        .twitter-profile-tab {
            display: none;
            position: absolute;
            top: 0;
            left: 30vh;
            height: 55.8vh;
            width: 100%;
            background: var(--twitter-background);
            overflow: hidden;
            color: var(--twitter-black);
        }

        .twitter-profile-tab-header {
            height: 6%;
            width: 100%;
            margin-top: 18%;
        }

        .twitter-profile-tab-header-back {
            width: 7%;
            aspect-ratio: 1/1;
            background: var(--twitter-black);
            color: var(--twitter-white);
            border-radius: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            margin-left: 6%;
            transition: 0.2s;
        }

        .twitter-profile-tab-header-back:hover {
            background: var(--twitter-gray);
        }

        .twitter-profile-tab-header-back:active {
            background: var(--twitter-dirty-white);
        }

        .twitter-profile-tab-info {
            width: 100%;
            height: 35%;
            border-bottom: thin solid var(--twitter-transparent-black);
        }

        .twitter-profile-tab-info-background {
            width: 100%;
            height: 45%;
            display: flex;
            padding: 4%;
            justify-content: space-between;
        }

        .twitter-profile-tab-info-picture {
            height: 100%;
        }

        .twitter-profile-tab-info-image {
            height: 100%;
            object-fit: cover;
            border-radius: 100%;
            aspect-ratio: 1/1;
        }

        .twitter-profile-tab-info-container {
            display: flex;
            width: 50%;
            gap: 4%;
            align-items: flex-end;
            justify-content: flex-end;
        }

        .twitter-profile-tab-info-edit {
            height: 45%;
            aspect-ratio: 1/1;
            display: flex;
            border-radius: 100%;
            border: 1px solid var(--twitter-gray);
            align-items: center;
            background: transparent;
            justify-content: center;
            transition: 0.2s;
        }

        .twitter-profile-tab-info-edit:hover {
            background: var(--twitter-dirty-white);
        }

        .twitter-profile-tab-info-edit:active {
            background: var(--twitter-gray);
        }

        .twitter-profile-tab-info-edit-account-text {
            height: 45%;
            width: 70%;
            border-radius: 3vh;
            font-size: 1.2vh;
            text-align: center;
            line-height: 2.7vh;
            background: transparent;
            border: 1px solid var(--twitter-gray);
            transition: 0.2s;
        }

        .twitter-profile-tab-info-edit-account-text:hover {
            background: var(--twitter-dirty-white);
        }

        .twitter-profile-tab-info-edit-account-text:active {
            background: var(--twitter-gray);
        }

        .twitter-profile-tab-info-name {
            margin-left: 5%;
            font-size: 1.5vh;
            font-weight: 600;
            color: var(--twitter-black);
        }

        .twitter-profile-tab-info-username {
            margin-left: 5%;
            font-size: 1.1vh;
            color: var(--twitter-gray);
        }

        .twitter-profile-tab-info-description {
            width: 100%;
            padding: 1.5% 5% 0 5%;
            height: 13%;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .twitter-profile-tab-info-follows {
            width: 95%;
            display: flex;
            margin-left: 5%;
            font-size: 1.1vh;
            color: var(--twitter-gray);
            gap: 3%;
        }

        .twitter-profile-tab-info-followers-count{
            font-weight: 600;
            color: var(--twitter-black);
        }

        .twitter-profile-tab-info-following-count{
            font-weight: 600;
            color: var(--twitter-black);
        }

        .twitter-profile-tab-info-tabs {
            width: 100%;
            height: 12%;
            margin-top: 2%;
            display: flex;
            padding: 0 5% 0 5%;
            justify-content: space-between;
            font-weight: 600;
            color: var(--twitter-gray);
            font-size: 1.2vh;
        }

        .twitter-profile-tab-info-tab-selected {
            display: flex;
            color: var(--twitter-black);
            flex-direction: column;
            justify-content: space-between;
        }

        .twitter-profile-tab-info-tab-selected::after {
            content: "";
            width: 100%;
            height: 0.3vh;
            border-radius: 1vh;
            background: var(--twitter-blue);
        }

        .twitter-profile-tab-tweets {
            width: 100%;
            height: 50%;
            overflow-y: scroll;
            overflow-x: hidden;
        }

        .twitter-profile-tab-tweets::-webkit-scrollbar {
            display: none;
        }
    </style>
    <div class="twitter-profile-tab">
        <div class="twitter-profile-tab-header">
            <div class="twitter-profile-tab-header-back"><i class="fa-solid fa-arrow-left"></i></div>
        </div>

        <div class="twitter-profile-tab-info">
            <div class="twitter-profile-tab-info-background">
                <div class="twitter-profile-tab-info-picture"><img src="./img/default.png" class="twitter-profile-tab-info-image"></div>

                <div class="twitter-profile-tab-info-container">
                    <div class="twitter-profile-tab-info-edit"><i class="fa-solid fa-envelope"></i></div>
                    <div class="twitter-profile-tab-info-edit-account-text">Seguir</div>
                </div>
            </div>

            <div class="twitter-profile-tab-info-name">John Doe</div>
            <div class="twitter-profile-tab-info-username">@johndoe</div>
            <div class="twitter-profile-tab-info-description">Descrição do perfil</div>

            <div class="twitter-profile-tab-info-follows">
                <div class="twitter-profile-tab-info-followers"><span class="twitter-profile-tab-info-followers-count">0</span> Seguidores</div>
                <div class="twitter-profile-tab-info-following"><span class="twitter-profile-tab-info-following-count">0</span> Seguindo</div>
            </div>

            <div class="twitter-profile-tab-info-tabs">
                <div class="twitter-profile-tab-info-tab twitter-profile-tab-info-tab-selected">Posts</div>
                <div class="twitter-profile-tab-info-tab">Replies</div>
                <div class="twitter-profile-tab-info-tab">Media</div>
                <div class="twitter-profile-tab-info-tab">Likes</div>
            </div>
        </div>
        <div class="twitter-profile-tab-tweets">
            <div class="twitter-tweet">
                <div class="tweet-tweeter" id="tweet-data-0">symazgay &nbsp;<span>@cusymaz · 2 d</span></div>
                <div class="tweet-message">asdasdasda</div>
                <div class="twt-img" style="top: 1vh;"><img src="./img/default.png" class="tweeter-image"></div>
                <div class="tweet-buttons-container">
                    <div class="tweet-buttons"><i class="fa-light fa-comment" aria-hidden="true"></i></div>
                    <div class="tweet-buttons"><i class="fa-light fa-retweet" aria-hidden="true"></i></div>
                    <div class="tweet-buttons tweet-like-button"><i class="fa-light fa-heart" aria-hidden="true"></i></div>
                    <div class="tweet-buttons"><i class="fa-light fa-arrow-up-from-bracket" aria-hidden="true"></i></div>
                </div>
            </div>
        </div>
    </div>
`);

//Página edit account
$('.twitter-app').append(/*html*/`
    <style type="text/css">
        .twitter-edit-account-tab {
            position: absolute;
            width: 100%;
            height: 90%;
            border-radius: 2.5vh;
            background-color: var(--twitter-white);
            color: var(--twitter-dark-gray);
            bottom: -120%;
            display: none;
        }

        .twitter-edit-account-buttons {
            margin: 2vh;
            margin-top: 1vh;
        }

        .twitter-edit-account-cancel {
            float: left;
            height: 2.5vh;
            line-height: 2.5vh;
            color: var(--twitter-black);
            transition: 0.25s;
        }

        .twitter-edit-account-cancel:hover {
            color: var(--twitter-gray);
        }

        .twitter-edit-account-accept {
            float: right;
            font-weight: bold;
            color: var(--twitter-white-fix);
            background: var(--twitter-blue);
            height: 2.5vh;
            line-height: 2.5vh;
            font-size: 1vh;
            width: 5vh;
            text-align: center;
            border-radius: 3vh;
            transition: 0.25s;
        }

        .twitter-edit-account-accept:hover {
            background: var(--twitter-light-blue);
        }

        .twitter-edit-account-logout {
            text-align: center;
            height: 3vh;
            line-height: 3vh;
            background: var(--twitter-light-red);
            width: 14vh;
            margin: auto;
            margin-top: 9vh;
            color: var(--twitter-white);
            border-radius: 1vh;
            transition: 0.25s;
        }

        .twitter-edit-account-logout:hover {
            background: var(--twitter-red);
        }

        .twitter-edit-account-profile {
            width: 10vh;
            height: 10vh;
            margin: auto;
            margin-top: 6vh;
        }

        .twitter-edit-account-image {
            width: 10vh;
            height: 10vh;
            border-radius: 10vh;
            object-fit: cover;
        }

        .twitter-edit-account-photo {
            text-align: center;
            font-size: 1vh;
            color: var(--twitter-dark-gray);
            margin-top: 0.5vh;
            transition: 0.2s;
        }

        .twitter-edit-account-photo:hover {
            color: var(--twitter-black);
        }

        .twitter-edit-account-name {
            margin-top: 2vh;
            text-indent: 2vh;
            font-weight: bold;
            border-bottom: 1px solid var(--twitter-transparent-black);
            border-top: 1px solid var(--twitter-transparent-black);
            height: 3.5vh;
            line-height: 3.2vh;
            font-size: 1.2vh;
        }

        .twitter-edit-account-name-input {
            outline: none;
            border-width: 0;
            font-weight: normal;
            background: transparent;
            margin-left: 3vh;
        }

        .twitter-edit-account-bio {
            text-indent: 2vh;
            font-weight: bold;
            border-bottom: 1px solid var(--twitter-transparent-black);
            height: 3.5vh;
            line-height: 3.2vh;
            font-size: 1.2vh;
        }

        .twitter-edit-account-bio-input {
            outline: none;
            border-width: 0;
            font-weight: normal;
            background: transparent;
            margin-left: 3vh;
        }

        .twitter-edit-account-new {
            margin-top: 5vh;
            text-indent: 2vh;
            font-weight: bold;
            border-bottom: 1px solid var(--twitter-transparent-black);
            border-top: 1px solid var(--twitter-transparent-black);
            height: 3.5vh;
            line-height: 3.2vh;
            font-size: 1.2vh;
        }

        .twitter-edit-account-old {
            text-indent: 2vh;
            font-weight: bold;
            border-bottom: 1px solid var(--twitter-transparent-black);
            height: 3.5vh;
            line-height: 3.2vh;
            font-size: 1.2vh;
        }

        .twitter-edit-account-password-input {
            outline: none;
            border-width: 0;
            font-weight: normal;
            background: transparent;
            margin-left: 3vh;
        }

        .twitter-password-new {
            margin-left: 3.6vh;
        }

        .twitter-edit-account-popup {
            display: none;
            position: absolute;
            width: 20vh;
            height: 5vh;
            background: var(--twitter-transparent-black);
            margin-top: 1vh;
            margin-left: auto;
            margin-right: auto;
            left: 0;
            right: 0;
            backdrop-filter: blur(2px);
            border-radius: 1vh;
            color: var(--twitter-white);
        }

        .twitter-edit-account-picture-link {
            outline: none;
            border-width: 0;
            background: transparent;
            margin-top: 1.3vh;
            margin-left: 0.5vh;
            width: 15vh;
        }

        .twitter-link-cancel {
            margin-left: 0.5vh;
            margin-right: 0.5vh;
            transition: 0.2s;
        }

        .twitter-link-confirm {
            transition: 0.2s;
        }

        .twitter-link-confirm:hover {
            color: var(--twitter-gray);
        }

        .twitter-link-cancel:hover {
            color: var(--twitter-gray);
        }

        .twitter-edit-account-picture-link::placeholder { /* Chrome, Firefox, Opera, Safari 10.1+ */
            color: var(--twitter-gray);
        }
    </style>
    <div class="twitter-edit-account-tab">
        <div class="twitter-edit-account-buttons">
            <div class="twitter-edit-account-cancel">Cancelar</div>
            <div class="twitter-edit-account-accept">Guardar</div>
        </div>
        <div class="twitter-edit-account-profile"><img src="./img/default.png" class="twitter-edit-account-image twitter-profile-picture"></div>
        <div class="twitter-edit-account-photo">Editar foto</div>
        <div class="twitter-edit-account-popup">
            <input class="twitter-edit-account-picture-link" placeholder="link">
            <i class="twitter-link-cancel fa-light fa-xmark"></i>
            <i class="twitter-link-confirm fa-light fa-check"></i>
        </div>
        <div class="twitter-edit-account-name">Nome<input class="twitter-edit-account-name-input"></div>
        <div class="twitter-edit-account-bio">Bio<input class="twitter-edit-account-bio-input"></div>
        <div class="twitter-edit-account-new">Nova password<input class="twitter-edit-account-password-input twitter-password-new" type="password" placeholder="password"></div>
        <div class="twitter-edit-account-old">Password antiga<input class="twitter-edit-account-password-input twitter-password-old" type="password" placeholder="password"></div>
        <div class="twitter-edit-account-logout">Logout</div>
    </div>
`);

//Página login
$('.twitter-app').append(/*html*/`
    <style type="text/css">
        .twitter-login {
            display: none;
            position: absolute;
            top: 0;
            height: 100%;
            width: 100%;
            background: var(--twitter-blue);
            overflow: hidden;
            z-index: 105;
            color: var(--twitter-white-fix);
        }

        .twitter-login-icon {
            position: relative;
            text-align: center;
            margin: auto;
            font-size: 4vh;
            margin-top: 14vh;
            margin-bottom: 9vh;
        }

        .twitter-login-info {
            position: relative;
            text-align: center;
            font-size: 2vh;
        }

        .twitter-login-input0 {
            display: none;
            position: relative;
            width: 70%;
            margin: auto;
            height: 3.5vh;
            margin-top: 1.5vh;
        }

        .twitter-login-input {
            position: relative;
            width: 70%;
            margin: auto;
            height: 3.5vh;
            margin-top: 1.5vh;
        }

        .twitter-login-input2 {
            position: relative;
            width: 70%;
            margin: auto;
            height: 3.5vh;
            margin-top: 0.2vh;
        }

        .twitter-login-button {
            position: relative;
            width: 50%;
            color: var(--twitter-blue);
            height: 3.5vh;
            line-height: 3.5vh;
            text-align: center;
            font-size: 1.2vh;
            margin: 0.5vh auto auto;
            background: var(--twitter-white-fix);
            border-radius: 3.5vh;
            margin-top: 2.5vh;
            transition: 0.25s;
        }

        .twitter-login-button:hover {
            background: var(--twitter-dirty-white-fix);
        }

        .twitter-login-register {
            position: relative;
            text-align: center;
            margin-top: 4vh;
            font-size: 1.1vh;
            transition: 0.25s;
        }

        .twitter-login-register:hover {
            color: var(--twitter-dirty-white-fix);
        }

        .twitter-login-inputs {
            outline: none;
            border-width: 0;
            position: relative;
            width: 100%;
            margin: auto;
            background: var(--twitter-white-fix);
            color: var(--twitter-gray-fix);
            border-radius: 3.5vh;
            height: 100%;
            line-height: 3.5vh;
            text-align: left;
            text-indent: 2vh;
            font-size: 1.2vh;
        }

        .twitter-login-password {
            margin-top: 0.5vh;
        }
    </style>
    <div class="twitter-login">
        <div class="twitter-login-icon"><i class="fa-brands fa-twitter"></i></div>

        <div class="twitter-login-info">Login</div>
        <div class="twitter-login-input0"><input class="twitter-login-inputs twitter-login-realname" placeholder="Nome"></div>
        <div class="twitter-login-input"><input class="twitter-login-inputs twitter-login-name" placeholder="Username"></div>
        <div class="twitter-login-input2"><input class="twitter-login-inputs twitter-login-password" type="password" placeholder="Password"></div>
        <div class="twitter-login-button">Entrar</div>

        <div class="twitter-login-register">Ainda não tens conta? <b>Registar</b></div>
    </div>
`);


function formatTwitterMessage(TwitterMessage) {
    var TwtMessage = TwitterMessage;
    var res = TwtMessage.split("@");
    var tags = TwtMessage.split("#");
    var InvalidSymbols = ["[", "?", "!", "@", "#", "]"]

    for(i = 1; i < res.length; i++) {
        var MentionTag = res[i].split(" ")[0];
        if (MentionTag !== null && MentionTag !== undefined && MentionTag !== "") {
            TwtMessage = TwtMessage.replace("@"+MentionTag, "<span class='mentioned-tag' data-mentiontag='@"+MentionTag+"' style='color: rgb(27, 149, 224);'>@"+MentionTag+"</span>");
        }
    }

    for(i = 1; i < tags.length; i++) {
        var Hashtag = tags[i].split(" ")[0];

        for(j = 1; j < InvalidSymbols.length; j++){
            var symbol = InvalidSymbols[j];
            var res = Hashtag.indexOf(symbol);

            if (res > -1) {
                Hashtag = Hashtag.replace(symbol, "");
            }
        }

        if (Hashtag !== null && Hashtag !== undefined && Hashtag !== "") {
            TwtMessage = TwtMessage.replace("#"+Hashtag, "<span class='hashtag-tag-text' data-hashtag='"+Hashtag+"' style='color: rgb(27, 149, 224);'>#"+Hashtag+"</span>");
        }
    }

    return TwtMessage
}


function loadTweets(Tweets) {
    if (Tweets === null || Tweets === undefined || Tweets === "" || Tweets.length <= 0) return false;

    $(".twitter-home-tweets").html("");
    $.each(Tweets, function(i, Tweet){
        let TwtMessage = formatTwitterMessage(Tweet.message.text);
        let PictureUrl = "./img/default.png";

        if (typeof(Tweet.avatar_url) === 'string') PictureUrl = Tweet.avatar_url + "?width=128&height=128";

        let TwtPicture = '';

        if (Tweet.message.image !== '') {
            TwtPicture = /*html*/`<div class="tweet-picture"><img src="${Tweet.message.image}" class="tweet-picture-img"></div>`;
        }

        let TweetElement = /*html*/`
            <div class="twitter-tweet">
                <div class="tweet-tweeter" id="tweet-data-${i}">${Tweet.name.replace(/</g, "&lt;").replace(/>/g, "&gt;")} &nbsp;<span>@${Tweet.username.replace(/</g, "&lt;").replace(/>/g, "&gt;")} &middot; ${timeSinceShort(Tweet.time)}</span></div>
                <div class="tweet-message">${TwtMessage.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</div>${TwtPicture.replace(/</g, "&lt;").replace(/>/g, "&gt;")}
                <div class="twt-img" style="top: 1vh;"><img src="${PictureUrl.replace(/</g, "&lt;").replace(/>/g, "&gt;")}" class="tweeter-image"></div>
                <div class="tweet-buttons-container">
                    <div class="tweet-buttons"><i class="fa-light fa-comment"></i></div>
                    <div class="tweet-buttons"><i class="fa-light fa-retweet"></i></div>
                    <div class="tweet-buttons tweet-like-button"><i class="fa-light fa-heart"></i></div>
                    <div class="tweet-buttons"><i class="fa-light fa-arrow-up-from-bracket"></i></div>
                </div>
            </div>
        `;

        $(".twitter-home-tweets").append(TweetElement);

        let dataToAppend = {
            name: Tweet.name,
            username: Tweet.username,
            picture: PictureUrl,
        }
        //append data to tweet element
        $( `#tweet-data-${i}`).data("user", dataToAppend);
    });
}

function loadProfileTweets(Tweets) {
    if (Tweets === null || Tweets === undefined || Tweets === "" || Tweets.length <= 0) return false;

    $(".twitter-profile-tab-tweets").html("");
    $.each(Tweets, function(i, Tweet){
        let TwtMessage = formatTwitterMessage(Tweet.message.text);
        let PictureUrl = "./img/default.png";

        if (typeof(Tweet.avatar_url) === 'string') PictureUrl = Tweet.avatar_url + "?width=128&height=128";

        let TwtPicture = '';

        if (Tweet.message.image !== '') {
            TwtPicture = /*html*/`<div class="tweet-picture"><img src="${Tweet.message.image}" class="tweet-picture-img"></div>`;
        }

        let TweetElement = /*html*/`
            <div class="twitter-tweet">
                <div class="tweet-tweeter">${Tweet.name.replace(/</g, "&lt;").replace(/>/g, "&gt;")} &nbsp;<span>@${Tweet.username.replace(/</g, "&lt;").replace(/>/g, "&gt;")} &middot; ${timeSinceShort(Tweet.time)}</span></div>
                <div class="tweet-message">${TwtMessage.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</div>${TwtPicture.replace(/</g, "&lt;").replace(/>/g, "&gt;")}
                <div class="twt-img" style="top: 1vh;"><img src="${PictureUrl.replace(/</g, "&lt;").replace(/>/g, "&gt;")}" class="tweeter-image"></div>
                <div class="tweet-buttons-container">
                    <div class="tweet-buttons"><i class="fa-light fa-comment"></i></div>
                    <div class="tweet-buttons"><i class="fa-light fa-retweet"></i></div>
                    <div class="tweet-buttons tweet-like-button"><i class="fa-light fa-heart"></i></div>
                    <div class="tweet-buttons"><i class="fa-light fa-arrow-up-from-bracket"></i></div>
                </div>
            </div>
        `;

        $(".twitter-profile-tab-tweets").append(TweetElement);

        /*let dataToAppend = {
            name: Tweet.name,
            username: Tweet.username,
            picture: PictureUrl,
        }
        //append data to tweet element
        $( `#tweet-data-${i}`).data("user", dataToAppend);*/
    });
}

$(document).on('click', '.twitter-home-feed-button', function(e){
    e.preventDefault();

    $(".twitter-home-feed-button").removeClass("twitter-home-feed-selected");
    $(this).addClass("twitter-home-feed-selected");

    if ($(this).hasClass("twitter-home-feed-all")) {
        inFollowingPage = false;
        loadTweets(tweets);
    }
    else if ($(this).hasClass("twitter-home-feed-following")) {
        inFollowingPage = true;
        $.post('http://cphone/twitter_getfollowfeed', JSON.stringify({
            username: localStorage.twitter_username,
            password: localStorage.twitter_password
        }), function(data){
            loadTweets(data.tweets);
        });
    }
});

$(document).on('click', '.twitter-login-button', function(e){
    e.preventDefault();

    let username = $('.twitter-login-name').val();
    let password = $('.twitter-login-password').val();

    if (!isRegistering) {
        $.post('http://cphone/twitter_login', JSON.stringify({
            username: username,
            password: password
        }), function(data){
            loggedIn = data.success;
            accountName = data.name;

            if (loggedIn) {
                if (typeof(data.avatar) === 'string') {
                    $(".twitter-profile-picture").attr("src", data.avatar + "?width=64&height=64");
                } else {
                    $(".twitter-profile-picture").attr("src", "./img/default.png");
                }

                $.post('http://cphone/twitter_getmessages', JSON.stringify({
                    username: username,
                    password: password
                }), function(data){
                    messages = data.messages.reverse();

                    loadTwitterMessages(messages, username);
                });

                $(".twitter-login").fadeOut(200);

                localStorage.twitter_username = username;
                localStorage.twitter_password = password;
            } else {
                QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Conta',"Login inválido!", "#1DA1F2");
            }   
        })
    } else {
        let name = $('.twitter-login-realname').val();

        if (username.length < 4) {
            QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Conta',"Mínimo 4 caracteres para o nome de utilizador!", "#1DA1F2");
            return false;
        }

        if (name.length < 4) {
            QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Conta',"Mínimo 4 caracteres para o nome!", "#1DA1F2");
            return false;
        }

        if (password.length < 6) {
            QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Conta',"Mínimo 6 caracteres para a password!", "#1DA1F2");
            return false;
        }

        $.post('http://cphone/twitter_register', JSON.stringify({
            username: username,
            password: password,
            name: name
        }), function(data){
            let accountCreated = data.success;
            let response = data.response;

            if (accountCreated) {
                isRegistering = false;
        
                $(".twitter-login-info").fadeOut(function() {
                    $(this).text("Login")
                }).fadeIn();
            
                $(".twitter-login-button").text("Entrar");
            
                $(".twitter-login-register").fadeOut(function() {
                    $(this).html("Ainda não tens conta? <b>Registar</b>")
                }).fadeIn();
        
                $(".twitter-login-input0").fadeOut();

                QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Conta',"Conta criada, podes agora fazer login!", "#1DA1F2");
            } else {
                QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", "Conta", response, "#1DA1F2");
            }   
        })
    }

});

$(document).on('click', '.tweet-picture-img', function(e){
    let src = $(this).attr('src')

    viewFullScreenImage(src);
});

$(document).on('click', '.twitter-footer-button', function(e){
    e.preventDefault();

    $(".twitter-home-selected").removeClass("twitter-home-selected");
    $(this).addClass("twitter-home-selected");

    $(".twitter-home-tweets-container").css("display", "none");
    $(".twitter-new-tweet").css("display", "none");
    $(".twitter-home-search").css("display", "none");
    $(".twitter-home-notifications").css("display", "none");
    $(".twitter-home-dm").css("display", "none");

    if ($(this).hasClass("twitter-button-home")) {
        $(".twitter-home-tweets-container").css("display", "block");
        $(".twitter-new-tweet").css("display", "block");
    } else if ($(this).hasClass("twitter-button-search")) {
        $(".twitter-home-search").css("display", "block");
    } else if ($(this).hasClass("twitter-button-notifications")) {
        $(".twitter-home-notifications").css("display", "block");
    } else if ($(this).hasClass("twitter-button-messages")) {
        $(".twitter-home-dm").css("display", "block");
        
    }
});

$(document).on('click', '.tweet-like-button', function(e){
    e.preventDefault();

    $(this).toggleClass("tweet-like-button-active");
});

$(document).on('click', '.twitter-login-register', function(e){
    e.preventDefault();

    $('.twitter-login-name').val('');
    $('.twitter-login-password').val('');
    $('.twitter-login-realname').val('');

    if (!isRegistering) {
        isRegistering = true;

        $(".twitter-login-info").fadeOut(function() {
            $(this).text("Criar conta")
        }).fadeIn();
    
        $(".twitter-login-button").text("Registar");
    
        $(".twitter-login-register").fadeOut(function() {
            $(this).html("Já tens conta? <b>Login</b>")
        }).fadeIn();

        $(".twitter-login-input0").fadeIn()
    } else {
        isRegistering = false;
        
        $(".twitter-login-info").fadeOut(function() {
            $(this).text("Login")
        }).fadeIn();
    
        $(".twitter-login-button").text("Entrar");
    
        $(".twitter-login-register").fadeOut(function() {
            $(this).html("Ainda não tens conta? <b>Registar</b>")
        }).fadeIn(); 

        $(".twitter-login-input0").fadeOut()
    }
});


$(document).on('click', '.twitter-dm-tab-input-button', function(e){
    e.preventDefault();

    var TweetMessage = $(".twitter-dm-tab-input-text").val();
    var chatPartner = $(".twitter-dm-tab-header-name").data("chatpartner");

    if (TweetMessage.length > 1000) {
        QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Mensagens', "Limite de caracteres excedido!", "#1DA1F2");
        return;
    }

    $(".twitter-dm-tab-input-text").val('');

    if (TweetMessage != "") {
        $.post('http://cphone/twitter_sendmessage', JSON.stringify({
            message: TweetMessage,
            username: localStorage.twitter_username,
            password: localStorage.twitter_password,
            target: chatPartner,
            attachments: []
        }));
    } else {
        QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Mensagens', "Escreve uma mensagem!", "#1DA1F2");
    }
});

$(document).on('keypress', function (e) {
    if ($(".twitter-dm-tab").css("display") === "block" && e.target.className === "twitter-dm-tab-input-text") {
        if(e.which === 13){
            var TweetMessage = $(".twitter-dm-tab-input-text").val();
            var chatPartner = $(".twitter-dm-tab-header-name").data("chatpartner");
        
            if (TweetMessage.length > 1000) {
                QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Mensagens', "Limite de caracteres excedido!", "#1DA1F2");
                return;
            }
        
            $(".twitter-dm-tab-input-text").val('');
        
            if (TweetMessage != "") {
                $.post('http://cphone/twitter_sendmessage', JSON.stringify({
                    message: TweetMessage,
                    username: localStorage.twitter_username,
                    password: localStorage.twitter_password,
                    target: chatPartner,
                    attachments: []
                }));
            } else {
                QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Mensagens', "Escreve uma mensagem!", "#1DA1F2");
            }
        }
    }
});


$(document).on('click', '.twitter-new-tweet-accept', function(e){
    e.preventDefault();

    var TweetMessage = $(".twitter-new-tweet-input").val();

    if (TweetMessage.length > 500) {
        QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Novo Tweet', "Limite de caracteres excedido!", "#1DA1F2");
        return;
    }

    $(".twitter-new-tweet-input").val('');

    if (TweetMessage != "") {
        $.post('http://cphone/twitter_post', JSON.stringify({
            message: TweetMessage,
            username: localStorage.twitter_username,
            password: localStorage.twitter_password,
            picture: ''
        }));

        QB.Phone.Animations.BottomSlideDown(".twitter-new-tweet-tab", 200, -120);
    } else {
        QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Novo Tweet', "Escreve uma mensagem!", "#1DA1F2");
    }
});

$(document).on('click', '.twitter-new-tweet-cancel', function(e){
    QB.Phone.Animations.BottomSlideDown(".twitter-new-tweet-tab", 200, -120);
});

$(document).on('click', '.twitter-new-tweet', function(e){
    QB.Phone.Animations.BottomSlideUp(".twitter-new-tweet-tab", 200, 0);
});

$(document).on('click', '.twitter-profile-tab-info-edit-account-text', function(e){
    e.preventDefault();

    const profile = $(".twitter-profile-tab").data("profile");

    if (profile === undefined) return false;
    if (profile.username !== localStorage.twitter_username) {
        if (profile.is_following) {
            $(".twitter-profile-tab-info-edit-account-text").text("Seguir");
            $.post('http://cphone/twitter_unfollow', JSON.stringify({
                username: localStorage.twitter_username,
                password: localStorage.twitter_password,
                target: profile.username
            }));
        }
        else {
            $(".twitter-profile-tab-info-edit-account-text").text("Deixar de seguir");
            $.post('http://cphone/twitter_follow', JSON.stringify({
                username: localStorage.twitter_username,
                password: localStorage.twitter_password,
                target: profile.username
            }));
        }

        $(".twitter-profile-tab").data("profile").is_following = !profile.is_following;

        $(".twitter-profile-tab-info-followers-count").text(parseInt($(".twitter-profile-tab-info-followers-count").text()) + (profile.is_following ? 1 : -1));

        return true;
    }

    $(".twitter-edit-account-name-input").attr("value", profile.name);
    $(".twitter-edit-account-bio-input").attr("value", profile.bio);
    $(".twitter-password-old").val('');
    $(".twitter-password-new").val('');

    QB.Phone.Animations.BottomSlideUp(".twitter-edit-account-tab", 200, 0);
});

$(document).on('click', '.twitter-home-profile', function(e){

    showTwitterClickedProfile(localStorage.twitter_username);
});

$(document).on('click', '.twitter-edit-account-cancel', function(e){
    QB.Phone.Animations.BottomSlideDown(".twitter-edit-account-tab", 200, -120);
});

$(document).on('click', '.twitter-edit-account-logout', function(e){
    $(".twitter-login").fadeIn(200);

    setTimeout(function() {
        QB.Phone.Animations.BottomSlideDown(".twitter-edit-account-tab", 200, -120);

        $(".twitter-profile-tab").animate({
            left: "30vh",
        }, 150, function() {
            $(".twitter-profile-tab").css("display", "none");
        });
    }, 200);

    localStorage.twitter_username = undefined;
    localStorage.twitter_password = undefined;

    $.post('http://cphone/twitter_logout', JSON.stringify({}));
});

$(document).on('click', '.twitter-edit-account-photo', function(e){
    $(".twitter-edit-account-picture-link").val('');
    $('.twitter-edit-account-popup').fadeIn(200);
});

$(document).on('click', '.twitter-link-cancel', function(e){
    $('.twitter-edit-account-popup').fadeOut(200);
});

function getChats(messages, myUsername) {
    let chatMap = {};

    messages.forEach(msg => {
        // Determine the chat partner and their details
        let isSender = msg.sender === myUsername;
        let chatPartner = isSender ? msg.recipient : msg.sender;
        let chatPartnerAvatar = isSender ? msg.recipientAvatar : msg.senderAvatar;
        let chatPartnerLabel = isSender ? msg.recipientLabel : msg.senderLabel;

        // Create a unique key for the chat (sorted to avoid duplicates)
        let chatKey = [msg.sender, msg.recipient].sort().join("-");

        // Store only the latest message per chat
        chatMap[chatKey] = {
            chatPartner: chatPartner,
            chatPartnerAvatar: chatPartnerAvatar,
            chatPartnerLabel: chatPartnerLabel,
            latestMessage: msg.content,
            timestamp: msg.timestamp,
        };
    });

    // Convert the chatMap object back to an array
    return Object.values(chatMap).sort((a, b) => {
        return new Date(b.timestamp) - new Date(a.timestamp); // Sort by timestamp descending
    });
}

function getChatMessages(messages, myUsername, chatPartner) {
    return messages.filter(msg =>
        (msg.sender === myUsername && msg.recipient === chatPartner) ||
        (msg.sender === chatPartner && msg.recipient === myUsername)
    );
}

function loadTwitterDM(messages, username, chatPartner) {
    let chatMessages = getChatMessages(messages, username, chatPartner);
        $(".twitter-dm-tab-messages").html("");
    
        let lastSender = null;
        let lastTimestamp = null;
    
        $.each(chatMessages, function (i, message) {
            let messageText = formatTwitterMessage(message.content);
            let messageTime = timeSinceShort(message.timestamp);
            let messageSender = message.sender === username ? "me" : "them";
    
            let showTime = false;
    
            if (lastSender === null || message.sender !== lastSender) {
                // If it's the first message OR sender has changed, show timestamp
                showTime = true;
            } else {
                let timeDifference = new Date(message.timestamp) - new Date(lastTimestamp);
                if (timeDifference > 5 * 60 * 1000) {
                    // If more than 5 minutes passed, show timestamp
                    showTime = true;
                }
            }
    
            lastSender = message.sender;
            lastTimestamp = message.timestamp;
    
            let messageElement = /*html*/`
                <div class="twitter-dm-message">
                    <div class="twitter-dm-message-${messageSender}">
                        <div class="twitter-dm-message-${messageSender}-text">${messageText.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</div>
                    </div>
                    <div class="twitter-dm-message-${messageSender}-time" style="display: none;">${messageTime}</div>
                </div>
            `;
    
            $(".twitter-dm-tab-messages").append(messageElement);
        });
    
        // Show timestamp only on the last message in a sequence
        let lastMessageBlocks = {};
        $(".twitter-dm-message").each(function () {
            let senderClass = $(this).find(".twitter-dm-message-me").length ? "me" : "them";
            lastMessageBlocks[senderClass] = $(this);
        });
    
        if (lastMessageBlocks["me"]) {
            lastMessageBlocks["me"].find(".twitter-dm-message-me-time").show();
        }
        if (lastMessageBlocks["them"]) {
            lastMessageBlocks["them"].find(".twitter-dm-message-them-time").show();
        }
    
        $(".twitter-dm-tab").css("display", "block");
        $(".twitter-dm-tab-messages .twitter-dm-message:last-child")[0]?.scrollIntoView();
}

function loadTwitterMessages(messages, username) {
    const chats = getChats(messages, username);
    
    //build the chat list
    $(".twitter-home-dm").html("");
    $.each(chats, function(i, chat){
        let chatPartner = chat.chatPartner;
        let chatPartnerAvatar = chat.chatPartnerAvatar;
        let chatPartnerLabel = chat.chatPartnerLabel;
        let latestMessage = chat.latestMessage;
        let timestamp = chat.timestamp;

        let ChatElement = /*html*/`
            <div class="twitter-chat">
                <div class="twitter-chat-partner"><img src="${chatPartnerAvatar || "./img/default.png"}" class="twitter-chat-partner-image"></div>
                <div class="twitter-chat-preview">
                    <div class="twitter-chat-partner-label">${chatPartnerLabel.replace(/</g, "&lt;").replace(/>/g, "&gt;")} &nbsp;<span>@${chatPartner.replace(/</g, "&lt;").replace(/>/g, "&gt;")} &middot; ${timeSinceShort(timestamp)}</span></div>
                    <div class="twitter-chat-latest-message">${latestMessage.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</div>
                </div>
            </div>
        `;

        $(".twitter-home-dm").append(ChatElement);
        $(".twitter-chat").last().data("chatPartner", chatPartner);
    });

    //build chat with click
    $(document).on("click", ".twitter-chat", function (e) {
        e.preventDefault();
    
        let chatPartner = $(this).data("chatPartner");
        let chatPartnerAvatar = $(this).find(".twitter-chat-partner-image").attr("src");
        let chatPartnerLabel = $(this).find(".twitter-chat-partner-label").text().split(" ")[0];
    
        $(".twitter-dm-tab-header-name").text(chatPartnerLabel);
        $(".twitter-dm-tab-header-name").data("chatpartner", chatPartner);
        $(".twitter-dm-tab-header-image").attr("src", chatPartnerAvatar);

        loadTwitterDM(messages, username, chatPartner);
    });
}

$(document).on('click', '.twitter-dm-tab-header-back', function(e){
    e.preventDefault();
    $(".twitter-dm-tab").css("display", "none");
    $(".twitter-dm-tab-messages").html("");
    $(".twitter-dm-tab-input-text").val("");
});



$(document).on('click', '.twitter-profile-tab-header-back', function(e){
    e.preventDefault();

    $(".twitter-profile-tab").animate({
        left: "30vh",
    }, 150, function() {
        $(".twitter-profile-tab").css("display", "none");
    });
});

function showTwitterClickedProfile(username) {
    $.post('http://cphone/twitter_getprofile', JSON.stringify({
        myUsername: localStorage.twitter_username,
        username: username,
    }), function(data){
        const profile = data.profile;
        const tweets = profile.tweets;
        const myUsername = localStorage.twitter_username;
        const isMyAccount = (profile.username === myUsername);

        let pictureUrl = "./img/default.png";
        let profileBio = profile.bio || "Sem descrição";
        if (typeof (profile.avatar_url) === 'string') {
            pictureUrl = profile.avatar_url;
        }

        if (isMyAccount) {
            $(".twitter-profile-tab-info-edit").hide();
            $(".twitter-profile-tab-info-edit-account-text").text("Editar Perfil");
        } else {
            $(".twitter-profile-tab-info-edit").show();

            if (profile.is_following) {
                $(".twitter-profile-tab-info-edit-account-text").text("Deixar de seguir");
            }
            else {
                $(".twitter-profile-tab-info-edit-account-text").text("Seguir");
            }
        }

        $(".twitter-profile-tab-info-image").attr("src", pictureUrl.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
        $(".twitter-profile-tab-info-name").text(profile.name.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
        $(".twitter-profile-tab-info-username").text("@" + profile.username.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
        $(".twitter-profile-tab-info-description").text(profileBio.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
        $(".twitter-profile-tab-info-followers-count").text(profile.follower_count);
        $(".twitter-profile-tab-info-following-count").text(profile.following_count);

        $(".twitter-profile-tab").data("profile", profile);

        loadProfileTweets(tweets);

        $(".twitter-profile-tab").css("display", "block");
        $(".twitter-profile-tab").animate({
            left: "0",
        }, 150);
    });
}

$(document).on('click', '.twitter-profile-tab-info-edit', function(e){
    const profile = $(".twitter-profile-tab").data("profile");

    let picture = "./img/default.png";
    if (typeof (profile.avatar_url) === 'string') {
        picture = profile.avatar_url;
    }

    let username = profile.username;
    let name = profile.name;

    if (username === localStorage.twitter_username) {
        return false;
    }

    //open dm chat
    $(".twitter-dm-tab-header-name").text(name);
    $(".twitter-dm-tab-header-name").data("chatpartner", username);
    $(".twitter-dm-tab-header-image").attr("src", picture);
    loadTwitterDM(messages, localStorage.twitter_username, username);
});

$(document).on('click', '.tweet-tweeter', function(e){
    e.preventDefault();

    let user = $(this).data("user");

    showTwitterClickedProfile(user.username);
});

$(document).on('click', '.twitter-search-user', function(e){
    e.preventDefault();

    let username = $(this).data("user");

    showTwitterClickedProfile(username);
});

let searchTimeout; // Global timeout variable

$(".twitter-home-search-input-text").on("keyup", function() {
    var username = $(this).val();
    
    // Clear previous timeout to reset the delay
    clearTimeout(searchTimeout);

    if (username.length < 4) {
        $(".twitter-home-search-results").html("");
        return false;
    }

    searchTimeout = setTimeout(function () {
        $.post('http://cphone/twitter_searchuser', JSON.stringify({
            username: username,
        }), function (data) {
            const users = data.users;
            $(".twitter-home-search-results").html("");

            $.each(users, function (i, user) {
                let PictureUrl = "./img/default.png";
                if (typeof (user.avatar_url) === 'string') 
                    PictureUrl = user.avatar_url + "?width=256&height=256";

                let UserElement = /*html*/`
                    <div class="twitter-search-user">
                        <div class="twitter-search-user-picture">
                            <img src="${PictureUrl.replace(/</g, "&lt;").replace(/>/g, "&gt;")}" class="twitter-search-user-image">
                        </div>
                        <div class="twitter-search-user-name">
                            <div class="twitter-search-user-label">${user.name.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</div>
                            <div class="twitter-search-user-username">@${user.username.replace(/</g, "&lt;").replace(/>/g, "&gt;")}</div>
                        </div>
                    </div>
                `;

                $(".twitter-home-search-results").append(UserElement);

                $(".twitter-search-user").last().data("user", user.username);
            });
        });
    }, 500); // Debounce by 500ms
});

$(document).on('click', '.twitter-edit-account-accept', async function(e){
    let link = $(".twitter-edit-account-picture-link").val();
    let name = $(".twitter-edit-account-name-input").val();
    let bio = $(".twitter-edit-account-bio-input").val();
    let password = $(".twitter-password-old").val();
    let newpassword = $(".twitter-password-new").val();

    if (link.match(/\.(jpeg|jpg|gif|png)$/) === null) {
        link = '';
    }

    if (name !== '' && name.length < 4) {
        QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Conta',"Mínimo 4 caracteres para o nome!", "#1DA1F2");
        return false;
    }

    if (newpassword !== '' && newpassword.length < 6) {
        QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Conta',"Mínimo 6 caracteres para a password!", "#1DA1F2");
        return false;
    }

    if (newpassword !== '' && password !== '' && password === newpassword) {
        QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Conta',"A nova password tem que ser diferente da antiga!", "#1DA1F2");
        return false;
    }

    if (newpassword !== '' && password !== '' && password !== localStorage.twitter_password) {
        QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Conta',"Password incorreta!", "#1DA1F2");
        return false;
    }

    // Fetch the image from the URL
    if (link !== '') {
        link = await uploadImage(link);
    }

    $.post('http://cphone/twitter_updateaccount', JSON.stringify({
        username: localStorage.twitter_username,
        password: localStorage.twitter_password,
        newpassword: newpassword,
        newname: name,
        newavatar: link,
        newbio: bio,
    }), function(data){
        if (data.success) {
            if (link !== '') {
                $(".twitter-edit-account-image").attr("src", link);
                $(".twitter-profile-tab-info-image").attr("src", link);
                $(".twitter-profile-picture").attr("src", link + "?width=128&height=128");
            }

            if (name !== '') {
                $(".twitter-profile-tab-info-name").text(name.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
                accountName = name;
            }

            if (newpassword !== '') {
                localStorage.twitter_password = newpassword;
            }

            if (bio !== '') {
                $(".twitter-profile-tab-info-description").text(bio.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
            }

            QB.Phone.Animations.BottomSlideDown(".twitter-edit-account-tab", 200, -120);
        }
    })
});

$(document).on('click', '.twitter-link-confirm', function(e){
    let link = $(".twitter-edit-account-picture-link").val();

    if (link.match(/\.(jpeg|jpg|gif|png)$/) === null) {
        QB.Phone.Notifications.Add("fab fa-twitter", "Pwitter", 'Imagem de perfil', "Imagem inválida!", "#1DA1F2");
        return false;
    }

    $(".twitter-edit-account-image").attr("src", link + "?width=128&height=128");

    $('.twitter-edit-account-popup').fadeOut(200);
});

$(document).on('click', '.mentioned-tag', function(e){
    e.preventDefault();
    //CopyMentionTag(this);
});

$(document).on('click', '.twitter-home-settings', function(e){
    if (localStorage.twitterDarkMode !== undefined && localStorage.twitterDarkMode === "true") {
        localStorage.twitterDarkMode = "false";
        $(".twitter-app").removeClass("twitter-app-darkmode");
        QB.Phone.Functions.HeaderTextColor("black", 300);
        $('.phone-home-button').css({"background-color":"rgba(0, 0, 0, 0.75)"});
    } else {
        localStorage.twitterDarkMode = "true";
        $(".twitter-app").addClass("twitter-app-darkmode");
        QB.Phone.Functions.HeaderTextColor("white", 300);
        $('.phone-home-button').css({"background-color":"rgba(255, 255, 255, 0.75)"});
    }
});


function OpenTwitter() {
    let username = localStorage.twitter_username;
    let password = localStorage.twitter_password;

    if (localStorage.twitterDarkMode !== undefined && localStorage.twitterDarkMode === "true") {
        $(".twitter-app").addClass("twitter-app-darkmode");
        QB.Phone.Functions.HeaderTextColor("white", 300);
        $('.phone-home-button').css({"background-color":"rgba(255, 255, 255, 0.75)"});
    } else {
        $(".twitter-app").removeClass("twitter-app-darkmode");
        QB.Phone.Functions.HeaderTextColor("black", 300);
        $('.phone-home-button').css({"background-color":"rgba(0, 0, 0, 0.75)"});
    }

    $(".twitter-login").show();

    loadTweets(tweets);

    if (username !== undefined && password !== undefined) {
        $.post('http://cphone/twitter_login', JSON.stringify({
            username: username,
            password: password
        }), function(data){
            loggedIn = data.success;
            accountName = data.name;

            if (typeof(data.avatar) === 'string') {
                $(".twitter-profile-picture").attr("src", data.avatar + "?width=128&height=128");
            } else {
                $(".twitter-profile-picture").attr("src", "./img/default.png");
            }

            if (loggedIn) {
                $.post('http://cphone/twitter_getmessages', JSON.stringify({
                    username: username,
                    password: password
                }), function(data){
                    messages = data.messages.reverse();

                    loadTwitterMessages(messages, username);
                });

                $(".twitter-login").hide();
            }      
        })    
    }
}


$(document).ready(function(){
    let username = localStorage.twitter_username;
    let password = localStorage.twitter_password;

    if (username !== undefined && password !== undefined) {
        $.post('http://cphone/twitter_login', JSON.stringify({
            username: username,
            password: password
        }));
    }

    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "loadTweets":
                tweets = event.data.tweets;

                if (!inFollowingPage) {
                    loadTweets(event.data.tweets);
                }
                
                break;
            case "loadMessages":
                messages = event.data.messages.reverse();

                loadTwitterMessages(messages, username);

                if ($(".twitter-dm-tab").css("display") === "block") {
                    loadTwitterDM(messages, username, $(".twitter-dm-tab-header-name").data("chatpartner"));
                }

                break;
        }
    })
});