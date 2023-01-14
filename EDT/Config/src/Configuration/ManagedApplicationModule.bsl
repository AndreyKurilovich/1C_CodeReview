
#Область ОбработчикиСобытий

Процедура ПриНачалеРаботыСистемы()
	
	СтрокаТриггер = "КодКонфигурации=";
	
	Если СтрЧислоВхождений(ПараметрЗапуска, СтрокаТриггер) > 0 Тогда 
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Запуск в автоматическом режиме'"));
		КодКонфигурации = "";
		
		СтрокиПараметраЗапуска = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПараметрЗапуска, ",");
		
		Для каждого Строка Из СтрокиПараметраЗапуска Цикл
		
			Если СтрЧислоВхождений(Строка, СтрокаТриггер) > 0 Тогда
			
				КодКонфигурации = СтрЗаменить(Строка, СтрокаТриггер, "");
				РаботаСЗадачамиКлиент.АвтоматическаяГенерацияФайловЗадач(КодКонфигурации);
			
			КонецЕсли;	
		
		КонецЦикла;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаТриггер + " : " + КодКонфигурации);
		
		ЗавершитьРаботуСистемы(Ложь, Ложь); 
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти