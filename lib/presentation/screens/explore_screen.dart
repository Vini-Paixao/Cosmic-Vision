import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../app/themes/themes.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/route_constants.dart';
import '../../core/extensions/date_extensions.dart';
import '../../domain/entities/apod_entity.dart';
import '../viewmodels/explore_viewmodel.dart';
import '../widgets/cosmic_app_bar.dart';
import '../widgets/cosmic_card.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_shimmer.dart';

/// Tela Explore - Navegação por data e APODs aleatórios
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreViewModel>().loadRandomApods();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final viewModel = context.read<ExploreViewModel>();
    
    // Não carrega mais se tiver data única ou range selecionado
    if (viewModel.selectedDate != null || viewModel.hasDateRange) {
      return;
    }
    
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      viewModel.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CosmicAppBar(
        title: 'Explorar',
        showBackButton: false,
        actions: [
          // Botão de ordenação (só aparece quando não é imagem individual)
          Consumer<ExploreViewModel>(
            builder: (context, viewModel, _) {
              // Oculta se for imagem individual
              if (viewModel.selectedDate != null) {
                return const SizedBox.shrink();
              }
              
              return IconButton(
                onPressed: viewModel.toggleSortOrder,
                tooltip: viewModel.sortNewestFirst 
                    ? 'Ordenar: mais antigo primeiro' 
                    : 'Ordenar: mais recente primeiro',
                icon: Icon(
                  viewModel.sortNewestFirst
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: AppColors.stardust,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () => _showDatePicker(context),
            tooltip: 'Buscar por data',
            icon: const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.stardust,
            ),
          ),
          IconButton(
            onPressed: () => _showDateRangePicker(context),
            tooltip: 'Buscar por período',
            icon: const Icon(
              Icons.date_range_rounded,
              color: AppColors.stardust,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.galaxy,
        ),
        child: Consumer<ExploreViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              children: [
                // Chip de data selecionada
                if (viewModel.selectedDate != null)
                  _buildSelectedDateChip(viewModel),

                // Chip de período selecionado
                if (viewModel.hasDateRange)
                  _buildSelectedDateRangeChip(viewModel),

                // Lista de APODs
                Expanded(
                  child: _buildApodList(context, viewModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectedDateChip(ExploreViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.nebulaPurple.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.nebulaPurple.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: AppColors.stardust,
          ),
          const SizedBox(width: AppDimensions.sm),
          Text(
            viewModel.selectedDate!.toDisplayFormat(),
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.stardust,
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          GestureDetector(
            onTap: () {
              viewModel.clearDateSelection();
              viewModel.loadRandomApods();
            },
            child: const Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDateRangeChip(ExploreViewModel viewModel) {
    final startDate = viewModel.selectedStartDate!;
    final endDate = viewModel.selectedEndDate!;
    final daysDiff = endDate.difference(startDate).inDays + 1;
    
    // Formato curto para as datas (DD/MM)
    final startStr = '${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}';
    final endStr = '${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year}';
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.galacticTeal.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.galacticTeal.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.date_range_rounded,
            size: 16,
            color: AppColors.galacticTeal,
          ),
          const SizedBox(width: AppDimensions.sm),
          Flexible(
            child: Text(
              '$startStr - $endStr ($daysDiff dias)',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.galacticTeal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          GestureDetector(
            onTap: () {
              viewModel.clearDateRangeSelection();
              viewModel.loadRandomApods();
            },
            child: const Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApodList(BuildContext context, ExploreViewModel viewModel) {
    if (viewModel.isLoading && viewModel.apods.isEmpty) {
      return const ApodListShimmer();
    }

    if (viewModel.isError && viewModel.apods.isEmpty) {
      return ErrorView(
        message: viewModel.errorMessage ?? 'Erro ao carregar',
        onRetry: viewModel.loadRandomApods,
      );
    }

    if (viewModel.apods.isEmpty) {
      return const EmptyView(
        icon: Icons.explore_off_rounded,
        title: 'Nenhum APOD encontrado',
        message: 'Tente uma data diferente ou recarregue',
      );
    }

    // Desabilita pull-to-refresh quando há data única ou range selecionado
    final hasSelection = viewModel.selectedDate != null || viewModel.hasDateRange;
    
    final listView = ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: AppDimensions.xl),
      itemCount: viewModel.apods.length + (viewModel.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == viewModel.apods.length) {
          return _buildLoadingIndicator();
        }

        final apod = viewModel.apods[index];
        return CosmicCard(
          apod: apod,
          isFavorite: viewModel.isFavorite(apod.date),
          onTap: () => _navigateToDetail(context, apod),
          onFavoriteTap: () => viewModel.toggleFavorite(apod),
        );
      },
    );

    // Só mostra RefreshIndicator quando não há seleção de data
    if (hasSelection) {
      return listView;
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      color: AppColors.nebulaPurple,
      backgroundColor: AppColors.surfaceDark,
      child: listView,
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(AppDimensions.lg),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.nebulaPurple,
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final viewModel = context.read<ExploreViewModel>();
    final now = DateTime.now();
    final firstDate = DateTime(1995, 6, 16); // Primeiro APOD

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate ?? now,
      firstDate: firstDate,
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.nebulaPurple,
              onPrimary: AppColors.white,
              surface: AppColors.surfaceDark,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.deepSpace,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      viewModel.loadApodByDate(selectedDate);
    }
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final viewModel = context.read<ExploreViewModel>();
    final now = DateTime.now();
    
    // Valores iniciais
    final initialStart = viewModel.hasDateRange 
        ? viewModel.selectedStartDate!
        : now.subtract(const Duration(days: 7));
    final initialEnd = viewModel.hasDateRange 
        ? viewModel.selectedEndDate!
        : now;

    final result = await showDialog<DateTimeRange>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return _DateRangePickerDialog(
          initialStart: initialStart,
          initialEnd: initialEnd,
          minDate: ApiConstants.minDate,
          maxDate: now,
        );
      },
    );

    if (result != null && context.mounted) {
      // Validar limite de dias
      final daysDiff = result.end.difference(result.start).inDays + 1;
      
      if (daysDiff > ApiConstants.maxPeriodDays) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.white,
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(
                    'Período máximo é de ${ApiConstants.maxPeriodDays} dias. '
                    'Você selecionou $daysDiff dias.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.supernovaOrange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            margin: const EdgeInsets.all(AppDimensions.md),
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }

      viewModel.loadApodsByDateRange(
        startDate: result.start,
        endDate: result.end,
      );
    }
  }

  void _navigateToDetail(BuildContext context, ApodEntity apod) {
    Navigator.of(context).pushNamed(
      RouteConstants.detail,
      arguments: apod,
    );
  }
}

/// Dialog customizado para seleção de período com máscara de input
class _DateRangePickerDialog extends StatefulWidget {
  final DateTime initialStart;
  final DateTime initialEnd;
  final DateTime minDate;
  final DateTime maxDate;

  const _DateRangePickerDialog({
    required this.initialStart,
    required this.initialEnd,
    required this.minDate,
    required this.maxDate,
  });

  @override
  State<_DateRangePickerDialog> createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<_DateRangePickerDialog> {
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  late final MaskTextInputFormatter _startMask;
  late final MaskTextInputFormatter _endMask;
  
  String? _startError;
  String? _endError;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(
      text: _formatDate(widget.initialStart),
    );
    _endController = TextEditingController(
      text: _formatDate(widget.initialEnd),
    );
    _startMask = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
    _endMask = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {'#': RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  DateTime? _parseDate(String text) {
    if (text.length != 10) return null;
    try {
      final parts = text.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      if (month < 1 || month > 12) return null;
      if (day < 1 || day > 31) return null;
      if (year < 1995 || year > 2100) return null;
      
      final date = DateTime(year, month, day);
      if (date.day != day || date.month != month || date.year != year) {
        return null;
      }
      return date;
    } catch (_) {
      return null;
    }
  }

  void _openCalendar() async {
    final range = await showDateRangePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      firstDate: widget.minDate,
      lastDate: widget.maxDate,
      initialDateRange: DateTimeRange(
        start: _parseDate(_startController.text) ?? widget.initialStart,
        end: _parseDate(_endController.text) ?? widget.initialEnd,
      ),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.galacticTeal,
            surface: AppColors.surfaceDark,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (range != null && mounted) {
      setState(() {
        _startController.text = _formatDate(range.start);
        _endController.text = _formatDate(range.end);
        _startError = null;
        _endError = null;
      });
    }
  }

  void _onSubmit() {
    final startDate = _parseDate(_startController.text);
    final endDate = _parseDate(_endController.text);
    
    bool hasError = false;
    
    if (startDate == null) {
      setState(() => _startError = 'Data inválida');
      hasError = true;
    } else if (startDate.isBefore(widget.minDate)) {
      setState(() => _startError = 'Mínimo: 16/06/1995');
      hasError = true;
    } else if (startDate.isAfter(widget.maxDate)) {
      setState(() => _startError = 'Não pode ser futura');
      hasError = true;
    }
    
    if (endDate == null) {
      setState(() => _endError = 'Data inválida');
      hasError = true;
    } else if (endDate.isAfter(widget.maxDate)) {
      setState(() => _endError = 'Não pode ser futura');
      hasError = true;
    }
    
    if (!hasError && startDate != null && endDate != null) {
      if (endDate.isBefore(startDate)) {
        setState(() => _endError = 'Deve ser após início');
        hasError = true;
      }
    }
    
    if (!hasError && startDate != null && endDate != null) {
      Navigator.pop(context, DateTimeRange(start: startDate, end: endDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.deepSpace,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Período',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: _openCalendar,
            icon: const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.galacticTeal,
            ),
            tooltip: 'Abrir calendário',
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _startController,
            inputFormatters: [_startMask],
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              labelText: 'Data de início',
              hintText: 'DD/MM/AAAA',
              errorText: _startError,
              filled: true,
              fillColor: AppColors.eventHorizon,
              labelStyle: const TextStyle(color: AppColors.asteroidGray),
              hintStyle: TextStyle(color: AppColors.asteroidGray.withValues(alpha: 0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: BorderSide(color: AppColors.asteroidGray.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: const BorderSide(color: AppColors.galacticTeal),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: const BorderSide(color: AppColors.supernovaOrange),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: const BorderSide(color: AppColors.supernovaOrange),
              ),
              suffixIcon: const Icon(Icons.edit_calendar, color: AppColors.asteroidGray),
            ),
            onChanged: (_) => setState(() => _startError = null),
          ),
          const SizedBox(height: AppDimensions.md),
          TextField(
            controller: _endController,
            inputFormatters: [_endMask],
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              labelText: 'Data de término',
              hintText: 'DD/MM/AAAA',
              errorText: _endError,
              filled: true,
              fillColor: AppColors.eventHorizon,
              labelStyle: const TextStyle(color: AppColors.asteroidGray),
              hintStyle: TextStyle(color: AppColors.asteroidGray.withValues(alpha: 0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: BorderSide(color: AppColors.asteroidGray.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: const BorderSide(color: AppColors.galacticTeal),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: const BorderSide(color: AppColors.supernovaOrange),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: const BorderSide(color: AppColors.supernovaOrange),
              ),
              suffixIcon: const Icon(Icons.edit_calendar, color: AppColors.asteroidGray),
            ),
            onChanged: (_) => setState(() => _endError = null),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: AppColors.asteroidGray),
          ),
        ),
        TextButton(
          onPressed: _onSubmit,
          child: const Text(
            'Buscar',
            style: TextStyle(color: AppColors.galacticTeal),
          ),
        ),
      ],
    );
  }
}
