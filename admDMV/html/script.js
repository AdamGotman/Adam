$(document).ready(function() {
    $('body').hide(0)
    window.addEventListener("message", function(event) {
        var item = event.data;
        if (item.dmvadam == true) {
            $('body').show(650)
        }

    })
})
const questionTable = [
    {
        question: "Ce semnifică acest indicator rutier?",
        image: "img/cedeazatrecere.png",
        answers: [
            { text: "Oprire obligatorie", correct: false },
            { text: "Drum cu prioritate", correct: false },
            { text: "Cedează trecerea", correct: true },
            { text: "Sfârșit de drum cu prioritate", correct: false },
        ]
    },
    {
        question: "Ce trebuie să faci la culoarea galbenă a semaforului?",
        image: "img/semaforgalben.png",
        answers: [
            { text: "Te oprești, dacă poți face asta în siguranță", correct: true },
            { text: "Accelerezi", correct: false },
            { text: "Continui fără oprire", correct: false },
            { text: "Ignori semaforul", correct: false },
        ]
    },
    {
        question: "Ce este viteza maxima in oras?",
        image: "img/noimg.png",
        answers: [
            { text: "40 km/h", correct: false },
            { text: "80 km/h", correct: false },
            { text: "95 km/h", correct: false },
            { text: "90 km/h", correct: true },
        ]
    },
    {
        question: "Ce semnificație are indicatorul cu copilul?",
        image: "img/atentiecopii.png",
        answers: [
            { text: "Zonă industrială", correct: false },
            { text: "Trecere pentru bicicliști", correct: false },
            { text: "Zonă cu copii / Școală", correct: true },
            { text: "Drum în lucru", correct: false },
        ]
    },
    {
        question: "Ce trebuie să faci înainte de o trecere de pietoni?",
        image: "img/trecerepietoni.png",
        answers: [
            { text: "Claxonezi", correct: false },
            { text: "Accelerezi", correct: false },
            { text: "Reduci viteza și ești pregătit să oprești", correct: true },
            { text: "Ignori pietonii", correct: false },
        ]
    },
    {
        question: "Care este limita legală de alcool în sânge pentru șoferii amatori?",
        image: "img/testalcho.png",
        answers: [
            { text: "0.2‰", correct: false },
            { text: "0.5‰", correct: false },
            { text: "0.0‰", correct: true },
            { text: "1.0‰", correct: false },
        ]
    },
    {
        question: "Când este permisă depășirea prin dreapta?",
        image: "img/depasiredreapta.png",
        answers: [
            { text: "Pe drumuri cu cel puțin 3 benzi pe sens", correct: true },
            { text: "Niciodată", correct: false },
            { text: "Când ești grăbit", correct: false },
            { text: "În afara localităților", correct: false },
        ]
    },
    {
        question: "Ce trebuie să faci când ambulanța are semnalele pornite?",
        image: "img/ambulanta.png",
        answers: [
            { text: "Continui normal", correct: false },
            { text: "Reduci viteza", correct: false },
            { text: "Facilitezi trecerea imediat", correct: true },
            { text: "Ignori", correct: false },
        ]
    },
    {
        question: "În ce ordine vor trece autovehiculele prin intersecție?",
        image: "img/ordinetrece.png",
        answers: [
            { text: "Autotrucul, autoturismul verde, autoturismul roșu", correct: false },
            { text: "Autoturismul roșu, autoturismul verde, autotrucul albastru;", correct: true },
            { text: "Autoturismul verde, autotrucul, autoturismul roșu.", correct: false },
            { text: "Nu au voie", correct: false },
        ]
    },
    {
        question: "Limita de viteza pe autostrada?",
        image: "img/noimg.png",
        answers: [
            { text: "Nu este", correct: false },
            { text: "120 km/h", correct: false },
            { text: "160 km/h", correct: true },
            { text: "150 km/h", correct: false },
        ]
    },
    {
        question: "Ce trebuie verificat înainte de o plecare la drum lung?",
        image: "img/verifica.png",
        answers: [
            { text: "Doar presiunea în roți", correct: false },
            { text: "Nivelul uleiului și combustibilul", correct: false },
            { text: "Toate sistemele esențiale: frâne, lumini, roți", correct: true },
            { text: "Claxonul și ștergătoarele", correct: false },
        ]
    },
    {
        question: "Ce faci la un semafor defect?",
        image: "img/noimg.png",
        answers: [
            { text: "Ignori și treci", correct: false },
            { text: "Respecți indicatoarele și prioritatea de dreapta", correct: true },
            { text: "Te oprești și aștepți", correct: false },
            { text: "Ceri indicații altor șoferi", correct: false },
        ]
    },
    {
        question: "Care din conducători este obligat să cedeze trecerea pietonilor?",
        image: "img/cedezetrecere.png",
        answers: [
            { text: "Niciunul", correct: false },
            { text: "Ambii conducători.", correct: true },
            { text: "Numai conducătorul autoturismului roșu.", correct: false },
            { text: "Numai conducătorul autoturismului albastru.", correct: false },
        ]
    },
    {
        question: "Cum trebuie așezat triunghiul reflectorizant în caz de avarie?",
        image: "img/triunghireflectorizant.png",
        answers: [
            { text: "Imediat lângă mașină", correct: false },
            { text: "La cel puțin 30 m în spate", correct: true },
            { text: "Pe plafon", correct: false },
            { text: "În fața mașinii", correct: false },
        ]
    },
    {
        question: "Ce semnifică acest indicator?",
        image: "img/interzis.png",
        answers: [
            { text: "Acces permis doar pentru locuitori", correct: false },
            { text: "Drum închis circulației", correct: false },
            { text: "Acces interzis", correct: true },
            { text: "Acces permis autovehiculelor grele", correct: false },
        ]
    }
];
const mainQuestion = document.querySelector('.big-text');
const imgQestion = document.querySelector('.imgTest');
const answersQuestion = document.querySelectorAll('.answer');
const nextQuestionBtn = document.querySelector('.next-button');
const cotainerDMV = document.querySelector('.container');
const timerHTML = document.querySelector('.box-time');
const questionBoxes = document.querySelectorAll('.box');
let timerInterval;

