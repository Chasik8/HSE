import json
from pathlib import Path

import joblib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import streamlit as st
from sklearn import metrics

APP_DIR = Path(__file__).parent
FEATURES = ['fixed_acidity', 'volatile_acidity', 'citric_acid', 'residual_sugar',
            'chlorides', 'free_sulfur_dioxide', 'total_sulfur_dioxide', 'density',
            'pH', 'sulphates', 'alcohol', 'is_red']


@st.cache_resource
def load_model():
    return joblib.load(APP_DIR / 'model.joblib')


@st.cache_data
def load_config():
    return json.loads((APP_DIR / 'config.json').read_text())


@st.cache_data
def load_test():
    return pd.read_csv(APP_DIR / 'test.csv')


@st.cache_data
def test_proba(_model, X):
    return _model.predict_proba(X)[:, 1]


model = load_model()
config = load_config()
test = load_test()
X_test, y_test = test[FEATURES], test['target'].to_numpy()
p_test = test_proba(model, X_test)

st.title('Отбор хороших вин')

with st.sidebar:
    threshold = st.slider('Порог', 0.0, 1.0, float(config['threshold']), 0.01)

tab_one, tab_metrics, tab_batch, tab_coef = st.tabs(
    ['Оценка одного вина', 'Модельные метрики', 'Пакетное предсказание', 'Что выучила модель'])

# 4.1
with tab_one:
    values = {'is_red': int(st.toggle('Красное вино'))}
    for f in FEATURES[:-1]:
        lo, hi, med = float(test[f].min()), float(test[f].max()), float(test[f].median())
        values[f] = st.number_input(f, min_value=lo, max_value=hi, value=med, format='%.5g')
    p = model.predict_proba(pd.DataFrame([values])[FEATURES])[0, 1]
    st.metric('Вероятность, что вино хорошее', f'{p:.3f}')
    st.write('Решение:', 'хорошее, в подборку' if p >= threshold else 'не хорошее, не берем')

# 4.2
with tab_metrics:
    pred = (p_test >= threshold).astype(int)
    tn, fp, fn, tp = metrics.confusion_matrix(y_test, pred, labels=[0, 1]).ravel()
    precision = tp / (tp + fp) if tp + fp else 0.0
    recall = tp / (tp + fn)
    f1 = 2 * tp / (2 * tp + fp + fn)
    fpr_t = fp / (fp + tn)

    c1, c2, c3 = st.columns(3)
    c1.metric('Precision', f'{precision:.3f}')
    c2.metric('Recall', f'{recall:.3f}')
    c3.metric('F1', f'{f1:.3f}')

    fig, axes = plt.subplots(1, 3, figsize=(15, 4.5))
    metrics.ConfusionMatrixDisplay(np.array([[tn, fp], [fn, tp]])).plot(
        ax=axes[0], cmap='Blues', colorbar=False)
    axes[0].set_title('Матрица ошибок')

    fpr, tpr, _ = metrics.roc_curve(y_test, p_test)
    axes[1].plot(fpr, tpr)
    axes[1].plot([0, 1], [0, 1], 'k--')
    axes[1].scatter(fpr_t, recall, color='red', zorder=5)
    axes[1].set(xlabel='FPR', ylabel='TPR', title='ROC-кривая')

    prec_c, rec_c, _ = metrics.precision_recall_curve(y_test, p_test)
    axes[2].plot(rec_c, prec_c)
    axes[2].scatter(recall, precision, color='red', zorder=5)
    axes[2].set(xlabel='Recall', ylabel='Precision', title='PR-кривая')
    st.pyplot(fig)
    plt.close(fig)

    st.write('Если порог увеличить, в подборку попадет меньше вин, но среди них будет больше хороших '
             '(precision растет, recall падает). Если порог уменьшить, подборка станет шире, но в нее '
             'попадет больше посредственных вин (recall растет, precision падает).')

# 4.3
with tab_batch:
    uploaded = st.file_uploader('CSV с признаками вин', type='csv')
    if uploaded is not None:
        try:
            batch = pd.read_csv(uploaded)
        except Exception as e:
            st.error(f'Не удалось прочитать файл: {e}')
            st.stop()
        missing = [f for f in FEATURES if f not in batch.columns]
        if missing:
            st.error('Не хватает столбцов: ' + ', '.join(missing))
        else:
            try:
                batch['proba'] = model.predict_proba(batch[FEATURES])[:, 1]
            except Exception as e:
                st.error(f'Некорректные значения в файле: {e}')
                st.stop()
            batch['decision'] = (batch['proba'] >= threshold).astype(int)
            st.dataframe(batch)
            st.download_button('Скачать', batch.to_csv(index=False), file_name='predictions.csv',
                               mime='text/csv')

# 4.4
with tab_coef:
    coefs = pd.Series(model[-1].coef_.ravel(), index=FEATURES).sort_values()
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.barh(coefs.index, coefs.values, color=['red' if v < 0 else 'green' for v in coefs.values])
    ax.set_xlabel('Коэффициент')
    st.pyplot(fig)
    plt.close(fig)
    st.write('За хорошее вино: ' + ', '.join(coefs[coefs > 0].sort_values(ascending=False).index[:3]))
    st.write('Против: ' + ', '.join(coefs[coefs < 0].index[:3]))
