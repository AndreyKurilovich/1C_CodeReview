#Область ПрограммныйИнтерфейс

// Формирует структуру параметров, в которой расположены реквизиты поиска задачи в исходном коде.
//
// Параметры:
//  Задача - СправочникСсылка.Задачи - Задача, по которой требуется провести поиск.
//
// Возвращаемое значение:
//  Структура - свойства задачи в исходном коде
//
Функция ПараметрыЗадачиВИсходныхФайлах(Задача) Экспорт
	
	ДанныеЗадачи = РаботаСЗадачамиВызовСервера.ДанныеЗадачи(Задача);
	
	Файл = Новый Файл(ДанныеЗадачи.ИмяФайла);
	ФайлСуществует = Файл.Существует();
	
	Если Не ФайлСуществует Тогда
		ТекстОшибки = СтрШаблон(НСтр("ru='Файл не существует: %1'"), ДанныеЗадачи.ИмяФайла);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли; 
	
	ПараметрыЗадачи = Новый Структура;
	ПараметрыЗадачи.Вставить("НомерНачальнойСтроки", 		0);
	ПараметрыЗадачи.Вставить("НомерСимволаНачальнойСтроки", 0);
	ПараметрыЗадачи.Вставить("НомерКонечнойСтроки", 		0);
	ПараметрыЗадачи.Вставить("НомерСимволаКонечнойСтроки", 	0);
	ПараметрыЗадачи.Вставить("УсловиеПоискаНайдено", 		Ложь);
	ПараметрыЗадачи.Вставить("БлокПрограммногоКода", 		"");
	
	ПоискПоСтрокам 	= ПредопределенноеЗначение("Перечисление.ВариантыУсловийПоиска.ПоследовательныйПоискПоСтрокам");
	ПерваяСтрока 	= ПредопределенноеЗначение("Перечисление.ВариантыУсловийПоиска.ПерваяСтрокаФайла");
		
	Если ДанныеЗадачи.ВариантУсловияПоиска = ПоискПоСтрокам Тогда
	
		ПоследовательныйПоискПоСтрокам(ДанныеЗадачи.ИмяФайла, ДанныеЗадачи, ПараметрыЗадачи);
		
	ИначеЕсли ДанныеЗадачи.ВариантУсловияПоиска = ПерваяСтрока Тогда
				
		ПоискПервойСтрокиФайла(ДанныеЗадачи.ИмяФайла, ПараметрыЗадачи);
		
	КонецЕсли;	
	
	Возврат ПараметрыЗадачи;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПоследовательныйПоискПоСтрокам

Процедура ПоследовательныйПоискПоСтрокам(ИмяФайла, ДанныеЗадачи, ПараметрыЗадачи)

	ПараметрыЗадачи.УсловиеПоискаНайдено = Истина; 

	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайла);
	
	НомерСтрокиПредыдущегоПоиска = 0;
	
	Для каждого УсловиеПоиска Из ДанныеЗадачи.Условия Цикл
		
		Если УсловиеПоиска.ВидПострочногоПоиска = ПредопределенноеЗначение("Перечисление.ВидыПострочногоПоиска.СНачалаФайла") Тогда
			НомерСтрокиПредыдущегоПоиска = 0;		
		КонецЕсли;    
	
		ПозицияУсловия = ПозицияУсловияВТексте(ТекстовыйДокумент, УсловиеПоиска, НомерСтрокиПредыдущегоПоиска); 
		НомерСтрокиПредыдущегоПоиска = Макс(НомерСтрокиПредыдущегоПоиска, ПозицияУсловия.НомерНачальнойСтроки);
		
		Если ПозицияУсловия.УсловиеНайдено И УсловиеПоиска.МеткаВКоде Тогда
			
			ПараметрыЗадачи.НомерНачальнойСтроки 		= ПозицияУсловия.НомерНачальнойСтроки;	
			ПараметрыЗадачи.НомерСимволаНачальнойСтроки = ПозицияУсловия.НомерСимволаНачальнойСтроки; 
			
			ПараметрыЗадачи.НомерКонечнойСтроки 		= ПозицияУсловия.НомерНачальнойСтроки;	
			ПараметрыЗадачи.НомерСимволаКонечнойСтроки 	= ПозицияУсловия.НомерСимволаКонечнойСтроки; 
			
		КонецЕсли;  
		
		ПараметрыЗадачи.УсловиеПоискаНайдено = Мин(ПараметрыЗадачи.УсловиеПоискаНайдено, ПозицияУсловия.УсловиеНайдено);
		
		Если Не ПараметрыЗадачи.УсловиеПоискаНайдено Тогда 		
			Прервать;			
		КонецЕсли;
		
	КонецЦикла; 
	
	ПараметрыЗадачи.БлокПрограммногоКода = БлокПрограммногоКода(
		ТекстовыйДокумент, 
		ПараметрыЗадачи.УсловиеПоискаНайдено, 
		ПараметрыЗадачи.НомерНачальнойСтроки, 
		ПараметрыЗадачи.НомерКонечнойСтроки);	
		
