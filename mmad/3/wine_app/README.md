# Wine app

Python 3.13.

```bash
pip install -r requirements.txt
streamlit run app.py
```

Файлы: `model.joblib` (StandardScaler + LogisticRegression), `config.json` (порог), `test.csv` (тестовая выборка).

## Кэширование

`st.cache_resource` хранит один объект модели на весь сервер и возвращает его без копирования. `st.cache_data` сериализует результат и каждый раз отдает копию, это подходит для таблиц, но не для модели.

Без декоратора `joblib.load` будет читать модель с диска при каждом действии пользователя, так как скрипт перезапускается целиком.
