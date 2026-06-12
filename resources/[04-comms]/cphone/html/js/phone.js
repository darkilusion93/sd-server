var CurrentFooterTab = "contacts";
var CallData = {};
var ClearNumberTimer = null;
var SelectedSuggestion = null;
var AmountOfSuggestions = 0;

let isCurrentCallVideo = false;

let contacts = {};
let favoriteContacts = [];
let blockedNumbers = [];

$('.phone-application-container').append(/*html*/`
    <style type="text/css">
        .phone-app {
            display: none;
            height: 100%;
            width: 100%;
            background: rgb(255 255 255);
            overflow: hidden;
        }
    </style>
    <div class="phone-app"></div>
    <div class="phone-call-app"></div>
`);

$('.phone-app').append(/*html*/`
    <style type="text/css">
        .phone-app-header {
            position: relative;
            font-family: 'Samsung Sans bold';
            font-size: 2.6vh;
            top: 5vh;
            margin-left: 1.5vh;
            color: black;
        }

        #total-contacts {
            position: relative;
            font-size: 1.1vh;
            font-family: 'Samsung Sans Medium';
            top: -3vh;
            color: rgba(0, 0, 0, 0.75);
        }

        .phone-app-footer {
            position: absolute;
            height: 4vh;
            width: 100%;
            bottom: 2.2vh;
            z-index: 101;
            border-top: 1px solid rgb(0 0 0 / 11%);
            backdrop-filter: blur(8px);
            display: flex;
            justify-content: center;
        }

        .phone-app-footer-button {
            position: relative;
            height: 100%;
            width: 23%;
            text-align: center;
            line-height: 4vh;
            float: left;
            font-family: 'Samsung Sans Medium';
            font-size: 1.7vh;
            color: #6e6e6e;
            transition: .1s;
        }

        .phone-app-footer-button > p {
            position: absolute;
            top: 1.6vh;
            font-size: 0.9vh;
            text-align: center;
            width: 100%;
        }

        .phone-app-footer-button:hover {
            color: #555555;
        }

        .phone-selected-footer-tab {
            color: rgb(0, 90, 255);
        }

        .phone-selected-footer-tab:hover {
            color: rgb(0, 90, 255);
        }

        .phone-contacts {
            display: block;
            position: relative;
            height: 100%;
            right: 0%;
            width: 100%;
            transition: right 0.2s, color 0.2s;
        }

        .phone-favorites {
            display: none;
            position: absolute;
            height: 100%;
            right: 0%;
            width: 100%;
            background: white;
            transition: right 0.2s, color 0.2s;
        }

        .phone-contacts-left {
            right: 20%;
        }

        .phone-keypad-header {
            padding-top: 6vh;
            padding-left: 3vh;
            font-family: 'Helvetica';
            font-size: 1.8vh;
        }

        #phone-keypad-input {
            position: absolute;
            margin: 0 auto;
            left: 0;
            right: 0;
            top: 8vh;
            height: 4vh;
            width: 24vh;
            text-align: center;
            line-height: 3.9vh;
            font-size: 2.6vh;
            overflow: hidden;
        }

        .phone-keypad {
            display: none;
            position: absolute;
            height: 100%;
            width: 100%;
            top: 0;
            background: white;
        }

        .phone-recent {
            display: none;
            position: absolute;
            height: 100%;
            width: 100%;
            top: 0;
            background: white;
        }

        .phone-recent-header {
            margin-top: 5vh;
            font-size: 1.8vh;
        }

        .phone-recent-calls::-webkit-scrollbar {
            display: none;
        }

        .phone-recent-calls {
            position: relative;
            width: 100%;
            height: 72%;
            overflow-x: hidden;
            overflow-y: scroll;
        }

        .phone-recent-call {
            position: relative;
            height: 4vh;
            width: 92%;
            margin: auto;
            background-color: rgb(255 255 255);
            border-top: 0.1vh solid rgb(51 51 51 / 12%);
        }
        .phone-recent-call:hover {
            color: #686868;
        }
        .phone-recent-call-image {
            position: absolute;
            width: 4vh;
            height: 4vh;
            top: 1.2vh;
            left: 1vh;
            text-align: center;
            line-height: 4.2vh;
            font-size: 1.6vh;
            color: white;
            border-radius: 50%;
            font-family: 'Samsung Sans Bold';
            background: #4e54c8;  /* fallback for old browsers */
            background: -webkit-linear-gradient(to right, #8f94fb, #4e54c8);  /* Chrome 10-25, Safari 5.1-6 */
            background: linear-gradient(to right, #8f94fb, #4e54c8); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
        }
        .phone-recent-call-name {
            position: absolute;
            top: 0.5vh;
            left: 2.5vh;
            font-weight: 700;
            color: black;
        }
        .phone-recent-call-type {
            position: absolute;
            bottom: 1vh;
            left: 0vh;
            font-size: 1.2vh;
            color: rgba(54, 54, 54, 0.808);
        }
        .phone-recent-call-time {
            position: absolute;
            bottom: 1.1vh;
            right: 2.75vh;
            font-size: 1.2vh;
            font-family: 'Helvetica';
            color: rgba(54, 54, 54, 0.808);
        }

        .phone-keypad-keys {
            position: absolute;
            width: 23vh;
            height: 35vh;
            left: 3vh;
            top: 16vh;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-evenly;
        }

        .phone-keypad-key {
            position: relative;
            height: 6vh;
            width: 6vh;
            text-align: center;
            line-height: 6vh;
            font-size: 2.7vh;
            color: black;
            transition: .1s;
            background-color: #e3e3e3;
            border-radius: 4vh;
        }

        .phone-keypad-key:hover {
            background-color: #dbdbdb;
        }

        .phone-keypad-key:active {
            background-color: #e7e7e7;
        }

        .phone-contacts-header {
            position: absolute;
            top: 0;
            height: 4vh;
            width: 100%;
        }

        .phone-contacts-header > i {
            float: right;
            line-height: 4vh;
            font-size: 1.8vh;
            padding-right: 2vh;
            margin-left: 0.2vh;
            transition: .1s;
            color: #000000;
            z-index: 150;
        }

        .phone-contacts-header > i:hover {
            color: #686de0;
        }

        /* #phone-search-icon {
            position: relative;
        }*/

        #phone-plus-icon {
            position: absolute;
            top: 0vh;
            right: 1.5vh;
            font-size: 3vh;
            color: #005aff;
            font-weight: 100;
        }

        #contact-search {
            display: block;
            position: absolute;
            border: none;
            background: rgb(239 239 239);
            top: 5.4vh;
            width: 26vh;
            height: 2.5vh;
            border-radius: 0.5vh;
            outline: none;
            text-indent: 1vh;
            font-size: 1.2vh;
            font-family: 'Helvetica';
        }


        .phone-contact-list::-webkit-scrollbar {
            display: none;
        }

        .phone-contact-list::-webkit-scrollbar-thumb {
            display: none;
        }

        .phone-contact-list::-webkit-scrollbar-track {
            display: none;
        }

        .phone-contact-list {
            height: 67%;
            width: 96%;
            margin: 0 auto;
            margin-top: 5.5vh;
            overflow-y: scroll;
            overflow-x: hidden;
        }

        .phone-favorite-list::-webkit-scrollbar {
            display: none;
        }

        .phone-favorite-list::-webkit-scrollbar-thumb {
            display: none;
        }

        .phone-favorite-list::-webkit-scrollbar-track {
            display: none;
        }

        .phone-favorite-list {
            height: 74%;
            width: 96%;
            margin: 0 auto;
            margin-top: -0.5vh;
            overflow-y: scroll;
            overflow-x: hidden;
        }

        .phone-contact {
            position: relative;
            width: 92%;
            margin: auto;
            left: 0.3vh;
            height: 3.5vh;
            background-color: rgb(255 255 255);
            border-top: 1px solid #0000001c;
            transition: color 0.2s;
        }

        .phone-contact:hover {
            color: black;
        }

        .phone-favorite {
            position: relative;
            width: 96%;
            margin: auto;
            margin-left: 1.2vh;
            height: 4vh;
            background-color: rgb(255 255 255);
            border-top: 1px solid #0000001c;
            transition: color 0.2s;
            display: flex;
            align-items: center;
            gap: 1vh;
        }

        .phone-favorite:hover {
            color: black;
        }

        .phone-contact-firstletter {
            position: absolute;
            /* background-color: #eb4d4b; */
            height: 3.4vh;
            width: 3.4vh;
            margin: .5vh;
            margin-left: .6vh;
            text-align: center;
            line-height: 3.5vh;
            border-radius: 50%;
            font-family: 'Samsung Sans Bold';
            color: white;
        }

        .phone-contact-name {
            line-height: 3.5vh;
            font-size: 1.4vh;
        }

        .phone-favorite-name {
            line-height: 3.5vh;
            font-size: 1.4vh;
        }

        .phone-contact-actions {
            position: absolute;
            right: 0;
            top: .3vh;
            right: 2vh;
            font-size: 2.2vh;
            transition: .1s;
        }

        .phone-contact-actions:hover {
            color: #e74c3c;
        }

        .phone-contact-action-buttons {
            display: none;
            position: absolute;
            bottom: 1.2vh;
            height: 5vh;
            width: 95%;
            margin: 0 auto;
            left: 0;
            right: 0;
        }

        .phone-contact-action-buttons > i {
            position: relative;
            float: left;
            margin-left: 5vh;
            left: -.2vh;
            top: 1vh;
            font-size: 2.3vh;
            color: rgb(44, 44, 44);
            transition: .1s;
        }

        .phone-contact-action-buttons > i:hover {
            color: #eb4d4b;
        }

        .phone-add-contact {
            display: block;
            position: absolute;
            height: 100%;
            width: 100%;
            bottom: -100%;
            background: rgb(251 251 251);
            z-index: 102;
            opacity: 0.0;
            border-radius: 2vh;
            transition: bottom 0.4s, opacity 1.0s;
        }

        .phone-add-contact-show {
            opacity: 1.0;
            bottom: -10%;
            transition: bottom 0.4s, opacity 0.1s;
        }

        .phone-add-contact-name {
            position: relative;
            margin-top: 3vh;
            background: none;
            outline: none;
            border: 1px solid rgba(0, 0, 0, 0.155);
            height: 3.5vh;
            width: 100%;
            font-size: 1.3vh;
            text-indent: 1.5vh;
            background-color: white;
        }

        .phone-edit-contact-name {
            position: relative;
            margin-top: 3vh;
            background: none;
            outline: none;
            border: 1px solid rgba(0, 0, 0, 0.155);
            height: 3.5vh;
            width: 100%;
            font-size: 1.3vh;
            text-indent: 1.5vh;
            background-color: white;
        }

        #phone-add-contact-name-icon {
            position: absolute;
            top: 13.1vh;
            left: 2.1vh;
            font-size: 2.4vh;
        }

        .phone-add-contact-number {
            position: relative;
            background: none;
            outline: none;
            border: none;
            border-bottom: 1px solid rgba(0, 0, 0, 0.155);
            height: 3.5vh;
            width: 100%;
            font-size: 1.3vh;
            text-indent: 1.5vh;
            background-color: white;
        }

        .phone-add-contact-number::-webkit-inner-spin-button {
            display: none;
        }

        .phone-edit-contact-number {
            position: relative;
            background: none;
            outline: none;
            border: none;
            border-bottom: 1px solid rgba(0, 0, 0, 0.155);
            height: 3.5vh;
            width: 100%;
            font-size: 1.3vh;
            text-indent: 1.5vh;
            background-color: white;
        }

        .phone-edit-contact-number::-webkit-inner-spin-button {
            display: none;
        }

        .phone-add-contact-iban {
            position: relative;
            background: none;
            outline: none;
            border: none;
            border-bottom: 1px solid rgba(0, 0, 0, 0.155);
            height: 3.5vh;
            width: 100%;
            font-size: 1.3vh;
            text-indent: 1.5vh;
            background-color: white;
        }

        .phone-add-contact-iban::-webkit-inner-spin-button {
            display: none;
        }

        .phone-edit-contact-iban {
            position: relative;
            background: none;
            outline: none;
            border: none;
            border-bottom: 1px solid rgba(0, 0, 0, 0.155);
            height: 3.5vh;
            width: 100%;
            font-size: 1.3vh;
            text-indent: 1.5vh;
            background-color: white;
        }

        .phone-edit-contact-iban::-webkit-inner-spin-button {
            display: none;
        }

        #phone-add-contact-number-icon {
            position: absolute;
            top: 20.1vh;
            left: 2.1vh;
            font-size: 2.4vh;
        }

        #phone-add-contact-iban-icon {
            position: absolute;
            top: 27.1vh;
            left: 2.1vh;
            font-size: 2.4vh;
        }

        .phone-add-contact-button {
            position: relative;
            width: fit-content;
            text-align: center;
            transition: .1s;
            font-size: 1.3vh;
            color: #007aff;
        }

        .phone-add-contact-button:hover {
            color: #0262cb;
        }

        .phone-add-contact-button:active {
            color: #3194ff;
        }

        .phone-edit-contact-button {
            position: relative;
            width: fit-content;
            text-align: center;
            transition: .1s;
            font-size: 1.3vh;
            color: #007aff;
        }

        .phone-edit-contact-button:hover {
            color: #0262cb;
        }

        .phone-edit-contact-button:active {
            color: #3194ff;
        }

        /* EDIT CONTACT YEEY */

        .phone-edit-contact {
            display: block;
            position: absolute;
            height: 100%;
            width: 100%;
            top: 100%;
            opacity: 0.0;
            background: rgb(230, 230, 230);
            transition: opacity 0.25s, top 1.0s cubic-bezier(1, -0.01, 1, -0.17)
        }

        .phone-edit-contact-show {
            top: 0%;
            opacity: 1.0;
            transition: opacity 0.25s, top 0.0s;
        }

        #phone-edit-contact-number-icon {
            position: absolute;
            top: 20.1vh;
            left: 2.1vh;
            font-size: 2.4vh;
        }

        #phone-edit-contact-iban-icon {
            position: absolute;
            top: 27.1vh;
            left: 2.1vh;
            font-size: 2.4vh;
        }

        .phone-edit-contact-buttons {
            position: absolute;
            bottom: 0;
            height: 5vh;
            width: 100%;
        }

        /* Phone Call App */

        .phone-call-app {
            display: none;
            height: 100%;
            width: 100%;
            background: #de6262  ;  /* fallback for old browsers */
            background: -webkit-linear-gradient(to right, #de6262 , #ffb88c);  /* Chrome 10-25, Safari 5.1-6 */
            background: linear-gradient(to right, #de6262 , #ffb88c); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */    
            background-size: 400% 400%;
            
            -webkit-animation: AnimationName 35s ease infinite;
            -moz-animation: AnimationName 35s ease infinite;
            animation: AnimationName 35s ease infinite;  
            overflow: hidden;
        }

        .phone-call-incoming {
            display: none;
            height: fit-content;
            width: 100%;
        }
        .phone-call-incoming-title {
            position: relative;
            text-align: center;
            margin-top: 0.5vh;
            font-family: 'Helvetica';
            color: white;
            font-size: 1.1vh;
            text-shadow: 0 0 1vh rgba(0, 0, 0, 0.1);
        }
        .phone-call-incoming-caller {
            position: relative;
            text-align: center;
            margin-top: 8vh;
            font-family: 'Helvetica';
            color: white;
            font-size: 2.5vh;
            text-shadow: 0 0 1vh rgba(0, 0, 0, 0.1);
        }
        .phone-call-incoming-picture {
            position: absolute;
            margin: 0 auto;
            width: 12vh;
            height: 12vh;
            left: 0;
            right: 0;
            top: 18vh;
            border-radius: 50%;
            border: .2vh solid #ffffff6c;
            background: rgba(27, 27, 27, 0.25);
            box-shadow: 0 0 .5vh 0 rgba(0, 0, 0, 0.5);
            animation: pulse 2s infinite;
        }
        #incoming-answer {
            transform: rotate(0deg);
            color: white;
            background-color: #34c759;
            height: 5vh;
            width: 5vh;
            text-align: center;
            line-height: 5vh;
            font-size: 1.9vh;
            border-radius: 50%;
            transition: .1s;
        }
        #incoming-answer:hover {
            background-color: #21e151;
            transition: .1s;
        }
        #incoming-deny {
            transform: rotate(132deg);
            color: #ffffff;
            background-color: #e74c3c;
            height: 5vh;
            width: 5vh;
            text-align: center;
            line-height: 5vh;
            font-size: 1.9vh;
            border-radius: 50%;
            transition: .1s;
        }
        #incoming-deny:hover {
            background-color: #e73826;
            transition: .1s;
        }

        #incoming-deny > p {
            position: absolute;
            top: -0.5vh;
            left: 2.8vh;
            font-size: 1.1vh;
            text-align: center;
            width: 100%;
            transform: rotate(-132deg);
            font-family: 'Helvetica';
            font-weight: 100;
            color: white;
            line-height: 1;
        }

        #incoming-answer > p {
            position: absolute;
            top: 5.9vh;
            left: 0.2vh;
            font-size: 1.1vh;
            text-align: center;
            width: 100%;
            font-family: 'Helvetica';
            font-weight: 100;
            color: white;
            line-height: 1;
        }

        /* Outgoing */

        .phone-call-outgoing {
            display: none;
            height: 100%;
            width: 100%;
        }
        .phone-call-outgoing-title {
            position: relative;
            text-align: center;
            margin-top: 0.5vh;
            font-family: 'Helvetica';
            color: white;
            font-size: 1.1vh;
            text-shadow: 0 0 1vh rgba(0, 0, 0, 0.1);
        }
        .phone-call-outgoing-caller {
            position: relative;
            text-align: center;
            margin-top: 8vh;
            font-family: 'Helvetica';
            color: white;
            font-size: 2.5vh;
            text-shadow: 0 0 1vh rgba(0, 0, 0, 0.1);
        }
        .phone-call-outgoing-picture {
            position: absolute;
            margin: 0 auto;
            width: 12vh;
            height: 12vh;
            left: 0;
            right: 0;
            top: 18vh;
            border-radius: 50%;
            border: .2vh solid #ffffff6c;
            background: rgba(27, 27, 27, 0.25);
            box-shadow: 0 0 .5vh 0 rgba(0, 0, 0, 0.5);
            animation: pulse 2s infinite;
        }
        #outgoing-cancel {
            transform: rotate(132deg);
            color: #ffffff;
            background-color: #e74c3c;
            height: 5vh;
            width: 5vh;
            text-align: center;
            line-height: 5vh;
            font-size: 1.9vh;
            border-radius: 50%;
            transition: .1s;
        }
        #outgoing-cancel:hover {
            background-color: #e73826;
            transition: .1s;
        }
        @-webkit-keyframes pulse {
            0% {
            -webkit-box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.8);
            }
            70% {
                -webkit-box-shadow: 0 0 0 10px rgba(255, 255, 255, 0);
            }
            100% {
                -webkit-box-shadow: 0 0 0 0 rgba(255, 255, 255, 0);
            }
        }
        @keyframes pulse {
            0% {
            -moz-box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.8);
            box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.4);
            }
            70% {
                -moz-box-shadow: 0 0 0 10px rgba(255, 255, 255, 0);
                box-shadow: 0 0 0 10px rgba(255, 255, 255, 0);
            }
            100% {
                -moz-box-shadow: 0 0 0 0 rgba(255, 255, 255, 0);
                box-shadow: 0 0 0 0 rgba(255, 255, 255, 0);
            }
        }

        @-webkit-keyframes AnimationName {
            0%{background-position:0% 50%}
            50%{background-position:100% 50%}
            100%{background-position:0% 50%}
        }
        @-moz-keyframes AnimationName {
            0%{background-position:0% 50%}
            50%{background-position:100% 50%}
            100%{background-position:0% 50%}
        }
        @keyframes AnimationName {
            0%{background-position:0% 50%}
            50%{background-position:100% 50%}
            100%{background-position:0% 50%}
        }

        /* Ongoing */

        .phone-call-ongoing {
            display: none;
            height: 100%;
            width: 100%;
        }
        .phone-call-ongoing-title {
            display: none;
            position: relative;
            text-align: center;
            top: 7.5vh;
            font-family: 'Helvetica';
            color: white;
            font-size: 1.1vh;
            text-shadow: 0 0 1vh rgba(0, 0, 0, 0.1);
        }
        .phone-call-ongoing-caller {
            position: relative;
            text-align: center;
            top: 10vh;
            font-family: 'Helvetica';
            color: white;
            font-size: 2.5vh;
            text-shadow: 0 0 1vh rgba(0, 0, 0, 0.1);
        }
        .phone-call-ongoing-picture {
            position: absolute;
            margin: 0 auto;
            width: 12vh;
            height: 12vh;
            left: 0;
            right: 0;
            top: 18vh;
            border-radius: 50%;
            border: .2vh solid #ffffff6c;
            background: rgba(27, 27, 27, 0.25);
            box-shadow: 0 0 .5vh 0 rgba(0, 0, 0, 0.5);
            animation: pulse 2s infinite;
        }
        .phone-call-ongoing-time {
            position: relative;
            text-align: center;
            top: 8vh;
            font-family: 'Helvetica';
            color: white;
            font-size: 1.2vh;
            text-shadow: 0 0 1vh rgba(0, 0, 0, 0.1);
        }
        #ongoing-cancel {
            position: absolute;
            bottom: 8vh;
            margin: 0 auto;
            left: 40.8%;
            transform: rotate(132deg);
            color: #ffffffcc;
            background-color: #e74c3c;
            padding: 1.5vh;
            font-size: 2.5vh;
            border-radius: 50%;
            transition: background-color .1s ease-in-out;
        }
        #ongoing-cancel:hover {
            background-color: #e73826;
            transition: .2s;
        }

        .phone-suggestedcontacts {
            display: none;
            position: absolute;
            height: 100%;
            width: 100%;
            top: 0;
            background: rgb(230, 230, 230);
        }

        .phone-favorites-header {
            width: 100%;
            height: fit-content;
            margin-top: 5.5vh;
            text-indent: 1.5vh;
            font-size: 2.6vh;
            font-weight: bolder;
            line-height: 5vh;
            color: black;
            font-family: 'Samsung Sans bold';
        }

        .suggested-contacts {
            position: absolute;
            width: 100%;
            height: 33vh;
            top: 17vh;
            background-color: rgba(245, 245, 245, 0.788);
            border-radius: 2vh;
            box-shadow: 0 0 .3vh 0vh rgba(0, 0, 0, 0.3);
            overflow-x: hidden;
            overflow-y: scroll;
        }

        .suggested-contacts::-webkit-scrollbar {
            display: none;
        }

        .suggested-contact {
            position: relative;
            height: 6vh;
            width: 100%;
            background-color: rgb(235, 235, 235);
            /* background-color: rgb(44, 44, 44); */
            transition: .05s ease-in-out;
        }

        .suggested-contact:hover {
            background-color: rgb(221, 221, 221);
        }

        .suggested-contact > i {
            position: absolute;
            top: 1.7vh;
            left: 1.5vh;
            font-size: 2.5vh;
            color: rgb(255, 164, 44);
        }

        .suggested-name {
            position: absolute;
            left: 5vh;
            top: 2.1vh;
            font-family: 'Helvetica';
            color: black;
            font-size: 1.3vh;
        }

        .suggested-number {
            font-family: 'Helvetica';
            color: rgb(31, 31, 31);
            font-size: 1.2vh;
        }

        .noselect {
            -webkit-touch-callout: none; /* iOS Safari */
            -webkit-user-select: none; /* Safari */
            -khtml-user-select: none; /* Konqueror HTML */
                -moz-user-select: none; /* Old versions of Firefox */
                -ms-user-select: none; /* Internet Explorer/Edge */
                    user-select: none; /* Non-prefixed version, currently
                                            supported by Chrome, Opera and Firefox */
        }

        .keypad-inv-override {
            margin-top: 1vh;
            background-color: #ffffff;
        }

        .keypad-inv-override:active {
            background-color: #ffffff;
        }

        .keypad-inv-override:hover {
            background-color: #ffffff;
        }

        .keypad-call-override {
            background-color: #34c759;
            color: white;
            margin-top: 1vh;
            font-size: 2vh;
            line-height: 6.3vh;
            rotate: 95deg;
        }

        .keypad-call-override:hover {
            background-color: #40d164;
        }

        .keypad-call-override:active {
            background-color: #37a752;
        }

        .keypad-clear-override {
            margin-top: 1vh;
            font-size: 2vh;
            color: #000000;
            background-color: #ffffff;
            line-height: 6.3vh;
            opacity: 0.0;
            transition: opacity .5s ease-in-out;
        }

        .keypad-clear-show {
            opacity: 1.0;
        }

        .keypad-clear-override:hover {
            color: #383838;
            background-color: #ffffff;
        }

        .keypad-clear-override:active {
            color: #686868;
            background-color: #ffffff;
        }

        .phone-keypad-addcontact {
            position: absolute;
            margin: 0 auto;
            left: 0;
            right: 0;
            top: 11.5vh;
            height: 2vh;
            width: 24vh;
            text-align: center;
            line-height: 2vh;
            font-size: 1.2vh;
            overflow: hidden;
            color: #007aff;
            opacity: 0.0;
            transition: opacity .5s ease-in-out, color .2s ease-in-out;
        }

        .phone-keypad-addcontact:hover {
            color: #4da2ff;
        }

        .phone-keypad-addcontact:active {
            color: #005fc7;   
        }

        .phone-keypad-addcontact-show {
            opacity: 1.0;
        }

        .phone-keypad-hascontact {
            color: black;
        }

        .phone-keypad-hascontact:hover {
            color: black;
        }

        .phone-keypad-hascontact:active {
            color: black;
        }

        .phone-app-keypad-icon {
            letter-spacing: -0.1vh;
        }

        .phone-add-contact-header {
            margin-top: 1.2vh;
            display: flex;
            justify-content: space-around;
        }

        .phone-add-contact-header-text {
            font-size: 1.3vh;
            font-weight: bolder;
        }

        .phone-edit-contact-header {
            display: flex;
            justify-content: space-between;
            width: 87%;
            margin: auto;
            margin-top: 5vh;
        }

        .phone-edit-contact-header-text {
            font-size: 1.3vh;
            font-weight: bolder;
        }

        .phone-add-contact-image {
            width: 10vh;
            height: 10vh;
            margin: auto;
            margin-top: 1.5vh;
        }

        .phone-add-contact-image > img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
        }

        .phone-contact-details {
            position: absolute;
            height: 100%;
            width: 100%;
            left: 100%;
            top: 0;
            opacity: 0.0;
            background: rgb(241 241 241);
            transition: left 0.2s, opacity 1.0s cubic-bezier(1, 0.01, 1, -0.13);
        }

        .phone-contact-details-container {
            width: 100%;
            height: 50.7%;
            overflow-y: scroll;
        }

        .phone-contact-details-container::-webkit-scrollbar {
            display: none;
        }

        .phone-contact-details-show {
            opacity: 1.0;
            left: 0%;
            transition: left 0.2s, opacity 0.01s;
        }

        .phone-contact-details-header {
            margin: auto;
            margin-top: 5vh;
            display: flex;
            justify-content: space-between;
            width: 90%;
            color: #005aff;
            transition: color 0.25s;
        }

        .phone-contact-details-initials {
            width: 8vh;
            height: 8vh;
            margin: auto;
            margin-top: 0.5vh;
            border-radius: 7vh;
            background: linear-gradient(0deg, rgba(99,99,99,1) 0%, rgba(154,154,154,1) 100%);
            text-align: center;
            line-height: 8vh;
            font-size: 3vh;
            color: white;
        }

        .phone-favorite-initials {
            width: 2.8vh;
            height: 2.8vh;
            border-radius: 7vh;
            background: linear-gradient(0deg, rgba(99,99,99,1) 0%, rgba(154,154,154,1) 100%);
            text-align: center;
            line-height: 2.8vh;
            font-size: 1.2vh;
            color: white;
        }

        .phone-edit-contact-initials {
            width: 12vh;
            height: 12vh;
            margin: auto;
            margin-top: 0.5vh;
            border-radius: 7vh;
            background: linear-gradient(0deg, rgba(99,99,99,1) 0%, rgba(154,154,154,1) 100%);
            text-align: center;
            line-height: 12vh;
            font-size: 5vh;
            color: white;
        }

        .phone-contact-details-name {
            font-size: 2vh;
            text-align: center;
            margin-top: 0.5vh;
            color: black;
        }

        .phone-contact-details-actions {
            display: flex;
            justify-content: space-around;
            width: 94%;
            margin: auto;
            margin-top: 1vh;
        }

        .phone-contact-details-action {
            height: 4.5vh;
            width: 6vh;
            background: white;
            border-radius: 0.5vh;
            text-align: center;
            line-height: 3.5vh;
            font-size: 1.4vh;
            color: #2270ff;
        }

        .phone-contact-details-action > p {
            font-size: 1vh;
            line-height: 0vh;
        }

        .phone-contact-details-action-disabled {
            color: #cfcfcf;
        }

        .phone-contact-details-number {
            width: 90.8%;
            margin: auto;
            margin-top: 1vh;
            background: white;
            border-radius: 0.5vh;
            color: #2270ff;
            text-indent: 1vh;
            transition: 0.25s;
        }

        .phone-contact-details-number:hover {
            background: #c9c9c9;
        }

        .phone-contact-details-number:active {
            background: white;
        }

        .phone-contact-details-number-disp {
            color: black;
            font-size: 1.1vh;
            line-height: 2.4vh;
        }

        .phone-contact-details-number-num {
            line-height: 1vh;
            height: 1.5vh;
        }

        .phone-contact-details-iban {
            display: none;
            width: 90.8%;
            margin: auto;
            margin-top: 1vh;
            background: white;
            border-radius: 0.5vh;
            color: #2270ff;
            text-indent: 1vh;
            transition: 0.25s;
        }

        .phone-contact-details-iban:hover {
            background: #c9c9c9;
        }

        .phone-contact-details-iban:active {
            background: white;
        }

        .phone-contact-details-iban-disp {
            color: black;
            font-size: 1.1vh;
            line-height: 2.4vh;
        }

        .phone-contact-details-iban-num {
            line-height: 1vh;
            height: 1.5vh;
        }

        .phone-contact-details-notes {
            width: 90.8%;
            margin: auto;
            margin-top: 1vh;
            background: white;
            border-radius: 0.5vh;
            color: #000000;
            text-indent: 1vh;
            font-size: 1.1vh;
            line-height: 2.5vh;
            height: 8vh;
        }

        .phone-contact-details-buttons {
            width: 90.8%;
            margin: auto;
            margin-top: 1vh;
            background: white;
            border-radius: 0.5vh;
            color: #2270ff;
            text-indent: 1vh;
            line-height: 2.5vh;
            height: fit-content;
            transition: 0.25s;
        }

        .phone-contact-details-button-message {
            height: 3.5vh;
            line-height: 3.5vh;
            transition: 0.25s;
        }

        .phone-contact-details-button-message:hover {
            background: #c9c9c9;
        }

        .phone-contact-details-button-message:active {
            background: white;
        }

        .phone-contact-details-button-favorites {
            height: 3.5vh;
            line-height: 3.5vh;
            border-top: 1px solid rgb(0 0 0 / 11%);
            transition: 0.25s;
        }

        .phone-contact-details-button-favorites:hover {
            background: #c9c9c9;
        }

        .phone-contact-details-button-favorites:active {
            background: white;
        }

        .phone-contact-details-button-add-contact {
            display: none;
            height: 3.5vh;
            line-height: 3.5vh;
            border-top: 1px solid rgb(0 0 0 / 11%);
            transition: 0.25s;
        }

        .phone-contact-details-button-add-contact:hover {
            background: #c9c9c9;
        }

        .phone-contact-details-button-add-contact:active {
            background: white;
        }

        .phone-contact-details-button-location {
            height: 3.5vh;
            line-height: 3.5vh;
            border-top: 1px solid rgb(0 0 0 / 11%);
            transition: 0.25s;
        }

        .phone-contact-details-button-location:hover {
            background: #c9c9c9;
        }

        .phone-contact-details-button-location:active {
            background: white;
        }

        .phone-contact-details-block {
            width: 90.8%;
            margin: auto;
            margin-top: 1vh;
            margin-bottom: 1vh;
            background: white;
            border-radius: 0.5vh;
            color: #ea4335;
            text-indent: 1vh;
            line-height: 3.5vh;
            height: 3.5vh;
            transition: 0.25s;
        }

        .phone-contact-details-block:hover {
            background: #c9c9c9;
        }

        .phone-contact-details-block:active {
            background: white;
        }

        .phone-contact-details-back:hover {
            color: #3e82ff;
        }

        .phone-contact-details-edit:hover {
            color: #3e82ff;
        }

        .phone-delete-contact-button {
            position: relative;
            border: 1px solid rgba(0, 0, 0, 0.155);
            height: 3.5vh;
            width: 100%;
            font-size: 1.3vh;
            text-indent: 1.5vh;
            background-color: white;
            margin-top: 2vh;
            line-height: 3.5vh;
            color: #ea4335;
        }

        .phone-call-background {
            height: 115%;
            width: 115%;
            top: -6%;
            left: -7%;
            background-size: cover;
            background-position-y: 1.05vh;
            background-position-x: -0.3vh;
            background-repeat: no-repeat;
            background-color: #0a0a0a;
            filter: blur(12px);
            position: absolute;
        }

        .phone-call-buttons {
            display: flex;
            justify-content: space-around;
            margin-top: 34vh;
        }

        .phone-favorite-info {
            width: 1.5vh;
            height: 1.5vh;
            margin-left: auto;
            margin-right: 0.8vh;
            fill: #005aff;
            transition: 0.2s;
        }

        .phone-favorite-info:hover {
            fill: #639aff;
        }

        .phone-recent-call-info {
            position: absolute;
            width: 1.5vh;
            height: 1.5vh;
            bottom: 1.3vh;
            right: 0.5vh;
            fill: #005aff;
            transition: 0.2s;
        }

        .phone-recent-call-info:hover {
            fill: #639aff;
        }

        .phone-recent-button {
            display: grid;
            grid-auto-flow: column;
            grid-auto-columns: 1fr;
            height: 2.3vh;
            width: 14.8vh;
            align-items: center;
            margin: auto;
            margin-top: 1vh;
            border-radius: 0.5vh;
            background: rgb(224 224 227);
        }

        .phone-recent-button-button {
            color: #484848;
            right: 1vh;
            top: 7.8vh;
            font-size: 1.1vh;
            background: #d7d7d700;
            width: 100%;
            text-align: center;
            height: 2.1vh;
            line-height: 2.3vh;
            border-radius: 0.5vh;
            transition: 0.2s;
            z-index: 2;
            font-weight: normal;
        }

        .phone-recent-button-button:hover {
            color: #6a6969;
        }

        .phone-recent-button-button:active {
            color: #484848;
        }

        .phone-recent-button-all {
            grid-column: 1;
            grid-row: 1;
        }

        .phone-recent-button-selection {
            background: rgb(255 255 255);
            border: 0.5px solid rgba(0,0,0,0.04);
            box-shadow: 0 3px 8px 0 rgb(0 0 0 / 12%), 0 3px 1px 0 rgb(0 0 0 / 4%);
            border-radius: 0.4vh;
            grid-column: 1;
            grid-row: 1;
            height: 1.9vh;
            width: 7.3vh;
            will-change: transform;
            margin-left: 0.1vh;
            transition: transform .2s ease;
        }

        .phone-recent-button-bold-text {
            font-weight: bold;
            color: #484848;
        }

        .phone-recent-button-bold-text:hover {
            color: #484848;
        }

        .phone-recent-text {
            font-size: 2.6vh;
            font-weight: bold;
            text-indent: 2.5vh;
            margin-top: 0.8vh;
            color: black;
            font-family: 'Samsung Sans bold';
        }

        .phone-recent-call-phone {
            position: absolute;
            top: 2.2vh;
            left: 2.5vh;
            font-size: 1.1vh;
            color: #818181;
        }

        .my-videocall-area {
            position: absolute;
            width: 9vh;
            height: 16vh;
            right: 1vh;
            top: 5.4vh;
            transition: 0.2s;
            border-radius: 0.5vh;
        }

        .videocall-area {
            position: absolute;
            width: 29vh;
            height: 56vh;
            top: 2.5vh;
        }

        .phone-videocall-ongoing {
            display: none;
            height: 100%;
            width: 100%;
        }

        .videocall-background {
            position: absolute;
            width: 100%;
            height: 100%;
            background: black;
        }

        .videocall-controls {
            position: absolute;
            bottom: 0;
            height: 8vh;
            width: 100%;
            border-radius: 1vh;
            background: #000000b8;
            backdrop-filter: blur(8px);
        }

        .videocall-controls-cancel {
            position: absolute;
            bottom: 2vh;
            margin: auto;
            left: 0;
            right: 0;
            color: #ffffffcc;
            background-color: #e74c3c;
            width: 5vh;
            height: 5vh;
            line-height: 5.2vh;
            font-size: 2.5vh;
            text-align: center;
            transform: rotate(135deg);
            border-radius: 50%;
        }

        .videocall-controls-accept {
            position: absolute;
            bottom: 2vh;
            margin: auto;
            left: 45%;
            right: 0;
            color: #ffffffcc;
            background-color: #34c759;
            width: 5vh;
            height: 5vh;
            line-height: 5.2vh;
            font-size: 2.5vh;
            text-align: center;
            transform: rotate(358deg);
            border-radius: 50%;
        }

        .videocall-controls-decline {
            position: absolute;
            bottom: 2vh;
            margin: auto;
            left: 0;
            right: 45%;
            color: #ffffffcc;
            background-color: #e74c3c;
            width: 5vh;
            height: 5vh;
            line-height: 5.2vh;
            font-size: 2.5vh;
            text-align: center;
            transform: rotate(135deg);
            border-radius: 50%;
        }

        .my-videocall-area-big {
            position: absolute;
            width: 29vh;
            height: 56vh;
            top: 4.5vh;
            right: 0;
            border-radius: 0;
        }

        .videocall-before-ongoing {
            width: 100%;
            height: 100%;
            position: absolute;
            background: #00000085;
        }

        .videocall-before-ongoing-header {
            width: 100%;
            height: 2vh;
            position: absolute;
            text-align: center;
            top: 10vh;
            color: white;
            font-size: 2vh;
        }

        .videocall-before-ongoing-footer {
            width: 100%;
            height: 2vh;
            position: absolute;
            text-align: center;
            top: 13vh;
            color: white;
            font-size: 1.2vh;
        }
    </style>
`);

