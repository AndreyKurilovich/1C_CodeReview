///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ОповещениеПользователя

Процедура СообщитьПользователю(
		Знач ТекстСообщенияПользователю,
		Знач КлючДанных,
		Знач Поле,
		Знач ПутьКДанным = "",
		Отказ = Ложь,
		ЭтоОбъект = Ложь) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	Если ЭтоОбъект Тогда
		Сообщение.УстановитьДанные(КлючДанных);
	Иначе
		Сообщение.КлючДанных = КлючДанных;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
	
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ДанныеВБазе

#Область ПредопределенныйЭлемент

Функция ИспользоватьСтандартнуюФункциюПолученияПредопределенного(ПолноеИмяПредопределенного) Экспорт
	
	// Используется стандартная функция платформы для получения:
	//  - пустых ссылок; 
	//  - значений перечислений;
	//  - точек маршрута бизнес-процессов.
	
	Возврат ".ПУСТАЯССЫЛКА" = ВРег(Прав(ПолноеИмяПредопределенного, 13))
		Или "ПЕРЕЧИСЛЕНИЕ." = ВРег(Лев(ПолноеИмяПредопределенного, 13))
		Или "БИЗНЕСПРОЦЕСС." = ВРег(Лев(ПолноеИмяПредопределенного, 14));
	
КонецФункции

Функция ИмяПредопределенногоПоПолям(ПолноеИмяПредопределенного) Экспорт
	
	ЧастиПолногоИмени = СтрРазделить(ПолноеИмяПредопределенного, ".");
	Если ЧастиПолногоИмени.Количество() <> 3 Тогда 
		ВызватьИсключение ТекстОшибкиПредопределенноеЗначениеНеНайдено(ПолноеИмяПредопределенного);
	КонецЕсли;
	
	ПолноеИмяОбъектаМетаданных = ВРег(ЧастиПолногоИмени[0] + "." + ЧастиПолногоИмени[1]);
	ИмяПредопределенного = ЧастиПолногоИмени[2];
	
	Результат = Новый Структура;
	Результат.Вставить("ПолноеИмяОбъектаМетаданных", ПолноеИмяОбъектаМетаданных);
	Результат.Вставить("ИмяПредопределенного", ИмяПредопределенного);
	
	Возврат Результат;
	
КонецФункции

Функция ПредопределенныйЭлемент(ПолноеИмяПредопределенного, ПоляПредопределенного, ПредопределенныеЗначения) Экспорт
	
	// Если ошибка в имени метаданных.
	Если ПредопределенныеЗначения = Неопределено Тогда 
		ВызватьИсключение ТекстОшибкиПредопределенноеЗначениеНеНайдено(ПолноеИмяПредопределенного);
	КонецЕсли;
	
	// Получение результата из кэша.
	Результат = ПредопределенныеЗначения.Получить(ПоляПредопределенного.ИмяПредопределенного);
	
	// Если предопределенного нет в метаданных.
	Если Результат = Неопределено Тогда 
		ВызватьИсключение ТекстОшибкиПредопределенноеЗначениеНеНайдено(ПолноеИмяПредопределенного);
	КонецЕсли;
	
	// Если предопределенный есть в метаданных, но не создан в ИБ.
	Если Результат = Null Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ТекстОшибкиПредопределенноеЗначениеНеНайдено(ПолноеИмяПредопределенного) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Предопределенное значение ""%1"" не существует.'"), ПолноеИмяПредопределенного);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти
