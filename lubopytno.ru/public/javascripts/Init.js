(function(){
	//$(document).bind('dblclick',function(){})
	//$('#lentaComponent').draggable({axis:'y'});

	window.onload = function(){
		
		LentaComponent.addAllMonths();
		
		LentaComponent.init();

		LentaComponent.makeClickabely();
		LentaComponent.makeDraggableScrollable();

		var heuteTagNummer = new Date().getDate();
		var Monat = new Date().getMonth()+1;
		var year = new Date().getFullYear();

		LentaComponent.lentaCenter(Monat,heuteTagNummer,year);
		LentaComponent.calendarCenter(Monat,heuteTagNummer,year);
		//отключаем реакцию дней
		//$('.day').bind('click',function(){return false});
		$('.day').bind('mousedown',function(){return false});

		LentaComponent.Transport.getMonthBlock('2009-06');
		//LentaComponent.addMonth();
		//console.log(LentaComponent.Cash.get(8,2009));
		//LentaComponent.addHandler();
	}
})()
