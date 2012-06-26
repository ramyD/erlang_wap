var WS = false;
if (window.WebSocket) WS = WebSocket;
if (!WS && window.MozWebSocket) WS = MozWebSocket;
if (!WS)
  alert("WebSocket not supported by this browser");
// Get an Element
function $() { return document.getElementById(arguments[0]); }
// Get the value of an Element
function $F() { return document.getElementById(arguments[0]).value; }
var client = {
  connect: function(){
    this._ws=new WS("ws://localhost:8000/websocket");
    this._ws.onopen=this._onopen;
    this._ws.onmessage=this._onmessage;
    this._ws.onclose=this._onclose;
  },
  _onopen: function(){
    $('connect').className='hidden';
    $('connected').className='';
    $('phrase').focus();
    client._send('client-connected');
  },
  _send: function(message){
    if (this._ws)
      this._ws.send(message);
  },
  chat: function(text) {
    if (text != null && text.length>0 )
      client._send(text);
  },
  _onmessage: function(m) {
    if (m.data){
      var text = m.data;
      var msg=$('msgs');
      var spanText = document.createElement('span');
      spanText.className='text';
      spanText.innerHTML=text;
      var lineBreak = document.createElement('br');
      msg.appendChild(spanText);
      msg.appendChild(lineBreak);
      msg.scrollTop = msg.scrollHeight - msg.clientHeight;
    }
  },
  _onclose: function(m) {
    this._ws=null;
    $('connect').className='';
    $('connected').className='hidden';
    $('msg').innerHTML='';
  }
};

window.onload = function () {
  $('cA').onclick = function(event) { client.connect(); return false; };
  $('sendB').onclick = function(event) { client.chat($F('phrase')); $('phrase').value=''; $('phrase').focus(); return false; };
};