$('.phone-app').append(/*html*/`
    <div class="phone-contacts">
        <div class="phone-app-header">
            <p>Contactos</p>
            <span id="total-contacts">0 contactos</span>
            <i id="phone-plus-icon" class="fas fa-plus"></i>
            <input type="text" id="contact-search" placeholder="Procurar..." spellcheck="false">
        </div>

        <div class="phone-contact-list">
            <!-- <div class="phone-contact" data-contactid="1">
                <div class="phone-contact-firstletter">P</div>
                <div class="phone-contact-name">Pieter Post</div>
                <div class="phone-contact-actions"><i class="fas fa-sort-down"></i></div>

                <div class="phone-contact-action-buttons">
                    <i class="fas fa-phone-volume"></i>
                    <i class="fas fa-comment"></i>
                    <i class="fas fa-user-edit"></i>
                </div>
            </div>-->
        </div>
    </div>

    <div class="phone-contact-details">
        <div class="phone-contact-details-header">
            <div class="phone-contact-details-back"><i class="fa-solid fa-chevron-left"></i>&nbsp;&nbsp;Contactos</div>
            <div class="phone-contact-details-edit">Editar</div>
        </div>

        <div class="phone-contact-details-initials">PH</div>

        <div class="phone-contact-details-name">PLACEHOLDER</div>

        <div class="phone-contact-details-actions">
            <div class="phone-contact-details-action" id="new-chat-phone"><i class="fa-solid fa-comment"></i><p>mensagem</p></div>
            <div class="phone-contact-details-action" id="phone-start-call"><i class="fa-solid fa-phone"></i><p>chamada</p></div>
            <div class="phone-contact-details-action" id="phone-start-videocall"><i class="fa-solid fa-video"></i><p>video</p></div>
            <div class="phone-contact-details-action phone-contact-details-action-disabled"><i class="fa-solid fa-envelope"></i><p>mail</p></div>
        </div>

        <div class="phone-contact-details-container">
            <div class="phone-contact-details-number" id="phone-start-call">
                <div class="phone-contact-details-number-disp">número</div>
                <div class="phone-contact-details-number-num">PLACEHOLDER</div>
            </div>

            <div class="phone-contact-details-iban">
                <div class="phone-contact-details-iban-disp">iban</div>
                <div class="phone-contact-details-iban-num">PLACEHOLDER</div>
            </div>

            <div class="phone-contact-details-notes">Notas</div>

            <div class="phone-contact-details-buttons">
                <div class="phone-contact-details-button-message" id="new-chat-phone">Enviar Mensagem</div>
                <div class="phone-contact-details-button-add-contact">Adicionar aos Contactos</div>
                <div class="phone-contact-details-button-favorites">Adicionar aos Favoritos</div>
                <div class="phone-contact-details-button-location">Partilhar Localização</div>
            </div>

            <div class="phone-contact-details-block">Bloquear Contacto</div>
        </div>
    </div>

    <div class="phone-edit-contact">
        <div class="phone-edit-contact-header">
            <div class="phone-edit-contact-button" id="edit-contact-cancel">Cancelar</div>
            <div class="phone-edit-contact-button" id="edit-contact-save">Guardar</div>
        </div>

        <div class="phone-edit-contact-initials"></div>

        <input type="text" class="phone-edit-contact-name" placeholder="Nome" required spellcheck="false">
        <input type="text" class="phone-edit-contact-number" placeholder="Número" required spellcheck="false">
        <input type="text" class="phone-edit-contact-iban" placeholder="IBAN" required spellcheck="false">

        <div class="phone-delete-contact-button" id="edit-contact-delete"><p>Apagar</p></div>
    </div>

    <div class="phone-recent">
        <div class="phone-recent-header">
            <div class="phone-recent-button">
                <span class="phone-recent-button-selection" style="transform: translateX(0vh);"></span>
                <div class="phone-recent-button-all phone-recent-button-button phone-recent-button-bold-text">Todas</div>
                <div class="phone-recent-button-missed phone-recent-button-button">Perdidas</div>
            </div>
            <div class="phone-recent-text">Recente</div>
        </div>

        <div class="phone-recent-calls">
            <!-- <div class="phone-recent-call"> <div class="phone-recent-call-image">P</div> <div class="phone-recent-call-name">Pieter Post</div> <div class="phone-recent-call-type"><i class="fas fa-phone-slash"></i></div> <div class="phone-recent-call-time">12:05</div> </div> -->
        </div>                            
    </div>

    <div class="phone-favorites">
        <div class="phone-favorites-header">Favoritos</div>

        <div class="phone-favorite-list">
            <!-- <div class="suggested-contact"> <i class="fas fa-exclamation-circle"></i> <span class="suggested-name">Jay Nandes &middot; <span class="suggested-number">0612345678</span></span> </div> -->
            <!-- <div class="suggested-contact">
                <i class="fas fa-exclamation-circle"></i>
                <span class="suggested-name">Jay Nandes &middot; <span class="suggested-number">0612345678</span></span>
            </div> -->
        </div>
    </div>

    <div class="phone-keypad noselect">
        <div id="phone-keypad-input"></div>
        <div class="phone-keypad-addcontact">Adicionar Contacto</div>

        <div class="phone-keypad-keys">
            <div class="phone-keypad-key" data-keypadvalue="1">1</div>
            <div class="phone-keypad-key" data-keypadvalue="2">2</div>
            <div class="phone-keypad-key" data-keypadvalue="3">3</div>
            <div class="phone-keypad-key" data-keypadvalue="4">4</div>
            <div class="phone-keypad-key" data-keypadvalue="5">5</div>
            <div class="phone-keypad-key" data-keypadvalue="6">6</div>
            <div class="phone-keypad-key" data-keypadvalue="7">7</div>
            <div class="phone-keypad-key" data-keypadvalue="8">8</div>
            <div class="phone-keypad-key" data-keypadvalue="9">9</div>
            <div class="phone-keypad-key" data-keypadvalue="-">-</div>
            <div class="phone-keypad-key" data-keypadvalue="0">0</div>
            <div class="phone-keypad-key" data-keypadvalue="#">#</div>
            <div class="phone-keypad-key keypad-inv-override" data-keypadvalue="inv"></div>
            <div class="phone-keypad-key keypad-call-override" data-keypadvalue="call"><i class="fas fa-phone-alt"></i></div>
            <div class="phone-keypad-key keypad-clear-override" data-keypadvalue="clear"><i class="fas fa-backspace"></i></div>
        </div>
    </div>

    <div class="phone-add-contact">
        <div class="phone-add-contact-header">
            <div class="phone-add-contact-button" id="add-contact-cancel">Cancelar</div>
            <div class="phone-add-contact-header-text">Novo Contacto</div>
            <div class="phone-add-contact-button" id="add-contact-save">Guardar</div>
        </div>

        <div class="phone-add-contact-image">
            <img src="../html/img/default.png">
        </div>

        <input type="text" class="phone-add-contact-name" placeholder="Nome" required spellcheck="false">
        <input type="text" class="phone-add-contact-number" placeholder="Número" required spellcheck="false">
        <input type="text" class="phone-add-contact-iban" placeholder="IBAN" required spellcheck="false">
    </div>

    <div class="phone-app-footer">
        <div class="phone-app-footer-button" data-phonefootertab="favorites">
            <i class="fa-solid fa-star"></i>
            <p>Favoritos</p>
        </div>
        <div class="phone-app-footer-button" data-phonefootertab="keypad">
            <div class="phone-app-keypad-icon">
                <i class="fa-solid fa-ellipsis-vertical"></i>
                <i class="fa-solid fa-ellipsis-vertical"></i>
                <i class="fa-solid fa-ellipsis-vertical"></i>
            </div>
            <p>Teclado</p>
        </div>
        <div class="phone-app-footer-button" data-phonefootertab="recent">
            <i class="fa-solid fa-clock"></i><p>Recente</p>
        </div>
        <div class="phone-app-footer-button phone-selected-footer-tab" data-phonefootertab="contacts">
            <i class="fa-solid fa-address-book"></i><p>Contactos</p>
        </div>
    </div>
`);

