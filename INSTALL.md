Зависимости
-----------

* linux 64bit (git, make, wget)
* [Docker](http://docker.io)
* [fidm](https://github.com/LeKovr/fidm)
* [ConSup](https://github.com/LeKovr/consup) (установка по инструкции ниже)

Установка производится на хост с 64bit linux (64bit - это требование docker).
Git будет установлен вместе с docker, единственная зависимость, которую надо поставить вручную - make.


### Установка make

При установке пакета **make** потребуется пароль для sudo.

```
which make > /dev/null || sudo apt-get install make
```

### Установка **docker**, **fidm**, **consup**

При установке **docker** и **fidm** потребуется пароль для sudo.

Все зависимости установятси при выполнении этой команды, при этом docker будет установлен согласно [инструкции](http://docs.docker.com/linux/step_one/). Если такой вариант не подходит, надо предварительно поставить docker вручную.
```
make deps
```

Для того, чтобы текущий пользователь мог работать с docker, его надо добавить в группу docker:
```
sudo usermod -a -G docker $USER
```
