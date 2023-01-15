﻿#language: ru

@tree

Функционал: Тестирование выгрузки задач в файл для Сонара

Как Разработчик я хочу
проверить корректность работы сохранения файла с актуальными задачами
чтобы эффективно выполнять код ревью

Контекст:

	Дано я подключаю TestClient "ЭтотКлиент" логин "Admin" пароль "1"
	И я закрываю все окна клиентского приложения
	
Сценарий: Подготовка данных
 	
	 И Я подготоваливаю данные справочника Конфигурации

	И Я подготоваливаю данные справочника Файлы

	И Я удаляю все существующие задачи

	И Я создаю новую задачу	"СуществующаяЗадача1" в файле "ObjectModule.bsl" для конфигурации "Тестирование" с условием поиска С начала файла и текстом "Процедура кл_ПередЗаписью(Отказ," 

	И Я создаю новую задачу	"СуществующаяЗадача2" в файле "ObjectModule.bsl" для конфигурации "Тестирование" с условием поиска С начала файла и текстом "ЗарегистрироватьЗаказКОбновлениюВMagento" 
	И Я создаю новую задачу	"СуществующаяЗадача3" в файле "ObjectModule.bsl" для конфигурации "Тестирование" с условием поиска С начала файла и текстом "Функция кл_КонтрольСтатусаСтроки(Источник, Товары, Состояни" 
	И Я создаю новую задачу	"НесуществующаяЗадача" в файле "ObjectModule.bsl" для конфигурации "Тестирование" с условием поиска С начала файла и текстом "Не существующий текст" 
	И Я создаю новую задачу	"СуществующаяЗадача4" в файле "Module.bsl" для конфигурации "Тестирование" с условием поиска С начала файла и текстом "кл_ПриСозданииНаСервереПосле(Отказ" 
	И Я создаю новую задачу	"СуществующаяЗадача5" в файле "Module.bsl" для конфигурации "Тестирование" с условием поиска С начала файла и текстом "Процедура кл_ИзменитьРеквизитыФормы()" 
	И Я создаю новую задачу	"СуществующаяЗадача6" в файле "ManagerModule.bsl" для конфигурации "Тестирование" с условием поиска С начала файла и текстом "кл_ДобавитьКомандыПечати(КомандыПечати)" 

