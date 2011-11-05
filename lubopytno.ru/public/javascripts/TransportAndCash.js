LentaComponent.Cash = {
			monthsNames:['january','february','march','april','may','june','july','august','september','october','november','december'],
			monthsNamesRus:['январь','февраль','март','апрель','май','июнь','июль','август','сентябрь','октябрь','ноябрь','декабрь'],
			monthsLength:[31,(new Date().getFullYear()%4 == 0?29:28),31,30,31,30,31,31,30,31,30,31],
			actualMonths:(function(){ 
									if(window.months){
										var val = window.months;
										if(!$.browser.msie){delete window.months};
										return val;
									}else{ return null }
			})(),
			
			add:function(html,month,year){
				
				var months = html.split('&&');//id=\"+[a-z,A-Z,0-9,-_]*\"+/g.exec(html);
				var cash = LentaComponent.Cash.actualMonths;
				if(typeof months == 'object'){
					for(var i=0;i<months.length;i++){
						var monthDataArr = months[i].match(/id=\"+[a-z,A-Z,0-9,-_]*\"+/)[0].
										match(/\d{4}|\d{1,2}/g);
						var year = parseInt(monthDataArr[0]);
						var monthNum = parseInt(monthDataArr[1]);
						var monthName = LentaComponent.Cash.monthsNames[monthNum-1];
						var key = year+'-'+monthName;
						cash[key] = {};
						cash[key].html = months[i];
						cash[key].length = months[i].match(/class=\"day(\s[a-z,_]|\")+/g).length;
						cash[key].num = monthNum;
						cash[key].year = year;
						cash[key].link = '/months/'+year+'-'+(monthNum<10?'0':'')+monthNum+'.json';
					}
				}
				return cash[key];
			},
			
			get:function(month,year){
				var monthName = LentaComponent.Cash.monthsNames[month-1];
				var monthObject = this.actualMonths[year+'-'+monthName];
				if(monthObject && monthObject.year == year){
					return monthObject;
				}
			},
			
			createCalendarBlock:function(mon,year){
				var months = LentaComponent.Cash.actualMonths;
				var length = months[ year+'-'+LentaComponent.Cash.monthsNames[mon-1] ].length;
				var block = '<div id="'+year+'month_calendar'+mon+'" class="month_calendar"><div class="month_name">'+LentaComponent.Cash.monthsNamesRus[mon-1]+'</div>';				
				for(var i = 1;i<=length;i++){
					block+='<div class="day_calendar">'+i+'</div>';
				};
				block+='</div>';
				return block;
			},
			
}
LentaComponent.Transport = {
					
			getMonthBlock:function(link1,link2){
					var url = 'months/'+link1+(link2?'_'+link2:'')+'.json';
					
					$.ajax({
							type:'POST',
							url:url,
														
							complete:function(httpRequest){
									if(httpRequest.status == 200)
										//console.log(httpRequest.responseText);
										LentaComponent.addMonth(LentaComponent.Cash.add(httpRequest.responseText));
							},
							
							error:function(httpRequest){
									//alert(httpRequest.responseText);
							}
					})
					
			}
}
