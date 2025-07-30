import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/tasa_credito_model.dart';
import '../services/tasas_credito_service.dart';
import './main_layout.dart';
import '../widgets/tasa_credito_card.dart';

class TasasCreditoScreen extends StatefulWidget {
  const TasasCreditoScreen({super.key});

  @override
  _TasasCreditoScreenState createState() => _TasasCreditoScreenState();
}

class _TasasCreditoScreenState extends State<TasasCreditoScreen>
    with SingleTickerProviderStateMixin {
  final TasasCreditoService _service = TasasCreditoService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<TasaCredito> _tasas = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _selectedTipoTarjeta;
  Timer? _debounce;
  String? _errorMessage;
  String? _searchQuery;
  late AnimationController _hideHeaderController;
  bool _isHeaderVisible = true;

  final Map<String, String> _entidadesSugeridas = {
    'Reservas': 'banreservas', // Display 'Reservas', send 'banreservas'
    'Popular': 'Popular',
    'BHD': 'BHD',
    'Scotiabank': 'Scotiabank',
    'Caribe': 'Caribe',
    'APAP': 'APAP',
    'Promerica': 'Promerica'
  };

  @override
  void initState() {
    super.initState();
    developer.log('Inicializando pantalla de Tasas de Crédito');
    _hideHeaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..forward(); // Start with header visible
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    _hideHeaderController.dispose();
    _service.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    developer.log('Cargando datos iniciales...');
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _tasas = [];
      _hasMore = true;
      _errorMessage = null;
    });
    await _fetchData();
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;
    developer.log('Cargando más datos...');
    setState(() {
      _isLoading = true;
      _currentPage++;
    });
    await _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await _service.getTasasCredito(
        page: _currentPage,
        tipoTarjeta: _selectedTipoTarjeta,
        entidad: _searchQuery,
      );
      setState(() {
        _tasas.addAll(response.items);
        _hasMore = _currentPage < response.totalPaginas;
        _isLoading = false;
        if (_tasas.isEmpty && !_hasMore) {
          _errorMessage = 'No se encontraron resultados.';
        }
      });
    } catch (e) {
      developer.log('Error al cargar tasas: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchQuery != query) {
        setState(() {
          _searchQuery = query.isNotEmpty ? query : null;
        });
        _loadInitialData();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading) {
      _loadMoreData();
    }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isHeaderVisible) {
        _isHeaderVisible = false;
        _hideHeaderController.reverse();
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isHeaderVisible) {
        _isHeaderVisible = true;
        _hideHeaderController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasas de Crédito'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterDialog,
            ),
          ],
        ),
        body: Column(
          children: [
            _buildHeader(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizeTransition(
      sizeFactor: _hideHeaderController,
      axisAlignment: -1.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar entidad...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          _buildSugerenciasChips(),
          if (_selectedTipoTarjeta != null && (_searchQuery == null || _searchQuery!.isEmpty))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text('Filtro: ${_getTipoEntidadName(_selectedTipoTarjeta)}'),
                  onDeleted: () {
                    setState(() => _selectedTipoTarjeta = null);
                    _loadInitialData();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _tasas.isEmpty) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: _loadInitialData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_tasas.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('No se encontraron resultados.', style: TextStyle(fontSize: 16)),
        ),
      );
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: _loadInitialData,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _tasas.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _tasas.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return TasaCreditoCard(tasa: _tasas[index]);
          },
        ),
      ),
    );
  }

  String _getTipoEntidadName(String? code) {
    switch (code) {
      case 'BM':
        return 'Bancos Múltiples';
      case 'AC':
        return 'Asociaciones de Ahorros y Préstamos';
      case 'EMC':
        return 'Emisores de Tarjetas de Crédito';
      default:
        return '';
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar por Tipo de Entidad'),
          content: DropdownButton<String>(
            value: _selectedTipoTarjeta,
            hint: const Text('Seleccione un tipo'),
            isExpanded: true,
            items: <String>['BM', 'AC', 'EMC']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(_getTipoEntidadName(value)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedTipoTarjeta = newValue;
              });
              Navigator.of(context).pop();
              _loadInitialData();
            },
          ),
        );
      },
    );
  }

  Widget _buildSugerenciasChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: _entidadesSugeridas.entries.map((entry) {
          final displayName = entry.key;
          final apiName = entry.value;
          final isSelected = _searchQuery == apiName;

          return ChoiceChip(
            label: Text(displayName),
            selected: isSelected,
            onSelected: (selected) {
              final newQuery = selected ? apiName : '';
              _searchController.text = newQuery;
              _onSearchChanged(newQuery);
            },
            selectedColor: Theme.of(context).colorScheme.primary,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            backgroundColor: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!,
              ),
            ),
            showCheckmark: false,
          );
        }).toList(),
      ),
    );
  }
}
