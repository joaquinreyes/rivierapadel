part of 'enter_match_result.dart';

class CustomNumberInput extends ConsumerStatefulWidget {
  final Function(List<String>) onChanged;
  final int index;
  final Color color;
  final List<int?>? initialScore;
  const CustomNumberInput(
      {super.key,
      required this.onChanged,
      this.color = AppColors.green5,
      required this.index,
      this.initialScore});

  @override
  _CustomNumberInputState createState() => _CustomNumberInputState();
}

class _CustomNumberInputState extends ConsumerState<CustomNumberInput> {
  final List<TextEditingController> _controllers =
      List.generate(3, (_) => TextEditingController());
  FocusNode _focusNode(int index) {
    final nodes = ref.read(_scoreFocusNodes); // total 6 nodes
    // get based on widget.index
    return nodes[index + widget.index * 3];
  }

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      controller.addListener(_onTextChanged);
    }
    if (widget.initialScore != null) {
      for (var i = 0; i < widget.initialScore!.length; i++) {
        _controllers[i].text = widget.initialScore![i] != null
            ? widget.initialScore![i].toString()
            : '';
      }
    }
  }

  void _onTextChanged() {
    final values = _controllers.map((controller) => controller.text).toList();
    widget.onChanged(values);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        3,
        (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 4, right: 4),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNode(index),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                cursorColor: widget.color,
                maxLength: 1,
                style: AppTextStyles.panchangMedium21.copyWith(
                  color: widget.color,
                ),
                decoration: InputDecoration(
                  counterText: '', // Hide the character counter
                  contentPadding: const EdgeInsets.only(bottom: 3),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.color, width: 1),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.color, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.color, width: 1),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && ((index) + widget.index * 3) < 5) {
                    _focusNode(index + 1).requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _focusNode(index - 1).requestFocus();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
