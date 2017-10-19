# Проект подготовки документации.

В данном проекте собрано окружение, позволяющее на основе исходников Markdown сформировать и запустить вебсайт с документацией.

* Вебсайт генерится с помощью [GitBook](https://www.gitbook.com/)
* Управление сборкой и вебсайтом производится в контейнерах [Docker](http://docker.io)

Исходные тексты документации размещаются в каталоге `src/`.

## Установка

См. [INSTALL.md](INSTALL.md)

### Настройка для dcape

Создаем файл настроек .env
```
make .env
```

В файле .env хранятся индивидуальные настройки каждой копии сайта. В т.ч. переменные

* **APP_SITE** - имя хоста проекта (doc.dev.lan)

Создание файла с указанием настроек:
```
APP_SITE=test.dev.lan make .env
```

Если хост **APP_SITE** не прописан в DNS, его надо указать в hosts:
```
sudo -c 'echo "127.0.0.1 doc.dev.lan" >> /etc/hosts'
```

## Сборка проекта

* `make book-html` - генерация html
* `make book-pdf` - генерация pdf
* `make book-epub` - генерация epub
* `make book-all` - генерация html, pdf, epub
* `make book-serve` - запуск вебсервера http://localhost:4000 с горячим обновлением контента
* `make start` - book-all и запуск вебсервера в среде dcape

## Кастомизация

Исходники шаблонов страниц [тут](https://github.com/GitbookIO/theme-default)
Если надо переопределить блок - см [Extend instead of Forking](https://toolchain.gitbook.com/themes/),
если заменить весь шаблон - скачать его в src/_layouts/ и редактировать.

## Документация по Gitbook

* [Общая структура](https://toolchain.gitbook.com/structure.html)
* [Шаблоны](https://toolchain.gitbook.com/themes/)
* [Стили](https://starlying.gitbooks.io/gitbook-1/content/styling/book.html)
* [LESS](https://plugins.gitbook.com/plugin/styles-less)

License
-------

This project is under the **MIT** License. See the [LICENSE](LICENSE) file for the full license text.

Copyright (c) 2017 [Tender.Pro](http://www.tender.pro)
