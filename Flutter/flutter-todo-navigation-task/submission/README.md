# Результат

Web версия, запуск `flutter run -d chrome`, окно 360 на 640.

## Видео

Добавление, пустой ввод, Back из формы, свайп, отмена, закрытие диалога, удаление.

![demo](demo.gif)

Тот же ролик в mp4: [demo.mp4](demo.mp4)

## Скриншоты

| Список | Добавление | Пустой ввод |
|---|---|---|
| <img src="list.png" width="240"> | <img src="add.png" width="240"> | <img src="empty_error.png" width="240"> |

| Свайп | Подтверждение | После удаления |
|---|---|---|
| <img src="swipe.png" width="240"> | <img src="delete_dialog.png" width="240"> | <img src="after_delete.png" width="240"> |

## Проверки

Полный вывод в [checks.txt](checks.txt).

```
flutter analyze
No issues found!

flutter test test/package_check.dart test/behavior_check.dart
All tests passed! (15)
```
