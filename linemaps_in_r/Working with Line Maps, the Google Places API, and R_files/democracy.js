var demLoading;function dem_Vote(that)
{inpts=that.getElementsByTagName('input');user_added=false;ans=-1;theSubmit=false;for(i=0;i<inpts.length;i++)
{cur=inpts[i];if(cur.type=='radio'&&cur.checked)
{ans=cur.value;if(ans=='newAnswer')
{user_added=true;ans=inpts[i+1].value;}}
if(cur.name=='dem_poll_id')
poll_id=cur.value;if(cur.name=='dem_cookie_days')
cdays=cur.value;if(cur.type=='submit')
theSubmit=cur;}
if(ans==-1||ans=='')
return false;demLoading=setTimeout(dem_loadingDots.bind(theSubmit),50);path=that.action;if(user_added)
{path+="?dem_action=add_answer";path+="&dem_new_answer="+encodeURIComponent(ans);}else
{path+="?dem_action=vote";path+="&dem_poll_"+poll_id+"="+ans;}
path+="&dem_poll_id="+poll_id;path+="&dem_ajax=true";dem_ajax.open("GET",path,true);dem_ajax.onreadystatechange=dem_displayVotes.bind(that);dem_ajax.send(null);return false;}
function dem_addUncheck()
{oUL=this.parentNode.parentNode;lis=oUL.getElementsByTagName('li');els=lis[lis.length-1].childNodes;for(i=els.length-1;i>=0;i--)
if(els[i].nodeName.toLowerCase()=='a')
els[i].style.display='';else
els[i].parentNode.removeChild(els[i]);Inp=oUL.getElementsByTagName('input');for(i=0;i<Inp.length;i++)
{Inp[i].onclick=function(){return true};}
return true;}
function dem_addAnswer(that)
{allBoxes=that.parentNode.parentNode.getElementsByTagName('input');for(i=0;i<allBoxes.length;i++)
{allBoxes[i].onclick=dem_addUncheck;allBoxes[i].checked=false;}
that.style.display='none';i1=document.createElement('input');i1.type='radio';i1.value='newAnswer';i1.checked=true;i2=document.createElement('input');i2.className='addAnswerText';that.parentNode.appendChild(i1);that.parentNode.appendChild(i2);i2.focus();return false;}
function dem_loadingDots(){isInput=this.nodeName.toLowerCase()=='input';str=(isInput)?this.value:this.innerHTML;if(str.substring(str.length-3)=='...')
if(isInput)
this.value=str.substring(0,str.length-3);else
this.innerHTML=str.substring(0,str.length-3);else
if(isInput)
this.value+='.';else
this.innerHTML+='.';demLoading=setTimeout(dem_loadingDots.bind(this),200);}
function dem_clearDots(){clearTimeout(demLoading);}
function dem_getVotes(path,that)
{that.blur();demLoading=setTimeout(dem_loadingDots.bind(that),50);dem_ajax.open("GET",path,true);dem_ajax.onreadystatechange=dem_displayVotes.bind(that.parentNode);dem_ajax.send(null);return false;}
function dem_displayVotes()
{if(dem_ajax.readyState!=4)
return false;if(dem_ajax.status!=200)
{alert('Error '+dem_ajax.status);return false;}
clearTimeout(demLoading);this.innerHTML=dem_ajax.responseText;}
function dem_getHTTPObject(){var xmlhttp;/*@cc_on
  @if (@_jscript_version >= 5)
    try {
      xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
      try {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (E) {
        xmlhttp = false;
      }
    }
  @else
  xmlhttp = false;
  @end @*/if(!xmlhttp&&typeof XMLHttpRequest!='undefined'){try{xmlhttp=new XMLHttpRequest();}catch(e){xmlhttp=false;}}
return xmlhttp;}
dem_ajax=new dem_getHTTPObject();Function.prototype.bind=function(){var __method=this,args=$A(arguments),object=args.shift();return function(){return __method.apply(object,args.concat($A(arguments)));}}
var $A=Array.from=function(iterable){if(!iterable)return[];if(iterable.toArray){return iterable.toArray();}else{var results=[];for(var i=0;i<iterable.length;i++)
results.push(iterable[i]);return results;}}