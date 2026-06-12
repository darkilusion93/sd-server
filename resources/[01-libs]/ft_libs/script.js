//! CONFIG

const uploadUrl = ""; //? default upload url
const uploadField = ""; //? default upload field

//! CONFIG

import {OrthographicCamera, Scene, WebGLRenderTarget, LinearFilter, NearestFilter, RGBAFormat, UnsignedByteType, CfxTexture, ShaderMaterial, PlaneBufferGeometry, Mesh, WebGLRenderer} from "/module/Three.js";

var isAnimated = false;
var MainRender;
var scId = 0;
let isVertical = true;

// from https://stackoverflow.com/a/12300351
function dataURItoBlob(dataURI) {
    const byteString = atob(dataURI.split(',')[1]);
    const mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]

    const ab = new ArrayBuffer(byteString.length);
    const ia = new Uint8Array(ab);
  
    for (let i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }
  
    const blob = new Blob([ab], {type: mimeString});
    return blob;
}

// citizenfx/screenshot-basic
class GameRender {
    constructor() {
        window.addEventListener('resize', this.resize);

        const cameraRTT = new OrthographicCamera(window.innerWidth / -2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / -2, -10000, 10000);

        cameraRTT.position.z = 0;
        const width = Math.floor(window.innerWidth);
        //cameraRTT.setViewOffset(window.innerWidth, window.innerHeight, window.innerWidth / 3.5, 0, width, window.innerHeight);

        if (isVertical) {
            cameraRTT.setViewOffset(window.innerWidth, window.innerHeight, window.innerWidth / 3.5, 0, width, window.innerHeight);
        } else {
            cameraRTT.setViewOffset(window.innerWidth, window.innerHeight, 0, 0, window.innerWidth, window.innerHeight);
        }

        const sceneRTT = new Scene();

        const rtTexture = new WebGLRenderTarget(window.innerWidth, window.innerHeight, {minFilter: LinearFilter, magFilter: NearestFilter, format: RGBAFormat, type: UnsignedByteType});
        const gameTexture = new CfxTexture();
        gameTexture.needsUpdate = true;

        const material = new ShaderMaterial({
            uniforms: { "tDiffuse": { value: gameTexture } },
            vertexShader: `
			varying vec2 vUv;
			void main() {
				vUv = vec2(uv.x, 1.0-uv.y);
				gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
			}
`,
            fragmentShader: `
			varying vec2 vUv;
			uniform sampler2D tDiffuse;
			void main() {
				gl_FragColor = texture2D(tDiffuse, vUv);
			}
`
        });

        this.material = material;

        const plane = new PlaneBufferGeometry(window.innerWidth, window.innerHeight);
        const quad = new Mesh(plane, material);
        quad.position.z = -100;
        sceneRTT.add(quad);

        const renderer = new WebGLRenderer();
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.autoClear = false;

        let appendArea = document.createElement("div");
        appendArea.id = "three-game-render";

        document.body.append(appendArea);

        appendArea.appendChild(renderer.domElement);
        appendArea.style.display = 'none';

        this.renderer = renderer;
        this.rtTexture = rtTexture;
        this.sceneRTT = sceneRTT;
        this.cameraRTT = cameraRTT;
        this.gameTexture = gameTexture;

        this.animate = this.animate.bind(this);

        requestAnimationFrame(this.animate);
    }

    resize() {
        const cameraRTT = new OrthographicCamera(window.innerWidth / -2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / -2, -10000, 10000);
        cameraRTT.position.z = 0;

        if (isVertical) {
            const width = Math.floor(window.innerWidth);
            cameraRTT.setViewOffset(window.innerWidth, window.innerHeight, window.innerWidth / 3.5, 0, width, window.innerHeight);
        } else {
            cameraRTT.setViewOffset(window.innerWidth, window.innerHeight, 0, 0, window.innerWidth, window.innerHeight);
        }

        cameraRTT.zoom = 0.1;

        this.cameraRTT = cameraRTT;

        const sceneRTT = new Scene();

        const plane = new PlaneBufferGeometry(window.innerWidth, window.innerHeight);
        const quad = new Mesh(plane, this.material);
        quad.position.z = -100;
        sceneRTT.add(quad);

        this.sceneRTT = sceneRTT;

        this.rtTexture = new WebGLRenderTarget(window.innerWidth, window.innerHeight, {minFilter: LinearFilter, magFilter: NearestFilter, format: RGBAFormat, type: UnsignedByteType});

        //MainRender.renderer.setSize(window.innerWidth, window.innerHeight);
    }

