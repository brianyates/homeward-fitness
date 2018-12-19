$(document).on('turbolinks:load', function(){
function datepicker_getZindex(e){for(var t,a;e.length&&e[0]!==document;){if(("absolute"===(t=e.css("position"))||"relative"===t||"fixed"===t)&&(a=parseInt(e.css("zIndex"),10),!isNaN(a)&&0!==a))return a;e=e.parent()}return 0}function Datepicker(){this._curInst=null,this._keyEvent=!1,this._disabledInputs=[],this._datepickerShowing=!1,this._inDialog=!1,this._mainDivId="ui-datepicker-div",this._inlineClass="ui-datepicker-inline",this._appendClass="ui-datepicker-append",this._triggerClass="ui-datepicker-trigger",this._dialogClass="ui-datepicker-dialog",this._disableClass="ui-datepicker-disabled",this._unselectableClass="ui-datepicker-unselectable",this._currentClass="ui-datepicker-current-day",this._dayOverClass="ui-datepicker-days-cell-over",this.regional=[],this.regional[""]={closeText:"Done",prevText:"Prev",nextText:"Next",currentText:"Today",monthNames:["January","February","March","April","May","June","July","August","September","October","November","December"],monthNamesShort:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],dayNames:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],dayNamesShort:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],dayNamesMin:["Su","Mo","Tu","We","Th","Fr","Sa"],weekHeader:"Wk",dateFormat:"mm/dd/yy",firstDay:0,isRTL:!1,showMonthAfterYear:!1,yearSuffix:""},this._defaults={showOn:"focus",showAnim:"fadeIn",showOptions:{},defaultDate:null,appendText:"",buttonText:"...",buttonImage:"",buttonImageOnly:!1,hideIfNoPrevNext:!1,navigationAsDateFormat:!1,gotoCurrent:!1,changeMonth:!1,changeYear:!1,yearRange:"c-10:c+10",showOtherMonths:!1,selectOtherMonths:!1,showWeek:!1,calculateWeek:this.iso8601Week,shortYearCutoff:"+10",minDate:null,maxDate:null,duration:"fast",beforeShowDay:null,beforeShow:null,onSelect:null,onChangeMonthYear:null,onClose:null,numberOfMonths:1,showCurrentAtPos:0,stepMonths:1,stepBigMonths:12,altField:"",altFormat:"",constrainInput:!0,showButtonPanel:!1,autoSize:!1,disabled:!1},$.extend(this._defaults,this.regional[""]),this.regional.en=$.extend(!0,{},this.regional[""]),this.regional["en-US"]=$.extend(!0,{},this.regional.en),this.dpDiv=datepicker_bindHover($("<div id='"+this._mainDivId+"' class='ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all'></div>"))}function datepicker_bindHover(e){var t="button, .ui-datepicker-prev, .ui-datepicker-next, .ui-datepicker-calendar td a";return e.on("mouseout",t,function(){$(this).removeClass("ui-state-hover"),-1!==this.className.indexOf("ui-datepicker-prev")&&$(this).removeClass("ui-datepicker-prev-hover"),-1!==this.className.indexOf("ui-datepicker-next")&&$(this).removeClass("ui-datepicker-next-hover")}).on("mouseover",t,datepicker_handleMouseover)}function datepicker_handleMouseover(){$.datepicker._isDisabledDatepicker(datepicker_instActive.inline?datepicker_instActive.dpDiv.parent()[0]:datepicker_instActive.input[0])||($(this).parents(".ui-datepicker-calendar").find("a").removeClass("ui-state-hover"),$(this).addClass("ui-state-hover"),-1!==this.className.indexOf("ui-datepicker-prev")&&$(this).addClass("ui-datepicker-prev-hover"),-1!==this.className.indexOf("ui-datepicker-next")&&$(this).addClass("ui-datepicker-next-hover"))}function datepicker_extendRemove(e,t){$.extend(e,t);for(var a in t)null==t[a]&&(e[a]=t[a]);return e}$.extend($.ui,{datepicker:{version:"1.12.1"}});var datepicker_instActive;$.extend(Datepicker.prototype,{markerClassName:"hasDatepicker",maxRows:4,_widgetDatepicker:function(){return this.dpDiv},setDefaults:function(e){return datepicker_extendRemove(this._defaults,e||{}),this},_attachDatepicker:function(e,t){var a,i,s;i="div"===(a=e.nodeName.toLowerCase())||"span"===a,e.id||(this.uuid+=1,e.id="dp"+this.uuid),(s=this._newInst($(e),i)).settings=$.extend({},t||{}),"input"===a?this._connectDatepicker(e,s):i&&this._inlineDatepicker(e,s)},_newInst:function(e,t){return{id:e[0].id.replace(/([^A-Za-z0-9_\-])/g,"\\\\$1"),input:e,selectedDay:0,selectedMonth:0,selectedYear:0,drawMonth:0,drawYear:0,inline:t,dpDiv:t?datepicker_bindHover($("<div class='"+this._inlineClass+" ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all'></div>")):this.dpDiv}},_connectDatepicker:function(e,t){var a=$(e);t.append=$([]),t.trigger=$([]),a.hasClass(this.markerClassName)||(this._attachments(a,t),a.addClass(this.markerClassName).on("keydown",this._doKeyDown).on("keypress",this._doKeyPress).on("keyup",this._doKeyUp),this._autoSize(t),$.data(e,"datepicker",t),t.settings.disabled&&this._disableDatepicker(e))},_attachments:function(e,t){var a,i,s,n=this._get(t,"appendText"),r=this._get(t,"isRTL");t.append&&t.append.remove(),n&&(t.append=$("<span class='"+this._appendClass+"'>"+n+"</span>"),e[r?"before":"after"](t.append)),e.off("focus",this._showDatepicker),t.trigger&&t.trigger.remove(),"focus"!==(a=this._get(t,"showOn"))&&"both"!==a||e.on("focus",this._showDatepicker),"button"!==a&&"both"!==a||(i=this._get(t,"buttonText"),s=this._get(t,"buttonImage"),t.trigger=$(this._get(t,"buttonImageOnly")?$("<img/>").addClass(this._triggerClass).attr({src:s,alt:i,title:i}):$("<button type='button'></button>").addClass(this._triggerClass).html(s?$("<img/>").attr({src:s,alt:i,title:i}):i)),e[r?"before":"after"](t.trigger),t.trigger.on("click",function(){return $.datepicker._datepickerShowing&&$.datepicker._lastInput===e[0]?$.datepicker._hideDatepicker():$.datepicker._datepickerShowing&&$.datepicker._lastInput!==e[0]?($.datepicker._hideDatepicker(),$.datepicker._showDatepicker(e[0])):$.datepicker._showDatepicker(e[0]),!1}))},_autoSize:function(e){if(this._get(e,"autoSize")&&!e.inline){var t,a,i,s,n=new Date(2009,11,20),r=this._get(e,"dateFormat");r.match(/[DM]/)&&(t=function(e){for(a=0,i=0,s=0;s<e.length;s++)e[s].length>a&&(a=e[s].length,i=s);return i},n.setMonth(t(this._get(e,r.match(/MM/)?"monthNames":"monthNamesShort"))),n.setDate(t(this._get(e,r.match(/DD/)?"dayNames":"dayNamesShort"))+20-n.getDay())),e.input.attr("size",this._formatDate(e,n).length)}},_inlineDatepicker:function(e,t){var a=$(e);a.hasClass(this.markerClassName)||(a.addClass(this.markerClassName).append(t.dpDiv),$.data(e,"datepicker",t),this._setDate(t,this._getDefaultDate(t),!0),this._updateDatepicker(t),this._updateAlternate(t),t.settings.disabled&&this._disableDatepicker(e),t.dpDiv.css("display","block"))},_dialogDatepicker:function(e,t,a,i,s){var n,r,o,d,c,l=this._dialogInst;return l||(this.uuid+=1,n="dp"+this.uuid,this._dialogInput=$("<input type='text' id='"+n+"' style='position: absolute; top: -100px; width: 0px;'/>"),this._dialogInput.on("keydown",this._doKeyDown),$("body").append(this._dialogInput),(l=this._dialogInst=this._newInst(this._dialogInput,!1)).settings={},$.data(this._dialogInput[0],"datepicker",l)),datepicker_extendRemove(l.settings,i||{}),t=t&&t.constructor===Date?this._formatDate(l,t):t,this._dialogInput.val(t),this._pos=s?s.length?s:[s.pageX,s.pageY]:null,this._pos||(r=document.documentElement.clientWidth,o=document.documentElement.clientHeight,d=document.documentElement.scrollLeft||document.body.scrollLeft,c=document.documentElement.scrollTop||document.body.scrollTop,this._pos=[r/2-100+d,o/2-150+c]),this._dialogInput.css("left",this._pos[0]+20+"px").css("top",this._pos[1]+"px"),l.settings.onSelect=a,this._inDialog=!0,this.dpDiv.addClass(this._dialogClass),this._showDatepicker(this._dialogInput[0]),$.blockUI&&$.blockUI(this.dpDiv),$.data(this._dialogInput[0],"datepicker",l),this},_destroyDatepicker:function(e){var t,a=$(e),i=$.data(e,"datepicker");a.hasClass(this.markerClassName)&&(t=e.nodeName.toLowerCase(),$.removeData(e,"datepicker"),"input"===t?(i.append.remove(),i.trigger.remove(),a.removeClass(this.markerClassName).off("focus",this._showDatepicker).off("keydown",this._doKeyDown).off("keypress",this._doKeyPress).off("keyup",this._doKeyUp)):"div"!==t&&"span"!==t||a.removeClass(this.markerClassName).empty(),datepicker_instActive===i&&(datepicker_instActive=null))},_enableDatepicker:function(e){var t,a,i=$(e),s=$.data(e,"datepicker");i.hasClass(this.markerClassName)&&("input"===(t=e.nodeName.toLowerCase())?(e.disabled=!1,s.trigger.filter("button").each(function(){this.disabled=!1}).end().filter("img").css({opacity:"1.0",cursor:""})):"div"!==t&&"span"!==t||((a=i.children("."+this._inlineClass)).children().removeClass("ui-state-disabled"),a.find("select.ui-datepicker-month, select.ui-datepicker-year").prop("disabled",!1)),this._disabledInputs=$.map(this._disabledInputs,function(t){return t===e?null:t}))},_disableDatepicker:function(e){var t,a,i=$(e),s=$.data(e,"datepicker");i.hasClass(this.markerClassName)&&("input"===(t=e.nodeName.toLowerCase())?(e.disabled=!0,s.trigger.filter("button").each(function(){this.disabled=!0}).end().filter("img").css({opacity:"0.5",cursor:"default"})):"div"!==t&&"span"!==t||((a=i.children("."+this._inlineClass)).children().addClass("ui-state-disabled"),a.find("select.ui-datepicker-month, select.ui-datepicker-year").prop("disabled",!0)),this._disabledInputs=$.map(this._disabledInputs,function(t){return t===e?null:t}),this._disabledInputs[this._disabledInputs.length]=e)},_isDisabledDatepicker:function(e){if(!e)return!1;for(var t=0;t<this._disabledInputs.length;t++)if(this._disabledInputs[t]===e)return!0;return!1},_getInst:function(e){try{return $.data(e,"datepicker")}catch(e){throw"Missing instance data for this datepicker"}},_optionDatepicker:function(e,t,a){var i,s,n,r,o=this._getInst(e);if(2===arguments.length&&"string"==typeof t)return"defaults"===t?$.extend({},$.datepicker._defaults):o?"all"===t?$.extend({},o.settings):this._get(o,t):null;i=t||{},"string"==typeof t&&((i={})[t]=a),o&&(this._curInst===o&&this._hideDatepicker(),s=this._getDateDatepicker(e,!0),n=this._getMinMaxDate(o,"min"),r=this._getMinMaxDate(o,"max"),datepicker_extendRemove(o.settings,i),null!==n&&void 0!==i.dateFormat&&void 0===i.minDate&&(o.settings.minDate=this._formatDate(o,n)),null!==r&&void 0!==i.dateFormat&&void 0===i.maxDate&&(o.settings.maxDate=this._formatDate(o,r)),"disabled"in i&&(i.disabled?this._disableDatepicker(e):this._enableDatepicker(e)),this._attachments($(e),o),this._autoSize(o),this._setDate(o,s),this._updateAlternate(o),this._updateDatepicker(o))},_changeDatepicker:function(e,t,a){this._optionDatepicker(e,t,a)},_refreshDatepicker:function(e){var t=this._getInst(e);t&&this._updateDatepicker(t)},_setDateDatepicker:function(e,t){var a=this._getInst(e);a&&(this._setDate(a,t),this._updateDatepicker(a),this._updateAlternate(a))},_getDateDatepicker:function(e,t){var a=this._getInst(e);return a&&!a.inline&&this._setDateFromField(a,t),a?this._getDate(a):null},_doKeyDown:function(e){var t,a,i,s=$.datepicker._getInst(e.target),n=!0,r=s.dpDiv.is(".ui-datepicker-rtl");if(s._keyEvent=!0,$.datepicker._datepickerShowing)switch(e.keyCode){case 9:$.datepicker._hideDatepicker(),n=!1;break;case 13:return(i=$("td."+$.datepicker._dayOverClass+":not(."+$.datepicker._currentClass+")",s.dpDiv))[0]&&$.datepicker._selectDay(e.target,s.selectedMonth,s.selectedYear,i[0]),t=$.datepicker._get(s,"onSelect"),t?(a=$.datepicker._formatDate(s),t.apply(s.input?s.input[0]:null,[a,s])):$.datepicker._hideDatepicker(),!1;case 27:$.datepicker._hideDatepicker();break;case 33:$.datepicker._adjustDate(e.target,e.ctrlKey?-$.datepicker._get(s,"stepBigMonths"):-$.datepicker._get(s,"stepMonths"),"M");break;case 34:$.datepicker._adjustDate(e.target,e.ctrlKey?+$.datepicker._get(s,"stepBigMonths"):+$.datepicker._get(s,"stepMonths"),"M");break;case 35:(e.ctrlKey||e.metaKey)&&$.datepicker._clearDate(e.target),n=e.ctrlKey||e.metaKey;break;case 36:(e.ctrlKey||e.metaKey)&&$.datepicker._gotoToday(e.target),n=e.ctrlKey||e.metaKey;break;case 37:(e.ctrlKey||e.metaKey)&&$.datepicker._adjustDate(e.target,r?1:-1,"D"),n=e.ctrlKey||e.metaKey,e.originalEvent.altKey&&$.datepicker._adjustDate(e.target,e.ctrlKey?-$.datepicker._get(s,"stepBigMonths"):-$.datepicker._get(s,"stepMonths"),"M");break;case 38:(e.ctrlKey||e.metaKey)&&$.datepicker._adjustDate(e.target,-7,"D"),n=e.ctrlKey||e.metaKey;break;case 39:(e.ctrlKey||e.metaKey)&&$.datepicker._adjustDate(e.target,r?-1:1,"D"),n=e.ctrlKey||e.metaKey,e.originalEvent.altKey&&$.datepicker._adjustDate(e.target,e.ctrlKey?+$.datepicker._get(s,"stepBigMonths"):+$.datepicker._get(s,"stepMonths"),"M");break;case 40:(e.ctrlKey||e.metaKey)&&$.datepicker._adjustDate(e.target,7,"D"),n=e.ctrlKey||e.metaKey;break;default:n=!1}else 36===e.keyCode&&e.ctrlKey?$.datepicker._showDatepicker(this):n=!1;n&&(e.preventDefault(),e.stopPropagation())},_doKeyPress:function(e){var t,a,i=$.datepicker._getInst(e.target);if($.datepicker._get(i,"constrainInput"))return t=$.datepicker._possibleChars($.datepicker._get(i,"dateFormat")),a=String.fromCharCode(null==e.charCode?e.keyCode:e.charCode),e.ctrlKey||e.metaKey||a<" "||!t||t.indexOf(a)>-1},_doKeyUp:function(e){var t=$.datepicker._getInst(e.target);if(t.input.val()!==t.lastVal)try{$.datepicker.parseDate($.datepicker._get(t,"dateFormat"),t.input?t.input.val():null,$.datepicker._getFormatConfig(t))&&($.datepicker._setDateFromField(t),$.datepicker._updateAlternate(t),$.datepicker._updateDatepicker(t))}catch(e){}return!0},_showDatepicker:function(e){if("input"!==(e=e.target||e).nodeName.toLowerCase()&&(e=$("input",e.parentNode)[0]),!$.datepicker._isDisabledDatepicker(e)&&$.datepicker._lastInput!==e){var t,a,i,s,n,r,o;t=$.datepicker._getInst(e),$.datepicker._curInst&&$.datepicker._curInst!==t&&($.datepicker._curInst.dpDiv.stop(!0,!0),t&&$.datepicker._datepickerShowing&&$.datepicker._hideDatepicker($.datepicker._curInst.input[0])),!1!==(i=(a=$.datepicker._get(t,"beforeShow"))?a.apply(e,[e,t]):{})&&(datepicker_extendRemove(t.settings,i),t.lastVal=null,$.datepicker._lastInput=e,$.datepicker._setDateFromField(t),$.datepicker._inDialog&&(e.value=""),$.datepicker._pos||($.datepicker._pos=$.datepicker._findPos(e),$.datepicker._pos[1]+=e.offsetHeight),s=!1,$(e).parents().each(function(){return!(s|="fixed"===$(this).css("position"))}),n={left:$.datepicker._pos[0],top:$.datepicker._pos[1]},$.datepicker._pos=null,t.dpDiv.empty(),t.dpDiv.css({position:"absolute",display:"block",top:"-1000px"}),$.datepicker._updateDatepicker(t),n=$.datepicker._checkOffset(t,n,s),t.dpDiv.css({position:$.datepicker._inDialog&&$.blockUI?"static":s?"fixed":"absolute",display:"none",left:n.left+"px",top:n.top+"px"}),t.inline||(r=$.datepicker._get(t,"showAnim"),o=$.datepicker._get(t,"duration"),t.dpDiv.css("z-index",datepicker_getZindex($(e))+1),$.datepicker._datepickerShowing=!0,$.effects&&$.effects.effect[r]?t.dpDiv.show(r,$.datepicker._get(t,"showOptions"),o):t.dpDiv[r||"show"](r?o:null),$.datepicker._shouldFocusInput(t)&&t.input.trigger("focus"),$.datepicker._curInst=t))}},_updateDatepicker:function(e){this.maxRows=4,datepicker_instActive=e,e.dpDiv.empty().append(this._generateHTML(e)),this._attachHandlers(e);var t,a=this._getNumberOfMonths(e),i=a[1],s=e.dpDiv.find("."+this._dayOverClass+" a");s.length>0&&datepicker_handleMouseover.apply(s.get(0)),e.dpDiv.removeClass("ui-datepicker-multi-2 ui-datepicker-multi-3 ui-datepicker-multi-4").width(""),i>1&&e.dpDiv.addClass("ui-datepicker-multi-"+i).css("width",17*i+"em"),e.dpDiv[(1!==a[0]||1!==a[1]?"add":"remove")+"Class"]("ui-datepicker-multi"),e.dpDiv[(this._get(e,"isRTL")?"add":"remove")+"Class"]("ui-datepicker-rtl"),e===$.datepicker._curInst&&$.datepicker._datepickerShowing&&$.datepicker._shouldFocusInput(e)&&e.input.trigger("focus"),e.yearshtml&&(t=e.yearshtml,setTimeout(function(){t===e.yearshtml&&e.yearshtml&&e.dpDiv.find("select.ui-datepicker-year:first").replaceWith(e.yearshtml),t=e.yearshtml=null},0))},_shouldFocusInput:function(e){return e.input&&e.input.is(":visible")&&!e.input.is(":disabled")&&!e.input.is(":focus")},_checkOffset:function(e,t,a){var i=e.dpDiv.outerWidth(),s=e.dpDiv.outerHeight(),n=e.input?e.input.outerWidth():0,r=e.input?e.input.outerHeight():0,o=document.documentElement.clientWidth+(a?0:$(document).scrollLeft()),d=document.documentElement.clientHeight+(a?0:$(document).scrollTop());return t.left-=this._get(e,"isRTL")?i-n:0,t.left-=a&&t.left===e.input.offset().left?$(document).scrollLeft():0,t.top-=a&&t.top===e.input.offset().top+r?$(document).scrollTop():0,t.left-=Math.min(t.left,t.left+i>o&&o>i?Math.abs(t.left+i-o):0),t.top-=Math.min(t.top,t.top+s>d&&d>s?Math.abs(s+r):0),t},_findPos:function(e){for(var t,a=this._getInst(e),i=this._get(a,"isRTL");e&&("hidden"===e.type||1!==e.nodeType||$.expr.filters.hidden(e));)e=e[i?"previousSibling":"nextSibling"];return t=$(e).offset(),[t.left,t.top]},_hideDatepicker:function(e){var t,a,i,s,n=this._curInst;!n||e&&n!==$.data(e,"datepicker")||this._datepickerShowing&&(t=this._get(n,"showAnim"),a=this._get(n,"duration"),i=function(){$.datepicker._tidyDialog(n)},$.effects&&($.effects.effect[t]||$.effects[t])?n.dpDiv.hide(t,$.datepicker._get(n,"showOptions"),a,i):n.dpDiv["slideDown"===t?"slideUp":"fadeIn"===t?"fadeOut":"hide"](t?a:null,i),t||i(),this._datepickerShowing=!1,(s=this._get(n,"onClose"))&&s.apply(n.input?n.input[0]:null,[n.input?n.input.val():"",n]),this._lastInput=null,this._inDialog&&(this._dialogInput.css({position:"absolute",left:"0",top:"-100px"}),$.blockUI&&($.unblockUI(),$("body").append(this.dpDiv))),this._inDialog=!1)},_tidyDialog:function(e){e.dpDiv.removeClass(this._dialogClass).off(".ui-datepicker-calendar")},_checkExternalClick:function(e){if($.datepicker._curInst){var t=$(e.target),a=$.datepicker._getInst(t[0]);(t[0].id===$.datepicker._mainDivId||0!==t.parents("#"+$.datepicker._mainDivId).length||t.hasClass($.datepicker.markerClassName)||t.closest("."+$.datepicker._triggerClass).length||!$.datepicker._datepickerShowing||$.datepicker._inDialog&&$.blockUI)&&(!t.hasClass($.datepicker.markerClassName)||$.datepicker._curInst===a)||$.datepicker._hideDatepicker()}},_adjustDate:function(e,t,a){var i=$(e),s=this._getInst(i[0]);this._isDisabledDatepicker(i[0])||(this._adjustInstDate(s,t+("M"===a?this._get(s,"showCurrentAtPos"):0),a),this._updateDatepicker(s))},_gotoToday:function(e){var t,a=$(e),i=this._getInst(a[0]);this._get(i,"gotoCurrent")&&i.currentDay?(i.selectedDay=i.currentDay,i.drawMonth=i.selectedMonth=i.currentMonth,i.drawYear=i.selectedYear=i.currentYear):(t=new Date,i.selectedDay=t.getDate(),i.drawMonth=i.selectedMonth=t.getMonth(),i.drawYear=i.selectedYear=t.getFullYear()),this._notifyChange(i),this._adjustDate(a)},_selectMonthYear:function(e,t,a){var i=$(e),s=this._getInst(i[0]);s["selected"+("M"===a?"Month":"Year")]=s["draw"+("M"===a?"Month":"Year")]=parseInt(t.options[t.selectedIndex].value,10),this._notifyChange(s),this._adjustDate(i)},_selectDay:function(e,t,a,i){var s,n=$(e);$(i).hasClass(this._unselectableClass)||this._isDisabledDatepicker(n[0])||((s=this._getInst(n[0])).selectedDay=s.currentDay=$("a",i).html(),s.selectedMonth=s.currentMonth=t,s.selectedYear=s.currentYear=a,this._selectDate(e,this._formatDate(s,s.currentDay,s.currentMonth,s.currentYear)))},_clearDate:function(e){var t=$(e);this._selectDate(t,"")},_selectDate:function(e,t){var a,i=$(e),s=this._getInst(i[0]);t=null!=t?t:this._formatDate(s),s.input&&s.input.val(t),this._updateAlternate(s),(a=this._get(s,"onSelect"))?a.apply(s.input?s.input[0]:null,[t,s]):s.input&&s.input.trigger("change"),s.inline?this._updateDatepicker(s):(this._hideDatepicker(),this._lastInput=s.input[0],"object"!=typeof s.input[0]&&s.input.trigger("focus"),this._lastInput=null)},_updateAlternate:function(e){var t,a,i,s=this._get(e,"altField");s&&(t=this._get(e,"altFormat")||this._get(e,"dateFormat"),a=this._getDate(e),i=this.formatDate(t,a,this._getFormatConfig(e)),$(s).val(i))},noWeekends:function(e){var t=e.getDay();return[t>0&&t<6,""]},iso8601Week:function(e){var t,a=new Date(e.getTime());return a.setDate(a.getDate()+4-(a.getDay()||7)),t=a.getTime(),a.setMonth(0),a.setDate(1),Math.floor(Math.round((t-a)/864e5)/7)+1},parseDate:function(e,t,a){if(null==e||null==t)throw"Invalid arguments";if(""===(t="object"==typeof t?t.toString():t+""))return null;var i,s,n,r,o=0,d=(a?a.shortYearCutoff:null)||this._defaults.shortYearCutoff,c="string"!=typeof d?d:(new Date).getFullYear()%100+parseInt(d,10),l=(a?a.dayNamesShort:null)||this._defaults.dayNamesShort,u=(a?a.dayNames:null)||this._defaults.dayNames,h=(a?a.monthNamesShort:null)||this._defaults.monthNamesShort,p=(a?a.monthNames:null)||this._defaults.monthNames,g=-1,_=-1,m=-1,f=-1,k=!1,D=function(t){var a=i+1<e.length&&e.charAt(i+1)===t;return a&&i++,a},y=function(e){var a=D(e),i="@"===e?14:"!"===e?20:"y"===e&&a?4:"o"===e?3:2,s="y"===e?i:1,n=new RegExp("^\\d{"+s+","+i+"}"),r=t.substring(o).match(n);if(!r)throw"Missing number at position "+o;return o+=r[0].length,parseInt(r[0],10)},v=function(e,a,i){var s=-1,n=$.map(D(e)?i:a,function(e,t){return[[t,e]]}).sort(function(e,t){return-(e[1].length-t[1].length)});if($.each(n,function(e,a){var i=a[1];if(t.substr(o,i.length).toLowerCase()===i.toLowerCase())return s=a[0],o+=i.length,!1}),-1!==s)return s+1;throw"Unknown name at position "+o},M=function(){if(t.charAt(o)!==e.charAt(i))throw"Unexpected literal at position "+o;o++};for(i=0;i<e.length;i++)if(k)"'"!==e.charAt(i)||D("'")?M():k=!1;else switch(e.charAt(i)){case"d":m=y("d");break;case"D":v("D",l,u);break;case"o":f=y("o");break;case"m":_=y("m");break;case"M":_=v("M",h,p);break;case"y":g=y("y");break;case"@":g=(r=new Date(y("@"))).getFullYear(),_=r.getMonth()+1,m=r.getDate();break;case"!":g=(r=new Date((y("!")-this._ticksTo1970)/1e4)).getFullYear(),_=r.getMonth()+1,m=r.getDate();break;case"'":D("'")?M():k=!0;break;default:M()}if(o<t.length&&(n=t.substr(o),!/^\s+/.test(n)))throw"Extra/unparsed characters found in date: "+n;if(-1===g?g=(new Date).getFullYear():g<100&&(g+=(new Date).getFullYear()-(new Date).getFullYear()%100+(g<=c?0:-100)),f>-1)for(_=1,m=f;;){if(s=this._getDaysInMonth(g,_-1),m<=s)break;_++,m-=s}if((r=this._daylightSavingAdjust(new Date(g,_-1,m))).getFullYear()!==g||r.getMonth()+1!==_||r.getDate()!==m)throw"Invalid date";return r},ATOM:"yy-mm-dd",COOKIE:"D, dd M yy",ISO_8601:"yy-mm-dd",RFC_822:"D, d M y",RFC_850:"DD, dd-M-y",RFC_1036:"D, d M y",RFC_1123:"D, d M yy",RFC_2822:"D, d M yy",RSS:"D, d M y",TICKS:"!",TIMESTAMP:"@",W3C:"yy-mm-dd",_ticksTo1970:24*(718685+Math.floor(492.5)-Math.floor(19.7)+Math.floor(4.925))*60*60*1e7,formatDate:function(e,t,a){if(!t)return"";var i,s=(a?a.dayNamesShort:null)||this._defaults.dayNamesShort,n=(a?a.dayNames:null)||this._defaults.dayNames,r=(a?a.monthNamesShort:null)||this._defaults.monthNamesShort,o=(a?a.monthNames:null)||this._defaults.monthNames,d=function(t){var a=i+1<e.length&&e.charAt(i+1)===t;return a&&i++,a},c=function(e,t,a){var i=""+t;if(d(e))for(;i.length<a;)i="0"+i;return i},l=function(e,t,a,i){return d(e)?i[t]:a[t]},u="",h=!1;if(t)for(i=0;i<e.length;i++)if(h)"'"!==e.charAt(i)||d("'")?u+=e.charAt(i):h=!1;else switch(e.charAt(i)){case"d":u+=c("d",t.getDate(),2);break;case"D":u+=l("D",t.getDay(),s,n);break;case"o":u+=c("o",Math.round((new Date(t.getFullYear(),t.getMonth(),t.getDate()).getTime()-new Date(t.getFullYear(),0,0).getTime())/864e5),3);break;case"m":u+=c("m",t.getMonth()+1,2);break;case"M":u+=l("M",t.getMonth(),r,o);break;case"y":u+=d("y")?t.getFullYear():(t.getFullYear()%100<10?"0":"")+t.getFullYear()%100;break;case"@":u+=t.getTime();break;case"!":u+=1e4*t.getTime()+this._ticksTo1970;break;case"'":d("'")?u+="'":h=!0;break;default:u+=e.charAt(i)}return u},_possibleChars:function(e){var t,a="",i=!1,s=function(a){var i=t+1<e.length&&e.charAt(t+1)===a;return i&&t++,i};for(t=0;t<e.length;t++)if(i)"'"!==e.charAt(t)||s("'")?a+=e.charAt(t):i=!1;else switch(e.charAt(t)){case"d":case"m":case"y":case"@":a+="0123456789";break;case"D":case"M":return null;case"'":s("'")?a+="'":i=!0;break;default:a+=e.charAt(t)}return a},_get:function(e,t){return void 0!==e.settings[t]?e.settings[t]:this._defaults[t]},_setDateFromField:function(e,t){if(e.input.val()!==e.lastVal){var a=this._get(e,"dateFormat"),i=e.lastVal=e.input?e.input.val():null,s=this._getDefaultDate(e),n=s,r=this._getFormatConfig(e);try{n=this.parseDate(a,i,r)||s}catch(e){i=t?"":i}e.selectedDay=n.getDate(),e.drawMonth=e.selectedMonth=n.getMonth(),e.drawYear=e.selectedYear=n.getFullYear(),e.currentDay=i?n.getDate():0,e.currentMonth=i?n.getMonth():0,e.currentYear=i?n.getFullYear():0,this._adjustInstDate(e)}},_getDefaultDate:function(e){return this._restrictMinMax(e,this._determineDate(e,this._get(e,"defaultDate"),new Date))},_determineDate:function(e,t,a){var i=null==t||""===t?a:"string"==typeof t?function(t){try{return $.datepicker.parseDate($.datepicker._get(e,"dateFormat"),t,$.datepicker._getFormatConfig(e))}catch(e){}for(var a=(t.toLowerCase().match(/^c/)?$.datepicker._getDate(e):null)||new Date,i=a.getFullYear(),s=a.getMonth(),n=a.getDate(),r=/([+\-]?[0-9]+)\s*(d|D|w|W|m|M|y|Y)?/g,o=r.exec(t);o;){switch(o[2]||"d"){case"d":case"D":n+=parseInt(o[1],10);break;case"w":case"W":n+=7*parseInt(o[1],10);break;case"m":case"M":s+=parseInt(o[1],10),n=Math.min(n,$.datepicker._getDaysInMonth(i,s));break;case"y":case"Y":i+=parseInt(o[1],10),n=Math.min(n,$.datepicker._getDaysInMonth(i,s))}o=r.exec(t)}return new Date(i,s,n)}(t):"number"==typeof t?isNaN(t)?a:function(e){var t=new Date;return t.setDate(t.getDate()+e),t}(t):new Date(t.getTime());return(i=i&&"Invalid Date"===i.toString()?a:i)&&(i.setHours(0),i.setMinutes(0),i.setSeconds(0),i.setMilliseconds(0)),this._daylightSavingAdjust(i)},_daylightSavingAdjust:function(e){return e?(e.setHours(e.getHours()>12?e.getHours()+2:0),e):null},_setDate:function(e,t,a){var i=!t,s=e.selectedMonth,n=e.selectedYear,r=this._restrictMinMax(e,this._determineDate(e,t,new Date));e.selectedDay=e.currentDay=r.getDate(),e.drawMonth=e.selectedMonth=e.currentMonth=r.getMonth(),e.drawYear=e.selectedYear=e.currentYear=r.getFullYear(),s===e.selectedMonth&&n===e.selectedYear||a||this._notifyChange(e),this._adjustInstDate(e),e.input&&e.input.val(i?"":this._formatDate(e))},_getDate:function(e){return!e.currentYear||e.input&&""===e.input.val()?null:this._daylightSavingAdjust(new Date(e.currentYear,e.currentMonth,e.currentDay))},_attachHandlers:function(e){var t=this._get(e,"stepMonths"),a="#"+e.id.replace(/\\\\/g,"\\");e.dpDiv.find("[data-handler]").map(function(){var e={prev:function(){$.datepicker._adjustDate(a,-t,"M")},next:function(){$.datepicker._adjustDate(a,+t,"M")},hide:function(){$.datepicker._hideDatepicker()},today:function(){$.datepicker._gotoToday(a)},selectDay:function(){return $.datepicker._selectDay(a,+this.getAttribute("data-month"),+this.getAttribute("data-year"),this),!1},selectMonth:function(){return $.datepicker._selectMonthYear(a,this,"M"),!1},selectYear:function(){return $.datepicker._selectMonthYear(a,this,"Y"),!1}};$(this).on(this.getAttribute("data-event"),e[this.getAttribute("data-handler")])})},_generateHTML:function(e){var t,a,i,s,n,r,o,d,c,l,u,h,p,g,_,m,f,k,D,y,v,$,M,w,b,C,I,x,N,S,Y,F,T,A,K,j,O,E,R,H=new Date,U=this._daylightSavingAdjust(new Date(H.getFullYear(),H.getMonth(),H.getDate())),L=this._get(e,"isRTL"),W=this._get(e,"showButtonPanel"),P=this._get(e,"hideIfNoPrevNext"),z=this._get(e,"navigationAsDateFormat"),B=this._getNumberOfMonths(e),J=this._get(e,"showCurrentAtPos"),V=this._get(e,"stepMonths"),X=1!==B[0]||1!==B[1],Z=this._daylightSavingAdjust(e.currentDay?new Date(e.currentYear,e.currentMonth,e.currentDay):new Date(9999,9,9)),q=this._getMinMaxDate(e,"min"),G=this._getMinMaxDate(e,"max"),Q=e.drawMonth-J,ee=e.drawYear;if(Q<0&&(Q+=12,ee--),G)for(t=this._daylightSavingAdjust(new Date(G.getFullYear(),G.getMonth()-B[0]*B[1]+1,G.getDate())),t=q&&t<q?q:t;this._daylightSavingAdjust(new Date(ee,Q,1))>t;)--Q<0&&(Q=11,ee--);for(e.drawMonth=Q,e.drawYear=ee,a=this._get(e,"prevText"),a=z?this.formatDate(a,this._daylightSavingAdjust(new Date(ee,Q-V,1)),this._getFormatConfig(e)):a,i=this._canAdjustMonth(e,-1,ee,Q)?"<a class='ui-datepicker-prev ui-corner-all' data-handler='prev' data-event='click' title='"+a+"'><span class='ui-icon ui-icon-circle-triangle-"+(L?"e":"w")+"'>"+a+"</span></a>":P?"":"<a class='ui-datepicker-prev ui-corner-all ui-state-disabled' title='"+a+"'><span class='ui-icon ui-icon-circle-triangle-"+(L?"e":"w")+"'>"+a+"</span></a>",s=this._get(e,"nextText"),s=z?this.formatDate(s,this._daylightSavingAdjust(new Date(ee,Q+V,1)),this._getFormatConfig(e)):s,n=this._canAdjustMonth(e,1,ee,Q)?"<a class='ui-datepicker-next ui-corner-all' data-handler='next' data-event='click' title='"+s+"'><span class='ui-icon ui-icon-circle-triangle-"+(L?"w":"e")+"'>"+s+"</span></a>":P?"":"<a class='ui-datepicker-next ui-corner-all ui-state-disabled' title='"+s+"'><span class='ui-icon ui-icon-circle-triangle-"+(L?"w":"e")+"'>"+s+"</span></a>",r=this._get(e,"currentText"),o=this._get(e,"gotoCurrent")&&e.currentDay?Z:U,r=z?this.formatDate(r,o,this._getFormatConfig(e)):r,d=e.inline?"":"<button type='button' class='ui-datepicker-close ui-state-default ui-priority-primary ui-corner-all' data-handler='hide' data-event='click'>"+this._get(e,"closeText")+"</button>",c=W?"<div class='ui-datepicker-buttonpane ui-widget-content'>"+(L?d:"")+(this._isInRange(e,o)?"<button type='button' class='ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all' data-handler='today' data-event='click'>"+r+"</button>":"")+(L?"":d)+"</div>":"",l=parseInt(this._get(e,"firstDay"),10),l=isNaN(l)?0:l,u=this._get(e,"showWeek"),h=this._get(e,"dayNames"),p=this._get(e,"dayNamesMin"),g=this._get(e,"monthNames"),_=this._get(e,"monthNamesShort"),m=this._get(e,"beforeShowDay"),f=this._get(e,"showOtherMonths"),k=this._get(e,"selectOtherMonths"),D=this._getDefaultDate(e),y="",$=0;$<B[0];$++){for(M="",this.maxRows=4,w=0;w<B[1];w++){if(b=this._daylightSavingAdjust(new Date(ee,Q,e.selectedDay)),C=" ui-corner-all",I="",X){if(I+="<div class='ui-datepicker-group",B[1]>1)switch(w){case 0:I+=" ui-datepicker-group-first",C=" ui-corner-"+(L?"right":"left");break;case B[1]-1:I+=" ui-datepicker-group-last",C=" ui-corner-"+(L?"left":"right");break;default:I+=" ui-datepicker-group-middle",C=""}I+="'>"}for(I+="<div class='ui-datepicker-header ui-widget-header ui-helper-clearfix"+C+"'>"+(/all|left/.test(C)&&0===$?L?n:i:"")+(/all|right/.test(C)&&0===$?L?i:n:"")+this._generateMonthYearHeader(e,Q,ee,q,G,$>0||w>0,g,_)+"</div><table class='ui-datepicker-calendar'><thead><tr>",x=u?"<th class='ui-datepicker-week-col'>"+this._get(e,"weekHeader")+"</th>":"",v=0;v<7;v++)N=(v+l)%7,x+="<th scope='col'"+((v+l+6)%7>=5?" class='ui-datepicker-week-end'":"")+"><span title='"+h[N]+"'>"+p[N]+"</span></th>";for(I+=x+"</tr></thead><tbody>",S=this._getDaysInMonth(ee,Q),ee===e.selectedYear&&Q===e.selectedMonth&&(e.selectedDay=Math.min(e.selectedDay,S)),Y=(this._getFirstDayOfMonth(ee,Q)-l+7)%7,F=Math.ceil((Y+S)/7),T=X&&this.maxRows>F?this.maxRows:F,this.maxRows=T,A=this._daylightSavingAdjust(new Date(ee,Q,1-Y)),K=0;K<T;K++){for(I+="<tr>",j=u?"<td class='ui-datepicker-week-col'>"+this._get(e,"calculateWeek")(A)+"</td>":"",v=0;v<7;v++)O=m?m.apply(e.input?e.input[0]:null,[A]):[!0,""],R=(E=A.getMonth()!==Q)&&!k||!O[0]||q&&A<q||G&&A>G,j+="<td class='"+((v+l+6)%7>=5?" ui-datepicker-week-end":"")+(E?" ui-datepicker-other-month":"")+(A.getTime()===b.getTime()&&Q===e.selectedMonth&&e._keyEvent||D.getTime()===A.getTime()&&D.getTime()===b.getTime()?" "+this._dayOverClass:"")+(R?" "+this._unselectableClass+" ui-state-disabled":"")+(E&&!f?"":" "+O[1]+(A.getTime()===Z.getTime()?" "+this._currentClass:"")+(A.getTime()===U.getTime()?" ui-datepicker-today":""))+"'"+(E&&!f||!O[2]?"":" title='"+O[2].replace(/'/g,"&#39;")+"'")+(R?"":" data-handler='selectDay' data-event='click' data-month='"+A.getMonth()+"' data-year='"+A.getFullYear()+"'")+">"+(E&&!f?"&#xa0;":R?"<span class='ui-state-default'>"+A.getDate()+"</span>":"<a class='ui-state-default"+(A.getTime()===U.getTime()?" ui-state-highlight":"")+(A.getTime()===Z.getTime()?" ui-state-active":"")+(E?" ui-priority-secondary":"")+"' href='#'>"+A.getDate()+"</a>")+"</td>",A.setDate(A.getDate()+1),A=this._daylightSavingAdjust(A);I+=j+"</tr>"}++Q>11&&(Q=0,ee++),M+=I+="</tbody></table>"+(X?"</div>"+(B[0]>0&&w===B[1]-1?"<div class='ui-datepicker-row-break'></div>":""):"")}y+=M}return y+=c,e._keyEvent=!1,y},_generateMonthYearHeader:function(e,t,a,i,s,n,r,o){var d,c,l,u,h,p,g,_,m=this._get(e,"changeMonth"),f=this._get(e,"changeYear"),k=this._get(e,"showMonthAfterYear"),D="<div class='ui-datepicker-title'>",y="";if(n||!m)y+="<span class='ui-datepicker-month'>"+r[t]+"</span>";else{for(d=i&&i.getFullYear()===a,c=s&&s.getFullYear()===a,y+="<select class='ui-datepicker-month' data-handler='selectMonth' data-event='change'>",l=0;l<12;l++)(!d||l>=i.getMonth())&&(!c||l<=s.getMonth())&&(y+="<option value='"+l+"'"+(l===t?" selected='selected'":"")+">"+o[l]+"</option>");y+="</select>"}if(k||(D+=y+(!n&&m&&f?"":"&#xa0;")),!e.yearshtml)if(e.yearshtml="",n||!f)D+="<span class='ui-datepicker-year'>"+a+"</span>";else{for(u=this._get(e,"yearRange").split(":"),h=(new Date).getFullYear(),g=(p=function(e){var t=e.match(/c[+\-].*/)?a+parseInt(e.substring(1),10):e.match(/[+\-].*/)?h+parseInt(e,10):parseInt(e,10);return isNaN(t)?h:t})(u[0]),_=Math.max(g,p(u[1]||"")),g=i?Math.max(g,i.getFullYear()):g,_=s?Math.min(_,s.getFullYear()):_,e.yearshtml+="<select class='ui-datepicker-year' data-handler='selectYear' data-event='change'>";g<=_;g++)e.yearshtml+="<option value='"+g+"'"+(g===a?" selected='selected'":"")+">"+g+"</option>";e.yearshtml+="</select>",D+=e.yearshtml,e.yearshtml=null}return D+=this._get(e,"yearSuffix"),k&&(D+=(!n&&m&&f?"":"&#xa0;")+y),D+="</div>"},_adjustInstDate:function(e,t,a){var i=e.selectedYear+("Y"===a?t:0),s=e.selectedMonth+("M"===a?t:0),n=Math.min(e.selectedDay,this._getDaysInMonth(i,s))+("D"===a?t:0),r=this._restrictMinMax(e,this._daylightSavingAdjust(new Date(i,s,n)));e.selectedDay=r.getDate(),e.drawMonth=e.selectedMonth=r.getMonth(),e.drawYear=e.selectedYear=r.getFullYear(),"M"!==a&&"Y"!==a||this._notifyChange(e)},_restrictMinMax:function(e,t){var a=this._getMinMaxDate(e,"min"),i=this._getMinMaxDate(e,"max"),s=a&&t<a?a:t;return i&&s>i?i:s},_notifyChange:function(e){var t=this._get(e,"onChangeMonthYear");t&&t.apply(e.input?e.input[0]:null,[e.selectedYear,e.selectedMonth+1,e])},_getNumberOfMonths:function(e){var t=this._get(e,"numberOfMonths");return null==t?[1,1]:"number"==typeof t?[1,t]:t},_getMinMaxDate:function(e,t){return this._determineDate(e,this._get(e,t+"Date"),null)},_getDaysInMonth:function(e,t){return 32-this._daylightSavingAdjust(new Date(e,t,32)).getDate()},_getFirstDayOfMonth:function(e,t){return new Date(e,t,1).getDay()},_canAdjustMonth:function(e,t,a,i){var s=this._getNumberOfMonths(e),n=this._daylightSavingAdjust(new Date(a,i+(t<0?t:s[0]*s[1]),1));return t<0&&n.setDate(this._getDaysInMonth(n.getFullYear(),n.getMonth())),this._isInRange(e,n)},_isInRange:function(e,t){var a,i,s=this._getMinMaxDate(e,"min"),n=this._getMinMaxDate(e,"max"),r=null,o=null,d=this._get(e,"yearRange");return d&&(a=d.split(":"),i=(new Date).getFullYear(),r=parseInt(a[0],10),o=parseInt(a[1],10),a[0].match(/[+\-].*/)&&(r+=i),a[1].match(/[+\-].*/)&&(o+=i)),(!s||t.getTime()>=s.getTime())&&(!n||t.getTime()<=n.getTime())&&(!r||t.getFullYear()>=r)&&(!o||t.getFullYear()<=o)},_getFormatConfig:function(e){var t=this._get(e,"shortYearCutoff");return t="string"!=typeof t?t:(new Date).getFullYear()%100+parseInt(t,10),{shortYearCutoff:t,dayNamesShort:this._get(e,"dayNamesShort"),dayNames:this._get(e,"dayNames"),monthNamesShort:this._get(e,"monthNamesShort"),monthNames:this._get(e,"monthNames")}},_formatDate:function(e,t,a,i){t||(e.currentDay=e.selectedDay,e.currentMonth=e.selectedMonth,e.currentYear=e.selectedYear);var s=t?"object"==typeof t?t:this._daylightSavingAdjust(new Date(i,a,t)):this._daylightSavingAdjust(new Date(e.currentYear,e.currentMonth,e.currentDay));return this.formatDate(this._get(e,"dateFormat"),s,this._getFormatConfig(e))}}),$.fn.datepicker=function(e){if(!this.length)return this;$.datepicker.initialized||($(document).on("mousedown",$.datepicker._checkExternalClick),$.datepicker.initialized=!0),0===$("#"+$.datepicker._mainDivId).length&&$("body").append($.datepicker.dpDiv);var t=Array.prototype.slice.call(arguments,1);return"string"!=typeof e||"isDisabled"!==e&&"getDate"!==e&&"widget"!==e?"option"===e&&2===arguments.length&&"string"==typeof arguments[1]?$.datepicker["_"+e+"Datepicker"].apply($.datepicker,[this[0]].concat(t)):this.each(function(){"string"==typeof e?$.datepicker["_"+e+"Datepicker"].apply($.datepicker,[this].concat(t)):$.datepicker._attachDatepicker(this,e)}):$.datepicker["_"+e+"Datepicker"].apply($.datepicker,[this[0]].concat(t))},$.datepicker=new Datepicker,$.datepicker.initialized=!1,$.datepicker.uuid=(new Date).getTime(),$.datepicker.version="1.12.1";var widgetsDatepicker=$.datepicker;
});