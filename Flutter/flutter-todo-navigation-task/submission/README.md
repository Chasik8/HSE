# Результат

Web версия в браузере на ПК, запуск `flutter run -d chrome`, окно 1280 на 720.

## Видео

Добавление, пустой ввод, Back из формы, свайп, отмена, закрытие диалога, удаление.

![demo](demo.gif)

Тот же ролик в mp4: [demo.mp4](demo.mp4)

## Скриншоты

Список

![list](list.png)

Пустой ввод

![empty](empty_error.png)

Добавление

![add](add.png)

Свайп

![swipe](swipe.png)

Подтверждение

![dialog](delete_dialog.png)

После удаления

![after](after_delete.png)

## Проверки

Полный вывод в [checks.txt](checks.txt).

```
flutter analyze
No issues found!

flutter test test/package_check.dart test/behavior_check.dart
All tests passed! (15)
```
