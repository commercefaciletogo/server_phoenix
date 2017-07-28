import { tns } from 'tiny-slider/src/tiny-slider';

let slider = tns({
    container: document.querySelector('.ad-image-slider'),
    items: 1,
    loop: false,
    controlsContainer: document.querySelector('.controls'),
    navContainer: document.querySelector('.thumbnails'),
    controls: false,
    touch: false,
    lazyload: true
})

const req = (method, url, doneCallback, data = null) => { 
    let request = new XMLHttpRequest();
    request.open(method, url);
    request.setRequestHeader("x-csrf-token", window.csrfToken);
    request.onload = doneCallback;
    request.send(data);
};

const openInNewTab = url => { 
    window.open(url, '', 'width=200');
};

document.querySelector("button.view-phone").addEventListener("click", () => {
    document.querySelector("button.view-phone span.phone").innerText = window.phone;
    document.querySelector("button.view-phone").setAttribute("disabled", true);
});

document.querySelector("button.favorite").addEventListener("click", () => {
    let b = document.querySelector("button.favorite span i.fa");
    if (b.classList.contains("fa-heart-o")) {
        b.classList.remove("fa-heart-o");
        b.classList.add("fa-heart");
    } else {
        b.classList.remove("fa-heart");
        b.classList.add("fa-heart-o");
    }
});

document.querySelector("button.report").addEventListener("click", () => {
    let b = document.querySelector("button.report span i.fa");
    if (b.classList.contains("fa-ban")) {
        b.classList.remove("fa-ban");
        b.classList.add("fa-warning");
    } else {
        b.classList.remove("fa-warning");
        b.classList.add("fa-ban");
    }
});

document.querySelector(".share.facebook").addEventListener("click", () => {
    let b = document.querySelector(".share.facebook");
    let url = b.getAttribute("data-url");
    let medium = b.getAttribute("data-medium");
    console.log(url, medium);
    openInNewTab(url);
});
document.querySelector(".share.twitter").addEventListener("click", () => {
    let b = document.querySelector(".share.twitter");
    let url = b.getAttribute("data-url");
    let medium = b.getAttribute("data-medium");
    console.log(url, medium);
    openInNewTab(url);
});
document.querySelector(".share.whatsapp").addEventListener("click", () => {
    let b = document.querySelector(".share.whatsapp");
    let url = b.getAttribute("data-url");
    let medium = b.getAttribute("data-medium");
    console.log(url, medium);
    openInNewTab(url);
});