КонецПроцедуры

Функция БлокПрограммногоКода(ТекстовыйДокумент, УсловиеПоискаНайдено, НомерНачальнойСтроки, НомерКонечнойСтроки)
	
	БлокПрограммногоКода = "";
	
	ОтступКодаСверху 	= 10;
	ОтступКодаСнизу 	= 10;
	
	Если УсловиеПоискаНайдено Тогда
	
		НачалоБлока 	= Макс(1, НомерНачальнойСтроки - ОтступКодаСверху);
		ОкончаниеБлока 	= Мин(ТекстовыйДокумент.КоличествоСтрок(), НомерКонечнойСтроки + ОтступКодаСнизу);
		
		Для НомерСтроки = НачалоБлока По ОкончаниеБлока Цикл
		
			БлокПрограммногоКода = БлокПрограммногоКода + ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки) + Символы.ПС;	
		
		КонецЦикла;
	
	КонецЕсли;
	
	Возврат БлокПрограммногоКода;
	
КонецФункции

Функция ПозицияУсловияВТексте(ТекстовыйДокумент, УсловиеПоиска, Знач НомерСтрокиНачалаПоиска)
	
	ПозицияУсловия = Новый Структура; 
	ПозицияУсловия.Вставить("УсловиеНайдено", 				Ложь);
	ПозицияУсловия.Вставить("НомерНачальнойСтроки", 		0);
	ПозицияУсловия.Вставить("НомерСимволаНачальнойСтроки", 	0);
	ПозицияУсловия.Вставить("НомерСимволаКонечнойСтроки", 	0);
	
	НомерПервойСтроки 		= НомерПервойСтрокиПоиска(УсловиеПоиска, НомерСтрокиНачалаПоиска);
	НомерПоследнейСтроки 	= НомерПоследнейСтрокиПоиска(УсловиеПоиска, НомерСтрокиНачалаПоиска, ТекстовыйДокумент);
	
	ВариантПоискаСодержит = УсловиеПоиска.ВариантПоиска = ПредопределенноеЗначение("Перечисление.ВариантыПоиска.Содержит");
	УсловиеНайдено = Ложь;
	
	Для НомерСтроки = НомерПервойСтроки По НомерПоследнейСтроки Цикл
		
		СтрокаТекста = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
		
		НомерСимвола = СтрНайти(СтрокаТекста, УсловиеПоиска.Условие);
		УсловиеНайдено = НомерСимвола > 0;
		
		Если УсловиеНайдено Тогда
			
			Если ВариантПоискаСодержит Тогда
				
				ПозицияУсловия.УсловиеНайдено 				= УсловиеНайдено;		
				ПозицияУсловия.НомерНачальнойСтроки 		= НомерСтроки;		
				ПозицияУсловия.НомерСимволаНачальнойСтроки 	= НомерСимвола;		
				ПозицияУсловия.НомерСимволаКонечнойСтроки 	= НомерСимвола + СтрДлина(УсловиеПоиска.Условие);		
				
			КонецЕсли;
			
			Прервать; 
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ВариантПоискаСодержит Тогда
		
		СтрокаПозиции = Макс(1, НомерСтрокиНачалаПоиска);
		
		ПозицияУсловия.УсловиеНайдено = Не УсловиеНайдено; 
		ПозицияУсловия.НомерНачальнойСтроки 		= СтрокаПозиции;		
		ПозицияУсловия.НомерСимволаНачальнойСтроки 	= 1;		
		ПозицияУсловия.НомерСимволаКонечнойСтроки 	= 1;		
	
	КонецЕсли;
	
	Возврат ПозицияУсловия;
	
КонецФункции    

Функция НомерПервойСтрокиПоиска(УсловиеПоиска, НомерСтрокиНачалаПоиска)
	
	Если УсловиеПоиска.ВидПострочногоПоиска = ПредопределенноеЗначение("Перечисление.ВидыПострочногоПоиска.СНачалаФайла") Тогда
	
		НомерПервойСтроки = 0; 
		
	Иначе
		
		НомерПервойСтроки = НомерСтрокиНачалаПоиска + 1; 
		
	КонецЕсли;	
	
	Возврат НомерПервойСтроки;

КонецФункции

