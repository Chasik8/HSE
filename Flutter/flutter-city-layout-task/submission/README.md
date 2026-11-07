# Результат

Web версия в браузере на ПК, запуск `flutter run -d chrome`, окно 1280 на 720.

## Видео

Первая загрузка, список и сетка, «Обновить» с индикатором, смена режима во время ожидания.

![demo](demo.gif)

Тот же ролик в mp4: [demo.mp4](demo.mp4)

## Скриншоты

Список

![list](list.png)

Сетка

![grid](grid.png)

Ожидание при первом запуске

![first](first_waiting.png)

Ожидание после «Обновить»

![waiting](waiting.png)

Смена режима во время ожидания

![switch](waiting_switch.png)

Данные после ожидания в последнем выбранном виде

![after](after_refresh.png)

Окно высотой 480, прокрутка до последнего города

![list480](list_480.png)

![grid480](grid_480.png)

## Проверки

Полный вывод в [checks.txt](checks.txt).

```
flutter analyze
No issues found!

flutter test
All tests passed! (1)

flutter test test/behavior_check.dart
All tests passed! (8)
```
