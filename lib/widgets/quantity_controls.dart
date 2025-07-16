import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class QuantityControls extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final bool compact;

  const QuantityControls({
    Key? key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppTheme.primaryColor.withOpacity(0.08),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8, 
        vertical: compact ? 2 : 4
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildControlButton(
            onTap: quantity > 1 ? onDecrease : onRemove,
            backgroundColor: quantity > 1 
                ? AppTheme.primaryColor 
                : AppTheme.errorColor,
            icon: quantity > 1 
                ? Icons.remove 
                : Icons.delete_outline,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
            child: Text(
              '$quantity',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: compact ? 14 : 16,
              ),
            ),
          ),
          _buildControlButton(
            onTap: onIncrease,
            backgroundColor: AppTheme.primaryColor,
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onTap,
    required Color backgroundColor,
    required IconData icon,
  }) {
    final double size = compact ? 24 : 28;
    final double iconSize = compact ? 14 : 16;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        width: size,
        height: size,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
