﻿#language: ru

@tree

Функционал: Тестирование рабочего стола

Как Разработчик я хочу
проверить корректность работы всех вариантов поиска в исходном коде 
чтобы эффективно выполнять код ревью

Контекст:
	Дано я подключаю TestClient "ЭтотКлиент" логин "Admin" пароль "1"
	И я закрываю все окна клиентского приложения
	
Сценарий: Подготовка данных

	И Я подготоваливаю данные справочника Конфигурации
	И Я подготоваливаю данные справочника Файлы
		
Сценарий: Проверка отображения исходного кода в найденной задаче
	
	И я меняю значение переключателя с именем 'ОтборСостоянияЗадач' на 'Актуально*' по шаблону
	И из выпадающего списка с именем "Конфигурация" я выбираю по строке 'Тестирование'
	И в таблице "Список" я нажимаю на кнопку с именем 'СписокНоваяЗадача'
	Тогда открылось окно 'Задача (создание)'
	И в поле с именем 'Наименование' я ввожу текст 'Тестирование работы рабочего стола'
	И из выпадающего списка с именем "Состояние" я выбираю по строке 'К выполнению'
	И в поле с именем 'Описание' я ввожу текст 'Проверка поиска \"С начала файла\"'
	И из выпадающего списка с именем "Конфигурация" я выбираю по строке 'Тестирование'
	И из выпадающего списка с именем "Файл" я выбираю по строке 'ObjectModule.bsl'
	И я нажимаю кнопку выбора у поля с именем "ВариантУсловияПоиска"
	И из выпадающего списка с именем "ВариантУсловияПоиска" я выбираю по строке 'Последовательный поиск по строкам'
	И в таблице "Условия" я нажимаю на кнопку с именем 'УсловияДобавить'
	И в таблице "Условия" из выпадающего списка с именем "УсловияВидПострочногоПоиска" я выбираю по строке 'С начала файла'
	И в таблице "Условия" из выпадающего списка с именем "УсловияВариантПоиска" я выбираю по строке 'Содержит'
	И в таблице "Условия" в поле с именем 'УсловияУсловие' я ввожу текст 'Процедура кл_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)'
	И в таблице "Условия" я завершаю редактирование строки
	И в таблице "Условия" я устанавливаю флаг с именем 'УсловияМеткаВКоде'
	И в таблице "Условия" я завершаю редактирование строки
	И я нажимаю на кнопку с именем 'ФормаЗаписать'
	И я нажимаю на кнопку с именем 'ФормаОпределитьПараметрыВИсходномКоде'
	И я нажимаю на кнопку с именем 'ФормаЗаписатьИЗакрыть'		
	И я жду закрытия окна 'Проверка поиска С начала файла (Задача)' в течение 20 секунд

	Когда в таблице "Список" я перехожу к строке:
		| 'В коде' | 'Задача'                             |
		| 'Да'     | 'Тестирование работы рабочего стола' |

	Тогда элемент формы с именем "СписокБлокПрограммногоКода" стал равен 
		|''|
		|'#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда'|
		|''|
		|'#Область ОбработчикиСобытий'|
		|''|
		|'&После(\"ПередЗаписью\")'|
		|'Процедура кл_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)'|
		|''|
		|'	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда'|
		|'		НеотмененныеСтрокиТовары = Товары.НайтиСтроки(Новый Структура(\"Отменено\", Ложь));'|
		|'		СуммаСНДСИтого = 0;'|
		|'		Для Каждого СтрокаТовара Из НеотмененныеСтрокиТовары Цикл'|
		|'			СуммаСНДСИтого = СуммаСНДСИтого + СтрокаТовара.СуммаСНДС;	'|
		|'		КонецЦикла;'|
		|'		Если кл_ПредоплатаНаСайте И СуммаСНДСИтого > кл_СуммаПредоплаты Тогда'|
		|'			'|
		|'			ОбщегоНазначения.СообщитьПользователю('|
		|''|
		
	Когда в таблице "Список" я нажимаю на кнопку с именем 'СписокУдалить'
	Тогда открылось окно '1С:Предприятие'
	И я нажимаю на кнопку с именем 'Button0'