Функция НомерПоследнейСтрокиПоиска(УсловиеПоиска, НомерСтрокиНачалаПоиска, ТекстовыйДокумент)
	// BSLLS:MagicNumber-off
	// BSLLS:LineLength-off
	
	ПоследняяСтрокаФайла = ТекстовыйДокумент.КоличествоСтрок();
	НомерПоследнейСтроки = 0;
	
	Если УсловиеПоиска.ВидПострочногоПоиска = ПредопределенноеЗначение("Перечисление.ВидыПострочногоПоиска.НаСледующейСтроке") Тогда  
		
		НомерПоследнейСтроки = НомерСтрокиНачалаПоиска + 1;
		
	ИначеЕсли УсловиеПоиска.ВидПострочногоПоиска = ПредопределенноеЗначение("Перечисление.ВидыПострочногоПоиска.СледующиеДесятьСтрок") Тогда
		
		НомерПоследнейСтроки = НомерСтрокиНачалаПоиска + 11;
		
	ИначеЕсли УсловиеПоиска.ВидПострочногоПоиска = ПредопределенноеЗначение("Перечисление.ВидыПострочногоПоиска.СледующиеТридцатьСтрок") Тогда
		
		НомерПоследнейСтроки = НомерСтрокиНачалаПоиска + 31;
		
	ИначеЕсли УсловиеПоиска.ВидПострочногоПоиска = ПредопределенноеЗначение("Перечисление.ВидыПострочногоПоиска.СледующиеШестьдесятСтрок") Тогда
		
		НомерПоследнейСтроки = НомерСтрокиНачалаПоиска + 61;
		
	ИначеЕсли УсловиеПоиска.ВидПострочногоПоиска = ПредопределенноеЗначение("Перечисление.ВидыПострочногоПоиска.СледующиеСтоСтрок") Тогда
		
		НомерПоследнейСтроки = НомерСтрокиНачалаПоиска + 101;
	
	ИначеЕсли УсловиеПоиска.ВидПострочногоПоиска = ПредопределенноеЗначение("Перечисление.ВидыПострочногоПоиска.ДоКонцаМетода") Тогда
		
		НомерПоследнейСтроки = ПоследняяСтрокаТекущегоМетода(НомерСтрокиНачалаПоиска, ТекстовыйДокумент);
	
	Иначе
		
		НомерПоследнейСтроки = ПоследняяСтрокаФайла;
		
	КонецЕсли;
	
	НомерПоследнейСтроки = Мин(НомерПоследнейСтроки, ПоследняяСтрокаФайла);	 
	
	Возврат НомерПоследнейСтроки;
	
	// BSLLS:MagicNumber-on
	// BSLLS:LineLength-on
КонецФункции

Функция ПоследняяСтрокаТекущегоМетода(НомерСтрокиНачалаПоиска, ТекстовыйДокумент)
	
	ПоследняяСтрокаТекущегоМетода = 0;
	
	Для НомерСтроки = НомерСтрокиНачалаПоиска По ТекстовыйДокумент.КоличествоСтрок() Цикл
		
		ПоследняяСтрокаТекущегоМетода = НомерСтроки;
		
		СтрокаТекста = ВРег(ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки));
		
		НомерСимвола = СтрНайти(СтрокаТекста, ВРег("КонецПроцедуры"));
		Если НомерСимвола = 0 Тогда
			НомерСимвола = СтрНайти(СтрокаТекста, ВРег("КонецФункции"));
		КонецЕсли;
		
		Если НомерСимвола > 0 Тогда
			Прервать;	
		КонецЕсли;
		
	КонецЦикла;	
	
	Возврат ПоследняяСтрокаТекущегоМетода;
		
КонецФункции

#КонецОбласти

Процедура ПоискПервойСтрокиФайла(ИмяФайла, ПараметрыЗадачи)
		
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайла);	
	
	ПараметрыЗадачи.УсловиеПоискаНайдено = Истина; 	
		
	Для НомерСтроки = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
		
		СтрокаТекста = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
		
		Если ПустаяСтрока(СтрокаТекста) Тогда
			Продолжить;	
		КонецЕсли;	
		
		ПервыйСимвол = 1;
		
		ПараметрыЗадачи.НомерНачальнойСтроки = НомерСтроки;
		ПараметрыЗадачи.НомерСимволаНачальнойСтроки = ПервыйСимвол;
		
		ПараметрыЗадачи.НомерКонечнойСтроки = НомерСтроки;
		ПараметрыЗадачи.НомерСимволаКонечнойСтроки = Макс(СтрДлина(СтрокаТекста) - 1, ПервыйСимвол);
		
		ПараметрыЗадачи.УсловиеПоискаНайдено = Истина;
		
		Прервать;
		
	КонецЦикла; 		
				
	ПараметрыЗадачи.БлокПрограммногоКода = БлокПрограммногоКода(
		ТекстовыйДокумент, 
		ПараметрыЗадачи.УсловиеПоискаНайдено, 
		ПараметрыЗадачи.НомерНачальнойСтроки, 
		ПараметрыЗадачи.НомерКонечнойСтроки);
			
КонецПроцедуры

#КонецОбласти