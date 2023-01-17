
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьИнформациюПоАктуальностиЗадачи();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьЭлементовФормы();
	ТекущийЭлемент = Элементы.Файл;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьИнформациюПоАктуальностиЗадачи();

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_Задача");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент)
	
	Если Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗадач.Выполнено") 
		И Объект.ДатаЗавершения = Дата(1, 1, 1) Тогда

		Объект.ДатаЗавершения = ТекущаяДата();
		
	КонецЕсли;
	
	Если Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗадач.КВыполнению")  Тогда
		Объект.ДатаЗавершения = Дата(1, 1, 1);
	КонецЕсли;
	
	УстановитьВидимостьЭлементовФормы();

КонецПроцедуры

&НаКлиенте
Процедура ВариантУсловияПоискаПриИзменении(Элемент)
	
	ПоискПоСтрокам = ПредопределенноеЗначение("Перечисление.ВариантыУсловийПоиска.ПоследовательныйПоискПоСтрокам");
	
	Элементы.Условия.Доступность = Объект.ВариантУсловияПоиска = ПоискПоСтрокам;

КонецПроцедуры

&НаКлиенте
Процедура ТипЗадачиПриИзменении(Элемент)
	
	Если Объект.ТипЗадачи.Пустая() Тогда
		Возврат;
	КонецЕсли;

	РеквизитыТипаЗадачи = РеквизитыТипаЗадачи(Объект.ТипЗадачи);
	
	Если ПустаяСтрока(Объект.Описание) Тогда
		Объект.Описание = РеквизитыТипаЗадачи.Описание;	
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = РеквизитыТипаЗадачи.Наименование;	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУсловия

&НаКлиенте
Процедура УсловияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "УсловияУсловие" Тогда
		
		СтандартнаяОбработка = Ложь;
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеРедактированияУсловияПоиска", ЭтотОбъект);
		
		ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(
			ОписаниеОповещения, Элемент.ТекущиеДанные.Условие, НСтр("ru='Условие поиска'"));
		
	КонецЕсли;

КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОпределитьПараметрыВИсходномКоде(Команда)
	
	РаботаСЗадачамиКлиент.ОбновитьСведенияПоЗадачам(Объект.Ссылка);
	ОбновитьИнформациюПоАктуальностиЗадачи();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	РаботаСЗадачамиКлиент.ОткрытьФайл(Объект.Файл);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьВидимостьЭлементовФормы()
	
	Элементы.КачествоРешения.Доступность = Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗадач.Выполнено");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеРедактированияУсловияПоиска(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	Элементы.Условия.ТекущиеДанные.Условие = ВведенныйТекст;
	Модифицированность = Истина;

КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоАктуальностиЗадачи()
	
	УсловиеНайдено = УсловиеПоискаПоЗадачеНайдено();
	
	Если УсловиеНайдено Тогда
		Элементы.КартинкаАктуальностьЗадачи.Картинка = БиблиотекаКартинок.ОформлениеЗнакФлажок;
	Иначе
		Элементы.КартинкаАктуальностьЗадачи.Картинка = БиблиотекаКартинок.ОформлениеКрест;
	КонецЕсли;	

КонецПроцедуры

&НаСервере
Функция УсловиеПоискаПоЗадачеНайдено()
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СведенияОПоискеЗадачСрезПоследних.УсловиеПоискаНайдено КАК УсловиеПоискаНайдено
		|ИЗ
		|	РегистрСведений.СведенияОПоискеЗадач.СрезПоследних(, Задача = &Задача) КАК СведенияОПоискеЗадачСрезПоследних";
	
	Запрос.УстановитьПараметр("Задача", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		 УсловиеНайдено = Ложь;
	Иначе
		
		Выборка = РезультатЗапроса.Выбрать();	
		Выборка.Следующий();
		УсловиеНайдено = Выборка.УсловиеПоискаНайдено;
		
	КонецЕсли;
	
	Возврат УсловиеНайдено;
	
КонецФункции

&НаСервереБезКонтекста
Функция РеквизитыТипаЗадачи(ТипЗадачи)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТипыЗадач.Наименование КАК Наименование,
		|	ТипыЗадач.Описание КАК Описание
		|ИЗ
		|	Справочник.ТипыЗадач КАК ТипыЗадач
		|ГДЕ
		|	ТипыЗадач.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ТипЗадачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();	
	Выборка.Следующий();
	
	РеквизитыТипаЗадачи = Новый Структура("Наименование, Описание");
	ЗаполнитьЗначенияСвойств(РеквизитыТипаЗадачи, Выборка);
	
	Возврат  РеквизитыТипаЗадачи;
	
КонецФункции

#КонецОбласти