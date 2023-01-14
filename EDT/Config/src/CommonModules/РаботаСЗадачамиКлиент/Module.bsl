#Область ПрограммныйИнтерфейс

// Открывает во внешнем редакторе файл.
//
// Параметры:
//  ФайлСсылка - СправочникСсылка.Файлы - файл.
//
Процедура ОткрытьФайл(ФайлСсылка) Экспорт
	
	ПолныйПутьФайла = РаботаСЗадачамиВызовСервера.ПолныйПутьФайла(ФайлСсылка);
	НачатьЗапускПриложения(Новый ОписаниеОповещения, ПолныйПутьФайла);
	
КонецПроцедуры   
  
// Анализ задач и выгрузка актуальных в файл.
//
// Параметры:
//  КодКонфигурации - Строка - Код, по которому будет осуществлен поиск конфигурации.
//
Процедура АвтоматическаяГенерацияФайловЗадач(КодКонфигурации) Экспорт

	Конфигурация = РаботаСЗадачамиВызовСервера.КонфигурацияПоКоду(КодКонфигурации);
	Если Конфигурация.Пустая() Тогда
		
		Текст = СтрШаблон(НСтр("ru='Не найдена конфигурация с кодом: %1'"), КодКонфигурации);
		ОбщегоНазначенияКлиент.СообщитьПользователю(Текст);
		
		Возврат;
	
	КонецЕсли;
	
	АктуализироватьЗадачи(Конфигурация);
	ВыгрузитьАктуальныеЗадачиДляСонара(Конфигурация);	

КонецПроцедуры  

// В рамках указанной конфигурации производится анализ актуальности каждой задачи.
// Результат фиксируется в регистре СведенияОПоискеЗадач.
//
// Параметры:
//  Конфигурация - СправочникСсылка.Конфигурации - Конфигурация, по которой выполняется актуализация задач.
//
Процедура АктуализироватьЗадачи(Конфигурация) Экспорт 
	
	ОбновитьСведенияПоЗадачам();
    РаботаСЗадачамиВызовСервера.ПеренестиЗадачиНаПроверку(Конфигурация);

КонецПроцедуры 

// Обновление состояния по одной или всем задачам, находящимся в статусе КВыполнению
//
// Параметры:
//  Задача - СправочникСсылка.Задачи - задача, для которой осуществляется обновление.
//         - Неопределено - Обновление всех задач.
//
Процедура ОбновитьСведенияПоЗадачам(Задача = Неопределено) Экспорт
	
	ЗадачиДляПоискаВИсходномКоде = РаботаСЗадачамиВызовСервера.ЗадачиДляПоискаВИсходномКоде(Задача);
	
	РезультатПоиска = Новый Соответствие;
	
	Для каждого ЗадачаДляПоиска Из ЗадачиДляПоискаВИсходномКоде Цикл
	
		ПараметрыЗадачи = ПоискЗадачВИсходномКодеКлиент.ПараметрыЗадачиВИсходныхФайлах(ЗадачаДляПоиска); 
		РезультатПоиска.Вставить(ЗадачаДляПоиска, ПараметрыЗадачи);
		
	КонецЦикла;
	
	РаботаСЗадачамиВызовСервера.ЗафиксироватьИзменениеРеквизитовЗадачВИсходномКоде(РезультатПоиска);

КонецПроцедуры