Сценарий: Выгрузка задач в файл
	
	И Я удаляю файл результата выгрузки для сонара	
	
	И я закрываю все окна клиентского приложения
	И из выпадающего списка с именем "Конфигурация" я выбираю по строке 'Тестирование'
	И я нажимаю на кнопку с именем 'ВыгрузитьЗадачи'	
	И я жду появления файла "C:\Jenkins\CodeRewiev\Repo\Vanessa\TestConfiguration\Result.txt" в течение 10 секунд
	И файл "C:\Jenkins\CodeRewiev\Repo\Vanessa\TestConfiguration\Result.txt" содержит строки
		|"fileinfos": [|
		|{|
		|"path": "file:///C:/Jenkins/CodeRewiev/Repo/Vanessa/TestConfiguration/src/ManagerModule.bsl",|
		|"diagnostics": [|
		|{|
		|"range": {|
		|"start": {|
		|"line": 10,|
		|"character": 11|
		|},|
		|"end": {|
		|"line": 10,|
		|"character": 50|
		|}|
		|},|
		|"severity": "Error",|
		|"code": "CodeReview",|
		|"source": "CodeReview",|
		|"message": "СуществующаяЗадача6",|
		|"relatedInformation": null|
		|}|
		|]|
		|},|
		|{|
		|"path": "file:///C:/Jenkins/CodeRewiev/Repo/Vanessa/TestConfiguration/src/Module.bsl",|
		|"diagnostics": [|
		|{|
		|"range": {|
		|"start": {|
		|"line": 4,|
		|"character": 11|
		|},|
		|"end": {|
		|"line": 4,|
		|"character": 45|
		|}|
		|},|
		|"severity": "Error",|
		|"code": "CodeReview",|
		|"source": "CodeReview",|
		|"message": "СуществующаяЗадача4",|
		|"relatedInformation": null|
		|},|
		|{|
		|"range": {|
		|"start": {|
		|"line": 15,|
		|"character": 1|
		|},|
		|"end": {|
		|"line": 15,|
		|"character": 38|
		|}|
		|},|
		|"severity": "Error",|
		|"code": "CodeReview",|
		|"source": "CodeReview",|
		|"message": "СуществующаяЗадача5",|
		|"relatedInformation": null|
		|}|
		|]|
		|},|
		|{|
		|"path": "file:///C:/Jenkins/CodeRewiev/Repo/Vanessa/TestConfiguration/src/ObjectModule.bsl",|
		|"diagnostics": [|
		|{|
		|"range": {|
		|"start": {|
		|"line": 6,|
		|"character": 1|
		|},|
		|"end": {|
		|"line": 6,|
		|"character": 33|
		|}|
		|},|
		|"severity": "Error",|
		|"code": "CodeReview",|
		|"source": "CodeReview",|
		|"message": "СуществующаяЗадача1",|
		|"relatedInformation": null|
		|},|
		|{|
		|"range": {|
		|"start": {|
		|"line": 64,|
		|"character": 2|
		|},|
		|"end": {|
		|"line": 64,|
		|"character": 42|
		|}|
		|},|
		|"severity": "Error",|
		|"code": "CodeReview",|
		|"source": "CodeReview",|
		|"message": "СуществующаяЗадача2",|
		|"relatedInformation": null|
		|},|
		|{|
		|"range": {|
		|"start": {|
		|"line": 158,|
		|"character": 1|
		|},|
		|"end": {|
		|"line": 158,|
		|"character": 60|
		|}|
		|},|
		|"severity": "Error",|
		|"code": "CodeReview",|
		|"source": "CodeReview",|
		|"message": "СуществующаяЗадача3",|
		|"relatedInformation": null|
		|}|
		|]|
		|}|
		|]|
		|}|

	И файл "C:\Jenkins\CodeRewiev\Repo\Vanessa\TestConfiguration\Result.txt" не содержит строки
		|"НесуществующаяЗадача"|

Сценарий: Проверка перевода статуса задачи в Ожидает проверки	

	Когда я меняю значение переключателя с именем 'ОтборСостоянияЗадач' на 'Ожидает проверки (1)'
	Тогда таблица "Список" стала равной:
		| 'Срок, дн.' | 'Задача'               |
		| ''          | 'НесуществующаяЗадача' |

Сценарий: Автоматическая выгрузка файла
	
	И Я удаляю файл результата выгрузки для сонара

	* Проверка на несуществующий код конфигурации	
		
		И я выполняю код встроенного языка (Расширение)
			"""bsl
			РаботаСЗадачамиКлиент.АвтоматическаяГенерацияФайловЗадач("555");
			"""
		Если файл "C:\Jenkins\CodeRewiev\Repo\Vanessa\TestConfiguration\Result.txt" существует Тогда
			И я вызываю исключение с текстом сообщения "Ошибка. Сформировался файл по неизвестному коду конфигурации"

	* Проверка по реальному коду конфигурации

		И я выполняю код встроенного языка (Расширение)
			"""bsl
			РаботаСЗадачамиКлиент.АвтоматическаяГенерацияФайловЗадач("101");
			"""
		И я жду появления файла "C:\Jenkins\CodeRewiev\Repo\Vanessa\TestConfiguration\Result.txt" в течение 10 секунд

Сценарий: Выгрузка файла для сонара из формы конфигурации
	
	И Я удаляю файл результата выгрузки для сонара
	И Я открываю навигационную ссылку "e1cib/data/Справочник.Конфигурации?ref=952dcb9d08730db311ed9240abdb4b8e"
	Когда открылось окно 'Тестирование (Конфигурация)'
	И я нажимаю на кнопку с именем 'ФормаВыгрузитьЗадачи'
	И Я закрываю окно 'Тестирование (Конфигурация)'
	И я жду появления файла "C:\Jenkins\CodeRewiev\Repo\Vanessa\TestConfiguration\Result.txt" в течение 10 секунд
			