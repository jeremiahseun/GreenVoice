import 'package:fluttertoast/fluttertoast.dart';
import 'package:greenvoice/utils/constants/exports.dart';

class CustomToast {
  showCustomToast(
      {required String message,
      required bool isError,
      required BuildContext context}) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
            width: 2,
            color: isError ? AppColors.redColor : AppColors.primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: isError ? AppColors.toastBackground : AppColors.primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          isError
              ? const Icon(
                  Icons.close_rounded,
                  color: AppColors.redColor,
                )
              : const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryColor,
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message,
                style: AppStyles.blackBold16
                    .copyWith(color: AppColors.whiteColor)),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 2),
      gravity: ToastGravity.TOP,
    );
  }
}
