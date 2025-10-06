import 'package:dating_app/state/coins_bloc/coins_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dating_app/utils/app_color.dart';

class WalletCardPro extends StatefulWidget {
  final int coins;
  final VoidCallback onWatchAd;
  final VoidCallback? onManage;
  final bool isLoading;
  final bool isAdLoading;

  const WalletCardPro({
    super.key,
    required this.coins,
    required this.onWatchAd,
    this.onManage,
    this.isLoading = false,
    this.isAdLoading = false,
  });

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
          // Loading overlay
          BlocBuilder<CoinsBloc, CoinsState>(
            builder: (context, state) {
              if (state is GetCurrentUserCoinsLoadingState) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Loading wallet...',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
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
              BlocBuilder<CoinsBloc, CoinsState>(
                builder: (context, state) {
                  if(state is GetCurrentUserCoinsSuccessState){
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        key: ValueKey('coins-${state.coins}'),
                        ' ${state.coins.toString()} Coins'.replaceFirst('\u0000', ''),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                        ),
                      ),
                    );
                  } else if(state is GetCurrentUserCoinsLoadingState){
                    return Container(
                      height: 26,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    );
                  } else if(state is GetCurrentUserCoinsErrorState){
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Error loading coins',
                        style: GoogleFonts.poppins(
                          color: Colors.red.shade200,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      key: ValueKey('coins-${widget.coins}'),
                      ' ${widget.coins.toString()} Coins'.replaceFirst('\u0000', ''),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                      ),
                    ),
                  );
                },
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
                  BlocBuilder<CoinsBloc, CoinsState>(
                    builder: (context, state) {
                      return _WatchAdSwitch(
                        onPressed: state is AddCoinsLoadingState ? null : widget.onWatchAd,
                        isLoading: state is AddCoinsLoadingState,
                      );
                    },
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
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _WatchAdSwitch extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  const _WatchAdSwitch({required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isLoading ? Colors.white.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isLoading ? 0.1 : 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
              )
            else
              Icon(Icons.play_circle_fill, color: primary, size: 18),
            const SizedBox(width: 6),
            Text(
              isLoading ? 'Adding...' : '+5',
              style: GoogleFonts.poppins(
                color: isLoading ? textDark.withOpacity(0.7) : textDark,
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