$('.phone-call-app').append(/*html*/`
    <div class="phone-call-background"></div>
    <div class="phone-call-incoming">
        <div class="phone-call-incoming-caller">Desconhecido</div>
        <div class="phone-call-incoming-title">A receber chamada</div>

        <div class="phone-call-buttons">
            <i class="fas fa-phone" id="incoming-deny"><p>Recusar</p></i>
            <i class="fas fa-phone" id="incoming-answer"><p>Atender</p></i>
        </div>
    </div>

    <div class="phone-call-outgoing">
        <div class="phone-call-outgoing-caller">Desconhecido</div>
        <div class="phone-call-outgoing-title">A ligar...</div>

        <div class="phone-call-buttons">
            <i class="fas fa-phone" id="outgoing-cancel"></i>
        </div>
    </div>

    <div class="phone-call-ongoing">
        <div class="phone-call-ongoing-title">Em curso</div>
        <div class="phone-call-ongoing-caller">Desconhecido</div>
        <div class="phone-call-ongoing-time">05:05</div>

        <i class="fas fa-phone" id="ongoing-cancel"></i>
    </div>

    <div class="phone-videocall-ongoing">
        <div class="videocall-background"></div>
        <video id="othercamera-stream" class="videocall-area" autoplay muted></video>
        <canvas id="mycamera-render" class="my-videocall-area"></canvas>
        <div class="videocall-before-ongoing">
            <div class="videocall-before-ongoing-header"></div>
            <div class="videocall-before-ongoing-footer"></div>
        </div>
        <div class="videocall-controls">
            <div class="videocall-controls-accept"><i class="fas fa-phone"></i></div>
            <div class="videocall-controls-decline"><i class="fas fa-phone"></i></div>
            <div class="videocall-controls-cancel"><i class="fas fa-phone"></i></div>
        </div>
    </div>
`);

