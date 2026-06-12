$('.phone-application-container').append(/*html*/`
    <style type="text/css">
        .snake-app {
            display: none;
            height: 100%;
            width: 100%;
            background: black;
            overflow: hidden;
        }

        .snake-title {
            margin-top: 8vh;
            text-align: center;
            font-size: 2vh;
            color: white;
        }

        .snake-game {
            margin: auto;
            margin-top: 0.4vh;
            width: 92%;
        }

        #snakeCanvas {
            background: black;
            width: 100%;
            height: 100%;
            border-color: rgb(0 255 0);
            border-width: 0.1vh;
            border-style: solid;
        }

        .snake-button {
            color: #ffffff;
            font-size: 1.3vh;
            background: #007600;
            width: 14vh;
            text-align: center;
            height: 2.2vh;
            line-height: 2.3vh;
            border-radius: 0.5vh;
            transition: 0.2s;
            margin: auto;
            margin-top: 2vh;
        }

        .snake-button:hover {
            background: #00ff00;
        }

        .snake-button:active {
            background: #88ff88;
        }

        .snake-scores {
            font-size: 1.2vh;
            color: white;
            margin: auto;
            margin-top: 3vh;
            width: 90%;
            display: flex;
            justify-content: space-between;
        }
    </style>
    <div class="snake-app">
        <div class="snake-title">Snake</div>
        <div class="snake-scores">
            <div class="snake-highscore">Highscore: 0</div>
            <div class="snake-currentscore">Score: 0</div>
        </div>
        <div class="snake-game">
            <canvas id="snakeCanvas" width="300" height="300"></canvas>
        </div>
        <div class="snake-button">Jogar novamente</div>
    </div>
`);

var canvas;
var snake_ctx;

var head;
var apple;
var ball;

var dots;
var apple_x;
var apple_y;

var leftDirection = false;
var rightDirection = true;
var upDirection = false;
var downDirection = false;
var inGame = false;    

const DOT_SIZE = 10;
const ALL_DOTS = 900;
const MAX_RAND = 29;
const DELAY = 70;
const C_HEIGHT = 300;
const C_WIDTH = 300;    

const LEFT_KEY = 37;
const RIGHT_KEY = 39;
const UP_KEY = 38;
const DOWN_KEY = 40;

var x = new Array(ALL_DOTS);
var y = new Array(ALL_DOTS);   


function initSnakeGame() {
    if (inGame) return;

    if (localStorage.snakeHighscore === undefined || localStorage.snakeHighscore === null) localStorage.snakeHighscore = 0;

    $(".snake-highscore").text(`Highscore: ${localStorage.snakeHighscore}`);
    $(".snake-currentscore").text(`Score: 0`);

    inGame = true;
    $(".snake-button").fadeOut(50);

    leftDirection = false;
    rightDirection = true;
    upDirection = false;
    downDirection = false;
    
    canvas = document.getElementById('snakeCanvas');
    snake_ctx = canvas.getContext('2d');

    loadImages();
    createSnake();
    locateApple();
    setTimeout("gameCycle()", DELAY);
}    

function loadImages() {
    
    head = new Image();
    head.src = 'img/head.png';    
    
    ball = new Image();
    ball.src = 'img/dot.png'; 
    
    apple = new Image();
    apple.src = 'img/apple.png'; 
}

function createSnake() {

    dots = 3;

    for (var z = 0; z < dots; z++) {
        x[z] = 50 - z * 10;
        y[z] = 50;
    }
}

function checkApple() {

    if ((x[0] == apple_x) && (y[0] == apple_y)) {

        dots++;

        if (localStorage.snakeHighscore < dots - 3) localStorage.snakeHighscore = dots - 3;

        $(".snake-highscore").text(`Highscore: ${localStorage.snakeHighscore}`);
        $(".snake-currentscore").text(`Score: ${dots - 3}`);

        locateApple();
    }
}    

function doDrawing() {
    
    snake_ctx.clearRect(0, 0, C_WIDTH, C_HEIGHT);
    
    if (inGame) {

        snake_ctx.drawImage(apple, apple_x, apple_y);

        for (var z = 0; z < dots; z++) {
            
            if (z == 0) {
                snake_ctx.drawImage(head, x[z], y[z]);
            } else {
                snake_ctx.drawImage(ball, x[z], y[z]);
            }
        }    
    } else {
        snakeGameOver();
    }        
}

function snakeGameOver() {
    
    snake_ctx.fillStyle = 'white';
    snake_ctx.textBaseline = 'middle'; 
    snake_ctx.textAlign = 'center'; 
    snake_ctx.font = 'normal bold 18px Helvetica';
    
    snake_ctx.fillText('Game over', C_WIDTH/2, C_HEIGHT/2);

    $(".snake-button").fadeIn(200);
}

function move() {
    for (var z = dots; z > 0; z--) {
        x[z] = x[(z - 1)];
        y[z] = y[(z - 1)];
    }

    if (leftDirection) {
        x[0] -= DOT_SIZE;
    }

    if (rightDirection) {
        x[0] += DOT_SIZE;
    }

    if (upDirection) {
        y[0] -= DOT_SIZE;
    }

    if (downDirection) {
        y[0] += DOT_SIZE;
    }
}    

function checkCollision() {

    for (var z = dots; z > 0; z--) {

        if ((z > 4) && (x[0] == x[z]) && (y[0] == y[z])) {
            inGame = false;
        }
    }

    if (y[0] >= C_HEIGHT) {
        inGame = false;
    }

    if (y[0] < 0) {
       inGame = false;
    }

    if (x[0] >= C_WIDTH) {
      inGame = false;
    }

    if (x[0] < 0) {
      inGame = false;
    }
}

function locateApple() {

    var r = Math.floor(Math.random() * MAX_RAND);
    apple_x = r * DOT_SIZE;

    r = Math.floor(Math.random() * MAX_RAND);
    apple_y = r * DOT_SIZE;
}    

function gameCycle() {
    if (inGame) {
        checkApple();
        move();
        checkCollision();
        doDrawing();
        setTimeout("gameCycle()", DELAY);
    }
}

onkeydown = function(e) {
    
    var key = e.keyCode;
    
    if ((key == LEFT_KEY) && (!rightDirection)) {
        
        leftDirection = true;
        upDirection = false;
        downDirection = false;
    }

    if ((key == RIGHT_KEY) && (!leftDirection)) {
        
        rightDirection = true;
        upDirection = false;
        downDirection = false;
    }

    if ((key == UP_KEY) && (!downDirection)) {
        
        upDirection = true;
        rightDirection = false;
        leftDirection = false;
    }

    if ((key == DOWN_KEY) && (!upDirection)) {
        
        downDirection = true;
        rightDirection = false;
        leftDirection = false;
    }        
};    

$(document).on('click', '.snake-button', function(e){
    initSnakeGame();
});