/*-------------------- FORMS -------------------------------------------------*/
#search {
  background: rgba(240, 250, 250, 0.6);
  border: 1px solid #DCE5E5;
  margin-left: auto;
  margin-right: auto;
  margin-top: 6em;
  width: 40em;
}
#search > * {
  display: block;
  margin-left: auto;
  margin-right: auto;
}
#search > input {
  width: 30em;
}
#search > button {
  padding-top: 0;
  width: 32em;
  margin-top: 0.2em;
}

/*-------------------- RAILS + PLAYERS ---------------------------------------*/
#rails {
  width: 90%;
  border-bottom: 1px solid black;
  height: 130px;
  position: absolute;
  bottom: 7%;
  left: 5%;
}
.player {
  position: absolute;
  -webkit-transition: left 1s ease-out;
  -moz-transition: left 1s ease-out;
  transition: left 1s ease-out;
}
#player1 {
  left: 0%;
  z-index: 10;
}
#pSlowest {
  left: 0%;
  z-index: 9;
}
#pFastest {
  left: 0%;
  z-index: 8;
}
.name {
  background-color: rgb(250, 250, 250);
  font-family: "Josefin Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
  border-top: 3px solid #ddd;
  text-align: center;
  font-size: 1.5em;
}
/*-------------------- ABBREVIATIONS ---------------------------------------*/
#abbrevs {
  position: absolute;
  top: 10px;
  bottom: 10px;
  left: 10px;
  right: 10px;
  color: #CCCCCC;
  z-index: -1;
}
.abbrev {
  position: absolute;
}

.abbrevBonus {
  position: absolute;
  z-index: -2;
  color: #CC0000;
  font-weight: bolder;
  visibility: hidden;
}

div.playBonus {
  -webkit-animation: playBonus 7s;
  -moz-animation: playBonus 7s;
  animation: playBonus 7s;
  visibility: hidden;
}

@-webkit-keyframes playBonus{
  0%,100% {
    visibility:visible;
    opacity:0.3;
  }
  25%,75% {
    visibility:visible;
    opacity:1.0;
  }
  50% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: translate(-1000px, 0px);
    visibility:visible;
    opacity:1.0;
  }
}
@-moz-keyframes playBonus{
  0%,100% {
    visibility:visible;
    opacity:0.3;
  }
  25%,75% {
    visibility:visible;
    opacity:1.0;
  }
  50% {
    -moz-animation-timing-function: ease-out;
    -moz-transform: translate(-1000px, 0px);
    visibility:visible;
    opacity:1.0;
  }
}

.show0 {
  /*
  -webkit-transition: -webkit-transform 1s ease-out;
  -moz-transition: -moz-transform 1s ease-out;
  transition: transform 1s ease-out;
  */
  -webkit-transition: top 1s ease-out, left 1s ease-out;
  -moz-transition: top 1s ease-out, left 1s ease-out;
  transition: top 1s ease-out, left 1s ease-out;
}

.hide0 {
  -webkit-animation: hide0 1s;
  -moz-animation: hide0 1s;
  animation: hide0 1s;
  visibility: hidden;
}
@keyframes hide0{
  0% {
    animation-timing-function: ease-out;
    transform: scale(1);
    opacity: 1;
    visibility:visible;
  }
  20% {
    animation-timing-function: ease-out;
    transform: scale(2);
    color: #333333;
    opacity: 1;
  }
  100% {
    animation-timing-function: ease-out;
    transform: scale(8);
    opacity: 0.05;
  }
}
@-webkit-keyframes hide0{
  0% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(1);
    opacity: 1;
    visibility:visible;
  }
  20% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(2);
    color: #333333;
    opacity: 1;
  }
  100% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(8);
    opacity: 0.05;
  }
}
@-moz-keyframes hide0{
  0% {
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(1);
    opacity: 1;
    visibility:visible;
  }
  20% {
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(2);
    color: #333333;
    opacity: 1;
  }
  100% {
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(8);
    opacity: 0.05;
  }
}

.hide1 {
  -webkit-animation: hide1 1s;
  -moz-animation: hide1 1s;
  animation: hide1 1s;
  visibility: hidden;
}
@-webkit-keyframes hide1{
  0% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(1);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(1);
    animation-timing-function: ease-out;
    transform: scale(1);
    opacity: 1;
    visibility:visible;
  }
  20% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(2);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(2);
    animation-timing-function: ease-out;
    transform: scale(2);
    color: #333333;
    opacity: 1;
  }
  100% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(2);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(2);
    animation-timing-function: ease-out;
    transform: scale(2);
    top: 1%;
  }
}

.hide2 {
  -webkit-animation: hide2 1s;
  -moz-animation: hide2 1s;
  animation: hide2 1s;
  visibility: hidden;
}
@-webkit-keyframes hide2{
  0% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(1);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(1);
    animation-timing-function: ease-out;
    transform: scale(1);
    opacity: 1;
    visibility:visible;
  }
  20% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(2);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(2);
    animation-timing-function: ease-out;
    transform: scale(2);
    color: #333333;
    opacity: 1;
  }
  100% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(2);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(2);
    animation-timing-function: ease-out;
    transform: scale(2);
    top: 90%;
  }
}

.hide3 {
  -webkit-animation: hide3 1s;
  -moz-animation: hide3 1s;
  animation: hide3 1s;
  visibility: hidden;
}
@-webkit-keyframes hide3{
  0% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(1);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(1);
    animation-timing-function: ease-out;
    transform: scale(1);
    opacity: 1;
    visibility:visible;
  }
  20% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(2);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(2);
    animation-timing-function: ease-out;
    transform: scale(2);
    color: #333333;
    opacity: 1;
  }
  100% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(2);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(2);
    animation-timing-function: ease-out;
    transform: scale(2);
    left: 0%;
  }
}
.hide4 {
  -webkit-animation: hide4 1s;
  -moz-animation: hide4 1s;
  animation: hide4 1s;
  visibility: hidden;
}
@-webkit-keyframes hide4{
  0% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(1);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(1);
    animation-timing-function: ease-out;
    transform: scale(1);
    opacity: 1;
    visibility:visible;
  }
  20% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(2);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(2);
    animation-timing-function: ease-out;
    transform: scale(2);
    color: #333333;
    opacity: 1;
  }
  100% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(2);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(2);
    animation-timing-function: ease-out;
    transform: scale(2);
    left: 90%;
  }
}
.hide5 {
  -webkit-animation: hide5 1s;
  -moz-animation: hide5 1s;
  animation: hide5 1s;
  visibility: hidden;
}
@-webkit-keyframes hide5{
  0% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(1);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(1);
    animation-timing-function: ease-out;
    transform: scale(1);
    opacity: 1;
    visibility:visible;
  }
  20% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scale(2);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scale(2);
    animation-timing-function: ease-out;
    transform: scale(2);
    color: #333333;
    opacity: 1;
  }
  100% {
    -webkit-animation-timing-function: ease-out;
    -webkit-transform: scaleX(20);
    -moz-animation-timing-function: ease-out;
    -moz-transform: scaleX(20);
    animation-timing-function: ease-out;
    transform: scaleX(20);
  }
}