function OpenPhoneApp() {
    $.post('http://cphone/GetMissedCalls', JSON.stringify({}), function(recent){
        $(".phone-recent-button-selection").css('transform', 'translateX(0vh)');
        QB.Phone.Functions.SetupRecentCalls(recent, false);
    });
}

function isNumberInContacts(number) {
    let contactName = undefined;

    $.each(contacts, function(i, contact){
        if (contact.number == number) {
            contactName = contact.name;
        }
    });

    return contactName;
}

function copyStringToClipboard(str) {
    // Create new element
    var el = document.createElement('textarea');
    // Set value (string to be copied)
    el.value = str;
    // Set non-editable to avoid focus and move outside of view
    el.setAttribute('readonly', '');
    el.style = {position: 'absolute', left: '-9999px'};
    document.body.appendChild(el);
    // Select text inside element
    el.select();
    // Copy text to clipboard
    document.execCommand('copy');
    // Remove temporary element
    document.body.removeChild(el);
}

function timeSince(date) {
    var seconds = Math.floor((new Date() - new Date(date * 1000)) / 1000);
    var interval = seconds / 31536000;
  
    if (interval > 1) {
        if (Math.floor(interval) === 1) {
            return Math.floor(interval) + " ano";
        } else {
            return Math.floor(interval) + " anos";
        }
    }
    interval = seconds / 2592000;
    if (interval > 1) {
        if (Math.floor(interval) === 1) {
            return Math.floor(interval) + " mês";
        } else {
            return Math.floor(interval) + " mêses";
        }
    }
    interval = seconds / 86400;
    if (interval > 1) {
        if (Math.floor(interval) === 1) {
            return Math.floor(interval) + " dia";
        } else {
            return Math.floor(interval) + " dias";
        }
    }
    interval = seconds / 3600;
    if (interval > 1) {
        if (Math.floor(interval) === 1) {
            return Math.floor(interval) + " hora";
        } else {
            return Math.floor(interval) + " horas";
        }
    }
    interval = seconds / 60;
    if (interval > 1) {
        if (Math.floor(interval) === 1) {
            return Math.floor(interval) + " minuto";
        } else {
            return Math.floor(interval) + " minutos";
        }
    }

    if (Math.floor(seconds) === 1) {
        return Math.floor(seconds) + " segundos";
    } else {
        return Math.floor(seconds) + " segundos";
    }
}