let currentIndex = 0;
let correctAnswers = 0;
let wrongAnswer = 0;
let timer = 15 * 60; // 15 min

function StartTest() {
    hasAnswered = false;
    const current = questionTable[currentIndex];
    mainQuestion.innerHTML = current.question;
    imgQestion.src = current.image;

    current.answers.forEach((answer, index) => {
        const btn = answersQuestion[index];
        btn.innerText = answer.text;
        btn.style.backgroundColor = '';
        btn.onclick = () => {
            hasAnswered = true;
            if (answer.correct) {
                btn.style.backgroundColor = 'lightgreen';
                questionBoxes[currentIndex].style.boxShadow = '0 0 0 3px #90ee906b';
                questionBoxes[currentIndex].style.backgroundColor = 'lightgreen';
                correctAnswers++;
            } else {
                btn.style.backgroundColor = 'salmon';
                questionBoxes[currentIndex].style.boxShadow = '0 0 0 3px #fa80726b';
                questionBoxes[currentIndex].style.backgroundColor = 'salmon';
                wrongAnswer++;
            }
            answersQuestion.forEach(b => b.onclick = null);
        };
    });
}

function nextQuestionButton() {
    if(hasAnswered){
    if (wrongAnswer > 5 ){
        stopTest();
    }else{
        currentIndex++;
        StartTest();
    }
   }
   if(currentIndex >= questionTable.length){
    $('body').hide(0);
    console.log('Ai trecut testul');
    $.post(`https://${GetParentResourceName()}/givePermis`, JSON.stringify({}));
   }
}

function stopTest(){
    $('body').hide(0);
    clearInterval(timerInterval);
    cotainerDMV.style.display = 'none';
    $.post(`https://${GetParentResourceName()}/noPermis`, JSON.stringify({}));
}

function updateTime(){
    const minutes = Math.floor(timer / 60);
    const seconds = timer % 60;
    timerHTML.innerHTML = `${minutes}:${seconds.toString().padStart(2, '0')}`;
    if (timer <= 0) {
        stopTest();
    } else {
        timer--;
    }
}
 
function startExam(){
    updateTime();
    timerInterval = setInterval(updateTime, 1000);
    document.querySelector('.container').style.display = 'flex';
    document.querySelector('.container-choise').style.display = 'none';
    StartTest();
}

function showTheory(){
    document.querySelector('.container-choise').style.display = 'none';
    document.querySelector('.theory-container').style.display = 'flex';
}

function closeTheory(){
    document.querySelector('.container-choise').style.display = 'flex';
    document.querySelector('.theory-container').style.display = 'none';
}

function closeAll(){
    $('body').hide(0)
    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
}
