var LentaComponent = {
	
	lentaHandler: $('#lenta'),
	calendarHandler: $('#calendar'),
	marker: $('#marker'),
	touchpads: $('.touchpad'),
	
	pageWidth: $('body').width(),
	
	previosLentaDay: null,
	previosCalendarDay: null,
	
	//Внутренние объекты
	Lenta:{
				months:[],
				currPositionLenta:null,
				beforeZeroLength:0,
				dayWidth:	parseInt( getCssRuleValue(0,'.day','width') || 0 )+
							parseInt( getCssRuleValue(0,'.day','paddingLeft') || 0 )+
							parseInt( getCssRuleValue(0,'.day','paddingRight') || 0 )+
							parseInt( getCssRuleValue(0,'.day','marginRight')  || 0 )+
							parseInt( getCssRuleValue(0,'.day','marginLeft')  || 0 ),
				startDrag:{x:null,time:null},
				stopDrag:{x:null,time:null},
									
				createMonthObject:function(obj){
					var obj = obj || {};
					this.year = obj.year || null;
					this.month = obj.month || null;
					this.width = obj.width || null;
					this.position = obj.position || null;
									
					LentaComponent.Lenta.months.push(this);
				},
				
				getLeftPoint:function(){ return LentaComponent.pageWidth/2 - this.dayWidth/2 + this.beforeZeroLength },
				getRightPoint:function(){return -(this.getFullLength()-LentaComponent.pageWidth/2 - this.dayWidth/2)},
				
				getFullLength:function(){
					var l = 0;
					for(var i=0;i<this.months.length;i++){
						if(this.months[i].position >= 0)	//считаем только положительную длину
							l+=this.months[i].width;
					}
					return l;
				},
				getMinimalLeftPosition:function(){
					var min = 0;
					for(var i=0;i<this.months.length;i++){
						if(this.months[i].position < min)	//сравниваем с наименьшим
							min = this.months[i].position;
					}
					return min;
				}
	},
	Calendar:{
					months:[],
					currPositionCalendar:null,
					beforeZeroLength:0,
					dayWidth:parseInt( getCssRuleValue(0,'.day_calendar','width') )+
							parseInt( getCssRuleValue(0,'.day_calendar','paddingLeft') || 0 )+
							parseInt(	getCssRuleValue(0,'.day_calendar','paddingRight') || 0 )+
							parseInt( getCssRuleValue(0,'.day_calendar','marginRight') || 0 )+
							parseInt( getCssRuleValue(0,'.day_calendar','marginLeft') || 0 )+
							parseInt( getCssRuleValue(0,'.day_calendar','borderLeftWidth') || 0 )+
							parseInt( getCssRuleValue(0,'.day_calendar','borderRightWidth') || 0 ),
				
					createMonthObject:function(obj){
						var obj = obj || {};
						this.year = obj.year || null;
						this.month = obj.month || null;
						this.width = obj.width || null;
						this.position = obj.position || null;
									
						LentaComponent.Calendar.months.push(this);
					},
				
					getLeftPoint:function(){ return LentaComponent.pageWidth/2 - this.dayWidth/2 + this.beforeZeroLength},
					getRightPoint:function(){return -(LentaComponent.Lenta.getFullLength.call(this)-LentaComponent.pageWidth/2 - this.dayWidth/2)}
	},
	
	//методы
	init:function(){
		//LentaComponent.pageWidth = $('body').width();
	
		LentaComponent.addDateSelector();
		
		$('#today_but').bind('click',function(){
			
			LentaComponent.lentaHandler.stop();
			LentaComponent.calendarHandler.stop();
			var heuteTagNummer = new Date().getDate();
			var Monat = new Date().getMonth()+1;
			var year = new Date().getFullYear();

			LentaComponent.lentaCenter(Monat,heuteTagNummer,year);
			LentaComponent.calendarCenter(Monat,heuteTagNummer,year);
		});
		
		$('#calendar_but').bind('click',function(){
			$('#datapicker').css('display',$('#datapicker').css('display')=='block'?'none':'block');
		})
						
		//сохраняем все месяцы в виде объектов в массив	
		if(this.Lenta.months.length == 0){
			$('.month_lenta').each(function(){
				var month = new LentaComponent.Lenta.createMonthObject();
				month.year =  parseInt($(this).attr('id'));
				month.month = $(this).attr('id').replace(/^\d{4}[a-z,A-Z,_]+/,'');
				month.width = $(this).width();
				month.position = $(this).position().left;
			});
	
			$('.month_calendar').each(function(){
				var month = new LentaComponent.Calendar.createMonthObject();
				month.year =  parseInt($(this).attr('id'));
				month.month = parseInt( $(this).attr('id').replace(/^\d{4}[a-z,A-Z,_]+/,'') );
				month.width = $(this).width();
				month.position = $(this).position().left;
			});
		}
		//
		LentaComponent.marker.css('display',($.cookie("marker_check")=="true"?"block":"none")).fadeTo(0,0.5);
		LentaComponent.touchpads.css('display',($.cookie("scroll_check")=="true"?"block":"none")).fadeTo(0,0.1);

		var panel = $(
			'<div id="settingsPanel">'+
			'<div class="set_field"><input type="checkbox" '+($.cookie("marker_check")=="true"?"checked":"")+' class="check" id="marker_check" /><span class="caption">центральный маркер</span></div>'+
			'<div class="set_field"><input type="checkbox" '+($.cookie("scroll_check")=="true"?"checked":"")+' class="check" id="scroll_check" /><span class="caption">области прокрутки</span></div>'+
			'<input type="button" value="сохранить" id="save_but"/>'+
		'</div>').appendTo($('#win'));
		
		var button = $('<div id="switchPanelButton"></div>').appendTo($('#LentaComponent'));
		
		function saveAndClose(){
			if(panel.css('right') == '0px'){
				panel.animate({right:'-200px'},200);
				$('.check').each(function(){
					var self = $(this);
					$.cookie(self.attr('id'),self.attr('checked'));
				});
			}else{
				panel.animate({right:'0px'},200);
			}
		}
			
		$('#marker_check').bind('click',function(){
			if(LentaComponent.marker.css('display') == 'block'){
				LentaComponent.marker.css('display','none');
			}else{
				LentaComponent.marker.css('display','block');
			}
		});
		$('#scroll_check').bind('click',function(){
			if($('.left').css('display') == 'block'){
				LentaComponent.touchpads.css('display','none');
			}else{
				LentaComponent.touchpads.css('display','block');
			}
		});
		
		
		button.bind('click',function(){saveAndClose()});
		
		$('#save_but').bind('click',function(){saveAndClose()});
		
		LentaComponent.touchpads.hover(function(){$(this).fadeTo(0,0.3)},function(){$(this).fadeTo(0,0.1)})
		
		//корректируем css для подписей
		$('.caption').css({position:'relative',left:'3px',top:($.browser.opera?'0px':'-3px')});
	},
	//
	makeDraggableScrollable:function(){
		this.lentaHandler.draggable({
										axis: 'x',
										cursor: 'pointer',
										grid:[7,1],
										start:function(evt,ui){$('.day_calendar').removeClass('current');
																LentaComponent.Lenta.startDrag.x = evt.clientX;
																LentaComponent.Lenta.startDrag.time = evt.timeStamp;
										},
										drag:function(evt,ui){
											var offsetLenta = ui.position.left;
											var delta = offsetLenta - LentaComponent.Lenta.currPositionLenta;
											var currPositionCalendar = LentaComponent.calendarHandler.position().left;
											LentaComponent.calendarHandler.css('left',currPositionCalendar+delta/7+'px');
											LentaComponent.Lenta.currPositionLenta = offsetLenta;
										},
										stop:function(evt,ui){
																			
											var SPEED,speed = null;//
											var startDragX = LentaComponent.Lenta.startDrag.x;
											var startDragTime = LentaComponent.Lenta.startDrag.time;
											
											var stopDragX = evt.clientX;
											var stopDragTime = evt.timeStamp;
											
											
											var left = (startDragX > stopDragX);
											var right = (startDragX < stopDragX);
											var leftWay = (startDragX - stopDragX);
											var rightWay = (stopDragX - startDragX);
											var Time = stopDragTime - startDragTime;
											
											var LentaLeftPoint = LentaComponent.Lenta.getLeftPoint();
											var LentaRightPoint = LentaComponent.Lenta.getRightPoint();
											var CalendarLeftPoint = LentaComponent.Calendar.getLeftPoint();
											var CalendarRightPoint = LentaComponent.Calendar.getRightPoint();
											
											if(left && (leftWay < 200 && leftWay > 2)){
												SPEED = speed = Math.round(leftWay/Time*10);
												if(SPEED >= 0 && SPEED < 5){SPEED = 80000};
												if(SPEED >= 5 && SPEED <= 10){SPEED = 30000};
												if(SPEED > 10 && SPEED <= 15){SPEED = 15000};
												if(SPEED > 15 && SPEED < 100){SPEED = 7000};
												LentaComponent.lentaHandler.animate({left:LentaRightPoint},SPEED,'linear');
												LentaComponent.calendarHandler.animate({left:CalendarRightPoint},SPEED,'linear');
											}
											if(right && (rightWay < 200 && rightWay > 2)){
												SPEED = speed = Math.round(rightWay/Time*10);
												if(SPEED >= 0 && SPEED < 5){SPEED = 80000};
												if(SPEED >= 5 && SPEED <= 10){SPEED = 30000};
												if(SPEED > 10 && SPEED <= 15){SPEED = 15000};
												if(SPEED > 15 && SPEED < 100){SPEED = 7000};
												LentaComponent.lentaHandler.animate({left:LentaLeftPoint},SPEED,'linear');
												LentaComponent.calendarHandler.animate({left:CalendarLeftPoint},SPEED,'linear');
											}
										}
									});
			
		this.lentaHandler.bind('mousedown',function(){
			LentaComponent.lentaHandler.stop();
			LentaComponent.calendarHandler.stop();
			LentaComponent.Lenta.currPositionLenta = LentaComponent.lentaHandler.offset().left;
		});
		
		
		
		$('.touchpad').bind('mouseover',function(evt){
			var directionLenta = null;
			var directionCalendar = null;
			
			if($(evt.target).hasClass('left')){
				directionLenta = LentaComponent.Lenta.getLeftPoint();
				directionCalendar = LentaComponent.Calendar.getLeftPoint();
			}else{
				directionLenta = LentaComponent.Lenta.getRightPoint();
				directionCalendar = LentaComponent.Calendar.getRightPoint();
			}
			
			LentaComponent.lentaHandler.stop().animate({left:directionLenta},25000,'linear');
			LentaComponent.calendarHandler.stop().animate({left:directionCalendar},25000,'linear');
			
		}).bind('mouseout',function(){
			LentaComponent.lentaHandler.stop();
			LentaComponent.calendarHandler.stop();
			LentaComponent.Lenta.currPositionLenta = LentaComponent.lentaHandler.offset().left;
		});
	
	},
	makeClickabely:function(){
	
		$('.month_calendar').live('click',function(evt){
			LentaComponent.lentaHandler.stop();
			LentaComponent.calendarHandler.stop();
			var target = $(evt.target);
			if(target.hasClass('day_calendar')){
				var id = $(this).attr('id');
				var dayNumber = parseInt(target.text());
				var year = parseInt(id.replace(/[a-z,A-Z,_]\d{1,2}/,''));
				var currMonth = parseInt(id.replace(/\d{4}month_calendar/,''));
				var lentaDay = $($('#'+year+'month_lenta'+currMonth).children('.day')[dayNumber-1]);
				//alert($(lentaDay).attr('class'))
				
				(LentaComponent.previosCalendarDay || $()).removeClass('onclick');
				(LentaComponent.previosLentaDay || $()).removeClass('current_day');
				
				LentaComponent.lentaCenter(currMonth,dayNumber,year);
				LentaComponent.calendarCenter(currMonth,dayNumber,year);
				
				target.addClass('onclick');
				$(lentaDay).addClass('current_day');
				
				LentaComponent.previosCalendarDay = target;
				LentaComponent.previosLentaDay = $(lentaDay);
			}
		});
		
		$('.month_lenta').live('click',function(evt){
			LentaComponent.lentaHandler.stop();
			LentaComponent.calendarHandler.stop();
			
			var target = $(evt.target);
			// проверим, может кликнули на дочернем элементе
			target.parents().map(function(){
				if($(this).hasClass('day')){
					target = $(this);
				}
			})
			if( target.hasClass('day') ){
				var id = $(this).attr('id');
				var dayNumber = $(this).children('.day').index(target)+1;
				var currMonth = parseInt(id.replace(/\d{4}month_lenta/,''));
				var year = parseInt(id.replace(/[a-z,A-Z,_]\d{1,2}/,''));
				var calendarDay = $('#'+year+'month_calendar'+currMonth).children('.day_calendar')[dayNumber-1];
				
				try {
					LentaComponent.previosCalendarDay.removeClass('onclick');
					LentaComponent.previosLentaDay.removeClass('current_day');
				}catch(e){}
							
				target.addClass('current_day');
				$(calendarDay).addClass('onclick');
				
				LentaComponent.lentaCenter(currMonth,dayNumber,year);
				LentaComponent.calendarCenter(currMonth,dayNumber,year);
				
				LentaComponent.previosLentaDay = target;
				LentaComponent.previosCalendarDay = $(calendarDay);
			}else if(target.hasClass('handler')){
				//SNAP!!!!!!!!!!
				//alert();
			}
		})
		
	},
	
	lentaCenter:function(month,day,year){
		var lentaX = $('#'+year+'month_lenta' + month).position().left;
		var offsetLenta = lentaX +(LentaComponent.Lenta.dayWidth * day) - (LentaComponent.pageWidth/2) - LentaComponent.Lenta.dayWidth/2;
		LentaComponent.lentaHandler.animate({left:-offsetLenta},700,function(){
			LentaComponent.Lenta.currPositionLenta = LentaComponent.lentaHandler.offset().left;
			LentaComponent.blinkDay(month,day,year,400,10);
		});
	},
	
	calendarCenter:function(month,day,year){
		var calendarX = $('#'+year+'month_calendar'+month).position().left;
		var offsetCalendar = calendarX + (LentaComponent.Calendar.dayWidth * day) - (LentaComponent.pageWidth/2) - LentaComponent.Calendar.dayWidth/2;
		LentaComponent.calendarHandler.animate({left:-(offsetCalendar)},700);
	},
	snap:function(){
		
	},
	blinkDay:function(month,day,year,fadeout,fadein){
		//var currentDay = $('#'+year+'month_lenta' + month).children('.day').eq(day-1).children('h1');
		//(LentaComponent.previosLentaDay || $()).animate({'fontSize':'12px'},0)
		//currentDay.animate({'fontSize':'14px'},10);
		//LentaComponent.previosLentaDay = currentDay;	
	},
	
	addMonth:function(monthObject){
		var monthObject = monthObject || {};
		
		var days_in_month = LentaComponent.Cash.monthsLength;
		var curr_year = new Date().getFullYear();
		var curr_month_num = new Date().getMonth()+1;
		var curr_day = new Date().getDate();
			
		var blockCalendar = document.createDocumentFragment(); 
		var blockLenta = document.createDocumentFragment();
			
		var day_calendar_width = LentaComponent.Calendar.dayWidth;
		var day_lenta_width = LentaComponent.Lenta.dayWidth;
			
		var Calendar,Lenta = null;
		var leftPosCalendar,leftPosLenta = null;
		
		var month_num = monthObject.num;
		var month_year = monthObject.year;
		var day_in_month = monthObject.length;
		
		var handler = jQuery('<div class="handler">&nbsp;</div>');
								
		Calendar = jQuery(LentaComponent.Cash.createCalendarBlock(month_num,month_year));
		Lenta = jQuery(monthObject.html);
		handler.appendTo(Lenta);
		
		//текущий месяц
		if( month_num == curr_month_num && month_year == curr_year){
			leftPosCalendar = 0;
			leftPosLenta = 0;
			Calendar.css('left',leftPosCalendar+'px').css('width',day_calendar_width * day_in_month+'px');
			Lenta.css('left',leftPosLenta).css('width',day_lenta_width * day_in_month+'px');
			blockCalendar.appendChild(Calendar[0]);
			blockLenta.appendChild(Lenta[0]);
		}
	
	//после текущего месяца
		if( month_num > curr_month_num ){
			if(month_year == curr_year){
				var offset = month_num - curr_month_num;
				var l = this.getMonthOffset(curr_month_num,offset,'forward');
				//alert(l);
				leftPosCalendar = l * day_calendar_width;
				leftPosLenta = l * day_lenta_width;
				//alert(leftPosCalendar);
				Calendar.css('left',leftPosCalendar+'px').css('width',day_calendar_width * day_in_month+'px');
				Lenta.css('left',leftPosLenta+'px').css('width',day_lenta_width * day_in_month+'px');
					
				blockCalendar.appendChild(Calendar[0]);
				blockLenta.appendChild(Lenta[0]);
				//console.log(month_num,' ',curr_month_num,' ',l);
			}
			if( month_year < curr_year ){
				var offsetYear = curr_year - month_year;
						//console.log(offsetYear);
			}
			if( month_year > curr_year ){
				var offsetYear = month_year - curr_year;
			}
		}
				
		//пред текущим месяцем
		if( month_num < curr_month_num ){
			if(month_year == curr_year){
				var offset = curr_month_num - month_num;
				var l = this.getMonthOffset(curr_month_num,offset,'back');
				leftPosCalendar = -(l * day_calendar_width);
				leftPosLenta = -(l * day_lenta_width);
						
				Calendar.css('left',leftPosCalendar+'px').css('width',day_calendar_width * day_in_month+'px');
				Lenta.css('left',leftPosLenta+'px').css('width',day_lenta_width * day_in_month+'px');
						
				blockCalendar.appendChild(Calendar[0]);
				blockLenta.appendChild(Lenta[0]);
						
				LentaComponent.Lenta.beforeZeroLength = Math.abs(leftPosLenta);
				LentaComponent.Calendar.beforeZeroLength = Math.abs(leftPosCalendar);

				//console.log(month_num,' ',curr_month_num,' ',l);
			}
			if( month_year < curr_year ){
				var offsetYear = month_year - curr_year;
				//console.log(offsetYear);
			}
		}
			
		$(blockCalendar).appendTo(LentaComponent.calendarHandler);
		$(blockLenta).appendTo(LentaComponent.lentaHandler);
		
		var objCalendar = {
							year:month_year,
							month:month_num,
							width:day_calendar_width * day_in_month,
							position:leftPosCalendar
						}
		var objLenta = {
						year:month_year,
						month:month_num,
						width:day_lenta_width * day_in_month,
						position:leftPosLenta
					}
		
		new LentaComponent.Calendar.createMonthObject(objCalendar);
		new LentaComponent.Lenta.createMonthObject(objLenta);
		
	},
	
	addAllMonths:function(){
		
		var actualMonths = LentaComponent.Cash.actualMonths;
		if(actualMonths){
			for(var i in actualMonths){
				this.addMonth(actualMonths[i]);
			}
		}
		LentaComponent.marker.css('display','block').fadeTo(0,0.5);
	},
	getMonthOffset:function(begin,offset,direction){
		var arr = LentaComponent.Cash.monthsLength;
		var newArr = (direction == 'forward')?
						arr.slice(begin-1,begin+offset-1):
					arr.slice((begin-offset)-1,begin-1);
						
		var count = 0;
		
		for(var i=0;i<newArr.length;i++){
			count+=newArr[i];
		}
		return count;
	},
	addHandler:function(){
		var handler = $('<div class="handler">&nbsp;</div>');
		
		$('.month_lenta').each(function(){
			handler.clone(true).appendTo($(this));
			$(this).children();
		})
		$('#win').css('height','267px');
	},
	addDateSelector:function(){
		var selector = $('<div id="datapicker"></div><div id="datapickerWrap"><span id="today_but">сегодня</span>&nbsp;&nbsp;&nbsp;<span id="calendar_but">календарь</span></div>').appendTo('body');
		
		$.datepicker.setDefaults($.extend($.datepicker.regional["ru"]));
		$('#datapicker').datepicker({
								showOn:'button',
								buttonImageOnly:false,
								buttonText:'выбрать день',
								changeMonth:false,
								changeYear:false,
								constrainInput:false,
								duration:'',
								monthNames:['январь','февраль','март','апрель','май','июнь','июль','август','сентеябрь','октябрь','ноябрь','декабрь'],
								showButtonPanel:false,
								onSelect:function(dateText,inst){
									$('#datapicker').css('display','none');
									var day = parseInt(inst.selectedDay);
									var month = parseInt(inst.selectedMonth)+1;
									var year = parseInt(inst.selectedYear);
									LentaComponent.lentaCenter(month,day,year);
									LentaComponent.calendarCenter(month,day,year);
								}
		}).draggable();
	}
}
function getCssRuleValue(sheet,CSSselector,styleName){
		var cssFileLength = document.styleSheets.length;
		var cssFile = document.styleSheets[parseInt(sheet)];
		var rules = cssFile[ (/MSIE/).test(navigator.userAgent)?'rules':'cssRules' ];
		var rulesLength = rules.length;
		
		for(var i=0;i<rulesLength;i++){
			if(rules[i].selectorText == CSSselector){
				return rules[i].style[styleName];
			}
		}
		return null;
	}
/*
function consoleLog(arg1){
	if(typeof console == 'undefined') return;
	console.log.apply(null,arguments);
}
function consoleClear(){
	if(typeof console === 'undefined' || typeof console.clear === 'undefined') return;
	console.clear();
}
*/