$(document).on('click', '.phone-keypad-key', function(e){
    e.preventDefault();

    var PressedButton = $(this).data('keypadvalue');

    if (!isNaN(PressedButton) || PressedButton == "-" || PressedButton == "#") {
        var keyPadHTML = $("#phone-keypad-input").text();
        $("#phone-keypad-input").text(keyPadHTML + PressedButton);
    } else if (PressedButton == "clear") {
        var keyPadHTML = $("#phone-keypad-input").text();

        keyPadHTML = keyPadHTML.slice(0, -1);

        $("#phone-keypad-input").text(keyPadHTML);
    } else if (PressedButton == "call") {
        let number = $("#phone-keypad-input").text();

        if (number === undefined || number === null || number === "") {return false;}

        setupCall({number: number, name: number}, false);
        return true;
    }

    let finalText = $("#phone-keypad-input").text();

    if (finalText.length <= 0) {
        $(".keypad-clear-override").removeClass("keypad-clear-show");
        $(".phone-keypad-addcontact").removeClass("phone-keypad-addcontact-show");
        return false;
    }

    let name = isNumberInContacts(finalText);

    if (name !== undefined) {
        $(".phone-keypad-addcontact").addClass("phone-keypad-hascontact")
        $(".phone-keypad-addcontact").text(name);
    } else {
        $(".phone-keypad-addcontact").removeClass("phone-keypad-hascontact")
        $(".phone-keypad-addcontact").text('Adicionar Contacto');
    }

    $(".keypad-clear-override").addClass("keypad-clear-show");
    $(".phone-keypad-addcontact").addClass("phone-keypad-addcontact-show");
});

$(document).on('click', '.phone-app-footer-button', function(e){
    e.preventDefault();

    var PressedFooterTab = $(this).data('phonefootertab');

    if (PressedFooterTab !== CurrentFooterTab) {
        $('.phone-app-footer').find('[data-phonefootertab="'+CurrentFooterTab+'"').removeClass('phone-selected-footer-tab');
        $(this).addClass('phone-selected-footer-tab');

        $(".phone-"+CurrentFooterTab).hide();
        $(".phone-"+PressedFooterTab).show();

        CurrentFooterTab = PressedFooterTab;
    }
});

$(document).on('click', '#phone-plus-icon', function(e){
    e.preventDefault();

    $(".phone-add-contact").addClass("phone-add-contact-show");
});

$(document).on('click', '.phone-keypad-addcontact', function(e){
    e.preventDefault();

    if (!$(".phone-keypad-addcontact").hasClass("phone-keypad-hascontact")) {
        $(".phone-add-contact-number").val($("#phone-keypad-input").text());
        $(".phone-add-contact").addClass("phone-add-contact-show");
    }
});

$(document).on('click', '#phone-keypad-input', function(e){
    e.preventDefault();

    //TODO: add tooltip to paste number from clipboard
})

$(document).on('click', '.phone-contact-details-back', function(e){
    e.preventDefault();

    $(".phone-contact-details").removeClass("phone-contact-details-show");
    $(".phone-contacts").removeClass("phone-contacts-left");
})

var CurrentContactData = {}

$(document).on('click', '.phone-contact', function(e){
    e.preventDefault();

    var ContactId = $(this).data('contactid');
    var ContactData = $(`[data-contactid='${ContactId}']`).data('contactData');

    var matches = ContactData.name.match(/\b(\w)/g); // ['J','S','O','N']
    let acronym = /*html*/`<i class="fa-solid fa-user"></i>`;

    if (matches !== null) {
        acronym = matches.join('').substring(0, 2).toUpperCase(); // JSON
    }

    $(".phone-contact-details-initials").html(acronym);
    $(".phone-contact-details-name").text(ContactData.name);
    $(".phone-contact-details-number-num").text(ContactData.number);

    if (ContactData.iban !== undefined && ContactData.iban !== null && ContactData.iban !== 0 && ContactData.iban !== "") {
        $(".phone-contact-details-iban").show();
        $(".phone-contact-details-iban-num").text(ContactData.iban);
    } else {
        $(".phone-contact-details-iban").hide();
    }

    $(".phone-contact-details-button-favorites").show();
    $(".phone-contact-details-button-add-contact").hide();

    if (favoriteContacts.includes(ContactData.number)) {
        $(".phone-contact-details-button-favorites").text("Remover dos Favoritos");
    } else {
        $(".phone-contact-details-button-favorites").text("Adicionar aos Favoritos");
    }

    if (blockedNumbers.includes(ContactData.number)) {
        $(".phone-contact-details-block").text("Desbloquear Contacto");
    } else {
        $(".phone-contact-details-block").text("Bloquear Contacto");
    }

    CurrentContactData.name = ContactData.name
    CurrentContactData.number = ContactData.number
    CurrentContactData.iban = ContactData.iban

    $(".phone-contact-details").addClass("phone-contact-details-show");
    $(".phone-contacts").addClass("phone-contacts-left");
})

$(document).on('click', '.phone-contact-details-edit', function(e){
    e.preventDefault();

    $(".phone-edit-contact-name").val(CurrentContactData.name);
    $(".phone-edit-contact-number").val(CurrentContactData.number);

    var matches = CurrentContactData.name.match(/\b(\w)/g); // ['J','S','O','N']
    let acronym = /*html*/`<i class="fa-solid fa-user"></i>`;

    if (matches !== null) {
        acronym = matches.join('').substring(0, 2).toUpperCase(); // JSON
    }

    $(".phone-edit-contact-initials").html(acronym);

    if (CurrentContactData.iban != null && CurrentContactData.iban != undefined) {
        $(".phone-edit-contact-iban").val(CurrentContactData.iban);
    } else {
        $(".phone-edit-contact-iban").val("");
    }

    $(".phone-edit-contact").addClass("phone-edit-contact-show");
});

$(document).on('click', '.phone-contact-details-button-favorites', function(e){
    e.preventDefault();
    
    if (favoriteContacts.includes(CurrentContactData.number)) {
        favoriteContacts = favoriteContacts.filter(function(item) {
            return item !== CurrentContactData.number;
        });

        $(".phone-contact-details-button-favorites").text("Adicionar aos Favoritos");
    } else {
        favoriteContacts.push(CurrentContactData.number)
        $(".phone-contact-details-button-favorites").text("Remover dos Favoritos");
    }

    localStorage.favorite_contacts = JSON.stringify(favoriteContacts);

    QB.Phone.Functions.LoadContacts(contacts);
});

$(document).on('click', '.phone-contact-details-button-add-contact', function(e){
    e.preventDefault();
    
    CurrentContactData.number

    $(".phone-add-contact-number").val(RecentData.number);
    $(".phone-add-contact").addClass("phone-add-contact-show");

    QB.Phone.Functions.LoadContacts(contacts);
});

$(document).on('click', '.phone-contact-details-block', function(e){
    e.preventDefault();
    
    if (blockedNumbers.includes(CurrentContactData.number)) {
        blockedNumbers = blockedNumbers.filter(function(item) {
            return item !== CurrentContactData.number;
        });

        $(".phone-contact-details-block").text("Bloquear Contacto");
    } else {
        blockedNumbers.push(CurrentContactData.number)
        $(".phone-contact-details-block").text("Desbloquear Contacto");
    }

    localStorage.blocked_numbers = JSON.stringify(blockedNumbers);
});

$(".phone-edit-contact-name").on("keyup", function() {
    var value = $(this).val();

    var matches = value.match(/\b(\w)/g); // ['J','S','O','N']
    let acronym = /*html*/`<i class="fa-solid fa-user"></i>`;

    if (matches !== null) {
        acronym = matches.join('').substring(0, 2).toUpperCase(); // JSON
    }

    $(".phone-edit-contact-initials").html(acronym);
});

$(document).on('click', '#edit-contact-save', function(e){
    e.preventDefault();

    var ContactName = $(".phone-edit-contact-name").val();
    var ContactNumber = $(".phone-edit-contact-number").val();
    var ContactIban = $(".phone-edit-contact-iban").val();

    if (ContactName != "" && ContactNumber != "") {
        $(".phone-contact-details-name").text(ContactName);
        $(".phone-contact-details-number-num").text(ContactNumber);

        if (ContactIban !== undefined && ContactIban !== null && ContactIban !== 0 && ContactIban !== "") {
            $(".phone-contact-details-iban").show();
            $(".phone-contact-details-iban-num").text(ContactIban);
        } else {
            $(".phone-contact-details-iban").hide();
        }

        $.post('http://cphone/EditContact', JSON.stringify({
            CurrentContactName: ContactName,
            CurrentContactNumber: ContactNumber,
            CurrentContactIban: ContactIban,
            OldContactName: CurrentContactData.name,
            OldContactNumber: CurrentContactData.number,
            OldContactIban: CurrentContactData.iban,
        }), function(PhoneContacts){
            QB.Phone.Functions.LoadContacts(PhoneContacts);
        });
        $(".phone-edit-contact").removeClass("phone-edit-contact-show");
        setTimeout(function(){
            $(".phone-edit-contact-number").val("");
            $(".phone-edit-contact-name").val("");
        }, 250)
    } else {
        QB.Phone.Notifications.Add("fas fa-exclamation-circle", "Adicionar Contacto", "Erro", "Preenche todos os campos!","#eb4034", 2000);
    }
});

