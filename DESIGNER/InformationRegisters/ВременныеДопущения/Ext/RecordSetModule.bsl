
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	МинимальноеЗначениеКартинки = 2; 
	
	Для каждого Запись Из ЭтотОбъект Цикл
	
		Запись.Картинка = МинимальноеЗначениеКартинки;	
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли