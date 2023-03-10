///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОповещениеПользователя

// Формирует путь к заданной строке НомерСтроки и колонке ИмяРеквизита 
// табличной части ИмяТабличнойЧасти для выдачи сообщений в форме.
// Для совместного использования с процедурой СообщитьПользователю
// (для передачи в параметры Поле или ПутьКДанным). 
//
// Параметры:
//  ИмяТабличнойЧасти - Строка - имя табличной части.
//  НомерСтроки - Число - номер строки табличной части.
//  ИмяРеквизита - Строка - имя реквизита.
//
// Возвращаемое значение:
//  Строка - путь к ячейке таблицы.
//
Функция ПутьКТабличнойЧасти(
		Знач ИмяТабличнойЧасти,
		Знач НомерСтроки, 
		Знач ИмяРеквизита) Экспорт
	
	Возврат ИмяТабличнойЧасти + "[" + Формат(НомерСтроки - 1, "ЧН=0; ЧГ=0") + "]." + ИмяРеквизита;
	
КонецФункции

#КонецОбласти

#Область Данные

// Дополняет таблицу значений - приемник данными из таблицы значений - источника.
// Типы ТаблицаЗначений, ДеревоЗначений, ТабличнаяЧасть не доступны на клиенте.
//
// Параметры:
//  ТаблицаИсточник - ТаблицаЗначений
//                  - ДеревоЗначений
//                  - ТабличнаяЧасть
//                  - ДанныеФормыКоллекция - таблица, из которой будут
//                    браться строки для заполнения;
//  ТаблицаПриемник - ТаблицаЗначений
//                  - ДеревоЗначений
//                  - ТабличнаяЧасть
//                  - ДанныеФормыКоллекция - таблица, в которую будут
//                    добавлены строки из таблицы-источника.
//
Процедура ДополнитьТаблицу(ТаблицаИсточник, ТаблицаПриемник) Экспорт
	
	Для Каждого СтрокаТаблицыИсточник Из ТаблицаИсточник Цикл
		
		ЗаполнитьЗначенияСвойств(ТаблицаПриемник.Добавить(), СтрокаТаблицыИсточник);
		
	КонецЦикла;
	
КонецПроцедуры

// Дополняет таблицу значений Таблица значениями из массива Массив.
//
// Параметры:
//  Таблица - ТаблицаЗначений - таблица, которую необходимо заполнить значениями из массива;
//  Массив  - Массив - массив значений для заполнения таблицы;
//  ИмяПоля - Строка - имя поля таблицы значений, в которое необходимо загрузить значения из массива.
// 
Процедура ДополнитьТаблицуИзМассива(Таблица, Массив, ИмяПоля) Экспорт

	Для каждого Значение Из Массив Цикл
		
		Таблица.Добавить()[ИмяПоля] = Значение;
		
	КонецЦикла;
	
КонецПроцедуры

// Дополняет массив МассивПриемник значениями из массива МассивИсточник.
//
// Параметры:
//  МассивПриемник - Массив - массив, в который необходимо добавить значения.
//  МассивИсточник - Массив - массив значений для заполнения.
//  ТолькоУникальныеЗначения - Булево - если истина, то в массив будут включены только уникальные значения.
//
Процедура ДополнитьМассив(МассивПриемник, МассивИсточник, ТолькоУникальныеЗначения = Ложь) Экспорт
	
	Если ТолькоУникальныеЗначения Тогда
		
		УникальныеЗначения = Новый Соответствие;
		
		Для Каждого Значение Из МассивПриемник Цикл
			УникальныеЗначения.Вставить(Значение, Истина);
		КонецЦикла;
		
		Для Каждого Значение Из МассивИсточник Цикл
			Если УникальныеЗначения[Значение] = Неопределено Тогда
				МассивПриемник.Добавить(Значение);
				УникальныеЗначения.Вставить(Значение, Истина);
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		Для Каждого Значение Из МассивИсточник Цикл
			МассивПриемник.Добавить(Значение);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Дополняет структуру значениями из другой структуры.
//
// Параметры:
//   Приемник - Структура - коллекция, в которую будут добавляться новые значения.
//   Источник - Структура - коллекция, из которой будут считываться пары Ключ и Значение для заполнения.
//   Заменять - Булево
//            - Неопределено - что делать в местах пересечения ключей источника и приемника:
//                             Истина - заменять значения приемника (самый быстрый способ),
//                             Ложь   - не заменять значения приемника (пропускать),
//                             Неопределено - значение по умолчанию. Бросать исключение.
//
Процедура ДополнитьСтруктуру(Приемник, Источник, Заменять = Неопределено) Экспорт
	
	Для Каждого Элемент Из Источник Цикл
		Если Заменять <> Истина И Приемник.Свойство(Элемент.Ключ) Тогда
			Если Заменять = Ложь Тогда
				Продолжить;
			Иначе
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Пересечение ключей источника и приемника: ""%1"".'"), Элемент.Ключ);
			КонецЕсли
		КонецЕсли;
		Приемник.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
КонецПроцедуры

// Дополняет соответствие значениями из другого соответствия.
//
// Параметры:
//   Приемник - Соответствие - коллекция, в которую будут добавляться новые значения.
//   Источник - Соответствие из КлючИЗначение - коллекция, из которой будут считываться пары Ключ и Значение для заполнения.
//   Заменять - Булево
//            - Неопределено - что делать в местах пересечения ключей источника и приемника:
//                             Истина - заменять значения приемника (самый быстрый способ),
//                             Ложь   - не заменять значения приемника (пропускать),
//                             Неопределено - значение по умолчанию. Бросать исключение.
//
Процедура ДополнитьСоответствие(Приемник, Источник, Заменять = Неопределено) Экспорт
	
	Для Каждого Элемент Из Источник Цикл
		Если Заменять <> Истина И Приемник[Элемент.Ключ] <> Неопределено Тогда
			Если Заменять = Ложь Тогда
				Продолжить;
			Иначе
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Пересечение ключей источника и приемника: ""%1"".'"), Элемент.Ключ);
			КонецЕсли
		КонецЕсли;
		Приемник.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
КонецПроцедуры

// Проверяет наличие реквизита или свойства у произвольного объекта без обращения к метаданным.
//
// Параметры:
//  Объект       - Произвольный - объект, у которого нужно проверить наличие реквизита или свойства;
//  ИмяРеквизита - Строка       - имя реквизита или свойства.
//
// Возвращаемое значение:
//  Булево - Истина, если есть.
//
Функция ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

// Удаляет все вхождения переданного значения из массива.
//
// Параметры:
//  Массив - Массив - массив, из которого необходимо удалить значение;
//  Значение - Произвольный - удаляемое значение из массива.
// 
Процедура УдалитьВсеВхожденияЗначенияИзМассива(Массив, Значение) Экспорт
	
	КоличествоЭлементовКоллекции = Массив.Количество();
	
	Для ОбратныйИндекс = 1 По КоличествоЭлементовКоллекции Цикл
		
		Индекс = КоличествоЭлементовКоллекции - ОбратныйИндекс;
		
		Если Массив[Индекс] = Значение Тогда
			
			Массив.Удалить(Индекс);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Удаляет все вхождения значений указанного типа.
//
// Параметры:
//  Массив - Массив - массив, из которого необходимо удалить значения;
//  Тип - Тип - тип значений, которые подлежат удалению из массива.
// 
Процедура УдалитьВсеВхожденияТипаИзМассива(Массив, Тип) Экспорт
	
	КоличествоЭлементовКоллекции = Массив.Количество();
	
	Для ОбратныйИндекс = 1 По КоличествоЭлементовКоллекции Цикл
		
		Индекс = КоличествоЭлементовКоллекции - ОбратныйИндекс;
		
		Если ТипЗнч(Массив[Индекс]) = Тип Тогда
			
			Массив.Удалить(Индекс);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Удаляет одно значение из массива.
//
// Параметры:
//  Массив - Массив - массив, из которого необходимо удалить значение;
//  Значение - Массив - удаляемое значение из массива.
// 
Процедура УдалитьЗначениеИзМассива(Массив, Значение) Экспорт
	
	Индекс = Массив.Найти(Значение);
	Если Индекс <> Неопределено Тогда
		Массив.Удалить(Индекс);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает копию исходного массива с уникальными значениями.
//
// Параметры:
//  Массив - Массив - массив произвольных значений.
//
// Возвращаемое значение:
//  Массив - массив уникальных элементов.
//
Функция СвернутьМассив(Знач Массив) Экспорт
	Результат = Новый Массив;
	ДополнитьМассив(Результат, Массив, Истина);
	Возврат Результат;
КонецФункции

// Возвращает разность массивов. Разностью двух массивов является массив, содержащий
// все элементы первого массива, не существующие во втором массиве.
//
// Параметры:
//  Массив - Массив - массив элементов, из которого необходимо выполнить вычитание;
//  МассивВычитания - Массив - массив элементов, который будет вычитаться.
// 
// Возвращаемое значение:
//  Массив - разностью двух массивов.
//
// Пример:
//	//А = [1, 3, 5, 7];
//	//В = [3, 7, 9];
//	Результат = ОбщегоНазначенияКлиентСервер.РазностьМассивов(А, В);
//	//Результат = [1, 5];
//
Функция РазностьМассивов(Знач Массив, Знач МассивВычитания) Экспорт
	
	Результат = Новый Массив;
	Для Каждого Элемент Из Массив Цикл
		Если МассивВычитания.Найти(Элемент) = Неопределено Тогда
			Результат.Добавить(Элемент);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Создает массив и помещает в него переданное значение.
//
// Параметры:
//  Значение - Произвольный - любое значение.
//
// Возвращаемое значение:
//  Массив - массив из одного элемента.
//
Функция ЗначениеВМассиве(Значение) Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Значение);
	
	Возврат Массив;
	
КонецФункции

// Получает строку, содержащую ключи структуры, разделенные символом разделителя.
//
// Параметры:
//  Структура - Структура - структура, ключи которой преобразуются в строку.
//  Разделитель - Строка - разделитель, который вставляется в строку между ключами структуры.
//
// Возвращаемое значение:
//  Строка - строка, содержащая ключи структуры разделенные разделителем.
//
Функция КлючиСтруктурыВСтроку(Структура, Разделитель = ",") Экспорт
	
	Результат = "";
	
	Для Каждого Элемент Из Структура Цикл
		СимволРазделителя = ?(ПустаяСтрока(Результат), "", Разделитель);
		Результат = Результат + СимволРазделителя + Элемент.Ключ;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает значение свойства структуры.
//
// Параметры:
//   Структура - Структура
//             - ФиксированнаяСтруктура - объект, из которого необходимо прочитать значение ключа.
//   Ключ - Строка - имя свойства структуры, для которого необходимо прочитать значение.
//   ЗначениеПоУмолчанию - Произвольный - возвращается когда в структуре нет значения по указанному
//                                        ключу.
//       Для скорости рекомендуется передавать только быстро вычисляемые значения (например примитивные типы),
//       а инициализацию более тяжелых значений выполнять после проверки полученного значения (только если это
//       требуется).
//
// Возвращаемое значение:
//   Произвольный - значение свойства структуры. ЗначениеПоУмолчанию если в структуре нет указанного свойства.
//
Функция СвойствоСтруктуры(Структура, Ключ, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Если Структура = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Результат = ЗначениеПоУмолчанию;
	Если Структура.Свойство(Ключ, Результат) Тогда
		Возврат Результат;
	Иначе
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
КонецФункции

// Возвращает пустой уникальный идентификатор.
//
// Возвращаемое значение:
//  УникальныйИдентификатор - 00000000-0000-0000-0000-000000000000
//
Функция ПустойУникальныйИдентификатор() Экспорт
	
	Возврат Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	
КонецФункции

#КонецОбласти

#Область Формы

// Выполняет поиск элемента отбора в коллекции по заданному представлению.
//
// Параметры:
//  КоллекцияЭлементов - КоллекцияЭлементовОтбораКомпоновкиДанных - контейнер с элементами и группами отбора,
//                                                                  например, Список.Отбор.Элементы или группа в отборе.
//  Представление - Строка - представление группы.
// 
// Возвращаемое значение:
//  ЭлементОтбораКомпоновкиДанных - элемент отбора.
//
Функция НайтиЭлементОтбораПоПредставлению(КоллекцияЭлементов, Представление) Экспорт
	
	ВозвращаемоеЗначение = Неопределено;
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		Если ЭлементОтбора.Представление = Представление Тогда
			ВозвращаемоеЗначение = ЭлементОтбора;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение
	
КонецФункции

// Устанавливает свойство ИмяСвойства элемента формы с именем ИмяЭлемента в значение Значение.
// Применяется в тех случаях, когда элемента формы может не быть на форме из-за отсутствия прав у пользователя
// на объект, реквизит объекта или команду.
//
// Параметры:
//  ЭлементыФормы - ВсеЭлементыФормы
//                - ЭлементыФормы - коллекция элементов управляемой формы.
//  ИмяЭлемента   - Строка       - имя элемента формы.
//  ИмяСвойства   - Строка       - имя устанавливаемого свойства элемента формы.
//  Значение      - Произвольный - новое значение элемента.
// 
Процедура УстановитьСвойствоЭлементаФормы(ЭлементыФормы, ИмяЭлемента, ИмяСвойства, Значение) Экспорт
	
	ЭлементФормы = ЭлементыФормы.Найти(ИмяЭлемента);
	Если ЭлементФормы <> Неопределено И ЭлементФормы[ИмяСвойства] <> Значение Тогда
		ЭлементФормы[ИмяСвойства] = Значение;
	КонецЕсли;
	
КонецПроцедуры 

// Возвращает значение свойства ИмяСвойства элемента формы с именем ИмяЭлемента.
// Применяется в тех случаях, когда элемент формы может не быть на форме из-за отсутствия прав у пользователя
// на объект, реквизит объекта или команду.
//
// Параметры:
//  ЭлементыФормы - ВсеЭлементыФормы
//                - ЭлементыФормы - коллекция элементов управляемой формы.
//  ИмяЭлемента   - Строка       - имя элемента формы.
//  ИмяСвойства   - Строка       - имя свойства элемента формы.
// 
// Возвращаемое значение:
//   Произвольный - значение свойства ИмяСвойства элемента формы ИмяЭлемента.
// 
Функция ЗначениеСвойстваЭлементаФормы(ЭлементыФормы, ИмяЭлемента, ИмяСвойства) Экспорт
	
	ЭлементФормы = ЭлементыФормы.Найти(ИмяЭлемента);
	Возврат ?(ЭлементФормы <> Неопределено, ЭлементФормы[ИмяСвойства], Неопределено);
	
КонецФункции 

// Получает картинку для вывода на странице с комментарием в зависимости
// от наличия текста в комментарии.
//
// Параметры:
//  Комментарий  - Строка - текст комментария.
//
// Возвращаемое значение:
//  Картинка - картинка, которая должна отображаться на странице с комментарием.
//
Функция КартинкаКомментария(Комментарий) Экспорт

	Если НЕ ПустаяСтрока(Комментарий) Тогда
		Картинка = БиблиотекаКартинок.Комментарий;
	Иначе
		Картинка = Новый Картинка;
	КонецЕсли;
	
	Возврат Картинка;
	
КонецФункции

#КонецОбласти

#Область РаботаСФайлами

// Добавляет к переданному пути каталога конечный символ-разделитель, если он отсутствует.
//
// Параметры:
//  ПутьКаталога - Строка - путь к каталогу.
//
// Возвращаемое значение:
//  Строка - путь к каталогу с конечным символом-разделителем.
//
// Пример:
//  Результат = ДобавитьКонечныйРазделительПути("C:\Мой каталог"); // возвращает "C:\Мой каталог\".
//  Результат = ДобавитьКонечныйРазделительПути("C:\Мой каталог\"); // возвращает "C:\Мой каталог\".
//  Результат = ДобавитьКонечныйРазделительПути("%APPDATA%"); // возвращает "%APPDATA%\".
//
Функция ДобавитьКонечныйРазделительПути(Знач ПутьКаталога) Экспорт
	
	Если ПустаяСтрока(ПутьКаталога) Тогда
		Возврат ПутьКаталога;
	КонецЕсли;
	
	ДобавляемыйСимвол = ПолучитьРазделительПути();
	
	Если СтрЗаканчиваетсяНа(ПутьКаталога, ДобавляемыйСимвол) Тогда
		Возврат ПутьКаталога;
	Иначе 
		Возврат ПутьКаталога + ДобавляемыйСимвол;
	КонецЕсли;
	
КонецФункции

// Составляет полное имя файла из имени каталога и имени файла.
//
// Параметры:
//  ИмяКаталога  - Строка - путь к каталогу файла на диске.
//  ИмяФайла     - Строка - имя файла, без имени каталога.
//
// Возвращаемое значение:
//   Строка - полное имя файла с учетом каталога.
//
Функция ПолучитьПолноеИмяФайла(Знач ИмяКаталога, Знач ИмяФайла) Экспорт

	Если НЕ ПустаяСтрока(ИмяФайла) Тогда
		
		Слэш = "";
		Если (Прав(ИмяКаталога, 1) <> "\") И (Прав(ИмяКаталога, 1) <> "/") Тогда
			Слэш = ?(СтрНайти(ИмяКаталога, "\") = 0, "/", "\");
		КонецЕсли;
		
		Возврат ИмяКаталога + Слэш + ИмяФайла;
		
	Иначе
		
		Возврат ИмяКаталога;
		
	КонецЕсли;

КонецФункции

// Раскладывает полное имя файла на составляющие.
//
// Параметры:
//  ПолноеИмяФайла - Строка - полный путь к файлу или каталогу.
//  ЭтоКаталог - Булево - признак того, что передано имя каталога.
//
// Возвращаемое значение:
//   Структура - имя файла, разложенное на составные части(аналогично свойствам объекта Файл):
//     ПолноеИмя - содержит полный путь к файлу, т.е. полностью соответствует входному параметру ПолноеИмяФайла.
//     Путь - содержит путь к каталогу, в котором лежит файл.
//     Имя - содержит имя файла с расширением, без пути к файлу.
//     Расширение - содержит расширение файла.
//     ИмяБезРасширения - содержит имя файла без расширения и без пути к файлу.
// 
// Пример:
//  ПолноеИмяФайла = "c:\temp\test.txt";
//  ЧастиИмениФайла = РазложитьПолноеИмяФайла(ПолноеИмяФайла);
//  
//  В результате структура полей будет заполнена следующим образом:
//    ПолноеИмя: "c:\temp\test.txt",
//    Путь: "c:\temp\",
//    Имя: "test.txt",
//    Расширение: ".txt",
//    ИмяБезРасширения: "test".
//
Функция РазложитьПолноеИмяФайла(Знач ПолноеИмяФайла, ЭтоКаталог = Ложь) Экспорт
	
	СтруктураИмениФайла = Новый Структура("ПолноеИмя,Путь,Имя,Расширение,ИмяБезРасширения");
	ЗаполнитьЗначенияСвойств(СтруктураИмениФайла, Новый Файл(ПолноеИмяФайла));
	
	Возврат СтруктураИмениФайла;
	
КонецФункции

// Функция раскладывает строку в массив строк, используя "./\" как разделитель.
//
// Параметры:
//  Строка - Строка - исходная строка.
//
// Возвращаемое значение:
//  Массив - коллекция фрагментов строки.
//
Функция РазложитьСтрокуПоТочкамИСлэшам(Знач Строка) Экспорт
	
	Перем ТекущаяПозиция;
	
	Фрагменты = Новый Массив;
	
	НачальнаяПозиция = 1;
	
	Для ТекущаяПозиция = 1 По СтрДлина(Строка) Цикл
		ТекущийСимвол = Сред(Строка, ТекущаяПозиция, 1);
		Если ТекущийСимвол = "." Или ТекущийСимвол = "/" Или ТекущийСимвол = "\" Тогда
			ТекущийФрагмент = Сред(Строка, НачальнаяПозиция, ТекущаяПозиция - НачальнаяПозиция);
			НачальнаяПозиция = ТекущаяПозиция + 1;
			Фрагменты.Добавить(ТекущийФрагмент);
		КонецЕсли;
	КонецЦикла;
	
	Если НачальнаяПозиция <> ТекущаяПозиция Тогда
		ТекущийФрагмент = Сред(Строка, НачальнаяПозиция, ТекущаяПозиция - НачальнаяПозиция);
		Фрагменты.Добавить(ТекущийФрагмент);
	КонецЕсли;
	
	Возврат Фрагменты;
	
КонецФункции

// Выделяет из имени файла его расширение (набор символов после последней точки).
//
// Параметры:
//  ИмяФайла - Строка - имя файла с именем каталога или без.
//
// Возвращаемое значение:
//   Строка - расширение файла.
//
Функция ПолучитьРасширениеИмениФайла(Знач ИмяФайла) Экспорт
	
	РасширениеФайла = "";
	МассивСтрок = СтрРазделить(ИмяФайла, ".", Ложь);
	Если МассивСтрок.Количество() > 1 Тогда
		РасширениеФайла = МассивСтрок[МассивСтрок.Количество() - 1];
	КонецЕсли;
	Возврат РасширениеФайла;
	
КонецФункции

// Преобразует расширение файла в нижний регистр без точки.
//
// Параметры:
//  Расширение - Строка - расширение для преобразования.
//
// Возвращаемое значение:
//  Строка - преобразованное расширение.
//
Функция РасширениеБезТочки(Знач Расширение) Экспорт
	
	Расширение = НРег(СокрЛП(Расширение));
	
	Если Сред(Расширение, 1, 1) = "." Тогда
		Расширение = Сред(Расширение, 2);
	КонецЕсли;
	
	Возврат Расширение;
	
КонецФункции

// Возвращает имя файла с расширением.
// Если расширение пустое, тогда точка не добавляется.
//
// Параметры:
//  ИмяБезРасширения - Строка - имя файла без расширения.
//  Расширение       - Строка - расширение.
//
// Возвращаемое значение:
//  Строка - имя файла с расширением.
//
Функция ПолучитьИмяСРасширением(ИмяБезРасширения, Расширение) Экспорт
	
	Если ПустаяСтрока(Расширение) Тогда
		Возврат ИмяБезРасширения;
	КонецЕсли;
	
	Возврат ИмяБезРасширения + "." + Расширение;
	
КонецФункции

// Возвращает строку недопустимых символов.
// Согласно http://en.wikipedia.org/wiki/Filename - в разделе "Reserved characters and words".
// Возвращаемое значение:
//   Строка - строка недопустимых символов.
//
Функция ПолучитьНедопустимыеСимволыВИмениФайла() Экспорт

	НедопустимыеСимволы = """/\[]:;|=?*<>";
	НедопустимыеСимволы = НедопустимыеСимволы + Символы.Таб + Символы.ПС;
	Возврат НедопустимыеСимволы;

КонецФункции

// Проверяет наличие недопустимых символов в имени файла.
//
// Параметры:
//  ИмяФайла  - Строка - имя файла.
//
// Возвращаемое значение:
//   Массив   - массив обнаруженных в имени файла недопустимых символов.
//              Если недопустимых символов не обнаружено - возвращается пустой массив.
//
Функция НайтиНедопустимыеСимволыВИмениФайла(ИмяФайла) Экспорт

	НедопустимыеСимволы = ПолучитьНедопустимыеСимволыВИмениФайла();
	
	МассивНайденныхНедопустимыхСимволов = Новый Массив;
	
	Для ПозицияСимвола = 1 По СтрДлина(НедопустимыеСимволы) Цикл
		ПроверяемыйСимвол = Сред(НедопустимыеСимволы,ПозицияСимвола,1);
		Если СтрНайти(ИмяФайла,ПроверяемыйСимвол) <> 0 Тогда
			МассивНайденныхНедопустимыхСимволов.Добавить(ПроверяемыйСимвол);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивНайденныхНедопустимыхСимволов;

КонецФункции

// Заменяет недопустимые символы в имени файла.
//
// Параметры:
//  ИмяФайла     - Строка - исходное имя файла.
//  НаЧтоМенять  - Строка - строка, на которую необходимо заменить недопустимые символы.
//
// Возвращаемое значение:
//   Строка - преобразованное имя файла.
//
Функция ЗаменитьНедопустимыеСимволыВИмениФайла(Знач ИмяФайла, НаЧтоМенять = " ") Экспорт
	
	Возврат СокрЛП(СтрСоединить(СтрРазделить(ИмяФайла, ПолучитьНедопустимыеСимволыВИмениФайла(), Истина), НаЧтоМенять));

КонецФункции

#КонецОбласти

#Область ПроверкаТипаЗначения

// Возвращает признак того, что переданное значение является, либо не является, числом.
//
// Параметры:
//  ПроверяемоеЗначение - Строка - значение, которое проверяется на соответствие числу.
//
// Возвращаемое значение:
//   Булево - признак того, что переданное значение является, либо не является, числом.
//
Функция ЭтоЧисло(Знач ПроверяемоеЗначение) Экспорт 
	
	Если ПроверяемоеЗначение = "0" Тогда
		Возврат Истина;
	КонецЕсли;
	
	ОписаниеЧисла = Новый ОписаниеТипов("Число");
	
	Возврат ОписаниеЧисла.ПривестиЗначение(ПроверяемоеЗначение) <> 0;
	
КонецФункции

#КонецОбласти

#Область ПриведениеЗначения

// Приводит строковое значение к дате.
//
// Параметры:
//  Значение - Строка - строковое значение, которое приводится к дате.
//
// Возвращаемое значение:
//   Дата - приведенное значение.
//
Функция СтрокаВДату(Знач Значение) Экспорт 
	
	ПустаяДата = Дата(1, 1, 1);
	
	Если Не ЗначениеЗаполнено(Значение) Тогда 
		Возврат ПустаяДата;
	КонецЕсли;
	
	ОписаниеДаты = Новый ОписаниеТипов("Дата");
	Дата = ОписаниеДаты.ПривестиЗначение(Значение);
	
	Если ТипЗнч(Дата) = Тип("Дата")
		И ЗначениеЗаполнено(Дата) Тогда 
		
		Возврат Дата;
	КонецЕсли;
	
	#Область ПодготовкаЧастейДаты
	
	КоличествоСимволов = СтрДлина(Значение);
	
	Если КоличествоСимволов > 25 Тогда 
		Возврат ПустаяДата;
	КонецЕсли;
	
	ЧастиЗначения = Новый Массив;
	ЧастьЗначения = "";
	
	Для НомерСимвола = 1 По КоличествоСимволов Цикл 
		
		Символ = Сред(Значение, НомерСимвола, 1);
		
		Если ЭтоЧисло(Символ) Тогда 
			
			ЧастьЗначения = ЧастьЗначения + Символ;
			
		Иначе
			
			Если Не ПустаяСтрока(ЧастьЗначения) Тогда 
				ЧастиЗначения.Добавить(ЧастьЗначения);
			КонецЕсли;
			
			ЧастьЗначения = "";
			
		КонецЕсли;
		
		Если НомерСимвола = КоличествоСимволов
			И Не ПустаяСтрока(ЧастьЗначения) Тогда 
			
			ЧастиЗначения.Добавить(ЧастьЗначения);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЧастиЗначения.Количество() < 3 Тогда 
		Возврат ПустаяДата;
	КонецЕсли;
	
	Если ЧастиЗначения.Количество() < 4 Тогда 
		ЧастиЗначения.Добавить("00");
	КонецЕсли;
	
	Если ЧастиЗначения.Количество() < 5 Тогда 
		ЧастиЗначения.Добавить("00");
	КонецЕсли;
	
	Если ЧастиЗначения.Количество() < 6 Тогда 
		ЧастиЗначения.Добавить("00");
	КонецЕсли;
	
	#КонецОбласти
	
	// Если формат ггггММддЧЧммсс:
	НормализованноеЗначение = ЧастиЗначения[2] + ЧастиЗначения[1] + ЧастиЗначения[0]
		+ ЧастиЗначения[3] + ЧастиЗначения[4] + ЧастиЗначения[5];
	
	Дата = ОписаниеДаты.ПривестиЗначение(НормализованноеЗначение);
	
	Если ТипЗнч(Дата) = Тип("Дата")
		И ЗначениеЗаполнено(Дата) Тогда 
		
		Возврат Дата;
	КонецЕсли;
	
	// Если формат ггггддММЧЧммсс
	НормализованноеЗначение = ЧастиЗначения[2] + ЧастиЗначения[0] + ЧастиЗначения[1]
		+ ЧастиЗначения[3] + ЧастиЗначения[4] + ЧастиЗначения[5];
	
	Дата = ОписаниеДаты.ПривестиЗначение(НормализованноеЗначение);
	
	Если ТипЗнч(Дата) = Тип("Дата")
		И ЗначениеЗаполнено(Дата) Тогда 
		
		Возврат Дата;
	КонецЕсли;
	
	Возврат ПустаяДата;
	
КонецФункции

// Формирует количество секунд в сутках.
//
//
// Возвращаемое значение:
//   Число - количество секунд.
//
Функция СекундВСутках() Экспорт
	
	СекундВМинуте 	= 60;
	МинутВЧасе 		= 60;
	ЧасовВСутках 	= 24;
	
	Возврат СекундВМинуте * МинутВЧасе * ЧасовВСутках ;
	
КонецФункции

#КонецОбласти

#КонецОбласти