$(document).on('click', '#edit-contact-delete', function(e){
    e.preventDefault();

    var ContactName = $(".phone-edit-contact-name").val();
    var ContactNumber = $(".phone-edit-contact-number").val();
    var ContactIban = $(".phone-edit-contact-iban").val();

    $.post('http://cphone/DeleteContact', JSON.stringify({
        CurrentContactName: ContactName,
        CurrentContactNumber: ContactNumber,
        CurrentContactIban: ContactIban,
    }), function(PhoneContacts){
        QB.Phone.Functions.LoadContacts(PhoneContacts);
    });
    $(".phone-edit-contact").removeClass("phone-edit-contact-show");
    $(".phone-contact-details").removeClass("phone-contact-details-show");
    $(".phone-contacts").removeClass("phone-contacts-left");
    setTimeout(function(){
        $(".phone-edit-contact-number").val("");
        $(".phone-edit-contact-name").val("");
    }, 250);
});

$(document).on('click', '#new-chat-phone', function(e){
    var ContactData = CurrentContactData;

    if (ContactData.number !== myPhoneNumber) {
        refreshLatestMessages();

        QB.Phone.Functions.HeaderTextColor("white", 400);
        QB.Phone.Animations.CloseApp('.phone-application-container', 400);
        setTimeout(function(){
            QB.Phone.Functions.ToggleApp("phone", "none");
            QB.Phone.Functions.ToggleApp("whatsapp", "block");
            QB.Phone.Data.currentApplication = "whatsapp";
            QB.Phone.Animations.OpenApp('.phone-application-container', 300);
        
            refreshOpenedChatMessages(ContactData.number);

            $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 150);
            $(".whatsapp-openedchat").css({"display":"block"});
            $(".whatsapp-openedchat").css({left: 0+"vh"});
            $(".whatsapp-chats").animate({left: 30+"vh"},100, function(){
                $(".whatsapp-chats").css({"display":"none"});
            });
        }, 400)
    } else {
        QB.Phone.Notifications.Add("fa fa-phone-alt", "Telefone", "Erro", "Não podes enviar mensagens a ti próprio...", "default", 3500);
    }
});

$(document).on('click', '#edit-contact-cancel', function(e){
    e.preventDefault();

    $(".phone-edit-contact").removeClass("phone-edit-contact-show");
    setTimeout(function(){
        $(".phone-edit-contact-number").val("");
        $(".phone-edit-contact-name").val("");
    }, 250)
});

$(document).on('click', '#add-contact-save', function(e){
    e.preventDefault();

    var ContactName = $(".phone-add-contact-name").val();
    var ContactNumber = $(".phone-add-contact-number").val();
    var ContactIban = $(".phone-add-contact-iban").val();

    if (ContactName != "" && ContactNumber != "") {
        $.post('http://cphone/AddNewContact', JSON.stringify({
            ContactName: ContactName,
            ContactNumber: ContactNumber,
            ContactIban: ContactIban,
        }), function(PhoneContacts){
            QB.Phone.Functions.LoadContacts(PhoneContacts);
        });
        $(".phone-add-contact").removeClass("phone-add-contact-show");
        setTimeout(function(){
            $(".phone-add-contact-number").val("");
            $(".phone-add-contact-name").val("");
        }, 250)
    } else {
        QB.Phone.Notifications.Add("fas fa-exclamation-circle", "Adicionar Contacto", "Erro", "Preenche todos os campos!","#eb4034", 2000);
    }
});

$(document).on('click', '#add-contact-cancel', function(e){
    e.preventDefault();

    $(".phone-add-contact").removeClass("phone-add-contact-show");
    setTimeout(function(){
        $(".phone-add-contact-number").val("");
        $(".phone-add-contact-name").val("");
    }, 250)
});

$(document).on('click', '#phone-start-call', function(e){
    e.preventDefault();   
    
    var ContactData = CurrentContactData;
    let isVideo = false;
    
    setupCall(ContactData, isVideo);
});

$(document).on('click', '.phone-favorite', function(e){
    e.preventDefault();

    let clickedClass = $(e.target).closest("div").attr("class");

    if (clickedClass === "phone-favorite-info") {
        $('.phone-app-footer').find(`[data-phonefootertab="${CurrentFooterTab}"`).removeClass('phone-selected-footer-tab');
        $('.phone-app-footer').find(`[data-phonefootertab="contacts"`).addClass('phone-selected-footer-tab');

        $(`.phone-${CurrentFooterTab}`).hide();
        $(`.phone-contacts`).show();

        CurrentFooterTab = "contacts";

        var ContactId = $(this).data('contactid');
        var ContactData = $(`[data-contactid='${ContactId}']`).data('contactData');
    
        var matches = ContactData.name.match(/\b(\w)/g); // ['J','S','O','N']
        let acronym = /*html*/`<i class="fa-solid fa-user"></i>`;
    
        if (matches !== null) {
            acronym = matches.join('').substring(0, 2).toUpperCase(); // JSON
        }
    
        $(".phone-contact-details-initials").html(acronym);
        $(".phone-contact-details-name").text(ContactData.name);
        $(".phone-contact-details-number-num").text(ContactData.number);
    
        if (ContactData.iban !== undefined && ContactData.iban !== null && ContactData.iban !== 0 && ContactData.iban !== "") {
            $(".phone-contact-details-iban").show();
            $(".phone-contact-details-iban-num").text(ContactData.iban);
        } else {
            $(".phone-contact-details-iban").hide();
        }

        $(".phone-contact-details-button-favorites").show();
        $(".phone-contact-details-button-add-contact").hide();
    
        if (favoriteContacts.includes(ContactData.number)) {
            $(".phone-contact-details-button-favorites").text("Remover dos Favoritos");
        } else {
            $(".phone-contact-details-button-favorites").text("Adicionar aos Favoritos");
        }

        if (blockedNumbers.includes(ContactData.number)) {
            $(".phone-contact-details-block").text("Desbloquear Contacto");
        } else {
            $(".phone-contact-details-block").text("Bloquear Contacto");
        }
    
        CurrentContactData.name = ContactData.name
        CurrentContactData.number = ContactData.number
        CurrentContactData.iban = ContactData.iban
    
        $(".phone-contact-details").addClass("phone-contact-details-show");
        $(".phone-contacts").addClass("phone-contacts-left");

        return true;
    }

    var ContactId = $(this).data('contactid');
    var ContactData = $(`[data-contactid='${ContactId}']`).data('contactData');
    
    setupCall(ContactData, false);
});

$(document).on('click', '#phone-start-videocall', function(e){
    e.preventDefault();   
    
    var ContactData = CurrentContactData;
    let isVideo = true;
    
    setupCall(ContactData, isVideo);
});

$(document).on('click', '.phone-contact-details-iban', function(e){
    e.preventDefault();   
    
    copyStringToClipboard(CurrentContactData.iban);
    
    QB.Phone.Notifications.Add("fas fa-exclamation-circle", "Contactos", "Informações", "IBAN Copiado!","#eb4034", 2000);
});

$(document).on('click', '.phone-contact-details-button-location', function(e){
    e.preventDefault();

    $.post('http://cphone/SendMessage', JSON.stringify({
        ChatNumber: CurrentContactData.number,
        ChatMessage: "Coordenadas GPS",
        ChatType: "location",
    }));

    QB.Phone.Notifications.Add("fas fa-exclamation-circle", "Contactos", "Informações", "Localização enviada","#eb4034", 2000);
});