    animate() {
        requestAnimationFrame(this.animate);
        if (isAnimated) {
            let innerWidth = window.innerWidth;

            this.renderer.clear();
            this.renderer.render(this.sceneRTT, this.cameraRTT, this.rtTexture, true);
            const read = new Uint8Array(innerWidth * window.innerHeight * 4);
            this.renderer.readRenderTargetPixels(this.rtTexture, 0, 0, innerWidth, window.innerHeight, read);
            this.canvas.style.display = 'inline';

            if (isVertical) {
                this.canvas.width = window.innerHeight * 9/16;
                this.canvas.height = window.innerHeight;
            } else {
                this.canvas.width = window.innerWidth;
                this.canvas.height = window.innerHeight;
            }

            const d = new Uint8ClampedArray(read.buffer);

            const cxt = this.canvas.getContext('2d');
            cxt.putImageData(new ImageData(d, innerWidth, window.innerHeight), 0, 0);
        }
    }

    changeAspectRatio(vertical) {
        isVertical = vertical;

        if (isVertical) {
            this.canvas.width = window.innerHeight * 9/16;
            this.canvas.height = window.innerHeight;
        } else {
            this.canvas.width = window.innerWidth;
            this.canvas.height = window.innerHeight;
        }

        const cameraRTT = new OrthographicCamera(window.innerWidth / -2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / -2, -10000, 10000);
        cameraRTT.position.z = 0;

        if (isVertical) {
            const width = Math.floor(window.innerWidth);
            cameraRTT.setViewOffset(window.innerWidth, window.innerHeight, window.innerWidth / 3.5, 0, width, window.innerHeight);
        } else {
            cameraRTT.setViewOffset(window.innerWidth, window.innerHeight, 0, 0, window.innerWidth, window.innerHeight);
        }

        cameraRTT.zoom = 0.1;

        this.cameraRTT = cameraRTT;

        const sceneRTT = new Scene();

        const plane = new PlaneBufferGeometry(window.innerWidth, window.innerHeight);
        const quad = new Mesh(plane, this.material);
        quad.position.z = -100;
        sceneRTT.add(quad);

        this.sceneRTT = sceneRTT;

        this.rtTexture = new WebGLRenderTarget(window.innerWidth, window.innerHeight, {minFilter: LinearFilter, magFilter: NearestFilter, format: RGBAFormat, type: UnsignedByteType});
    }

    renderToTarget(element) {
        this.canvas = element;

        this.changeAspectRatio(isVertical);

        isAnimated = true;
    }

    requestScreenshot = (url, field) => new Promise((res) => {
        url = url ? url : uploadUrl;
        field = field ? field : uploadField;
        let wasInAnim = isAnimated;
        if (isAnimated) isAnimated = false;
        
        //console.log(this.canvas.width);

        const imageURL = this.canvas.toDataURL("image/jpeg", 0.8);
        const getFormData = () => {
            const formData = new FormData();
            formData.append(field, dataURItoBlob(imageURL), `screenshot.jpeg`);
    
            return formData;
        };
        fetch(url, {
            method: 'POST',
            mode: 'cors',
            body: (field) ? getFormData() : JSON.stringify({
                data: imageURL,
                id: scId
            })
        })
        .then(response => response.text())
        .then(text => {
            res(text);
        });
        scId++;
        this.canvas.style.display = "none";
        isAnimated = wasInAnim;
    })

    stop() {
        isAnimated = false;
        if (this.canvas) {
            if (this.canvas.style.display != "none") {
                this.canvas.style.display = "none";
            }
        }
    }
}

setTimeout(() => {
    MainRender = new GameRender();
    window.MainRender = MainRender;
}, 1000);