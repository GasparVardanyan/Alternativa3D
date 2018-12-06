Настройка программного обеспечения для работы с AlternativaGUI. Подключение библиотеки в наиболее популярных средах разработки.

==FlashDevelop 4==
1. Скачать с официального сайта и установить FlashDevelop 4
2. Запустить FlashDevelop 4. Перед вами стартовое окно программы
3. Создать новый AS3 Project
4. Скачать библиотеку "AlternativaGUI" и поместить файл AlternativaGUI.swc в папку lib вашего проекта
5. В проводнике проекта файлу lib/AlternativaGUI.swc указать "Add To Library" 

==Adobe Flash Builder 4.5==
1. Скачать с и установить Adobe Flash Builder 4.5
2. Скачать библиотеку "AlternativaGUI" и поместить файл AlternativaGUI.swc в удобную для вас папку
3. Запустить Adobe Flash Builder 4.5. Перед вами стартовое окно программы
4. Создать новый ActionScript Project:
  4.1. File -> New ActionScript Project
  4.2. Указать имя и путь к проекту -> Next
  4.3. Library Path -> Add SWC -> Указать путь к AlternativaGUI.swc -> Finish

==IntelliJ IDEA 10.5==
1. Скачать с официального сайта и установить IntelliJ IDEA 10.5
2. Скачать библиотеку "AlternativaGUI" и поместить файл AlternativaGUI.swc в удобную для вас папку
3. Запустить IntelliJ IDEA 10.5. Перед вами стартовое окно программы
4. Создать новый проект:
  4.1. File -> New Project
  4.2. Create project from scratch -> Указать имя и путь к проекту, тип модуля. Создать ActionScript модуль -> Next -> Next
  4.3. Убрать галочки Create sample Flex application, Create HTML wrapper -> Finish
5. File -> Project Structure -> Libraries -> ActionScript / Flex -> OK -> Add SWC Files -> Указать путь к библиотеке AlternativaGUI.swc -> OK

Поскольку библиотека AlternativaGUI разработана для flash не забывайте установить последнюю версию Adobe Flash Player.


==Подключение шрифтов для AlternativaGUI Default Theme:==
1) для работы библиотеки, необходимы шрифты двух типов: otf и ttf.
2) в классе Fonts, надо прописать путь к шрифтам.