QB.Phone.Functions.LoadContacts = function(myContacts) {
    //TODO: sort contacts here...
    $(".phone-contact-list").html("");
    $(".phone-favorite-list").html("");
    $(".whatsapp-contact-list").html("");
    var TotalContacts = 0;

    //sort contacts by name
    myContacts.sort(function(a, b) {
        if (a.name.toLowerCase() < b.name.toLowerCase()) return -1;
        if (a.name.toLowerCase() > b.name.toLowerCase()) return 1;
        return 0;
    });

    contacts = myContacts;

    if (localStorage.favorite_contacts === null || localStorage.favorite_contacts === undefined) {
        favoriteContacts = [];
    } else {
        favoriteContacts = JSON.parse(localStorage.favorite_contacts);
    }

    if (localStorage.blocked_numbers === null || localStorage.blocked_numbers === undefined) {
        blockedNumbers = [];
    } else {
        blockedNumbers = JSON.parse(localStorage.blocked_numbers);
    }

    //TODO: add job contacts

    $(".phone-contacts").hide();
    $(".phone-recent").hide();
    $(".phone-keypad").hide();

    $(`.phone-${CurrentFooterTab}`).show();

    $("#contact-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $(".phone-contact-list .phone-contact").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });

    if (myContacts !== null && myContacts !== undefined) {
        $.each(myContacts, function(i, contact){
            if (contact.name === null || contact.name === undefined) { contact.name = '?'; }
            
            let ContactElement = /*html*/`
                <div class="phone-contact" data-contactid="${i}">
                    <div class="phone-contact-name">${contact.name}</div>
                </div>`;

            let WhatsappElement = /*html*/`
                <div class="whatsapp-contact" data-contactid="${i}">
                    <div class="whatsapp-contact-firstletter">${((contact.name).charAt(0)).toUpperCase()}</div>
                    <div class="contact-checked"><i class="fas fa-check"></i></div>
                    <div class="whatsapp-contact-name">${contact.name}</div>
                </div>`;
            
            TotalContacts = TotalContacts + 1

            if (favoriteContacts.includes(contact.number)) {
                var matches = contact.name.match(/\b(\w)/g); // ['J','S','O','N']
                let acronym = /*html*/`<i class="fa-solid fa-user"></i>`;
            
                if (matches !== null) {
                    acronym = matches.join('').substring(0, 2).toUpperCase(); // JSON
                }

                let FavoriteElement = /*html*/`
                    <div class="phone-favorite" data-contactid="${i}">
                        <div class="phone-favorite-initials">${acronym}</div>
                        <div class="phone-favorite-name">${contact.name}</div>
                        <div class="phone-favorite-info" data-contactid="${i}"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!--! Font Awesome Pro 6.2.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2022 Fonticons, Inc. --><path d="M256 0C114.6 0 0 114.6 0 256s114.6 256 256 256s256-114.6 256-256S397.4 0 256 0zM256 464c-114.7 0-208-93.31-208-208S141.3 48 256 48s208 93.31 208 208S370.7 464 256 464zM296 336h-16V248C280 234.8 269.3 224 256 224H224C210.8 224 200 234.8 200 248S210.8 272 224 272h8v64h-16C202.8 336 192 346.8 192 360S202.8 384 216 384h80c13.25 0 24-10.75 24-24S309.3 336 296 336zM256 192c17.67 0 32-14.33 32-32c0-17.67-14.33-32-32-32S224 142.3 224 160C224 177.7 238.3 192 256 192z"></path></svg></div>
                    </div>`;

                $(".phone-favorite-list").append(FavoriteElement);
            }

            $(".phone-contact-list").append(ContactElement);
            $(".whatsapp-contact-list").append(WhatsappElement);
            $(`[data-contactid="${i}"]`).data('contactData', contact);
        });

        $("#total-contacts").text(TotalContacts+ " contactos");
    } else {
        $("#total-contacts").text("0 contactos");
    }
};

function setupCall(cData, isVideo) {
    if (cData.number === myPhoneNumber) {
        QB.Phone.Notifications.Add("fas fa-phone", "Telemóvel", "Erro", "Não podes ligar para ti próprio","#eb4034", 2000);
        return false;
    }

    if (blockedNumbers.includes(cData.number)) {
        QB.Phone.Notifications.Add("fas fa-phone", "Telemóvel", "Erro", "Contacto bloqueado!","#eb4034", 2000);
        return false;
    }

    $.post('http://cphone/CallContact', JSON.stringify({
        ContactData: cData,
        isVideo: isVideo,
        Anonymous: QB.Phone.Data.AnonymousCall,
    }), function(status){
        if (!status.CanCall) {
            QB.Phone.Notifications.Add("fas fa-phone", "Telemóvel", "Erro", "Número ocupado","#eb4034", 2000);
            return false;
        }

        if (status.InCall) {
            QB.Phone.Notifications.Add("fas fa-phone", "Telemóvel", "Erro", "Estás numa chamada!","#eb4034", 2000);
            return false;
        }

        isCurrentCallVideo = isVideo;

        CallData.CallType = "outgoing";

        if (isVideo) {
            $(".phone-call-outgoing").css({"display":"none"});
            $(".phone-call-incoming").css({"display":"none"});
            $(".phone-call-ongoing").css({"display":"none"});
            $(".phone-videocall-ongoing").css({"display":"block"});

            $(".my-videocall-area").addClass("my-videocall-area-big");
            $(".videocall-controls-accept").css({"display":"none"});
            $(".videocall-controls-decline").css({"display":"none"});
            $(".videocall-controls-cancel").css({"display":"block"});

            $(".videocall-before-ongoing").show();

            $(".videocall-before-ongoing-header").text(cData.name);
            $(".videocall-before-ongoing-footer").text("A Chamar...");
            
            QB.Phone.Functions.HeaderTextColor("white", 400);
            QB.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
            setTimeout(function(){
                $(".phone-app").css({"display":"none"});
                QB.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                QB.Phone.Functions.ToggleApp("phone-call", "block");
            }, 450);

            CallData.name = cData.name;
            CallData.number = cData.number;
        
            QB.Phone.Data.currentApplication = "phone-call";

            $(".my-videocall-area").addClass("my-videocall-area-big");

            handleCallVideo();

            return true;
        }

        $(".phone-call-outgoing").css({"display":"block"});
        $(".phone-call-incoming").css({"display":"none"});
        $(".phone-call-ongoing").css({"display":"none"});
        $(".phone-videocall-ongoing").css({"display":"none"});
        $(".phone-call-outgoing-caller").html(cData.name);
        
        QB.Phone.Functions.HeaderTextColor("white", 400);
        QB.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
        setTimeout(function(){
            $(".phone-app").css({"display":"none"});
            QB.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
            QB.Phone.Functions.ToggleApp("phone-call", "block");
        }, 450);

        CallData.name = cData.name;
        CallData.number = cData.number;
    
        QB.Phone.Data.currentApplication = "phone-call"; 
    });
}

$(document).on('click', '.phone-recent-button-all', function(e){
    $(".phone-recent-button-selection").css('transform', 'translateX(0vh)');
    $(".phone-recent-button-missed").removeClass("advert-bold-text");
    $(".phone-recent-button-all").addClass("advert-bold-text");

    $.post('http://cphone/GetMissedCalls', JSON.stringify({}), function(recent){
        QB.Phone.Functions.SetupRecentCalls(recent, false);
    });
});

$(document).on('click', '.phone-recent-button-missed', function(e){
    $(".phone-recent-button-selection").css('transform', 'translateX(7.4vh)');
    $(".phone-recent-button-missed").addClass("advert-bold-text");
    $(".phone-recent-button-all").removeClass("advert-bold-text");

    $.post('http://cphone/GetMissedCalls', JSON.stringify({}), function(recent){
        QB.Phone.Functions.SetupRecentCalls(recent, true);
    });
});

QB.Phone.Functions.SetupRecentCalls = function(recentcalls, onlyShowMissed) {
    $(".phone-recent-calls").html("");

    recentcalls = recentcalls.reverse();

    $.each(recentcalls, function(i, recentCall){
        var TypeIcon = 'fas fa-phone-volume';
        var IconStyle = "color: #cdcdcd; opacity: 0.0;";
        var TextStyle = "";

        if (recentCall.type === "outgoing") {
            TypeIcon = 'fa-solid fa-phone';
            var IconStyle = "color: #cdcdcd; font-size: 1.4vh;";
        }

        if (recentCall.type === "notanswered") {
            TypeIcon = 'fa-solid fa-phone-slash';
            var IconStyle = "color: #cdcdcd; font-size: 1.4vh;";
        }

        if (recentCall.type === "missed") {
            TypeIcon = 'fa-solid fa-phone-slash';
            var IconStyle = "color: #e82616; font-size: 1.4vh;";
            var TextStyle = "color: #e82616;";
        }

        if (recentCall.anonymous && recentCall.type !== "outgoing" && recentCall.type !== "notanswered") {
            recentCall.name = "###-####";
        }

        var elem = /*html*/`
            <div class="phone-recent-call" id="recent-${i}">
                <div class="phone-recent-call-name" style="${TextStyle}">${recentCall.name}</div>
                <div class="phone-recent-call-phone">Telemóvel</div>
                <div class="phone-recent-call-type"><i class="${TypeIcon}" style="${IconStyle}"></i></div>
                <div class="phone-recent-call-time">${timeSince(recentCall.time)}</div>
                <div class="phone-recent-call-info" id="recent-${i}"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!--! Font Awesome Pro 6.2.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2022 Fonticons, Inc. --><path d="M256 0C114.6 0 0 114.6 0 256s114.6 256 256 256s256-114.6 256-256S397.4 0 256 0zM256 464c-114.7 0-208-93.31-208-208S141.3 48 256 48s208 93.31 208 208S370.7 464 256 464zM296 336h-16V248C280 234.8 269.3 224 256 224H224C210.8 224 200 234.8 200 248S210.8 272 224 272h8v64h-16C202.8 336 192 346.8 192 360S202.8 384 216 384h80c13.25 0 24-10.75 24-24S309.3 336 296 336zM256 192c17.67 0 32-14.33 32-32c0-17.67-14.33-32-32-32S224 142.3 224 160C224 177.7 238.3 192 256 192z"></path></svg></div>
            </div>`;

        if (recentCall.type === "missed" && onlyShowMissed) {
            $(".phone-recent-calls").append(elem);
            $("#recent-"+i).data('recentData', recentCall);
        } else if (!onlyShowMissed) {
            $(".phone-recent-calls").append(elem);
            $("#recent-"+i).data('recentData', recentCall);
        }

    });
}

$(document).on('click', '.phone-recent-call', function(e){
    e.preventDefault();

    var RecendId = $(this).attr('id');
    RecentData = $("#"+RecendId).data('recentData');

    //console.log(RecentData)
    let clickedClass = $(e.target).closest("div").attr("class");

    if (clickedClass === "phone-recent-call-info") {
        $('.phone-app-footer').find(`[data-phonefootertab="${CurrentFooterTab}"`).removeClass('phone-selected-footer-tab');
        $('.phone-app-footer').find(`[data-phonefootertab="contacts"`).addClass('phone-selected-footer-tab');

        $(`.phone-${CurrentFooterTab}`).hide();
        $(`.phone-contacts`).show();

        CurrentFooterTab = "contacts";

        const isInContacts = isNumberInContacts(RecentData.number) !== undefined;
    
        var matches = RecentData.name.match(/\b(\w)/g); // ['J','S','O','N']
        let acronym = /*html*/`<i class="fa-solid fa-user"></i>`;
    
        if (matches !== null) {
            acronym = matches.join('').substring(0, 2).toUpperCase(); // JSON
        }
    
        $(".phone-contact-details-initials").html(acronym);
        $(".phone-contact-details-name").text(RecentData.name);
        $(".phone-contact-details-number-num").text(RecentData.number);
    
        if (RecentData.iban !== undefined && RecentData.iban !== null && RecentData.iban !== 0 && RecentData.iban !== "") {
            $(".phone-contact-details-iban").show();
            $(".phone-contact-details-iban-num").text(RecentData.iban);
        } else {
            $(".phone-contact-details-iban").hide();
        }

        console.log(isInContacts)

        if (isInContacts) {
            $(".phone-contact-details-button-favorites").show();
            $(".phone-contact-details-button-add-contact").hide();
        } else {
            $(".phone-contact-details-button-favorites").hide();
            $(".phone-contact-details-button-add-contact").show();   
        }
    
        if (favoriteContacts.includes(RecentData.number)) {
            $(".phone-contact-details-button-favorites").text("Remover dos Favoritos");
        } else {
            $(".phone-contact-details-button-favorites").text("Adicionar aos Favoritos");
        }

        if (blockedNumbers.includes(RecentData.number)) {
            $(".phone-contact-details-block").text("Desbloquear Contacto");
        } else {
            $(".phone-contact-details-block").text("Bloquear Contacto");
        }
    
        CurrentContactData.name = RecentData.name
        CurrentContactData.number = RecentData.number
        CurrentContactData.iban = RecentData.iban
    
        $(".phone-contact-details").addClass("phone-contact-details-show");
        $(".phone-contacts").addClass("phone-contacts-left");

        return true;
    }

    setupCall(RecentData, false);
});

CancelOutgoingCall = function() {
    if (isCurrentCallVideo) {
        stopHandleCallVideo();
    }

    if (QB.Phone.Data.currentApplication == "phone-call") {
        closeAppRoutine();
        QB.Phone.Data.CallActive = false;
        QB.Phone.Data.currentApplication = null;
    }
}

$(document).on('click', '#outgoing-cancel', function(e){
    e.preventDefault();

    $.post('http://cphone/CancelOutgoingCall');
});

$(document).on('click', '#incoming-deny', function(e){
    e.preventDefault();

    $.post('http://cphone/DenyIncomingCall');
});

$(document).on('click', '#ongoing-cancel', function(e){
    e.preventDefault();
    
    $.post('http://cphone/CancelOngoingCall');
});

QB.Phone.Functions.SetupCurrentCall = function(cData) {
    //TODO: If phone is closed, peak
    
    if (cData.InCall) {
        if (blockedNumbers.includes(cData.TargetData.number)) {
            $.post('http://cphone/DenyIncomingCall');
            return false;
        }
        
        CallData = cData;
        $(".phone-currentcall-container").css({"display":"block"});

        if (cData.CallType == "incoming") {
            $(".phone-currentcall-title").html("A receber chamada de");
        } else if (cData.CallType == "outgoing") {
            $(".phone-currentcall-title").html("Chamar");
        } else if (cData.CallType == "ongoing") {
            $(".phone-currentcall-title").html("Em chamada ("+cData.CallTime+")");
        }

        $(".phone-call-incoming-caller").html(cData.TargetData.name);
        $(".phone-currentcall-contact").html(cData.TargetData.name);
    } else {
        $(".phone-currentcall-container").css({"display":"none"});
    }
}

$(document).on('click', '.phone-currentcall-container', function(e){
    e.preventDefault();

    if (CallData.isVideo) {
        isCurrentCallVideo = CallData.isVideo;

        $(".phone-call-incoming").css({"display":"none"});
        $(".phone-call-outgoing").css({"display":"none"});
        $(".phone-call-ongoing").css({"display":"none"});
        $(".phone-videocall-ongoing").css({"display":"block"});

        handleCallVideo();

        $(".phone-call-ongoing-caller").html(CallData.name);

        if (CallData.CallType == "incoming") {
            $(".my-videocall-area").addClass("my-videocall-area-big");
            $(".videocall-controls-accept").css({"display":"block"});
            $(".videocall-controls-decline").css({"display":"block"});
            $(".videocall-controls-cancel").css({"display":"none"});
            $(".videocall-before-ongoing").show();
            $(".videocall-before-ongoing-header").text(CallData.TargetData.name);
            $(".videocall-before-ongoing-footer").text("Chamada de vídeo");
        } else if (CallData.CallType == "outgoing") {
            $(".my-videocall-area").addClass("my-videocall-area-big");
            $(".videocall-controls-accept").css({"display":"none"});
            $(".videocall-controls-decline").css({"display":"none"});
            $(".videocall-controls-cancel").css({"display":"block"});
            $(".videocall-before-ongoing").show();
            $(".videocall-before-ongoing-header").text(CallData.name);
            $(".videocall-before-ongoing-footer").text("A Chamar...");
        } else if (CallData.CallType == "ongoing") {
            $(".my-videocall-area").removeClass("my-videocall-area-big");
            $(".videocall-controls-accept").css({"display":"none"});
            $(".videocall-controls-decline").css({"display":"none"});
            $(".videocall-controls-cancel").css({"display":"block"});
            $(".videocall-before-ongoing").hide();
        }

        QB.Phone.Functions.HeaderTextColor("white", 500);
        QB.Phone.Animations.OpenApp('.phone-application-container', 300);
        QB.Phone.Animations.TopSlideDown('.phone-call-app', 500, 0);
        QB.Phone.Functions.ToggleApp("phone-call", "block");
                    
        QB.Phone.Data.currentApplication = "phone-call";
        return true;
    }

    if (CallData.CallType == "incoming") {
        $(".phone-call-incoming").css({"display":"block"});
        $(".phone-call-outgoing").css({"display":"none"});
        $(".phone-call-ongoing").css({"display":"none"});
        $(".phone-videocall-ongoing").css({"display":"none"});
    } else if (CallData.CallType == "outgoing") {
        $(".phone-call-incoming").css({"display":"none"});
        $(".phone-call-outgoing").css({"display":"block"});
        $(".phone-call-ongoing").css({"display":"none"});
        $(".phone-videocall-ongoing").css({"display":"none"});
    } else if (CallData.CallType == "ongoing") {
        $(".phone-call-incoming").css({"display":"none"});
        $(".phone-call-outgoing").css({"display":"none"});
        $(".phone-call-ongoing").css({"display":"block"});
        $(".phone-videocall-ongoing").css({"display":"none"});
    }
    $(".phone-call-ongoing-caller").html(CallData.name);

    QB.Phone.Functions.HeaderTextColor("white", 500);
    QB.Phone.Animations.OpenApp('.phone-application-container', 300);
    QB.Phone.Animations.TopSlideDown('.phone-call-app', 500, 0);
    QB.Phone.Functions.ToggleApp("phone-call", "block");
                
    QB.Phone.Data.currentApplication = "phone-call";
});

$(document).on('click', '#incoming-answer', function(e){
    e.preventDefault();

    $.post('http://cphone/AnswerCall');
});

$(document).on('click', '.videocall-controls-accept', function(e){
    e.preventDefault();
    $(".my-videocall-area").removeClass("my-videocall-area-big");
    $(".videocall-before-ongoing").fadeOut(200);

    $.post('http://cphone/AnswerCall');
});

$(document).on('click', '.videocall-controls-cancel', function(e){
    e.preventDefault();

    ///console.log(CallData.CallType)

    stopHandleCallVideo();

    if (CallData.CallType == "outgoing") {
        $.post('http://cphone/CancelOutgoingCall');
    } else if (CallData.CallType == "ongoing") {
        $.post('http://cphone/CancelOngoingCall');
    } else {
        $.post('http://cphone/DenyIncomingCall');
    }
});

function endCurrentVideoCall() {
    stopHandleCallVideo();

    if (CallData.CallType == "outgoing") {
        $.post('http://cphone/CancelOutgoingCall');
    } else if (CallData.CallType == "ongoing") {
        $.post('http://cphone/CancelOngoingCall');
    } else {
        $.post('http://cphone/DenyIncomingCall');
    }
}

function answerCurrentVideoCall() {
    $(".my-videocall-area").removeClass("my-videocall-area-big");
    $(".videocall-before-ongoing").fadeOut(200);

    $.post('http://cphone/AnswerCall');
}

/*
$(document).on('click', '.videocall-controls-decline', function(e){
    e.preventDefault();

    stopHandleCallVideo();

    $.post('http://cphone/DenyIncomingCall');
});*/

QB.Phone.Functions.AnswerCall = function(CallData) {
    if (isCurrentCallVideo) {
        $(".videocall-controls-accept").css({"display":"none"});
        $(".videocall-controls-decline").css({"display":"none"});
        $(".videocall-controls-cancel").css({"display":"block"});
        $(".my-videocall-area").removeClass("my-videocall-area-big");
        $(".videocall-before-ongoing").fadeOut(200);
        return true;
    } 

    $(".phone-call-incoming").css({"display":"none"});
    $(".phone-call-outgoing").css({"display":"none"});
    $(".phone-call-ongoing").css({"display":"block"});
    $(".phone-videocall-ongoing").css({"display":"none"});
    $(".phone-call-ongoing-caller").html(CallData.TargetData.name);

    QB.Phone.Functions.Close();
}


//! WEBRTC Functions

//<video id="target-stream" class="content-area" autoplay muted></video>

var RTC = null;
const RTCServers = {iceServers: [
    {
        urls: ['stun:stun1.l.google.com:19302', 'stun:stun2.l.google.com:19302']
    },
    {
        url: "turn:54.36.99.11:3478",
        username: "Sem Destino",
        credential: "Sem Destino",
    },
], iceCandidatePoolSize: 10, iceTransportPolicy : "relay"};

let streamId = 1;


var streaming = false;
var watching = false;
var stream = null;
var remoteStream = null;

let peers = {};
let isHandlingVideo = false;


function handleCallVideo() {
    //CallData.name = cData.name;
    //CallData.number = cData.number;
    if (isHandlingVideo) return false;

    isHandlingVideo = true;

    $.post("https://cphone/CreateFacetimeCamera", JSON.stringify({}));

    let canvas = $("#mycamera-render")[0];
    canvas.style.display = "block";

    MainRender.renderToTarget(canvas);
    StartStreaming(myPhoneNumber);
}

function stopHandleCallVideo() {
    //CallData.name = cData.name;
    //CallData.number = cData.number;
    if (!isHandlingVideo) return false;

    isHandlingVideo = false;

    $.post('http://cphone/destroyFacetimeCamera');

    MainRender.stop();
    if (RTC) RTC.close();

    peers = {};
}

async function StartStreaming(id) { //? start the stream and send streamId and offerObject to server
    if (RTC) RTC.close();

    streamId = id;

    $.post("https://cphone/startStreaming", JSON.stringify({streamId: streamId}))
}

async function newPeer(data) {
    //console.log("newPeer", data);
    //if (watching || !streaming) return;

    if (peers[data.serverid]) return;
    peers[data.serverid] = {serverid: data.serverid, RTC: null, ready: false}
    peers[data.serverid].RTC = new RTCPeerConnection(RTCServers);
    peers[data.serverid].RTC.onicecandidate = (event) => {
        if (event.candidate) {
            let candidate = new RTCIceCandidate(event.candidate);
            peers[data.serverid].RTC.addIceCandidate(candidate);
           // console.log("icecandidatestreamer", {streamId: data.streamId, serverid: data.serverid, candidate: candidate})
            $.post("https://cphone/newIceCandidateStreamer", JSON.stringify({streamId: data.streamId, serverid: data.serverid, candidate: candidate}));
        }
    }

    let stream = document.getElementById("mycamera-render").captureStream();

    stream.getTracks().forEach(track => {
        //console.log("addtrack to " + data.serverid);
        peers[data.serverid].RTC.addTrack(track, stream);
    });

    let candidateOffer = await peers[data.serverid].RTC.createOffer();
    await peers[data.serverid].RTC.setLocalDescription(candidateOffer);

    let offerObject = {
        sdp: candidateOffer.sdp,
        type: candidateOffer.type
    }

    $.post("https://cphone/sendRTCOffer", JSON.stringify({streamId: data.streamId, serverid: data.serverid, offer: offerObject}));
}

async function leaveStream(data) {
    if (peers[data.serverid]) {
        peers[data.serverid].RTC.close();
        peers[data.serverid] = null;
    };
}

async function stopStream(data) {
    if (streamId == data.streamId) {
        if (RTC) {
            watching = false;
            streamId = 0;
            RTC.close();
            let video = document.getElementById("othercamera-stream");
            video.pause();
            video.srcObject = null;
        }
    }
}

async function StartWatching(streamId, serverid) { //? start watching a stream
    watching = true;
    if (RTC) RTC.close();
    RTC = new RTCPeerConnection(RTCServers);
    
    let video = document.getElementById("othercamera-stream");
    video.style.display = "block";
    //video.pause()
    //video.src = "";
    video.srcObject = new MediaStream(); //? create a media stream for remote stream

    RTC.onicecandidate = (event) => {
        if (event.candidate) {
            let candidate = new RTCIceCandidate(event.candidate);
            RTC.addIceCandidate(candidate);
            //console.log("icecandidatewatcher", {streamId: streamId, candidate: candidate, serverid: serverid})
            $.post("https://cphone/newIceCandidateWatcher", JSON.stringify({streamId: streamId, candidate: candidate, serverid: serverid}));
        }
    }

    RTC.ontrack = (event) => {
        event.streams[0].getTracks().forEach(track => {
            video.srcObject.addTrack(track);
        })
    }

    //let sessionDesc = new RTCSessionDescription(JSON.parse('videocall'));
    //await RTC.setLocalDescription(sessionDesc);

    //let candidateAnswer = await RTC.createAnswer();
    //await RTC.setLocalDescription(candidateAnswer);

    // let answerObject = {
    //     sdp: candidateAnswer.sdp,
    //     type: candidateAnswer.type
    // }

    $.post("https://cphone/joinStream", JSON.stringify({streamId: streamId, serverid: serverid}));
}

async function receiveRTCOffer(data) {
    //console.log("receiveRTCOffer", data);
    //console.log("RTC", RTC);
    let sessionDesc = new RTCSessionDescription(data.offer);
    await RTC.setRemoteDescription(sessionDesc);

    let candidateAnswer = await RTC.createAnswer();
    await RTC.setLocalDescription(candidateAnswer);

    let answerObject = {
        sdp: candidateAnswer.sdp,
        type: candidateAnswer.type
    }

    $.post("https://cphone/sendRTCAnswer", JSON.stringify({streamId: data.streamId, serverid: data.serverid, answer: answerObject}))
}

async function receiveRTCAnswer(data) { //? receive answer from watcher
    //console.log("receiveRTCAnswer", data);
    if (peers[data.serverid]) {
        let answer = new RTCSessionDescription(data.answer);
        await peers[data.serverid].RTC.setRemoteDescription(answer);
        peers[data.serverid].ready = true;
    }
}

async function newIceCandidateStreamer(data) { //? receive an ice candidate from streamer
    //console.log("newIceCandidateStreamer", data);
    if (streamId == data.streamId) {
        let candidate = new RTCIceCandidate(data.candidate);
        RTC.addIceCandidate(candidate);
    }
}

async function newIceCandidateWatcher(data) { //? receive an ice candidate from watcher
    //console.log("newIceCandidateWatcher", data);
    if (peers[data.serverid]) {
        let candidate = new RTCIceCandidate(data.candidate);
        peers[data.serverid].RTC.addIceCandidate(candidate)
    }
}


$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "icecandidatestreamer":
                newIceCandidateStreamer(event.data);
                break;
            case "icecandidatewatcher":
                newIceCandidateWatcher(event.data);
                break;
            case "receiveoffer":
                receiveRTCOffer(event.data);
                break;
            case "receiveanswer":
                receiveRTCAnswer(event.data);
                break;
            case "joinstream":
                newPeer(event.data);
                break;
            case "startwatching":
                StartWatching(event.data.id, event.data.serverid);
                break;
        }
    })
});