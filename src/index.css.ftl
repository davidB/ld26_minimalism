<#macro aprefixes>
<#list [ "-moz-", "-webkit-", "-ms-", "-o-", ""] as p>
<#nested p>
</#list>
</#macro>
/* Icons @import url(http://weloveiconfonts.com/api/?family=fontawesome|fontelico|zocial); */

/* fontawesome */
[class*="fontawesome-"]:before {
  font-family: 'FontAwesome', sans-serif;
}

/* fontelico */
[class*="fontelico-"]:before {
  font-family: 'fontelico', sans-serif;
}

/* zocial */
[class*="zocial-"]:before {
  font-family: 'zocial', sans-serif;
}
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
  <@aprefixes ; x>${x}transition: left 1s ease-out;
  </@aprefixes>
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
  <@aprefixes ; x>${x}animation: playBonus 7s;
  </@aprefixes>
  visibility: hidden;
}
<@aprefixes ; x>
@${x}keyframes playBonus{
  0%,100% {
    visibility:visible;
    opacity:0.3;
  }
  25%,75% {
    visibility:visible;
    opacity:1.0;
  }
  50% {
    ${x}animation-timing-function: ease-out;
    ${x}transform: translate(-1000px, 0px);
    visibility:visible;
    opacity:1.0;
  }
}
</@aprefixes>

.show0 {
  /*
  <@aprefixes ; x>${x}transition: ${x}transform 1s ease-out;</@aprefixes>
  */
  -webkit-transition: top 1s ease-out, left 1s ease-out;
  -moz-transition: top 1s ease-out, left 1s ease-out;
  transition: top 1s ease-out, left 1s ease-out;
  <@aprefixes ; x>${x}transition: top 1s ease-out, left 1s ease-out;</@aprefixes>
}

<#macro hide n>
.hide${n} {
	<@aprefixes ; x>${x}animation: hide${n} 1s;</@aprefixes>
  visibility: hidden;
}
<@aprefixes ; x>
@${x}keyframes hide${n}{
  0% {
    ${x}animation-timing-function: ease-out;
    ${x}transform: scale(1);
    opacity: 1;
    visibility:visible;
  }
  20% {
    ${x}animation-timing-function: ease-out;
    ${x}transform: scale(2);
    color: #333333;
    opacity: 1;
  }
  <#nested x>
}
</@aprefixes>
</#macro>
<@hide n="0" ; x>
	100% {
    ${x}animation-timing-function: ease-out;
    ${x}transform: scale(8);
    opacity: 0.05;
  }
</@hide>

<@hide n="1" ; x>
  100% {
    ${x}animation-timing-function: ease-out;
    ${x}transform: scale(2);
    top: 1%;
  }
</@hide>

<@hide n="2" ; x>
  100% {
    ${x}animation-timing-function: ease-out;
    ${x}transform: scale(2);
    top: 90%;
  }
</@hide>
<@hide n="3" ; x>
  100% {
    ${x}animation-timing-function: ease-out;
    ${x}transform: scale(2);
    left: 1%;
  }
</@hide>
<@hide n="4" ; x>
  100% {
    ${x}animation-timing-function: ease-out;
    ${x}transform: scale(2);
    left: 90%;
  }
</@hide>
<@hide n="5" ; x>
  100% {
    ${x}animation-timing-function: ease-out;
    ${x}transform: scaleX(20);
  }
</@hide>