import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: CitiesPage()),
);

class City {
  const City(this.name, this.degrees);
  final String name;
  final int degrees;
}

// Уже готово: без сети, всегда успешно, результат через 500 мс.
Future<List<City>> loadCities() async {
  await Future<void>.delayed(const Duration(milliseconds: 500));
  return const [
    City('Москва', 18),
    City('Париж', 21),
    City('Лондон', 14),
    City('Санкт-Петербург', 12),
    City('Токио', 24),
    City('Петропавловск-Камчатский', 7),
  ];
}

class CitiesPage extends StatefulWidget {
  const CitiesPage({super.key});
  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  bool _grid = false;
  late Future<List<City>> _future;

  @override
  void initState() {
    super.initState();
    _future = loadCities();
  }

  void _refresh() {
    setState(() {
      _future = loadCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Города')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ToggleButtons(
                    isSelected: [!_grid, _grid],
                    onPressed: (i) => setState(() => _grid = i == 1),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Список'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Сетка'),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _refresh,
                    child: const Text('Обновить'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: FutureBuilder<List<City>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final cities = snapshot.data ?? [];
                    if (_grid) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 120,
                            ),
                        itemCount: cities.length,
                        itemBuilder: (context, i) =>
                            CityGridCard(city: cities[i]),
                      );
                    }
                    return ListView(
                      children: [
                        for (final city in cities) CityListCard(city: city),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CityListCard extends StatelessWidget {
  const CityListCard({super.key, required this.city});
  final City city;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(city.name)),
            const SizedBox(width: 8),
            Text('${city.degrees} °C'),
          ],
        ),
      ),
    );
  }
}

class CityGridCard extends StatelessWidget {
  const CityGridCard({super.key, required this.city});
  final City city;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              city.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('${city.degrees} °C'),
          ],
        ),
      ),
    );
  }
}
