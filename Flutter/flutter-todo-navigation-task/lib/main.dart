import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: TodoPage()),
);

class TodoItem {
  const TodoItem(this.id, this.title);
  final int id;
  final String title;
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final todos = [
    const TodoItem(1, 'Повторить Navigator'),
    const TodoItem(2, 'Подготовить презентацию'),
  ];
  int nextId = 3;

  Future<void> openAddPage() async {
    final title = await Navigator.push(
      context,
      MaterialPageRoute<String>(builder: (_) => const AddTodoPage()),
    );
    if (!mounted || title == null) return;
    setState(() => todos.add(TodoItem(nextId++, title)));
  }

  Future<void> deleteTodo(TodoItem todo) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить задачу?'),
        content: Text(todo.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (!mounted || ok != true) return;
    setState(() => todos.removeWhere((t) => t.id == todo.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Задачи')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddPage,
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
      body: todos.isEmpty
          ? const Center(child: Text('Пока нет задач'))
          : ListView(
              // место под кнопку снизу
              padding: const EdgeInsets.only(bottom: 88),
              children: [
                for (final todo in todos)
                  Slidable(
                    key: ValueKey(todo.id),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) => deleteTodo(todo),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Удалить',
                        ),
                      ],
                    ),
                    child: ListTile(title: Text(todo.title)),
                  ),
              ],
            ),
    );
  }
}

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final controller = TextEditingController();
  String? errorText;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void save() {
    final title = controller.text.trim();
    if (title.isEmpty) {
      setState(() => errorText = 'Введите название');
      return;
    }
    Navigator.pop(context, title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новая задача')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Название',
              errorText: errorText,
            ),
            onSubmitted: (_) => save(),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: save, child: const Text('Сохранить')),
        ],
      ),
    );
  }
}
