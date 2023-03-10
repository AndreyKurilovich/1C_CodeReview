#Область ПрограммныйИнтерфейс

// Метод формирует каталог репозитория, заменяя слэши на обратные.
//
// Параметры:
//  Конфигурация - СправочникСсылка.Конфигурации - Конфигурация.
//
// Возвращаемое значение:
//  Строка - полный путь к каталогу
//
Функция КаталогРепозиторияКонфигурацииОбратныеСлеши(Конфигурация) Экспорт 

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Конфигурации.КаталогРепозитория КАК КаталогРепозитория
		|ИЗ
		|	Справочник.Конфигурации КАК Конфигурации
		|ГДЕ
		|	Конфигурации.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Конфигурация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
    КаталогРепозитория = Выборка.КаталогРепозитория;
	
	Возврат РаботаСЗадачами.ЗаменитьСлэшыНаОбратные(КаталогРепозитория);

КонецФункции

#КонецОбласти