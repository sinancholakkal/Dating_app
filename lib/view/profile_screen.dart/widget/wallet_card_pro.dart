import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dating_app/utils/app_color.dart';

class WalletCardPro extends StatefulWidget {
  final int coins;
  final VoidCallback onWatchAd;
  final VoidCallback? onManage;

  const WalletCardPro({super.key, required this.coins, required this.onWatchAd, this.onManage});

  @override
  State<WalletCardPro> createState() => _WalletCardProState();
}

class _WalletCardProState extends State<WalletCardPro> {
  @override
  void didUpdateWidget(WalletCardPro oldWidget) {
    super.didUpdateWidget(oldWidget);
    // No need to manage state here since parent handles it with ValueNotifier
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF52A0FD), Color(0xFF00C6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative soft shapes
          Positioned(
            top: -30,
            right: -20,
            child: _blob(100, Colors.white.withOpacity(0.15)),
          ),
          Positioned(
            bottom: -40,
            left: -10,
            child: _blob(120, Colors.white.withOpacity(0.10)),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current balance',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
                Text(
                  ' ${widget.coins.toString()} Coins'.replaceFirst('\u0000', ''),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    '5638   ****   ****   3729',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const Spacer(),
                  _WatchAdSwitch(
                    onPressed: widget.onWatchAd,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _blob(double size, Color color) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );
}

class _WatchAdSwitch extends StatelessWidget {
  final VoidCallback onPressed;
  const _WatchAdSwitch({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.play_circle_fill, color: primary, size: 18),
            const SizedBox(width: 6),
            Text(
              '+5',
              style: GoogleFonts.poppins(
                color: textDark,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