// Выгрузка всех актуальных задач в файл JSON, указанный в свойствах конфигурации.
//
// Параметры:
//  Конфигурация - СправочникСсылка.Конфигурации - Конфигурация, по которой выполняется выгрузка.
//
Процедура ВыгрузитьАктуальныеЗадачиДляСонара(Конфигурация) Экспорт
	
	ИмяФайлаРезультата = РаботаСЗадачамиВызовСервера.ИмяФайлаРезультата(Конфигурация);	
	ДанныеПоЗадачам  = РаботаСЗадачамиВызовСервера.ДанныеПоЗадачамДляВыгрузки(Конфигурация);
	
	Запись = Новый ЗаписьJSON;
	Запись.ПроверятьСтруктуру = Ложь;
	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON();
	Запись.ОткрытьФайл(ИмяФайлаРезультата, , , ПараметрыЗаписи);
	
	Запись.ЗаписатьНачалоОбъекта(); // Корень
	
	Запись.ЗаписатьИмяСвойства("date");
	Запись.ЗаписатьЗначение(Формат(ТекущаяДата(), "ДФ='yyyy-MM-dd hh:mm:ss'"));
	Запись.ЗаписатьИмяСвойства("fileinfos");
	
	Запись.ЗаписатьНачалоМассива(); // fileinfos	
	
	Для каждого КлючИЗначение Из ДанныеПоЗадачам Цикл
	
		Запись.ЗаписатьНачалоОбъекта(); // file
		
		Запись.ЗаписатьИмяСвойства("path");
		
		КаталогРепозитория = РаботаСЗадачамиПовтИсп.КаталогРепозиторияКонфигурацииОбратныеСлеши(Конфигурация);
		ПутьКФайлу = "file:///" + КаталогРепозитория + КлючИЗначение.Ключ;
		Запись.ЗаписатьЗначение(ПутьКФайлу);
		
		Запись.ЗаписатьИмяСвойства("diagnostics");
		Запись.ЗаписатьНачалоМассива(); // diagnostics
		
		ВыгрузитьОшибкиПоФайлу(КлючИЗначение.Значение, Запись); 
		
		Запись.ЗаписатьКонецМассива(); // diagnostics
		Запись.ЗаписатьКонецОбъекта(); // file
		
	КонецЦикла;
	
	Запись.ЗаписатьКонецМассива(); // fileinfos
	Запись.ЗаписатьКонецОбъекта(); // корень  
	
	Запись.Закрыть();
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыгрузитьОшибкиПоФайлу(ВсеОшибкиФайла, Запись)
	
	Для каждого ОшибкаВФайле Из ВсеОшибкиФайла Цикл
		
		Запись.ЗаписатьНачалоОбъекта(); // item diagnostics
		Запись.ЗаписатьИмяСвойства("range");
		Запись.ЗаписатьНачалоОбъекта(); // range
		
		Запись.ЗаписатьИмяСвойства("start");
		Запись.ЗаписатьНачалоОбъекта();
		Запись.ЗаписатьИмяСвойства("line");
		Запись.ЗаписатьЗначение(ОшибкаВФайле.НомерНачальнойСтроки - 1);
		Запись.ЗаписатьИмяСвойства("character");
		Запись.ЗаписатьЗначение(ОшибкаВФайле.НомерСимволаНачальнойСтроки);
		Запись.ЗаписатьКонецОбъекта();
		
		Запись.ЗаписатьИмяСвойства("end");
		Запись.ЗаписатьНачалоОбъекта();
		Запись.ЗаписатьИмяСвойства("line");
		Запись.ЗаписатьЗначение(ОшибкаВФайле.НомерКонечнойСтроки - 1);
		Запись.ЗаписатьИмяСвойства("character");
		Запись.ЗаписатьЗначение(ОшибкаВФайле.НомерСимволаКонечнойСтроки); 
		Запись.ЗаписатьКонецОбъекта();
		
		Запись.ЗаписатьКонецОбъекта(); // range
		
		// severity
		Запись.ЗаписатьИмяСвойства("severity");
		Запись.ЗаписатьЗначение("Error");
		
		// code
		Запись.ЗаписатьИмяСвойства("code");
		Запись.ЗаписатьЗначение("CodeReview");
		
		// source
		Запись.ЗаписатьИмяСвойства("source");
		Запись.ЗаписатьЗначение("CodeReview");
		
		// message
		Запись.ЗаписатьИмяСвойства("message");
		Запись.ЗаписатьЗначение(ОшибкаВФайле.ЗадачаОписание);
		
		// relatedInformation
		Запись.ЗаписатьИмяСвойства("relatedInformation");
		Запись.ЗаписатьЗначение(Неопределено);
		Запись.ЗаписатьКонецОбъекта(); // item diagnostics
		
	КонецЦикла;	

КонецПроцедуры  

#КонецОбласти